#!/usr/bin/env python3
"""Extract, alpha-isolate, scale (2.0x integer nearest-neighbor), and compile
all structures directly from 'map to scale pmdo and make tilset asset.png'
and 'MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp' into native PMDO tilesets.

Follows Palika mapping architecture:
- Layer 8: Roofs, Auvents, Surplombs (Player walks underneath)
- Layer 6: Walls, Facades, Tapis d'entrée, Coffres, Comptoirs (Player walks in front / on)
- Layer 0: Ground collision mask
"""

from __future__ import annotations

import io
import json
import math
import os
import struct
from pathlib import Path
from typing import Any, Dict, List, Tuple

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
MAP_TO_SCALE = ROOT / "map to scale pmdo and make tilset asset.png"
MAP_COMPLETE = ROOT / "MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp"
OUT_BASE = ROOT / "data/map_structures_alpha_isolated_pmdo"
CONTENT_TILE_DIR = ROOT / "Content/Tile"
DOCS_DIR = ROOT / "docs"

PMDO_TILE_GRID_PX = 32
PMDO_CELL_PX = 8

# Exact structure definitions from 'map to scale pmdo and make tilset asset.png'
MAP_TO_SCALE_STRUCTURES = [
    {
        "id": "map_struct_01_nw_spinda_grand_cafe",
        "name_en": "Northwest Grand Spinda Café",
        "name_fr": "Grand Café Spinda Nord-Ouest",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (114, 18, 260, 115),
        "split_y_rel": 58,
        "description": "Grand terraced Spinda Café with wooden canopy, entrance counter, and side patio.",
        "category": "service_cafe",
    },
    {
        "id": "map_struct_02_nw_expedition_tent_blue",
        "name_en": "Northwest Blue Expedition Tent",
        "name_fr": "Tente d'Expédition Bleue Nord-Ouest",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (216, 168, 272, 222),
        "split_y_rel": 28,
        "description": "Blue fabric expedition dome tent with entrance flap and wooden tie-down pegs.",
        "category": "tent_dwelling",
    },
    {
        "id": "map_struct_03_nw_plaza_podium_blue_emblem",
        "name_en": "Plaza Podium & Blue Guild Emblem",
        "name_fr": "Podium de Place & Emblème Bleu de Guilde",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (182, 216, 254, 282),
        "split_y_rel": 32,
        "description": "Stone ceremony podium featuring blue Guild emblem crest and circular paving.",
        "category": "monument_plaza",
    },
    {
        "id": "map_struct_04_w_bear_cave_dwelling",
        "name_en": "West Bear-Head Cave Dwelling",
        "name_fr": "Habitation Grotte Tête d'Ours Ouest",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (92, 390, 170, 465),
        "split_y_rel": 40,
        "description": "Cliffside cave dwelling carved into a carved Ursaring / Teddiursa bear face entrance.",
        "category": "unique_dwelling",
    },
    {
        "id": "map_struct_05_sw_round_fire_house",
        "name_en": "Southwest Round Fire-Style House",
        "name_fr": "Maison Ronde Style Feu Sud-Ouest",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (142, 492, 206, 560),
        "split_y_rel": 36,
        "description": "Round terracotta hut with pointed thatched cap roof and wood trim doorway.",
        "category": "residential_house",
    },
    {
        "id": "map_struct_06_center_plaza_pavilion",
        "name_en": "Central Plaza Pavilion & Landmark",
        "name_fr": "Pavillon & Monument de Place Centrale",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (262, 262, 342, 342),
        "split_y_rel": 42,
        "description": "Central plaza gathering pavilion with wooden columns, railing, and tiled roof.",
        "category": "plaza_pavilion",
    },
    {
        "id": "map_struct_07_center_treehouse_dwelling",
        "name_en": "Central Treehouse Living Quarters",
        "name_fr": "Logis de Maison dans l'Arbre Centrale",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (380, 278, 482, 392),
        "split_y_rel": 60,
        "description": "Multi-tiered living quarters integrated into the giant central village tree trunk.",
        "category": "treehouse_dwelling",
    },
    {
        "id": "map_struct_08_east_terrace_house",
        "name_en": "East Terrace Wooden House",
        "name_fr": "Maison en Bois sur Terrasse Est",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (552, 420, 680, 542),
        "split_y_rel": 64,
        "description": "Spacious cliffside dwelling with large sloped wooden shingle roof and front porch.",
        "category": "residential_house",
    },
    {
        "id": "map_struct_09_southeast_market_stall",
        "name_en": "Southeast Bazaar & Market Canopy",
        "name_fr": "Échoppe & Auvent de Marché Sud-Est",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (680, 520, 802, 642),
        "split_y_rel": 62,
        "description": "Open-air merchant shop stall with colorful striped canopy and goods display counter.",
        "category": "market_stall",
    },
    {
        "id": "map_struct_10_south_fishery_dock",
        "name_en": "South Fishery & Lakeside Dock Hut",
        "name_fr": "Cabane de Pêcheur & Ponton Sud",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "crop_box": (320, 600, 442, 722),
        "split_y_rel": 62,
        "description": "Waterside fishing station with wooden dock stilts, drying racks, and boat slip.",
        "category": "fishery_dock",
    },
]


