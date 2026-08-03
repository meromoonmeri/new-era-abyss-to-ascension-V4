#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ENTREE DES RUINES TORDUES — clairiere, riviere, pont, bouche de grotte.
Style Chunsoft / Pokemon Donjon Mystere, perspective 2,5D vue de dessus
legerement inclinee.

--------------------------------------------------------------------
POURQUOI 576 x 408 PX — ce n'est pas un choix esthetique
--------------------------------------------------------------------
L'ancien ground (719037f) fait 576 x 408 et porte SIX entites dont les
scripts dependent :

    Dungeon_Entrance       (504,160) 44x48   -> la bouche de grotte
    Kangaskhan_Rock        (408,176) 24x24   -> rive EST
    Main_Entrance_Marker   ( 24,192) 16x16   -> arrivee par l'OUEST
    TEAMMATE_1/2/3         (104,160) 16x16   -> rive OUEST

En conservant la taille a l'identique, le facteur d'echelle des entites
vaut 1,0 : aucune ne bouge, aucun script ne casse. La composition
DECOULE de ces coordonnees :
    arrivee a l'ouest -> clairiere herbeuse a gauche
    grotte a l'est    -> falaise rocheuse a droite
    la riviere coule NORD->SUD entre les deux, et le PONT la franchit a
    hauteur des entites (y 150-206), donc « de l'autre rive on entre
    dans la grotte ».
La carte fait 1,8 x 1,7 ecran (320x240) : EdgeView=Clamp, jamais de
bande noire.

--------------------------------------------------------------------
CE QUI A ETE MESURE SUR LA PLANCHE OFFICIELLE — et corrige
--------------------------------------------------------------------
Reference : `Entrance - Foret Lugubre ch6.png` (600x312, 124 couleurs),
planche Chunsoft du meme jeu.

    critere                        OFFICIEL   1re version   corrige
    ecart moyen au voisin de droite   3,48       4,69          ~3,5
    pixels identiques au voisin        63 %       90 %          ~65 %

90 % de pixels identiques a leur voisin, c'est un decor en APLATS —
des taches facon camouflage. Chunsoft ne procede pas ainsi : chaque
zone porte un GRAIN fin. D'ou la refonte : plus aucun seuillage de
bruit sur de grandes surfaces, mais des OBJETS DESSINES un par un
(houppiers, buissons, pierres, planches) poses sur un fond texture au
pixel. Le grain vient d'un dither de Bayer 4x4 applique a l'echelle du
pixel, pas d'un fbm etale.

Palette : toutes les composantes des planches officielles sont des
multiples de 8 moins 1 -> palette 5 bits de la DS. `ds5()` y ramene
chaque pixel. Sans cela le decor jure a cote des sprites.

--------------------------------------------------------------------
LES QUATRE COUCHES ET LEURS CADENCES
--------------------------------------------------------------------
    Base   decor fixe                      1 frame
    Eau    riviere                         8 frames, FrameLength  6
    Herbe  herbe, houppiers, buissons      8 frames, FrameLength 20
    Ciel   nuages                          8 frames, FrameLength 30

Cadences premieres entre elles : 6, 20 et 30 ne retombent en phase
qu'au bout de 60 images, l'oeil ne percoit aucune boucle.

Le mouvement est CYCLIQUE par construction (phase = i/8 injectee dans
des sinus), pas par decalage d'image : a la 8e frame le motif est
revenu a l'identique. L'herbe ne se DEPLACE pas, sa silhouette change
d'un pixel — un sprite qui glisse trahirait le procede.

