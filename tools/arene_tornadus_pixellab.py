#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""arene_tornadus_pixellab.py — l'arene-sommet de Tornadus, via PIXELLAB.

DEMANDE
=======
« créer sur pixel lab l'arene de tornadus au sommet d'une montagne,
isolée, pour ensuite placer les 24 frames de cyclone dans le ciel en
fond ». Le decor vient donc de PixelLab (pas d'un rendu procedural
final), selon la recette mesuree dans ruines_pixellab.py :

  1. un PLAN DE COMPOSITION procedural en init_image,
  2. init_image_strength eleve (550) : le modele garde la disposition
     et n'apporte que sa facture,
  3. quantification palette DS 5 bits apres generation,
  4. isolement (alpha) par masque geometrique : c'est nous qui tenons
     la silhouette du sommet, donc la decoupe est nette et stable.

TAILLES
=======
bitforge : max 200x200. Le plan fait 128x128 ; la sortie PixelLab est
agrandie x4 au plus proche -> 512x512, grain 4 : EXACTEMENT le grain et
le canvas de la boucle cyclonique (work/cyclone_loop/), donc les deux
couches se marient pixel pour pixel. Le plateau (rayon ~47 cellules =
188 px) deborde largement de l'oeil du cyclone (rayon 76 px) : la roche
mord sous les nuages, couture invisible.

Usage :
    PIXELLAB_KEY=xxxx python3 tools/arene_tornadus_pixellab.py
