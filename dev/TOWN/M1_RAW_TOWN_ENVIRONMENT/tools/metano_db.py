#!/usr/bin/env python3
"""M1 — base de langage du Ground Metano (fondation primaire).

Le Ground metano_town est multi-couches (11 layers : Base, Cliffs,
River×4 frames, Objects Under/Anim, Objects, Objects Anim, Objects
Over/Anim, Fringe). L'unité d'analyse est le SUPERTILE : pour une
cellule 8px, le tuple exact des frames de toutes les couches
(+ collision native). Deux cellules au pixel identique (toutes couches)
partagent le même hash.

Produit :
  /tmp/mt_db.json     : grille 189×189 de hashes, collision, paires
                        d'adjacence H/V observées, fréquences, classes.
  /tmp/mt_imgs/       : composite RGBA 8×8 par supertile (rendu à plat
                        des couches pour classification et rendu).

Classes (couleur composite + collision NATIVES, jamais devinées) :
  G herbe unie marchable, P chemin/sable, W eau (rivière animée),
  O autre (arbres, falaises, berges, décors).
"""
from __future__ import annotations

import hashlib
import io
import json
import struct
from collections import Counter, defaultdict
from pathlib import Path

from PIL import Image

REPO = Path('/home/user/new-era-abyss-to-ascension-V4')
GROUND = 'metano_town'
IMG_DIR = Path('/tmp/mt_imgs')
OUT = Path('/tmp/mt_db.json')


def read_sheet(path: Path):
    data = path.read_bytes()
    _, count = struct.unpack_from('<II', data, 0)
    out = {}
    for i in range(count):
        key, off = struct.unpack_from('<QQ', data, 8 + i * 16)
        (size,) = struct.unpack_from('<Q', data, off)
        out[(key & 0xFFFFFFFF, key >> 32)] = data[off + 8:off + 8 + size]
    return out


