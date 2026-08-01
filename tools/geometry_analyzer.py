#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
geometry_analyzer.py — Analyseur de géométrie spatiale des Grounds (audit exhaustif).

Reconstruit une représentation fidèle d'un .rsground et détecte les
incohérences spatiales :
  - géométrie : dimensions, couches graphiques vs grille de collision
  - collisions : distribution Tags, obstacles, bordures
  - zones praticables : BFS depuis le marker d'entrée, accessibilité
  - silhouettes de décor : tuiles de décor (couches 1/2) avec opacité
  - entités : positions vs collisions, vs décor, distances inter-entités
  - chemins de circulation : largeur, continuité
  - caméras des scripts : hors bornes

Usage : python3 tools/geometry_analyzer.py <nom_map>
"""
import json
import os
import re
import struct
import sys
import io
from collections import deque
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_ground(name):
    with open(os.path.join(ROOT, 'Data', 'Ground', name + '.rsground'), encoding='utf-8-sig') as f:
        return json.load(f)['Object']


def load_tiles(sheet):
    with open(os.path.join(ROOT, 'Content', 'Tile', sheet + '.tile'), 'rb') as f:
        raw = f.read()
    _, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<Q', raw, off)[0]
        cells[(x, y)] = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert('RGBA')
    return cells


_tile_cache = {}


def get_tiles(sheet):
    if sheet not in _tile_cache:
        _tile_cache[sheet] = load_tiles(sheet)
    return _tile_cache[sheet]


def tags_at(ob, x, y):
    cx, cy = x // 8, y // 8
    if cx < 0 or cy < 0 or cx >= len(ob) or cy >= len(ob[0]):
        return None
    return ob[cx][cy].get('Tags', 0)


def bfs(ob, start_cell):
    W, H = len(ob), len(ob[0])
    seen = {start_cell}
    q = deque([start_cell])
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)):
            n = (cx + dx, cy + dy)
            if n not in seen and 0 <= n[0] < W and 0 <= n[1] < H and ob[n[0]][n[1]].get('Tags', 0) == 0:
                seen.add(n)
                q.append(n)
    return seen


def has_decor_tile(o, gx, gy, min_opaque=50):
    """La cellule graphique (gx,gy) porte-t-elle une tuile de décor opaque
    (couches 1/2) ?"""
    layers = o.get('Layers', [])
    if len(layers) < 2:
        return False
    for li in (1, 2):
        tiles = layers[li]['Tiles']
        if gx >= len(tiles) or gy >= len(tiles[0]):
            continue
        cell = tiles[gx][gy]
        for sub in cell.get('Layers', []):
            for f in sub.get('Frames', []):
                sheet = f.get('Sheet', '')
                tx, ty = f.get('TexLoc', {}).get('X', 0), f.get('TexLoc', {}).get('Y', 0)
                try:
                    img = get_tiles(sheet).get((tx, ty))
                except Exception:
                    img = None
                if img is None:
                    continue
                px = [p for p in img.getdata() if p[3] > 200]
                if len(px) > min_opaque:
                    return True
    return False


def decor_grid(o):
    """Grille booléenne (24x17 cellules 24px) de présence de décor opaque."""
    layers = o.get('Layers', [])
    if len(layers) < 2:
        return []
    tiles = layers[1]['Tiles']
    W, H = len(tiles), len(tiles[0])
    return [[has_decor_tile(o, x, y) for y in range(H)] for x in range(W)]


def decor_groups(grid):
    """Groupes connexes de décor (pour identifier rochers/parois/objets)."""
    W, H = len(grid), len(grid[0])
    seen = set()
    groups = []
    for x in range(W):
        for y in range(H):
            if grid[x][y] and (x, y) not in seen:
                g = []
                q = [(x, y)]
                seen.add((x, y))
                while q:
                    cx, cy = q.pop()
                    g.append((cx, cy))
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)):
                        n = (cx + dx, cy + dy)
                        if 0 <= n[0] < W and 0 <= n[1] < H and grid[n[0]][n[1]] and n not in seen:
                            seen.add(n)
                            q.append(n)
                xs = [c[0] for c in g]
                ys = [c[1] for c in g]
                groups.append({'x0': min(xs) * 24, 'y0': min(ys) * 24,
                               'x1': max(xs) * 24 + 24, 'y1': max(ys) * 24 + 24,
                               'n': len(g)})
    return sorted(groups, key=lambda z: -z['n'])


def main():
    name = sys.argv[1] if len(sys.argv) > 1 else 'cloven_ruins_entrance'
    o = load_ground(name)
    ob = o['obstacles']
    W, H = len(ob), len(ob[0])
    print(f'===== ANALYSEUR GEOMETRIE : {name} =====')
    print(f'[TERRAIN] {W*8} x {H*8} px | TexSize {o.get("TexSize")} | Music {o.get("Music")!r}')

    # couches
    for i, layer in enumerate(o.get('Layers', [])):
        tiles = layer.get('Tiles')
        if tiles:
            p = 8 * o.get('TexSize', 1)
            ok = 'OK' if len(tiles) * p == W * 8 and len(tiles[0]) * p == H * 8 else 'ECART'
            print(f'  L{i}: {len(tiles)}x{len(tiles[0])} -> {len(tiles)*p}x{len(tiles[0])*p} px {ok}')

    # collisions
    dist = {}
    for x in range(W):
        for y in range(H):
            t = ob[x][y].get('Tags', 0)
            dist[t] = dist.get(t, 0) + 1
    walk = dist.get(0, 0)
    print(f'[COLLISIONS] Tags={dist} | walkable {100*walk/(W*H):.0f}%')
    if walk == W * H:
        print('  >>> CARTE 100% WALKABLE — AUCUNE collision (à corriger)')
    borders = {'haut': 0, 'bas': 0, 'gauche': 0, 'droite': 0}
    for x in range(W):
        if ob[x][0].get('Tags', 0) != 0: borders['haut'] += 1
        if ob[x][H-1].get('Tags', 0) != 0: borders['bas'] += 1
    for y in range(H):
        if ob[0][y].get('Tags', 0) != 0: borders['gauche'] += 1
        if ob[W-1][y].get('Tags', 0) != 0: borders['droite'] += 1
    print(f'  Bordures bloquées : haut={borders["haut"]} bas={borders["bas"]} gauche={borders["gauche"]} droite={borders["droite"]} (cellules 8px)')

    # décor
    grid = decor_grid(o)
    if grid:
        ng = sum(1 for x in range(len(grid)) for y in range(len(grid[0])) if grid[x][y])
        print(f'[DECOR] {ng} cellules 24px avec décor opaque')
        groups = decor_groups(grid)
        print(f'  {len(groups)} groupes de décor :')
        for g in groups[:14]:
            print(f'    ({g["x0"]},{g["y0"]}) -> ({g["x1"]},{g["y1"]})  {g["n"]} cellules')

    # entités vs collisions/décor
    ent = o['Entities'][0]
    print('[ENTITES]')
    issues = []
    for cat in ('MapChars', 'Spawners', 'GroundObjects', 'Markers'):
        for e in ent.get(cat, []):
            c = e.get('Collider', {})
            x, y = c.get('X', 0), c.get('Y', 0)
            w, h = c.get('Width', 8), c.get('Height', 8)
            nm = e.get('EntName') or e.get('NPCName') or '?'
            t = tags_at(ob, x, y)
            gx, gy = (x + w // 2) // 24, (y + h // 2) // 24
            under = grid[gx][gy] if grid and 0 <= gx < len(grid) and 0 <= gy < len(grid[0]) else False
            status = []
            if t not in (0, None): status.append(f'Tags={t}')
            if under: status.append('SOUS DECOR')
            if status:
                issues.append((nm, x, y, status))
                print(f'  {cat[:9]:<9} {nm:<22} ({x},{y}) {" ".join(status)}')
            else:
                print(f'  {cat[:9]:<9} {nm:<22} ({x},{y}) OK')

    # BFS
    start = None
    for m in ent.get('Markers', []):
        if 'Main_Entrance' in (m.get('EntName') or ''):
            c = m.get('Collider', {})
            start = (c['X'] // 8, c['Y'] // 8)
    if start:
        seen = bfs(ob, start)
        print(f'[PRATICABILITE] BFS depuis ({start[0]*8},{start[1]*8}) : {100*len(seen)/max(walk,1):.0f}% atteints')

    # caméras
    sdir = os.path.join(ROOT, 'Data', 'Script', 'halcyon', 'ground', name)
    badcam = 0
    if os.path.isdir(sdir):
        for fn in sorted(os.listdir(sdir)):
            if not fn.endswith('.lua'): continue
            src = open(os.path.join(sdir, fn), encoding='utf-8').read()
            src = re.sub(r'--\[\[.*?\]\]--', '', src, flags=re.S)
            src = re.sub(r'--.*$', '', src, flags=re.M)
            for m in re.finditer(r'MoveCamera\((\d+),\s*(\d+)', src):
                if int(m.group(1)) > W * 8 or int(m.group(2)) > H * 8:
                    badcam += 1
                    print(f'  caméra hors bornes {fn}: ({m.group(1)},{m.group(2)})')
    print(f'  caméras : {"OK dans les bornes" if badcam==0 else f"{badcam} hors bornes"}')
    print(f'===== FIN ({len(issues)} entités avec problème) =====')


if __name__ == '__main__':
    main()
