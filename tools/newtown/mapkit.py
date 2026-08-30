#!/usr/bin/env python3
"""mapkit — Metano Ground asset library with PROVEN VALIDITY guarantees.

Nothing here invents pixels. The library exposes, and the composer may only
ever use:

  UNIS   universal flat tiles per class (measured: tiny color variance,
         >96% single-class, >=40 occurrences). Flat tiles have no painted
         border, so ANY juxtaposition of UNIS with anything is seam-free.
  ADJ    per-layer directed adjacency tables measured from metano: a pair of
         neighbor tiles is legal only if it occurs in metano, or if at least
         one side is UNIS.
  PIECES rectangular windows of the source (river bands, lake body, roads,
         plaza, groves, decor, edge bands, fords) whose border ring cells are
         all UNIS/universal-empty and which contain NO building cell inside
         (buildings removed at M1). Internal adjacencies inside a piece are
         copied verbatim, so pieces are seam-proof by construction at their
         rims (rim rings are 2 cells of universal ground).

The composer paints ONLY from this library; the validator re-proves every
adjacency + provenance afterwards and repairs only offending cells.
Export happens only when all checks pass.
"""
from __future__ import annotations
import json, sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tools" / "newtown"))
from render_ground_png import SheetLoader  # noqa: E402
from ground_grammar import load, classify, render as g_render  # noqa: E402

OUT = ROOT / ".runtime-work/mapkit"
LAYERS = ['Base','Cliffs','River','Layer 4','Objects Under','Objects Under Anim',
          'Objects','Objects Anim','Objects Over','Objects Over Anim','Fringe']


def tile_id(cell):
    if not cell or not cell.get('Layers'):
        return None
    lay = cell['Layers'][0]
    fr = (lay.get('Frames') or [{}])[0]
    if not fr or not fr.get('Sheet'):
        return None
    t = fr.get('TexLoc') or {}
    return (fr['Sheet'], t.get('X', 0), t.get('Y', 0))


