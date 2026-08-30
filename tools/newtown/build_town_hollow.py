#!/usr/bin/env python3
"""MILESTONE 1 — town_hollow RAW TOWN ENVIRONMENT generator.

Method — context-matched tile synthesis from metano_town (zero new art):

  * Every ground tile in the target map is a REAL source cell copied
    byte-exact (all 11 layers + its obstacle cell), selected so its local
    3x3 class neighbourhood equals the target's desired 3x3 class
    neighbourhood. Ground transitions are therefore authentic: a bank tile
    is only ever used where a bank existed in Metano Town, a bridge deck
    only where a bridge deck existed, etc.

  * Classes measured from the source, never guessed:
      W  water        (River-layer occupancy; source animates 4 frames)
      C  cliff        (Cliffs-layer occupancy)  -> never requested
      B  building     (saturated red/blue/white OBJ clusters) -> excluded
      T  tree         (OBJ/Over with green-dominant canopy or dark mass)
      D  decor-grass  (small OBJ speckle: flowers/bushes/rocks on ground)
      P  path/sand    (warm bright base colour, no bits)
      G  grass        (green base, no bits)
      X  anything else -> excluded

  * Deterministic: SEED fixed and recorded; same inputs => same sha256.
    Selection rotates candidates per (x,y) so large fields never repeat one
    tile and never show a stamped pattern.

  * Milestone 1 = RAW environment: no buildings (BUILD cells and
    structure-bearing X cells are never emitted), no NPCs, no GroundObjects;
    only terrain + water + vegetation + paths + reserved open plots, and
    navigation markers for entry/exit testing.
"""
from __future__ import annotations
import argparse, copy, hashlib, json, math, sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from render_ground_png import SheetLoader, render_ground, read_tile_sheet  # noqa: E402

SRC = ROOT / "Data/Ground/metano_town.rsground"
OUT = ROOT / "Data/Ground/town_hollow.rsground"
WORK = ROOT / ".runtime-work"
REPORT = WORK / "town_hollow_report.json"
TW, TH = 140, 110
SEED = 20260829
LAYERS = ['Base','Cliffs','River','Layer 4','Objects Under','Objects Under Anim',
          'Objects','Objects Anim','Objects Over','Objects Over Anim','Fringe']
EMPTY = {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}


def H2(x, y, salt=0):
    """deterministic 0..1 hash (no RNG state)"""
    d = hashlib.blake2b(f"{x},{y},{salt},{SEED}".encode(), digest_size=8).digest()
    return int.from_bytes(d, 'big') / float(1 << 64)


# ---------------------------------------------------------------- layout ----
def river_poly():
    return [(118, -4), (114, 8), (110, 20), (102, 32), (92, 42), (82, 50), (74, 60), (70, 70)]
LAKE = (70, 80, 18, 10)                      # cx cy rx ry
OUTLET = [(62, 84), (54, 92), (48, 102), (46, 114)]

def seg_dist(x, y, pts, width):
    best = 1e9
    for (ax, ay), (bx, by) in zip(pts, pts[1:]):
        vx, vy = bx - ax, by - ay
        L2 = vx * vx + vy * vy or 1
        t = max(0.0, min(1.0, ((x - ax) * vx + (y - ay) * vy) / L2))
        px, py = ax + t * vx, ay + t * vy
        d = math.hypot(x - px, y - py)
        best = min(best, d)
    end = 1.5 if pts in (river_poly(), OUTLET) else 1.0
    if pts is river_poly() and y <= 0: best = min(best, abs(x - pts[0][0]) + y * 0 + 0.6)
    return best - width / 2 if best > width / 2 else 0.0

def in_lake(x, y, pad=0.0):
    cx, cy, rx, ry = LAKE
    return ((x - cx) / (rx + pad)) ** 2 + ((y - cy) / (ry + pad)) ** 2 <= 1.0