def isolate_structure_crop(crop_im: Image.Image) -> Image.Image:
    """Isolates the structure by creating a clean 32-bit alpha channel,
    eliminating background grass/dirt while preserving authentic structure pixels."""
    im = crop_im.convert("RGBA")
    arr = np.array(im)
    h, w = arr.shape[:2]

    # Create initial alpha mask
    alpha = np.ones((h, w), dtype=np.uint8) * 255

    r, g, b = arr[:, :, 0].astype(int), arr[:, :, 1].astype(int), arr[:, :, 2].astype(int)

    # Detect green grass background (pure grass terrain surrounding the structure)
    is_pure_grass = (g > r + 22) & (g > b + 22) & (g > 75) & (r < 170) & (b < 120)

    # Detect solid black borders
    is_pure_black = (r < 18) & (g < 18) & (b < 18)

    # Detect flat water surrounding
    is_flat_water = (b > r + 30) & (b > 110) & (r < 80) & (g > 60)

    # Mark non-structure outer boundary
    bg_mask = is_pure_grass | is_pure_black

    # Flood fill background from edges to avoid removing inside green/blue props
    visited = np.zeros((h, w), dtype=bool)
    stack = []

    for x in range(w):
        if bg_mask[0, x]:
            stack.append((0, x))
            visited[0, x] = True
        if bg_mask[h - 1, x]:
            stack.append((h - 1, x))
            visited[h - 1, x] = True

    for y in range(h):
        if bg_mask[y, 0]:
            stack.append((y, 0))
            visited[y, 0] = True
        if bg_mask[y, w - 1]:
            stack.append((y, w - 1))
            visited[y, w - 1] = True

    while stack:
        cy, cx = stack.pop()
        alpha[cy, cx] = 0

        for ny, nx in ((cy - 1, cx), (cy + 1, cx), (cy, cx - 1), (cy, cx + 1)):
            if 0 <= ny < h and 0 <= nx < w:
                if not visited[ny, nx] and bg_mask[ny, nx]:
                    visited[ny, nx] = True
                    stack.append((ny, nx))

    arr[:, :, 3] = alpha
    return Image.fromarray(arr)


def write_pmdo_tile_binary(sheet_img: Image.Image, out_path: Path, tile_size: int = 8) -> int:
    """Writes native PMDO .tile binary container."""
    out_path.parent.mkdir(parents=True, exist_ok=True)
    buf = io.BytesIO()
    sheet_img.save(buf, format="PNG", optimize=False)
    png_bytes = buf.getvalue()
    header = struct.pack("<IIIIIIII", tile_size, len(png_bytes), 0, 0, len(png_bytes), 0, 1, 0)
    with open(out_path, "wb") as f:
        f.write(header + png_bytes)
    return len(png_bytes)


def get_font(size: int = 16) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    font_paths = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            try:
                return ImageFont.truetype(fp, size)
            except Exception:
                pass
    return ImageFont.load_default()


