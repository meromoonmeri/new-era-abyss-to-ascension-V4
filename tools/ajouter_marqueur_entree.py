#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Pose les marqueurs d'arrivee attendus par New Era sur une carte importee.

Le probleme
-----------
Les cartes reprises d'ExplorersOfSkyOrigins nomment leur point d'arrivee
`Entrance`. New Era, lui, appelle systematiquement
`GAME:EnterGroundMap(carte, "Main_Entrance_Marker")`, et
tools/verify_ground_registration.py refuse une carte sans ce marqueur.

Plutot que de reecrire tous les appels du mod, on ajoute l'alias sur la
carte importee.

Ou poser le marqueur
--------------------
1. Si un marqueur `Entrance` existe ET tombe sur du sol libre, on reprend
   sa position : c'est le point d'arrivee voulu par les auteurs.
2. Sinon on prend la case libre la plus proche du centre de gravite de la
   plus grande poche de sol accessible.

Le cas 2 est frequent : EOSO pose souvent `Entrance` en coordonnees
negatives (patron du marqueur hors champ, repositionne par script). Un
tel marqueur ferait naitre le joueur hors de la carte.

On verifie qu'un personnage de 16x16 tient reellement sur la case, pas
seulement son coin haut-gauche.
"""
import copy
import json
import pathlib
import sys

import numpy as np
from scipy import ndimage

TEX = 8
ALIAS = ('Main_Entrance_Marker', 'entrance')


def gabarit():
    """Marqueur modele, repris d'une carte saine du projet."""
    d = json.loads(pathlib.Path('Data/Ground/metano_town.rsground')
                   .read_bytes().decode('utf-8-sig'))['Object']
    for c in d.get('Entities', []):
        for m in (c.get('Markers') or []):
            return copy.deepcopy(m)
    raise RuntimeError('aucun marqueur modele')


def traiter(nom, proto, appliquer=False):
    p = pathlib.Path('Data/Ground') / (nom + '.rsground')
    doc = json.loads(p.read_bytes().decode('utf-8-sig'))
    d = doc['Object']
    obs = d['obstacles']
    W, H = len(obs), len(obs[0])
    bloque = np.array([[obs[x][y]['Tags'] == 1 for y in range(H)]
                       for x in range(W)])
    libre = ~bloque.T
    lab, n = ndimage.label(libre)
    tailles = ndimage.sum(libre, lab, range(1, n + 1))
    if not len(tailles):
        return f"  {nom:26s} REFUS : aucune case libre"
    big = int(np.argmax(tailles)) + 1

    def tient(px, py, s=16):
        for dx in range(0, s, TEX):
            for dy in range(0, s, TEX):
                cx, cy = (px + dx) // TEX, (py + dy) // TEX
                if not (0 <= cx < W and 0 <= cy < H):
                    return False
                if bloque[cx][cy] or lab[cy][cx] != big:
                    return False
        return True

    couche = d['Entities'][0]
    couche.setdefault('Markers', [])
    presents = {e.get('EntName') for e in couche['Markers']}

    # 1. reprendre Entrance s'il est exploitable
    cible = None
    for e in couche['Markers']:
        if e.get('EntName') == 'Entrance':
            c = e.get('Collider') or {}
            if tient(c.get('X', -1), c.get('Y', -1)):
                cible = (c['X'], c['Y'])
                origine = 'reprise du marqueur Entrance'
            break

    # 2. sinon, centre de gravite de la plus grande poche
    if cible is None:
        ys, xs = np.where(lab == big)
        gx, gy = int(xs.mean()), int(ys.mean())
        best = None
        for k in range(len(xs)):
            x, y = int(xs[k]) * TEX, int(ys[k]) * TEX
            if not tient(x, y):
                continue
            dd = (x // TEX - gx) ** 2 + (y // TEX - gy) ** 2
            if best is None or dd < best[0]:
                best = (dd, x, y)
        if best is None:
            return f"  {nom:26s} REFUS : pas de case 16x16 libre"
        cible = (best[1], best[2])
        origine = 'centre de la plus grande poche'

    ajoutes = []
    for a in ALIAS:
        if a in presents:
            continue
        q = copy.deepcopy(proto)
        q['EntName'] = a
        q['Direction'] = 0
        q['Collider'] = {'X': cible[0], 'Y': cible[1],
                         'Width': 16, 'Height': 16}
        couche['Markers'].append(q)
        ajoutes.append(a)

    if not ajoutes:
        return f"  {nom:26s} deja pourvu"
    if appliquer:
        p.write_text('\ufeff' + json.dumps(doc, ensure_ascii=False, indent=1),
                     encoding='utf-8')
    return (f"  {nom:26s} {cible} <- {origine}"
            f"{'' if appliquer else '  (SIMULATION)'}")


def main():
    appliquer = '--appliquer' in sys.argv
    noms = [a for a in sys.argv[1:] if not a.startswith('-')]
    if not noms:
        print('usage: ajouter_marqueur_entree.py <ground> [...] [--appliquer]')
        return 1
    proto = gabarit()
    for n in noms:
        print(traiter(n, proto, appliquer))
    return 0


if __name__ == '__main__':
    sys.exit(main())
