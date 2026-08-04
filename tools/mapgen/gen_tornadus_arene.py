#!/usr/bin/env python3
# =============================================================================
# gen_tornadus_arene.py — regenere l'arene du boss Tornadus (ch5) par la
# METHODE DES RELAIS : clone d'un patron valide + re-skin biome, topologie
# et câblage intacts.
#
#   Patron structurel : crooked_den (salle compacte, feuille dediee 8px,
#                        3 spawners TEAMMATE, aucune sortie-scriptee).
#   Matériau visuel   : mount_windswept_entrance (feuilles Mount_Windswept_*,
#                        style EoS Mt Horn — meme famille que le biome garde).
#   Cible ecrasée     : Data/Ground/mount_windswept_guardian.rsground
#                       (actuelle : feuille 24px sur grille 8px = rendu casse).
#
# Invariants preserves :
#   - NOM, Name FR, musique ('Sky Tower.ogg'), scripts Lua, zone, master_zone
#   - .rsmap de combat (19x19 craggy_peak) : deja valide → NON TOUCHE
#   - choregraphie mount_windswept_guardian_ch_5.lua : toutes ses positions
#     vivent dans le carre 432x432 px (x 168-264, y 24-392, camera 216,216)
#     => l'arene fait exactement 54x54 cellules de 8px = 432x432 px.
#
# Contrôles integres : positions Lua forcement libres, connexité BFS depuis
# l'entrée sud, injection index.idx + verification des blobs PNG.
#
#   python3 tools/mapgen/gen_tornadus_arene.py          # dry-run, rendu preview
#   python3 tools/mapgen/gen_tornadus_arene.py --ecrire # materialise tout
# =============================================================================
import io
import json
import os
import struct
import sys
from collections import deque

import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')

PATRON = os.path.join(ROOT, 'Data', 'Ground', 'crooked_den.rsground')
SOURCE = os.path.join(ROOT, 'Data', 'Ground', 'mount_windswept_entrance.rsground')
CIBLE = os.path.join(ROOT, 'Data', 'Ground', 'mount_windswept_guardian.rsground')
FEUILLE = 'Mount_Windswept_Guardian_Base'

CELL = 8
ARENA_W = ARENA_H = 54          # cellules ; 54x8 = 432 px

# Positions durcies de mount_windswept_guardian_ch_5.lua (px) — DOIVENT
# rester marchables (perso ~ boite 24px autour ±).
LUA_POINTS = [
    (216, 376), (168, 376), (264, 376), (216, 392),   # teleports equipe
    (216, 360), (168, 360), (264, 360), (216, 376),   # variantes scenes
    (216, 380), (216, 340), (216, 320), (216, 220),   # cheminements
    (216, 24),                                        # perchoir Tornadus
]

# Zones libres forcees (en cellules, x0,y0,x1,y1 inclus)
PERCHOIR = (24, 2, 29, 5)       # atterrissage de Tornadus au nord
SUD_ZONE = (21, 46, 32, 50)     # arrivee de l'equipe au sud
COULOIR = (20, 6, 33, 45)       # scene centrale : aucun obstacle


# ---------------------------------------------------------------------------
# Chargements
# ---------------------------------------------------------------------------
_PKGCACHE = {}


def load_package(sheet):
    if sheet in _PKGCACHE:
        return _PKGCACHE[sheet]
    with open(os.path.join(TILEDIR, sheet + '.tile'), 'rb') as f:
        raw = f.read()
    ts, cnt = struct.unpack_from('<II', raw, 0)
    cells = {}
    for i in range(cnt):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        x, y = key & 0xFFFFFFFF, key >> 32
        ln, = struct.unpack_from('<q', raw, off)
        cells[(x, y)] = Image.open(
            io.BytesIO(raw[off + 8:off + 8 + ln])).convert('RGBA')
    _PKGCACHE[sheet] = (ts, cells)
    return _PKGCACHE[sheet]


def render_ground_image(path):
    """Image RGBA complete + masque bloque (bool), cellule = 8px."""
    o = json.load(open(path, encoding='utf-8-sig'))['Object']
    L0 = o['Layers'][0]['Tiles']
    W, H = len(L0), len(L0[0])
    img = Image.new('RGBA', (W * CELL, H * CELL), (0, 0, 0, 255))
    for lay in o['Layers']:
        if not lay.get('Visible', True):
            continue
        T = lay['Tiles']
        for x in range(W):
            for y in range(H):
                for tl in T[x][y].get('Layers', []):
                    frs = tl.get('Frames', [])
                    if not frs or not frs[0].get('Sheet'):
                        continue
                    ts, cells = load_package(frs[0]['Sheet'])
                    src = cells.get((frs[0]['TexLoc']['X'],
                                     frs[0]['TexLoc']['Y']))
                    if src is not None:
                        img.alpha_composite(src, (x * CELL, y * CELL))
    ob = o['obstacles']
    blocked = np.array([[ob[x][y].get('Tags', 0) != 0 for y in range(H)]
                        for x in range(W)], dtype=bool)
    return o, np.asarray(img), blocked


