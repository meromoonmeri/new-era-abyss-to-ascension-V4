#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
render_all_red_sky.py — Rendu PNG haute fidélité de toutes les cartes Ground
issues des conversions de Rescue Team et Explorateurs du Ciel.
"""
import os, io, json, struct, time
from concurrent.futures import ProcessPoolExecutor
import multiprocessing
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TILE_DIRS = [
    os.path.join(ROOT, 'Content', 'Tile'),
    os.path.join(ROOT, 'RESERVE', 'red_tiles'),
    os.path.join(ROOT, 'RESERVE', 'sky_tiles'),
    '/tmp/pmdred-port/output/Tiles'
]
DATA_GROUND = os.path.join(ROOT, 'Data', 'Ground')
OUT_RED_DIR = os.path.join(ROOT, 'docs', 'renders', 'rescue_team')
OUT_SKY_DIR = os.path.join(ROOT, 'docs', 'renders', 'sky')
os.makedirs(OUT_RED_DIR, exist_ok=True)
os.makedirs(OUT_SKY_DIR, exist_ok=True)

def find_tile_file(sheet_name):
    for d in TILE_DIRS:
        p = os.path.join(d, sheet_name + '.tile')
        if os.path.exists(p):
            return p
    return None

def decode_tile_package(path):
    if not path or not os.path.exists(path):
        return None, None
    with open(path, 'rb') as f:
        raw = f.read()
    if len(raw) < 8:
        return None, None
    tile_size, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    recs = []
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        recs.append((key & 0xFFFFFFFF, key >> 32, off))
    for x, y, off in recs:
        if (x, y) in cells or off + 8 >= len(raw):
            continue
        ln = struct.unpack_from('<Q', raw, off)[0]
        if off + 8 + ln > len(raw):
            continue
        png_bytes = raw[off + 8: off + 8 + ln]
        try:
            cells[(x, y)] = Image.open(io.BytesIO(png_bytes)).convert('RGBA')
        except Exception:
            pass
    return tile_size, cells

def render_single_ground(task):
    map_name, out_dir = task
    ground_path = os.path.join(DATA_GROUND, map_name + '.rsground')
    out_png_path = os.path.join(out_dir, map_name + '.png')
    
    if not os.path.exists(ground_path):
        return map_name, False, "Fichier rsground introuvable"
        
    try:
        with open(ground_path, encoding='utf-8-sig') as f:
            obj = json.load(f)['Object']
            
        tex = obj.get('TexSize', 1)
        pitch = 8 * tex
        layers = obj.get('Layers', [])
        if not layers or not layers[0].get('Tiles'):
            return map_name, False, "Pas de calques Tiles"
            
        W = len(layers[0]['Tiles'])
        H = len(layers[0]['Tiles'][0])
        if W == 0 or H == 0:
            return map_name, False, "Dimensions nulles"
            
        img = Image.new('RGBA', (W * pitch, H * pitch), (0, 0, 0, 0))
        
        # Cache local des packages pour cette carte
        local_pkg_cache = {}
        
        for li, layer in enumerate(layers):
            if not layer.get('Visible', True):
                continue
            tiles = layer.get('Tiles', [])
            for x in range(min(W, len(tiles))):
                col = tiles[x]
                for y in range(min(H, len(col))):
                    cell = col[y]
                    for tl in cell.get('Layers', []):
                        frames = tl.get('Frames', [])
                        if not frames: continue
                        fr = frames[0]
                        sheet = fr.get('Sheet', '')
                        if not sheet: continue
                        
                        if sheet not in local_pkg_cache:
                            tile_file = find_tile_file(sheet)
                            local_pkg_cache[sheet] = decode_tile_package(tile_file)
                            
                        tsize, cells = local_pkg_cache[sheet]
                        if not cells: continue
                        
                        loc = fr.get('TexLoc', {'X': 0, 'Y': 0})
                        t = cells.get((loc['X'], loc['Y']))
                        if t is None: continue
                        
                        img.alpha_composite(t, (x * pitch, y * pitch))
                        
        img.save(out_png_path, 'PNG')
        return map_name, True, f"{W*pitch}x{H*pitch} px"
        
    except Exception as e:
        return map_name, False, str(e)

def main():
    red_tasks = []
    for f in os.listdir(DATA_GROUND):
        if f.endswith('.rsground'):
            name = f[:-9]
            if (len(name) >= 4 and name[0] in 'abdhwt' and name[1].isdigit()) or any(name.startswith(p) for p in ['abime_', 'antre_', 'bois_', 'champ_', 'cretes_', 'fosse_', 'sommet_', 'vallon_', 'pre_']):
                red_tasks.append((name, OUT_RED_DIR))

    sky_tasks = []
    for f in os.listdir(DATA_GROUND):
        if f.endswith('.rsground'):
            name = f[:-9]
            if name.startswith('sky_') or name.startswith('cloven_ruin_regi') or name.startswith('arc_') or name in ['treasure_spinda_cafe', 'd18p11a', 'd19p11a', 'd20p11a', 'd21p21a', 'd21p41a', 'd22p11a', 'p05p01a', 'p05p02a', 'p05p03a', 'p05p04a', 'p06p01a', 'p07p01a', 'p08p01a', 'p09p01a']:
                sky_tasks.append((name, OUT_SKY_DIR))

    all_tasks = red_tasks + sky_tasks
    print(f"Lancement du rendu de {len(all_tasks)} maps ({len(red_tasks)} Rescue Team + {len(sky_tasks)} Sky)...")

    start_t = time.time()
    num_workers = min(os.cpu_count() or 4, 8)
    success_count = 0
    fail_count = 0

    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        results = list(executor.map(render_single_ground, all_tasks))
        
    for name, ok, msg in results:
        if ok:
            success_count += 1
        else:
            fail_count += 1
            print(f"  ❌ Échec {name}: {msg}")

    elapsed = time.time() - start_t
    print(f"\n=== RENDU TERMINÉ EN {elapsed:.2f}s ===")
    print(f"Succès : {success_count} / {len(all_tasks)} PNGs générés")
    print(f"Échecs : {fail_count}")

if __name__ == '__main__':
    main()
