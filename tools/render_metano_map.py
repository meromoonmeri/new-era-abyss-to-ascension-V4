#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""render_metano_map.py — reconstitue le rendu visuel d'une map Metano.

Combine toutes les tile sheets référencées par la .rsground en une image
qui montre le rendu final (tel qu'il apparaîtrait en jeu).

Usage:
    python3 tools/render_metano_map.py --ground Data/Ground/metano_town.rsground
    python3 tools/render_metano_map.py --all
"""
import argparse
import json
import struct
from pathlib import Path
from PIL import Image
import io
from collections import defaultdict, Counter

ROOT = Path(__file__).resolve().parents[1]
TILEDIR = ROOT / "Content" / "Tile"
GROUNDDIR = ROOT / "Data" / "Ground"
OUTDIR = ROOT / ".runtime-cache" / "metano_renders"


def load_tile_sheet(path: Path) -> dict:
    """Charge un .tile et retourne un cache {(cx, cy): PIL.Image}."""
    cache = {}
    if not path.exists():
        return cache
    with open(path, "rb") as f:
        tileSize, tileCount = struct.unpack("<II", f.read(8))
        if tileSize != 8:
            return cache
        indirs = []
        for _ in range(tileCount):
            key, byte_offset = struct.unpack("<QQ", f.read(16))
            cx = key & 0xFFFFFFFF
            cy = (key >> 32) & 0xFFFFFFFF
            indirs.append((cx, cy, byte_offset))
        # Cache unique blobs
        blob_cache = {}
        for cx, cy, byte_offset in indirs:
            if byte_offset not in blob_cache:
                f.seek(byte_offset)
                length = struct.unpack("<q", f.read(8))[0]
                if length < 0 or length > 1_000_000:
                    blob_cache[byte_offset] = None
                else:
                    blob_cache[byte_offset] = f.read(length)
            data = blob_cache[byte_offset]
            if not data:
                continue
            try:
                img = Image.open(io.BytesIO(data))
                if img.size == (8, 8):
                    cache[(cx, cy)] = img
            except Exception:
                pass
    return cache


def render_ground(ground_path: Path, sheet_cache: dict) -> Image.Image:
    """Génère le rendu visuel d'un .rsground."""
    with open(ground_path, encoding="utf-8-sig") as f:
        d = json.load(f)
    obj = d['Object']
    if not obj.get('Layers') or not obj['Layers'][0].get('Tiles'):
        return None
    rows = len(obj['Layers'][0]['Tiles'])
    cols = len(obj['Layers'][0]['Tiles'][0])
    W, H = cols * 8, rows * 8

    # Composite: for each cell, draw all 4 layers in order
    composite = Image.new("RGBA", (W, H), (0, 0, 0, 0))

    # Order: ground (layer 0) -> cliff (1) -> objects (2) -> animated (3) -> fringe (3-4)
    # In metano_town: layer 0 has Ground sheet only, layer 1 has Cliffs, etc.
    # We'll just composite all layers as-is.

    for layer in obj['Layers']:
        layer_name = layer.get('Name', '')
        layer_idx = layer.get('Layer', 0)
        for y, row in enumerate(layer['Tiles']):
            for x, cell in enumerate(row):
                for sub in cell.get('Layers', []):
                    for frame in sub.get('Frames', []):
                        sheet_name = frame.get('Sheet', '')
                        tex = frame.get('TexLoc', {})
                        tx, ty = tex.get('X', 0), tex.get('Y', 0)
                        if sheet_name not in sheet_cache:
                            sheet_cache[sheet_name] = load_tile_sheet(TILEDIR / f"{sheet_name}.tile")
                        tile = sheet_cache[sheet_name].get((tx, ty))
                        if tile:
                            composite.alpha_composite(tile, (x * 8, y * 8))
    return composite


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ground", type=Path, help="Render a specific .rsground")
    parser.add_argument("--all", action="store_true", help="Render all Metano_* grounds")
    args = parser.parse_args()

    OUTDIR.mkdir(parents=True, exist_ok=True)

    if args.ground:
        sheet_cache = {}
        img = render_ground(args.ground, sheet_cache)
        if img:
            out = OUTDIR / f"{args.ground.stem}.png"
            img.save(out)
            print(f"-> {out} ({out.stat().st_size/1024:.0f} KB, {img.size[0]}x{img.size[1]} px)")
    elif args.all:
        grounds = sorted(GROUNDDIR.glob("metano_*.rsground")) + sorted(GROUNDDIR.glob("treasure_spinda_cafe.rsground"))
        print(f"Rendering {len(grounds)} grounds...\n")
        sheet_cache = {}
        for g in grounds:
            img = render_ground(g, sheet_cache)
            if img:
                out = OUTDIR / f"{g.stem}.png"
                img.save(out)
                print(f"  {g.stem:<32} {img.size[0]:>4}x{img.size[1]:<4} px -> {out.name} ({out.stat().st_size/1024:.0f} KB)")
        print(f"\nTotal sheets loaded: {len(sheet_cache)}")
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
