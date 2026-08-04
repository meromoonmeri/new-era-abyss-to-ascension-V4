#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cyclone_loop.py — UN systeme nuageux cyclonique, 24 frames, boucle parfaite.

BRIEF
=====
24 PNG transparents alignes (frame_01..frame_24), un UNIQUE systeme
cyclonique qui evolue frame apres frame (pas 24 illustrations), rotation
lente autour d'une ouverture circulaire PARFAITEMENT CENTREE et de taille
CONSTANTE (le sommet de la montagne sera compose dedans), transition
progressive blanc lumineux -> bleu-gris dense, boucle 24->1 INVISIBLE,
style pixel-art Pokemon Mystery Dungeon (pas d'anti-aliasing, outline net,
ombrage doux par paliers, clusters propres).

POURQUOI PROCEDURAL ET PAS UN MODELE D'IMAGE
=============================================
Un generateur d'images ne peut garantir ni l'identite a 90-95 % entre
frames consecutives, ni l'ouverture circulaire au pixel pres sur 24 frames,
ni la fermeture de boucle sans pop. Ici tout est deterministe et la boucle
est une PROPRIETE MATHEMATIQUE du champ, pas un espoir.

GARANTIE DE BOUCLE (meme ecole que ciel_tournant.py)
=====================================================
Le champ complet est de la forme
    F(r, theta, phi) = SOMME de termes cos(k*theta + c*rho + w*phi + p + balancement(phi))
avec phi = 2*pi*f/24 et w ENTIER. Chaque terme est 2*pi-periodique en phi,
donc F(phi=0) == F(phi=2*pi) EXACTEMENT. La frame 24 (phi=2*pi*23/24) n'est
separee de la frame 1 que d'un pas de 15 degres de phase — le meme pas
qu'entre n'importe quelles frames consecutives : le point de couture est
indetectable par construction.

LES 15 DEGRES DU BRIEF, LUS HONNETEMENT
=======================================
Une rotation MONOTONE de 15 degres sur le cycle est incompatible avec une
boucle invisible : a la fermeture, le motif reviendrait brutalement de +15
a 0 degres (pop garanti, sauf symetrie radiale exacte du nuage, qui se
verrait). Lecture fidele au brief et bouclable :
  1. les GRANDES masses balancent de 0 -> 15 -> 0 degres sur le cycle
     (theta_g = 15deg * (1-cos(phi))/2, periodique, doux) ;
  2. les FILAMENTS SPIRAUX avancent en continu, dont une famille a
     k=24, w=1 qui avance EXACTEMENT de 360/24 = 15 degres par cycle ;
  3. la turbulence (w entiers) continue de tourner pendant que la balance
     revient : l'oeil lit une rotation continue, rien ne rebondit.

COULEUR : la transition blanc -> bleu-gris doit etre « extremement
progressive sur les 24 frames » ET boucler. Le seul cycle honnete est
aller-retour : c(phi) = (1-cos(phi))/2. Frame 1 = plus blanc, frame 13 =
plus dense/bleu-gris, frame 24 = revenu presque au blanc de la frame 1.
Delta entre frames consecutives : ~4 % de la plage totale.

