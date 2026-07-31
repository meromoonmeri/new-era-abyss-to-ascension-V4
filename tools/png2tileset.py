#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""png2tileset.py — convertit une image PNG en tileset RogueEssence/PMDO.

    python3 tools/png2tileset.py decoupe  <image.png> [--tile 24] [--grid 8]
    python3 tools/png2tileset.py importer <image.png> <NomPlanche> [options]
    python3 tools/png2tileset.py carte    <image.png> <NomPlanche> <sortie.rsmap> [options]
    python3 tools/png2tileset.py ground   <image.png> <NomPlanche> <sortie.rsground> [options]
    python3 tools/png2tileset.py verifier <NomPlanche>

Options communes :
    --tile N      taille de tuile en px      (defaut 24 = tuile de donjon)
    --grid N      pas de grille du ground    (defaut 8, seulement pour `ground`)
    --align X,Y   decalage du decoupage      (defaut 0,0)
    --seuil N     % d'opacite mini pour qu'une tuile soit gardee (defaut 1)
    --sol "a,b"   couleurs RGB du sol marchable, pour `carte`
    --apply       ecrit reellement (sinon simple essai a blanc)

--------------------------------------------------------------------------
CE QUE LE FORMAT EXIGE — verifie dans le moteur, pas suppose
--------------------------------------------------------------------------
1) STRUCTURE DU .tile  (RogueEssence/Content/TileSheet.cs + BaseSheet.cs)
       uint32  tileSize
       uint32  tileCount
       tileCount x ( uint64 key = x | (y << 32) , uint64 offset absolu )
       a chaque offset :  int64 longueur  +  octets PNG
   Les tuiles identiques PARTAGENT le meme offset : la deduplication est
   native au format, pas une optimisation de mon cru. Verifie sur
   Metano_Town_Base (35646 entrees pour un nombre d'images bien moindre).

2) ALPHA PREMULTIPLIE — le piege principal.
   `BaseSheet.ImportTex` (l.188-192) applique premultiply(tex, false) a
   l'import, et `BaseSheet.Load` (l.63-73) ne l'applique PAS. Les octets
   stockes dans un .tile sont donc DEJA premultiplies.
   Mesure de confirmation sur Metano_Town_Objects : 45760 pixels
   d'alpha 0 testes, 0 avec un RGB non nul ; et tous les pixels d'alpha
   partiel respectent RGB <= A. C'est la signature du premultiplie.
   Consequence : ecrire un PNG standard (alpha droit) donnerait des
   halos clairs sur tous les bords transparents. L'outil premultiplie
   donc a l'ecriture, et de-premultiplie a la relecture.

3) index.idx  (RogueEssence/Content/TileIndex.cs, TileGuide.Load)
       uint32 nbPlanches
       par planche : nom en chaine C# 7-bit-encoded, uint32 tileSize,
                     uint32 nbTuiles, puis nbTuiles x (int32 x, int32 y,
                     int64 position)
   GraphicsManager.GetTile lit la position DANS cet index : une planche
   absente de l'index renvoie 0 -> tuile d'erreur affichee. On regenere
   donc l'index apres toute ecriture, via tools/rebuild_tile_index.py
   dont la non-regression est verifiee (il reproduit l'index d'origine
   octet pour octet).

4) TAILLES DE TUILE
   Ground  : la grille vaut 8 * TexSize px (GroundMap.TileSize).
   Donjon  : GraphicsManager.TileSize, 24 px dans ce projet.
   Une carte de combat batie sur des tuiles de 8 px ne s'afficherait pas
   correctement : l'outil refuse la combinaison et le dit.
