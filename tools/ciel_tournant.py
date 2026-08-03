#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ciel_tournant.py — ciel a deux couches : les nuages RESPIRENT en tournant.

CE QUI N'ALLAIT PAS (mesure, pas impression)
============================================
Version precedente : d(r,t) = SUM a_i * sin(k_i*(theta - rot) + phi_i)
Le seul terme variable etait (theta - rot). C'est une ROTATION RIGIDE
PURE : le motif orbite sans jamais se deformer.
Preuve : on prend la frame a 180 deg, on la re-tourne de -180 deg
(rotation exacte au pixel, sans interpolation) et on retombe a 99,2 %
sur la frame 0. Un nuage qui se dilue donnerait un taux bas.

LE CORRECTIF — UNE VITESSE PAR HARMONIQUE
=========================================
    d = SUM_i  a_i * sin(k_i*theta + w_i*u + phi_i) * g_i(r)

`u` va de 0 a 2*pi sur un cycle. Comme
    sin(k*theta + w*u) = sin(k*(theta + (w/k)*u))
chaque harmonique tourne a SA PROPRE vitesse angulaire w_i/k_i. Les
rapports etant tous differents, les harmoniques se dephasent les unes
par rapport aux autres : les creux se comblent, les masses se
scindent, la silhouette change en permanence. Le nuage ne se contente
plus d'orbiter — il se dilue et se reforme.

BOUCLE : les w_i sont ENTIERS, donc chaque terme est 2*pi-periodique
en u. Apres un cycle complet le champ est rigoureusement identique.

DEUX COUCHES (methode citee par l'auteur : lointains + moyens)
    lointains : k faibles (grosses masses), vitesse lente, teinte pale
    moyens    : k eleves (formations serrees), vitesse differente
Deux couches independantes qui se croisent : c'est le croisement qui
tue la lecture du motif par l'oeil.

STYLE mesure sur la carte d'origine : ciel (247,247,255) a 59,9 %,
nuage (215,231,247) a 40,1 %, grain de 4 px (natif 288x336 agrandi x4).
"""
import numpy as np, math

W, H = 1152, 1344
CX, CY = 580, 668
GRAIN = 4
CIEL  = np.array([247, 247, 255])
NUAGE = np.array([215, 231, 247])
OMBRE = np.array([207, 223, 243])

# (k angulaire, w vitesse ENTIERE, amplitude, phase, rayon pref, largeur)
# w/k = vitesse de rotation propre. Tous les rapports sont distincts.
LOINTAINS = [
    ( 1, 1, 1.00, 0.35, 600, 340),   # w/k = 1.00
    ( 2, 1, 0.78, 2.10, 720, 300),   #       0.50
    ( 3, 2, 0.62, 4.80, 520, 280),   #       0.67
    ( 5, 2, 0.40, 1.15, 660, 320),   #       0.40
]
MOYENS = [
    ( 4, 3, 0.66, 5.10, 560, 210),   # w/k = 0.75
    ( 7, 2, 0.52, 3.60, 700, 200),   #       0.29
    (11, 4, 0.36, 0.80, 620, 230),   #       0.36
    (13, 3, 0.28, 5.25, 760, 190),   #       0.23
]

gh, gw = H // GRAIN, W // GRAIN
_Y, _X = np.mgrid[0:gh, 0:gw]
_px = _X * GRAIN + GRAIN / 2.0
_py = _Y * GRAIN + GRAIN / 2.0
_R  = np.hypot(_px - CX, _py - CY)
_T  = np.arctan2(_py - CY, _px - CX)
_ENV = 1.0 / (1.0 + np.exp(-(_R - 400) / 90.0))   # rien sur le plateau


def champ(harm, u):
    d = np.zeros((gh, gw))
    for (k, w, a, ph, r0, lg) in harm:
        d += a * np.sin(k * _T + w * u + ph) * np.exp(-((_R - r0) / lg) ** 2)
    return d * _ENV


def couche(nom, u, seuil):
    """Masque booleen d'une couche de nuages a l'instant u."""
    h = LOINTAINS if nom == 'lointains' else MOYENS
    return champ(h, u) > seuil


def frame(u, s_loin=0.20, s_moy=0.30):
    """Rendu complet : ciel uni + deux couches de nuages superposees."""
    small = np.zeros((gh, gw, 3), int)
    small[:] = CIEL
    loin = couche('lointains', u, s_loin)
    moy  = couche('moyens',    u, s_moy)
    small[loin] = NUAGE          # masses de fond, pales
    small[moy]  = NUAGE          # formations plus serrees
    small[loin & moy] = OMBRE    # la ou les deux se superposent
    return np.repeat(np.repeat(small, GRAIN, 0), GRAIN, 1)