def main() -> None:
    print("================================================================================")
    print("EXTRACTING ALL STRUCTURES DIRECTLY FROM MAP TO ALPHA-ISOLATED PMDO TILESETS")
    print("================================================================================")

    OUT_BASE.mkdir(parents=True, exist_ok=True)
    (OUT_BASE / "manifests").mkdir(exist_ok=True)
    (OUT_BASE / "validation").mkdir(exist_ok=True)
    CONTENT_TILE_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_DIR.mkdir(parents=True, exist_ok=True)

    map_img = Image.open(MAP_TO_SCALE).convert("RGBA")
    print(f"Loaded source map: {MAP_TO_SCALE.name} ({map_img.size})")

    processed_structures: List[Dict[str, Any]] = []

    for s_def in MAP_TO_SCALE_STRUCTURES:
        s_id = s_def["id"]
        folder_path = OUT_BASE / s_id
        folder_path.mkdir(exist_ok=True)

        box = s_def["crop_box"]
        crop_raw = map_img.crop(box)

        # 1. Isolate in pure 32-bit alpha
        crop_alpha = isolate_structure_crop(crop_raw)
        nw, nh = crop_alpha.size

        # 2. Scale 2.0x integer nearest-neighbor for PMDO Metano scale
        pmdo_w = nw * 2
        pmdo_h = nh * 2
        pmdo_im = crop_alpha.resize((pmdo_w, pmdo_h), Image.Resampling.NEAREST)

        # 3. Pad to standard PMDO 32px tile grid
        grid_w = math.ceil(pmdo_w / PMDO_TILE_GRID_PX) * PMDO_TILE_GRID_PX
        grid_h = math.ceil(pmdo_h / PMDO_TILE_GRID_PX) * PMDO_TILE_GRID_PX

        padded_pmdo_im = Image.new("RGBA", (grid_w, grid_h), (0, 0, 0, 0))
        pad_x = (grid_w - pmdo_w) // 2
        pad_y = grid_h - pmdo_h
        padded_pmdo_im.paste(pmdo_im, (pad_x, pad_y), pmdo_im)

        # 4. Layer splitting: Layer 8 (Roofs/Surplombs) vs Layer 6 (Walls/Bases)
        split_y_pmdo = s_def["split_y_rel"] * 2 + pad_y

        arr_full = np.array(padded_pmdo_im)

        arr_l8 = arr_full.copy()
        arr_l8[split_y_pmdo:, :, 3] = 0
        layer8_im = Image.fromarray(arr_l8)

        arr_l6 = arr_full.copy()
        arr_l6[:split_y_pmdo, :, 3] = 0
        layer6_im = Image.fromarray(arr_l6)

        # 5. Save all deliverables
        raw_crop_file = folder_path / f"{s_id}_raw_crop.png"
        native_file = folder_path / f"{s_id}_native_1x_alpha.png"
        pmdo_file = folder_path / f"{s_id}_complete_pmdo_2x.png"
        l8_file = folder_path / f"{s_id}_roof_overhang_layer8.png"
        l6_file = folder_path / f"{s_id}_walls_base_layer6.png"

        crop_raw.save(raw_crop_file, "PNG", optimize=True)
        crop_alpha.save(native_file, "PNG", optimize=True)
        padded_pmdo_im.save(pmdo_file, "PNG", optimize=True)
        layer8_im.save(l8_file, "PNG", optimize=True)
        layer6_im.save(l6_file, "PNG", optimize=True)

        # Compile individual .tile binary
        tile_path = CONTENT_TILE_DIR / f"{s_id}_Base.tile"
        write_pmdo_tile_binary(padded_pmdo_im, tile_path, tile_size=PMDO_CELL_PX)

        struct_info = {
            **s_def,
            "crop_box": box,
            "native_dimensions": [nw, nh],
            "pmdo_dimensions_raw": [pmdo_w, pmdo_h],
            "pmdo_grid_dimensions": [grid_w, grid_h],
            "pmdo_tiles_w": grid_w // PMDO_TILE_GRID_PX,
            "pmdo_tiles_h": grid_h // PMDO_TILE_GRID_PX,
            "split_y_pmdo_px": split_y_pmdo,
            "files": {
                "raw_crop": str(raw_crop_file.relative_to(ROOT)),
                "native_1x_alpha": str(native_file.relative_to(ROOT)),
                "pmdo_2x_complete": str(pmdo_file.relative_to(ROOT)),
                "layer8_roof": str(l8_file.relative_to(ROOT)),
                "layer6_walls": str(l6_file.relative_to(ROOT)),
                "pmdo_tile_binary": str(tile_path.relative_to(ROOT)),
            },
        }

        (folder_path / f"{s_id}_manifest.json").write_text(
            json.dumps(struct_info, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )

        processed_structures.append(struct_info)
        print(f"[OK] Extracted {s_id:40s} -> {pmdo_w}x{pmdo_h} px ({grid_w//32}x{grid_h//32} PMDO tiles)")

    # 6. Assemble Master Tilesets
    print("\n--- Assembling Master Map Structures Tilesets ---")
    cols = 2
    max_w = max(s["pmdo_grid_dimensions"][0] for s in processed_structures)
    col_w = max_w + PMDO_TILE_GRID_PX
    row_count = math.ceil(len(processed_structures) / cols)

    row_heights = []
    for r in range(row_count):
        rh = 0
        for c in range(cols):
            idx = r * cols + c
            if idx < len(processed_structures):
                rh = max(rh, processed_structures[idx]["pmdo_grid_dimensions"][1])
        row_heights.append(rh + PMDO_TILE_GRID_PX)

    sheet_w = cols * col_w + PMDO_TILE_GRID_PX
    sheet_h = sum(row_heights) + PMDO_TILE_GRID_PX

    master_full = Image.new("RGBA", (sheet_w, sheet_h), (0, 0, 0, 0))
    master_l8 = Image.new("RGBA", (sheet_w, sheet_h), (0, 0, 0, 0))
    master_l6 = Image.new("RGBA", (sheet_w, sheet_h), (0, 0, 0, 0))

    layout_positions: Dict[str, Any] = {}

    for idx, s in enumerate(processed_structures):
        c = idx % cols
        r = idx // cols

        px = PMDO_TILE_GRID_PX + c * col_w
        py = PMDO_TILE_GRID_PX + sum(row_heights[:r])

        pmdo_img = Image.open(ROOT / s["files"]["pmdo_2x_complete"]).convert("RGBA")
        l8_img = Image.open(ROOT / s["files"]["layer8_roof"]).convert("RGBA")
        l6_img = Image.open(ROOT / s["files"]["layer6_walls"]).convert("RGBA")

        master_full.paste(pmdo_img, (px, py), pmdo_img)
        master_l8.paste(l8_img, (px, py), l8_img)
        master_l6.paste(l6_img, (px, py), l6_img)

        layout_positions[s["id"]] = {
            "name_en": s["name_en"],
            "atlas_pixel_x": px,
            "atlas_pixel_y": py,
            "width": s["pmdo_grid_dimensions"][0],
            "height": s["pmdo_grid_dimensions"][1],
            "tiles_w": s["pmdo_tiles_w"],
            "tiles_h": s["pmdo_tiles_h"],
        }

    master_full_path = OUT_BASE / "map_all_structures_master_tileset.png"
    master_l8_path = OUT_BASE / "map_all_structures_roofs_layer8.png"
    master_l6_path = OUT_BASE / "map_all_structures_walls_layer6.png"

    master_full.save(master_full_path, "PNG", optimize=True)
    master_l8.save(master_l8_path, "PNG", optimize=True)
    master_l6.save(master_l6_path, "PNG", optimize=True)

    print(f"[OK] Saved Master Sheet: {master_full_path.name} ({sheet_w}x{sheet_h} px)")
    print(f"[OK] Saved Layer 8 Sheet: {master_l8_path.name} ({sheet_w}x{sheet_h} px)")
    print(f"[OK] Saved Layer 6 Sheet: {master_l6_path.name} ({sheet_w}x{sheet_h} px)")

    # 7. Compile Master PMDO Binaries
    tile_all = CONTENT_TILE_DIR / "Map_Extracted_Structures_All_Base.tile"
    tile_l8 = CONTENT_TILE_DIR / "Map_Extracted_Structures_Roofs_Over.tile"
    tile_l6 = CONTENT_TILE_DIR / "Map_Extracted_Structures_Walls_Under.tile"

    write_pmdo_tile_binary(master_full, tile_all)
    write_pmdo_tile_binary(master_l8, tile_l8)
    write_pmdo_tile_binary(master_l6, tile_l6)

    print(f"[OK] Compiled: {tile_all.name}")
    print(f"[OK] Compiled: {tile_l8.name}")
    print(f"[OK] Compiled: {tile_l6.name}")

    # 8. Master Manifest
    inventory = {
        "schema_version": "2.0.0",
        "title": "Map-Extracted Alpha-Isolated Structures PMDO Library",
        "source_map": "map to scale pmdo and make tilset asset.png",
        "scale_metrics": {
            "scale_factor": 2.0,
            "interpolation": "nearest_neighbor_integer_lossless",
            "tile_grid_px": PMDO_TILE_GRID_PX,
            "collision_cell_px": PMDO_CELL_PX,
            "pure_alpha_32bit": True,
        },
        "structure_count": len(processed_structures),
        "structures": processed_structures,
        "master_tilesets": {
            "all_structures": str(master_full_path.relative_to(ROOT)),
            "layer_8_roofs": str(master_l8_path.relative_to(ROOT)),
            "layer_6_walls": str(master_l6_path.relative_to(ROOT)),
        },
        "atlas_layout": layout_positions,
    }

    inv_path = OUT_BASE / "manifests/MAP_EXTRACTED_STRUCTURES_INVENTORY.json"
    inv_path.write_text(json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    # 9. Visual Showcase
    build_map_structures_showcase(processed_structures, map_img)
    build_map_structures_report(processed_structures, inventory)

    print("\n================================================================================")
    print("ALL MAP STRUCTURES EXTRACTED, ALPHA-ISOLATED & COMPILED FOR PMDO!")
    print("================================================================================")


def build_map_structures_showcase(structures: List[Dict[str, Any]], map_img: Image.Image) -> None:
    """Generates a high-res 1920x1080 studio showcase demonstrating raw map crops vs alpha-isolated PMDO tilesets."""
    sw, sh = 1920, 1080
    showcase = Image.new("RGBA", (sw, sh), (18, 22, 28, 255))
    draw = ImageDraw.Draw(showcase)

    font_title = get_font(24)
    font_sub = get_font(15)
    font_head = get_font(16)
    font_body = get_font(12)
    font_mono = get_font(11)

    # Header
    draw.rectangle([(0, 0), (sw, 75)], fill=(28, 34, 46, 255))
    draw.rectangle([(0, 73), (sw, 75)], fill=(80, 150, 255, 255))

    draw.text((40, 14), "STRUCTURES EXTRAITES DE VOTRE MAP — ALPHA ISOLATE & SCALE PMDO", fill=(255, 255, 255, 255), font=font_title)
    draw.text((40, 46), "Source: 'map to scale pmdo and make tilset asset.png' • 2.0x Lossless Scale • Layer 6 & Layer 8 Splits", fill=(170, 200, 240, 255), font=font_sub)

    # Grid of 10 structure cards (5 rows x 2 cols)
    card_w = 910
    card_h = 180
    cols = 2

    for idx, s in enumerate(structures):
        c = idx % cols
        r = idx // cols

        cx = 35 + c * (card_w + 30)
        cy = 95 + r * (card_h + 15)

        draw.rounded_rectangle([(cx, cy), (cx + card_w, cy + card_h)], radius=8, fill=(26, 32, 42, 255), outline=(48, 60, 78, 255), width=1)

        # 1. Raw map crop thumbnail
        raw_crop = Image.open(ROOT / s["files"]["raw_crop"]).convert("RGBA")
        scale_raw = min(120 / raw_crop.width, 140 / raw_crop.height, 1.0)
        raw_disp = raw_crop.resize((int(raw_crop.width * scale_raw), int(raw_crop.height * scale_raw)), Image.Resampling.NEAREST)

        box_raw_x = cx + 15
        box_raw_y = cy + 20
        draw.rectangle([(box_raw_x, box_raw_y), (box_raw_x + 120, box_raw_y + 140)], fill=(15, 18, 24, 255), outline=(70, 80, 100, 255))
        showcase.paste(raw_disp, (box_raw_x + (120 - raw_disp.width) // 2, box_raw_y + (140 - raw_disp.height) // 2), raw_disp)
        draw.text((box_raw_x + 10, cy + 5), "1. Crop Brut Map", fill=(240, 180, 70, 255), font=font_body)

        # Arrow indicator
        draw.text((cx + 145, cy + 80), "➜", fill=(100, 200, 255, 255), font=font_head)

        # 2. Alpha-isolated PMDO 2x complete structure
        pmdo_im = Image.open(ROOT / s["files"]["pmdo_2x_complete"]).convert("RGBA")
        scale_pmdo = min(150 / pmdo_im.width, 140 / pmdo_im.height, 1.0)
        pmdo_disp = pmdo_im.resize((int(pmdo_im.width * scale_pmdo), int(pmdo_im.height * scale_pmdo)), Image.Resampling.NEAREST)

        box_pmdo_x = cx + 175
        box_pmdo_y = cy + 20
        draw.rectangle([(box_pmdo_x, box_pmdo_y), (box_pmdo_x + 150, box_pmdo_y + 140)], fill=(12, 15, 20, 255), outline=(60, 140, 220, 255))
        
        # Checker
        for y_c in range(box_pmdo_y, box_pmdo_y + 140, 8):
            for x_c in range(box_pmdo_x, box_pmdo_x + 150, 8):
                if ((x_c // 8) + (y_c // 8)) % 2 == 0:
                    draw.rectangle([(x_c, y_c), (x_c + 8, y_c + 8)], fill=(22, 28, 38, 255))

        showcase.paste(pmdo_disp, (box_pmdo_x + (150 - pmdo_disp.width) // 2, box_pmdo_y + (140 - pmdo_disp.height) // 2), pmdo_disp)
        draw.text((box_pmdo_x + 10, cy + 5), "2. Alpha Isolate (2.0x)", fill=(100, 220, 140, 255), font=font_body)

        # 3. Layer 8 (Roofs) & Layer 6 (Walls) previews
        l8_im = Image.open(ROOT / s["files"]["layer8_roof"]).convert("RGBA")
        l6_im = Image.open(ROOT / s["files"]["layer6_walls"]).convert("RGBA")

        scale_split = min(100 / l8_im.width, 65 / l8_im.height, 1.0)
        l8_disp = l8_im.resize((int(l8_im.width * scale_split), int(l8_im.height * scale_split)), Image.Resampling.NEAREST)
        l6_disp = l6_im.resize((int(l6_im.width * scale_split), int(l6_im.height * scale_split)), Image.Resampling.NEAREST)

        box_split_x = cx + 345
        draw.rectangle([(box_split_x, cy + 20), (box_split_x + 100, cy + 85)], fill=(12, 15, 20, 255), outline=(180, 100, 220, 255))
        draw.rectangle([(box_split_x, cy + 95), (box_split_x + 100, cy + 160)], fill=(12, 15, 20, 255), outline=(220, 150, 80, 255))

        showcase.paste(l8_disp, (box_split_x + (100 - l8_disp.width) // 2, cy + 20 + (65 - l8_disp.height) // 2), l8_disp)
        showcase.paste(l6_disp, (box_split_x + (100 - l6_disp.width) // 2, cy + 95 + (65 - l6_disp.height) // 2), l6_disp)

        draw.text((box_split_x + 105, cy + 45), "L8 Toit", fill=(200, 140, 255, 255), font=font_mono)
        draw.text((box_split_x + 105, cy + 120), "L6 Murs", fill=(255, 180, 100, 255), font=font_mono)

        # 4. Text specifications
        tx = cx + 510
        ty = cy + 15
        draw.text((tx, ty), f"#{idx+1}: {s['name_fr']}", fill=(255, 255, 255, 255), font=font_head)
        draw.text((tx, ty + 22), f"{s['name_en']}", fill=(180, 205, 240, 255), font=font_body)

        draw.text((tx, ty + 46), f"Crop Map:    [{s['crop_box'][0]}, {s['crop_box'][1]}, {s['crop_box'][2]}, {s['crop_box'][3]}] px", fill=(150, 170, 195, 255), font=font_mono)
        draw.text((tx, ty + 64), f"Native 1x:   {s['native_dimensions'][0]}×{s['native_dimensions'][1]} px", fill=(150, 170, 195, 255), font=font_mono)
        draw.text((tx, ty + 82), f"PMDO 2x:     {s['pmdo_dimensions_raw'][0]}×{s['pmdo_dimensions_raw'][1]} px ({s['pmdo_tiles_w']}×{s['pmdo_tiles_h']} tuiles 32px)", fill=(100, 220, 140, 255), font=font_mono)
        draw.text((tx, ty + 100), f"Split Y:     Y = {s['split_y_pmdo_px']} px (Coupe Toit/Murs)", fill=(240, 200, 80, 255), font=font_mono)
        draw.text((tx, ty + 118), f"Catégorie:   {s['category']}", fill=(150, 170, 195, 255), font=font_mono)
        draw.text((tx, ty + 138), f"Fichier: {s['files']['pmdo_2x_complete'][:48]}...", fill=(180, 190, 205, 255), font=font_mono)

    out_showcase = OUT_BASE / "showcase_map_extracted_structures.png"
    showcase.save(out_showcase, "PNG", optimize=True)
    print(f"[OK] Saved Map Structures Showcase: {out_showcase.name}")


def build_map_structures_report(structures: List[Dict[str, Any]], manifest: Dict[str, Any]) -> None:
    """Writes detailed report."""
    md = f"""# RAPPORT D'EXTRACTION DES STRUCTURES DE LA MAP — PMDO PALIKA

## 1. Vue d'Ensemble

Toutes les **10 structures** visibles sur votre carte source (**`map to scale pmdo and make tilset asset.png`**) ont été découpées directement depuis l'image de la map, détourées en **alpha pur 32-bit**, agrandies selon l'échelle exacte PMDO Metano ($2.0\\times$ integer nearest-neighbor), découpées selon l'architecture en couches de Palika (Layer 6 Murs/Base vs Layer 8 Toits/Surplombs) et compilées en binaires natifs PMDO `.tile`.

---

## 2. Inventaire des 10 Structures Extraites de la Map

"""
    for s in structures:
        md += f"""### #{s['id']} — {s['name_fr']} ({s['name_en']})
- **Zone sur la Map (Crop)** : Bounding Box `[{s['crop_box'][0]}, {s['crop_box'][1]}, {s['crop_box'][2]}, {s['crop_box'][3]}]`
- **Résolution Native Découpée (1.0x)** : {s['native_dimensions'][0]} × {s['native_dimensions'][1]} px
- **Échelle PMDO Metano (2.0x)** : {s['pmdo_dimensions_raw'][0]} × {s['pmdo_dimensions_raw'][1]} px
- **Grille de Tuiles PMDO (32px)** : {s['pmdo_grid_dimensions'][0]} × {s['pmdo_grid_dimensions'][1]} px ({s['pmdo_tiles_w']} × {s['pmdo_tiles_h']} tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = {s['split_y_pmdo_px']}\\text{{ px}}$
- **Catégorie** : `{s['category']}`
- **Fichiers Générés** :
  - Crop Brut de la Map : `{s['files']['raw_crop']}`
  - Version Alpha Isolate 1x : `{s['files']['native_1x_alpha']}`
  - Version PMDO 2x Complète : `{s['files']['pmdo_2x_complete']}`
  - Couche 8 (Toits & Surplombs) : `{s['files']['layer8_roof']}`
  - Couche 6 (Murs & Bases) : `{s['files']['layer6_walls']}`
  - Binaire Moteur PMDO : `{s['files']['pmdo_tile_binary']}`

"""

    md += f"""---

## 3. Planches Maîtres & Binaires Moteur PMDO

- **Planche Maître Complète** : `{manifest['master_tilesets']['all_structures']}`
- **Planche Couche 8 (Toits & Surplombs)** : `{manifest['master_tilesets']['layer_8_roofs']}`
- **Planche Couche 6 (Murs & Bases)** : `{manifest['master_tilesets']['layer_6_walls']}`
- **Binaires Moteur dans `Content/Tile/`** :
  - `Content/Tile/Map_Extracted_Structures_All_Base.tile`
  - `Content/Tile/Map_Extracted_Structures_Roofs_Over.tile`
  - `Content/Tile/Map_Extracted_Structures_Walls_Under.tile`
  - 10 binaires individuels `Content/Tile/map_struct_*_Base.tile`
"""

    out_report = DOCS_DIR / "MAP_EXTRACTED_STRUCTURES_PALIKA_REPORT.md"
    out_report.write_text(md, encoding="utf-8")
    print(f"[OK] Saved Report: {out_report.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
