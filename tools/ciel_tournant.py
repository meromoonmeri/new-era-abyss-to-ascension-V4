#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ciel_tournant.py — nuages en rotation, composition unique et irreguliere.

TROIS DEFAUTS DE LA VERSION PRECEDENTE, ET LEUR CAUSE
=====================================================
1. « on voit la forme des images decoupees »
   Le masque de compositing etait la FORME des nuages PixelLab
   (548008 px, 42 % de la zone ciel). Les nuages tournaient donc a
   l'interieur d'une decoupe immobile : un nuage qui bouge dans un
   trou en forme de nuage. Corrige : le masque est desormais TOUTE la
   zone ciel (1302502 px), le plateau seul est preserve.
2. « on voit trop la construction par secteurs »
   26 bouffees repliquees a l'identique dans 8 secteurs de 45 deg.
   Corrige : plus aucune replication, voir ci-dessous.
3. « couronne de nuages artificielle »
   Les bouffees etaient des disques parfaits poses sur un anneau.
   Corrige : champ continu, densite modulee par le rayon.

COMMENT ON BOUCLE SANS SYMETRIE
===============================
La densite de nuage est une somme d'harmoniques en ANGLE :

    d(r,t) = SUM_i  a_i * sin(k_i * t + phi_i) * g_i(r)

Les k_i sont des ENTIERS. Une fonction de la forme sin(k*t) est
2*pi-periodique pour tout k entier : apres un tour complet, le champ
est rigoureusement identique. La boucle est donc exacte sur 360 deg,
et non sur 45 deg — il n'y a plus aucun secteur repete.
Les k_i sont volontairement premiers entre eux (1,2,3,5,7,11,13) :
aucun sous-multiple commun, donc aucune symetrie d'ordre N.

STYLE — mesure sur la carte d'origine, pas suppose
    2 couleurs : (247,247,255) ciel a 59,9 %, (215,231,247) nuage.
    grain de 4 px (image native 288x336 agrandie x4).
On respecte les deux : rendu sur grille au grain 4, deux tons pleins,
plus une nuance d'ombre tres legere pour eviter l'aplat total.
"""
import numpy as np, math

W, H = 1152, 1344
CX, CY = 580, 668
GRAIN = 4
CIEL = np.array([247, 247, 255])
NUAGE = np.array([215, 231, 247])
OMBRE = np.array([207, 223, 243])      # nuance discrete, palette DS

# Harmoniques : (frequence entiere, amplitude, phase, rayon pref, largeur)
HARM = [
    ( 1, 1.00, 0.35, 560, 300),
    ( 2, 0.72, 2.10, 700, 260),
    ( 3, 0.60, 4.80, 480, 240),
    ( 5, 0.45, 1.15, 640, 300),
    ( 7, 0.34, 3.60, 760, 240),
    (11, 0.24, 0.80, 560, 280),
    (13, 0.18, 5.25, 680, 260),
]

gh, gw = H // GRAIN, W // GRAIN
_Y, _X = np.mgrid[0:gh, 0:gw]
_px = _X * GRAIN + GRAIN / 2.0
_py = _Y * GRAIN + GRAIN / 2.0
_R = np.hypot(_px - CX, _py - CY)
_T = np.arctan2(_py - CY, _px - CX)

# Enveloppe radiale : pas de nuage sur le plateau, densite qui monte
# vers l'exterieur puis se maintient. C'est ce qui evite l'anneau net.
_ENV = 1.0 / (1.0 + np.exp(-(_R - 400) / 90.0))


def champ(rot):
    """Densite de nuage, tournee de `rot` radians."""
    d = np.zeros((gh, gw))
    t = _T - rot
    for (k, a, ph, r0, lg) in HARM:
        d += a * np.sin(k * t + ph) * np.exp(-((_R - r0) / lg) ** 2)
    return d * _ENV


def frame(rot, seuil=0.16):
    """Une frame : ciel uniforme, nuages en deux tons."""
    d = champ(rot)
    small = np.zeros((gh, gw, 3), int)
    small[:] = CIEL
    small[d > seuil] = NUAGE
    small[d > seuil + 0.30] = OMBRE
    return np.repeat(np.repeat(small, GRAIN, 0), GRAIN, 1)
