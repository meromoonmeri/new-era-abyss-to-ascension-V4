#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""arene_diancie_anim.py — cristaux en levitation + cercle qui pulse.

MESURES SUR L'ARENE (240x312, 15 couleurs)
==========================================
    cristaux : 6 masses de plus de 150 px dans le tiers haut,
               le plus gros 3219 px centre en (139,84)
    cercle   : anneaux concentriques centres en (120,205), rayon 0..95
               la teinte va de (244,211,236) au centre a (151,108,147)
               au bord — c'est un degrade radial deja present.

DEUX ANIMATIONS DISTINCTES
==========================
1. LES CRISTAUX LEVITENT
   Ils ne tournent pas sur eux-memes : ils MONTENT et DESCENDENT
   doucement, avec un decalage de phase entre eux. Un cristal en
   levitation qui pivoterait sur place ferait toupie. Le mouvement
   est vertical, de 2 a 4 px, et chacun a sa propre cadence.
   Technique : on decoupe chaque masse et on la repose decalee, en
   rebouchant derriere avec le fond sombre mesure (15,15,23).

2. LE CERCLE PULSE
   Une onde radiale part du centre vers le bord. La couleur des
   anneaux se decale sur une rampe rose -> violet -> bleu. La pulsation
   s'INTENSIFIE quand le ton monte : le parametre `intensite` va de
   0 (calme, avant la scene) a 1 (plein combat).
   Les teintes sont quantifiees sur la rampe 5 bits DS.

BOUCLE : tous les multiplicateurs du temps sont ENTIERS, donc le
motif est 2*pi-periodique. Verifie a chaque construction.
"""
import numpy as np, math
from PIL import Image
from scipy import ndimage

W, H = 240, 312
NF = 8
CX, CY = 120, 205          # centre du cercle magique
FOND = np.array([15, 15, 23])

def _ds(x):
    return (np.round((x + 1) / 8) * 8 - 1).clip(0, 255)

_src = np.array(Image.open('/home/user/work/arene_diancie_240x312.png').convert('RGB')).astype(int)
_Y, _X = np.mgrid[0:H, 0:W]
_R = np.hypot(_X - CX, _Y - CY)

# --- les masses de cristal, isolees une fois pour toutes -------------
_r, _g, _b = _src[..., 0], _src[..., 1], _src[..., 2]
_cri = (_r > 150) & (_b > 140) & (_g < _r * 0.85)
_cri[150:] = False
_lab, _n = ndimage.label(_cri)
_t = ndimage.sum(_cri, _lab, range(1, _n + 1))
# On ne retient que les masses FRANCHEMENT EN L'AIR. Trois des six
# descendaient jusqu'a y=149, c'est-a-dire sur le bord du sol (qui
# commence a y=140) : les animer faisait bouger 781 pixels de la
# plateforme. Une masse dont le bas depasse y=136 est accrochee au
# decor, pas en levitation.
CRISTAUX = []
for _i, _v in enumerate(_t):
    if _v <= 150:
        continue
    _ys, _xs = np.where(_lab == _i + 1)
    if _ys.max() > 136:
        continue
    CRISTAUX.append(_i + 1)

# rampe de teintes du cercle : rose -> violet -> bleu -> rose
RAMPE = [np.array(c) for c in
         [(247, 215, 239), (231, 167, 215), (199, 119, 183),
          (159, 79, 151), (143, 135, 231), (143, 199, 231)]]


def _teinte(p):
    """Interpole sur la rampe, p cyclique dans [0,1)."""
    q = (p % 1.0) * len(RAMPE)
    i = int(q) % len(RAMPE)
    j = (i + 1) % len(RAMPE)
    f = q - int(q)
    return RAMPE[i] * (1 - f) + RAMPE[j] * f


def frame(k, intensite=1.0):
    """Frame k du cycle.

    CORRECTIF (retour de jeu) : la premiere version repeignait les
    anneaux du SOL a chaque frame. Mesure : 13142 pixels sur 14218 qui
    changeaient etaient dans la plateforme, soit 92 % du mouvement.
    Visuellement, le sol ONDULAIT sous les pieds des combattants au
    lieu de rester stable — un decor de combat doit etre fixe.
    Le sol est donc RENDU IMMOBILE. Seuls bougent :
      - les six cristaux, qui levitent
      - un halo lumineux au centre exact du cercle, qui respire sans
        deplacer un seul pixel de motif (on module la luminosite, on
        ne repeint pas les anneaux)
    """
    u = 2 * math.pi * k / NF
    img = _src.copy()

    # --- 1. LE CERCLE RESPIRE, il ne se repeint pas ----------------
    # On module UNIQUEMENT la luminosite du coeur, sur un disque etroit.
    # Aucun anneau n'est redessine : le motif du sol reste identique
    # d'une frame a l'autre, seule son intensite varie.
    if intensite > 0.01:
        coeur = (_R < 30) & (_Y > 140)
        k_lum = 1.0 + 0.13 * intensite * math.sin(u)
        img[coeur] = img[coeur] * k_lum

    # --- 2. CRISTAUX EN LEVITATION ---------------------------------
    # On efface les six masses d'abord, on les repose ensuite : sinon
    # un effacement mange un cristal deja repose et laisse une trainee.
    dep = []
    for idx, li in enumerate(CRISTAUX):
        m = (_lab == li)
        amp = 2 + (idx % 3)
        dy = int(round(amp * math.sin(u + idx * 1.7)))
        ys, xs = np.where(m)
        dep.append((ys, xs, dy))
        img[ys, xs] = FOND
    for ys, xs, dy in dep:
        ny = np.clip(ys + dy, 0, H - 1)
        img[ny, xs] = _src[ys, xs]

    return _ds(np.clip(img, 0, 255)).astype(np.uint8)
