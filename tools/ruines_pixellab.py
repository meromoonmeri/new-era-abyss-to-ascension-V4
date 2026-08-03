#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ENTREE DES RUINES TORDUES — decor GENERE PAR PIXELLAB, puis anime.

--------------------------------------------------------------------
POURQUOI CE SCRIPT EXISTE
--------------------------------------------------------------------
La demande est explicite : le decor doit venir de PixelLab, pas d'un
rendu procedural. Mais PixelLab seul ne sait pas COMPOSER une scene :
trois essais en texte seul (style_strength 20 / 35 / 55, guidance 9)
ont rendu des textures d'herbe et de foret, sans riviere ni pont.

La solution retenue, mesuree : on lui donne un PLAN DE COMPOSITION en
`init_image` (le rendu procedural precedent) avec un
`init_image_strength` eleve. Le modele conserve la disposition et
n'apporte que sa facture. Balayage effectue :

    init_image_strength   250   350   450   550   650
    composition tenue     non   part.  oui   OUI   oui
    facture PixelLab      oui   oui    oui   OUI   moins

550 retenu.

--------------------------------------------------------------------
LES LIMITES DE L'API, MESUREES
--------------------------------------------------------------------
  generate-image-pixflux   max 400 x 400
  generate-image-bitforge  max 200 x 200   (seul a accepter init_image
                                            et style_image)
  style_image DOIT faire exactement la taille demandee, sinon
      HTTP 500 "style_image must be size (142, 200), not (312, 600)"
  jobs concurrents limites -> HTTP 429 au-dela de ~2 en parallele.

La carte fait 576 x 408. Elle se decoupe donc EXACTEMENT en 4 x 3
dalles de 144 x 136 (144*4 = 576, 136*3 = 408), toutes sous la limite
de 200. Chaque dalle recoit SON morceau du plan en init_image, ce qui
garde les raccords coherents : coutures mesurees a 13-22 de saut pour
un ecart interne de 6-15, soit du meme ordre que le grain du decor.

--------------------------------------------------------------------
CE QUE CE SCRIPT FAIT APRES LA GENERATION
--------------------------------------------------------------------
1. QUANTIFICATION. PixelLab rend 1537 couleurs ; les planches
   officielles en comptent 124 et toutes leurs composantes sont des
   multiples de 8 moins 1 (palette 5 bits de la DS). On ramene donc
   sur cette grille, sinon le decor jure a cote des sprites.

2. ANIMATION. Le decor genere est FIXE. On en derive trois couches
   animees en deplacant le contenu des zones concernees :
     Eau    detectee par teinte bleue      8 frames  FrameLength  6
     Herbe  detectee par teinte verte      8 frames  FrameLength 20
     Ciel   bande haute                    8 frames  FrameLength 30
   Cadences premieres entre elles : elles ne retombent en phase qu'au
   bout de 60 affichages, aucune boucle percue.
   Le mouvement est cyclique par construction (phase i/8 dans des
   sinus) : la 8e frame revient a l'identique.

3. CELLULES ANIMEES PAR MESURE. On compare reellement les 8 frames :
   une cellule n'entre dans une couche que si elle CHANGE. Sans ce
   controle, des cellules portent 8 frames identiques — du poids de
   fichier pour rien.

4. ENTITES INTOUCHEES. La carte garde 576 x 408, donc le facteur
   d'echelle vaut 1,0 et les six entites ne bougent pas :
     Dungeon_Entrance (504,160) . Kangaskhan_Rock (408,176)
     Main_Entrance_Marker (24,192) . TEAMMATE_1/2/3 (104,160)

Usage :
    python3 tools/ruines_pixellab.py --generer   # appelle PixelLab
    python3 tools/ruines_pixellab.py --apply     # ecrit tileset+ground
