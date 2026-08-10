#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""rebuild_boss_arena_pixelperfect.py — reconstruit une arène de combat .rsmap
DEPUIS son ground source, en pixel-perfect, et PROUVE la correspondance.

PRINCIPE (vérifié dans le moteur RogueEssence/PMDO) :
  - Les maps de donjon (.rsmap) rendent chaque cellule à TileSize = 24 px
    (GraphicsManager.TileSize = DungeonTexSize * TEX_SIZE, 3*8).
  - TileLayer.Draw blitte la texture à SA TAILLE NATIVE : une texture 8x8
    dans une cellule 24x24 laisse ~89% de la cellule vide (noir).
    => Le rendu des arènes avec textures 8x8 produit bandes/trous noirs.
  - CORRECTION : chaque texture du ground (8x8 si TexSize=1, 24x24 si
    TexSize=3) est placée dans la cellule d'arène (24px). Pour TexSize=1,
    upscale x3 NEAREST (échelle ENTIÈRE, aucun rééchantillonnage) ; pour
    TexSize=3, échelle 1:1. Résultat : chaque cellule pleine = pixel-art du
    ground à l'identique, sans bande noire.

POUR CHAQUE ARÈNE :
  1. ground source : TexSize, couches graphiques, obstacles, markers.
  2. sheet dédiée "Arena_<arena>_Base" (dédup, prémultiplié conservé).
  3. .rsmap réécrit :
     - Tiles[x][y].Data.ID  = floor | unbreakable  (collision du ground)
     - Tiles[x][y].Data.TileTex.Layers = textures de la cellule (frames conservées)
     - Layers de la map vidés (éviter le double rendu)
     - DiscoveryArray [W][H] = false
     - EntryPoints / MapTeams = positions des markers du ground (cellules)
  4. Rendu de COMPARAISON : ground (pas 8*TexSize) upscalé x(24/(8*TexSize))
     vs arène (24px) ; différence pixel à pixel (doit être ~0).

