#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""arene_tornadus_post.py — post-traitement du rendu d'arene + composites.

Traite INDISTINCTEMENT :
  - work/arene_tornadus/pixellab_brut_128.png  (rendu PixelLab, 128x128,
    produit par arene_tornadus_pixellab.py sur votre machine),
  - ou work/arene_tornadus/gen_sommet.png      (rendu de secours genere
    dans le sandbox, ~1024x1024),
et produit l'arene ISOLEE 512x512 grain 4 + les composites avec la boucle
cyclonique (24 frames, work/cyclone_loop/).

Pipeline (recette maison, cf. ruines_pixellab.py) :
  1. decoupe par masque de silhouette (fond uni detecte aux coins),
  2. recadrage sur la grille 128 cellules (grain final 4 px),
  3. quantification palette DS 5 bits (median-cut 128 puis grille),
  4. alpha net, upscale x4 au plus proche,
  5. composites arene dessous / loop dessus, previews 12 fps.
"""
import os

import numpy as np
from PIL import Image
from scipy import ndimage

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, 'work', 'arene_tornadus')
LOOP = os.path.join(REPO, 'work', 'cyclone_loop')
N, G = 128, 4
CIBLE = 94          # diametre vise du plateau en cellules (oeil loop = 38)


def ds5(a, couleurs=128):
    im = Image.fromarray(a.astype(np.uint8), 'RGB')
    q = im.quantize(colors=couleurs, method=Image.MEDIANCUT, dither=0)
    pal = np.array(q.getpalette()[:couleurs * 3],
                   dtype=int).reshape(-1, 3)
    pal = np.clip((pal // 8) * 8 + 7, 0, 255).astype(np.uint8)
    return pal[np.asarray(q, dtype=int)]


def charge():
    """Renvoie (rgb 128x128x3, mask 128x128) depuis la meilleure source."""
    pb = os.path.join(OUT, 'pixellab_brut_128.png')
    if os.path.exists(pb):
        a = np.asarray(Image.open(pb).convert('RGB').resize(
            (N, N), Image.NEAREST))
        lum = a.mean(2)
        mask = lum > lum.min() + 30
        return a, masque_propre(mask)

    gp = os.path.join(OUT, 'gen_sommet.png')
    im = Image.open(gp).convert('RGB')
    W, H = im.size
    a = np.asarray(im)
    coins = np.concatenate([a[:8, :8].reshape(-1, 3), a[:8, -8:].reshape(-1, 3),
                            a[-8:, :8].reshape(-1, 3),
                            a[-8:, -8:].reshape(-1, 3)])
    bg = np.median(coins, 0)
    dist = np.abs(a.astype(int) - bg).sum(2)
    mask_f = dist > 90
    mask_f = masque_propre(mask_f)

    # descente sur la grille 128 : moyenne par blocs
    f = W // N
    rgb = a.reshape(N, f, N, f, 3).mean(axis=(1, 3)).round().astype(np.uint8)
    m128 = mask_f.reshape(N, f, N, f).mean(axis=(1, 3)) > 0.5
    return rgb, m128


def masque_propre(m):
    m = ndimage.binary_fill_holes(m)
    lab, n = ndimage.label(m)
    if n > 1:
        tailles = ndimage.sum(m, lab, range(1, n + 1))
        m = lab == (np.argmax(tailles) + 1)
    return m


def recadre(rgb, mask):
    """Ajuste le diametre du plateau sur CIBLE cellules, recentre."""
    ys, xs = np.where(mask)
    d = max(ys.max() - ys.min() + 1, xs.max() - xs.min() + 1)
    if abs(d - CIBLE) > 2:
        f = CIBLE / d
        ns = int(round(N * f))
        rgb = np.asarray(Image.fromarray(rgb).resize((ns, ns), Image.NEAREST))
        mask = np.asarray(Image.fromarray(
            (mask * 255).astype(np.uint8)).resize(
                (ns, ns), Image.NEAREST)) > 127
        out_r = np.zeros((N, N, 3), np.uint8)
        out_m = np.zeros((N, N), bool)
        y0 = (N - ns) // 2 if ns <= N else 0
        x0 = (N - ns) // 2 if ns <= N else 0
        if ns <= N:
            out_r[y0:y0 + ns, x0:x0 + ns] = rgb
            out_m[y0:y0 + ns, x0:x0 + ns] = mask
        else:
            c = ns // 2
            out_r = rgb[c - N // 2:c - N // 2 + N, c - N // 2:c - N // 2 + N]
            out_m = mask[c - N // 2:c - N // 2 + N, c - N // 2:c - N // 2 + N]
        return out_r, out_m
    return rgb, mask


def main():
    rgb, mask = charge()
    rgb, mask = recadre(rgb, mask)
    mask = masque_propre(mask)

    base = ds5(rgb)
    base[~mask] = 0
    a = np.where(mask, 255, 0).astype(np.uint8)
    rgba = np.dstack([base, a]).astype(np.uint8)
    rgba = np.repeat(np.repeat(rgba, G, 0), G, 1)
    arene = Image.fromarray(rgba, 'RGBA')
    arene.save(os.path.join(OUT, 'arene_sommet_isolee.png'))
    print('arene isolee 512x512 ->', os.path.join(OUT,
                                                 'arene_sommet_isolee.png'))

    frames = [Image.open(os.path.join(LOOP, 'frame_%02d.png' % f))
              .convert('RGBA') for f in range(1, 25)]
    fonds = []
    for f, im in enumerate(frames):
        c = Image.new('RGBA', (512, 512), (16, 22, 36, 255))
        c.alpha_composite(arene)
        c.alpha_composite(im)
        fonds.append(c)
        if f + 1 in (1, 13):
            c.save(os.path.join(OUT, 'composite_f%02d.png' % (f + 1)))
    fonds[0].save(os.path.join(OUT, 'composite_12fps.apng'),
                  save_all=True, append_images=fonds[1:],
                  duration=83, loop=0, disposal=2)
    mini = 256
    sheet = Image.new('RGB', (mini * 6 + 14, mini * 4 + 12), (24, 28, 38))
    for f, im in enumerate(fonds):
        sheet.paste(im.resize((mini, mini), Image.NEAREST).convert('RGB'),
                    ((f % 6) * (mini + 2) + 1, (f // 6) * (mini + 2) + 1))
    sheet.save(os.path.join(OUT, 'composite_contact_sheet.png'))
    print('composites 12 fps ->', OUT)


if __name__ == '__main__':
    main()