# ---------------------------------------------------------------------------
# Composition
# ---------------------------------------------------------------------------
def build_arena(seed=20260805):
    """Compose l'image 432x432 + le masque bloque depuis l'entree du mont."""
    rng = np.random.default_rng(seed)
    _o, src, src_blocked = render_ground_image(SOURCE)
    SH, SW = src.shape[:2]                      # 552x504 px (69x63 cellules)
    cw, ch = SW // CELL, SH // CELL             # 69x63 cellules

    # -- 1. fenetre 54 cellules : recentrage auto sur le couloir libre --
    best, best_ox = -1, 0
    for ox in range(0, cw - ARENA_W + 1):
        strip = src_blocked[ox + 22:ox + 32, 10:50]     # futur couloir
        free = 1.0 - strip.mean()
        if free > best:
            best, best_ox = free, ox
    OX = best_ox * CELL
    print(f'fenetre source : ox={best_ox} cellules ({OX}px), '
          f'couloir libre a {best * 100:.1f}%')
    arena = src[0:ARENA_H * CELL, OX:OX + ARENA_W * CELL].copy()
    blocked = src_blocked[best_ox:best_ox + ARENA_W, 0:ARENA_H].copy()

    # bibliotheque de cellules de sol propre de la source (zones libres,
    # pixels tous opaques, pas de falaise voisine)
    sols = []
    for cx in range(best_ox + 8, best_ox + ARENA_W - 8):
        for cy in range(20, 52):
            if src_blocked[cx, cy]:
                continue
            p = src[cy * CELL:(cy + 1) * CELL, cx * CELL:(cx + 1) * CELL]
            if (p[:, :, 3] == 255).all():
                sols.append(p)
    assert len(sols) > 50, 'pas assez de cellules de sol source'

    def pave_floor(x0, y0, x1, y1):
        """Pave la zone (cellules incluses) avec du sol source varie."""
        for cx in range(x0, x1 + 1):
            for cy in range(y0, y1 + 1):
                arena[cy * CELL:(cy + 1) * CELL,
                      cx * CELL:(cx + 1) * CELL] = sols[rng.integers(
                          len(sols))]
                blocked[cx, cy] = False

    # -- 2. pourtour falaise : pools de cellules puisees dans la bande nord
    #       de la fenetre (y 0..1 = falaise pleine, y 2 = lisiere), avec
    #       mirroirs pour la variete ; reportees sur le pourtour complet
    #       sauf l'entree sud --
    def pool(y0, y1):
        cells = []
        for cy in range(y0, y1):
            for cx in range(ARENA_W):
                p = arena[cy * CELL:(cy + 1) * CELL,
                          cx * CELL:(cx + 1) * CELL].copy()
                cells.append(p)
                cells.append(p[:, ::-1])          # miroir horizontal
        return cells

    cliff_full = pool(0, 2)
    cliff_edge = pool(2, 3)

    def put_cliff(cx, cy, edge=False):
        band = cliff_edge if edge else cliff_full
        arena[cy * CELL:(cy + 1) * CELL,
              cx * CELL:(cx + 1) * CELL] = band[rng.integers(len(band))]
        blocked[cx, cy] = True

    for cx in range(ARENA_W):                   # muraille nord 2 cellules
        put_cliff(cx, 0)
        put_cliff(cx, 1)
    for cy in range(2, ARENA_H - 4):            # flancs
        put_cliff(0, cy, edge=(cy < 4))
        put_cliff(1, cy)
        put_cliff(ARENA_W - 2, cy)
        put_cliff(ARENA_W - 1, cy, edge=(cy < 4))
    for cx in range(ARENA_W):                   # muret sud sauf entree
        for cy in range(ARENA_H - 3, ARENA_H):
            if not (24 <= cx <= 29):
                put_cliff(cx, cy, edge=(cy == ARENA_H - 3))

    # -- 3. zones sceniques : sol libre garanti --
    pave_floor(*PERCHOIR)                       # perchoir Tornadus (nord)
    pave_floor(*SUD_ZONE)                       # arrivee equipe (sud)
    pave_floor(*COULOIR)                        # scene centrale

    # -- 4. garde-fou Lua : toutes les positions de la choregraphie libres --
    for (px, py) in LUA_POINTS:
        cx, cy = px // CELL, py // CELL
        assert 2 <= cx < ARENA_W - 2 and 2 <= cy < ARENA_H - 3, \
            f'position Lua ({px},{py}) dans le pourtour'
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                blocked[cx + dx, cy + dy] = False

    # -- 5. connexite : BFS depuis l'entree sud (27,50) ; poches isolees --
    start = (ARENA_W // 2, ARENA_H - 4)
    seen = np.zeros_like(blocked)
    q = deque([start])
    seen[start] = True
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < ARENA_W and 0 <= ny < ARENA_H \
                    and not blocked[nx, ny] and not seen[nx, ny]:
                seen[nx, ny] = True
                q.append((nx, ny))
    pockets = (~blocked & ~seen)
    blocked |= pockets
    n_free = int((~blocked).sum())
    print(f'marchable : {n_free}/{ARENA_W * ARENA_H} '
          f'({100 * n_free // (ARENA_W * ARENA_H)}%), '
          f'{int(pockets.sum())} cellules isolees bouchees')
    for (px, py) in LUA_POINTS:
        assert seen[px // CELL, py // CELL], \
            f'position Lua ({px},{py}) injoignable'
    print('positions Lua : toutes libres et joignables')
    return arena, blocked


# ---------------------------------------------------------------------------
# Ecritures
# ---------------------------------------------------------------------------
def write_package(path, grid_cells):
    """grid_cells : iterable (x, y, ndarray 8x8x4). Format .tile dedupé."""
    keys = sorted(grid_cells, key=lambda c: (c[1], c[0]))
    blobs, order = {}, []
    pngs = {}
    for x, y, arr in keys:
        im = Image.fromarray(arr, 'RGBA')
        buf = io.BytesIO()
        im.save(buf, format='PNG')
        png = buf.getvalue()
        pngs[(x, y)] = png
        if png not in blobs:
            blobs[png] = None
            order.append(png)
    header = 8 + len(keys) * 16
    off = header
    for png in order:
        blobs[png] = off
        off += 8 + len(png)
    out = bytearray(struct.pack('<II', CELL, len(keys)))
    table = []
    for x, y, _a in keys:
        k = x | (y << 32)
        table.append((k, blobs[pngs[(x, y)]]))
        out += struct.pack('<QQ', k, blobs[pngs[(x, y)]])
    for png in order:
        out += struct.pack('<q', len(png)) + png
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return table, len(out)


def index_append(nom, tile_size, table):
    """Ajoute `nom` a Content/Tile/index.idx en preservant les bytes."""
    idx_path = os.path.join(TILEDIR, 'index.idx')
    raw = open(idx_path, 'rb').read()
    n, = struct.unpack_from('<I', raw, 0)
    pos = 4
    entries = []
    for _ in range(n):
        ln, = struct.unpack_from('<B', raw, pos)
        pos += 1
        name = raw[pos:pos + ln]
        pos += ln
        ts, cnt = struct.unpack_from('<II', raw, pos)
        pos += 8 + cnt * 16
        entries.append((name, ts, cnt))
    body = raw[4:pos]
    assert pos == len(raw), 'index.idx malforme'
    assert nom.encode() not in [e[0] for e in entries], 'deja present'
    out = bytearray(struct.pack('<I', n + 1))
    out += body                              # bytes existants INTACTS
    nb = nom.encode('utf-8')
    out += struct.pack('<B', len(nb)) + nb
    out += struct.pack('<II', tile_size, len(table))
    for k, off in table:
        out += struct.pack('<QQ', k, off)
    open(idx_path, 'wb').write(bytes(out))
    print(f'index.idx : {n} -> {n + 1} tilesets (+{nom})')


def cell_identity(sheet, x, y):
    return {'AutoTileset': '', 'Associates': [],
            'Layers': [{'Frames': [{'Sheet': sheet,
                                    'TexLoc': {'X': x, 'Y': y}}],
                        'FrameLength': 60}],
            'NeighborCode': -1}


def write_ground(blocked):
    """Clone le patron crooked_den, remplace geometrie/couche/spawners."""
    patron = json.load(open(PATRON, encoding='utf-8-sig'))
    ancien = json.load(open(CIBLE, encoding='utf-8-sig'))['Object']
    o = patron['Object']
    o['AssetName'] = 'mount_windswept_guardian'
    o['Name'] = ancien.get('Name', {'DefaultText': 'Mount Windswept Summit',
                                    'LocalTexts': {'fr': 'Mont Venteux'}})
    o['Music'] = ancien.get('Music', 'Sky Tower.ogg')
    o['Comment'] = (ancien.get('Comment', '') +
                    ' | gen_tornadus_arene 2026-08-05 : salle regeneree au '
                    'patron crooked_den (54x54, perchoir nord, entree sud) ; '
                    'feuille dediee 8px composee depuis mount_windswept_'
                    'entrance ; ancienne feuille 24px sur grille 8px '
                    '(rendu casse) remplacee.').strip()
    # obstacles
    o['obstacles'] = [
        [{'Bounds': {'X': x * CELL, 'Y': y * CELL,
                     'Width': CELL, 'Height': CELL},
          'Tags': 1 if blocked[x, y] else 0}
         for y in range(ARENA_H)] for x in range(ARENA_W)]
    # une couche, identity mapping vers la feuille dediee
    o['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                    'Tiles': [[cell_identity(FEUILLE, x, y)
                               for y in range(ARENA_H)]
                              for x in range(ARENA_W)]}]
    # spawners : positions synchrones des TeleportTo du script ch_5
    spots = {'Teammate1': (168, 376), 'Teammate2': (264, 376),
             'Teammate3': (216, 392)}
    for sp in o['Entities'][0]['Spawners']:
        nm = sp.get('NPCName')
        if nm in spots:
            x, y = spots[nm]
            sp['Collider'] = {'X': x, 'Y': y, 'Width': 16, 'Height': 16}
    # markers : zone/mount_windswept/init.lua entre par 'Main_Entrance_Marker'
    # (ExitSegment, lignes 148/156) ; on le place dans l'entree sud (libre).
    # Le marker 'entrance' herite de l'ancien ground est preserve aussi.
    ent = o['Entities'][0]
    avecentree = False
    for mk in ent.get('Markers', []):
        if mk.get('EntName') == 'Main_Entrance_Marker':
            mk['Collider'] = {'X': 216, 'Y': 408, 'Width': 16, 'Height': 16}
            avecentree = True
    assert avecentree, 'Main_Entrance_Marker absent du patron'
    for mk in (ancien['Entities'][0].get('Markers') or []):
        if mk.get('EntName') == 'entrance':
            mk = dict(mk)
            mk['Collider'] = {'X': 216, 'Y': 408, 'Width': 16, 'Height': 16}
            ent.setdefault('Markers', []).append(mk)
    text = json.dumps(patron, ensure_ascii=False, indent=0)
    open(CIBLE, 'w', encoding='utf-8-sig').write(text)
    print(f'{os.path.relpath(CIBLE, ROOT)} : 54x54, couche Base -> '
          f'{FEUILLE}, obstacles regen')


