#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_bg_format.py — controle du format des fonds de cinematique.

POURQUOI CET OUTIL
------------------
Le viewport PMDO fait 320x240. Un fond affiche via UI:WaitShowBG doit avoir
des FRAMES de 320x240 pour couvrir l'ecran sans bande noire ni etirement.

Le piege : la taille du PNG contenu dans un .dir n'est PAS la taille de la
frame. Les .dir sont des planches (spritesheets). Exemple mesure :

    Dream_Back.dir   PNG 1536x1920   frames 192x240   63 frames

Choisir un fond sur son nom sans verifier ses dimensions produit donc un bug
visuel silencieux : rien ne casse, mais l'image est mal cadree a l'ecran.

FORMAT DU .dir (retro-ingenierie, verifiee sur les 16 fichiers du depot)
------------------------------------------------------------------------
    [ PNG complet ] [ 16 octets de metadonnees ]

Les 16 derniers octets sont 4 uint32 little-endian :
    frameWidth, frameHeight, 0, frameCount

USAGE
-----
    python3 tools/verify_bg_format.py .

Sortie : la liste des fonds, leur taille de frame, et un ECHEC pour tout
fond utilise en plein ecran dans un script alors que sa frame != 320x240.
"""
import glob
import os
import re
import struct
import sys

VIEWPORT = (320, 240)


def read_bg(path):
    """Renvoie (pngW, pngH, frameW, frameH, frameCount) ou None."""
    data = open(path, 'rb').read()
    i = data.find(b'\x89PNG\r\n\x1a\n')
    if i < 0:
        return None
    png_w, png_h = struct.unpack('>II', data[i + 16:i + 24])
    tail = data[data.rfind(b'IEND') + 8:]
    if len(tail) < 16:
        return None
    fw, fh, _unused, count = struct.unpack('<4I', tail[:16])
    return png_w, png_h, fw, fh, count


def main(root):
    bg_dir = os.path.join(root, 'Content', 'BG')
    if not os.path.isdir(bg_dir):
        print('Content/BG introuvable sous %s' % root)
        return 1

    catalogue = {}
    print('%-28s %-13s %-11s %-7s %s' % ('fond', 'planche', 'frame', 'frames', 'plein ecran'))
    print('-' * 78)
    for f in sorted(glob.glob(os.path.join(bg_dir, '*.dir'))):
        name = os.path.basename(f)[:-4]
        info = read_bg(f)
        if info is None:
            print('%-28s <illisible>' % name)
            continue
        pw, ph, fw, fh, n = info
        catalogue[name] = (fw, fh, n)
        full = (fw, fh) == VIEWPORT
        print('%-28s %5dx%-6d %4dx%-5d %-7d %s'
              % (name, pw, ph, fw, fh, n, 'oui' if full else 'NON'))

    # Quels fonds sont reellement utilises en plein ecran par les scripts ?
    used = {}
    pattern_bg = re.compile(r"bg='([^']+)'")
    pattern_show = re.compile(r'WaitShowBG\(\s*"([^"]+)"')
    for lua in glob.glob(os.path.join(root, 'Data/Script/**/*.lua'), recursive=True):
        src = open(lua, encoding='utf-8').read()
        # ignorer les commentaires en bloc et en ligne
        src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
        src = '\n'.join(l.split('--')[0] for l in src.split('\n'))
        for m in list(pattern_bg.finditer(src)) + list(pattern_show.finditer(src)):
            used.setdefault(m.group(1), set()).add(os.path.relpath(lua, root))

    print()
    failures = []
    for name in sorted(used):
        if name not in catalogue:
            failures.append((name, 'fond INTROUVABLE dans Content/BG', used[name]))
            continue
        fw, fh, _n = catalogue[name]
        if (fw, fh) != VIEWPORT:
            failures.append((name, 'frame %dx%d != 320x240' % (fw, fh), used[name]))

    if failures:
        print('ECHECS :')
        for name, why, files in failures:
            print('  %-22s %s' % (name, why))
            for f in sorted(files):
                print('      utilise par %s' % f)
        print()
        print('RESULTAT : %d fond(s) mal dimensionne(s)' % len(failures))
        return 1

    print('%d fond(s) utilise(s) par les scripts, tous en frame 320x240.'
          % len(used))
    print('RESULTAT : AUCUN BUG DE FORMAT')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else '.'))
