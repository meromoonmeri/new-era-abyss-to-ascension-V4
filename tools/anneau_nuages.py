#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""anneau_nuages.py — anneau de nuages en rotation, au style de la carte.

POURQUOI CE FICHIER
===================
Premiere version : rotation d'image -> la boucle sautait (ecart 80
entre 0 et 45 deg). Deuxieme : redessin avec random par appel -> ecart
48. Seul un rendu ANALYTIQUE avec angle replie modulo 45 deg donne un
ecart de 0, donc une boucle invisible.

STYLE — mesure sur la carte PixelLab, pas suppose :
    nuages d'origine : 2 COULEURS seulement
        (247,247,255) 59,9 %   fond de ciel
        (215,231,247) 40,1 %   le nuage
    l'image native fait 288x336 agrandie x4 : le grain est donc de
    4 px, pas de 1 px.
Ma premiere version utilisait 4 tons et un grain de 1 px : d'ou
l'aspect lisse et procedural. On reproduit ici les 2 tons et le
grain de 4 px.

PERIODICITE : 8 secteurs de 45 deg, N frames de 45/N deg. Apres N
frames le motif est exactement revenu sur lui-meme.
"""
import numpy as np, math, random

W, H = 1152, 1344
CX, CY = 580, 668
CIEL = np.array([247, 247, 255])
NUAGE = np.array([215, 231, 247])
GRAIN = 4                      # taille du pixel apparent de la carte
N_SEC = 8
SECT = 2 * math.pi / N_SEC

random.seed(4)
BOUF = [(random.uniform(330, 880), random.uniform(0, SECT),
         random.uniform(38, 104)) for _ in range(26)]

# Grille reduite au grain : on calcule 4x moins de points, puis on
# agrandit. C'est ce qui donne le bord en marches d'escalier du
# pixel art, au lieu d'un cercle lisse.
gh, gw = H // GRAIN, W // GRAIN
_Y, _X = np.mgrid[0:gh, 0:gw]
_px = _X * GRAIN + GRAIN / 2.0
_py = _Y * GRAIN + GRAIN / 2.0
_R = np.hypot(_px - CX, _py - CY)
_TH = np.arctan2(_py - CY, _px - CX)


def frame(rot, teinte=None):
    """Une frame de l'anneau. `rot` en radians. `teinte` remplace la
    couleur du nuage (pour l'orage) ; le ciel reste inchange."""
    coul = NUAGE if teinte is None else np.array(teinte)
    small = np.zeros((gh, gw, 3), int)
    small[:] = CIEL
    t = np.mod(_TH - rot, SECT)
    qx = _R * np.cos(t)
    qy = _R * np.sin(t)
    for (r0, a0, s0) in BOUF:
        s = s0 * (0.75 + r0 / 900)
        for (ox, oy, f) in ((0, 0, 1.0), (-s * 0.52, s * 0.16, 0.72),
                            (s * 0.55, s * 0.12, 0.66)):
            rr = s * f / 2
            lx = r0 * math.cos(a0) + ox
            ly = r0 * math.sin(a0) + oy
            lr = math.hypot(lx, ly)
            la = math.atan2(ly, lx)
            small[((qx - lr * math.cos(la)) ** 2
                   + (qy - lr * math.sin(la)) ** 2) < rr * rr] = coul
    return np.repeat(np.repeat(small, GRAIN, 0), GRAIN, 1)