Seules les cellules qui bougent figurent dans les planches animees.
"""
import copy
import json
import math
import os
import sys

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import png2tileset as P  # noqa: E402

ROOT = P.ROOT
W, H = 576, 408
PAS = 24                      # TexSize 3
NX, NY = W // PAS, H // PAS   # 24 x 17
NF = 8

# ------------------------------------------------------------------ palette
# Relevee sur les planches officielles, ramenee en 5 bits.
V0 = (31,  47,  23)      # feuillage nuit
V1 = (55,  71,  31)
V2 = (79,  95,  39)      # herbe de base (45056 px sur la ref)
V3 = (95, 111,  47)
V4 = (119, 143, 55)
V5 = (167, 191, 63)
V6 = (199, 215, 63)      # herbe plein soleil (9077 px sur la ref)

R0 = (55,  47,  47)      # roche nuit
R1 = (95,  87,  79)
R2 = (135, 119, 111)     # roche (3315 px)
R3 = (183, 175, 159)     # roche claire (4483 px)
R4 = (215, 207, 199)

E0 = (23,  55,  95)      # eau profonde
E1 = (47,  95, 159)
E2 = (71, 135, 199)
E3 = (127, 183, 223)
E4 = (207, 231, 247)     # ecume

B0 = (55,  39,  31)      # bois nuit
B1 = (95,  71,  47)
B2 = (143, 111, 71)
B3 = (183, 151, 103)

C0 = (95, 175, 239)      # ciel haut
C1 = (183, 223, 247)     # ciel horizon
NU = (247, 247, 247)
NO = (199, 215, 231)
LO = (151, 175, 191)     # crete lointaine
GR = (15,  15,  23)      # noir de grotte

YS = np.arange(H)[:, None]
XS = np.arange(W)[None, :]

CIEL_Y = 88
PONT_Y0, PONT_Y1 = 150, 206
GROTTE_CX, GROTTE_CY, GROTTE_RX, GROTTE_RY = 526, 182, 30, 34

BAYER = np.array([[0, 8, 2, 10], [12, 4, 14, 6],
                  [3, 11, 1, 9], [15, 7, 13, 5]]) / 16.0
BAY = np.tile(BAYER, (H // 4 + 1, W // 4 + 1))[:H, :W]

_CACHE_FIN = {}


def _fin(seed):
    """fbm de haute frequence, mis en cache (appele des dizaines de fois)."""
    if seed not in _CACHE_FIN:
        _CACHE_FIN[seed] = fbm(64.0, 2, seed)
    return _CACHE_FIN[seed]


def ds5(a):
    q = (np.clip(a, 0, 255).astype(int) // 8) * 8 + 7
    return np.clip(q, 0, 255).astype(np.uint8)


def grain(seed, ech=1.0):
    """Grain FIN, correle d'un pixel a l'autre.

    Premiere version : bruit blanc par pixel. Mesure -> ecart moyen au
    voisin de 15,46 contre 3,48 sur la planche officielle, soit de la
    neige. Un decor Chunsoft est PEINT : deux pixels voisins restent
    proches. On passe donc a un fbm de periode ~3 px, qui casse l'aplat
    sans granuler.
    """
    return _fin(seed) * ech


def _lisse(gr, rng):
    gy, gx = gr
    g = rng.random((gy + 1, gx + 1))
    ys = np.linspace(0, gy, H, endpoint=False)
    xs = np.linspace(0, gx, W, endpoint=False)
    y0, x0 = ys.astype(int), xs.astype(int)
    fy = ((1 - np.cos((ys - y0) * math.pi)) / 2)[:, None]
    fx = ((1 - np.cos((xs - x0) * math.pi)) / 2)[None, :]
    a = g[np.ix_(y0, x0)]
    b = g[np.ix_(y0, x0 + 1)]
    c = g[np.ix_(y0 + 1, x0)]
    d = g[np.ix_(y0 + 1, x0 + 1)]
    return (a * (1 - fx) + b * fx) * (1 - fy) + (c * (1 - fx) + d * fx) * fy


def fbm(base, oct_, seed):
    rng = np.random.default_rng(seed)
    out = np.zeros((H, W))
    amp, tot = 1.0, 0.0
    for k in range(oct_):
        out += amp * _lisse((max(1, int(base * 2 ** k * H / W)),
                             int(base * 2 ** k)), rng)
        tot += amp
        amp *= 0.5
    return out / tot


def pose(img, masque, coul):
    for k in range(3):
        img[:, :, k] = np.where(masque, coul[k], img[:, :, k])


# ------------------------------------------------------------------ geometrie
def riviere_bords(y):
    """La riviere serpente du nord au sud."""
    cx = 258 + 30 * np.sin(y / 104.0) + 11 * np.sin(y / 39.0 + 0.7)
    demi = 52 + 12 * np.sin(y / 77.0 + 1.1)
    return cx - demi, cx + demi


RIV_G, RIV_D = riviere_bords(YS)
RIVIERE = (XS >= RIV_G) & (XS <= RIV_D) & (YS >= 86)

_fal = fbm(3.5, 4, 21)
FALAISE = (XS >= 438 + 26 * np.sin(YS / 58.0) + 30 * (_fal - .5) * 2) \
    & (YS <= 306)
# on degage le parvis devant la grotte pour pouvoir y entrer
FALAISE &= ~((XS >= GROTTE_CX - 62) & (XS <= GROTTE_CX + 62)
             & (YS >= GROTTE_CY + GROTTE_RY - 4) & (YS <= 262))

ARCHE = (((XS - GROTTE_CX) / GROTTE_RX) ** 2
         + ((YS - GROTTE_CY) / GROTTE_RY) ** 2) < 1.0
ARCHE &= YS <= GROTTE_CY + GROTTE_RY


def _objets():
    """Liste FIXE des houppiers, buissons et pierres.

    Une liste explicite plutot qu'un seuillage de bruit : c'est ce qui
    donne des arbres qui ressemblent a des arbres, avec un tronc, une
    ombre portee et un cote eclaire.
    """
    rng = np.random.default_rng(2026)
    arbres, buissons, pierres = [], [], []

    # lisiere nord de la rive ouest
    x = -6
    while x < 250:
        y = 126 + rng.integers(-10, 12)
        arbres.append((x, y, rng.integers(21, 29)))
        x += rng.integers(24, 34)
    # bosquet ouest, le long du bord
    y = 156
    while y < 330:
        arbres.append((rng.integers(-8, 16), y, rng.integers(20, 27)))
        y += rng.integers(26, 38)
    # quelques arbres isoles dans la clairiere
    for p in ((78, 316), (150, 150), (196, 330)):
        arbres.append((p[0], p[1], rng.integers(19, 25)))

    # buissons : bordure basse + rives
    x = -8
    while x < W + 8:
        buissons.append((x, 384 + rng.integers(-8, 8), rng.integers(11, 17)))
        x += rng.integers(13, 20)
    for _ in range(26):
        yy = int(rng.integers(150, 340))
        g, d = riviere_bords(np.array([[yy]]))
        cote = rng.random() < .5
        xx = int(g[0, 0]) - rng.integers(8, 26) if cote \
            else int(d[0, 0]) + rng.integers(8, 26)
        if 4 < xx < W - 4:
            buissons.append((xx, yy, int(rng.integers(8, 13))))

    # pierres : parvis de la grotte et rives
    for _ in range(22):
        yy = int(rng.integers(120, 300))
        g, d = riviere_bords(np.array([[yy]]))
        cote = rng.random() < .5
        xx = int(g[0, 0]) - rng.integers(3, 14) if cote \
            else int(d[0, 0]) + rng.integers(3, 14)
        if 4 < xx < W - 4:
            pierres.append((xx, yy, int(rng.integers(4, 9))))
    for _ in range(14):
        pierres.append((int(rng.integers(452, 566)),
                        int(rng.integers(232, 300)),
                        int(rng.integers(5, 11))))
    return arbres, buissons, pierres


ARBRES, BUISSONS, PIERRES = _objets()


def _disque(cx, cy, r, ecrase=0.82):
    return (((XS - cx) / float(r)) ** 2
            + ((YS - cy) / (r * ecrase)) ** 2) < 1.0


# masques statiques utiles aux collisions
def _masque_feuillage(phase=0.0):
    m = np.zeros((H, W), bool)
    for i, (cx, cy, r) in enumerate(ARBRES):
        w = 1.4 * math.sin(2 * math.pi * phase + i * 1.7)
        m |= _disque(cx, cy, r + w)
    return m


def _masque_buissons(phase=0.0):
    m = np.zeros((H, W), bool)
    for i, (cx, cy, r) in enumerate(BUISSONS):
        w = 1.1 * math.sin(2 * math.pi * phase + i * 2.3)
        m |= _disque(cx, cy, r + w, 0.72)
    return m


def _masque_pierres():
    m = np.zeros((H, W), bool)
    for (cx, cy, r) in PIERRES:
        m |= _disque(cx, cy, r, 0.78)
    return m


# Emprise de la riviere sur toute la hauteur du tablier : le pont doit
# reposer sur les DEUX berges, pas s'arreter dans l'eau. Mesure de la
# 1re version : le tablier finissait a 18 px de la rive droite.
_bande = slice(PONT_Y0, PONT_Y1 + 1)
PONT_XG = float(RIV_G[_bande, 0].min()) - 34
PONT_XD = float(RIV_D[_bande, 0].max()) + 34
PONT = (YS >= PONT_Y0) & (YS <= PONT_Y1) & (XS >= PONT_XG) & (XS <= PONT_XD)


# ------------------------------------------------------------------ peinture
def peindre(ph_eau=0.0, ph_herbe=0.0, ph_ciel=0.0):
    img = np.zeros((H, W, 3), float)

    # ---------------------------------------------------------- CIEL
    t = np.clip(YS / float(CIEL_Y + 34), 0, 1)
    for k in range(3):
        img[:, :, k] = C0[k] + (C1[k] - C0[k]) * t
    nu = fbm(2.4, 4, 101)
    ond = 0.05 * np.sin(2 * math.pi * ph_ciel + XS / 44.0 + YS / 21.0)
    v = nu + ond
    haut = YS < CIEL_Y + 20
    pose(img, haut & (v > 0.545) & (BAY > .28), NO)
    pose(img, haut & (v > 0.585), NU)

    # CRETE LOINTAINE — profil de montagnes, pas une bande.
    # 1re version : un rectangle gris uniforme barrait l'image sur
    # toute la largeur. Ici le profil est un relief (deux sinus + bruit
    # basse frequence) et la couleur se fond vers le ciel en montant,
    # ce qui donne la perspective atmospherique de la reference.
    cr = fbm(2.2, 3, 55)
    prof_h = (CIEL_Y - 26
              + 13 * np.sin(XS / 61.0)
              + 8 * np.sin(XS / 23.0 + 1.9)
              + 16 * (cr - .5) * 2)
    mont = (YS >= prof_h) & (YS < CIEL_Y + 18)
    # plus on est haut sur le relief, plus la brume l'eclaircit
    tt = np.clip((YS - prof_h) / 30.0, 0, 1)
    for k in range(3):
        c = C1[k] + (LO[k] - C1[k]) * tt
        img[:, :, k] = np.where(mont, c, img[:, :, k])
    # arete eclairee
    pose(img, mont & ~np.roll(mont, 2, 0), (183, 199, 215))

    # ---------------------------------------------------------- SOL
    sol = YS >= CIEL_Y + 8
    gn = fbm(7.0, 3, 3)
    gg = grain(5, 1.0)
    sw = 0.030 * np.sin(2 * math.pi * ph_herbe + XS / 19.0 + YS / 27.0)
    v = gn * .74 + gg * .21 + BAY * .05 + sw
    herbe = np.zeros((H, W, 3))
    for k in range(3):
        c = np.full((H, W), float(V2[k]))
        c = np.where(v < .40, V1[k], c)
        c = np.where((v >= .46) & (v < .55), V3[k], c)
        c = np.where(v >= .55, V4[k], c)
        herbe[:, :, k] = c
    # clairiere : trouee de lumiere, centree sur l'arrivee du joueur
    d = np.sqrt(((XS - 122) / 104.0) ** 2 + ((YS - 262) / 90.0) ** 2)
    for k in range(3):
        herbe[:, :, k] = np.where((d < 1.0) & (v > .40 + .30 * d),
                                  V5[k], herbe[:, :, k])
        herbe[:, :, k] = np.where((d < .62) & (v > .52 + .24 * d),
                                  V6[k], herbe[:, :, k])
    for k in range(3):
        img[:, :, k] = np.where(sol, herbe[:, :, k], img[:, :, k])

    # sentier de terre battue, de l'arrivee vers le pont
    # Il part du marqueur d'arrivee (24,192) et rejoint le tablier du
    # pont : un sentier qui s'arrete au milieu de l'herbe ne raconte rien.
    ycible = (PONT_Y0 + PONT_Y1) / 2.0
    tt = np.clip((XS - 10) / max(1.0, PONT_XG - 10), 0, 1)
    sy = 192 + (ycible - 192) * (tt ** 1.5) + 16 * np.sin(tt * 3.4)
    sent = sol & (np.abs(YS - sy) < 13) & (XS < PONT_XG + 4)
    st = grain(6, 1.0)
    for k in range(3):
        c = np.where(st > .5, R3[k], R2[k]).astype(float)
        c = np.where(st > .84, R4[k], c)
        img[:, :, k] = np.where(sent, c, img[:, :, k])

    # ---------------------------------------------------------- RIVIERE
    u = (XS - RIV_G) / np.maximum(1.0, RIV_D - RIV_G)
    fil = (np.sin(YS / 6.0 - 2 * math.pi * ph_eau + np.sin(XS / 17.0) * 1.5)
           + np.sin(YS / 11.0 - 2 * math.pi * ph_eau * 2 + XS / 23.0)) / 2
    prof = 1 - np.abs(u - .5) * 2
    ge = grain(9, 1.0)
    v = prof * .60 + fil * .26 + ge * .09 + BAY * .05
    eau = np.zeros((H, W, 3))
    for k in range(3):
        c = np.full((H, W), float(E2[k]))
        c = np.where(v < .26, E3[k], c)
        c = np.where((v >= .40) & (v < .64), E1[k], c)
        c = np.where(v >= .64, E0[k], c)
        eau[:, :, k] = c
    # ecume aux rives + reflets qui filent au milieu
    pose(eau, (np.abs(u - .5) > .40) & (fil + (ge - .5) * .7 > .52), E4)
    pose(eau, (prof > .5) & (fil > .82), E4)
    for k in range(3):
        img[:, :, k] = np.where(RIVIERE, eau[:, :, k], img[:, :, k])
    # berge : liseré de terre humide
    berge = (~RIVIERE) & (np.roll(RIVIERE, 4, 1) | np.roll(RIVIERE, -4, 1)) \
        & sol
    pose(img, berge & (grain(11, 1.) > .35), R1)

    # ---------------------------------------------------------- FALAISE
    # Relief BASSE frequence : de vrais pans de roche, pas du mouchete.
    # Mesure 1re version : ecart au voisin 27,7 contre 4,6 sur la
    # planche officielle — la falaise grouillait.
    rn = fbm(3.0, 3, 12)
    rg = grain(13, 1.0)
    # pente : la lumiere vient du haut-gauche, on eclaire les faces
    # tournees vers elle. C'est le modele qui donne le volume, pas le bruit.
    gy_, gx_ = np.gradient(rn)
    pente = np.clip(.5 - (gx_ + gy_) * 26.0, 0, 1)
    v = rn * .34 + pente * .48 + rg * .13 + BAY * .05
    roche = np.zeros((H, W, 3))
    for k in range(3):
        c = np.full((H, W), float(R2[k]))
        c = np.where(v < .38, R1[k], c)
        c = np.where(v < .27, R0[k], c)
        c = np.where((v >= .52) & (v < .68), R3[k], c)
        c = np.where(v >= .68, R4[k], c)
        roche[:, :, k] = c
    for k in range(3):
        img[:, :, k] = np.where(FALAISE, roche[:, :, k], img[:, :, k])
    # FACE verticale : c'est elle qui donne le relief 2,5D
    face = FALAISE & ~np.roll(FALAISE, -16, 0)
    pose(img, face, R0)
    pose(img, face & ~np.roll(face, -5, 0) & (rg > .4), R1)
    # arete eclairee au sommet
    pose(img, FALAISE & ~np.roll(FALAISE, 4, 0) & (rg > .3), R4)

    # bouche de grotte : anneau de pierres claires + noir profond
    anneau = (((XS - GROTTE_CX) / (GROTTE_RX + 9.)) ** 2
              + ((YS - GROTTE_CY) / (GROTTE_RY + 9.)) ** 2) < 1.0
    anneau &= (YS <= GROTTE_CY + GROTTE_RY) & ~ARCHE
    pose(img, anneau, R3)
    pose(img, anneau & (rg > .55), R4)
    pose(img, ARCHE, GR)
    # degrade d'entree : le fond de la grotte s'eclaire un peu en bas
    hh = np.clip((YS - (GROTTE_CY - GROTTE_RY)) / (2.0 * GROTTE_RY), 0, 1)
    for k in range(3):
        img[:, :, k] = np.where(ARCHE & (hh > .72) & (BAY > .55),
                                R0[k], img[:, :, k])

    # ---------------------------------------------------------- ARBRES
    fg = grain(17, 1.0)
    fn = fbm(9.0, 3, 19)
    for i, (cx, cy, r) in enumerate(ARBRES):
        w = 1.4 * math.sin(2 * math.pi * ph_herbe + i * 1.7)
        rr = r + w
        # tronc
        tr = (np.abs(XS - cx) < 3) & (YS >= cy + rr * .55) \
            & (YS < cy + rr * .55 + 13)
        pose(img, tr, B0)
        pose(img, tr & (XS < cx), B1)
        # ombre portee au sol
        pose(img, _disque(cx + 4, cy + rr * .70, rr * .82, .34)
             & ~_disque(cx, cy, rr), V0)
        # houppier : 3 lobes, pas un cercle parfait
        hou = _disque(cx, cy, rr)
        hou |= _disque(cx - rr * .52, cy + rr * .12, rr * .62)
        hou |= _disque(cx + rr * .50, cy + rr * .16, rr * .58)
        val = fn * .74 + fg * .21 + BAY * .05
        # eclairage : la lumiere vient du haut-gauche
        ecl = ((cx - XS) / (rr * 2.0) + (cy - YS) / (rr * 1.6)) + .5
        vv = val * .55 + ecl * .45
        for k in range(3):
            c = np.full((H, W), float(V1[k]))
            c = np.where(vv < .40, V0[k], c)
            c = np.where((vv >= .52) & (vv < .64), V2[k], c)
            c = np.where((vv >= .64) & (vv < .76), V3[k], c)
            c = np.where(vv >= .76, V4[k], c)
            img[:, :, k] = np.where(hou, c, img[:, :, k])
        # liseré clair sur le bord eclaire
        bordh = hou & ~np.roll(np.roll(hou, 2, 0), 2, 1)
        pose(img, bordh & (fg > .30), V4)

    # ---------------------------------------------------------- BUISSONS
    bg = grain(23, 1.0)
    bn = fbm(11.0, 3, 29)
    for i, (cx, cy, r) in enumerate(BUISSONS):
        w = 1.1 * math.sin(2 * math.pi * ph_herbe + i * 2.3)
        rr = r + w
        bu = _disque(cx, cy, rr, .72)
        bu |= _disque(cx - rr * .5, cy + 1, rr * .66, .70)
        bu |= _disque(cx + rr * .5, cy + 1, rr * .62, .70)
        val = bn * .74 + bg * .21 + BAY * .05
        ecl = ((cy - YS) / (rr * 1.3)) + .5
        vv = val * .5 + ecl * .5
        for k in range(3):
            c = np.full((H, W), float(V1[k]))
            c = np.where(vv < .42, V0[k], c)
            c = np.where((vv >= .56) & (vv < .70), V2[k], c)
            c = np.where(vv >= .70, V3[k], c)
            img[:, :, k] = np.where(bu, c, img[:, :, k])
        pose(img, bu & ~np.roll(bu, 2, 0) & (bg > .38), V4)

    # ---------------------------------------------------------- PIERRES
    pg = grain(31, 1.0)
    for (cx, cy, r) in PIERRES:
        pi = _disque(cx, cy, r, .78)
        pose(img, _disque(cx + 2, cy + r * .55, r * .85, .32), V0)
        ecl = ((cx - XS) / (r * 2.2) + (cy - YS) / (r * 1.8)) + .5
        vv = ecl * .74 + pg * .21 + BAY * .05
        for k in range(3):
            c = np.full((H, W), float(R2[k]))
            c = np.where(vv < .42, R1[k], c)
            c = np.where((vv >= .58) & (vv < .74), R3[k], c)
            c = np.where(vv >= .74, R4[k], c)
            img[:, :, k] = np.where(pi, c, img[:, :, k])

    # ---------------------------------------------------------- PONT
    # peint APRES la riviere : il passe par-dessus.
    ombre = (YS > PONT_Y1) & (YS <= PONT_Y1 + 8) & (XS >= PONT_XG) \
        & (XS <= PONT_XD) & RIVIERE
    pose(img, ombre, E0)

    wg = grain(37, 1.0)
    planche = ((YS - PONT_Y0) // 9) % 2 == 0
    for k in range(3):
        c = np.where(planche, B2[k], B1[k]).astype(float)
        c = np.where(wg > .78, B3[k], c)
        c = np.where((YS - PONT_Y0) % 9 == 0, B0[k], c)   # joints
        img[:, :, k] = np.where(PONT, c, img[:, :, k])
    # lisses haut et bas
    pose(img, PONT & (YS <= PONT_Y0 + 5), B3)
    pose(img, PONT & (YS <= PONT_Y0 + 1), B0)
    pose(img, PONT & (YS >= PONT_Y1 - 5), B1)
    pose(img, PONT & (YS >= PONT_Y1 - 1), B0)
    # poteaux aux quatre coins
    for px in (PONT_XG + 6, PONT_XD - 6):
        for py in (PONT_Y0 + 3, PONT_Y1 - 8):
            pose(img, (np.abs(XS - px) <= 2)
                 & (np.abs(YS - py) <= 5), B0)

    masques = {
        'riv': RIVIERE & ~PONT,
        'feuille': _masque_feuillage(ph_herbe) | _masque_buissons(ph_herbe),
        'ciel': (~sol) & ~FALAISE,
        'fal': FALAISE, 'arc': ARCHE, 'pont': PONT, 'sol': sol,
        'pierres': _masque_pierres(),
    }
    return ds5(img), masques


# ------------------------------------------------------------------ cellules
def cellules(masque):
    s = set()
    for gx in range(NX):
        for gy in range(NY):
            if masque[gy * PAS:(gy + 1) * PAS, gx * PAS:(gx + 1) * PAS].any():
                s.add((gx, gy))
    return s


def grille_obstacles(m):
    dur = (m['riv'] | m['feuille'] | m['fal'] | m['arc'] | m['pierres']
           | (~m['sol']))
    dur = dur & ~m['pont']
    b = np.zeros((NY, NX), bool)
    for gx in range(NX):
        for gy in range(NY):
            bl = dur[gy * PAS:(gy + 1) * PAS, gx * PAS:(gx + 1) * PAS]
            b[gy, gx] = bl.mean() > 0.45
    return b


def degager(bloque, cx, cy, rayon=2):
    """Force une petite zone libre autour d'une entite indispensable."""
    gx, gy = cx // PAS, cy // PAS
    for dx in range(-rayon, rayon + 1):
        for dy in range(-rayon, rayon + 1):
            x, y = gx + dx, gy + dy
            if 0 <= x < NX and 0 <= y < NY:
                bloque[y, x] = False