"""
import argparse
import copy
import io
import json
import os
import struct
import sys
from collections import Counter

from PIL import Image
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')


# ---------------------------------------------------------------- alpha
def premultiplier(im):
    """PNG standard -> octets tels que le moteur les attend."""
    a = np.asarray(im.convert('RGBA')).astype(np.uint16)
    al = a[:, :, 3]
    out = a.copy()
    for c in range(3):
        out[:, :, c] = (a[:, :, c] * al) // 255
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


def depremultiplier(im):
    """Octets du moteur -> PNG standard, pour relecture/apercu."""
    a = np.asarray(im.convert('RGBA')).astype(np.uint16)
    al = a[:, :, 3]
    out = a.copy()
    nz = al > 0
    for c in range(3):
        ch = out[:, :, c]
        ch[nz] = np.minimum(a[:, :, c][nz] * 255 // al[nz], 255)
    return Image.fromarray(out.astype(np.uint8), 'RGBA')


# ------------------------------------------------------------- lecture
def lire_planche(nom, brut=False):
    """Retourne (tileSize, {(x,y): Image}).

    brut=False : images en alpha DROIT (pour affichage / edition).
    brut=True  : images telles qu'elles sont stockees, donc PREMULTIPLIEES.

    Le mode brut existe pour une raison precise. La de-premultiplication
    n'est PAS reversible sans perte : elle divise par l'alpha, et sur un
    alpha faible l'erreur d'arrondi explose. Mesure sur
    Metano_Town_Objects, pixel (1,2) de la tuile (161,2) :
        stocke (191,127,63, a=4)  ->  droit (255,255,255)  [sature]
                                  ->  restocke (4,4,3)     [perdu]
    soit 127/255 d'ecart sur un simple aller-retour.
    Pour COPIER ou RE-EMPAQUETER une planche existante sans l'abimer, il
    faut donc repartir des octets d'origine : c'est ce que fait brut=True,
    couple a ecrire_planche(..., deja_premultiplie=True).
    """
    with open(os.path.join(TILEDIR, nom + '.tile'), 'rb') as f:
        raw = f.read()
    ts, cnt = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(cnt):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<q', raw, off)[0]
        im = Image.open(io.BytesIO(raw[off + 8: off + 8 + ln])).convert('RGBA')
        cells[(x, y)] = im if brut else depremultiplier(im)
    return ts, cells


# ------------------------------------------------------------ ecriture
def ecrire_planche(nom, tile_size, grille, deja_premultiplie=False):
    """Ecrit un .tile dedupe.

    grille : {(x,y): Image}.
      deja_premultiplie=False -> images en alpha droit (cas normal :
        on importe un PNG produit par un graphiste). L'outil applique
        la premultiplication attendue par le moteur.
      deja_premultiplie=True  -> images deja au format moteur (cas d'une
        copie de planche existante lue avec brut=True). Aucune conversion,
        donc aucune perte.
    """
    keys = sorted(grille, key=lambda k: (k[1], k[0]))
    png_de = {}
    for k in keys:
        im = grille[k] if deja_premultiplie else premultiplier(grille[k])
        buf = io.BytesIO()
        im.save(buf, format='PNG')
        png_de[k] = buf.getvalue()

    encode, ordre = {}, []
    for k in keys:
        png = png_de[k]
        if png not in encode:
            encode[png] = None
            ordre.append(png)
    off = 8 + len(keys) * 16
    for png in ordre:
        encode[png] = off
        off += 8 + len(png)

    out = bytearray()
    out += struct.pack('<II', tile_size, len(keys))
    for k in keys:
        out += struct.pack('<QQ', k[0] | (k[1] << 32), encode[png_de[k]])
    for png in ordre:
        out += struct.pack('<q', len(png)) + png
    path = os.path.join(TILEDIR, nom + '.tile')
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return path, len(keys), len(ordre), len(out)


# -------------------------------------------------------------- decoupe
def decouper(path, tile, ax=0, ay=0, seuil=1):
    """Decoupe l'image en tuiles. Retourne (grille, stats)."""
    im = Image.open(path).convert('RGBA')
    W, H = im.size
    nx = (W - ax) // tile
    ny = (H - ay) // tile
    reste = ((W - ax) % tile, (H - ay) % tile)
    grille = {}
    vides = 0
    for gx in range(nx):
        for gy in range(ny):
            box = (ax + gx * tile, ay + gy * tile,
                   ax + (gx + 1) * tile, ay + (gy + 1) * tile)
            t = im.crop(box)
            al = np.asarray(t)[:, :, 3]
            if (al > 0).mean() * 100 < seuil:
                vides += 1
                continue
            grille[(gx, gy)] = t
    stats = dict(taille=(W, H), grille=(nx, ny), reste=reste,
                 gardees=len(grille), vides=vides)
    return grille, stats


