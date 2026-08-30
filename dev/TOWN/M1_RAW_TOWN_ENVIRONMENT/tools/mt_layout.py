#!/usr/bin/env python3
"""M1 — layout ORIGINAL « Vallon de l'Éclusée » (nom de travail).

Géométrie volontairement différente de Metano (rivière verticale
centre-est + cascade), de Luluby (croisée X centrale) et de Grass Town :
  * rivière en S paresseux : entre au NORD-CENTRE, serpente vers le
    SUD-OUEST puis ressort à l'OUEST ;
  * chemin principal : entrée SUD-EST → place centrale ovale à l'EST de
    la rivière → remonte au NORD ;
  * pont UNIQUE au centre-ouest vers le bosquet des parcelles ouest ;
  * parcelles futures : terrasse NE, rive ouest (après pont), balcon SE;
  * ceinture de forêt périmétrique épaisse, clairières internes.
Déterministe (seed).
"""
from __future__ import annotations

import json
import sys

sys.path.insert(0, '/home/user/new-era-abyss-to-ascension-V4/'
                   'dev/TOWN/M1_RAW_TOWN_ENVIRONMENT/tools')
from mt_stamp import Compo, VOC  # noqa: E402

SEED = 20260830
W, H = 84, 78


def build():
    c = Compo(W, H, SEED)

    # ---- forêt périmétrique (bord 5-8 cellules, bord irrégulier)
    c.rect('F', 0, 0, W - 1, 5)
    c.rect('F', 0, H - 6, W - 1, H - 1)
    c.rect('F', 0, 0, 5, H - 1)
    c.rect('F', W - 6, 0, W - 1, H - 1)
    # renflements internes de forêt (asymétrie naturelle)
    c.disk('F', 12, 14, 6)
    c.rect('F', 0, 0, 26, 16)          # quart NO au-delà de la rivière
    c.disk('F', 70, 12, 7)
    c.disk('F', 74, 62, 8)
    c.disk('F', 10, 66, 6)
    c.disk('F', 40, 8, 4)
    c.disk('F', 26, 70, 5)

    # ---- rivière : nord-centre -> arc -> sortie OUEST (le quart NO
    # au-delà de la rivière reste forêt : aucun pont nécessaire —
    # « bridges only where useful »)
    c.ribbon('W', [(44, 0), (41, 8), (36, 14), (29, 19),
                   (21, 23), (13, 27), (6, 30), (0, 32)], 3)

    # ---- entrée sud-est + chemin principal vers place puis nord
    c.ribbon('P', [(66, H - 1), (64, 68), (58, 60), (54, 52),
                   (52, 44)], 2)
    # place centrale ovale (est de la rivière)
    c.disk('P', 50, 38, 7)
    c.disk('P', 45, 38, 5)
    # remontée nord depuis la place
    c.ribbon('P', [(50, 32), (52, 22), (54, 14), (55, 6)], 2)
    # branche ouest : place -> parcelle ouest (sud de la rivière)
    c.ribbon('P', [(43, 40), (34, 42), (26, 42), (18, 44)], 1)
    # petit sentier berge : approche de la rivière (point d'eau)
    c.ribbon('P', [(26, 42), (24, 36)], 1)
    # sentier nord-est : place -> terrasse NE
    c.ribbon('P', [(54, 32), (60, 26), (64, 20)], 1)

    # (les parcelles restent en 'G' : herbe plate, accessibles — on ne
    # pose PAS de bâtiment ; elles se lisent par les clairières)
    return c


def main():
    c = build()
    stats = c.realize()
    # objets végétaux : bosquets/buissons/fleurs sur l'herbe, densités
    # décroissantes vers le centre (échantillonnage seedé)
    import random
    rng = random.Random(SEED)
    objs = VOC['objects']
    # tri : gros d'abord (bosquets), petits ensuite
    order = sorted(range(len(objs)), key=lambda i: -objs[i]['n'])
    specs = []
    for oi in order:
        o = objs[oi]
        tries = 40 if o['n'] >= 6 else 160
        for _ in range(tries):
            x = rng.randrange(4, W - 6)
            y = rng.randrange(4, H - 6)
            # densité : plus près du bord = plus probable
            d = min(x, y, W - 1 - x, H - 1 - y)
            pkeep = 0.9 if d < 14 else (0.30 if d < 22 else 0.10)
            if rng.random() > pkeep:
                continue
            specs.append((x, y, oi))
    placed = c.place_objects(specs)
    tot, bad = c.pair_report()
    print(f'realize: {stats} | objets posés: {placed}')
    print(f'paires: {tot} total, {bad} hors-corpus '
          f'({100*(tot-bad)/tot:.2f}% observées)')
    json.dump({'W': W, 'H': H, 'p': c.p, 'c': c.c,
               'mask': [''.join(c.mask[x][y] for x in range(W))
                        for y in range(H)],
               'params': {'seed': SEED, 'layout': 'mt_layout.py/1'}},
              open('/tmp/m1_metano_composed.json', 'w'))
    c.render('/tmp/m1_metano_composed.png')
    print(f'{W}x{H} -> /tmp/m1_metano_composed.png')


if __name__ == '__main__':
    main()
