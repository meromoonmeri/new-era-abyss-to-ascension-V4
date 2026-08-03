#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ciel_cinematique.py — ciel en 3 phases : calme -> couvert -> orage.

ARCHITECTURE, ET SA CONTRAINTE
==============================
Il n'existe AUCUNE API GROUND: pour piloter une couche de tuiles
(verifie : les methodes GROUND: employees dans le mod ne touchent pas
aux Layers). Un script ne peut donc PAS declencher la phase 2 ou 3.
Consequence assumee : les trois phases forment UNE SEULE boucle
continue de 24 frames. Le ciel passe du calme a l'orage puis revient
au calme, en permanence, comme une meteo qui evolue d'elle-meme.
C'est la seule facon d'obtenir une transition progressive sans
intervention de script.

    frames  0..7    phase 1  ciel clair, nuages rares et pales
    frames  8..15   phase 2  assombrissement, nuages plus nombreux
    frames 16..23   phase 3  orage, masses sombres et epaisses
    puis retour progressif vers la frame 0 (la courbe est cyclique)

PARALLAXE — deux couches a vitesses differentes
    Nuages_Loin   FrameLength 30, k faibles, grandes masses, lent
    Nuages_Pres   FrameLength 18, k eleves, formations serrees, vif
Le rapport 30/18 n'est pas entier : les deux plans se dephasent, le
motif combine ne se repete qu'au bout de 24*30 et 24*18 frames.

DEGRADE DE CIEL : la carte d'origine a deja deux tons de fond,
(247,247,255) en bas et (175,207,239) en haut. On conserve ce
principe : le ciel est un degrade vertical entre deux teintes qui
evoluent avec la phase.