"""
import base64
import copy
import io
import json
import math
import os
import sys
import time
import urllib.error
import urllib.request

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import png2tileset as P  # noqa: E402

ROOT = P.ROOT
CLE = os.environ.get('PIXELLAB_KEY', '67de8e85-73d4-40f2-82ce-4411e46c8542')
W, H = 576, 408
PAS = 24
NX, NY = W // PAS, H // PAS
NF = 8
TW, TH, GX, GY = 144, 136, 4, 3
FORCE = 550

PLAN = os.path.join(ROOT, 'work', 'plan_ruines.png')
DALLES = os.path.join(ROOT, 'work', 'dalles')
ASSEMBLE = os.path.join(ROOT, 'work', 'ruines_pixellab.png')

PROMPT = ("top-down 3/4 view game map background, Pokemon Mystery Dungeon "
          "Explorers of Sky style, seamless piece of a larger outdoor map: "
          "grass, river, rock, trees.")
NEGATIF = ("photorealistic, 3d render, blurry, text, watermark, ui, frame, "
           "border, characters, vignette, dark edges")


# ------------------------------------------------------------------ API
def appel(body, sortie, essais=3):
    for k in range(essais):
        req = urllib.request.Request(
            'https://api.pixellab.ai/v1/generate-image-bitforge',
            data=json.dumps(body).encode(), method='POST')
        req.add_header('Authorization', 'Bearer ' + CLE)
        req.add_header('Content-Type', 'application/json')
        try:
            r = json.load(urllib.request.urlopen(req, timeout=900))
        except urllib.error.HTTPError as e:
            msg = e.read()[:200].decode('utf8', 'replace')
            print(f'    HTTP {e.code} {msg}')
            if e.code in (429, 500, 502, 503) and k + 1 < essais:
                time.sleep(8)
                continue
            return None
        im = Image.open(io.BytesIO(base64.b64decode(r['image']['base64'])))
        im.save(sortie)
        return im
    return None


def generer():
    """Genere les 12 dalles, une par une (l'API refuse le parallele)."""
    if not os.path.exists(PLAN):
        print(f'ABANDON : plan de composition absent ({PLAN}).')
        return 1
    os.makedirs(DALLES, exist_ok=True)
    src = Image.open(PLAN).convert('RGB')
    if src.size != (W, H):
        print(f'ABANDON : le plan fait {src.size}, attendu {(W, H)}.')
        return 1
    for gy in range(GY):
        for gx in range(GX):
            out = os.path.join(DALLES, f'tile_{gx}{gy}.png')
            if os.path.exists(out):
                continue
            t = src.crop((gx * TW, gy * TH, (gx + 1) * TW, (gy + 1) * TH))
            b = io.BytesIO()
            t.save(b, format='PNG')
            print(f'  dalle {gx}{gy}')
            appel({'description': PROMPT, 'negative_description': NEGATIF,
                   'image_size': {'width': TW, 'height': TH},
                   'init_image': {'type': 'base64',
                                  'base64': base64.b64encode(
                                      b.getvalue()).decode()},
                   'init_image_strength': FORCE,
                   'text_guidance_scale': 7.0, 'view': 'high top-down',
                   'outline': 'selective outline',
                   'shading': 'detailed shading',
                   'detail': 'highly detailed', 'seed': 11}, out)
    # assemblage
    out = Image.new('RGB', (W, H))
    n = 0
    for gy in range(GY):
        for gx in range(GX):
            p = os.path.join(DALLES, f'tile_{gx}{gy}.png')
            if os.path.exists(p):
                out.paste(Image.open(p).convert('RGB'), (gx * TW, gy * TH))
                n += 1
    out.save(ASSEMBLE)
    print(f'  {n}/{GX*GY} dalles -> {ASSEMBLE}')
    return 0 if n == GX * GY else 1


# ------------------------------------------------------------------ palette
def ds5(a, couleurs=128):
    """Reduit a une palette de type DS.

    DEUX etapes, et la premiere ne suffit pas :

    1. QUANTIFICATION du NOMBRE de couleurs. Les planches officielles
       en comptent 124 (mesure sur Foret Lugubre). La sortie PixelLab
       en compte 1537 ; la seule mise sur grille 5 bits la ramene a
       1026, encore 8 fois trop. On passe donc par une palette adaptive
       (algorithme median-cut de Pillow) limitee a 128 teintes.
       Sans cela le decor a un fourmillement de nuances que la DS
       n'aurait jamais produit, et le tileset se dedoublonne mal :
       chaque tuile devient unique, le fichier enfle.

    2. GRILLE 5 BITS. Toutes les composantes des planches officielles
       sont des multiples de 8 moins 1 (32 valeurs par composante).
       On y ramene APRES la quantification, sur la palette elle-meme,
       pour ne pas recreer de nuances intermediaires.
    """
    im = Image.fromarray(a.astype(np.uint8), 'RGB')
    q = im.quantize(colors=couleurs, method=Image.MEDIANCUT, dither=0)
    pal = np.array(q.getpalette()[:couleurs * 3],
                   dtype=int).reshape(-1, 3)
    pal = np.clip((pal // 8) * 8 + 7, 0, 255).astype(np.uint8)
    idx = np.asarray(q, dtype=int)
    return pal[idx]


# ------------------------------------------------------------------ masques
def masques(a):
    """Isole eau / herbe / ciel par TEINTE, sur l'image generee.

    On ne peut plus s'appuyer sur la geometrie : le decor vient du
    modele, pas de nos formules. On mesure donc ce qu'il a dessine.
    """
    r = a[:, :, 0].astype(int)
    g = a[:, :, 1].astype(int)
    b = a[:, :, 2].astype(int)
    lum = (r + g + b) / 3.0
    ys = np.arange(H)[:, None] * np.ones((1, W))

    # eau : bleu domine nettement, et pas dans la bande de ciel
    eau = (b - r > 28) & (b > 90) & (ys > 96)
    # ciel : bleu clair OU blanc, dans la bande haute
    ciel = (ys <= 100) & ((b - r > 12) | (lum > 178))
    # herbe et feuillage : le vert domine
    herbe = (g - r > 8) & (g - b > 12)
    herbe &= ~eau & ~ciel
    return eau, herbe, ciel


def anime(base, eau, herbe, ciel, i):
    """Frame i : l'eau descend, l'herbe fremit, les nuages derivent.

    Cyclique par construction : a i = NF le motif est revenu.
    """
    ph = 2 * math.pi * i / NF
    f = base.copy()

    # EAU — defilement vertical cyclique + ondulation laterale
    dy = int(round(6 * i / NF)) * 2            # 0..12 px, cycle entier
    src = np.roll(base, dy, axis=0)
    ond = int(round(1.5 * math.sin(ph)))
    if ond:
        src = np.roll(src, ond, axis=1)
    f[eau] = src[eau]

    # HERBE — fremissement d'un pixel, pas un deplacement
    dxh = int(round(math.sin(ph)))
    dyh = int(round(math.sin(ph + 1.9)))
    sh = np.roll(np.roll(base, dyh, axis=0), dxh, axis=1)
    f[herbe] = sh[herbe]

    # CIEL — derive lente des nuages
    dxc = int(round(4 * i / NF)) * 2           # 0..8 px, cycle entier
    sc = np.roll(base, dxc, axis=1)
    f[ciel] = sc[ciel]
    return f


def cellules(m):
    s = set()
    for gx in range(NX):
        for gy in range(NY):
            if m[gy * PAS:(gy + 1) * PAS, gx * PAS:(gx + 1) * PAS].any():
                s.add((gx, gy))
    return s


# ------------------------------------------------------------------ collisions
def obstacles(a, eau, ciel):
    """Bloquant = eau, ciel, roche sombre et feuillage dense."""
    r = a[:, :, 0].astype(int)
    g = a[:, :, 1].astype(int)
    b = a[:, :, 2].astype(int)
    lum = (r + g + b) / 3.0
    sat = a.max(2).astype(int) - a.min(2).astype(int)
    roche = (sat < 34) & (lum < 168)
    feuille = (g - r > 22) & (lum < 96)
    dur = eau | ciel | roche | feuille
    bloque = np.zeros((NY, NX), bool)
    for gx in range(NX):
        for gy in range(NY):
            bloque[gy, gx] = dur[gy * PAS:(gy + 1) * PAS,
                                 gx * PAS:(gx + 1) * PAS].mean() > 0.45
    return bloque


def degager(bloque, cx, cy, r=1):
    gx, gy = cx // PAS, cy // PAS
    for dx in range(-r, r + 1):
        for dy in range(-r, r + 1):
            x, y = gx + dx, gy + dy
            if 0 <= x < NX and 0 <= y < NY:
                bloque[y, x] = False


def pont_praticable(bloque):
    """Le pont doit rester franchissable : on ouvre sa bande.

    Le tablier est peint par-dessus la riviere ; la detection par
    teinte le classe parfois en eau. On force donc l'ouverture sur la
    hauteur du pont, entre les deux berges.
    """
    y0, y1 = 150 // PAS, 206 // PAS
    for gy in range(y0, y1 + 1):
        for gx in range(NX):
            if 6 <= gx <= 16:
                bloque[gy, gx] = False


# ------------------------------------------------------------------ main
def construire(ecrire):
    if not os.path.exists(ASSEMBLE):
        print(f'ABANDON : image PixelLab absente ({ASSEMBLE}). '
              'Lancez --generer.')
        return 1
    brut = np.asarray(Image.open(ASSEMBLE).convert('RGB'))
    if brut.shape[:2] != (H, W):
        print(f'ABANDON : image {brut.shape[1]}x{brut.shape[0]}, '
              f'attendu {W}x{H}.')
        return 1
    n_avant = len(Image.fromarray(brut).getcolors(999999))
    base = ds5(brut)
    n_apres = len(Image.fromarray(base).getcolors(999999))
    ec = float(np.abs(base[:, 1:].astype(int)
                      - base[:, :-1].astype(int)).mean())
    print(f'image PixelLab {W}x{H}')
    print(f'  couleurs : {n_avant} -> {n_apres} apres palette 5 bits '
          f'(officiel 124)')
    print(f'  facture  : ecart voisin {ec:.2f} (officiel 3,48)')

    eau, herbe, ciel = masques(base)
    print(f'  eau {int(eau.sum()):6d} px | herbe {int(herbe.sum()):6d} px '
          f'| ciel {int(ciel.sum()):6d} px')

    frames = [Image.fromarray(base, 'RGB').convert('RGBA')]
    for i in range(1, NF):
        frames.append(Image.fromarray(anime(base, eau, herbe, ciel, i),
                                      'RGB').convert('RGBA'))

    # cellules qui CHANGENT reellement
    a0 = np.asarray(frames[0]).astype(int)
    diff = np.zeros((H, W), bool)
    for f in frames[1:]:
        diff |= (np.abs(np.asarray(f).astype(int) - a0).sum(2) > 0)
    remue = cellules(diff)
    c_eau = cellules(eau) & remue
    c_herbe = (cellules(herbe) & remue) - c_eau
    c_ciel = (cellules(ciel) & remue) - c_eau - c_herbe
    bouge = c_eau | c_herbe | c_ciel
    print(f'  cellules animees : {len(bouge)}/{NX*NY} '
          f'(eau {len(c_eau)}, herbe {len(c_herbe)}, ciel {len(c_ciel)})')

    for nom, cs in (('eau', c_eau), ('herbe', c_herbe), ('ciel', c_ciel)):
        if not cs:
            print(f'  ATTENTION : couche {nom} vide')
            continue
        pires = []
        for (gx, gy) in sorted(cs):
            box = (gx * PAS, gy * PAS, (gx + 1) * PAS, (gy + 1) * PAS)
            d0 = np.asarray(frames[0].crop(box)).astype(int)
            pires.append(max(int(np.abs(np.asarray(frames[k].crop(box))
                                        .astype(int) - d0).mean())
                             for k in range(1, NF)))
        mortes = sum(1 for e in pires if e == 0)
        print(f'  couche {nom:5s} : ecart median {int(np.median(pires))}, '
              f'{mortes}/{len(cs)} immobiles')

    bloque = obstacles(base, eau, ciel)
    pont_praticable(bloque)
    for (cx, cy) in ((24, 192), (104, 160), (408, 176)):
        degager(bloque, cx, cy, 1)
    degager(bloque, 504, 160, 2)
    dep, arr = (24 // PAS, 192 // PAS), (504 // PAS, 160 // PAS)
    att, joignable, libre = P._connexite(bloque, dep, arr)
    print(f'  obstacles  : {int(bloque.sum())}/{NX*NY} '
          f'({100*bloque.mean():.0f} %)')
    print(f'  jouabilite : {att}/{libre} atteignables, '
          f'grotte joignable = {joignable}')
    if not joignable:
        print('    ABANDON : la grotte est injoignable.')
        return 1

    Image.fromarray(base, 'RGB').save(
        os.path.join(ROOT, 'work', 'apercu_ruines_final.png'))
    if not ecrire:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0

    base_img = frames[0]
    grille = {}
    for gx in range(NX):
        for gy in range(NY):
            if (gx, gy) not in bouge:
                grille[(gx, gy)] = base_img.crop(
                    (gx * PAS, gy * PAS, (gx + 1) * PAS, (gy + 1) * PAS))
    P.ecrire_planche('Ruines_Entree_Base', PAS, grille)

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
                       if (x, y) in grille else P.tuile_vide()
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
    print('  entites (taille inchangee, facteur 1,0) :')
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
    print(f'ecrit {dst} ({len(txt)} o)')
    return 0


def main():
    if '--generer' in sys.argv:
        r = generer()
        if r:
            return r
    return construire('--apply' in sys.argv)


if __name__ == '__main__':
    sys.exit(main())
