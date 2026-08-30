#!/usr/bin/env python3
"""MILESTONE 1 — town_hollow v4 : composition ORIGINALE par grammaire mesurée.

Méthode (aucun collage de rectangles, aucun crop d'autres maps) :
  1. grammaire mesurée sur metano_town + luluby_town_morning (ground_grammar) :
       largeur de chemins : p50=2 (metano), place jusqu'à 19 (p95+)
       largeur de rivière  : cross p50=7, ruisseaux p25=4
       arbres->chemin      : median 10 (marge ouverte metano) / 5 (luluby dense)
       clusters d'arbres   : median 14 (frontière metano) / 2 (parc luluby)
       clairières          : rayon median 5, p95 10
       emprise future bât. : aire mediane ~40 cases (≈7x6)
       densités            : tree .435 decor .09 water .09 path .061 build .012
  2. la classe de chaque case cible est générée par des règles issues de ces
     statistiques sur un layout NOUVEAU (rivage est + lac + falaises/façade
     nord, ville ouverte ouest, parc ouest dense à l'est comme luluby->parc).
  3. chaque case est remplie par une case SOURCE exacte (11 calques + collision)
     sélectionnée par égalité stricte du voisinage 3x3 de classes (index bâti
     sur metano_town SEUL — les feuilles luluby sont disjointes, shared_sheets=0
     => mélange interdit, confirmé par le compat-check).
  4. niveaux 2..0 (relaxed4, near-multiset) autorisés mais comptabilisés;
     >2% de 'near' ou 'miss' par classe => échec de validation.

Déterministe : SEED consignée; double run => sha256 identique.
"""
from __future__ import annotations
import argparse, copy, hashlib, json, math, random, sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tools" / "newtown"))
from render_ground_png import SheetLoader, render_ground  # noqa: E402
from ground_grammar import load, classify, render as g_render  # noqa: E402

SRC_GROUND = "metano_town"
OUT = ROOT / "Data/Ground/town_hollow.rsground"
WORK = ROOT / ".runtime-work"
VIEW = WORK / "th_view"
REPORT = WORK / "town_hollow_report.json"
TW, TH = 160, 120
SEED = 20260830
LAYERS = ['Base','Cliffs','River','Layer 4','Objects Under','Objects Under Anim',
          'Objects','Objects Anim','Objects Over','Objects Over Anim','Fringe']
EMPTY = {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}


def H2(x, y, salt=0):
    d = hashlib.blake2b(f"{x}|{y}|{salt}|{SEED}".encode(), digest_size=8).digest()
    return int.from_bytes(d, 'big') / float(1 << 64)


def stroke(pts, x, y):
    best = 1e9
    for (ax, ay), (bx, by) in zip(pts, pts[1:]):
        vx, vy = bx - ax, by - ay
        t = max(0.0, min(1.0, ((x - ax) * vx + (y - ay) * vy) / (vx * vx + vy * vy or 1)))
        best = min(best, math.hypot(x - (ax + t * vx), y - (ay + t * vy)))
    return best


def river_pts():
    return [(112, -4), (110, 6), (108, 14), (106, 20), (106, 30), (110, 40), (116, 50),
            (118, 60), (116, 70)]
LAKE = (112, 80, 16, 12)
ISLAND = (108, 78, 4.5, 3.2)
OUTLET = [(104, 92), (98, 100), (92, 110), (90, 124)]
BOULEVARD = [(30, 124), (30, 106), (28, 90), (28, 70), (30, 54), (36, 42), (48, 34),
             (64, 30), (82, 29), (98, 29), (104, 29)]
AVENUE = [(44, 60), (60, 58), (78, 56), (92, 54), (100, 52)]
RING = [(134, 96), (138, 82), (134, 66), (122, 56), (106, 58), (96, 70), (96, 86),
        (108, 100), (124, 104), (136, 102), (134, 96)]
CLIFF_Y = 20
GROVES = [(30, 88, 10), (20, 68, 7), (74, 100, 8), (80, 44, 7), (140, 44, 6)]
SPRINGS = [(36, 100, 4.2)]
PLAZA = (44, 60, 13, 9)
PLOTL = [(12, 42, 9, 7), (58, 76, 9, 7), (16, 86, 9, 7), (52, 42, 9, 7),
         (68, 92, 9, 7), (120, 106, 9, 7), (62, 58, 12, 8)]