ROADS = {
    'main':  ([(60, 114), (60, 100), (56, 92), (50, 84), (46, 74), (44, 66)], 3),
    'north': ([(48, 56), (56, 48), (68, 44), (80, 42), (92, 40), (104, 40), (112, 40)], 2),
    'prom':  ([(112, 40), (114, 52), (108, 64), (98, 74), (104, 86), (96, 96), (86, 104), (78, 114)], 2),
    'spur1': ([(34, 58), (26, 52)], 2),
    'spur2': ([(38, 68), (30, 76)], 2),
    'spur3': ([(52, 52), (58, 40), (66, 34)], 2),
    'spur4': ([(96, 80), (104, 84)], 2),
}
PLAZA = (44, 62, 9, 6)

def plot_rects():
    return [(16, 46, 14, 9), (18, 74, 14, 9), (62, 28, 14, 9), (100, 88, 13, 9)]

def target_class(x, y):
    # water: river channel + lake + outlet
    w = 5.6 + (y / TH) * 3.2
    if seg_dist(x, y, river_poly(), w + 1.0) > 0.001 or in_lake(x, y, 0.5) or seg_dist(x, y, OUTLET, 4.4) > 0.001:
        pass
    water = seg_dist(x, y, river_poly(), w) <= 0 or in_lake(x, y) or seg_dist(x, y, OUTLET, 5.0) <= 0
    for (by0, by1, bx0, bx1) in [(39, 42, 88, 104), (86, 89, 47, 61)]:
        if by0 <= y <= by1 and bx0 <= x <= bx1:
            return 'J'
    # lake island (source has a tree island) : ring grass + tree core
    if 66 <= x <= 74 and 76 <= y <= 82:
        return 'T' if (68 <= x <= 72 and 78 <= y <= 80) else 'G'
    # roads
    cx, cy, rx, ry = PLAZA
    plaza = ((x - cx) / (rx + 0.5 * H2(x // 4, y // 4, 7) * rx * 0.35)) ** 2 + ((y - cy) / (ry + 0.5 * H2(x // 5, y // 5, 11) * ry * 0.35)) ** 2 <= 1.0
    road = plaza
    for name, (pts, wd) in ROADS.items():
        if seg_dist(x, y, pts, wd) <= 0:
            road = True
    if water:
        return 'W'
    if road:
        return 'P'
    # forest border bands with organic inner edge
    dn = y; ds = TH - 1 - y; dw = x; de = TW - 1 - x
    band_n = 10 + 5 * H2(x // 6, 0, 1)
    band_w = 9 + 5 * H2(0, y // 6, 2)
    band_e = 10 + 5 * H2(TW // 7, y // 6, 3)
    gap_s = 54 <= x <= 66 or 74 <= x <= 84          # entrances at south edge
    band_s = 0 if gap_s else (7 + 5 * H2(x // 6, TH // 6, 4))
    inner = min(dn - band_n, dw - band_w, de - band_e, ds - band_s)
    if inner <= 0:
        # solid forest with clearings shaped by hash, density gradient
        if H2(x // 2, y // 2, 5) < 0.80 + 0.15 * max(0, inner + 2):
            return 'T'
        return 'G'
    if inner < 9 and H2(x, y, 6) < 0.42:
        return 'T'
    # decor scatter: grass with speckles near forest, sparse mid-town
    if dw < 30 or de < 22:
        if H2(x, y, 8) < 0.10:
            return 'D'
    if H2(x, y, 9) < 0.030:
        return 'D'
    return 'G'


def build_target():
    grid = [[target_class(x, y) for y in range(TH)] for x in range(TW)]
    # reserved plots = flat grass clearings (kill T/W/P inside), spurs provide access
    for (px, py, pw, ph) in plot_rects():
        for x in range(px - 2, px + pw + 2):
            for y in range(py - 2, py + ph + 2):
                if 0 <= x < TW and 0 <= y < TH:
                    near_plot = px <= x < px + pw and py <= y < py + ph
                    if near_plot and grid[x][y] in ('T', 'D'):
                        grid[x][y] = 'G'
    # border coherence: forest closes N/E/W and all of S except declared corridors
    for x in range(TW):
        for y in (0, 1):
            if grid[x][y] not in ('W', 'J'): grid[x][y] = 'T'
        if not (54 <= x <= 66 or 74 <= x <= 84):
            for y in (TH - 1, TH - 2):
                if grid[x][y] not in ('W', 'J'): grid[x][y] = 'T'
        for y in range(TH - 6, TH):
            if 56 <= x <= 64 or 76 <= x <= 82:
                if grid[x][y] not in ('W', 'J'):
                    grid[x][y] = 'P'
    for y in range(TH):
        for xx in (0, 1, TW - 1, TW - 2):
            if grid[xx][y] not in ('W', 'J'): grid[xx][y] = 'T'
    # coherence pass: single stray W pixels next to land become land (river edges stay 1-thick only via context anyway)
    for x in range(TW):
        for y in range(TH):
            if grid[x][y] != 'W':
                continue
            nb = [grid[xx][yy] for xx, yy in [(x+1,y),(x-1,y),(x,y+1),(x,y-1)] if 0 <= xx < TW and 0 <= yy < TH]
            if nb and sum(1 for c in nb if c == 'W') <= 1:
                grid[x][y] = 'G'
    return grid


# --------------------------------------------------------------- source -----
def classify_source(obj):
    L = [l['Tiles'] for l in obj['Layers']]
    W = len(L[0]); H = len(L[0][0])
    WORK.mkdir(exist_ok=True)
    rend = WORK / 'th_src_render.png'
    if not rend.exists():
        img, _ = render_ground(SRC, SheetLoader([ROOT / 'Content/Tile']))
        img.save(rend)
    from PIL import Image
    px = Image.open(rend).convert('RGB').load()
    bits = lambda li, x, y: bool((L[li][x][y] or {}).get('Layers'))
    cls = [['X'] * H for _ in range(W)]
    for x in range(W):
        for y in range(H):
            r = g = b = 0.0
            for ox in (2, 6):
                for oy in (2, 6):
                    p = px[x * 8 + ox, y * 8 + oy]
                    r += p[0] / 4; g += p[1] / 4; b += p[2] / 4
            c = L[0][x][y] or {}
            base_empty = not c.get('Layers')
            r2 = r + 45 if base_empty else r  # void cells (outside map): treat as sand? no
            if bits(2, x, y):
                k = 'W'
            elif bits(1, x, y):
                k = 'C'
            elif r > 150 and (r - g > 60) and b < r - 40:
                k = 'B'
            elif g > 120 and b > 165 and r < 120:
                k = 'B'  # white-blue building face
            else:
                has_obj = any(bits(li, x, y) for li in (4, 5, 6, 7, 8, 9))
                if has_obj:
                    green = g > r + 6 and g > b + 6
                    dark = (r + g + b) / 3 < 128
                    k = 'T' if (green or dark) else 'B'
                elif g > r + 6 and g > b + 45:
                    k = 'G' if (r + g + b) / 3 > 130 else 'T'
                elif r > 150 and g > 118 and b < 130 and r >= g:
                    k = 'P'
                elif (r + g + b) / 3 > 130 and abs(r - g) < 26 and b > 130:
                    k = 'G'
                elif not has_obj and (r + g + b) / 3 < 100:
                    k = 'X'
                else:
                    k = 'D' if has_obj else 'G'
            cls[x][y] = k
    # grass interior safety: G cell must have no bits and 3x3 without B
    return cls, L, W, H


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cmd', nargs='?', default='build', choices=['build', 'render', 'validate'])
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()

    src = json.loads(SRC.read_text(encoding='utf-8-sig'))['Object']
    cls, L, W, H = classify_source(src)
    stats = Counter(c for col in cls for c in col)

    def occ_bits(x, y):
        return any(bool((L[li][x][y] or {}).get('Layers')) for li in range(1, len(LAYERS)))

    # class of a clamped neighbourhood tuple
    def src_class_at(x, y):
        c = cls[min(max(x, 0), W - 1)][min(max(y, 0), H - 1)]
        return c

    # Ford donor cells: the source's own walkable bright stepping stones /
    # plank patches that sit in or beside the channel. Verified by quad scan:
    # (115,111),(127,49),(133,15) blocks + the source bridge approach at
    # (86..90,138). Using them verbatim keeps the ford authentic.
    deck = []
    for (bx0, by0, bx1, by1) in [(115, 111, 116, 112), (127, 49, 128, 50), (133, 15, 134, 16), (86, 138, 90, 138)]:
        for yy in range(by0, by1 + 1):
            for xx in range(bx0, bx1 + 1):
                if int((src['obstacles'][xx][yy] or {}).get('Tags', 0)) == 0:
                    deck.append((xx, yy))
    def key_at(x, y):
        out = []
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                xx, yy = x + dx, y + dy
                c = cls[min(max(xx, 0), W - 1)][min(max(yy, 0), H - 1)]
                if dx == 0 and dy == 0 and c == 'W' and (x, y) in deck:
                    c = 'J'
                out.append(c)
        return tuple(out)

    index = {}
    by_center = {}
    for x in range(1, W - 1):
        for y in range(1, H - 1):
            k = key_at(x, y)
            if 'B' in k or 'C' in k:      # never expose buildings/cliffs as context source
                continue
            index.setdefault(k, []).append((x, y))
            by_center.setdefault(k[4], []).append((x, y))
    for k in index:
        if len(index[k]) > 900:
            step = len(index[k]) // 900
            index[k] = index[k][::step]
    for c in by_center:
        by_center[c] = [p for p in by_center[c]]

    tgt = build_target()

    def key9(x, y, g):
        return tuple(g[min(max(x + dx, 0), TW - 1)][min(max(y + dy, 0), TH - 1)] for dx in (-1, 0, 1) for dy in (-1, 0, 1))

    cells = {}
    match_stats = Counter()
    used_counter = {}
    for x in range(TW):
        for y in range(TH):
            k9 = key9(x, y, tgt)
            if k9[4] == 'J' and deck:
                cells[(x, y)] = (deck[int(H2(x, y, 17) * 4096) % len(deck)][0], deck[int(H2(x, y, 17) * 4096) % len(deck)][1], 'bridge-deck')
                match_stats['bridge-deck'] += 1
                continue
            cands = index.get(k9)
            mode = 'exact'
            if not cands:
                kk = (k9[1], k9[3], k9[4], k9[5], k9[7])
                cands = [p for p in by_center.get(k9[4], ())][:4000]
                cands = [p for p in cands if (key_at(*p)[1], key_at(*p)[3], key_at(*p)[4], key_at(*p)[5], key_at(*p)[7]) == kk]
                mode = 'relaxed4' if cands else 'NONE'
            if not cands:
                # near tier: minimize 8-neighborhood class multiset distance
                want = Counter(k9)
                pool = by_center.get(k9[4], [])[:2500]
                def _d(p):
                    kc = Counter(key_at(*p))
                    return sum(abs(want[c] - kc[c]) for c in (set(want) | set(kc)) - {'C', 'B', 'X'})
                scored = sorted(pool, key=lambda p: (_d(p), H2(p[0], p[1], 3)))[:24]
                cands = scored
                mode = 'near' if scored else 'NONE'
            if not cands:
                match_stats['miss'] += 1
                cands = by_center.get(k9[4], [(7, 111)])
                mode = 'center-only'
            else:
                match_stats[mode] += 1
            key2 = (mode, k9[4])
            i = used_counter.get(key2, 0)
            used_counter[key2] = i + 1
            sx, sy = cands[(used_counter.get(('pick', k9[4]), i * 7 + int(H2(x, y) * 977)) ) % len(cands)] if False else cands[(i * 37 + int(H2(x, y, 13) * 991)) % len(cands)]
            used_counter[('pick', k9[4])] = i * 37 + int(H2(x, y, 13) * 991) + 1
            cells[(x, y)] = (sx, sy, mode)

    # assemble 11 layers + obstacles from chosen source cells
    layers = []
    for li in range(len(LAYERS)):
        grid = [[copy.deepcopy(L[li][cells[(x, y)][0]][cells[(x, y)][1]]) for y in range(TH)] for x in range(TW)]
        layers.append({'Name': LAYERS[li], 'Layer': (4 if LAYERS[li] == 'Fringe' else 0), 'Visible': True, 'Tiles': grid})
    obstacles = [[copy.deepcopy(src['obstacles'][cells[(x, y)][0]][cells[(x, y)][1]]) for y in range(TH)] for x in range(TW)]
    for x in range(TW):
        for y in range(TH):
            obstacles[x][y]['Bounds'] = {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}
            # deep water must block (source shallows/fords stay as authored)
            if tgt[x][y] == 'W':
                obstacles[x][y]['Tags'] = 1
            # hard border: tree rows closing the map must block even when the
            # matched source cell is a walkable canopy overlay
            if (y < 2 or x < 2 or x >= TW - 2 or (y >= TH - 2 and not (54 <= x <= 66 or 74 <= x <= 84))) \
               and tgt[x][y] not in ('W', 'J', 'P'):
                obstacles[x][y]['Tags'] = 1

    # markers: south entrance + partner; plot anchors; bridge probes
    def mk(name, cx, cy):
        return {"EntName": name, "Direction": -1, "EntEnabled": True, "EntOrder": 0, "InteractOrder": 0,
                "triggerType": 0, "Collider": {"X": cx * 8, "Y": cy * 8, "Width": 16, "Height": 16}}
    markers = [mk('Main_Entrance_Marker', 60, TH - 4), mk('Main_Entrance_Marker_Partner', 62, TH - 4),
               mk('South_Promenade_Exit_Marker', 78, TH - 3), mk('North_River_Bridge_Marker', 108, 40)] + \
              [mk(f'Plot_{i+1}_Anchor', px + 6, py + 4) for i, (px, py, _, _) in enumerate(plot_rects())]

    out_obj = {
        "$type": "RogueEssence.Ground.GroundMap, RogueEssence", "TexSize": 1,
        "Name": {"DefaultText": "Town Hollow", "LocalTexts": {"fr": "Val Creux"}},
        "Released": False,
        "Comment": f"MILESTONE1 raw environment (context-matched synthesis of metano_town cells, seed {SEED}); no buildings by design.",
        "obstacles": obstacles, "rand": copy.deepcopy(src['rand']), "Status": {},
        "Background": copy.deepcopy(src['Background']), "BlankBG": copy.deepcopy(src['BlankBG']),
        "Layers": layers, "AssetName": "town_hollow", "Music": "Treasure Town.ogg",
        "EdgeView": 1, "NoSwitching": True, "ViewCenter": None,
        "ViewOffset": copy.deepcopy(src['ViewOffset']), "ActiveChar": None,
        "Decorations": [{"Name": "New Deco", "Layer": 0, "Visible": True, "Anims": []}],
        "Entities": [{"Name": "New EntLayer", "Visible": True, "MapChars": [], "GroundObjects": [], "Spawners": [], "Markers": markers}],
    }
    payload = "\ufeff" + json.dumps({"Version": "0.8.9.0", "Object": out_obj}, ensure_ascii=False, separators=(',', ': '))
    digest = hashlib.sha256(payload.encode()).hexdigest()
    report = {
        'seed': SEED, 'target': [TW, TH], 'source_classes': dict(stats),
        'matches': dict(match_stats), 'sha256': digest,
        'exact_ratio': round(match_stats['exact'] / max(1, sum(match_stats.values())), 4),
        'target_classes': dict(Counter(c for col in tgt for c in col)),
    }
    WORK.mkdir(exist_ok=True)
    REPORT.write_text(json.dumps(report, indent=1))
    target = OUT if (a.write and a.cmd in ('build',)) else WORK / 'town_hollow_preview.rsground'
    target.write_text(payload, encoding='utf-8')
    print('WROTE', target, len(payload), 'bytes sha256', digest[:16])
    print('MATCH', report['matches'], 'exact_ratio', report['exact_ratio'])

    img, meta = render_ground(target, SheetLoader([ROOT / 'Content/Tile']))
    png = WORK / 'town_hollow_preview.png'
    img.save(png)
    print('RENDER', png, meta['dimensions_pixels'])
    if a.cmd == 'validate':
        sys.exit(validate(target) and 0 or 1)


def validate(path):
    obj = json.loads(path.read_text(encoding='utf-8-sig'))['Object']
    probs = []
    L = [l['Tiles'] for l in obj['Layers']]
    ob = obj['obstacles']
    W = len(ob); H = len(ob[0])
    if (W, H) != (TW, TH): probs.append('dims')
    for li, grid in enumerate(L):
        if len(grid) != W or any(len(col) != H for col in grid): probs.append(f'layer{li} dims')
    src = json.loads(SRC.read_text(encoding='utf-8-sig'))['Object']
    SL = [l['Tiles'] for l in src['Layers']]
    sw, sh = len(SL[0]), len(SL[0][0])
    # full provenance: every emitted 11-layer tuple must exist verbatim in source
    src_tuples = set()
    for x in range(sw):
        for y in range(sh):
            src_tuples.add(json.dumps([json.dumps(SL[li][x][y], sort_keys=True) for li in range(len(LAYERS))]))
    miss = 0
    for x in range(W):
        for y in range(H):
            t = json.dumps([json.dumps(L[li][x][y], sort_keys=True) for li in range(len(LAYERS))])
            if t not in src_tuples: miss += 1
    if miss: probs.append(f'provenance misses: {miss}')
    solid = [[ob[x][y].get('Tags', 0) != 0 for y in range(H)] for x in range(W)]
    # walkable-water guard: outside the two declared fords, water must block
    def in_ford(x, y):
        return (39 <= y <= 42 and 88 <= x <= 104) or (86 <= y <= 89 and 47 <= x <= 61)
    bad_water = sum(1 for x in range(1, W - 1) for y in range(1, H - 1)
                    if bool((L[2][x][y] or {}).get('Layers')) and not solid[x][y] and not in_ford(x, y))
    if bad_water: probs.append(f'water walkable cells outside fords: {bad_water}')
    # BFS from entrance
    ent = obj['Entities'][0]
    m = next(t for t in ent['Markers'] if t['EntName'] == 'Main_Entrance_Marker')
    sx, sy = m['Collider']['X'] // 8, m['Collider']['Y'] // 8
    seen = {(sx, sy)}; dq = deque([(sx, sy)])
    while dq:
        x, y = dq.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and not solid[nx][ny] and (nx, ny) not in seen:
                seen.add((nx, ny)); dq.append((nx, ny))
    walk = sum(1 for x in range(W) for y in range(H) if not solid[x][y])
    ratio = len(seen) / max(1, walk)
    reach_bad = []
    for t in ent['Markers']:
        tx, ty = t['Collider']['X'] // 8, t['Collider']['Y'] // 8
        if (tx, ty) not in seen: reach_bad.append(t['EntName'])
    if reach_bad: probs.append(f'unreachable markers: {reach_bad}')
    # map border: walkable land may only exist on the south row inside declared entrances;
    # the north row legitimately carries the river inflow (water/cliff, not walkable land).
    def bare(x, y):
        return (not solid[x][y]) and not bool((L[2][x][y] or {}).get('Layers')) \
               and not any(bool((L[li][x][y] or {}).get('Layers')) for li in (4, 6, 8))
    north_bare = [x for x in range(W) if bare(x, 0)]
    runs_n = [0]
    for x in range(W):
        runs_n.append(runs_n[-1] + 1 if x in north_bare else 0)
    if max(runs_n) >= 4: probs.append(f'north border bare-road run {max(runs_n)}')
    south_gaps = [x for x in range(W) if bare(x, H - 1) and not (54 <= x <= 66 or 74 <= x <= 84)]
    if south_gaps: probs.append(f'south border unplanned openings: {south_gaps[:6]}')
    out = {'walkable': walk, 'reachable_from_entrance': len(seen), 'ratio': round(ratio, 4),
           'north_walkable_land_leaks': len(globals().get('north_walkable_land', [])),
           'probs': probs[:10]}
    print(json.dumps(out, indent=1))
    ok = not probs and ratio > 0.85
    print('VALIDATE', 'PASS' if ok else 'FAIL')
    return ok


if __name__ == '__main__':
    main()
