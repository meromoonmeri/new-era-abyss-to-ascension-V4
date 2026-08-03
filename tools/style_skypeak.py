#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""style_skypeak.py — porte une image au style Sky Peak (PMD).

SIGNATURE MESUREE SUR LA REFERENCE (501x564, 111 couleurs)
==========================================================
    bande        luminance  saturation
    ciel haut       123        0.95     bleu franc, tres sature
    horizon         219        0.33     pale, delave
    avant-plan       69        0.66     sombre ET sature
    dithering : voisin +1 different 23 %, voisin +2 47 %
                -> le motif se repete tous les 2 px : damier de Bayer
    palette : 32 valeurs de composante, 31 multiples de 8 moins 1
                -> rampe 5 bits par canal (DS)

CE QUE PIXELLAB NE PRODUIT PAS TOUT SEUL (mesure sur sky_v1)
    ciel      sat 0.58 au lieu de 0.95
    dithering +1 14 % / +2 17 % au lieu de 23 / 47  -> quasi absent
    couleurs  43 au lieu de 111
D'ou ce post-traitement : on ne redessine rien, on corrige la
COLORIMETRIE et on ajoute le dithering que le modele n'a pas mis.
"""
import numpy as np

BAYER4 = np.array([[ 0, 8, 2,10],
                   [12, 4,14, 6],
                   [ 3,11, 1, 9],
                   [15, 7,13, 5]], float) / 16.0 - 0.5


def _ds(x):
    """Quantifie sur la rampe 5 bits DS : composantes en 8k-1."""
    return (np.round((x + 1) / 8) * 8 - 1).clip(0, 255)


def profondeur(a, force=1.0):
    """Renforce la perspective atmospherique.

    En haut de l'image (le lointain) : on delave et on eclaircit.
    En bas (l'avant-plan) : on assombrit et on sature.
    C'est l'ecart mesure sur la reference : lum 219/sat 0.33 a
    l'horizon contre lum 69/sat 0.66 devant.
    """
    H = a.shape[0]
    v = (np.arange(H) / (H - 1.0))[:, None, None]      # 0 haut, 1 bas
    gris = a.mean(2, keepdims=True)
    # saturation : faible en haut, forte en bas
    k = 0.72 + 0.78 * v * force
    a = gris + (a - gris) * k
    # luminosite : l'avant-plan s'enfonce
    a = a * (1.04 - 0.34 * v * force)
    return a


def ciel_sature(a, hauteur=0.34, cible=0.95):
    """Ramene le ciel a la saturation de la reference (0.95 en haut)."""
    H = a.shape[0]
    lim = int(H * hauteur)
    z = a[:lim]
    g = z.mean(2, keepdims=True)
    mx = z.max(2, keepdims=True); mn = z.min(2, keepdims=True)
    sat = np.where(mx > 0, (mx - mn) / np.maximum(mx, 1), 0)
    # facteur variable : plein effet en haut, nul a l'horizon
    t = (1 - np.arange(lim) / float(lim))[:, None, None]
    besoin = np.where(sat > 0.02, cible / np.maximum(sat, 0.02), 1.0)
    k = 1.0 + (np.clip(besoin, 1.0, 3.4) - 1.0) * t
    a[:lim] = g + (z - g) * k
    return a


def dither(a, zone=0.42, amp=10.0):
    """Damier de Bayer 4x4 dans le ciel, avant quantification.

    Sans lui, la quantification 5 bits produit des BANDES nettes dans le
    degrade. Le damier casse la bande.

    REGLAGE MESURE : la reference a voisin +1 different a 25 % et
    voisin +2 a 50 %. Une amplitude de 10 donnait 77 % / 35 % — un
    damier visible partout au lieu d'un adoucissement. La bonne
    amplitude est celle qui fait basculer le pixel d'UN cran de
    quantification (8 niveaux) seulement pres de la frontiere entre
    deux crans : amp ~ 4.
    """
    H, W, _ = a.shape
    lim = int(H * zone)
    m = np.tile(BAYER4, (lim // 4 + 1, W // 4 + 1))[:lim, :W]
    t = (1 - np.arange(lim) / float(lim))[:, None]
    a[:lim] += (m * amp * (0.35 + 0.65 * t))[:, :, None]
    return a


def palette(a, n=112):
    """Ramene le nombre de couleurs a celui de la reference (111).

    Le traitement colorimetrique en cree beaucoup : 372 mesurees. Une
    quantification finale sur une palette unique remet l'image dans le
    budget d'un fond PMD, et supprime les couleurs parasites nees des
    multiplications.
    """
    from PIL import Image
    im = Image.fromarray(a.astype(np.uint8))
    q = im.quantize(colors=n, method=Image.MEDIANCUT, dither=Image.NONE)
    return np.array(q.convert('RGB'))


def appliquer(src, force=1.0):
    a = src.astype(float).copy()
    a = profondeur(a, force)
    a = ciel_sature(a)
    a = dither(a, amp=4.0)
    a = _ds(np.clip(a, 0, 255)).astype(np.uint8)
    return palette(a)