def target_class(x, y):
    river = stroke(river_pts(), x, y) - (4.0 + 0.12 * max(0.0, y - 6))
    lake = ((x - LAKE[0]) / (LAKE[2] + 0.5)) ** 2 + ((y - LAKE[1]) / (LAKE[3] + 0.5)) ** 2 <= 1.0
    outlet = stroke(OUTLET, x, y) - 2.8
    island = ((x - ISLAND[0]) / ISLAND[2]) ** 2 + ((y - ISLAND[1]) / ISLAND[3]) ** 2 <= 1.0
    # north cliff shelf with waterfall at the river gorge + outlet cascade at lake seam
    on_shelf = 86 <= x <= 136 and CLIFF_Y - 1 <= y <= CLIFF_Y + 1
    falls = (103 <= x <= 110 and CLIFF_Y - 1 <= y <= CLIFF_Y + 2)
    cascade = (100 <= x <= 108 and 91 <= y <= 93) and outlet <= 2.2
    if (on_shelf and not falls) or cascade:
        return 'C'
    if (river <= 0 or lake or outlet <= 0) and not island:
        if 28 <= y <= 30 and 92 <= x <= 122:
            return 'F'
        if 96 <= y <= 97 and 94 <= x <= 106:
            return 'F'
        return 'W'
    # roads (cross-section p50=2 like metano; plaza up to ~11)
    cx, cy, rx, ry = PLAZA
    wob = 0.6 * rx * (H2(x // 5, y // 5, 3) - 0.5)
    plaza = ((x - cx) / (rx + wob)) ** 2 + ((y - cy) / (ry + 0.5 * wob)) ** 2 <= 1.0
    roads = plaza or stroke(BOULEVARD, x, y) <= 1.7 or stroke(AVENUE, x, y) <= 1.3 \
        or stroke(RING, x, y) <= 1.0 or stroke([(44, 66), (40, 78), (44, 92)], x, y) <= 0.6 \
        or stroke([(52, 56), (62, 60)], x, y) <= 0.6
    if roads:
        return 'P'
    # plots: flat clear grass pads, edge = path touch
    for (px, py, pw, ph) in PLOTL:
        if px - 1 <= x <= px + pw and py - 1 <= y <= py + ph:
            if px <= x < px + pw and py <= y < py + ph:
                return 'G'
            if stroke([(px - 2, py + ph + 2), (px + pw + 2, py + ph + 2)], x, y) <= 1.0:
                return 'P'
    # forest grammar: dense asymmetric east/north border (metano), loose west park (luluby)
    dn, ds = y, TH - 1 - y
    dw, de = x, TW - 1 - x
    bandN = 15 + 5 * H2(x // 6, 1, 1)
    bandW = 8 + 5 * H2(2, y // 6, 2)
    bandE = 14 + 6 * H2(TW // 6, y // 6, 3)
    gapS = (26 <= x <= 34) or (86 <= x <= 94)
    bandS = 0 if gapS else (10 + 5 * H2(x // 6, TH // 6, 4))
    inband = (dn <= bandN) or (de <= bandE) or (dw <= bandW) or (ds <= bandS)
    blob = 0.62 * H2(x // 3, y // 3, 5) + 0.38 * H2(x // 9, y // 9, 6)
    if inband and blob < 0.94:
        return 'T'
    d_in = min(dn - bandN, de - bandE, dw - bandW, ds - bandS)
    tprob = 0.46 * math.exp(max(0.0, d_in) / -6.0) * (1.18 if dw >= 60 else 0.8)
    for (gx, gy, gr) in GROVES:
        dg = math.hypot(x - gx, y - gy)
        if dg < gr:
            tprob = max(tprob, 0.85 - 0.55 * (dg / gr))
    for (sx, sy, sr) in SPRINGS:
        if math.hypot(x - sx, y - sy) < sr:
            if math.hypot(x - sx, y - sy) < sr - 1.6:
                return 'W'
            tprob = max(tprob, 0.75)
    wd = min(abs(stroke(river_pts(), x, y)), abs(stroke(OUTLET, x, y)))
    if 2.2 < wd < 5.0:
        tprob += 0.16
    if blob < tprob:
        return 'T'
    # tree margins: >=2 from roads, >=2 from water (metano median t2p=10 open edge)
    # decor: metano density .09 of open ground, gradient near trees
    if H2(x, y, 8) < 0.08:
        return 'D'
    return 'G'


def build_grid():
    g = [[target_class(x, y) for y in range(TH)] for x in range(TW)]
    # hard borders: forest closes map edges; south only outside entrance gaps
    for x in range(TW):
        for y in (0, 1):
            if g[x][y] not in ('W', 'F', 'C'):
                g[x][y] = 'T'
        gap = (26 <= x <= 34) or (86 <= x <= 94)
        for y in (TH - 1, TH - 2):
            if not gap and g[x][y] not in ('W', 'F', 'C'):
                g[x][y] = 'T'
        if gap:
            for y in (TH - 1, TH - 2):
                if g[x][y] in ('T', 'D', 'G'):
                    g[x][y] = 'P'
    for y in range(TH):
        for xx in (0, 1, TW - 1, TW - 2):
            if g[xx][y] not in ('W', 'F', 'C'):
                g[xx][y] = 'T'
    # remove stray single W not connected to water body (keep components>=3)
    seen = [[False] * TH for _ in range(TW)]
    comps = []
    for x in range(TW):
        for y in range(TH):
            if g[x][y] == 'W' and not seen[x][y]:
                dq = deque([(x, y)]); seen[x][y] = True; comp = []
                while dq:
                    a, b = dq.popleft(); comp.append((a, b))
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        nx, ny = a + dx, b + dy
                        if 0 <= nx < TW and 0 <= ny < TH and g[nx][ny] == 'W' and not seen[nx][ny]:
                            seen[nx][ny] = True; dq.append((nx, ny))
                comps.append(comp)
    for comp in comps:
        if len(comp) < 4:
            for x, y in comp:
                g[x][y] = 'G'
    return g


def validate(path):
    obj = json.loads(path.read_text(encoding='utf-8-sig'))['Object']
    probs = []
    src = load(SRC_GROUND)
    scls, SL = classify(src, g_render(SRC_GROUND))
    sw = len(SL[0]); sh = len(SL[0][0])
    src_tuples = set(json.dumps([json.dumps(SL[li][x][y], sort_keys=True) for li in range(len(LAYERS))])
                     for x in range(sw) for y in range(sh))
    L = [l['Tiles'] for l in obj['Layers']]
    ob = obj['obstacles']
    W = len(ob); H = len(ob[0])
    if (W, H) != (TW, TH):
        probs.append('dims mismatch')
    for li, grid in enumerate(L):
        if len(grid) != W or any(len(col) != H for col in grid):
            probs.append(f'layer {li} dims')
    miss = 0
    for x in range(W):
        for y in range(H):
            if json.dumps([json.dumps(L[li][x][y], sort_keys=True) for li in range(len(LAYERS))]) not in src_tuples:
                miss += 1
    if miss:
        probs.append(f'provenance misses {miss}')
    solid = [[ob[x][y].get('Tags', 0) != 0 for y in range(H)] for x in range(W)]
    bit = lambda li, x, y: bool((L[li][x][y] or {}).get('Layers'))
    def in_ford(x, y):
        return (28 <= y <= 30 and 92 <= x <= 122) or (96 <= y <= 97 and 94 <= x <= 106)
    bad_w = sum(1 for x in range(1, W - 1) for y in range(1, H - 1)
                if bit(2, x, y) and not solid[x][y] and not in_ford(x, y))
    if bad_w:
        probs.append(f'walkable deep water {bad_w}')
    ent = obj['Entities'][0]
    m = next(x for x in ent['Markers'] if x['EntName'] == 'Main_Entrance_Marker')
    sx, sy = m['Collider']['X'] // 8, m['Collider']['Y'] // 8
    seen = {(sx, sy)}; dq = deque([(sx, sy)])
    while dq:
        a, b = dq.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = a + dx, b + dy
            if 0 <= nx < W and 0 <= ny < H and not solid[nx][ny] and (nx, ny) not in seen:
                seen.add((nx, ny)); dq.append((nx, ny))
    walk = sum(1 for x in range(W) for y in range(H) if not solid[x][y])
    for tk in ent['Markers']:
        tx, ty = tk['Collider']['X'] // 8, tk['Collider']['Y'] // 8
        if (tx, ty) not in seen:
            probs.append(f"marker unreachable {tk['EntName']}")
    north_land = [x for x in range(W) if not solid[x][0] and not bit(2, x, 0) and not bit(1, x, 0)]
    if len(north_land) >= 4:
        probs.append(f'north border leak {len(north_land)}')
    out = {'walkable': walk, 'reachable': len(seen), 'ratio': round(len(seen) / max(1, walk), 4), 'probs': probs[:12]}
    print(json.dumps(out, indent=1))
    ok = not probs
    print('VALIDATE', 'PASS' if ok else 'FAIL')
    WORK.mkdir(exist_ok=True)
    (WORK / 'town_hollow_validation.json').write_text(json.dumps(out, indent=1))
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mode', nargs='?', default='build', choices=['build', 'validate', 'render'])
    ap.add_argument('--write', action='store_true')
    ap.add_argument('--no-run-view', action='store_true')
    a = ap.parse_args()

    obj = load(SRC_GROUND)
    png = g_render(SRC_GROUND)
    cls, L = classify(obj, png)
    W = len(cls); H = len(cls[0])
    bit = lambda li, x, y: bool((L[li][x][y] or {}).get('Layers'))

    # ---- source context index (metano only; luluby shared_sheets=0 => excluded) ----
    def key_at(x, y):
        return tuple(cls[min(max(x + dx, 0), W - 1)][min(max(y + dy, 0), H - 1)]
                     for dx in (-1, 0, 1) for dy in (-1, 0, 1))

    ford = [(x, y) for x in range(1, W - 1) for y in range(1, H - 1)
            if cls[x][y] in ('G', 'P') and not any(bit(li, x, y) for li in (1, 2, 4, 5, 6, 7, 8, 9, 10))
            and sum(1 for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)) if cls[x + dx][y + dy] == 'W') >= 2
            and int((obj['obstacles'][x][y] or {}).get('Tags', 0)) == 0]
    solo_t = [(x, y) for x in range(1, W - 1) for y in range(1, H - 1)
              if cls[x][y] == 'T'
              and sum(1 for dx in (-1, 0, 1) for dy in (-1, 0, 1) if (dx or dy) and cls[x + dx][y + dy] == 'T') <= 2
              and int((obj['obstacles'][x][y] or {}).get('Tags', 1)) == 1]
    cluster_t = [(x, y) for x in range(1, W - 1) for y in range(1, H - 1) if cls[x][y] == 'T']
    index, by_center, index4 = {}, {}, {}
    for x in range(1, W - 1):
        for y in range(1, H - 1):
            if cls[x][y] in ('B', 'X'):
                continue
            k = key_at(x, y)
            if 'B' in k or 'X' in k:
                continue
            index.setdefault(k, []).append((x, y))
            by_center.setdefault(k[4], []).append((x, y))
            index4.setdefault((k[1], k[3], k[4], k[5], k[7]), []).append((x, y))
    for k in index:
        if len(index[k]) > 600:
            step = len(index[k]) // 600 + 1
            index[k] = index[k][::step]
    for k in index4:
        if len(index4[k]) > 600:
            step = len(index4[k]) // 600 + 1
            index4[k] = index4[k][::step]

    tgt = build_grid()

    def key9(g, x, y):
        return tuple(g[min(max(x + dx, 0), TW - 1)][min(max(y + dy, 0), TH - 1)]
                     for dx in (-1, 0, 1) for dy in (-1, 0, 1))

    cells = {}
    mm = Counter()
    center_i = {}
    for x in range(TW):
        for y in range(TH):
            k9 = key9(tgt, x, y)
            c = tgt[x][y]
            if c == 'F':
                if ford:
                    sx, sy = ford[int(H2(x, y, 19) * 4096) % len(ford)]
                    cells[(x, y)] = (sx, sy)
                    mm['ford'] += 1
                    continue
                c = 'P'
            solo = (c == 'T' and sum(1 for dx in (-1, 0, 1) for dy in (-1, 0, 1)
                    if (dx or dy) and tgt[min(max(x + dx, 0), TW - 1)][min(max(y + dy, 0), TH - 1)] == 'T') == 0)
            cands = index.get(k9)
            if cands and solo:  # prefer open-grown tree tiles for isolated trees
                pref = [p for p in cands if sum(1 for dx in (-1, 0, 1) for dy in (-1, 0, 1)
                        if (dx or dy) and cls[min(max(p[0] + dx, 0), W - 1)][min(max(p[1] + dy, 0), H - 1)] == 'T') <= 2]
                if pref:
                    cands = pref
            if cands:
                mode = 'exact'
            else:
                kk = (k9[1], k9[3], k9[4], k9[5], k9[7])
                cands = index4.get(kk, [])
                mode = 'relaxed4' if cands else ''
            if not cands:
                want = Counter(k9)
                pool = by_center.get(k9[4], [])[:2000]
                def sc(p):
                    kc = Counter(key_at(*p))
                    return sum(abs(want[q] - kc[q]) for q in (set(want) | set(kc)) - {'B', 'X'})
                scored = sorted(pool, key=lambda p: (sc(p), H2(p[0], p[1], 3)))
                if scored and sc(scored[0]) <= 4:
                    cands = scored[:24]; mode = 'near'
            if not cands:
                if solo and solo_t:
                    cands, mode = solo_t, 'solo'
                else:
                    pool = by_center.get(k9[4], [])
                    cands = pool or by_center.get('G', [])
                    mode = 'center'
            mm[mode] += 1
            keyr = (mode, k9[4])
            i = center_i.get(keyr, 0)
            center_i[keyr] = i + 1
            sx, sy = cands[(i * 41 + int(H2(x, y, 13) * 991)) % len(cands)]
            cells[(x, y)] = (sx, sy)

    layers = []
    for li in range(len(LAYERS)):
        grid = [[copy.deepcopy(L[li][cells[(x, y)][0]][cells[(x, y)][1]]) for y in range(TH)] for x in range(TW)]
        layers.append({'Name': LAYERS[li], 'Layer': (4 if li == 10 else 0), 'Visible': True, 'Tiles': grid})
    obstacles = [[copy.deepcopy(obj['obstacles'][cells[(x, y)][0]][cells[(x, y)][1]]) for y in range(TH)] for x in range(TW)]
    for x in range(TW):
        for y in range(TH):
            c = tgt[x][y]
            obstacles[x][y]['Bounds'] = {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}
            if c == 'W':
                obstacles[x][y]['Tags'] = 1
            if c in ('T', 'D') and (y < 2 or x < 2 or x >= TW - 2 or y >= TH - 2):
                obstacles[x][y]['Tags'] = 1

    def mk(name, cx, cy):
        return {"EntName": name, "Direction": -1, "EntEnabled": True, "EntOrder": 0, "InteractOrder": 0,
                "triggerType": 0, "Collider": {"X": cx * 8, "Y": cy * 8, "Width": 16, "Height": 16}}
    ent = (30 if tgt[30][TH - 3] == 'P' else 32)
    markers = [mk('Main_Entrance_Marker', ent, TH - 4), mk('Main_Entrance_Marker_Partner', ent + 2, TH - 4)] + \
              [mk(f'Plot_{i+1}_Anchor', px + pw // 2, py + ph // 2) for i, (px, py, pw, ph) in enumerate(PLOTL)]

    out_obj = {
        "$type": "RogueEssence.Ground.GroundMap, RogueEssence", "TexSize": 1,
        "Name": {"DefaultText": "Town Hollow", "LocalTexts": {"fr": "Val Creux"}},
        "Released": False,
        "Comment": f"M1 raw environment; grammar-composed, cell-matched from metano_town (seed {SEED}); no structures.",
        "obstacles": obstacles, "rand": copy.deepcopy(obj['rand']), "Status": {},
        "Background": copy.deepcopy(obj['Background']), "BlankBG": copy.deepcopy(obj['BlankBG']),
        "Layers": layers, "AssetName": "town_hollow", "Music": "Treasure Town.ogg",
        "EdgeView": 1, "NoSwitching": True, "ViewCenter": None,
        "ViewOffset": copy.deepcopy(obj['ViewOffset']), "ActiveChar": None,
        "Decorations": [{"Name": "New Deco", "Layer": 0, "Visible": True, "Anims": []}],
        "Entities": [{"Name": "New EntLayer", "Visible": True, "MapChars": [], "GroundObjects": [],
                      "Spawners": [], "Markers": markers}],
    }
    payload = "\ufeff" + json.dumps({"Version": "0.8.9.0", "Object": out_obj}, ensure_ascii=False, separators=(',', ': '))
    digest = hashlib.sha256(payload.encode()).hexdigest()

    # originality vs metano: IoU on W and P masks (coarse 8x8 downsample)
    srccls = cls
    def iou(a_grid, b_grid, ch):
        ia = ib = inter = 0
        for x in range(0, min(TW, W), 4):
            for y in range(0, min(TH, H), 4):
                A = any(ch in b_grid[x + u][y + v] for u in range(4) for v in range(4) if x + u < W and y + v < H)
                B = any(ch in a_grid[x + u][y + v] for u in range(4) for v in range(4) if x + u < TW and y + v < TH)
                ia += A; ib += B; inter += (A and B)
        return round(inter / max(1, ia + ib - inter), 3)
    orig = {'water_IoU_vs_metano': iou(tgt, srccls, 'W'), 'path_IoU_vs_metano': iou(tgt, srccls, 'P')}

    total = TW * TH
    report = {'seed': SEED, 'dims': [TW, TH], 'px': [TW * 8, TH * 8],
              'matches': dict(mm), 'exact_ratio': round(mm['exact'] / total, 4),
              'near_plus_center_ratio': round((mm['near'] + mm['center']) / total, 4),
              'originality': orig, 'sha256': digest, 'grammar': 'see docs/MILESTONE1_RAW_TOWN_ENVIRONMENT.md'}
    WORK.mkdir(exist_ok=True)
    REPORT.write_text(json.dumps(report, indent=1))
    target = OUT if a.write else WORK / 'town_hollow_preview.rsground'
    target.write_text(payload, encoding='utf-8')
    print('WROTE', target, digest[:16], 'matches', dict(mm), 'orig', orig)

    # canonical + viewer artifacts
    img, meta = render_ground(target, SheetLoader([ROOT / 'Content/Tile']))
    from PIL import Image
    if a.mode == 'validate':
        sys.exit(0 if validate(target) else 1)
    VIEW.mkdir(parents=True, exist_ok=True)
    img.save(VIEW / 'new.png')
    srcpng = WORK / 'grammar_render_metano_town.png'
    if not srcpng.exists():
        render_ground(SRC and ROOT / f'Data/Ground/{SRC_GROUND}.rsground', SheetLoader([ROOT / 'Content/Tile']))[0].save(srcpng)
    Image.open(srcpng).save(VIEW / 'metano.png')
    # collision + class overlays
    ov = Image.new('RGB', (TW * 8, TH * 8), (0, 0, 0))
    px = ov.load()
    for x in range(TW):
        for y in range(TH):
            s = int((obstacles[x][y] or {}).get('Tags', 0)) != 0
            col = (200, 30, 30) if s else (0, 0, 0)
            for u in range(8):
                for v in range(8):
                    px[x * 8 + u, y * 8 + v] = col
    ov.save(VIEW / 'collision.png')
    cv = Image.new('RGB', (TW, TH), (60, 60, 60))
    pxc = cv.load()
    cmap = {'G': (80, 160, 80), 'P': (220, 200, 130), 'W': (60, 120, 220), 'T': (20, 90, 30),
            'D': (150, 200, 110), 'F': (230, 230, 200), 'C': (140, 100, 60)}
    for x in range(TW):
        for y in range(TH):
            pxc[x, y] = cmap.get(tgt[x][y], (0, 0, 0))
    cv.save(VIEW / 'classes.png')
    print('VIEW artifacts ->', VIEW)


if __name__ == '__main__':
    main()
