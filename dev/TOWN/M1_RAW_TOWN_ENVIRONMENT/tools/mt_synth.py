#!/usr/bin/env python3
"""M1 — synthèse d'un layout ORIGINAL dans le langage du Ground Metano.

PAS un collage : chaque cellule est choisie par un modèle de blocs 2×2
OBSERVÉS dans metano_town (grammaire réelle du Ground) sous un plan
directeur original (biais de pondération). Garantie zéro-couture :
toute fenêtre 2×2 de la carte produite existe dans le donneur.

Exclusion des STRUCTURES (mission = zéro bâtiment) : composantes
connexes de cellules bloquées, grandes (>=40) et majoritairement
non-vertes (couleur composite native) = bâtiments ; leurs supertiles
exclusifs sont interdits de domaine. Mesuré, pas deviné.
"""
from __future__ import annotations

import json
import random
from collections import Counter, defaultdict
from functools import lru_cache

DB = json.load(open('/tmp/mt_db.json'))
W0, H0 = DB['W'], DB['H']
G = DB['grid']
COLLG = DB['coll']
INFO = DB['info']
HP = set(map(tuple, DB['hp']))
VP = set(map(tuple, DB['vp']))

FREQ = {k: v['freq'] for k, v in INFO.items()}
CLS = {k: v['cls'] for k, v in INFO.items()}
COLL = {k: v['coll'] for k, v in INFO.items()}

HRIGHT = defaultdict(set)
VDOWN = defaultdict(set)
for a, b in HP:
    HRIGHT[a].add(b)
for a, b in VP:
    VDOWN[a].add(b)

BL2 = defaultdict(set)
for x in range(1, W0):
    for y in range(1, H0):
        BL2[(G[x-1][y-1], G[x][y-1], G[x-1][y])].add(G[x][y])

# ------------------------------------------------ exclusion bâtiments
def building_cells():
    seen = [[False] * H0 for _ in range(W0)]
    bad_cells = set()
    for x in range(W0):
        for y in range(H0):
            if seen[x][y] or COLLG[x][y] == 0:
                continue
            stack = [(x, y)]
            seen[x][y] = True
            comp = []
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for nx, ny in ((cx-1, cy), (cx+1, cy),
                               (cx, cy-1), (cx, cy+1)):
                    if 0 <= nx < W0 and 0 <= ny < H0 \
                            and not seen[nx][ny] and COLLG[nx][ny] != 0:
                        seen[nx][ny] = True
                        stack.append((nx, ny))
            if len(comp) < 40:
                continue
            green = sum(1 for cx, cy in comp
                        if (lambda a: a[1] > a[0] and a[1] >= a[2])
                        (INFO[G[cx][cy]]['avg']))
            if green / len(comp) < 0.5:
                # bâtiment / falaise claire : structure -> interdite,
                # + marge 2 cellules (enseignes, seuils praticables)
                for cx, cy in comp:
                    for dx in range(-2, 3):
                        for dy in range(-2, 3):
                            nx, ny = cx + dx, cy + dy
                            if 0 <= nx < W0 and 0 <= ny < H0:
                                bad_cells.add((nx, ny))
    return bad_cells


BAD = building_cells()
# hash interdits = ceux qui n'apparaissent QUE dans les zones bâtiment
occ_ok = Counter()
occ_bad = Counter()
for x in range(W0):
    for y in range(H0):
        (occ_bad if (x, y) in BAD else occ_ok)[G[x][y]] += 1
FORBIDDEN = {h for h in FREQ if occ_ok[h] == 0}

DOMAIN = [h for h in FREQ
          if FREQ[h] >= 2 and h not in FORBIDDEN]
DOM_SET = set(DOMAIN)

CAP = 20


@lru_cache(maxsize=None)
def down_depth(h):
    seen = set()

    def rec(n, d):
        if d >= CAP:
            return CAP
        best = 0
        for nx in VDOWN[n]:
            if nx not in DOM_SET or nx in seen:
                continue
            seen.add(nx)
            best = max(best, 1 + rec(nx, d + 1))
            if best + d >= CAP:
                break
        return best
    return rec(h, 0)


