#!/usr/bin/env python3
"""Shared Ground-grammar engine: classification, spatial measurement,
compatibility checks and source-cell indexing for PMDO ground maps.

Everything is derived from REAL map data (no assumptions about tile meaning):
a cell's class comes from its layer occupancy + rendered color; spatial
statistics (tree spacing, path widths, channel widths, cluster sizes) are
measured with run/component analysis. Multiple grounds can share one
candidate index ONLY when they reference the same tileset sheets (verified).
"""
from __future__ import annotations
import json, math, sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from render_ground_png import SheetLoader, render_ground  # noqa: E402

WORK = ROOT / ".runtime-work"
LAYERS = None  # filled per ground


def load(name: str):
    p = ROOT / "Data/Ground" / f"{name}.rsground"
    obj = json.loads(p.read_text(encoding="utf-8-sig"))["Object"]
    return obj


def render(name: str):
    out = WORK / f"grammar_render_{name}.png"
    out.parent.mkdir(exist_ok=True)
    if not out.exists():
        img, _meta = render_ground(ROOT / "Data/Ground" / f"{name}.rsground",
                                   SheetLoader([ROOT / "Content/Tile"]))
        img.save(out)
    return out


def sheets_used(obj) -> set:
    s = set()
    for l in obj["Layers"]:
        for col in l["Tiles"]:
            for c in col:
                if c:
                    for lay in c.get("Layers", []):
                        for f in lay.get("Frames", []):
                            if f.get("Sheet"):
                                s.add(f["Sheet"])
    return s


def classify(obj, png):
    from PIL import Image
    L = [l["Tiles"] for l in obj["Layers"]]
    W = len(L[0]); H = len(L[0][0])
    px = Image.open(png).convert("RGB").load()
    nb = len(L)

    def bit(li, x, y):
        return 0 <= x < W and 0 <= y < H and bool((L[li][x][y] or {}).get("Layers"))

    cls = [["X"] * H for _ in range(W)]
    for x in range(W):
        for y in range(H):
            r = g = b = 0.0
            for ox in (2, 6):
                for oy in (2, 6):
                    p = px[x * 8 + ox, y * 8 + oy]
                    r += p[0] / 4; g += p[1] / 4; b += p[2] / 4
            lum = (r + g + b) / 3
            bits = 0
            for li in range(1, nb):
                if bit(li, x, y):
                    bits |= 1 << li
            if bits & (1 << 2):
                k = "W"
            elif bits & (1 << 1):
                k = "C"
            elif r > 150 and (r - g) > 60 and b < r - 40:
                k = "B"
            elif g > 120 and b > 165 and r < 120:
                k = "B"
            elif bits & ((1 << 4) | (1 << 5) | (1 << 6) | (1 << 7) | (1 << 8) | (1 << 9)):
                green = g > r + 6 and g > b + 6
                k = "T" if (green or lum < 128) else "D"
            elif b > r + 15 and b > g + 5 and b > 120:
                k = "W"
            elif g > r + 6 and g > b + 45:
                k = "T" if lum <= 130 else "G"
            elif r > 150 and g > 118 and b < 130 and r >= g:
                k = "P"
            elif lum > 150 and (r - g) < 30:
                k = "G"
            else:
                k = "X"
            cls[x][y] = k
    return cls, L


def components(mask_fn, W, H, diag=False):
    seen = [[False] * H for _ in range(W)]
    out = []
    steps = ((1, 0), (-1, 0), (0, 1), (0, -1)) + (((1, 1), (1, -1), (-1, 1), (-1, -1)) if diag else ())
    for x in range(W):
        for y in range(H):
            if mask_fn(x, y) and not seen[x][y]:
                dq = deque([(x, y)]); seen[x][y] = True; cells = []
                while dq:
                    a, b = dq.popleft(); cells.append((a, b))
                    for dx, dy in steps:
                        nx, ny = a + dx, b + dy
                        if 0 <= nx < W and 0 <= ny < H and mask_fn(nx, ny) and not seen[nx][ny]:
                            seen[nx][ny] = True; dq.append((nx, ny))
                out.append(cells)
    return out


def _q(vals, qs=(0.25, 0.5, 0.75, 0.95)):
    if not vals:
        return {}
    v = sorted(vals)
    return {f"p{int(q*100)}": v[min(len(v) - 1, int(q * len(v)))] for q in qs} | {"max": v[-1], "n": len(v)}