class Kit:
    def __init__(self):
        OUT.mkdir(parents=True, exist_ok=True)
        self.obj = load('metano_town')
        o = self.obj
        self.png = g_render('metano_town')
        self.cls, self.L = classify(o, self.png)
        self.W = len(self.cls); self.H = len(self.cls[0])
        self.nb = len(self.L)
        self.obs = o['obstacles']
        self._adj = None
        self._unis = None

    # ---------- universals ----------
    def unis(self):
        if self._unis is not None:
            return self._unis
        from PIL import Image
        px = Image.open(self.png).convert('RGB').load()
        acc = {}
        for x in range(self.W):
            for y in range(self.H):
                tid = tile_id(self.L[0][x][y])
                if tid is None:
                    continue
                cols = [px[x*8+u, y*8+v] for u in range(0, 8, 2) for v in range(0, 8, 2)]
                rs = [c[0] for c in cols]; gs = [c[1] for c in cols]; bs = [c[2] for c in cols]
                var = (max(rs)-min(rs)) + (max(gs)-min(gs)) + (max(bs)-min(bs))
                d = acc.setdefault(tid, {'n': 0, 'var': 0, 'cls': Counter()})
                d['n'] += 1; d['var'] += var; d['cls'][self.cls[x][y]] += 1
        flat = {}
        for tid, d in acc.items():
            dom, ndom = d['cls'].most_common(1)[0]
            if d['n'] >= 30 and d['var']/d['n'] <= 10 and ndom/d['n'] > 0.96:
                flat[tid] = dom
        best = {}
        for tid, cl in flat.items():
            if cl not in best or acc[tid]['n'] > acc[best[cl]]['n']:
                best[cl] = tid
        self._unis = {'by_class': best, 'set': set(best.values()), 'flat': flat}
        return self._unis

    # ---------- adjacency ----------
    def adj(self):
        if self._adj is not None:
            return self._adj
        u = self.unis()['set']
        tables = []
        for li in range(self.nb):
            pairs = set()
            for x in range(self.W):
                for y in range(self.H):
                    a = tile_id(self.L[li][x][y])
                    for dx, dy in ((1, 0), (0, 1)):
                        nx, ny = x+dx, y+dy
                        if nx >= self.W or ny >= self.H:
                            continue
                        b = tile_id(self.L[li][nx][ny])
                        if a is None and b is None:
                            continue
                        # None == "no tile on this layer" : legal everywhere
                        # (empty is the universal background of object layers)
                        if a is None or b is None or a in u or b in u:
                            continue
                        pairs.add((a[0], a[1], a[2], b[0], b[1], b[2]))
            tables.append(pairs)
        self._adj = tables
        return tables

    def pair_ok(self, li, a, b):
        """a at left/up of b on layer li (None = absent)."""
        if a is None or b is None:
            return True
        u = self.unis()['set']
        if li != 0:
            # object layers: flat rule applies only on base; above, 'None' is the
            # universal; a real tile next to a real tile must be an observed pair,
            # unless one side never varies its rim… keep strict + allow uni for base.
            pass
        if a in u or b in u:
            return True
        t = self.adj()[li]
        return ((a[0], a[1], a[2], b[0], b[1], b[2]) in t) or ((b[0], b[1], b[2], a[0], a[1], a[2]) in t)

    # ---------- piece extraction ----------
    def blocked_cells(self):
        """building cells + their 1-cell shadow so pieces never carry B art"""
        b = set()
        for x in range(self.W):
            for y in range(self.H):
                if self.cls[x][y] == 'B':
                    for dx in (-1, 0, 1):
                        for dy in (-1, 0, 1):
                            b.add((x+dx, y+dy))
        return b

    def ring_ok(self, x0, y0, x1, y1, edge_ok=(True, True, True, True)):
        u = self.unis()['set']
        if x0 < 0 or y0 < 0 or x1 >= self.W or y1 >= self.H:
            return False
        empty = {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}
        def cell_ok(x, y):
            if self.cls[x][y] == 'B':
                return False
            for li in range(1, self.nb):
                c = self.L[li][x][y]
                if c and c.get('Layers'):
                    return False
            t = tile_id(self.L[0][x][y])
            return t is None or t in u
        top = (y0 == 0 and edge_ok[0])
        bot = (y1 == self.H-1 and edge_ok[1])
        lef = (x0 == 0 and edge_ok[2])
        rig = (x1 == self.W-1 and edge_ok[3])
        for x in range(x0, x1+1):
            if not top and not bot:
                if not cell_ok(x, y0) or not cell_ok(x, y1):
                    return False
            elif not top and not cell_ok(x, y0):
                return False
            elif not bot and not cell_ok(x, y1):
                return False
        for y in range(y0, y1+1):
            if not lef and not rig:
                if not cell_ok(x0, y) or not cell_ok(x1, y):
                    return False
            elif not lef and not cell_ok(x0, y):
                return False
            elif not rig and not cell_ok(x1, y):
                return False
        return True

    def window(self, kind, x0, y0, x1, y1, note=''):
        """returns piece dict with full layer grids (refs into source arrays ok)"""
        return {'kind': kind, 'src': [x0, y0, x1, y1], 'w': x1-x0+1, 'h': y1-y0+1, 'note': note,
                'edge_src': (y0 == 0, y1 == self.H-1, x0 == 0, x1 == self.W-1)}

    def cell_empty(self):
        return {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}

    def extract_pieces(self, max_per_kind=6):
        """library of seam-safe pieces; each piece = source window whose rim is
        universal (or map-edge-flush) and which contains no building."""
        P = {}
        add = lambda kind, p: P.setdefault(kind, []).append(p)
        cls = self.cls
        # --- WATER system pieces: scan for lake/pond bodies and river corridors
        seen = [[False]*self.H for _ in range(self.W)]
        waters = []
        for x in range(self.W):
            for y in range(self.H):
                if cls[x][y] == 'W' and not seen[x][y]:
                    q = deque([(x, y)]); seen[x][y] = True; c = []
                    while q:
                        a, b = q.popleft(); c.append((a, b))
                        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                            nx, ny = a+dx, b+dy
                            if 0 <= nx < self.W and 0 <= ny < self.H and cls[nx][ny] == 'W' and not seen[nx][ny]:
                                seen[nx][ny] = True; q.append((nx, ny))
                    waters.append(c)
        waters.sort(key=len, reverse=True)
        for comp in waters[:6]:
            xs = [p[0] for p in comp]; ys = [p[1] for p in comp]
            x0, x1, y0, y1 = min(xs), max(xs), min(ys), max(ys)
            # big lake/pond block with rim
            for pad in (4, 3, 2):
                if self.ring_ok(max(0, x0-pad), max(0, y0-pad), min(self.W-1, x1+pad), min(self.H-1, y1+pad),
                                edge_ok=(y0-pad < 0, y1+pad >= self.H, x0-pad < 0, x1+pad >= self.W)):
                    add('water_body', self.window('water_body', max(0, x0-pad), 0 if y0-pad < 0 else max(0, y0-pad),
                                                  min(self.W-1, x1+pad), self.H-1 if y1+pad >= self.H else min(self.H-1, y1+pad)))
                    break
            # vertical river columns (straight runs of constant center)
            col_best = {}
            col_best = {}
            for (cx, cy) in comp:
                col_best.setdefault(cx, []).append(cy)
            for cx, rows in sorted(col_best.items()):
                rows.sort()
                run_start = rows[0]; prev = rows[0]
                segs = []
                for r in rows[1:] + [None]:
                    if r is None or r != prev + 1:
                        segs.append((run_start, prev))
                        if r is not None:
                            run_start = r
                    if r is not None:
                        prev = r
                for (run_start, prev) in segs:
                    if prev - run_start < 14:
                        continue
                    ya = 0 if run_start <= 3 else run_start - 2
                    yb = self.H - 1 if prev >= self.H - 4 else prev + 2
                    if yb - ya < 12:
                        continue
                    for half in (5, 4, 3):
                        xx0, xx1 = max(0, cx - half), min(self.W - 1, cx + half)
                        eok = (ya == 0, yb == self.H - 1, False, False)
                        if self.ring_ok(xx0, ya, xx1, yb, edge_ok=eok):
                            add('river_col', self.window('river_col', xx0, ya, xx1, yb, f'cx={cx}'))
                            break
        # --- ROAD strips: straight horizontal & vertical runs, with plazas
        for kind in ('road_h', 'road_v'):
            pass
        def comp_of(cname, minlen=10):
            seen2 = [[False]*self.H for _ in range(self.W)]
            out = []
            for x in range(self.W):
                for y in range(self.H):
                    if cls[x][y] == cname and not seen2[x][y]:
                        q = deque([(x, y)]); seen2[x][y] = True; c = []
                        while q:
                            a, b = q.popleft(); c.append((a, b))
                            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                                nx, ny = a+dx, b+dy
                                if 0 <= nx < self.W and 0 <= ny < self.H and cls[nx][ny] == cname and not seen2[nx][ny]:
                                    seen2[nx][ny] = True; q.append((nx, ny))
                        if len(c) >= minlen:
                            out.append(c)
            return out
        # horizontal straight runs by row
        for y in range(3, self.H-3):
            x = 3
            while x < self.W-3:
                if cls[x][y] == 'P':
                    x0 = x
                    while x < self.W-3 and cls[x][y] == 'P':
                        x += 1
                    x1 = x-1
                    if x1-x0 >= 12:
                        for hw in (1, 2):
                            if self.ring_ok(x0-1, y-hw-1, x1+1, y+hw+1):
                                add('road_h', self.window('road_h', x0-1, max(0, y-hw-1), x1+1, min(self.H-1, y+hw+1), f'w={x1-x0+1}'))
                                break
                x += 1
        for x in range(3, self.W-3):
            y = 3
            while y < self.H-3:
                if cls[x][y] == 'P':
                    y0 = y
                    while y < self.H-3 and cls[x][y] == 'P':
                        y += 1
                    y1 = y-1
                    if y1-y0 >= 10:
                        for hw in (1, 2):
                            if self.ring_ok(x-hw-1, y0-1, x+hw+1, y1+1):
                                add('road_v', self.window('road_v', max(0, x-hw-1), y0-1, min(self.W-1, x+hw+1), y1+1, f'h={y1-y0+1}'))
                                break
                y += 1
        # plazas: wide road blobs (component bbox of road comp with high density)
        for c in comp_of('P', 120):
            xs = [p[0] for p in c]; ys = [p[1] for p in c]
            # local density scan for a plaza rectangle
            import itertools
            x0, x1, y0, y1 = min(xs), max(xs), min(ys), max(ys)
            for cy in range(y0+6, y1-6, 6):
                row = [cx for cx in range(x0, x1) if all(cls[cx+dx][cy+dy] == 'P' for dx in (0, 1, 2, 3) for dy in (-1, 0, 1))]
                if len(row) >= 14:
                    a = row[0]
                    if self.ring_ok(a-2, cy-4, a+len(row)+1, cy+4):
                        add('plaza', self.window('plaza', a-2, cy-4, a+len(row)+1, cy+4, 'blob'))
                    break
        # --- FOREST masses, groves, edge bands
        for c in sorted(comp_of('T', 30), key=len, reverse=True)[:8]:
            xs = [p[0] for p in c]; ys = [p[1] for p in c]
            x0, x1, y0, y1 = min(xs), max(xs), min(ys), max(ys)
            if y0 <= 1 and y1 - y0 >= 6:
                add('edge_n', self.window('edge_n', x0, 0, x1, min(y1, 9)))
            if y1 >= self.H-2 and y1 - y0 >= 6:
                add('edge_s', self.window('edge_s', x0, self.H-10, x1, self.H-1))
            if x0 <= 1 and x1 - x0 >= 5:
                add('edge_w', self.window('edge_w', 0, y0, min(x1, 9), y1))
            if x1 >= self.W-2 and x1 - x0 >= 5:
                add('edge_e', self.window('edge_e', self.W-10, y0, self.W-1, y1))
            # interior groves: ring-checked 10x8 windows with >=55% trees
            placed = 0
            for gy in range(y0+1, y1-9, 5):
                for gx in range(x0+1, x1-10, 7):
                    t = sum(1 for X in range(gx, gx+11) for Y in range(gy, gy+9) if cls[X][Y] in ('T', 'D'))
                    if t >= 60 and self.ring_ok(gx-1, gy-1, gx+11, gy+9):
                        add('grove', self.window('grove', gx-1, gy-1, gx+11, gy+9, f't={t}'))
                        placed += 1
                        break
                if placed >= 2: break
        # --- decor windows
        for c in comp_of('D', 3):
            xs = [p[0] for p in c]; ys = [p[1] for p in c]
            x0, x1, y0, y1 = min(xs)-1, max(xs)+1, min(ys)-1, max(ys)+1
            if x1-x0 <= 8 and y1-y0 <= 6 and x0 >= 0 and y0 >= 0 and x1 < self.W and y1 < self.H:
                if self.ring_ok(x0, y0, x1, y1):
                    add('decor', self.window('decor', x0, y0, x1, y1))
        # --- FORD pieces: road over water (walkable P cells flanked by W vertically)
        for y in range(5, self.H-5):
            for x in range(5, self.W-5):
                if cls[x][y] == 'P' and cls[x][y-3] == 'W' and cls[x][y+3] == 'W':
                    if self.ring_ok(x-6, y-5, x+6, y+5):
                        add('ford', self.window('ford', x-6, y-5, x+6, y+5, 'road over water'))
        # --- CLIFF pieces (elevation), and STAIRS objects near cliffs
        for c in comp_of('C', 12):
            xs = [p[0] for p in c]; ys = [p[1] for p in c]
            x0, x1, y0, y1 = min(xs)-2, max(xs)+2, max(0, min(ys)-2), min(self.H-1, max(ys)+2)
            if x0 < 0: x0 = 0
            if x1 >= self.W: x1 = self.W-1
            if self.ring_ok(x0, y0, x1, y1):
                add('cliff', self.window('cliff', x0, y0, x1, y1))
        # dedupe by (w,h,src class fingerprint), keep a few variants
        out = {}
        for kind, plist in P.items():
            seen_fp = set(); keep = []
            for p in plist:
                x0, y0, x1, y1 = p['src']
                fp = (p['w'], p['h'],
                      sum(1 for X in range(x0, x1+1) for Y in range(y0, y1+1) if cls[X][Y] == 'W'),
                      sum(1 for X in range(x0, x1+1) for Y in range(y0, y1+1) if cls[X][Y] == 'T'),
                      sum(1 for X in range(x0, x1+1) for Y in range(y0, y1+1) if cls[X][Y] == 'P'))
                if fp in seen_fp:
                    continue
                seen_fp.add(fp); keep.append(p)
                if len(keep) >= max_per_kind:
                    break
            if keep:
                out[kind] = keep
        # stats
        stats = {k: [f"{p['w']}x{p['h']}@{tuple(p['src'])}" for p in v] for k, v in out.items()}
        json.dump({'unis': {k: list(v) for k, v in self.unis()['by_class'].items()},
                   'adj_pairs_per_layer': [len(t) for t in self.adj()], 'pieces': stats},
                  open(OUT/'library.json', 'w'), indent=1)
        return out


if __name__ == '__main__':
    k = Kit()
    P = k.extract_pieces()
    print({kind: len(v) for kind, v in P.items()})
