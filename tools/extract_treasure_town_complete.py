#!/usr/bin/env python3
"""
Comprehensive Treasure Town (Bourg-Trésor) PMDO Editor Asset Package Generator.
Extracts, isolates, categorizes and exports all signs, shops, props, vegetation,
animated objects frame-by-frame, and PMDO tilesets in pure alpha-isolated RGBA.
"""

from __future__ import annotations

import io
import json
import math
import shutil
import struct
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw


def extract_dir_frames(p: Path) -> List[Image.Image]:
    """Extract individual frame images from PMDO .dir format."""
    data = p.read_bytes()
    png_magic = b"\x89PNG\r\n\x1a\n"
    if png_magic not in data:
        return []
    idx = data.find(png_magic)
    iend = data.find(b"IEND\xaeB`\x82", idx)
    if iend == -1:
        return []
    png_bytes = data[idx:iend+8]
    trailing = data[iend+8:]
    im = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
    tw, th = im.size
    fw, fh = tw, th
    if len(trailing) >= 8:
        w_val, h_val = struct.unpack("<ii", trailing[:8])
        if w_val > 0 and h_val > 0 and w_val <= tw and h_val <= th:
            fw, fh = w_val, h_val
    cols = tw // fw
    rows = th // fh
    frames = []
    for r in range(rows):
        for c in range(cols):
            x = c * fw
            y = r * fh
            frame = im.crop((x, y, x + fw, y + fh))
            frames.append(frame)
    return frames


def decode_pmdo_archive_tiles(path: Path) -> List[Tuple[int, Image.Image]]:
    """Decode all PNG tiles from a PMDO .tile archive."""
    data = path.read_bytes()
    tiles = []
    pos = 0
    idx = 0
    while True:
        png_start = data.find(b"\x89PNG\r\n\x1a\n", pos)
        if png_start == -1:
            break
        iend = data.find(b"IEND\xaeB`\x82", png_start)
        if iend == -1:
            break
        png_end = iend + 8
        png_bytes = data[png_start:png_end]
        try:
            img = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
            tiles.append((idx, img))
            idx += 1
        except Exception:
            pass
        pos = png_end
    return tiles


def assemble_tileset_atlas(
    tiles: List[Image.Image],
    tile_w: int,
    tile_h: int,
    cols: int = 16
) -> Tuple[Image.Image, List[dict]]:
    """Assemble a tileset atlas with exact grid alignment for PMDO Editor."""
    count = len(tiles)
    rows = math.ceil(count / cols) if count > 0 else 1
    atlas = Image.new("RGBA", (cols * tile_w, rows * tile_h), (0, 0, 0, 0))
    metadata = []
    for i, t in enumerate(tiles):
        c = i % cols
        r = i // cols
        x = c * tile_w
        y = r * tile_h
        atlas.paste(t, (x, y), t)
        metadata.append({
            "index": i,
            "grid_col": c,
            "grid_row": r,
            "atlas_x": x,
            "atlas_y": y,
            "width": t.width,
            "height": t.height
        })
    return atlas, metadata


def build_pmdo_tile_binary(images: List[Image.Image], tile_w: int, tile_h: int) -> bytes:
    """Build a PMDO compliant .tile binary file."""
    buf = io.BytesIO()
    for img in images:
        png_buf = io.BytesIO()
        img.save(png_buf, format="PNG")
        buf.write(png_buf.getvalue())
    # Footer metadata (int32 tile_w, int32 tile_h, int32 count)
    footer = struct.pack("<iii", tile_w, tile_h, len(images))
    buf.write(footer)
    return buf.getvalue()


