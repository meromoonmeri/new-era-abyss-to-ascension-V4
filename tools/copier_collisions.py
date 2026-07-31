#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Recopie la grille d'obstacles d'un ground vers sa variante horaire.

Pourquoi
--------
Les cartes d'Explorers of Sky importees depuis PMDO-Explorers-Maps
existent souvent en plusieurs versions horaires (jour / crepuscule /
nuit). Mesure faite sur le depot source : seule la version JOUR porte
ses collisions.

    guild_outside        60x51  2756 murs (90 %)
    guild_outside_dusk   60x51     0 murs
    guild_outside_night  60x51     0 murs
    guild_basement       81x54  3380 murs (77 %)
    guild_basement_night 81x54     0 murs

Les variantes nocturnes sont donc des « feuilles » : le decor est
dessine, mais le moteur ne connait aucun mur (cf.
docs/audit_logique_spatiale.md). Le joueur traverserait les batiments
des la tombee du jour.

Ce n'est pas un defaut d'import : le probleme est present dans la source.

Methode
-------
Les deux cartes decrivent le MEME lieu a deux heures differentes : meme
grille, meme geometrie, seules les tuiles changent. On peut donc
recopier la grille d'obstacles telle quelle — a condition de le verifier
d'abord, ce que fait ce script :

  - meme dimensions de grille d'obstacles ;
  - meme TexSize ;
  - la source a des murs, la cible n'en a aucun.

Si l'une de ces conditions manque, on refuse d'ecrire : deux cartes de
dimensions differentes ne decrivent pas le meme lieu, et recopier une
grille par-dessus une grille deja remplie ecraserait un travail manuel.

Le style de serialisation du fichier cible est preserve (le depot
melange indent 0, 1 et 2 ; cf. tools/fix_spatial.py).
"""
import json
import pathlib
import sys


def charger(nom):
    p = pathlib.Path('Data/Ground') / (nom + '.rsground')
    return p, p.read_bytes()


def style(octets, doc):
    for ind in (1, 0, 2, 4):
        cand = '\ufeff' + json.dumps(doc, ensure_ascii=False,
                                     indent=ind, separators=(',', ': '))
        if cand.encode('utf-8') == octets:
            return ind
    return None


def compte(obs):
    return sum(1 for col in obs for c in col if c['Tags'] == 1)


def copier(source, cible, appliquer=False):
    ps, bs = charger(source)
    pc, bc = charger(cible)
    ds = json.loads(bs.decode('utf-8-sig'))['Object']
    docc = json.loads(bc.decode('utf-8-sig'))
    dc = docc['Object']

    os_, oc = ds['obstacles'], dc['obstacles']
    if (len(os_), len(os_[0])) != (len(oc), len(oc[0])):
        return f"REFUS  {cible}: grilles differentes " \
               f"{len(os_)}x{len(os_[0])} vs {len(oc)}x{len(oc[0])}"
    if ds.get('TexSize') != dc.get('TexSize'):
        return f"REFUS  {cible}: TexSize {ds.get('TexSize')} vs {dc.get('TexSize')}"
    ms, mc = compte(os_), compte(oc)
    if ms == 0:
        return f"REFUS  {cible}: la source {source} n'a aucun mur"
    if mc != 0:
        return f"REFUS  {cible}: a deja {mc} murs, on n'ecrase pas"

    for x in range(len(oc)):
        for y in range(len(oc[0])):
            oc[x][y]['Tags'] = os_[x][y]['Tags']

    if appliquer:
        ind = style(bc, json.loads(bc.decode('utf-8-sig')))
        if ind is None:
            return f"REFUS  {cible}: style de serialisation non reproductible"
        pc.write_bytes(('\ufeff' + json.dumps(
            docc, ensure_ascii=False, indent=ind,
            separators=(',', ': '))).encode('utf-8'))
    return f"OK     {source} -> {cible} : {ms} murs recopies" \
           f"{'' if appliquer else '  (SIMULATION)'}"


def main():
    appliquer = '--appliquer' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    if len(args) % 2:
        print("usage: copier_collisions.py <source> <cible> [...] [--appliquer]")
        return 1
    for i in range(0, len(args), 2):
        print(copier(args[i], args[i + 1], appliquer))
    return 0


if __name__ == '__main__':
    sys.exit(main())