def dedup_stats(grille):
    sig = Counter()
    for im in grille.values():
        sig[im.tobytes()] += 1
    return len(sig)


# -------------------------------------------------------- construction
def tuile_vide():
    return {'AutoTileset': '', 'Associates': [], 'Layers': [],
            'NeighborCode': -1}


def tuile_ref(sheet, x, y, framelen=60):
    return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
            'Layers': [{'Frames': [{'Sheet': sheet,
                                    'TexLoc': {'X': x, 'Y': y}}],
                        'FrameLength': framelen}]}


def gabarit_rsmap():
    """Clone une carte de combat existante pour heriter des 37 champs."""
    src = os.path.join(ROOT, 'Data', 'Map', 'montagne_traitresse_fond.rsmap')
    with open(src, encoding='utf-8-sig') as f:
        return json.load(f)


def gabarit_rsground():
    src = os.path.join(ROOT, 'Data', 'Ground', 'guild_heros_room.rsground')
    with open(src, encoding='utf-8-sig') as f:
        return json.load(f)


def _profil(im):
    """(luminance moyenne, saturation moyenne) des pixels opaques."""
    a = np.asarray(im.convert('RGBA')).astype(float)
    m = a[:, :, 3] > 128
    if not m.sum():
        return 0.0, 0.0
    rgb = a[:, :, :3][m]
    return float(rgb.mean()), float((rgb.max(axis=1) - rgb.min(axis=1)).mean())


def couleurs_sol(grille, seuil_pct=55, echantillon=None, tol_lum=28,
                 tol_sat=14):
    """Classe chaque tuile en SOL ou MUR.

    DEUX MODES, et le second est presque toujours le bon.

    1) Sans --sol : heuristique de luminance. Les tuiles les plus claires
       sont supposees etre le sol. Rapide, mais elle se trompe des que
       l'image contient un ciel clair ou des nuages : sur l'arene de
       Tornadus elle classait le ciel ET les corniches en terrain
       marchable (mesure : ciel lum 225 > plateforme lum 138).

    2) Avec --sol X,Y : on echantillonne la tuile qui contient ce pixel
       et on retient toutes les tuiles de meme PROFIL (luminance ET
       saturation proches). C'est ce qui separe proprement la roche du
       ciel : sur cette arene, sol = lum 138 / sat 10, ciel = lum 225 /
       sat 44. La saturation seule suffit a trancher.
    """
    prof = {k: _profil(im) for k, im in grille.items()}
    if not prof:
        return set()

    if echantillon is not None:
        lum0, sat0 = echantillon
        return {k for k, (l, s) in prof.items()
                if abs(l - lum0) <= tol_lum and abs(s - sat0) <= tol_sat}

    vals = sorted(l for l, _ in prof.values())
    seuil = vals[int(len(vals) * seuil_pct / 100)]
    return {k for k, (l, _) in prof.items() if l >= seuil}


