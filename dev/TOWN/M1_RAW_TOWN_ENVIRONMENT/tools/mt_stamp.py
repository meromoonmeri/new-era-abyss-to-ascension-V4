#!/usr/bin/env python3
"""M1 — composeur par MASQUES + AUTOTILES Metano (grammaire du Ground).

Méthode (ni collage de crops, ni copie de géométrie) :
  1. plan directeur ORIGINAL : masques rivière/chemins/forêt/objets ;
  2. chaque cellule d'un masque reçoit un supertile choisi parmi ceux
     OBSERVÉS dans metano_town pour le MÊME code de voisinage 8 bits
     (= la règle d'autotile du Ground, extraite mécaniquement) ;
  3. le choix parmi les candidats maximise les paires H/V observées
     (greedy gauche→droite, haut→bas) ;
  4. objets végétaux = groupes COMPLETS (composantes fermées, collision
     native) posés sur l'herbe — jamais coupés ;
  5. rapport : % de paires observées, % de codes exacts, rendu PNG.
Déterministe (seed).
"""
from __future__ import annotations

import json
import random
from collections import defaultdict, Counter

DB = json.load(open('/tmp/mt_db.json'))
VOC = json.load(open('/tmp/mt_vocab.json'))
W0, H0 = DB['W'], DB['H']
G0 = DB['grid']
COLLG0 = DB['coll']
INFO = DB['info']
CLS = {k: v['cls'] for k, v in INFO.items()}
HP = set(map(tuple, DB['hp']))
VP = set(map(tuple, DB['vp']))
GRASS = VOC['grass']

NEI8 = [(-1, -1), (0, -1), (1, -1), (-1, 0),
        (1, 0), (-1, 1), (0, 1), (1, 1)]


def green(k):
    a = INFO[k]['avg']
    return a[1] >= a[0] and a[1] >= a[2]


# table forêt (recalculée ici, même règle que l'audit)
def build_forest_table():
    is_f = lambda x, y: (CLS[G0[x][y]] == 'O' and COLLG0[x][y] != 0
                         and green(G0[x][y]))
    table = defaultdict(Counter)
    for x in range(W0):
        for y in range(H0):
            if is_f(x, y):
                c = 0
                for i, (dx, dy) in enumerate(NEI8):
                    nx, ny = x + dx, y + dy
                    if not (0 <= nx < W0 and 0 <= ny < H0) \
                            or is_f(nx, ny):
                        c |= 1 << i
                table[c][G0[x][y]] += 1
    return {c: cnt.most_common(12) for c, cnt in table.items()}


def build_bank_table():
    """cellules NON-eau adjacentes à l'eau (berges Metano) :
    code 8 bits « voisin est eau » -> supertiles observés."""
    is_w = lambda x, y: CLS[G0[x][y]] == 'W'
    table = defaultdict(Counter)
    for x in range(W0):
        for y in range(H0):
            if is_w(x, y):
                continue
            code = 0
            adj = False
            for i, (dx, dy) in enumerate(NEI8):
                nx, ny = x + dx, y + dy
                if 0 <= nx < W0 and 0 <= ny < H0 and is_w(nx, ny):
                    code |= 1 << i
                    if i in (1, 3, 4, 6):
                        adj = True
            if adj:
                table[code][G0[x][y]] += 1
    return {c: cnt.most_common(12) for c, cnt in table.items()}


TABLES = {
    'P': {int(c): v for c, v in VOC['path_table'].items()},
    'W': {int(c): v for c, v in VOC['water_table'].items()},
    'F': build_forest_table(),
    'BANK': build_bank_table(),
}

# fallback : code le plus proche (distance de Hamming) présent
def nearest_code(table, code):
    if code in table:
        return code
    best, bd = None, 99
    for c in table:
        d = bin(c ^ code).count('1')
        if d < bd:
            best, bd = c, d
    return best