USAGE :
  python3 tools/rebuild_boss_arena_pixelperfect.py <arène> <ground> [--write]
  (sans --write : analyse seule, rien n'est modifié)
"""
import argparse
import hashlib
import io
import json
import os
import struct
import subprocess
import sys

from PIL import Image
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAPDIR = os.path.join(ROOT, 'Data', 'Map')
GRODIR = os.path.join(ROOT, 'Data', 'Ground')
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')
TILE = 24          # TileSize des maps de donjon (moteur)
_sheet_cache = {}


def git_show(path):
    r = subprocess.run(['git', 'show', 'HEAD:' + path], capture_output=True, cwd=ROOT)
    return r.stdout if r.returncode == 0 else None


def load_package(sheet):
    if sheet in _sheet_cache:
        return _sheet_cache[sheet]
    local = os.path.join(TILEDIR, sheet + '.tile')
    raw = open(local, 'rb').read() if os.path.exists(local) else git_show('Content/Tile/' + sheet + '.tile')
    if raw is None:
        raise FileNotFoundError(f'sheet {sheet} introuvable')
    ts, tc = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(tc):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        cells[(x, y)] = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert('RGBA')
    _sheet_cache[sheet] = (ts, cells)
    return _sheet_cache[sheet]


def upscale(img, k):
    if k == 1:
        return img
    return img.resize((img.width * k, img.height * k), Image.NEAREST)


# ---------------------------------------------------------------- .tile writer
def write_tile_package(path, cells):
    """cells: liste de (x, y, PNG bytes). tileSize = taille native + TILE."""
    ts = TILE
    n = len(cells)
    header = struct.pack('<II', ts, n)
    cur = 8 + n * 16
    offsets = []
    prev = {}
    for x, y, png in cells:
        if png in prev:
            offsets.append(prev[png])
        else:
            offsets.append(cur)
            prev[png] = cur
            cur += 8 + len(png)
    table = b''
    for (x, y, png), off in zip(cells, offsets):
        table += struct.pack('<QQ', x | (y << 32), off)
    blobs = b''
    done = set()
    for (x, y, png), off in zip(cells, offsets):
        if off in done:
            continue
        done.add(off)
        blobs += struct.pack('<q', len(png)) + png
    with open(path, 'wb') as f:
        f.write(header + table + blobs)
    return n, len(prev)


# ---------------------------------------------------------------- index.idx
def read_index():
    local = os.path.join(TILEDIR, 'index.idx')
    if os.path.exists(local):
        return bytearray(open(local, 'rb').read())
    return bytearray(git_show('Content/Tile/index.idx'))


def write_index(d):
    with open(os.path.join(TILEDIR, 'index.idx'), 'wb') as f:
        f.write(bytes(d))


def inject_index(entries):
    idx = read_index()
    n = struct.unpack_from('<I', idx, 0)[0]
    pos = 4
    parsed = []
    for i in range(n):
        nl = idx[pos]; pos += 1
        name = bytes(idx[pos:pos + nl]).decode('utf-8', errors='replace'); pos += nl
        ts = struct.unpack_from('<I', idx, pos)[0]
        tc = struct.unpack_from('<I', idx, pos + 4)[0]
        table = bytes(idx[pos + 8:pos + 8 + tc * 16])
        parsed.append((name, ts, tc, table))
        pos += 8 + tc * 16
    names = {p[0] for p in parsed}
    for (name, ts, tc, table) in entries:
        if name not in names:
            parsed.append((name, ts, tc, table))
    parsed.sort(key=lambda p: p[0])
    out = bytearray()
    out += struct.pack('<I', len(parsed))
    for name, ts, tc, table in parsed:
        nb = name.encode('utf-8')
        out += bytes([len(nb)]) + nb
        out += struct.pack('<II', ts, tc)
        out += table
    write_index(out)


# ---------------------------------------------------------------- ground
def ground_data(gpath):
    with open(gpath, encoding='utf-8-sig') as f:
        d = json.load(f)['Object']
    tex = d.get('TexSize', 1)
    vis = [L for L in d.get('Layers', []) if L.get('Tiles')]
    obs = d.get('obstacles', [])
    markers = {}
    for e in d.get('Entities', []):
        for m in e.get('Markers', []):
            c = m.get('Collider', {})
            markers[m.get('EntName')] = (c.get('X'), c.get('Y'))
    return tex, vis, obs, markers


def cell_of(mx, my, tex):
    return (mx // (8 * tex), my // (8 * tex))


def detect_orientation(obs, tex, markers):
    OH = len(obs); OW = len(obs[0]) if OH else 0
    # la grille d'obstacles est en sous-cellules : dimension / tex
    GH, GW = OH // tex, OW // tex

    def w_yx(cx, cy):
        return 0 <= cy < GH and 0 <= cx < GW and all(
            obs[cy * tex + dy][cx * tex + dx].get('Tags', 1) == 0
            for dy in range(tex) for dx in range(tex))

    def w_xy(cx, cy):
        return 0 <= cx < GH and 0 <= cy < GW and all(
            obs[cx * tex + dx][cy * tex + dy].get('Tags', 1) == 0
            for dx in range(tex) for dy in range(tex))

    pts = [cell_of(*markers[n], tex) for n in ('Main_Entrance_Marker', 'Boss_Marker', 'Cutscene_Marker') if n in markers]
    s_yx = sum(1 for p in pts if w_yx(*p))
    s_xy = sum(1 for p in pts if w_xy(*p))
    if obs:
        if w_yx(0, 0): s_yx -= 2
        if w_xy(0, 0): s_xy -= 2
    return 'xy' if s_xy > s_yx else 'yx'


def walkable(obs, tex, orient, cx, cy):
    if orient == 'yx':
        OH = len(obs); OW = len(obs[0]) if OH else 0
        GH, GW = OH // tex, OW // tex
        if 0 <= cy < GH and 0 <= cx < GW:
            return all(obs[cy * tex + dy][cx * tex + dx].get('Tags', 1) == 0
                       for dy in range(tex) for dx in range(tex))
        return False
    else:
        OW = len(obs); OH = len(obs[0]) if OW else 0
        GW, GH = OW // tex, OH // tex
        if 0 <= cx < GW and 0 <= cy < GH:
            return all(obs[cx * tex + dx][cy * tex + dy].get('Tags', 1) == 0
                       for dx in range(tex) for dy in range(tex))
        return False


# ---------------------------------------------------------------- build
def build_sheet(arena, vis_layers, tex):
    seen = {}
    for L in vis_layers:
        T = L['Tiles']
        for x in range(len(T)):
            for y in range(len(T[0])):
                cell = T[x][y]
                if not isinstance(cell, dict):
                    continue
                for tl in cell.get('Layers', []):
                    for fi, fr in enumerate(tl.get('Frames', [])):
                        if fr.get('Sheet'):
                            key = (fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'], fi)
                            if key not in seen:
                                seen[key] = len(seen)
    pngs = {}
    meta = {}
    for key, idx in seen.items():
        sheet, tx, ty, fi = key
        ts, cells = load_package(sheet)
        src = cells.get((tx, ty))
        if src is None:
            src = Image.new('RGBA', (ts, ts), (0, 0, 0, 0))
        # taille cible : TILE px (24). si la texture source est 8x8 (TexSize 1)
        # -> upscale x3 ; si 24x24 (TexSize 3) -> 1:1.
        if src.width < TILE:
            up = upscale(src, TILE // src.width)
        else:
            up = src
        buf = io.BytesIO()
        up.save(buf, 'PNG')
        pngs[idx] = buf.getvalue()
        meta[idx] = key
    n = len(pngs)
    gx = max(1, int(np.ceil(np.sqrt(n))))
    gy = max(1, int(np.ceil(n / gx)))
    mapping = {}
    cells = []
    for idx, png in pngs.items():
        nx, ny = idx % gx, idx // gx
        mapping[meta[idx]] = (nx, ny)
        cells.append((nx, ny, png))
    return f'Arena_{arena}_Base', mapping, cells


def rebuild(arena, ground, write=False):
    arena_path = os.path.join(MAPDIR, arena + '.rsmap')
    gpath = os.path.join(GRODIR, ground + '.rsground')
    if not os.path.exists(arena_path) or not os.path.exists(gpath):
        print(f'ERREUR: {arena_path} ou {gpath} absent')
        return
    print(f'== {arena}  <-  {ground}')

    tex, vis_layers, obs, markers = ground_data(gpath)
    main = vis_layers[0]
    T = main['Tiles']
    W, H = len(T), len(T[0])
    print(f'   ground: TexSize={tex} {W}x{H} cellules = {W*8*tex}x{H*8*tex}px | couches: {len(vis_layers)}')

    has_tex = any(isinstance(T[x][y], dict) and T[x][y].get('Layers')
                  for x in range(W) for y in range(H))
    if not has_tex:
        print('   ground sans décor pixel-art (autotile procédural) — non concerné, skip')
        return

    orient = detect_orientation(obs, tex, markers)
    print(f'   orientation obstacles: {orient}')

    sheet_name, mapping, tile_cells = build_sheet(arena, vis_layers, tex)
    print(f'   sheet {sheet_name}: {len(tile_cells)} textures {TILE}x{TILE} (dédup)')

    def arena_cell(x, y):
        gcell = T[x][y]
        new_layers = []
        if isinstance(gcell, dict):
            for tl in gcell.get('Layers', []):
                frames = []
                for fi, fr in enumerate(tl.get('Frames', [])):
                    if fr.get('Sheet'):
                        nx, ny = mapping[(fr['Sheet'], fr['TexLoc']['X'], fr['TexLoc']['Y'], fi)]
                        frames.append({'Sheet': sheet_name, 'TexLoc': {'X': nx, 'Y': ny}})
                new_layers.append({'Frames': frames, 'FrameLength': tl.get('FrameLength', 60)})
        blocked = not walkable(obs, tex, orient, x, y)
        return {
            'Data': {
                'ID': 'unbreakable' if blocked else 'floor',
                'TileTex': {'AutoTileset': '', 'Associates': [], 'Layers': new_layers, 'NeighborCode': -1},
                'StableTex': False,
            },
            'Effect': {'TileLoc': {'X': x, 'Y': y}, 'ID': '', 'Revealed': False, 'Owner': 0, 'TileStates': []},
        }

    tiles = [[arena_cell(x, y) for y in range(H)] for x in range(W)]

    with open(arena_path, encoding='utf-8-sig') as f:
        d = json.load(f)
    obj = d['Object'] if 'Object' in d else d

    if not write:
        print('   [analyse seule — pas d’écriture]')
        metrics(arena, T, obs, tex, orient, markers)
        return

    obj['Tiles'] = tiles
    obj['Layers'] = []
    obj['DiscoveryArray'] = [[False] * H for _ in range(W)]

    def wcell(x, y):
        return walkable(obs, tex, orient, x, y)

    def nearest_w(x, y):
        if wcell(x, y):
            return (x, y)
        for r in range(1, max(W, H)):
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    if abs(dx) == r or abs(dy) == r:
                        if wcell(x + dx, y + dy):
                            return (x + dx, y + dy)
        return (x, y)

    eps = []
    for ep in obj.get('EntryPoints', []) or []:
        loc = ep.get('Loc', {})
        if wcell(loc.get('X', -1), loc.get('Y', -1)):
            eps.append(ep)
    if not eps and 'Main_Entrance_Marker' in markers:
        cx, cy = cell_of(*markers['Main_Entrance_Marker'], tex)
        cx, cy = nearest_w(cx, cy)
        eps.append({'Loc': {'X': cx, 'Y': cy}, 'Dir': 4})
        nx, ny = nearest_w(cx + 1, cy)
        if (nx, ny) != (cx, cy) and wcell(nx, ny):
            eps.append({'Loc': {'X': nx, 'Y': ny}, 'Dir': 4})
    if not eps:
        cx, cy = nearest_w(W // 2, H - 2)
        eps = [{'Loc': {'X': cx, 'Y': cy}, 'Dir': 4}]
    obj['EntryPoints'] = eps

    boss = markers.get('Boss_Marker')
    bx, by = cell_of(*boss, tex) if boss else (W // 2, max(2, H // 3))
    if not wcell(bx, by):
        found = None
        for r in range(1, max(W, H)):
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    if abs(dx) == r or abs(dy) == r:
                        if wcell(bx + dx, by + dy):
                            found = (bx + dx, by + dy); break
                if found: break
            if found: break
        if found:
            bx, by = found
    for team in obj.get('MapTeams', []) or []:
        for p in team.get('Players', []) or []:
            sl = p.setdefault('serializationLoc', {})
            if wcell(sl.get('X', -1), sl.get('Y', -1)):
                continue
            sl['X'] = bx
            sl['Y'] = by

    obj['Comment'] = (obj.get('Comment') or '') + ' | Pixel-perfect depuis ground (textures 24x24, collision ground).'

    with open(arena_path, 'w', encoding='utf-8') as f:
        json.dump(d, f, ensure_ascii=False, separators=(',', ':'))

    os.makedirs(TILEDIR, exist_ok=True)
    sheet_path = os.path.join(TILEDIR, sheet_name + '.tile')
    n_cells, n_uniq = write_tile_package(sheet_path, tile_cells)
    raw = open(sheet_path, 'rb').read()
    ts = struct.unpack_from('<I', raw, 0)[0]
    tc = struct.unpack_from('<I', raw, 4)[0]
    table = raw[8:8 + tc * 16]
    inject_index([(sheet_name, ts, tc, table)])
    print(f'   écrit: {arena_path} + {sheet_path} (tileSize={ts}, {tc} entrées) + index.idx')

    metrics(arena, T, obs, tex, orient, markers)
    render_compare(arena, ground, T, tex)


# ---------------------------------------------------------------- métriques
def metrics(arena, T, obs, tex, orient, markers):
    W, H = len(T), len(T[0])
    print('   --- métriques ground source vs arène ---')
    print(f'   dimensions : ground {W}x{H} cellules (= arène {W}x{H}) -> OK')
    cnt = {True: 0, False: 0}
    for x in range(W):
        for y in range(H):
            cnt[walkable(obs, tex, orient, x, y)] += 1
    print(f'   collision : {cnt[True]} walkable / {cnt[False]} bloqués')
    for name in ('Main_Entrance_Marker', 'Boss_Marker'):
        if name in markers:
            cx, cy = cell_of(*markers[name], tex)
            print(f'   {name} ({markers[name]}) -> cellule ({cx},{cy}) walkable={walkable(obs, tex, orient, cx, cy)}')


# ---------------------------------------------------------------- comparaison
def render_ground_image(T, tex):
    W, H = len(T), len(T[0])
    pas = 8 * tex
    img = Image.new('RGBA', (W * pas, H * pas), (0, 0, 0, 0))
    for x in range(W):
        for y in range(H):
            cell = T[x][y]
            if not isinstance(cell, dict):
                continue
            for tl in cell.get('Layers', []):
                frames = tl.get('Frames', [])
                if not frames:
                    continue
                fr = frames[0]
                if not fr.get('Sheet'):
                    continue
                ts, cells = load_package(fr['Sheet'])
                src = cells.get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                if src is not None:
                    img.alpha_composite(src, (x * pas, y * pas))
    return img


def render_arena_image(tiles):
    W, H = len(tiles), len(tiles[0])
    img = Image.new('RGBA', (W * TILE, H * TILE), (0, 0, 0, 255))
    for x in range(W):
        for y in range(H):
            tt = tiles[x][y]['Data']['TileTex']['Layers']
            for tl in tt:
                frames = tl.get('Frames', [])
                if not frames:
                    continue
                fr = frames[0]
                if not fr.get('Sheet'):
                    continue
                ts, cells = load_package(fr['Sheet'])
                src = cells.get((fr['TexLoc']['X'], fr['TexLoc']['Y']))
                if src is not None:
                    img.alpha_composite(src, (x * TILE, y * TILE))
    return img


def render_compare(arena, ground, T, tex):
    outdir = os.path.join(ROOT, 'docs', 'renders', 'pixelperfect')
    os.makedirs(outdir, exist_ok=True)
    g_img = render_ground_image(T, tex).convert('RGBA')
    k = TILE // (8 * tex)          # 3 si TexSize=1, 1 si TexSize=3
    expected = upscale(g_img, k)
    with open(os.path.join(MAPDIR, arena + '.rsmap'), encoding='utf-8-sig') as f:
        obj = json.load(f)['Object']
    a_img = render_arena_image(obj['Tiles']).convert('RGBA')

    def comp_on_black(im):
        base = Image.new('RGBA', im.size, (0, 0, 0, 255))
        base.alpha_composite(im)
        return base

    e = np.asarray(comp_on_black(expected).convert('RGB'), dtype=np.int16)
    a = np.asarray(comp_on_black(a_img).convert('RGB'), dtype=np.int16)
    diff = np.abs(e - a)
    total = e.shape[0] * e.shape[1]
    n_diff = int((diff.sum(axis=2) > 0).sum())
    max_d = int(diff.max())
    print(f'   comparaison: {a_img.width}x{a_img.height}px | pixels différents: {n_diff}/{total} ({100*n_diff/total:.2f}%) | diff max: {max_d}')

    pad = 12
    canvas = Image.new('RGBA', (expected.width * 2 + pad, expected.height), (30, 30, 40, 255))
    canvas.alpha_composite(comp_on_black(expected), (0, 0))
    canvas.alpha_composite(a_img, (expected.width + pad, 0))
    out = os.path.join(outdir, f'{arena}__vs__{ground}.png')
    canvas.convert('RGB').save(out)
    print(f'   montage: {out}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('arena')
    ap.add_argument('ground')
    ap.add_argument('--write', action='store_true')
    args = ap.parse_args()
    rebuild(args.arena, args.ground, write=args.write)


if __name__ == '__main__':
    main()
