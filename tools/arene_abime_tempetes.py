#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""arene_abime_tempetes.py — refait le ground de l'arene du Creux des Marees.

ETAT DES LIEUX (mesure)
=======================
Le .rsground actuel reference 4158 cellules sur UN seul tile placeholder
(TexLoc absent -> tuile noire) : l'arene est un rectangle bleu nuit vide.
L'atlas AbimeTempetes_Base.tile = 4158 tuiles 8x8 toutes noires.

CE QU'ON CONSTRUIT
==================
Un vrai ground 504x528, pixel art PMD, coherent avec la boucle cyclonique
(work/cyclone_loop/) :
  - sol de tempete : mer/nuage sombre en SPIRALE autour du centre de
    l'arene (272, 216) — les positions viennent du script init.lua :
    heros (272,240), gardien (272,200), camera (272,~216) ;
  - plateforme de combat circulaire rayon ~68 px, bord ronge par
    l'ecume : c'est ce que l'oeil de la boucle cyclonique (rayon 76 px)
    laissera voir une fois la loop compositée ;
  - rampe bleu-gris quantifiee 5 bits DS, outline 1 px, zero
    anti-aliasing.

PUIS
====
  - reconstruit Content/Tile/AbimeTempetes_Base.tile (dedup des tuiles
    8x8, meme format binaire que l'existant : header u32 size + u32 count,
    index (cle u64, offset u64), blobs PNG prefixes u64 longueur) ;
  - reecrit Data/Ground/abime_tempetes.rsground : chaque cellule pointe
    sur la tuile atlas correspondante (TexLoc), comme les vrais grounds ;
  - rend work/arene_abime_render.png + la preview animee arene + loop.

Deterministe : seed fixe.
"""
import io
import json
import math
import os
import struct

import numpy as np
from PIL import Image

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
W, H = 504, 528
CX, CY = 272, 216          # centre de combat (script init.lua)
R_PLAT = 68                # plateforme de combat
R_MARGE = 8                # marge de securite autour du canvas

OUT_PNG   = os.path.join(REPO, 'work', 'arene_abime_504x528.png')
TILE_PATH = os.path.join(REPO, 'Content', 'Tile', 'AbimeTempetes_Base.tile')
MAP_PATH  = os.path.join(REPO, 'Data', 'Ground', 'abime_tempetes.rsground')
RENDER    = os.path.join(REPO, 'work', 'arene_abime_render.png')

_y, _x = np.mgrid[0:H, 0:W]
_r = np.hypot(_x - CX, _y - CY)
_t = np.arctan2(_y - CY, _x - CX)

rng = np.random.default_rng(77031)


def ds5(x):
    return (np.round((x + 1) / 8) * 8 - 1).clip(0, 255)


def smoothstep(a, b, x):
    u = np.clip((x - a) / (b - a), 0.0, 1.0)
    return u * u * (3 - 2 * u)


# ------------------------------------------------------------------ champs
def champ_spirale(terms):
    """Somme de cos(k*(theta - beta*ln(r+12)) + p) : phase spirale, comme
    la boucle — c'est la signature visuelle du Creux des Marees."""
    s = np.zeros_like(_r)
    for (k, beta, a, p) in terms:
        s += a * np.cos(k * (_t - beta * np.log(_r + 12.0)) + p)
    return s


# mer en spirale : grosses houles + stries fines
HOULES = [(2, 0.9, 0.55, 0.7), (3, 1.1, 0.40, 2.9), (5, 1.3, 0.30, 5.1)]
STRIES = [(9, 1.5, 0.35, 1.3), (13, 1.7, 0.28, 4.2), (21, 1.9, 0.22, 0.4)]

houle = champ_spirale(HOULES)
strie = champ_spirale(STRIES)
# petit grain de vague, statique, haute frequence : c'est lui qui casse
# l'aspect « aerographe » en clusters de pixels
grain = (np.sin(_x * 0.9 + np.sin(_y * 0.7) * 2.0)
         * np.sin(_y * 0.8 + np.sin(_x * 0.6) * 2.0))
casse = np.sin(_x * 1.31 + np.sin(_y * 0.9) * 1.7) \
    + np.sin(_y * 1.17 + np.sin(_x * 0.8) * 1.7)

eau = 0.5 + 0.26 * houle + 0.20 * strie + 0.18 * grain
# la houle s'ecrase en s'approchant de l'oeil : plus clair pres du centre
eau += 0.25 * np.exp(-(_r / 150.0) ** 2)

# ------------------------------------------------------------- plateforme
# bord ronge : rayon module par une spirale lente
bord = R_PLAT + 3.5 * np.cos(3 * _t - 1.2 * np.log(_r + 12.0)) \
    + 2.0 * np.cos(7 * _t + 1.9)
plate = _r < bord

# roche : rampe sombre + fissures + grain fort (pas de disque lisse)
roche = 0.45 + 0.26 * np.cos(2 * _t + 0.8 * np.log(_r + 12.0)) \
    + 0.30 * grain
fiss = np.abs(np.sin(_r * 0.55 + 1.5 * np.sin(_t * 2.0) + 0.8 * grain)) < 0.12
roche[fiss] -= 0.40
# liseret humide clair juste a l'interieur du bord
roche[_r > bord - 7] += 0.22