STYLE : palette 5 bits DS (composantes 8k-1), grain de 4 px, aplats.
"""
import numpy as np, math

W, H = 1152, 1344
CX, CY = 580, 668
GRAIN = 4
NF = 24                      # 8 frames par phase

def _ds(v):
    return max(0, min(255, int(round((v + 1) / 8)) * 8 - 1))
def C(r, g, b):
    return np.array([_ds(r), _ds(g), _ds(b)])

# Trois climats. Pour chacun : ciel haut, ciel bas, nuage clair, nuage sombre.
PHASES = [
    # phase 1 — calme
    dict(haut=C(175,207,239), bas=C(247,247,255),
         nua=C(247,247,255),  omb=C(215,231,247), seuil=0.34),
    # phase 2 — le temps se couvre
    dict(haut=C(128,144,184), bas=C(196,204,228),
         nua=C(215,219,239),  omb=C(160,168,200), seuil=0.20),
    # phase 3 — orage
    dict(haut=C(56,60,88),    bas=C(112,116,148),
         nua=C(136,140,176),  omb=C(80,84,116),   seuil=0.10),
]

# (k angulaire, w vitesse entiere, amplitude, phase, rayon, largeur)
LOIN = [(1,1,1.00,0.35,600,340), (2,1,0.78,2.10,720,300),
        (3,2,0.62,4.80,520,280), (5,2,0.40,1.15,660,320)]
PRES = [(4,3,0.66,5.10,560,210), (7,2,0.52,3.60,700,200),
        (11,4,0.36,0.80,620,230), (13,3,0.28,5.25,760,190)]

gh, gw = H // GRAIN, W // GRAIN
_Y, _X = np.mgrid[0:gh, 0:gw]
_px = _X * GRAIN + GRAIN / 2.0
_py = _Y * GRAIN + GRAIN / 2.0
_R = np.hypot(_px - CX, _py - CY)
_T = np.arctan2(_py - CY, _px - CX)
_ENV = 1.0 / (1.0 + np.exp(-(_R - 400) / 90.0))
_VY = (_py / H)[:, :, None]          # 0 en haut, 1 en bas


def phase_continue(i):
    """Position dans le cycle meteo, 0..3..0. Courbe douce, sans palier."""
    u = i / NF
    # 0 -> 1 -> 2 -> 1 -> 0 lissé : une sinusoide relevee
    return 2.0 * (1.0 - math.cos(2 * math.pi * u)) / 2.0


def melange(p):
    """Interpole les quatre teintes entre les phases entieres."""
    a = int(math.floor(p)) % 3
    b = min(a + 1, 2)
    f = p - math.floor(p)
    out = {}
    for k in ('haut', 'bas', 'nua', 'omb'):
        out[k] = (PHASES[a][k] * (1 - f) + PHASES[b][k] * f)
    out['seuil'] = PHASES[a]['seuil'] * (1 - f) + PHASES[b]['seuil'] * f
    return out


def champ(harm, u):
    """Densite de nuage.

    Mesure sur les nuages d'origine : compacite 4*pi*A/P^2 = 0,177.
    Deux echecs avant d'y arriver :
      - sinusoides seules            -> 0,48, taches molles
      - harmoniques angulaires x11   -> bord decoupe mais EN RAYONS,
        un effet d'explosion, pas un ciel.
    Cause du second : les termes en k*_T elevé produisent des secteurs
    fins qui partent du centre. Une masse nuageuse n'a pas d'axe.
    Solution : le decoupage vient d'un bruit en COORDONNEES
    CARTESIENNES (sin(x/a)*sin(y/b)), qui n'a aucune direction
    privilegiee, module par les harmoniques angulaires basses qui
    portent le mouvement de rotation.

    Tout multiplicateur de `u` reste ENTIER : sinon la boucle saute.
    """
    d = np.zeros((gh, gw))
    for (k, w, a, ph, r0, lg) in harm:
        ang = np.sin(k * _T + w * u + ph)
        d += a * ang * np.exp(-((_R - r0) / lg) ** 2)
    # grain cartesien : casse le bord sans creer de rayons.
    gx1 = np.sin(_px / 47.0 + u) * np.sin(_py / 39.0 - u)
    gx2 = np.sin(_px / 23.0 - u) * np.sin(_py / 27.0 + u)
    d = d + 0.34 * gx1 + 0.20 * gx2
    return d * _ENV


def fond(cfg):
    """Degrade vertical, quantifie sur la rampe DS pour rester en aplats."""
    g = cfg['haut'][None, None, :] * (1 - _VY) + cfg['bas'][None, None, :] * _VY
    g = (np.round((g + 1) / 8) * 8 - 1).clip(0, 255)
    return g.astype(int)


def frame_loin(i):
    """Couche lointaine : le degrade de ciel + les grandes masses."""
    cfg = melange(phase_continue(i))
    img = fond(cfg)
    m = champ(LOIN, 2 * math.pi * i / NF) > cfg['seuil']
    img[m] = cfg['omb'].astype(int)
    return np.repeat(np.repeat(img, GRAIN, 0), GRAIN, 1), m


def frame_pres(i):
    """Couche proche : formations serrees, en transparence."""
    cfg = melange(phase_continue(i))
    m = champ(PRES, 2 * math.pi * i / NF) > cfg['seuil'] + 0.10
    col = cfg['nua'].astype(int)
    return m, col


# ==================================================================
# MER DE NUAGES EN CONTREBAS + BROUILLARD DE PLATEAU
# ==================================================================
# Mesures : le decor s'arrete a y=1343, le bas des falaises est vers
# y=1255, le plateau praticable occupe y 424..960.
#
# MER DE NUAGES : une nappe dense sous les falaises, qui donne
# l'altitude. Elle est CARTESIENNE (pas de rotation) : une mer de
# nuages vue d'un sommet defile lentement a l'horizontale, elle ne
# tourne pas autour de soi. Densite qui croit vers le bas de l'image.
#
# BROUILLARD : une echarpe qui traverse le plateau. Elle passe DEVANT
# le decor (couche superieure) et se dissipe sur les bords pour ne
# jamais masquer les entites. Amplitude volontairement faible : un
# brouillard opaque rendrait le combat illisible.

MER_Y0 = 1180.0     # ligne ou la mer commence a apparaitre
MER_L  = 190.0      # douceur de la montee

def mer(u):
    """Nappe de nuages sous les falaises. Defilement horizontal lent."""
    v = 1.0 / (1.0 + np.exp(-(_py - MER_Y0) / 46.0))     # 0 en haut, 1 en bas
    n = (np.sin(_px / 82.0 + u) * 0.60
         + np.sin(_px / 41.0 - u) * 0.34
         + np.sin(_px / 26.0 + 2 * u) * 0.22
         + np.sin(_py / 33.0 - u) * 0.28)
    return (n * 0.5 + 0.55) * v

def brouillard(u):
    """Echarpe qui traverse le plateau.

    Premier essai : bande de 105 px de large, seuil 0,34 -> 11,9 % du
    decor couvert, mais visuellement le plateau etait AVALE et les
    menhirs disparaissaient. Un brouillard de sommet est une echarpe
    FINE et discontinue, pas une nappe.
    Corrige : bande plus etroite (54 px), grain plus contraste pour la
    trouer, et attenuation forte au centre du plateau pour degager la
    zone de combat.
    """
    centre = 690.0 + 150.0 * np.sin(u)
    bande = np.exp(-((_py - centre + 46.0 * np.sin(_px / 190.0 + u)) / 54.0) ** 2)
    # grain tres contraste : l'echarpe est trouee, pas pleine
    grain = (np.sin(_px / 44.0 + 2 * u) * np.sin(_py / 31.0 - u)
             + 0.6 * np.sin(_px / 21.0 - u))
    grain = np.clip(grain * 0.8 + 0.15, 0.0, 1.0)
    # se dissipe au centre du plateau (lisibilite du combat) et au loin
    creux = 1.0 - 0.75 * np.exp(-(_R / 210.0) ** 2)
    loin = np.exp(-((_R - 330.0) / 300.0) ** 2)
    return bande * grain * creux * loin