class Compo:
    def __init__(self, W, H, seed):
        self.W, self.H = W, H
        self.rng = random.Random(seed)
        self.mask = [['G'] * H for _ in range(W)]   # G/P/W/F
        self.p = [[GRASS] * H for _ in range(W)]
        self.c = [[0] * H for _ in range(W)]
        self.objcells = set()

    def paint(self, lab, cells):
        for x, y in cells:
            if 0 <= x < self.W and 0 <= y < self.H:
                self.mask[x][y] = lab

    def rect(self, lab, x0, y0, x1, y1):
        self.paint(lab, [(x, y) for x in range(x0, x1 + 1)
                         for y in range(y0, y1 + 1)])

    def disk(self, lab, cx, cy, r):
        self.paint(lab, [(x, y)
                         for x in range(int(cx - r), int(cx + r) + 1)
                         for y in range(int(cy - r), int(cy + r) + 1)
                         if (x - cx) ** 2 + (y - cy) ** 2 <= r * r])

    def ribbon(self, lab, pts, hw):
        """bande épaisse le long d'une polyligne (interp linéaire)."""
        cells = []
        for (x1, y1), (x2, y2) in zip(pts, pts[1:]):
            steps = max(abs(x2 - x1), abs(y2 - y1)) * 2 + 1
            for s in range(steps + 1):
                t = s / steps
                cx = x1 + (x2 - x1) * t
                cy = y1 + (y2 - y1) * t
                for dx in range(-hw, hw + 1):
                    for dy in range(-hw, hw + 1):
                        if dx * dx + dy * dy <= hw * hw + hw:
                            cells.append((int(cx + dx), int(cy + dy)))
        self.paint(lab, cells)

    # ---------------------------------------------------- realize
    def realize(self):
        W, H = self.W, self.H
        m = self.mask
        stats = {'exact_code': 0, 'near_code': 0, 'cells': 0}

        def member(lab, x, y):
            if not (0 <= x < W and 0 <= y < H):
                return True          # bord de carte = continuation
            return m[x][y] == lab

        order = [(x, y) for y in range(H) for x in range(W)]
        for x, y in order:
            lab = m[x][y]
            if lab == 'G':
                continue
            code = 0
            for i, (dx, dy) in enumerate(NEI8):
                if member(lab, x + dx, y + dy):
                    code |= 1 << i
            table = TABLES[lab]
            c2 = nearest_code(table, code)
            stats['cells'] += 1
            if c2 == code:
                stats['exact_code'] += 1
            else:
                stats['near_code'] += 1
            pool = [(h, n) for h, n in table[c2]
                    if INFO[h]['freq'] >= 5]
            pool = pool or list(table[c2])
            strong = [h for h, n in pool if n >= 3]
            cands = strong or [h for h, _n in pool]
            # greedy : maximiser les paires observées avec gauche/haut
            def score(h):
                s = 0
                if x > 0 and (self.p[x - 1][y], h) in HP:
                    s += 2
                if y > 0 and (self.p[x][y - 1], h) in VP:
                    s += 2
                s += 0.001 * dict(table[c2])[h]
                return s
            best = max(cands, key=score)
            self.p[x][y] = best
            self.c[x][y] = INFO[best]['coll']

        # passe BERGES : toute cellule non-eau 4-adjacente à l'eau
        # reçoit le supertile de berge observé pour son code eau
        bank = TABLES['BANK']
        for x, y in order:
            if m[x][y] == 'W':
                continue
            code = 0
            adj = False
            for i, (dx, dy) in enumerate(NEI8):
                nx, ny = x + dx, y + dy
                if 0 <= nx < W and 0 <= ny < H and m[nx][ny] == 'W':
                    code |= 1 << i
                    if i in (1, 3, 4, 6):
                        adj = True
            if not adj:
                continue
            c2 = nearest_code(bank, code)
            pool = [(h, n) for h, n in bank[c2]
                    if INFO[h]['freq'] >= 5]
            pool = pool or list(bank[c2])
            strong = [h for h, n in pool if n >= 3]
            cands = strong or [h for h, _n in pool]

            def bscore(h):
                s = 0
                if x > 0 and (self.p[x - 1][y], h) in HP:
                    s += 2
                if y > 0 and (self.p[x][y - 1], h) in VP:
                    s += 2
                s += 0.001 * dict(bank[c2])[h]
                return s
            best = max(cands, key=bscore)
            self.p[x][y] = best
            self.c[x][y] = INFO[best]['coll']
            self.mask[x][y] = 'B'      # berge : pas d'objet dessus
        return stats

    # ---------------------------------------------------- objets
    def place_objects(self, specs):
        """specs : liste (x, y, obj_index). Vérifie que la zone est
        herbe pure et hors chemins/eau/forêt."""
        objs = VOC['objects']
        placed = 0
        for x0, y0, oi in specs:
            o = objs[oi]
            ok = True
            for dx, dy, _h, _cl in o['cells']:
                x, y = x0 + dx, y0 + dy
                if not (0 <= x < self.W and 0 <= y < self.H) \
                        or self.mask[x][y] != 'G' \
                        or (x, y) in self.objcells:
                    ok = False
                    break
            if not ok:
                continue
            for dx, dy, h, cl in o['cells']:
                x, y = x0 + dx, y0 + dy
                self.p[x][y] = h
                self.c[x][y] = cl
                self.objcells.add((x, y))
            placed += 1
        return placed

    def pair_report(self):
        tot = bad = 0
        for x in range(self.W):
            for y in range(self.H):
                if x + 1 < self.W:
                    tot += 1
                    if (self.p[x][y], self.p[x + 1][y]) not in HP:
                        bad += 1
                if y + 1 < self.H:
                    tot += 1
                    if (self.p[x][y], self.p[x][y + 1]) not in VP:
                        bad += 1
        return tot, bad

    def render(self, out):
        from PIL import Image
        from pathlib import Path
        IMG = Path('/tmp/mt_imgs')
        cache = {}
        im = Image.new('RGBA', (self.W * 8, self.H * 8))
        for x in range(self.W):
            for y in range(self.H):
                h = self.p[x][y]
                if h not in cache:
                    cache[h] = Image.open(IMG / f'{h}.png') \
                        .convert('RGBA')
                im.alpha_composite(cache[h], (x * 8, y * 8))
        im.convert('RGB').save(out)
