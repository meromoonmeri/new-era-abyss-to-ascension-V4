#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Verifie que chaque asset reference par un script EXISTE reellement.

POURQUOI CET OUTIL
==================
Retour de jeu : « l'effet de nausee affiche des carres violets et noirs ».

Ce n'est pas un bug d'effet, c'est un asset manquant. Quand le fichier
demande n'existe pas, RogueEssence ne plante pas et ne previent pas : il
substitue une texture de secours. Lue dans la source du moteur
(RogueCollab/RogueEssence) :

    GraphicsManager.getDirSheetCache()
        if (!File.Exists(dirPath)) -> DirSheet.LoadError()

    GraphicsManager.InitSystem():430
        defaultTex = new Texture2D(graphics, 32, 32);
        for (int ii = 0; ii < 16; ii++)
            BaseSheet.BlitColor((ii % 2 == (ii / 4 % 2))
                ? Color.Black : new Color(255, 0, 255, 255), ...);

Un damier 32x32 alternant NOIR et MAGENTA. C'est exactement le symptome
decrit, et il apparait SILENCIEUSEMENT : aucune exception, aucune ligne
de log, la cinematique continue.

CE QUE L'AUDIT A TROUVE
=======================
Cinq assets inventes, dont quatre sur le Mont Venteux :

    BGAnimData("Black")         VoiceVisions.DizzyVeil   -> le vertige
    BGAnimData("Cloudy_Sky")    mount_windswept_guardian -> l'orage
    BGAnimData("Ominous_Wind")  guardian + miniboss      -> les bourrasques
    BGAnimData("Sandstorm")     mount_windswept_guardian -> la poussiere
    BGAnimData("Fog")           searing_tunnel_miniboss  -> la fumee

Aucun n'existe dans Content/BG, aucun n'existe dans Halcyon upstream
(Palikadude/Halcyon, dont ce projet est le fork), aucun n'existe nulle
part sur le disque. Tous ont ete remplaces par le patron ATTESTE :

    anim  = RogueEssence.Content.BGAnimData("White", 0)
    Color = Color(r, g, b, a/255)

C'est ainsi que le code Halcyon d'origine assombrit l'ecran
(first_core_location_ch_3.lua:58-59) : une planche BLANCHE teintee, pas
une planche de la couleur voulue. Noter que l'alpha y est NORMALISE 0-1
— le « 76/255 » du code d'origine le prouve ; ecrire 128 donnerait 128
fois l'opacite maximale.

ASSETS DU JEU DE BASE
=====================
"White" et "Pre_Battle" sont absents du mod mais fournis par PMDO. On ne
les signale pas : Halcyon upstream les utilise et ses scenes fonctionnent
en jeu. Toute autre absence est un bug.

Pour ajouter un nom a cette liste, il faut une PREUVE d'usage en jeu, pas
une intuition : le chercher dans Halcyon upstream, ou l'observer
fonctionner soi-meme.

Usage : python3 tools/verify_assets_exist.py [racine]
"""
import glob
import os
import re
import sys

# Assets fournis par le jeu de base, absents du dossier du mod.
# N'ajouter QUE sur preuve d'usage fonctionnel (cf. en-tete).
BASE_GAME = {'White', 'Pre_Battle'}

FOLDERS = {
    'BG': 'Content/BG',
    'Object': 'Content/Object',
    'Particle': 'Content/Particle',
    'Item': 'Content/Item',
}

PATTERNS = {
    'BG': re.compile(r'BGAnimData\(\s*[\'"]([^\'"]+)[\'"]'),
    'Object': re.compile(r'ObjAnimData\(\s*[\'"]([^\'"]+)[\'"]'),
}


def strip_comments(src):
    src = re.sub(r'--\[\[.*?\]\]', '', src, flags=re.S)
    return '\n'.join(l.split('--')[0] for l in src.split('\n'))


def main(root='.'):
    present = {}
    for kind, folder in FOLDERS.items():
        path = os.path.join(root, folder)
        present[kind] = {os.path.basename(f)[:-4]
                         for f in glob.glob(os.path.join(path, '*.dir'))}

    found = {}
    for lua in glob.glob(os.path.join(root, 'Data/Script/**/*.lua'),
                         recursive=True):
        try:
            src = strip_comments(open(lua, encoding='utf-8',
                                      errors='replace').read())
        except Exception:
            continue
        rel = os.path.relpath(lua, root)
        for kind, pat in PATTERNS.items():
            for m in pat.finditer(src):
                found.setdefault((kind, m.group(1)), set()).add(rel)

    missing = []
    base = []
    for (kind, name), files in sorted(found.items()):
        if name in present.get(kind, set()):
            continue
        if name in BASE_GAME:
            base.append((kind, name))
            continue
        # tolerance : present dans un autre dossier de Content
        elsewhere = [k for k, v in present.items() if name in v]
        if elsewhere:
            continue
        missing.append((kind, name, sorted(files)))

    print('%d asset(s) reference(s) par les scripts.' % len(found))
    if base:
        print('%d fourni(s) par le jeu de base (ignores) : %s'
              % (len(base), ', '.join(n for _, n in base)))
    print()

    if not missing:
        print('RESULTAT : TOUS LES ASSETS REFERENCES EXISTENT')
        return 0

    print('ASSETS INTROUVABLES — le moteur affichera un damier noir/magenta :')
    for kind, name, files in missing:
        print('  [%s] %s' % (kind, name))
        for f in files:
            print('        %s' % f)
    print()
    print('RESULTAT : %d asset(s) introuvable(s)' % len(missing))
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else '.'))