def main() -> None:
    root = Path("data/treasure_town_editor_assets")
    root.mkdir(parents=True, exist_ok=True)

    objects_dir = root / "objects"
    signs_dir = objects_dir / "signs"
    shops_dir = objects_dir / "shops_and_stands"
    tents_dir = objects_dir / "tents_and_houses"
    props_dir = objects_dir / "furnishing_and_props"
    veg_dir = objects_dir / "vegetation_and_nature"

    for d in [signs_dir, shops_dir, tents_dir, props_dir, veg_dir]:
        d.mkdir(parents=True, exist_ok=True)

    anim_dir = root / "animated_objects_frames"
    anim_dir.mkdir(parents=True, exist_ok=True)

    tilesets_dir = root / "tilesets_pmdo_editor"
    tilesets_dir.mkdir(parents=True, exist_ok=True)

    manifest = {
        "version": "1.0.0",
        "title": "Treasure Town (Bourg-Trésor) PMDO Editor Complete Asset Library",
        "target_engine": "PMDO (Pokémon Mystery Dungeon Origins) / PMDO Map Editor",
        "objects": {},
        "animated_objects": {},
        "tilesets": {},
        "total_assets": 0
    }

    # 1. SIGNS & MISSION BOARDS
    print("=== Exporting Signs & Boards ===")
    sign_sources = {
        "sign_crossroads_classic": "docs/pmdo_isolated_structures/market_components/Sign_Crossroads.png",
        "sign_wooden_simple": "docs/pmdo_isolated_structures/market_components/Sign.png",
        "mission_board_guild": "docs/pmdo_isolated_structures/market_components/Mission_Board.png",
    }
    for key, src in sign_sources.items():
        src_path = Path(src)
        if src_path.exists():
            dst = signs_dir / f"{key}.png"
            shutil.copy(src_path, dst)
            im = Image.open(dst)
            manifest["objects"][key] = {
                "category": "signs",
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Panneau / Tableau {key.replace('_', ' ').title()}"
            }

    # 2. SHOPS & MARKET STANDS
    print("=== Exporting Shops & Market Stands ===")
    shop_sources = {
        "kecleon_shop_green_day": "docs/metano_origins_structure_library/buildings/metano_kecleon_shop_day.png",
        "kecleon_shop_purple_night": "docs/metano_origins_structure_library/buildings/metano_kecleon_shop_night.png",
        "spinda_cafe_day": "docs/metano_origins_structure_library/buildings/metano_cafe_day.png",
        "spinda_cafe_night": "docs/metano_origins_structure_library/buildings/metano_cafe_night.png",
        "merchant_stand_wood": "docs/pmd_structure_library/buildings/merchant_stand_01.png",
        "merchant_counter_low": "docs/pmd_structure_library/buildings/merchant_counter_01.png",
        "kangaskhan_storage_chest": "docs/pmdo_isolated_structures/market_components/Storage.png",
        "berry_basket_red": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Red.png",
        "berry_basket_blue": "docs/pmdo_isolated_structures/market_components/Berry_Basket_Blue.png",
        "terracotta_pot": "docs/pmdo_isolated_structures/market_components/Pot.png",
        "wooden_fence": "docs/pmdo_isolated_structures/market_components/Fence.png",
        "stump_table": "docs/pmdo_isolated_structures/market_components/Stump_Table.png",
        "stump_chair": "docs/pmdo_isolated_structures/market_components/Stump_Chair.png",
    }
    for key, src in shop_sources.items():
        src_path = Path(src)
        if src_path.exists():
            target_sub = shops_dir if any(w in key for w in ["shop", "stand", "cafe", "counter"]) else props_dir
            dst = target_sub / f"{key}.png"
            shutil.copy(src_path, dst)
            im = Image.open(dst)
            manifest["objects"][key] = {
                "category": "shops_or_props",
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Élément {key.replace('_', ' ').title()}"
            }

    # 3. TENTS & HOUSES
    print("=== Exporting Tents & Houses ===")
    tent_sources = {
        "tent_expedition_blue": "docs/pmd_structure_library/buildings/tent_01.png",
        "tent_expedition_plain": "docs/pmd_structure_library/buildings/tent_02.png",
        "beach_tent_coastal": "docs/waves_nostalgia_structures/overw4/beach_tent_01.png",
        "house_town_normal": "docs/pmd_structure_library/buildings/house_01.png",
        "house_leaf_hut_1": "docs/waves_nostalgia_structures/overw1/house_leaf_01.png",
        "house_leaf_hut_2": "docs/waves_nostalgia_structures/overw1/house_leaf_02.png",
        "shop_grand_bazaar": "docs/waves_nostalgia_structures/overw1/shop_01.png",
        "metano_house_fire": "docs/metano_origins_structure_library/buildings/metano_house_fire_day.png",
        "metano_house_rock": "docs/metano_origins_structure_library/buildings/metano_house_rock_day.png",
        "metano_house_normal": "docs/metano_origins_structure_library/buildings/metano_house_normal_day.png",
    }
    for key, src in tent_sources.items():
        src_path = Path(src)
        if src_path.exists():
            dst = tents_dir / f"{key}.png"
            shutil.copy(src_path, dst)
            im = Image.open(dst)
            manifest["objects"][key] = {
                "category": "tents_and_houses",
                "file": str(dst.relative_to(root)),
                "dimensions": [im.width, im.height],
                "frames": 1,
                "description": f"Bâtiment / Tente {key.replace('_', ' ').title()}"
            }

    # 4. PROPS & VEGETATION
    print("=== Exporting Environment Props & Nature ===")
    content_objects = [
        ("kangaskhan_rock_statue", "Content/Object/Kangaskhan_Rock.dir", props_dir),
        ("closed_guild_door", "Content/Object/Closed_Guild_Door.dir", props_dir),
        ("night_window", "Content/Object/Night_Window.dir", props_dir),
        ("hay_bed", "Content/Object/Hay_Bed.dir", props_dir),
        ("grassy_bag", "Content/Object/Grassy_Bag.dir", props_dir),
        ("river_stone_round", "Content/Object/River_Stone_Round.dir", props_dir),
        ("river_stone_diamond", "Content/Object/River_Stone_Diamond.dir", props_dir),
        ("food_basket", "Content/Object/Food_Big.dir", props_dir),
        ("tablette_zarbi", "Content/Object/Tablette_Zarbi.dir", props_dir),
        ("tree_town", "Content/Object/Tree_Town.dir", veg_dir),
        ("hedge_town", "Content/Object/Hedge.dir", veg_dir),
        ("flowerpot_pink", "Content/Object/Flowerpot_Pink.dir", veg_dir),
        ("flowerpot_white", "Content/Object/Flowerpot_White.dir", veg_dir),
        ("flowers_town_1", "Content/Object/Flowers_Town_1.dir", veg_dir),
        ("flowers_town_2", "Content/Object/Flowers_Town_2.dir", veg_dir),
        ("flowers_town_3", "Content/Object/Flowers_Town_3.dir", veg_dir),
        ("flowers_town_4", "Content/Object/Flowers_Town_4.dir", veg_dir),
        ("flowers_town_5", "Content/Object/Flowers_Town_5.dir", veg_dir),
        ("flowers_tropical_1", "Content/Object/Flowers_Tropical_1.dir", veg_dir),
        ("flowers_tropical_2", "Content/Object/Flowers_Tropical_2.dir", veg_dir),
        ("flowers_tropical_3", "Content/Object/Flowers_Tropical_3.dir", veg_dir),
        ("flowers_tropical_4", "Content/Object/Flowers_Tropical_4.dir", veg_dir),
        ("flowers_tropical_5", "Content/Object/Flowers_Tropical_5.dir", veg_dir),
        ("logs_large", "Content/Object/Logs_Large.dir", veg_dir),
        ("logs_small", "Content/Object/Logs_Small.dir", veg_dir),
        ("logs_stacked", "Content/Object/Logs_Stacked.dir", veg_dir),
        ("trunk_large", "Content/Object/Trunk_Large.dir", veg_dir),
        ("trunk_small", "Content/Object/Trunk_Small.dir", veg_dir),
        ("apricorn_big", "Content/Object/Apricorn_Big.dir", veg_dir),
    ]

    for key, src, dest_folder in content_objects:
        p = Path(src)
        if p.exists():
            frames = extract_dir_frames(p)
            if frames:
                dst = dest_folder / f"{key}.png"
                frames[0].save(dst, "PNG")
                manifest["objects"][key] = {
                    "category": "vegetation_or_props",
                    "file": str(dst.relative_to(root)),
                    "dimensions": [frames[0].width, frames[0].height],
                    "frames": len(frames),
                    "description": f"Élément {key.replace('_', ' ').title()}"
                }

    # 5. ANIMATED OBJECTS & FRAMES
    print("=== Exporting Animated Objects Frame-by-Frame ===")
    anim_sources = {
        "origins_windmill": [
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_0.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_1.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_2.png",
            "docs/metano_origins_structure_library/buildings/origins_windmill_frame_3.png"
        ],
        "origins_well": [
            "docs/metano_origins_structure_library/buildings/origins_well_frame_0.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_1.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_2.png",
            "docs/metano_origins_structure_library/buildings/origins_well_frame_3.png"
        ],
        "campfire": "Content/Object/Campfire.dir",
        "yellow_box": "Content/Object/Yellow_Box.dir",
        "diary_blue_opening": "Content/Object/Diary_Blue_Opening.dir",
        "diary_blue_closing": "Content/Object/Diary_Blue_Closing.dir",
        "diary_red_opening": "Content/Object/Diary_Red_Opening.dir",
        "diary_red_closing": "Content/Object/Diary_Red_Closing.dir",
    }

    for key, src in anim_sources.items():
        target_dir = anim_dir / key
        target_dir.mkdir(parents=True, exist_ok=True)
        frame_imgs = []

        if isinstance(src, list):
            for i, sf in enumerate(src):
                p = Path(sf)
                if p.exists():
                    dst_f = target_dir / f"frame_{i}.png"
                    shutil.copy(p, dst_f)
                    frame_imgs.append(Image.open(dst_f))
        else:
            p = Path(src)
            if p.exists():
                extracted = extract_dir_frames(p)
                for i, fr in enumerate(extracted):
                    dst_f = target_dir / f"frame_{i}.png"
                    fr.save(dst_f, "PNG")
                    frame_imgs.append(fr)
                shutil.copy(p, target_dir / p.name)

        if frame_imgs:
            strip_w = frame_imgs[0].width * len(frame_imgs)
            strip_h = frame_imgs[0].height
            strip = Image.new("RGBA", (strip_w, strip_h), (0, 0, 0, 0))
            for i, fr in enumerate(frame_imgs):
                strip.paste(fr, (i * frame_imgs[0].width, 0), fr)
            strip_path = target_dir / f"{key}_animation_strip.png"
            strip.save(strip_path, "PNG")

            manifest["animated_objects"][key] = {
                "folder": str(target_dir.relative_to(root)),
                "frame_count": len(frame_imgs),
                "frame_size": [frame_imgs[0].width, frame_imgs[0].height],
                "strip_file": str(strip_path.relative_to(root)),
                "frames": [f"frame_{i}.png" for i in range(len(frame_imgs))]
            }
            print(f"  -> Animated object [{key}]: {len(frame_imgs)} frames ({frame_imgs[0].size})")

    # 6. TILESETS FOR PMDO EDITOR
    print("=== Generating PMDO Editor Tilesets ===")
    tt_tile_files = [
        ("treasure_town_west", "Content/Tile/TreasureTownWest.tile", 24, 24),
        ("treasure_town_east", "Content/Tile/TreasureTownEast.tile", 24, 24),
        ("treasure_town_t00p01", "Content/Tile/T00p01_Base.tile", 8, 8),
        ("treasure_town_t00p02", "Content/Tile/T00p02_Base.tile", 8, 8),
        ("treasure_town_t00p03", "Content/Tile/T00p03_Base.tile", 8, 8),
        ("treasure_town_crossroads_sign", "Content/Tile/crossroads sign.tile", 8, 8),
        ("treasure_town_spinda_cafe_props", "Content/Tile/SpindaCafe2.tile", 8, 8),
    ]

    for slug, tile_path_str, tw, th in tt_tile_files:
        p = Path(tile_path_str)
        if not p.exists():
            continue
        raw_tiles = decode_pmdo_archive_tiles(p)
        if not raw_tiles:
            continue

        images = [img for _, img in raw_tiles]
        cols = 16 if tw >= 24 else 32
        atlas_img, meta = assemble_tileset_atlas(images, tw, th, cols=cols)

        atlas_png_path = tilesets_dir / f"{slug}_atlas.png"
        atlas_img.save(atlas_png_path, "PNG")

        pmdo_tile_path = tilesets_dir / f"{slug}.tile"
        pmdo_bin = build_pmdo_tile_binary(images, tw, th)
        pmdo_tile_path.write_bytes(pmdo_bin)

        manifest["tilesets"][slug] = {
            "atlas_png": str(atlas_png_path.relative_to(root)),
            "pmdo_tile": str(pmdo_tile_path.relative_to(root)),
            "tile_count": len(images),
            "tile_dimensions": [tw, th],
            "atlas_dimensions": [atlas_img.width, atlas_img.height],
            "grid_columns": cols,
            "grid_rows": math.ceil(len(images) / cols)
        }
        print(f"  -> Tileset [{slug}]: {len(images)} tiles -> {atlas_png_path.name} & {pmdo_tile_path.name}")

    # Total assets count
    manifest["total_assets"] = len(manifest["objects"]) + len(manifest["animated_objects"]) + len(manifest["tilesets"])

    # Write Manifest JSON
    manifest_p = root / "manifest.json"
    manifest_p.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"\nWrote manifest: {manifest_p} ({len(manifest_p.read_bytes())} bytes)")

    # Generate Visual Contact Sheet
    print("Building visual contact sheet for Treasure Town editor assets...")
    contact_w = 1100
    contact_h = 750
    contact = Image.new("RGBA", (contact_w, contact_h), (22, 26, 34, 255))
    draw = ImageDraw.Draw(contact)

    # Title Banner
    draw.rectangle([(0, 0), (contact_w, 50)], fill=(34, 42, 58, 255))

    items_to_show = [
        (signs_dir / "sign_crossroads_classic.png", (40, 70)),
        (signs_dir / "mission_board_guild.png", (120, 60)),
        (shops_dir / "kecleon_shop_green_day.png", (220, 60)),
        (props_dir / "kangaskhan_storage_chest.png", (380, 70)),
        (tents_dir / "tent_expedition_blue.png", (450, 60)),
        (tents_dir / "house_town_normal.png", (570, 60)),
        (shops_dir / "spinda_cafe_day.png", (40, 220)),
        (tilesets_dir / "treasure_town_west_atlas.png", (350, 220)),
        (tilesets_dir / "treasure_town_crossroads_sign_atlas.png", (780, 220)),
    ]

    for item_p, pos in items_to_show:
        if item_p.exists():
            try:
                im = Image.open(item_p)
                if im.width > 380 or im.height > 260:
                    im.thumbnail((360, 240), Image.NEAREST)
                draw.rectangle([(pos[0] - 2, pos[1] - 2), (pos[0] + im.width + 1, pos[1] + im.height + 1)], outline=(60, 70, 90, 255))
                contact.paste(im, pos, im)
            except Exception:
                pass

    contact_path = root / "treasure_town_assets_showcase.png"
    contact.save(contact_path, "PNG")
    print(f"Saved contact sheet: {contact_path}")


if __name__ == "__main__":
    main()