def unpremultiply(img):
    px = img.load()
    out = Image.new('RGBA', img.size)
    dp = out.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            dp[x, y] = (0, 0, 0, 0) if a == 0 else (
                min(255, r * 255 // a), min(255, g * 255 // a),
                min(255, b * 255 // a), a)
    return out


def main():
    IMG_DIR.mkdir(exist_ok=True)
    d = json.loads((REPO / 'Data/Ground' / f'{GROUND}.rsground')
                   .read_text(encoding='utf-8-sig'))
    o = d['Object']
    layers = o['Layers']
    obs = o['obstacles']
    W = len(obs)
    H = len(obs[0])
    sheets = {}

    def blob(sheet, tx, ty):
        if not sheet:
            return None
        if sheet not in sheets:
            p = REPO / 'Content/Tile' / f'{sheet}.tile'
            sheets[sheet] = read_sheet(p) if p.is_file() else {}
        return sheets[sheet].get((tx, ty))

    # clé par cellule = SHA1 des PIXELS composites de toutes les couches
    # (frame 0 + drapeau animé) — le Ground Metano est un atlas 1:1
    # (chaque cellule a un TexLoc propre), donc la signature (sheet,tex)
    # est unique partout ; le langage réel est porté par les PIXELS.
    grid = [[None] * H for _ in range(W)]
    sig_of = {}
    composite = {}
    tile_cache = {}
    rep_cell = {}
    sheet_cats = {}
    for x in range(W):
        for y in range(H):
            sig = []
            for li, L in enumerate(layers):
                t = L['Tiles'][x][y]
                for tl in t.get('Layers', []):
                    frames = tuple(
                        (f['Sheet'], f['TexLoc']['X'], f['TexLoc']['Y'])
                        for f in tl.get('Frames', []))
                    if frames:
                        sig.append((li, frames,
                                    tl.get('FrameTime', 0)))
            im = Image.new('RGBA', (8, 8), (0, 0, 0, 0))
            animated = False
            for (_li, frames, _ft) in sig:
                if len(frames) > 1:
                    animated = True
                sh, tx, ty = frames[0]
                ck = (sh, tx, ty)
                if ck not in tile_cache:
                    b = blob(sh, tx, ty)
                    tile_cache[ck] = (
                        unpremultiply(Image.open(io.BytesIO(b))
                                      .convert('RGBA')) if b else None)
                tile = tile_cache[ck]
                if tile is not None:
                    im.alpha_composite(tile)
            key = hashlib.sha1(im.tobytes()
                               + (b'A' if animated else b'S')
                               ).hexdigest()[:16]
            grid[x][y] = key
            if key not in sig_of:
                sig_of[key] = sig
                composite[key] = im
                im.save(IMG_DIR / f'{key}.png')
                rep_cell[key] = [x, y]
                cats = set()
                for (_li, frames, _ft) in sig:
                    sh = frames[0][0] or ''
                    if 'Cliff' in sh:
                        cats.add('cliff')
                    if 'River' in sh or 'Animated' in sh or \
                            'Animation' in sh:
                        cats.add('riveranim')
                    if 'Objects' in sh:
                        cats.add('objects')
                    if 'Fringe' in sh:
                        cats.add('fringe')
                sheet_cats[key] = sorted(cats)

    freq = Counter()
    collv = defaultdict(Counter)
    for x in range(W):
        for y in range(H):
            freq[grid[x][y]] += 1
            collv[grid[x][y]][obs[x][y]['Tags']] += 1

    hp, vp = set(), set()
    for x in range(W):
        for y in range(H):
            if x + 1 < W:
                hp.add((grid[x][y], grid[x + 1][y]))
            if y + 1 < H:
                vp.add((grid[x][y], grid[x][y + 1]))

    info = {}
    for k, im in composite.items():
        rgb = im.convert('RGB')
        px = list(rgb.getdata())
        n = len(px)
        avg = tuple(sum(p[i] for p in px) // n for i in range(3))
        var = sum(sum((p[i] - avg[i]) ** 2 for i in range(3))
                  for p in px) // n
        coll = collv[k].most_common(1)[0][0]
        anim = any(len(fr) > 1 for (_l, fr, _t) in [] ) # placeholder
        nlayers = len(sig_of[k])
        animated = any(len(frames) > 1
                       for (_li, frames, _ft) in sig_of[k])
        r, g, b = avg
        if animated or (b > 130 and b > r + 25):
            cls = 'W'
        elif var < 260 and g > 120 and g >= r - 10 and g > b and \
                coll == 0 and nlayers == 1:
            cls = 'G'
        elif r > 185 and g > 150 and b < 150 and r > b and coll == 0 \
                and nlayers == 1:
            cls = 'P'
        else:
            cls = 'O'
        info[k] = {'avg': list(avg), 'var': var, 'coll': coll,
                   'freq': freq[k], 'layers': nlayers,
                   'animated': animated, 'cls': cls,
                   'rep': rep_cell[k], 'cats': sheet_cats[k]}

    # signatures complètes par hash (matérialisation .rsground fidèle :
    # mêmes couches, mêmes frames d'animation, mêmes FrameTime)
    json.dump({k: [[li, [list(f) for f in frames], ft]
                   for (li, frames, ft) in sig]
               for k, sig in sig_of.items()},
              open('/tmp/mt_sigs.json', 'w'))
    coll_grid = [[obs[x][y]['Tags'] for y in range(H)] for x in range(W)]
    json.dump({'W': W, 'H': H, 'grid': grid, 'coll': coll_grid,
               'hp': sorted(map(list, hp)), 'vp': sorted(map(list, vp)),
               'info': info}, open(OUT, 'w'))
    c = Counter(v['cls'] for v in info.values())
    print('supertiles:', len(info), dict(c))
    print('freq top G:', sorted([(v['freq'], k) for k, v in info.items()
                                 if v['cls'] == 'G'], reverse=True)[:5])
    print('freq top P:', sorted([(v['freq'], k) for k, v in info.items()
                                 if v['cls'] == 'P'], reverse=True)[:5])
    print('freq top W:', sorted([(v['freq'], k) for k, v in info.items()
                                 if v['cls'] == 'W'], reverse=True)[:5])
    print('pairs H/V:', len(hp), len(vp))


if __name__ == '__main__':
    main()