RENDU PIXEL ART
===============
Champ calcule en 512x512 puis moyenne par blocs 4x4 -> 128x128 pixels
d'art (grain 4, convention du projet : ciel_tournant agrandi x4). La
decision masque/teinte est prise AU NIVEAU DE LA CELLULE : silhouette en
escalier propre, zero anti-aliasing, zero alpha partiel. Outline 1 cellule
sur tout le pourtour. Rampe 7 paliers interpolee entre la rampe « blanc
lumineux » et la rampe « bleu-gris dense », quantifiee 5 bits DS.
L'ouverture centrale est imposee APRES tout le reste : les cellules dont
le centre est a moins de R_EYE sont transparentes sur les 24 frames —
meme taille, meme centre, au pixel pres.
"""
import os
import math
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage

# ---------------------------------------------------------------- reglages
S      = 512              # canvas final (px)
G      = 4                # grain : 1 pixel d'art = G x G px fins
N      = S // G           # 128 pixels d'art de cote
NF     = 24               # frames
FPS    = 12               # pour les previews (12 fps = boucle 2 s)

# l'anneau principal s'arrete a rho=1 ; les bandes trainantes vont jusqu'a
# rho=1.3 : R_OUT * 1.3 doit tenir dans le canvas (S/2 - marge).
R_OUT  = 0.375 * S        # rayon externe de l'anneau nuageux (px fins)
R_EYE  = 0.148 * S        # rayon de l'ouverture centrale (px fins)

TAU    = 0.45             # seuil masque sur la densite moyennee par cellule

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                   'work', 'cyclone_loop')

# ---------------------------------------------------------------- geometrie
_y, _x = np.mgrid[0:S, 0:S]
_r   = np.hypot(_x - S / 2, _y - S / 2)
_t   = np.arctan2(_y - S / 2, _x - S / 2)
_rho = _r / R_OUT

# cercle de l'oeil au niveau cellule (centre de cellule), constant 24 frames
_cy, _cx = np.mgrid[0:N, 0:N]
_crx = (_cx + 0.5) * G - S / 2
_cry = (_cy + 0.5) * G - S / 2
_cr  = np.hypot(_crx, _cry)
_ct  = np.arctan2(_cry, _crx)
_crho = _cr / R_OUT
YE_CELLS = _cr < R_EYE          # ouverture : transparente, toujours


def smoothstep(a, b, x):
    u = np.clip((x - a) / (b - a), 0.0, 1.0)
    return u * u * (3 - 2 * u)


def box(a):
    """Moyenne par blocs GxG : 512x512 -> 128x128."""
    return a.reshape(N, G, N, G).mean(axis=(1, 3))


# ---------------------------------------------------------------- harmoniques
# Generees une fois (seed fixe) : deterministe d'une execution a l'autre.
rng = np.random.default_rng(20260804)

def tirage(n, ks, ws, amps, c_rhos, phase_spread=2 * math.pi):
    out = []
    for _ in range(n):
        out.append((
            int(rng.choice(ks)), int(rng.choice(ws)),
            float(rng.uniform(*amps)), float(rng.uniform(*c_rhos)),
            float(rng.uniform(0, phase_spread)),
        ))
    return out

# GRANDES MASSES (k bas) : amplitude moderee, balancement global seulement
# (w = 0 : elles ne « tournent » pas en continu, elles se deforment sur
# place via le balancement et les termes radiaux) — sinon k=1 a w=1 ferait
# un tour complet par cycle, bien trop vite. Amplitude faible : l'anneau
# doit rester PLEIN, les masses modulent sans percer le disque.
MASSES = tirage(7, ks=[1, 2, 3], ws=[0], amps=(0.14, 0.26),
                c_rhos=(-1.2, 1.2))

# FILAMENTS SPIRAUX : rotation continue. La derive par cycle d'un terme
# cos(k*theta - w*phi) est 360*w/k degres. Famille (24,1) = 15 degres/cycle
# pile, comme demande au brief. beta = enroulement logarithmique.
SPIRALES = []
for (k, w, beta, amp) in [
        (24, 1, 0.85, 0.16),   # 15.0 degres / cycle — le brief
        (24, 2, 0.75, 0.10),   # 30.0 degres / cycle
        (18, 1, 0.95, 0.14),   # 20.0 degres / cycle
        (12, 1, 1.10, 0.13),   # 30.0 degres / cycle
        ( 9, 1, 1.20, 0.10),   # 40.0 degres / cycle
]:
    SPIRALES.append((k, w, beta, amp, float(rng.uniform(0, 2 * math.pi))))

# TURBULENCE FINE : k moyens, w petits entiers -> derive 20-90 degres/cycle,
# c'est elle qui fait vivre les bords et l'interieur des masses.
TURB = tirage(14, ks=[6, 7, 8, 9, 11, 12, 14, 16], ws=[1, 2, 3],
              amps=(0.08, 0.16), c_rhos=(-2.0, 2.0))

# BANDES TRAINANTES EXTERNES : les virgules du cyclone, phase spirale
# cos(k*(theta - beta*ln(rho))) — c'est ca qui fait lire « cyclone ».
BANDES = tirage(4, ks=[2, 3, 3, 4], ws=[1, 2],
                amps=(0.28, 0.45), c_rhos=(0.9, 1.5))

# EROSION DU BORD EXTERNE : decoupe la silhouette en bancs nuageux.
# Ne touche que rho > 0.78 : l'interieur de l'anneau reste plein.
ERODE = tirage(7, ks=[2, 3, 4, 5, 7], ws=[1, 2],
               amps=(0.28, 0.50), c_rhos=(-1.0, 1.0))

# ECLAIRAGE : ombres douces A PHASE SPIRALE (pas radiale : sinon ca fait
# parts de tarte). beta dans c_rhos, w = 1.
LUMIERE = tirage(5, ks=[2, 3, 3, 4], ws=[1], amps=(0.20, 0.34),
                 c_rhos=(0.8, 1.4))

SWAY_MAX = math.radians(15.0)     # balancement global 0 -> 15 -> 0 degres


def densite(phi):
    """Champ de densite continu (px fins), periodique en phi."""
    sway = SWAY_MAX * (1.0 - math.cos(phi)) / 2.0
    th = _t - sway

    m = np.zeros_like(_rho)
    for (k, w, a, c, p) in MASSES:
        m += a * np.cos(k * th + c * _rho + w * phi + p)

    sp = np.zeros_like(_rho)
    w_arm = np.exp(-((_rho - 0.72) / 0.45) ** 2)   # bras au max a mi-anneau
    for (k, w, beta, a, p) in SPIRALES:
        sp += a * np.cos(k * th - k * beta * np.log(_rho + 0.18)
                         - w * phi + p) * w_arm

    tb = np.zeros_like(_rho)
    for (k, w, a, c, p) in TURB:
        tb += a * np.cos(k * th + c * _rho + w * phi + p)

    # anneau PLEIN : base haute, modulations moderees — le disque nuageux
    # reste lisible en continu, seuls ses bords respirent.
    bd = np.zeros_like(_rho)
    for (k, w, a, beta, p) in BANDES:
        bd += a * np.cos(k * (th - beta * np.log(_rho + 0.18)) - w * phi + p)
    outer_w = smoothstep(0.82, 1.02, _rho)

    base = 0.80 + 0.26 * m + 0.20 * sp + 0.42 * bd * outer_w
    turbmul = np.clip(1.0 + 0.32 * tb, 0.40, 1.45)

    e_in = smoothstep(R_EYE / R_OUT, R_EYE / R_OUT + 0.11, _rho)
    e_out = 1.0 - smoothstep(1.02, 1.30, _rho)

    er = np.zeros_like(_rho)
    for (k, w, a, c, p) in ERODE:
        er += a * np.cos(k * th + c * _rho + w * phi + p)
    er = np.clip(er, 0.0, None) * smoothstep(0.82, 1.12, _rho)

    d = base * turbmul * e_in * e_out - 0.55 * er
    d[_r < R_EYE] = -1.0                      # ouverture parfaite
    return d


def luminosite(phi):
    """Champ de brillance 0..1 (ombrage doux par paliers)."""
    sway = SWAY_MAX * (1.0 - math.cos(phi)) / 2.0
    th = _t - sway

    lu = np.zeros_like(_rho)
    for (k, w, a, beta, p) in LUMIERE:
        lu += a * np.cos(k * (th - beta * np.log(_rho + 0.18)) + w * phi + p)

    # mur de l'oeil : anneau brillant juste autour de l'ouverture
    mur = np.exp(-((_rho - (R_EYE / R_OUT + 0.05)) / 0.09) ** 2)

    b = 0.50 + 0.30 * lu + 0.34 * mur
    # un peu de texture d'ombre liee a la turbulence (meme phase = coherant)
    tb = np.zeros_like(_rho)
    for (k, w, a, c, p) in TURB[:6]:
        tb += a * np.sin(k * th + c * _rho + w * phi + p + 1.7)
    b += 0.16 * tb
    return np.clip(b, 0.0, 1.0)


# ---------------------------------------------------------------- palette
# Rampe 7 paliers : [lumiere ... ombre]. Interpolee entre l'etat « blanc
# lumineux » (c=0) et l'etat « bleu-gris dense » (c=1), quantifiee 5 bits.
RAMPE_CLAIR = [
    (255, 255, 255), (235, 240, 247), (210, 220, 233), (182, 196, 214),
    (152, 168, 190), (122, 140, 164), (98, 116, 140),
]
RAMPE_TEMPETE = [
    (198, 206, 217), (164, 176, 192), (135, 149, 168), (106, 121, 143),
    (82, 97, 120), (62, 76, 98), (47, 59, 79),
]


def ds5(x):
    return int((round((x + 1) / 8) * 8 - 1))


def palette(c):
    """Rampe + outline a l'instant de couleur c (0 = blanc, 1 = tempete)."""
    ramp = []
    for (r1, g1, b1), (r2, g2, b2) in zip(RAMPE_CLAIR, RAMPE_TEMPETE):
        ramp.append(tuple(ds5(v1 + (v2 - v1) * c)
                          for v1, v2 in zip((r1, g1, b1), (r2, g2, b2))))
    o = ramp[-1]
    outline = tuple(ds5(v * 0.72 - (8 if i == 1 else 0))
                    for i, v in enumerate(o))
    return ramp, outline


