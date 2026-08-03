#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""aube_finale.py — lever de soleil anime, fond de cinematique 320x240.

POURQUOI CETTE METHODE
======================
Premier essai : tout redessiner proceduralement. Resultat mesure comme
correct (cycle lumineux 69 -> 175 de luminance, boucle exacte) mais
visuellement geometrique : montagnes en triangles, nuages ovales. Tres
en dessous de PixelLab.
Deuxieme essai : generer 4 images PixelLab (nuit, aube, lever, jour) et
interpoler. ABANDONNE apres mesure : les compositions ne sont pas
alignees, la ligne d'horizon passe de y=145 a y=40 selon le moment.
Interpoler aurait fait FONDRE les montagnes les unes dans les autres.

METHODE RETENUE : une seule image PixelLab (le lever dore, valide),
decoupee en 4 calques par PROFONDEUR — exactement la technique de la
planche Chunsoft fournie par l'auteur : un composite, puis des calques
sur fond magenta. On n'anime QUE LA LUMIERE. Les formes ne bougent
jamais, donc aucun morphing n'est possible.

    ciel      teinte qui evolue de la nuit au plein jour
    prairie   lointaine, s'eclaire en premier (elle capte le soleil)
    collines  plan moyen, s'eclaire ensuite
    avant     silhouettes, s'eclairent en dernier
Le retard entre les plans est ce qui donne la profondeur : au lever du
jour, la lumiere touche le fond avant l'avant-plan.

FORMAT : Content/BG/X.dir = [PNG planche][16 octets : fw, fh, 0, count]
en uint32 LE. Verifie sur Genesis_Life.dir : planche 1280x960, frames
320x240, 16 frames, grille 4x4. Le viewport PMDO fait 320x240.
"""
import numpy as np, math
from PIL import Image

W, H = 320, 240
NF = 16
BASE = '/home/user/work/aube_m2.png'

_src = np.array(Image.open(BASE).convert('RGB')).astype(float)
_M = {n: np.load('/tmp/c_%s.npy' % n) for n in ('ciel', 'prai', 'mili', 'avan')}

# Teintes de mesure : on ne repeint pas, on MODULE l'image d'origine.
# (gain, teinte visee, force du virage) par phase, pour chaque calque.
# phase 0 = nuit finissante, 1 = aube, 2 = lever dore, 3 = plein jour
NUIT   = np.array([ 46,  56, 120])
AUBE   = np.array([216, 136, 144])
DORE   = np.array([255, 208, 128])
JOUR   = np.array([255, 252, 240])
TEINTE = [NUIT, AUBE, DORE, JOUR]
GAIN   = {'ciel': [0.30, 0.62, 1.00, 1.06],
          'prai': [0.24, 0.48, 0.94, 1.10],
          'mili': [0.20, 0.40, 0.86, 1.02],
          'avan': [0.16, 0.32, 0.74, 0.92]}
VIRAGE = {'ciel': [0.55, 0.42, 0.18, 0.10],
          'prai': [0.44, 0.30, 0.12, 0.06],
          'mili': [0.40, 0.26, 0.10, 0.05],
          'avan': [0.36, 0.22, 0.08, 0.04]}

def _interp(tab, t):
    p = t * (len(tab) - 1)
    i = min(int(p), len(tab) - 2)
    f = p - i
    return tab[i] * (1 - f) + tab[i + 1] * f

def frame(k):
    """Frame k. La boucle est exacte : frame(NF) == frame(0)."""
    u = k / NF
    t = (1 - math.cos(2 * math.pi * u)) / 2.0     # 0 -> 1 -> 0, sans palier
    ph = 2 * math.pi * u
    img = _src.copy()
    for nom, m in _M.items():
        gain = _interp(GAIN[nom], t)
        vir = _interp(VIRAGE[nom], t)
        teinte = _interp(TEINTE, t)
        z = _src[m]
        img[m] = z * gain * (1 - vir) + teinte[None, :] * vir * (z.mean(1, keepdims=True) / 255.0 + 0.35)
    # halo du soleil : il grandit et chauffe avec le jour
    Y, X = np.mgrid[0:H, 0:W]
    d = np.hypot(X - 86, Y - 53)
    halo = np.exp(-(d / (30 + 46 * t)) ** 2) * (0.15 + 0.55 * t)
    img += halo[:, :, None] * (np.array([255, 244, 200]) - img)
    # respiration de l'air : tres legere, et cyclique
    img *= (1.0 + 0.02 * math.sin(ph))
    img = np.clip(img, 0, 255)
    return (np.round((img + 1) / 8) * 8 - 1).clip(0, 255).astype(np.uint8)