# ---------------------------------------------------------------------------
def preview(arena, blocked, out):
    img = Image.fromarray(arena).resize((ARENA_W * CELL * 2,
                                         ARENA_H * CELL * 2),
                                        Image.NEAREST)
    from PIL import ImageDraw
    d = ImageDraw.Draw(img)
    for (px, py) in LUA_POINTS:
        d.ellipse([px * 2 - 5, py * 2 - 5, px * 2 + 5, py * 2 + 5],
                  outline=(255, 60, 60, 255), width=2)
    # entree sud + perchoir
    d.rectangle([PERCHOIR[0] * 16, PERCHOIR[1] * 16,
                 (PERCHOIR[2] + 1) * 16 - 1, (PERCHOIR[3] + 1) * 16 - 1],
                outline=(255, 210, 40, 255), width=2)
    d.rectangle([24 * 16, 51 * 16, 30 * 16 - 1, 54 * 16 - 1],
                outline=(60, 255, 60, 255), width=2)
    img.save(out)
    print('preview ->', out)


def main():
    ecrire = '--ecrire' in sys.argv
    arena, blocked = build_arena()
    pv = os.path.join(ROOT, 'docs', 'renders',
                      'mount_windswept_guardian_nouveau.png')
    os.makedirs(os.path.dirname(pv), exist_ok=True)
    preview(arena, blocked, pv)
    if not ecrire:
        print('(--ecrire pour materialiser feuille + index + ground)')
        return 0
    cells = [(x, y, arena[y * CELL:(y + 1) * CELL,
                          x * CELL:(x + 1) * CELL])
             for x in range(ARENA_W) for y in range(ARENA_H)]
    path = os.path.join(TILEDIR, FEUILLE + '.tile')
    table, sz = write_package(path, cells)
    print(f'{FEUILLE}.tile : {len(table)} cellules, {sz} octets')
    index_append(FEUILLE, CELL, table)
    write_ground(blocked)
    print('OK. Verifications suivantes :')
    print('  python3 tools/verify_tile_index.py --quiet')
    print('  python3 tools/render_ground.py mount_windswept_guardian')
    print('  python3 tools/validate_all.py')
    return 0


if __name__ == '__main__':
    sys.exit(main())