def nettoie(mask):
    """Clusters propres : supprime les miettes, bouche les micro-trous.
    L'ouverture centrale est re-imposee apres."""
    lab, n = ndimage.label(mask)
    if n:
        tailles = ndimage.sum(mask, lab, range(1, n + 1))
        miettes = np.array(tailles) < 10
        mask = mask & ~miettes[lab - 1]
    inv_lab, inv_n = ndimage.label(~mask)
    if inv_n:
        tailles = ndimage.sum(~mask, inv_lab, range(1, inv_n + 1))
        petits_trous = (np.array(tailles) < 14)
        mask = mask | (petits_trous[inv_lab - 1] & (inv_lab > 0))
    mask[YE_CELLS] = False
    return mask


def frame(phi):
    """Une frame : RGBA S x S, pixels d'art G x G."""
    d = box(densite(phi))
    b = box(luminosite(phi))

    mask = d > TAU
    mask = nettoie(mask)

    c = (1.0 - math.cos(phi)) / 2.0
    ramp, outline = palette(c)

    idx = np.clip((b * len(ramp)).astype(int), 0, len(ramp) - 1)
    # l'ombre la plus profonde est reservee a l'outline + aux creux tres denses
    idx = np.minimum(idx, len(ramp) - 2)
    creux = (d > 1.05)
    idx[creux] = len(ramp) - 2

    erodee = ndimage.binary_erosion(mask)      # voisinage 4 implicite suffit
    contour = mask & ~erodee

    rgb = np.zeros((N, N, 3), np.uint8)
    for i, col in enumerate(ramp):
        rgb[mask & (idx == i)] = col
    rgb[contour] = outline

    a = np.where(mask, 255, 0).astype(np.uint8)
    rgba = np.dstack([rgb, a])
    rgba = np.repeat(np.repeat(rgba, G, axis=0), G, axis=1)
    return Image.fromarray(rgba, 'RGBA')


