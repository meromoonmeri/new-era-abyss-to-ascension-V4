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
    [ uint32 taillePNG ] [ uint32 0 ] [ PNG complet ] [ 16 octets ]

Les 16 derniers octets sont 4 uint32 little-endian :
    frameWidth, frameHeight, LocHeight, frameCount

L'EN-TETE DE 8 OCTETS EST OBLIGATOIRE — leçon payee en jeu
-----------------------------------------------------------
RogueEssence.Content.DirSheet.Load lit d'abord un uint32 de longueur, puis
copie ce nombre d'octets. Cinq fonds du depot (les Genesis_*) etaient de
simples PNG BRUTS renommes en .dir, avec le pied de 16 octets colle mais
SANS cet en-tete. Le moteur lisait donc les 8 premiers octets de la
signature PNG (89 50 4E 47 / 0D 0A 1A 0A) comme une longueur de
1 196 314 761 octets, et plantait :

    System.ArgumentOutOfRangeException: Offset and length were out of
    bounds for the array (Parameter 'count')
       at RogueEssence.Content.DirSheet.Load(BinaryReader reader)

Et cet outil les declarait CONFORMES, parce qu'il cherchait la signature
PNG n'importe ou dans le fichier (data.find) au lieu de l'exiger a
l'offset 8. Il verifiait le cadrage sans jamais verifier que le fichier
etait seulement LISIBLE. C'est corrige : read_bg valide desormais la
structure complete, en simulant ce que fait le moteur.

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


PNG_SIG = b'\x89PNG\r\n\x1a\n'


def read_bg(path):
    """Renvoie (pngW, pngH, frameW, frameH, frameCount) ou une chaine d'erreur.

    Simule DirSheet.Load : on NE cherche PAS la signature PNG, on l'EXIGE
    a l'offset 8, apres l'en-tete de longueur. C'est la seule facon de
    detecter un fichier que le moteur refusera de charger.
    """
    data = open(path, 'rb').read()
    if len(data) < 24:
        return 'fichier tronque (%d octets)' % len(data)

    png_len, pad = struct.unpack('<II', data[:8])

    # Le symptome exact du bug des Genesis_* : un PNG brut renomme .dir.
    if data[:8] == PNG_SIG:
        return ('PNG BRUT sans en-tete .dir — le moteur lira une longueur '
                'de %d octets et plantera' % png_len)

    if data[8:16] != PNG_SIG:
        return 'pas de signature PNG a l offset 8 (en-tete corrompu)'

    end = 8 + png_len
    if end + 16 > len(data):
        return ('taillePNG=%d incoherente : il faudrait %d octets, le '
                'fichier en fait %d' % (png_len, end + 16, len(data)))

    png_w, png_h = struct.unpack('>II', data[24:32])
    fw, fh, _loc, count = struct.unpack('<4I', data[end:end + 16])

    # PAS de controle sur les octets qui SUIVENT le pied de page.
    # Faux positif mesure : SE5_Wind_Background.dir annonce png_len=10757
    # alors que son PNG s'arrete a 15101 (IEND+8), et porte 4336 octets de
    # rembourrage apres le pied. Le moteur s'en moque — il lit png_len puis
    # les 16 octets suivants, et n'ouvre jamais la suite. Ce fond est
    # utilise en jeu par ChapterScenes.lua et fonctionne. Interdire le
    # rembourrage ferait crier l'outil sur du contenu sain.
    if fw == 0 or fh == 0:
        return 'taille de frame nulle (%dx%d)' % (fw, fh)

    return png_w, png_h, fw, fh, count


def main(root):
    bg_dir = os.path.join(root, 'Content', 'BG')
    if not os.path.isdir(bg_dir):
        print('Content/BG introuvable sous %s' % root)
        return 1

    catalogue = {}
    broken = []
    print('%-28s %-13s %-11s %-7s %s' % ('fond', 'planche', 'frame', 'frames', 'plein ecran'))
    print('-' * 78)
    for f in sorted(glob.glob(os.path.join(bg_dir, '*.dir'))):
        name = os.path.basename(f)[:-4]
        info = read_bg(f)
        # Un .dir illisible est un CRASH en jeu, pas une ligne a ignorer.
        if info is None or isinstance(info, str):
            why = info if isinstance(info, str) else 'illisible'
            print('%-28s *** %s' % (name, why))
            broken.append((name, why))
            continue
        pw, ph, fw, fh, n = info
        catalogue[name] = (fw, fh, n)
        full = (fw, fh) == VIEWPORT
        print('%-28s %5dx%-6d %4dx%-5d %-7d %s'
              % (name, pw, ph, fw, fh, n, 'oui' if full else 'NON'))

    # Deux usages DISTINCTS, avec deux contraintes differentes :
    #
    #   PLEIN ECRAN  (WaitShowBG, bg='...')  -> la frame DOIT faire 320x240,
    #                sinon bande noire ou etirement.
    #
    #   OVERLAY      (BossFX.Overlay, FiniteOverlayEmitter) -> la frame peut
    #                avoir n'importe quelle taille : l'emetteur repete la
    #                tuile (RepeatX/RepeatY) et la fait defiler. C'est le cas
    #                de Dream_Back/Front (parallaxe) et SE5_Wind_Background
    #                (bandeau de vent). Les signaler serait un faux positif.
    used = {}     # plein ecran : contrainte 320x240
    overlay = {}  # tuiles defilantes : aucune contrainte de taille
    pattern_bg = re.compile(r"bg='([^']+)'")
    pattern_show = re.compile(r'WaitShowBG\(\s*"([^"]+)"')
    pattern_ovl = re.compile(r"BossFX\.Overlay\(\s*'([^']+)'")
    for lua in glob.glob(os.path.join(root, 'Data/Script/**/*.lua'), recursive=True):
        src = open(lua, encoding='utf-8').read()
        # ignorer les commentaires en bloc et en ligne
        src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
        src = '\n'.join(l.split('--')[0] for l in src.split('\n'))
        rel = os.path.relpath(lua, root)
        for m in list(pattern_bg.finditer(src)) + list(pattern_show.finditer(src)):
            used.setdefault(m.group(1), set()).add(rel)
        for m in pattern_ovl.finditer(src):
            overlay.setdefault(m.group(1), set()).add(rel)

    print()
    failures = []
    # Un fichier que le moteur ne peut pas charger est l'echec le plus grave :
    # il ne produit pas un defaut de cadrage, il jette une exception et coupe
    # la cinematique. On le remonte AVANT les problemes de dimensions.
    for name, why in broken:
        users = used.get(name, set()) | overlay.get(name, set())
        failures.append((name, 'ILLISIBLE PAR LE MOTEUR — ' + why, users))
    for name in sorted(overlay):
        if name not in catalogue:
            failures.append((name, 'overlay INTROUVABLE dans Content/BG', overlay[name]))
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

    print('%d fond(s) plein ecran, tous en frame 320x240.' % len(used))
    if overlay:
        print('%d fond(s) utilise(s) en overlay defilant (taille libre) :'
              % len(overlay))
        for name in sorted(overlay):
            if name in catalogue:
                fw, fh, n = catalogue[name]
                print('    %-22s frame %dx%d, %d frames' % (name, fw, fh, n))
            else:
                print('    %-22s ABSENT de Content/BG' % name)
    unused = sorted(set(catalogue) - set(used) - set(overlay))
    if unused:
        print('%d fond(s) present(s) mais jamais utilise(s) : %s'
              % (len(unused), ', '.join(unused)))
    print('RESULTAT : AUCUN BUG DE FORMAT')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else '.'))
