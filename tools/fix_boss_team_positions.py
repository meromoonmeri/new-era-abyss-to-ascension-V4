#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fix_boss_team_positions.py — répartit les équipes ennemies des arènes
reconstruites autour du centre walkable réel, sans jamais poser un ennemi
sur un mur ni empiler deux ennemis au même point.

Usage : python3 tools/fix_boss_team_positions.py <arène> [<arène> ...]
       (sans argument : traite les arènes pixel-perfect reconstruites)
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAPDIR = os.path.join(ROOT, 'Data', 'Map')

# Formation en anneau autour du centre : le boss au centre, les sbires sur
# deux couronnes (8 positions cardinales puis diagonales étendues).
RING = [
    (0, 0),          # boss (centre)
    (-1, 0), (1, 0), (0, -1), (0, 1),      # couronne 1 : N S E O
    (-1, -1), (1, -1), (-1, 1), (1, 1),    # couronne 1 : diagonales
    (-2, 0), (2, 0), (0, -2), (0, 2),      # couronne 2
    (-2, -2), (2, -2), (-2, 2), (2, 2),    # couronne 2
    (-3, 0), (3, 0), (0, -3), (0, 3),
    (-3, -3), (3, -3), (-3, 3), (3, 3),
    (-4, 0), (4, 0), (0, -4), (0, 4),
]


def load(path):
    with open(path, encoding='utf-8-sig') as f:
        return json.load(f)


def save(path, d):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, separators=(',', ':'))


def largest_walkable_center(tiles, W, H):
    """Centre de la plus grande composante connexe de cellules walkable."""
    seen = [[False] * H for _ in range(W)]
    best = []
    for x in range(W):
        for y in range(H):
            if seen[x][y] or tiles[x][y]['Data']['ID'] == 'unbreakable':
                continue
            comp = []
            stack = [(x, y)]
            seen[x][y] = True
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = cx + dx, cy + dy
                    if 0 <= nx < W and 0 <= ny < H and not seen[nx][ny] \
                            and tiles[nx][ny]['Data']['ID'] != 'unbreakable':
                        seen[nx][ny] = True
                        stack.append((nx, ny))
            if len(comp) > len(best):
                best = comp
    if not best:
        return (W // 2, H // 2)
    cx = sum(p[0] for p in best) // len(best)
    cy = sum(p[1] for p in best) // len(best)
    return (cx, cy)


def nearest_walkable(tiles, W, H, x, y):
    if 0 <= x < W and 0 <= y < H and tiles[x][y]['Data']['ID'] != 'unbreakable':
        return (x, y)
    for r in range(1, max(W, H)):
        for dx in range(-r, r + 1):
            for dy in range(-r, r + 1):
                if abs(dx) != r and abs(dy) != r:
                    continue
                nx, ny = x + dx, y + dy
                if 0 <= nx < W and 0 <= ny < H and tiles[nx][ny]['Data']['ID'] != 'unbreakable':
                    return (nx, ny)
    return (x, y)


def fix(arena):
    path = os.path.join(MAPDIR, arena + '.rsmap')
    if not os.path.exists(path):
        print(f'{arena}: absent')
        return
    d = load(path)
    o = d['Object'] if 'Object' in d else d
    tiles = o['Tiles']
    W, H = len(tiles), len(tiles[0])
    teams = o.get('MapTeams', []) or []
    players = []
    for t in teams:
        for p in t.get('Players', []) or []:
            players.append(p)
    if not players:
        print(f'{arena}: pas d’équipes ennemies')
        return

    # centre de combat : Boss_Marker (entité) ou centre de la plus grande zone
    center = None
    for e in o.get('Entities', []) or []:
        pass
    # le .rsmap n'a pas d'entités ; on prend le centre de la plus grande zone
    cx, cy = largest_walkable_center(tiles, W, H)

    # vérifier les empilements
    occupied = {}
    stacked = False
    for p in players:
        sl = p.setdefault('serializationLoc', {})
        key = (sl.get('X', -1), sl.get('Y', -1))
        if key in occupied:
            stacked = True
        occupied[key] = p
    if not stacked:
        # vérifier quand même la walkability de chaque position
        for p in players:
            sl = p['serializationLoc']
            if tiles[sl.get('X', -1)][sl.get('Y', -1)]['Data']['ID'] == 'unbreakable':
                stacked = True
                break
    if not stacked:
        print(f'{arena}: positions déjà distinctes et walkable — inchangé')
        return

    # répartir : boss au centre, sbires en anneau
    used = set()
    for idx, p in enumerate(players):
        ox, oy = RING[idx % len(RING)]
        tx, ty = nearest_walkable(tiles, W, H, cx + ox, cy + oy)
        # éviter les collisions entre ennemis
        guard = 0
        while (tx, ty) in used and guard < 200:
            ox, oy = RING[(idx + 1 + guard) % len(RING)]
            tx, ty = nearest_walkable(tiles, W, H, cx + ox, cy + oy)
            guard += 1
        used.add((tx, ty))
        sl = p['serializationLoc']
        sl['X'] = tx
        sl['Y'] = ty
    save(path, d)
    for p in players:
        print(f'{arena}: {p.get("CurrentForm", {}).get("Species")} -> ({p["serializationLoc"]["X"]},{p["serializationLoc"]["Y"]})')


def main():
    arenas = sys.argv[1:]
    if not arenas:
        arenas = [
            'gloomy_forest_boss', 'magma_cavern_pit', 'mt_blaze_summit',
            'frosty_forest_summit', 'tour_ciel_sommet', 'wish_cave_jirachi',
            'mount_windswept_guardian', 'vast_steppe_guardian',
            'palier_celeste', 'parvis_celeste', 'sanctuaire_voeu',
            'searing_crucible', 'crystal_sanctuary_miniboss',
            'crystal_sanctuary_relay', 'forgotten_marsh_relay',
            'cloven_ruins_regice', 'cloven_ruins_regirock',
            'cloven_ruins_registeel', 'sanctuaire_titans',
        ]
    for a in arenas:
        try:
            fix(a)
        except Exception as e:
            print(f'{a}: ERREUR {e}')


if __name__ == '__main__':
    main()