# ecume : anneau casse autour de la plateforme + stries de crete en mer,
# HACHEES en amas (le casse brise les rubans continus)
ecume_plate = (_r > bord) & (_r < bord + 4.0 + 2.5 * strie) \
    & (casse > -0.9)
ecume_mer = (strie > 0.58) & (casse > 0.1) & (_r > R_PLAT + 14)
# ressac : arc d'ecume discret autour de la plateforme
ressac = (np.abs(_r - (R_PLAT + 22)) < 1.6) & (casse > 0.6)

# ------------------------------------------------------------------ rampes
RAMPE_EAU = [          # du clair (pres de l'oeil) au sombre (bords carte)
    (126, 142, 164), (98, 114, 138), (74, 90, 114),
    (54, 68, 92), (38, 50, 72), (26, 35, 54),
]
RAMPE_ROCHE = [
    (108, 116, 130), (86, 94, 110), (66, 74, 90), (48, 55, 70), (34, 40, 54),
]
ECUME = (214, 226, 240)


def quant(ramp, val):
    idx = np.clip((val * len(ramp)).astype(int), 0, len(ramp) - 1)
    out = np.zeros((H, W, 3), np.uint8)
    for i, c in enumerate(ramp):
        out[idx == i] = c
    return out


def construit():
    img = quant(RAMPE_EAU, eau)
    rock = quant(RAMPE_ROCHE, roche)
    img[plate] = rock[plate]
    img[ecume_plate | ecume_mer | ressac] = ECUME

    # outline 1 px : contour de la plateforme (eau contre roche) et de
    # l'ecume de bord
    contour = plate ^ np.roll(plate, 1, 0) | plate ^ np.roll(plate, -1, 0) \
        | plate ^ np.roll(plate, 1, 1) | plate ^ np.roll(plate, -1, 1)
    img[contour] = (18, 24, 38)

    # bords de carte : fonce progressivement (vignette tempete)
    vig = smoothstep(210, 340, _r)
    img = (img.astype(int) * (1 - 0.35 * vig[..., None])).astype(np.uint8)

    img = np.dstack([ds5(img[..., i]) for i in range(3)]).astype(np.uint8)
    return Image.fromarray(img, 'RGB')


# ------------------------------------------------------------------ atlas
ATLAS_W = 128   # largeur (en tuiles) de la grille d'atlas : les cles
                # (x, y) sont coherentes entre le .tile et les TexLoc.


def ecris_atlas(img):
    """Dedup des tuiles 8x8 -> .tile binaire (meme format que l'existant)."""
    a = np.asarray(img)
    tiles, coords = {}, np.zeros((H // 8, W // 8, 2), int)
    for ty in range(H // 8):
        for tx in range(W // 8):
            bloc = a[ty * 8:(ty + 1) * 8, tx * 8:(tx + 1) * 8]
            cle = bloc.tobytes()
            if cle not in tiles:
                idx = len(tiles)
                tiles[cle] = (idx % ATLAS_W, idx // ATLAS_W, bloc)
            coords[ty, tx] = tiles[cle][:2]

    buf = io.BytesIO()
    buf.write(struct.pack('<II', 8, len(tiles)))
    # reserve l'index
    off_index = buf.tell()
    buf.write(b'\x00' * 16 * len(tiles))
    index = []
    for ax, ay, bloc in tiles.values():
        png = io.BytesIO()
        Image.fromarray(bloc, 'RGB').save(png, format='PNG')
        blob = png.getvalue()
        offset = buf.tell()
        buf.write(struct.pack('<Q', len(blob)))
        buf.write(blob)
        index.append((ax, ay, offset))
    fin = buf.tell()
    buf.seek(off_index)
    for ax, ay, offset in index:
        buf.write(struct.pack('<QQ', ax | (ay << 32), offset))
    buf.seek(fin)
    with open(TILE_PATH, 'wb') as f:
        f.write(buf.getvalue())
    return coords, len(tiles)


def reecrit_map(coords):
    with open(MAP_PATH, encoding='utf-8-sig') as f:
        d = json.load(f)
    t = d['Object']['Layers'][0]['Tiles']
    for ty, row in enumerate(t):
        for tx, cell in enumerate(row):
            ly = cell.get('Layers')
            if not ly:
                cell['Layers'] = ly = [{'Frames': [{}]}]
            fr = ly[0]['Frames'][0]
            fr['Sheet'] = 'AbimeTempetes_Base'
            fr['TexLoc'] = {'X': int(coords[ty, tx, 0]),
                            'Y': int(coords[ty, tx, 1])}
            fr.setdefault('FrameLength', 60)
    with open(MAP_PATH, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, indent=3)
    return len(t), len(t[0])


def main():
    img = construit()
    img.save(OUT_PNG)
    print('ground :', OUT_PNG)

    coords, n = ecris_atlas(img)
    print('atlas  : %d tuiles uniques 8x8 -> %s' % (n, TILE_PATH))

    h, w = reecrit_map(coords)
    print('map    : %dx%d cellules re-referencees -> %s' % (w, h, MAP_PATH))

    # rendu de controle via le pipeline officiel du repo
    import sys
    sys.path.insert(0, REPO)
    from render_maps import render_map
    render_map(MAP_PATH, RENDER, 'abime')
    print('rendu  :', RENDER)


if __name__ == '__main__':
    main()