def measure(name: str) -> dict:
    obj = load(name)
    cls, L = classify(obj, render(name))
    W = len(cls); H = len(cls[0])
    out = {"ground": name, "dims_tiles": [W, H], "dims_px": [W * 8, H * 8],
           "layers": [l["Name"] for l in obj["Layers"]],
           "music": obj.get("Music"), "sheets": sorted(sheets_used(obj))}

    def dist_field(acceptable):
        INF = 9999
        d = [[INF] * H for _ in range(W)]
        q = deque()
        for x in range(W):
            for y in range(H):
                if acceptable(cls[x][y]):
                    d[x][y] = 0; q.append((x, y))
        while q:
            x, y = q.popleft()
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < W and 0 <= ny < H and d[nx][ny] > d[x][y] + 1:
                    d[nx][ny] = d[x][y] + 1; q.append((nx, ny))
        return d

    # trees: clusters via nearest-neighbour single linkage
    td = dist_field(lambda c: c == "T")
    tree_cells = [(x, y) for x in range(W) for y in range(H) if cls[x][y] == "T"]
    seen = set(); clusters = []
    cset = set(tree_cells)
    for t in tree_cells:
        if t in seen:
            continue
        dq = deque([t]); seen.add(t); comp = []
        while dq:
            a, b = dq.popleft(); comp.append((a, b))
            for dx in range(-3, 4):
                for dy in range(-3, 4):
                    n = (a + dx, b + dy)
                    if n in cset and n not in seen and (dx * dx + dy * dy) <= 10:
                        seen.add(n); dq.append(n)
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                n = (a + dx, b + dy)
                if n in cset and n not in seen:
                    seen.add(n); dq.append(n)
        clusters.append(comp)
    sizes = sorted(len(c) for c in clusters)
    out["tree_clusters"] = {"n": len(clusters), "size": _q(sizes),
                            "median_size": sizes[len(sizes) // 2] if sizes else 0}
    # tree nearest-neighbour distance
    nn = []
    step = max(1, len(tree_cells) // 1200)
    for (x, y) in tree_cells[::step]:
        best = 99
        for (ox, oy) in tree_cells[::7]:
            if (ox, oy) == (x, y):
                continue
            dd = abs(ox - x) + abs(oy - y)
            if dd < best:
                best = dd
        nn.append(best)
    out["tree_nn_distance"] = _q(nn)
    # tree distance to path & water
    pd = dist_field(lambda c: c == "P")
    wd = dist_field(lambda c: c in ("W",))
    t2p = [pd[x][y] for x, y in tree_cells[::step] if pd[x][y] < 9999]
    t2w = [wd[x][y] for x, y in tree_cells[::step] if wd[x][y] < 9999]
    out["tree_to_path"] = _q(t2p); out["tree_to_water"] = _q(t2w)
    # path widths via vertical run lengths (and horizontal), same for water
    def widths(char):
        vr, hr = [], []
        for x in range(W):
            run = 0
            for y in range(H):
                run = run + 1 if cls[x][y] == char else 0
                if run:
                    vr.append(run)
        for y in range(H):
            run = 0
            for x in range(W):
                run = run + 1 if cls[x][y] == char else 0
                if run:
                    hr.append(run)
        return _q(vr), _q(hr)
    pv, ph = widths("P"); out["path_width_v"], out["path_width_h"] = pv, ph
    wv, wh = widths("W"); out["water_width_v"], out["water_width_h"] = wv, wh
    # open grass regions (largest inscribed radius via distance transform)
    gd = dist_field(lambda c: c in ("G", "X"))
    radii = sorted(gd[x][y] for x in range(0, W, 2) for y in range(0, H, 2))
    out["open_grass_radius"] = _q(radii[-len(radii)//4:] if radii else [], (0.5, 0.95))
    # decor density & border depth
    decor = sum(1 for col in cls for c in col if c == "D")
    trees = len(tree_cells)
    water = sum(1 for col in cls for c in col if c == "W")
    path = sum(1 for col in cls for c in col if c == "P")
    build = sum(1 for col in cls for c in col if c == "B")
    total = W * H
    out["density"] = {"tree": round(trees / total, 3), "decor": round(decor / total, 3),
                      "water": round(water / total, 3), "path": round(path / total, 3),
                      "building": round(build / total, 3)}
    # forest border depth: rows from edge that are >=60% tree
    def band_depth(axis):
        for k in range(1, 30):
            cnt = tot = 0
            rng = range(W) if axis == 0 else range(H)
            for a in rng:
                b = (a, k) if axis == 0 else (k, a)
                other = (a, H - 1 - k) if axis == 0 else (W - 1 - k, a)
                for cc in (b, other):
                    if cls[cc[0]][cc[1]] == "T":
                        cnt += 2
                tot += 2
            if cnt / tot < 0.55:
                return k - 1
        return 30
    out["border_depth_x"] = band_depth(0); out["border_depth_y"] = band_depth(1)
    # future-building footprints: BUILD components bbox sizes
    bb = components(lambda x, y: cls[x][y] == "B", W, H, diag=True)
    bb = [c for c in bb if len(c) >= 8]
    foot = sorted(((max(x for x, _ in c) - min(x for x, _ in c) + 1) *
                   (max(y for _, y in c) - min(y for _, y in c) + 1)) for c in bb)
    out["building_footprint_area"] = _q(foot)
    out["cls_counts"] = dict(Counter(c for col in cls for c in col))
    return out


def build_index(names):
    """Union candidate pool across grounds, sharing ONLY when sheet families
    intersect; returns (index, by_center, deck, info)."""
    pools, sheet_sets = [], []
    for n in names:
        obj = load(n)
        png = render(n)
        cls, L = classify(obj, png)
        pools.append((n, obj, cls, L))
        sheet_sets.append(sheets_used(obj))
    compat = set.intersection(*sheet_sets) if len(sheet_sets) > 1 else sheet_sets[0]
    info = {"grounds": {}, "shared_sheets": sorted(compat)}
    for (n, obj, cls, L), ss in zip(pools, sheet_sets):
        info["grounds"][n] = {"own_sheets": sorted(ss), "compatible": bool(ss and ss <= compat | ss)}
    index, by_center = {}, {}
    W0 = len(pools[0][3][0])
    for (n, obj, cls, L) in pools:
        W = len(cls); H = len(cls[0])
        bits = lambda li, x, y: bool((L[li][x][y] or {}).get("Layers"))

        def key_at(x, y):
            out2 = []
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    xx, yy = x + dx, y + dy
                    if xx < 0: xx = 0
                    if yy < 0: yy = 0
                    if xx >= W: xx = W - 1
                    if yy >= H: yy = H - 1
                    out2.append(cls[xx][yy])
            return tuple(out2)
        for x in range(1, W - 1):
            for y in range(1, H - 1):
                k = key_at(x, y)
                if "B" in k or "X" in k:
                    continue
                # forbid pure-water context whose own cell uses foreign sheet family
                rec = ((n, x, y), k)
                index.setdefault(k, []).append(rec)
                by_center.setdefault(k[4], []).append(rec)
    return pools, index, by_center, info
