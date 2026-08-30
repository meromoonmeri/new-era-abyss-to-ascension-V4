#!/usr/bin/env python3
"""M1 — vocabulaire étendu Metano : FALAISES, CASCADES, PONTS.

Tout est extrait mécaniquement de metano_town (mt_db avec cats/rep) :
  * table d'autotile FALAISE : cellules dont un layer vient de
    Metano_Town_Cliffs -> code de voisinage 8 bits « est falaise » ;
  * CASCADES : clusters de cellules riveranim+cliff (l'eau animée qui
    traverse la falaise) + extension eau amont/aval -> groupes complets
    (colonnes de chute : crête, chute, écume) avec collision native ;
  * PONTS : cellules praticables (coll 0) non-eau entourées d'eau
    H ou V -> clusters + anneau (rambardes) -> groupes complets.

Sortie : /tmp/mt_vocab2.json
"""
from __future__ import annotations

import json
from collections import Counter, defaultdict

DB = json.load(open('/tmp/mt_db.json'))
W0, H0 = DB['W'], DB['H']
G = DB['grid']
C = DB['coll']
INFO = DB['info']
CLS = {k: v['cls'] for k, v in INFO.items()}
CATS = {k: set(v.get('cats', [])) for k, v in INFO.items()}

NEI8 = [(-1, -1), (0, -1), (1, -1), (-1, 0),
        (1, 0), (-1, 1), (0, 1), (1, 1)]
NEI4 = [(-1, 0), (1, 0), (0, -1), (0, 1)]


def is_cliff(x, y):
    return 'cliff' in CATS[G[x][y]] and 'riveranim' not in CATS[G[x][y]]


def is_water(x, y):
    return CLS[G[x][y]] == 'W'


def build_cliff_table():
    table = defaultdict(Counter)
    for x in range(W0):
        for y in range(H0):
            if is_cliff(x, y):
                code = 0
                for i, (dx, dy) in enumerate(NEI8):
                    nx, ny = x + dx, y + dy
                    if not (0 <= nx < W0 and 0 <= ny < H0) \
                            or is_cliff(nx, ny):
                        code |= 1 << i
                table[code][G[x][y]] += 1
    return {str(c): cnt.most_common(12) for c, cnt in table.items()}


def clusters(cells):
    cs = set(cells)
    seen = set()
    out = []
    for c in cells:
        if c in seen:
            continue
        stack = [c]
        seen.add(c)
        comp = []
        while stack:
            cur = stack.pop()
            comp.append(cur)
            for dx, dy in NEI8:
                n = (cur[0] + dx, cur[1] + dy)
                if n in cs and n not in seen:
                    seen.add(n)
                    stack.append(n)
        out.append(comp)
    return out


def extract_group(x0, y0, x1, y1):
    return [[x - x0, y - y0, G[x][y], C[x][y]]
            for x in range(x0, x1 + 1) for y in range(y0, y1 + 1)]


def waterfalls():
    wf = [(x, y) for x in range(W0) for y in range(H0)
          if 'riveranim' in CATS[G[x][y]] and 'cliff' in CATS[G[x][y]]]
    groups = []
    for comp in clusters(wf):
        xs = [c[0] for c in comp]
        ys = [c[1] for c in comp]
        x0, x1 = min(xs), max(xs)
        y0, y1 = min(ys), max(ys)
        # étendre : 2 cellules d'eau au-dessus (crête) et 3 en dessous
        # (écume) si eau présente
        yt = y0
        while yt > 0 and any(is_water(x, yt - 1)
                             for x in range(x0, x1 + 1)) \
                and y0 - yt < 2:
            yt -= 1
        yb = y1
        while yb < H0 - 1 and any(is_water(x, yb + 1)
                                  for x in range(x0, x1 + 1)) \
                and yb - y1 < 3:
            yb += 1
        groups.append({'w': x1 - x0 + 1, 'h': yb - yt + 1,
                       'at': [x0, yt],
                       'cells': extract_group(x0, yt, x1, yb)})
    return groups


def bridges():
    decks = []
    for x in range(1, W0 - 1):
        for y in range(1, H0 - 1):
            if CLS[G[x][y]] != 'W' and C[x][y] == 0:
                if (is_water(x - 1, y) and is_water(x + 1, y)) or \
                        (is_water(x, y - 1) and is_water(x, y + 1)):
                    decks.append((x, y))
    groups = []
    for comp in clusters(decks):
        xs = [c[0] for c in comp]
        ys = [c[1] for c in comp]
        x0, x1 = min(xs) - 1, max(xs) + 1
        y0, y1 = min(ys) - 1, max(ys) + 1
        x0, y0 = max(0, x0), max(0, y0)
        x1, y1 = min(W0 - 1, x1), min(H0 - 1, y1)
        w, h = x1 - x0 + 1, y1 - y0 + 1
        if w * h > 60:
            continue
        groups.append({'w': w, 'h': h, 'at': [x0, y0],
                       'deck': len(comp),
                       'cells': extract_group(x0, y0, x1, y1)})
    return groups


def main():
    cliff = build_cliff_table()
    wf = waterfalls()
    br = bridges()
    json.dump({'cliff_table': cliff, 'waterfalls': wf, 'bridges': br},
              open('/tmp/mt_vocab2.json', 'w'))
    print('cliff codes:', len(cliff))
    print('waterfalls:', [(g['w'], g['h'], g['at']) for g in wf])
    print('bridges:', [(g['w'], g['h'], g['at'], g['deck'])
                       for g in br][:14])


if __name__ == '__main__':
    main()