"""
import base64
import io
import json
import math
import os
import sys
import time
import urllib.error
import urllib.request

import numpy as np
from PIL import Image
from scipy import ndimage

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CLE = os.environ.get('PIXELLAB_KEY', '')
OUT = os.path.join(REPO, 'work', 'arene_tornadus')
PLAN = os.path.join(OUT, 'plan_sommet_128.png')
BRUT = os.path.join(OUT, 'pixellab_brut_128.png')
FINAL = os.path.join(OUT, 'arene_sommet_pixellab.png')
LOOP = os.path.join(REPO, 'work', 'cyclone_loop')

N = 128          # plan natif
G = 4            # grain final (identique a la loop)
R_PLAT = 47.0    # rayon plateau en cellules du plan

PROMPT = ("top-down view game arena background, rocky mountain summit "
          "plateau with snow patches and wind-carved stone, circular "
          "island floating above a storm, Pokemon Mystery Dungeon "
          "Explorers of Sky style pixel art, crisp selective outline, "
          "detailed soft shading, blue-grey palette")
NEGATIF = ("photorealistic, 3d render, blurry, text, watermark, ui, "
           "frame, border, characters, pokemon, vignette, dark edges, "
           "anti-aliasing")
FORCE = 550

_y, _x = np.mgrid[0:N, 0:N]
_r = np.hypot(_x - N / 2, _y - N / 2)
_t = np.arctan2(_y - N / 2, _x - N / 2)


# ------------------------------------------------------------------ plan
def plan():
    """Plan de composition 128x128 : disposition tenue par le modele."""
    bord = R_PLAT * (1.0 + 0.055 * np.cos(3 * _t + 0.9)
                     + 0.035 * np.cos(6 * _t + 2.2))
    mask = _r < bord

    grain = (np.sin(_x * 0.9 + np.sin(_y * 0.7) * 2.0)
             * np.sin(_y * 0.8 + np.sin(_x * 0.6) * 2.0))
    rel = _r / 6.5 + 0.5 * np.cos(2 * _t - 0.9 * np.log(_r + 3.0))
    frac = rel - np.floor(rel)
    val = 0.62 - 0.10 * (np.floor(rel) % 2) + 0.14 * grain \
        - 0.28 * np.clip(_r / R_PLAT, 0, 1)
    val[frac < 0.14] -= 0.25

    neige = (0.55 * np.cos(3 * _t + 0.7 * np.log(_r + 3.0) + 0.8)
             + 0.30 * np.cos(7 * _t - 1.3 * np.log(_r + 3.0) + 3.1)
             + 0.25 * grain) > 0.42
    neige |= _r < 11 + 2 * np.cos(3 * _t + 1.0)

    RAMPE = [(168, 180, 196), (140, 153, 172), (112, 125, 146),
             (86, 99, 120), (64, 76, 97), (47, 57, 76)]
    idx = np.clip((val * len(RAMPE)).astype(int), 0, len(RAMPE) - 1)
    rgb = np.zeros((N, N, 3), np.uint8)
    for i, c in enumerate(RAMPE):
        rgb[idx == i] = c
    rgb[neige & mask] = (244, 248, 253)
    contour = mask & ~ndimage.binary_erosion(mask)
    rgb[contour] = (30, 39, 56)
    # ciel autour : aplat sombre, decoupe par masque apres generation
    out = np.zeros((N, N, 3), np.uint8)
    out[:] = (26, 35, 54)
    out[mask | contour] = rgb[mask | contour]
    return out, mask


# ------------------------------------------------------------------ API
def appel(body, sortie, essais=3):
    for k in range(essais):
        req = urllib.request.Request(
            'https://api.pixellab.ai/v1/generate-image-bitforge',
            data=json.dumps(body).encode(), method='POST')
        req.add_header('Authorization', 'Bearer ' + CLE)
        req.add_header('Content-Type', 'application/json')
        try:
            r = json.load(urllib.request.urlopen(req, timeout=900))
        except urllib.error.HTTPError as e:
            msg = e.read()[:300].decode('utf8', 'replace')
            print(f'    HTTP {e.code} {msg}')
            if e.code in (429, 500, 502, 503) and k + 1 < essais:
                time.sleep(8)
                continue
            return None
        im = Image.open(io.BytesIO(base64.b64decode(r['image']['base64'])))
        im.save(sortie)
        return im
    return None


def ds5(a, couleurs=128):
    """Palette DS : median-cut 128 puis grille 5 bits (recette maison)."""
    im = Image.fromarray(a.astype(np.uint8), 'RGB')
    q = im.quantize(colors=couleurs, method=Image.MEDIANCUT, dither=0)
    pal = np.array(q.getpalette()[:couleurs * 3],
                   dtype=int).reshape(-1, 3)
    pal = np.clip((pal // 8) * 8 + 7, 0, 255).astype(np.uint8)
    return pal[np.asarray(q, dtype=int)]


def main():
    if not CLE:
        print('ABANDON : PIXELLAB_KEY absent de l\'environnement.')
        return 1
    os.makedirs(OUT, exist_ok=True)

    p, mask = plan()
    Image.fromarray(p, 'RGB').save(PLAN)
    print('plan 128x128 ->', PLAN)

    if not os.path.exists(BRUT):
        b = io.BytesIO()
        Image.fromarray(p, 'RGB').save(b, format='PNG')
        print('appel PixelLab bitforge 128x128 (strength %d)...' % FORCE)
        im = appel({'description': PROMPT, 'negative_description': NEGATIF,
                    'image_size': {'width': N, 'height': N},
                    'init_image': {'type': 'base64',
                                   'base64': base64.b64encode(
                                       b.getvalue()).decode()},
                    'init_image_strength': FORCE,
                    'text_guidance_scale': 7.0, 'view': 'high top-down',
                    'outline': 'selective outline',
                    'shading': 'detailed shading',
                    'detail': 'highly detailed', 'seed': 7}, BRUT)
        if im is None:
            return 1
        print('generation PixelLab ->', BRUT)
    brut = np.asarray(Image.open(BRUT).convert('RGB').resize(
        (N, N), Image.NEAREST))

    base = ds5(brut)
    n = len(Image.fromarray(base).getcolors(999999))
    print('couleurs apres palette DS :', n)

    # isolement : masque geometrique dilate d'1 cellule (garde l'outline)
    alpha_mask = ndimage.binary_dilation(mask, iterations=1)
    rgb = base.copy()
    contour = alpha_mask & ~ndimage.binary_erosion(alpha_mask)
    rgb[contour] = (30, 39, 56)
    a = np.where(alpha_mask, 255, 0).astype(np.uint8)

    rgba = np.dstack([rgb, a]).astype(np.uint8)
    rgba = np.repeat(np.repeat(rgba, G, axis=0), G, axis=1)
    Image.fromarray(rgba, 'RGBA').save(FINAL)
    print('arene isolee 512x512 grain 4 ->', FINAL)

    # composites avec la boucle cyclonique
    frames = []
    for f in range(1, 25):
        fp = os.path.join(LOOP, 'frame_%02d.png' % f)
        if not os.path.exists(fp):
            print('loop absente : lancez tools/cyclone_loop.py')
            return 0
        frames.append(Image.open(fp).convert('RGBA'))
    arene = Image.fromarray(rgba, 'RGBA')
    fonds = []
    for f, im in enumerate(frames):
        c = Image.new('RGBA', (512, 512), (16, 22, 36, 255))
        c.alpha_composite(arene)
        c.alpha_composite(im)
        fonds.append(c)
        if f + 1 in (1, 13):
            c.save(os.path.join(OUT, 'pixellab_composite_f%02d.png' % (f + 1)))
    fonds[0].save(os.path.join(OUT, 'pixellab_composite_12fps.apng'),
                  save_all=True, append_images=fonds[1:],
                  duration=83, loop=0, disposal=2)
    mini = 256
    sheet = Image.new('RGB', (mini * 6 + 14, mini * 4 + 12), (24, 28, 38))
    for f, im in enumerate(fonds):
        sheet.paste(im.resize((mini, mini), Image.NEAREST).convert('RGB'),
                    ((f % 6) * (mini + 2) + 1, (f // 6) * (mini + 2) + 1))
    sheet.save(os.path.join(OUT, 'pixellab_contact_sheet.png'))
    print('composites ->', OUT)
    return 0


if __name__ == '__main__':
    sys.exit(main())
