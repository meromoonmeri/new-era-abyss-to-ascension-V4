#!/usr/bin/env python3
"""M1 — vocabulaire structuré du Ground Metano (grammaire réelle).

Trois familles extraites MÉCANIQUEMENT de metano_town :
  1. FONDS : herbe unie dominante (et variantes observées G-G).
  2. AUTOTILES chemin & rivière : pour chaque cellule P (resp. W), code
     de voisinage 8 bits « est-P » (resp. est-W) -> exemples de
     supertiles OBSERVÉS pour ce code. Dessiner une nouvelle forme et
     poser pour chaque cellule le supertile du code correspondant =
     transitions garanties par les règles du Ground lui-même.
  3. OBJETS : composantes connexes de cellules non-fond dont l'anneau
     extérieur est du fond pur (arbres, buissons, rochers, fleurs) —
     objets COMPLETS avec collision native ; les composantes bâtiment
     (grandes, bloquées, non vertes) sont EXCLUES (zéro structure).

Sortie : /tmp/mt_vocab.json
"""
from __future__ import annotations

import json
from collections import Counter, defaultdict

DB = json.load(open('/tmp/mt_db.json'))
W0, H0 = DB['W'], DB['H']
G = DB['grid']
COLLG = DB['coll']
INFO = DB['info']

CLS = {k: v['cls'] for k, v in INFO.items()}
FREQ = {k: v['freq'] for k, v in INFO.items()}

GRASS = '90587e7149f1f32f'          # herbe unie (freq 3412, coll 0)

NEI8 = [(-1, -1), (0, -1), (1, -1), (-1, 0),
        (1, 0), (-1, 1), (0, 1), (1, 1)]


def neighbor_code(x, y, member):
    code = 0
    for i, (dx, dy) in enumerate(NEI8):
        nx, ny = x + dx, y + dy
        inside = 0 <= nx < W0 and 0 <= ny < H0
        if not inside or member(nx, ny):
            code |= 1 << i
    return code


def build_autotile(is_member):
    table = defaultdict(Counter)
    for x in range(W0):
        for y in range(H0):
            if is_member(x, y):
                code = neighbor_code(x, y, is_member)
                table[code][G[x][y]] += 1
    return {str(c): cnt.most_common(6) for c, cnt in table.items()}


def main():
    is_p = lambda x, y: CLS[G[x][y]] == 'P'
    is_w = lambda x, y: CLS[G[x][y]] == 'W'
    path_table = build_autotile(is_p)
    water_table = build_autotile(is_w)

    # objets : composantes non-fond, anneau = herbe unie
    is_bg = lambda x, y: CLS[G[x][y]] == 'G'
    seen = [[False] * H0 for _ in range(W0)]
    objects = []
    for x in range(W0):
        for y in range(H0):
            if seen[x][y] or is_bg(x, y) or CLS[G[x][y]] in 'PW':
                continue
            stack = [(x, y)]
            seen[x][y] = True
            comp = []
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for dx, dy in NEI8:
                    nx, ny = cx + dx, cy + dy
                    if 0 <= nx < W0 and 0 <= ny < H0 \
                            and not seen[nx][ny] and not is_bg(nx, ny) \
                            and CLS[G[nx][ny]] not in 'PW':
                        seen[nx][ny] = True
                        stack.append((nx, ny))
            if not (1 <= len(comp) <= 100):
                continue
            # anneau extérieur : herbe unie stricte
            ring_ok = True
            cs = set(comp)
            for cx, cy in comp:
                for dx, dy in NEI8:
                    nx, ny = cx + dx, cy + dy
                    if (nx, ny) in cs:
                        continue
                    if not (0 <= nx < W0 and 0 <= ny < H0) \
                            or CLS[G[nx][ny]] not in 'GP':
                        ring_ok = False
                        break
                if not ring_ok:
                    break
            if not ring_ok:
                continue
            xs = [c[0] for c in comp]
            ys = [c[1] for c in comp]
            x0, y0 = min(xs), min(ys)
            w = max(xs) - x0 + 1
            h = max(ys) - y0 + 1
            blocked = sum(1 for cx, cy in comp if COLLG[cx][cy] != 0)
            # verdure moyenne (exclut structures claires)
            greens = sum(1 for cx, cy in comp
                         if (lambda a: a[1] >= a[0] and a[1] >= a[2])
                         (INFO[G[cx][cy]]['avg']))
            objects.append({
                'w': w, 'h': h, 'n': len(comp), 'blocked': blocked,
                'green_ratio': round(greens / len(comp), 2),
                'cells': [[cx - x0, cy - y0, G[cx][cy], COLLG[cx][cy]]
                          for cx, cy in comp],
                'at': [x0, y0]})

    json.dump({'grass': GRASS,
               'path_table': path_table,
               'water_table': water_table,
               'objects': objects},
              open('/tmp/mt_vocab.json', 'w'))
    sizes = Counter((o['w'], o['h']) for o in objects)
    print('path codes:', len(path_table), 'water codes:',
          len(water_table), 'objects:', len(objects))
    print('object sizes top:', sizes.most_common(10))


if __name__ == '__main__':
    main()
