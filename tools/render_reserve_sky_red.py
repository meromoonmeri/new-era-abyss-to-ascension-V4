#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
render_reserve_sky_red.py — Rendu PNG exhaustif de toutes les 712 cartes de sol
importées dans RESERVE/red_grounds (245 GBA) & RESERVE/sky_grounds (467 DS) +
génération d'un catalogue illustré dans docs/CATALOGUE_RESERVE_GROUNDS_SKY_RED.md.
"""
import os, sys, glob, json, struct, io, time
from concurrent.futures import ProcessPoolExecutor, as_completed
from PIL import Image

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
RED_GROUNDS = os.path.join(MOD_ROOT, "RESERVE", "red_grounds")
RED_TILES = os.path.join(MOD_ROOT, "RESERVE", "red_tiles")
SKY_GROUNDS = os.path.join(MOD_ROOT, "RESERVE", "sky_grounds")
SKY_TILES = os.path.join(MOD_ROOT, "RESERVE", "sky_tiles")

OUT_RED = os.path.join(MOD_ROOT, "docs", "renders", "reserve_red")
OUT_SKY = os.path.join(MOD_ROOT, "docs", "renders", "reserve_sky")
os.makedirs(OUT_RED, exist_ok=True)
os.makedirs(OUT_SKY, exist_ok=True)

def render_task(args):
    rsground_path, tiles_dir, out_png = args
    stem = os.path.splitext(os.path.basename(rsground_path))[0]
    try:
        data = json.load(open(rsground_path, "r", encoding="utf-8-sig"))["Object"]
        obs = data.get("obstacles", [])
        W, H = len(obs), len(obs[0]) if obs else (0, 0)
        tex = data.get("TexSize", 1)
        pitch = 8 * tex
        grid_W, grid_H = len(data["Layers"][0]["Tiles"]), len(data["Layers"][0]["Tiles"][0])
        free = sum(1 for x in range(W) for y in range(H) if obs[x][y].get("Tags", 0) == 0)
        pct = int(free * 100 / (W * H)) if W * H > 0 else 0
        if os.path.exists(out_png):
            kb = os.path.getsize(out_png) // 1024
            rel_png = os.path.relpath(out_png, MOD_ROOT)
            return (True, stem, grid_W*pitch, grid_H*pitch, W, H, pct, kb, rel_png)
        data = json.load(open(rsground_path, "r", encoding="utf-8-sig"))["Object"]
        obs = data.get("obstacles", [])
        W, H = len(obs), len(obs[0]) if obs else (0, 0)
        tex = data.get("TexSize", 1)
        pitch = 8 * tex
        
        layer0 = data["Layers"][0]
        sheet_name = ""
        for col in layer0.get("Tiles", []):
            for cell in col:
                for tl in cell.get("Layers", []):
                    for fr in tl.get("Frames", []):
                        if fr.get("Sheet"):
                            sheet_name = fr["Sheet"]
                            break
                    if sheet_name: break
                if sheet_name: break
            if sheet_name: break
            
        if not sheet_name:
            return (False, stem, "Feuille introuvable", 0, 0, 0, 0, 0, "")
            
        tile_path = os.path.join(tiles_dir, sheet_name + ".tile")
        if not os.path.exists(tile_path):
            return (False, stem, f"Tile absent: {sheet_name}.tile", 0, 0, 0, 0, 0, "")
            
        with open(tile_path, "rb") as f:
            raw = f.read()
        ts, cnt = struct.unpack_from("<II", raw, 0)
        cells = {}
        for i in range(cnt):
            key, off = struct.unpack_from("<QQ", raw, 8 + i*16)
            ln = struct.unpack_from("<Q", raw, off)[0]
            png = raw[off+8:off+8+ln]
            cells[(key & 0xFFFFFFFF, key >> 32)] = Image.open(io.BytesIO(png)).convert("RGBA")
            
        grid_W, grid_H = len(layer0["Tiles"]), len(layer0["Tiles"][0])
        img = Image.new("RGBA", (grid_W * pitch, grid_H * pitch), (0, 0, 0, 255))
        
        for x in range(grid_W):
            col = layer0["Tiles"][x]
            for y in range(grid_H):
                cell = col[y]
                for tl in cell.get("Layers", []):
                    frames = tl.get("Frames", [])
                    if frames:
                        loc = frames[0].get("TexLoc", {"X": 0, "Y": 0})
                        t = cells.get((loc["X"], loc["Y"]))
                        if t:
                            img.alpha_composite(t, (x * pitch, y * pitch))
                            
        img.save(out_png, "PNG")
        free = sum(1 for x in range(W) for y in range(H) if obs[x][y].get("Tags", 0) == 0)
        pct = int(free * 100 / (W * H)) if W * H > 0 else 0
        kb = os.path.getsize(out_png) // 1024
        rel_png = os.path.relpath(out_png, MOD_ROOT)
        return (True, stem, grid_W*pitch, grid_H*pitch, W, H, pct, kb, rel_png)
    except Exception as e:
        return (False, stem, str(e), 0, 0, 0, 0, 0, "")

def main():
    red_files = sorted(glob.glob(os.path.join(RED_GROUNDS, "*.rsground")))
    sky_files = sorted(glob.glob(os.path.join(SKY_GROUNDS, "*.rsground")))
    
    tasks = []
    for f in red_files:
        stem = os.path.splitext(os.path.basename(f))[0]
        tasks.append((f, RED_TILES, os.path.join(OUT_RED, stem + ".png")))
    for f in sky_files:
        stem = os.path.splitext(os.path.basename(f))[0]
        tasks.append((f, SKY_TILES, os.path.join(OUT_SKY, stem + ".png")))
        
    print(f"=== DÉBUT DU RENDU EXHAUSTIF DE {len(tasks)} CARTES (245 RED + 467 SKY) ===")
    t0 = time.time()
    
    red_results = []
    sky_results = []
    success_count = 0
    fail_count = 0
    
    with ProcessPoolExecutor(max_workers=os.cpu_count() or 4) as executor:
        for i, res in enumerate(executor.map(render_task, tasks), 1):
            if res[0]:
                success_count += 1
                _, stem, w_px, h_px, w_c, h_c, pct, kb, rel_png = res
                if "reserve_red" in rel_png:
                    red_results.append((stem, w_px, h_px, w_c, h_c, pct, kb, rel_png))
                else:
                    sky_results.append((stem, w_px, h_px, w_c, h_c, pct, kb, rel_png))
                if i % 100 == 0 or i == len(tasks):
                    print(f"  [{i:3d}/{len(tasks)}] Rendu {stem:25s} -> {w_px}x{h_px}px ({pct}% libre, {kb} Ko)")
            else:
                fail_count += 1
                print(f"  ❌ Échec sur {res[1]} : {res[2]}")
                
    t_total = round(time.time() - t0, 2)
    print(f"=== RENDU TERMINÉ en {t_total}s : {success_count} réussis, {fail_count} échecs ===")
    
    red_results.sort(key=lambda x: x[0])
    sky_results.sort(key=lambda x: x[0])
    
    md_path = os.path.join(MOD_ROOT, "docs", "CATALOGUE_RESERVE_GROUNDS_SKY_RED.md")
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("# CATALOGUE EXHAUSTIF DES 712 CARTES DE SOL IMPORTÉES (SKY & RED)\n\n")
        f.write(f"**Projet** : *New Era : Abyss to Ascension*\n")
        f.write(f"**Date de rendu** : 2026-08-07\n")
        f.write(f"**Total Cartes Rendu PNG** : **{success_count} cartes `.rsground`** converties depuis les assets authentiques de GBA (PMD Red) & DS (PMD Sky).\n\n")
        f.write("Chaque carte ci-dessous dispose d'un rendu haute définition PNG consultable dans `docs/renders/reserve_red/` ou `docs/renders/reserve_sky/`.\n\n")
        
        def write_section(title, rows):
            f.write(f"## {title} ({len(rows)} cartes)\n\n")
            f.write("| Identifiant (`ID`) | Résolution (px) | Grille (8px) | % Marchable | Poids (Ko) | Chemin PNG de Rendu |\n")
            f.write("| :--- | :---: | :---: | :---: | :---: | :--- |\n")
            for stem, w_px, h_px, w_c, h_c, pct, kb, rel_png in rows:
                f.write(f"| **`{stem}`** | {w_px}×{h_px} px | {w_c}×{h_c} | {pct}% | {kb} Ko | `{rel_png}` |\n")
            f.write("\n---\n\n")
            
        write_section("1. CARTES ET ENTRÉES GBA — POKÉMON DONJON MYSTÈRE RED RESCUE TEAM", red_results)
        write_section("2. CARTES ET ENTRÉES NINTENDO DS — POKÉMON DONJON MYSTÈRE EXPLORERS OF SKY", sky_results)
        
    print(f"✅ Catalogue markdown généré dans : docs/CATALOGUE_RESERVE_GROUNDS_SKY_RED.md")

if __name__ == "__main__":
    main()
