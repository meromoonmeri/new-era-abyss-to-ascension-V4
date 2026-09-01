#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_mapacomplete.py — BLOCKOUT v4 du fragment TOWN PLAZA (F1/F3).

Méthode Palika (M1) : la source sert de PLAN, jamais de crop. La source
(F1) est un VILLAGE DENSE : ceinture de forêt, anneau de maisons/échoppes
étroitement serrées autour d'une place centrale, chemins de sable étroits
et sinueux qui serpentent entre les bâtiments, parcelles cultivées, statue.

Ce blockout reproduit cette COMPOSITION et cette DENSITÉ (pas la
géométrie brute, qui est un montage re-encodé) avec le langage authentique
metano_town : autotiles chemin/forêt, groupes bâtiments et végétation
COMPLETS à collision native.

Niveau : BLOCKOUT (phase 6). Objets fins / foreground / collision fine
= phases suivantes.
"""
from __future__ import annotations

import json
import random
import sys

sys.path.insert(0, '/home/user/new-era-abyss-to-ascension-V4/'
                   'dev/TOWN/M1_RAW_TOWN_ENVIRONMENT/tools')
from mt_stamp import Compo, VOC, HP, VP, INFO  # noqa: E402

SEED = 20260901
W, H = 84, 84

BUILDINGS = json.load(open('/tmp/mt_buildings.json'))
HOUSES = [i for i, b in enumerate(BUILDINGS)
          if 30 <= b['n'] <= 200 and b['green_ratio'] < 0.5
          and b['w'] <= 20 and b['h'] <= 20]
# objets végétaux majeurs (arbres/bosquets/buissons complets)
VEG = [i for i, o in enumerate(VOC['objects'])
       if o['blocked'] >= 1 and o['n'] >= 3]


def build_plan():
    plan = [['F'] * H for _ in range(W)]

    def rect(x0, y0, x1, y1, lab):
        for x in range(max(0, x0), min(W, x1 + 1)):
            for y in range(max(0, y0), min(H, y1 + 1)):
                plan[x][y] = lab

    # ceinture de forêt dense (périmètre)
    for x in range(W):
        for y in range(H):
            d = min(x, y, W - 1 - x, H - 1 - y)
            if d < 8:
                plan[x][y] = 'F'

    # grande clairière intérieure (la place et ses abords)
    rect(8, 8, W - 9, H - 9, 'G')

    # chemins étroits et sinueux : croix principale + branches
    def ribbon(pts, hw=0):
        for (x1, y1), (x2, y2) in zip(pts, pts[1:]):
            steps = max(abs(x2-x1), abs(y2-y1))*2+1
            for s in range(steps+1):
                t=s/steps
                cx=x1+(x2-x1)*t; cy=y1+(y2-y1)*t
                for dx in range(-hw,hw+1):
                    for dy in range(-hw,hw+1):
                        rect(int(cx+dx), int(cy+dy), int(cx+dx), int(cy+dy),'P')

    # axe vertical principal (étroit) du nord au sud
    ribbon([(40, 6), (40, 28), (42, 34), (42, 46), (40, 52), (40, H-6)], 1)
    # axe horizontal principal (étroit) d'ouest en est
    ribbon([(6, 40), (28, 40), (34, 42), (46, 42), (52, 40), (W-6, 40)], 1)
    # petites branches vers les quartiers de maisons
    ribbon([(40, 16), (56, 16), (60, 18)], 0)      # nord-est
    ribbon([(40, 62), (56, 62), (60, 60)], 0)      # sud-est
    ribbon([(40, 16), (24, 16), (20, 18)], 0)      # nord-ouest
    ribbon([(28, 40), (28, 56), (26, 60)], 0)      # ouest-sud
    ribbon([(52, 40), (52, 56), (54, 60)], 0)      # est-sud

    # place centrale dégagée (petit parvis)
    rect(34, 34, 46, 48, 'P')
    return plan


def stamp_buildings(plan, c):
    """Pose un anneau DENSE de bâtiments complets autour de la place."""
    # Emplacements denses (quartiers) : beaucoup de maisons serrées.
    rng = random.Random(SEED)
    ring = []
    # quartier nord
    for i in range(5):
        ring.append((18 + i*8, 12))
    # quartier sud
    for i in range(5):
        ring.append((18 + i*8, H-18))
    # quartier ouest
    for i in range(5):
        ring.append((12, 16 + i*9))
    # quartier est
    for i in range(5):
        ring.append((W-18, 16 + i*9))
    # second anneau (cerclant la place)
    ring += [(30,24),(44,24),(30,52),(44,52),(50,30),(50,48),(26,30),(26,48)]
    # intérieur dense (autour du parvis) — village serré comme la source
    ring += [(32,33),(46,33),(32,47),(46,47),(39,28),(39,52),(28,39),(52,39)]
    # très dense : combler les interstices
    for _ in range(10):
        ring.append((rng.randrange(20, W-20), rng.randrange(16, H-16)))

    placed = 0
    for (x0, y0) in ring:
        b = BUILDINGS[rng.choice(HOUSES)]
        ok = True
        for dx, dy, h, cl in b['cells']:
            x, y = x0 + dx, y0 + dy
            if not (0 <= x < W and 0 <= y < H) or plan[x][y] not in ('G','P'):
                ok = False; break
        if not ok:
            continue
        for dx, dy, h, cl in b['cells']:
            x, y = x0 + dx, y0 + dy
            c.p[x][y] = h; c.c[x][y] = cl
            c.mask[x][y] = 'X'; c.objcells.add((x,y))
        placed += 1
    return placed


def seed_vegetation(c):
    rng = random.Random(SEED)
    specs = []
    objs = VOC['objects']
    keep = [i for i, o in enumerate(objs) if o['blocked'] >= 1]
    order = sorted(keep, key=lambda i: -objs[i]['n'])
    for oi in order:
        o = objs[oi]
        tries = 30 if o['n'] >= 6 else 120
        for _ in range(tries):
            x = rng.randrange(6, W-8); y = rng.randrange(6, H-8)
            d = min(x, y, W-1-x, H-1-y)
            pkeep = 0.95 if d < 16 else (0.45 if d < 26 else 0.15)
            if rng.random() > pkeep: continue
            specs.append((x,y,oi))
    return c.place_objects(specs)


def main():
    plan = build_plan()
    c = Compo(W, H, SEED)
    for x in range(W):
        for y in range(H):
            c.mask[x][y] = plan[x][y]

    stats = c.realize()
    placed_b = stamp_buildings(plan, c)
    placed_v = seed_vegetation(c)
    tot, bad = c.pair_report()
    print(f'realize: {stats}')
    print(f'bâtiments posés: {placed_b} | végétation posée: {placed_v}')
    print(f'paires: {tot} total, {bad} hors-corpus '
          f'({100*(tot-bad)/tot:.2f}% observées)')

    json.dump({'W': c.W, 'H': c.H, 'p': c.p, 'c': c.c,
               'mask': [''.join(c.mask[x][y] for x in range(c.W))
                        for y in range(c.H)],
               'params': {'seed': SEED, 'layout': 'build_mapacomplete/4',
                          'fragment': 'TOWN_PLAZA_F1_F3',
                          'level': 'BLOCKOUT', 'density': 'DENSE'}},
              open('/tmp/mapa_composed.json', 'w'))
    c.render('/tmp/mapa_blockout.png')
    print(f'{c.W}x{c.H} -> /tmp/mapa_blockout.png')
    return 0 if not bad else 2


if __name__ == '__main__':
    raise SystemExit(main())