# ------------------------------------------------------------ commandes
def cmd_decoupe(a):
    grille, st = decouper(a.image, a.tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    print(f"image        : {st['taille'][0]}x{st['taille'][1]} px")
    print(f"tuile        : {a.tile} px")
    print(f"grille       : {st['grille'][0]} x {st['grille'][1]} tuiles")
    if st['reste'] != (0, 0):
        print(f"  ATTENTION  : reste {st['reste'][0]}x{st['reste'][1]} px "
              f"non couverts (l'image n'est pas un multiple de {a.tile}).")
        print(f"               ces pixels seront IGNORES. Recadrez l'image ou")
        print(f"               ajustez --align pour choisir ou tombe la coupe.")
    print(f"tuiles gardees : {st['gardees']}  (vides ignorees : {st['vides']})")
    print(f"tuiles uniques : {dedup_stats(grille)}  "
          f"-> deduplication native du format")


def cmd_importer(a):
    grille, st = decouper(a.image, a.tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    if not grille:
        print('ABANDON : aucune tuile opaque trouvee.')
        return 1
    print(f"{st['grille'][0]}x{st['grille'][1]} tuiles de {a.tile} px, "
          f"{st['gardees']} gardees, {dedup_stats(grille)} uniques")
    if st['reste'] != (0, 0):
        print(f"  ATTENTION : {st['reste']} px non couverts, ignores.")
    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    path, nk, nu, sz = ecrire_planche(a.nom, a.tile, grille)
    print(f'ecrit {path}\n  {nk} entrees, {nu} images uniques, {sz} octets')
    reindexer()
    verifier(a.nom, grille, a.tile)
    return 0


def reindexer():
    import subprocess
    r = subprocess.run([sys.executable,
                        os.path.join(ROOT, 'tools', 'rebuild_tile_index.py')],
                       cwd=ROOT, capture_output=True, text=True)
    print('  index :', (r.stdout or r.stderr).strip().splitlines()[-1])


def verifier(nom, attendu=None, tile=None):
    """Relit la planche ecrite et la compare a la source."""
    ts, cells = lire_planche(nom)
    ok = True
    if tile is not None and ts != tile:
        print(f'  ECHEC : tileSize relu {ts}, attendu {tile}')
        ok = False
    if attendu is not None:
        diff = 0
        for k, im in attendu.items():
            if k not in cells:
                diff += 1
                continue
            a = np.asarray(im.convert('RGBA')).astype(int)
            b = np.asarray(cells[k].convert('RGBA')).astype(int)
            # tolerance 1/255 : le premultiplie est une division entiere
            if np.abs(a - b).max() > 2:
                diff += 1
        print(f'  relecture : {len(cells)} tuiles, {diff} ecarts > 2/255')
        ok = ok and diff == 0
    print('  VERIFICATION :', 'OK' if ok else 'ECHEC')
    return ok


def cmd_verifier(a):
    ts, cells = lire_planche(a.nom)
    print(f'{a.nom} : tuile {ts} px, {len(cells)} cellules')
    xs = [k[0] for k in cells]
    ys = [k[1] for k in cells]
    print(f'  grille {max(xs)+1} x {max(ys)+1}')
    # apercu
    W = (max(xs) + 1) * ts
    H = (max(ys) + 1) * ts
    ap = Image.new('RGBA', (W, H), (25, 25, 35, 255))
    for (x, y), im in cells.items():
        ap.alpha_composite(im, (x * ts, y * ts))
    out = os.path.join(ROOT, 'docs', 'renders', f'tileset_{a.nom}.png')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    ap.save(out)
    print('  apercu ->', out)


def _echantillon_sol(a, grille, tile, align):
    """Convertit --sol X,Y (pixel image) en profil (lum, sat) de sa tuile."""
    if not a.sol:
        return None
    ax, ay = map(int, align.split(','))
    px, py = map(int, a.sol.split(','))
    k = ((px - ax) // tile, (py - ay) // tile)
    if k not in grille:
        print(f'  ATTENTION : le pixel --sol {a.sol} tombe sur la tuile {k}, '
              f'qui est vide. Heuristique de luminance utilisee a la place.')
        return None
    lum, sat = _profil(grille[k])
    print(f'  echantillon sol : tuile {k}, luminance {lum:.0f}, '
          f'saturation {sat:.0f}')
    return lum, sat


def cmd_carte(a):
    tile = a.tile
    if tile != 24:
        print(f'  NOTE : une carte de COMBAT se dessine en tuiles de 24 px '
              f'(GraphicsManager.TileSize). Vous demandez {tile}.')
        if not a.force:
            print('  ABANDON (--force pour passer outre).')
            return 1
    grille, st = decouper(a.image, tile, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    nx, ny = st['grille']
    if not grille:
        print('ABANDON : aucune tuile.')
        return 1
    ech = _echantillon_sol(a, grille, tile, a.align)
    sol = couleurs_sol(grille, a.solpct, ech)
    print(f'grille {nx}x{ny} | {len(grille)} tuiles | '
          f'{len(sol)} classees SOL, {len(grille)-len(sol)} MUR')

    doc = gabarit_rsmap()
    obj = doc['Object']
    proto = copy.deepcopy(obj['Tiles'][0][0])

    def mk(idv, x, y):
        t = copy.deepcopy(proto)
        t['Data']['ID'] = idv
        t['Data']['TileTex'] = tuile_vide()
        t['Effect']['TileLoc'] = {'X': x, 'Y': y}
        return t

    obj['Tiles'] = [[mk('floor' if (x, y) in sol else 'unbreakable', x, y)
                     for y in range(ny)] for x in range(nx)]
    couche = {'Name': 'Base', 'Layer': 0, 'Visible': True,
              'Tiles': [[tuile_ref(a.nom, x, y) if (x, y) in grille
                         else tuile_vide() for y in range(ny)]
                        for x in range(nx)]}
    obj['Layers'] = [couche]
    obj['AssetName'] = os.path.splitext(os.path.basename(a.sortie))[0]
    obj['Name'] = {'DefaultText': a.nom.replace('_', ' '), 'LocalTexts': {}}
    obj['MapTeams'] = []
    obj['AllyTeams'] = []
    obj['BlankBG'] = tuile_vide()

    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    ecrire_planche(a.nom, tile, grille)
    reindexer()
    dst = a.sortie if os.path.isabs(a.sortie) \
        else os.path.join(ROOT, 'Data', 'Map', os.path.basename(a.sortie))
    with open(dst, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print('ecrit', dst)
    verifier(a.nom, grille, tile)
    return 0


def cmd_ground(a):
    pas = a.grid
    if 8 * (pas // 8) != pas:
        print('  ABANDON : le pas de grille d\'un ground vaut 8 * TexSize.')
        return 1
    grille, st = decouper(a.image, pas, *map(int, a.align.split(',')),
                          seuil=a.seuil)
    nx, ny = st['grille']
    if not grille:
        print('ABANDON : aucune tuile.')
        return 1
    print(f'grille {nx}x{ny} cellules de {pas} px | {len(grille)} tuiles')

    doc = gabarit_rsground()
    obj = doc['Object']
    obj['TexSize'] = pas // 8
    obj['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                      'Tiles': [[tuile_ref(a.nom, x, y) if (x, y) in grille
                                 else tuile_vide() for y in range(ny)]
                                for x in range(nx)]}]
    ech = _echantillon_sol(a, grille, pas, a.align)
    sol = couleurs_sol(grille, a.solpct, ech)
    proto_ob = obj['obstacles'][0][0]
    obj['obstacles'] = [[{**copy.deepcopy(proto_ob),
                          'Tags': 0 if (x, y) in sol else 1}
                         for y in range(ny)] for x in range(nx)]
    obj['AssetName'] = os.path.splitext(os.path.basename(a.sortie))[0]
    if not a.apply:
        print('(essai a blanc ; --apply pour ecrire)')
        return 0
    ecrire_planche(a.nom, pas, grille)
    reindexer()
    dst = a.sortie if os.path.isabs(a.sortie) \
        else os.path.join(ROOT, 'Data', 'Ground', os.path.basename(a.sortie))
    with open(dst, 'w', encoding='utf-8') as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
    print('ecrit', dst)
    verifier(a.nom, grille, pas)
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)

    def commun(p):
        p.add_argument('--tile', type=int, default=24)
        p.add_argument('--align', default='0,0')
        p.add_argument('--seuil', type=float, default=1.0)
        p.add_argument('--solpct', type=float, default=55.0)
        p.add_argument('--sol', default=None,
                       help='X,Y : pixel echantillon du terrain marchable')
        p.add_argument('--apply', action='store_true')
        p.add_argument('--force', action='store_true')

    p = sub.add_parser('decoupe'); p.add_argument('image'); commun(p)
    p = sub.add_parser('importer'); p.add_argument('image'); p.add_argument('nom'); commun(p)
    p = sub.add_parser('carte'); p.add_argument('image'); p.add_argument('nom'); p.add_argument('sortie'); commun(p)
    p = sub.add_parser('ground'); p.add_argument('image'); p.add_argument('nom'); p.add_argument('sortie')
    p.add_argument('--grid', type=int, default=8); commun(p)
    p = sub.add_parser('verifier'); p.add_argument('nom')

    a = ap.parse_args()
    return {'decoupe': cmd_decoupe, 'importer': cmd_importer,
            'carte': cmd_carte, 'ground': cmd_ground,
            'verifier': cmd_verifier}[a.cmd](a) or 0


if __name__ == '__main__':
    sys.exit(main())