# ---------------------------------------------------------------- production
def main():
    os.makedirs(OUT, exist_ok=True)
    phis = 2 * math.pi * np.arange(NF) / NF
    frames = []
    for f, phi in enumerate(phis):
        im = frame(phi)
        im.save(os.path.join(OUT, 'frame_%02d.png' % (f + 1)))
        frames.append(im)
        print('frame_%02d.png ok' % (f + 1))

    # --- metrics de boucle (culture maison : on mesure, on ne suppose pas) --
    def arr(i):
        return np.asarray(frames[i])[::G, ::G]  # retour au niveau cellule

    def delta(i, j):
        """(changement de STRUCTURE, changement de TEINTE) en %."""
        a, b_ = arr(i), arr(j)
        ma, mb = a[..., 3] > 0, b_[..., 3] > 0
        union = ma | mb
        structure = 100.0 * (ma != mb)[union].mean()
        dcol = np.abs(a[..., :3].astype(int) - b_[..., :3].astype(int))
        teinte = 100.0 * dcol.max(axis=2)[union].mean() / 255.0
        return structure, teinte

    print('\n--- deltas entre frames consecutives : structure (masque) / teinte')
    smax = 0.0
    for f in range(NF):
        s, t = delta(f, (f + 1) % NF)
        smax = max(smax, s)
        print('  %02d -> %02d :  masque %5.2f %%   teinte %4.1f %%'
              % (f + 1, (f + 1) % NF + 1, s, t))
    print('structure max %.2f %%  (le brief vise ~5-10 %% : 90-95 %% du nuage constant)'
          % smax)

    # preuve que ce n'est PAS une rotation rigide de l'image :
    # si c'etait le cas, la frame 13 (demi-cycle) retournee de 180 degres
    # (retournement exact, sans interpolation) collerait presque a la frame 1.
    a1, a13 = arr(0), arr(12)
    a13r = a13[::-1, ::-1]
    union = (a1[..., 3] > 0) | (a13r[..., 3] > 0)
    same = (a13r[..., 3] > 0) == (a1[..., 3] > 0)
    print('test rotation rigide (frame13 retournee 180 vs frame1) : '
          '%.2f %% de concordance masque — une rotation pure donnerait ~99 %%'
          % (100.0 * same[union].mean()))

    # --- previews --------------------------------------------------------
    frames[0].save(os.path.join(OUT, 'cyclone_loop_12fps.apng'),
                   save_all=True, append_images=frames[1:],
                   duration=round(1000 / FPS), loop=0, disposal=2)

    fond = Image.new('RGBA', (S, S), (18, 24, 40, 255))
    gif = []
    for im in frames:
        g = fond.copy()
        g.alpha_composite(im)
        gif.append(g.convert('P', palette=Image.ADAPTIVE))
    gif[0].save(os.path.join(OUT, 'cyclone_loop_12fps.gif'),
                save_all=True, append_images=gif[1:],
                duration=round(1000 / FPS), loop=0)

    # planche contact 6x4
    mini = 192
    sheet = Image.new('RGB', (mini * 6 + 14, mini * 4 + 12), (24, 28, 38))
    dr = ImageDraw.Draw(sheet)
    for f, im in enumerate(frames):
        m = im.resize((mini, mini), Image.NEAREST)
        bg = Image.new('RGBA', (mini, mini), (18, 24, 40, 255))
        bg.alpha_composite(m)
        x, y = (f % 6) * (mini + 2) + 1, (f // 6) * (mini + 2) + 1
        sheet.paste(bg.convert('RGB'), (x, y))
        dr.rectangle([x, y, x + 15, y + 11], fill=(24, 28, 38))
        dr.text((x + 2, y + 1), '%02d' % (f + 1), fill=(230, 236, 245))
    sheet.save(os.path.join(OUT, 'contact_sheet.png'))
    print('\nsorti dans', OUT)


if __name__ == '__main__':
    main()