def main():
    ecrire = '--apply' in sys.argv
    base_img_a, m0 = peindre()
    base_img = Image.fromarray(base_img_a, 'RGB').convert('RGBA')

    frames = [base_img]
    for i in range(1, NF):
        p = i / float(NF)
        a, _ = peindre(ph_eau=p, ph_herbe=p, ph_ciel=p)
        frames.append(Image.fromarray(a, 'RGB').convert('RGBA'))

    base_img.save('/home/user/apercu_ruines_entree.png')

    # controle de facture, contre la planche officielle
    a = np.asarray(base_img.convert('RGB')).astype(int)
    ec = np.abs(a[:, 1:] - a[:, :-1]).mean()
    sm = (np.abs(a[:, 1:] - a[:, :-1]).sum(2) == 0).mean()
    print(f'carte {W}x{H} -> {NX}x{NY} cellules de {PAS} px')
    print(f'  facture : ecart voisin {ec:.2f} (officiel 3,48) | '
          f'identiques {sm*100:.0f} % (officiel 63 %)')

    # QUELLES CELLULES BOUGENT — par MESURE, pas par masque.
    #
    # Deduire les cellules animees d'un masque geometrique donne des
    # cellules mortes : mesure sur la couche Ciel, 37 cellules sur 73
    # etaient dans le masque « ciel » mais ne contenaient aucun nuage,
    # donc affichaient 8 frames identiques. C'est du poids de fichier
    # pour rien, et un aveu que le masque ment.
    # On compare donc reellement les 8 frames, cellule par cellule :
    # une cellule n'entre dans une couche animee que si elle CHANGE.
    a0 = np.asarray(frames[0]).astype(int)
    diff = np.zeros((H, W), bool)
    for f in frames[1:]:
        diff |= (np.abs(np.asarray(f).astype(int) - a0).sum(2) > 0)
    remue = cellules(diff)

    c_eau = cellules(m0['riv']) & remue
    c_herbe = (cellules(m0['feuille']) & remue) - c_eau
    c_ciel = (cellules(m0['ciel']) & remue) - c_eau - c_herbe
    bouge = c_eau | c_herbe | c_ciel
    print(f'  cellules animees : {len(bouge)}/{NX*NY} '
          f'(eau {len(c_eau)}, herbe {len(c_herbe)}, ciel {len(c_ciel)})')

    # une frame identique a la frame 0 = animation morte. On le mesure.
    ok = True
    for nom, cs in (('eau', c_eau), ('herbe', c_herbe), ('ciel', c_ciel)):
        if not cs:
            print(f'  ATTENTION : couche {nom} vide')
            continue
        pires = []
        for (gx, gy) in sorted(cs):
            box = (gx * PAS, gy * PAS, (gx + 1) * PAS, (gy + 1) * PAS)
            d0 = np.asarray(frames[0].crop(box)).astype(int)
            e = max(int(np.abs(np.asarray(frames[k].crop(box)).astype(int)
                               - d0).mean()) for k in range(1, NF))
            pires.append(e)
        mortes = sum(1 for e in pires if e == 0)
        print(f'  couche {nom:5s} : ecart median {int(np.median(pires))}, '
              f'{mortes}/{len(cs)} cellules immobiles')
        if mortes > len(cs) * .5:
            ok = False

    bloque = grille_obstacles(m0)
    for (cx, cy) in ((24, 192), (104, 160), (408, 176)):
        degager(bloque, cx, cy, 1)
    degager(bloque, 504, 160, 2)
    dep = (24 // PAS, 192 // PAS)
    arr = (504 // PAS, 160 // PAS)
    att, joignable, libre = P._connexite(bloque, dep, arr)
    print(f'  obstacles : {int(bloque.sum())}/{NX*NY} bloquees '
          f'({100*bloque.mean():.0f} %)')
    print(f'  jouabilite : {att}/{libre} atteignables depuis l entree, '
          f'grotte joignable = {joignable}')
    if not joignable:
        print('    ABANDON : on ne peut pas atteindre la grotte.')
        return 1
    if not ok:
        print('    ABANDON : une couche animee ne bouge pas.')
        return 1
    if not ecrire:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0

    base_grille = {}
    for gx in range(NX):
        for gy in range(NY):
            if (gx, gy) not in bouge:
                base_grille[(gx, gy)] = base_img.crop(
                    (gx * PAS, gy * PAS, (gx + 1) * PAS, (gy + 1) * PAS))
    P.ecrire_planche('Ruines_Entree_Base', PAS, base_grille)

    couches = []
    for nom, cs, flen in (('Eau', c_eau, 6), ('Herbe', c_herbe, 20),
                          ('Ciel', c_ciel, 30)):
        if not cs:
            continue
        noms = []
        for i in range(NF):
            g = {(gx, gy): frames[i].crop(
                (gx * PAS, gy * PAS, (gx + 1) * PAS, (gy + 1) * PAS))
                for (gx, gy) in cs}
            n = f'Ruines_Entree_{nom}_{i+1}'
            P.ecrire_planche(n, PAS, g)
            noms.append(n)
        couches.append((nom, cs, noms, flen))
    P.reindexer()

    doc = P.gabarit_rsground('cloven_ruins_entrance')
    obj = doc['Object']
    obj['TexSize'] = PAS // 8
    obj['EdgeView'] = 1
    obj['AssetName'] = 'cloven_ruins_entrance'
    lay = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
            'Tiles': [[P.tuile_ref('Ruines_Entree_Base', x, y)
                       if (x, y) in base_grille else P.tuile_vide()
                       for y in range(NY)] for x in range(NX)]}]
    for nom, cs, noms, flen in couches:
        lay.append({'Name': nom, 'Layer': 0, 'Visible': True,
                    'Tiles': [[P.tuile_anim(noms, x, y, flen)
                               if (x, y) in cs else P.tuile_vide()
                               for y in range(NY)] for x in range(NX)]})
    obj['Layers'] = lay

    proto = obj['obstacles'][0][0]
    obj['obstacles'] = [[{**copy.deepcopy(proto),
                          'Tags': 1 if bloque[y][x] else 0}
                         for y in range(NY)] for x in range(NX)]

    print('  entites (carte de meme taille : facteur 1,0, rien ne bouge)')
    for e in (obj.get('Entities') or []):
        for cle in ('MapChars', 'GroundObjects', 'Markers', 'Spawners'):
            for o in (e.get(cle) or []):
                c = o.get('Collider')
                if c:
                    print(f'    {o.get("EntName"):24s} ({c["X"]},{c["Y"]})')

    dst = os.path.join(ROOT, 'Data', 'Ground',
                       'cloven_ruins_entrance.rsground')
    txt = json.dumps(doc, ensure_ascii=False, indent=2)
    json.loads(txt)
    with open(dst, 'w', encoding='utf-8') as f:
        f.write(txt)
    print('ecrit', dst, f'({len(txt)} o)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