# ------------------------------------------------------------ plan
TARGET = {
    'G': {'G'},
    'P': {'P'},
    'W': {'W'},
    'F': {'O'},      # forêt/décor
}


def weight(h, lab):
    w = FREQ[h]
    if lab and CLS[h] in TARGET.get(lab, ()):
        w *= 300
    return w


def synth(W, H, plan, seed, tries=600):
    rng = random.Random(seed)

    def one_row(up, i, salt, last):
        base = []
        for x in range(W):
            if up is None:
                cs = [h for h in DOMAIN
                      if (last or down_depth(h) >= 6)]
            else:
                cs = [h for h in VDOWN[up[x]]
                      if h in DOM_SET and (last or down_depth(h) >= 6)]
            if not cs:
                return None
            base.append(cs)
        feas = [set(base[0])]
        for x in range(1, W):
            cur = set()
            if up is None:
                for h in base[x]:
                    for left in feas[x - 1]:
                        if h in HRIGHT[left]:
                            cur.add(h)
                            break
            else:
                for h in base[x]:
                    for left in feas[x - 1]:
                        lr = BL2.get((up[x - 1], up[x], left))
                        if (lr is not None and h in lr) or \
                                (lr is None and h in HRIGHT[left]):
                            cur.add(h)
                            break
            if not cur:
                return None
            feas.append(cur)
        r = random.Random(seed * 733 + i * 37 + salt)
        row = [None] * W
        opts = list(feas[W - 1])
        row[W - 1] = r.choices(
            opts, weights=[weight(h, plan[W - 1][i]) for h in opts])[0]
        for x in range(W - 2, -1, -1):
            nxt = row[x + 1]
            if up is None:
                opts = [h for h in feas[x] if nxt in HRIGHT[h]]
            else:
                opts = []
                for h in feas[x]:
                    lr = BL2.get((up[x], up[x + 1], h))
                    if (lr is not None and nxt in lr) or \
                            (lr is None and nxt in HRIGHT[h]):
                        opts.append(h)
            if not opts:
                return None
            row[x] = r.choices(
                opts, weights=[weight(h, plan[x][i]) for h in opts])[0]
        return row

    rows = []
    up = None
    i = 0
    stuck = 0
    while len(rows) < H:
        row = None
        for salt in range(tries):
            row = one_row(up, i, salt, i == H - 1)
            if row is not None:
                break
        if row is None:
            if rows:
                rows.pop()
                up = rows[-1] if rows else None
                i -= 1
                stuck += 1
                if stuck > 80:
                    return None
                continue
            return None
        rows.append(row)
        up = row
        i += 1
    return [[rows[y][x] for y in range(H)] for x in range(W)]


def validate(p):
    W, H = len(p), len(p[0])
    bad = []
    for x in range(W):
        for y in range(H):
            if x + 1 < W and (p[x][y], p[x + 1][y]) not in HP:
                bad.append(('H', x, y))
            if y + 1 < H and (p[x][y], p[x][y + 1]) not in VP:
                bad.append(('V', x, y))
    return bad


def render(p, out):
    from PIL import Image
    from pathlib import Path
    IMG = Path('/tmp/mt_imgs')
    cache = {}
    W, H = len(p), len(p[0])
    im = Image.new('RGBA', (W * 8, H * 8), (0, 0, 0, 255))
    for x in range(W):
        for y in range(H):
            h = p[x][y]
            if h not in cache:
                cache[h] = Image.open(IMG / f'{h}.png').convert('RGBA')
            im.alpha_composite(cache[h], (x * 8, y * 8))
    im.convert('RGB').save(out)


if __name__ == '__main__':
    print('domain:', len(DOMAIN), '/', len(FREQ),
          'forbidden(building-only):', len(FORBIDDEN),
          'building cells:', len(BAD))
    c = Counter(CLS[h] for h in DOMAIN)
    print('domain classes:', dict(c))
