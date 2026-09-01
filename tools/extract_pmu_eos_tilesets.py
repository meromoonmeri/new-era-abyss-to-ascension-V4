#!/usr/bin/env python3
"""
Comprehensive PMU and PMD Explorers of Sky (EoS) Alpha-Isolated Tileset Extractor and Cataloguer.
Extracts, isolates, categorizes, and generates transparent atlases and manifests for all PMU/EoS tiles.
"""

from __future__ import annotations

import io
import json
import math
import struct
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw


@dataclass
class TileMeta:
    source_archive: str
    tile_index: int
    dimensions: Tuple[int, int]
    alpha_bbox: Optional[Tuple[int, int, int, int]]
    opaque_pixels: int
    total_pixels: int
    alpha_density: float
    is_pure_alpha_isolated: bool
    category: str
    atlas_name: str
    atlas_grid_col: int
    atlas_grid_row: int
    atlas_pixel_x: int
    atlas_pixel_y: int


def decode_pmu_archive(path: Path) -> List[Tuple[int, Image.Image]]:
    """Decode all tiles from a PMU .tile archive."""
    tiles = []
    with path.open("rb") as stream:
        header = stream.read(8)
        if len(header) < 8:
            return tiles
        w, h = struct.unpack("<ii", header)
        tile_count = (w // 32) * (h // 32)
        entries = []
        for _ in range(tile_count):
            raw = stream.read(12)
            if len(raw) < 12:
                break
            rel_offset, size = struct.unpack("<qi", raw)
            entries.append((rel_offset, size))
        header_size = stream.tell()

        for idx, (offset, size) in enumerate(entries):
            if size > 0:
                stream.seek(header_size + offset)
                data = stream.read(size)
                try:
                    img = Image.open(io.BytesIO(data)).convert("RGBA")
                    tiles.append((idx, img))
                except Exception:
                    continue
    return tiles


def decode_pmdo_archive(path: Path) -> List[Tuple[int, Image.Image]]:
    """Decode all embedded PNG tiles from a PMDO / EoS .tile archive."""
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


def categorize_tile(archive_name: str, tile_idx: int, img: Image.Image, bbox: Tuple[int, int, int, int], density: float) -> str:
    """Classify tile into semantic functional categories."""
    w, h = img.size
    if bbox is None or density == 0:
        return "empty"
    if density >= 0.98:
        return "solid_terrain"

    # Analyze color profile of non-transparent pixels
    pixels = img.load()
    green_count = 0
    brown_count = 0
    blue_count = 0
    red_count = 0
    total_non_transparent = 0

    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a > 32:
                total_non_transparent += 1
                if g > r + 15 and g > b + 15:
                    green_count += 1
                elif r > g + 20 and r > b + 20:
                    red_count += 1
                elif b > r + 15 and b > g + 15:
                    blue_count += 1
                elif r > 80 and g > 50 and b < 60 and r >= g:
                    brown_count += 1

    if total_non_transparent > 0:
        if green_count / total_non_transparent > 0.35:
            return "vegetation_and_foliage"
        if blue_count / total_non_transparent > 0.40:
            return "water_and_ice"
        if brown_count / total_non_transparent > 0.40:
            return "wood_structures_and_earth"
        if red_count / total_non_transparent > 0.35:
            return "fire_and_red_decor"

    if density < 0.35:
        return "small_props_and_decor"
    elif density < 0.75:
        return "architectural_and_furniture"
    else:
        return "terrain_transition_edges"


def assemble_atlas(
    tiles: List[Tuple[int, Image.Image, dict]],
    tile_w: int,
    tile_h: int,
    cols: int = 32,
    padding: int = 0,
    background: Tuple[int, int, int, int] = (0, 0, 0, 0)
) -> Tuple[Image.Image, List[dict]]:
    """Assemble a list of tiles into a transparent RGBA atlas."""
    if not tiles:
        return Image.new("RGBA", (1, 1), background), []

    count = len(tiles)
    rows = math.ceil(count / cols)
    atlas_w = cols * (tile_w + padding)
    atlas_h = rows * (tile_h + padding)

    atlas = Image.new("RGBA", (atlas_w, atlas_h), background)
    meta_list = []

    for i, (idx, img, extra) in enumerate(tiles):
        c = i % cols
        r = i // cols
        px = c * (tile_w + padding)
        py = r * (tile_h + padding)

        atlas.paste(img, (px, py), img)

        meta = {
            "tile_index": idx,
            "grid_col": c,
            "grid_row": r,
            "atlas_x": px,
            "atlas_y": py,
            "width": img.width,
            "height": img.height,
            **extra
        }
        meta_list.append(meta)

    return atlas, meta_list


def main() -> None:
    base_out = Path("data/tilesets_alpha_isolated")
    base_out.mkdir(parents=True, exist_ok=True)
    sheets_out = base_out / "sheets"
    sheets_out.mkdir(exist_ok=True)
    cats_out = base_out / "categories"
    cats_out.mkdir(exist_ok=True)
    docs_out = Path("docs/pmu_eos_tilesets")
    docs_out.mkdir(parents=True, exist_ok=True)

    print("=== 1. Extracting PMU Tile Archives (Tiles0 -> Tiles10) ===")
    pmu_dir = Path(".runtime-cache/pmu/PMU-Client/resources/GFX/Tiles")

    global_manifest = {
        "version": "1.0.0",
        "title": "PMU and PMD Explorers of Sky Alpha-Isolated Tileset Master Library",
        "pmu_archives": {},
        "eos_biomes": {},
        "category_summary": {},
        "total_isolated_alpha_tiles": 0,
        "total_processed_tiles": 0
    }

    all_categorized_tiles: Dict[str, List[Tuple[int, Image.Image, dict]]] = {}
    total_alpha_count = 0
    total_tiles_processed = 0

    if pmu_dir.exists():
        for archive_path in sorted(pmu_dir.glob("Tiles*.tile"), key=lambda x: int(x.stem.replace("Tiles", ""))):
            arch_name = archive_path.stem
            print(f"Processing PMU {arch_name}...")
            raw_tiles = decode_pmu_archive(archive_path)

            alpha_tiles = []
            for idx, img in raw_tiles:
                total_tiles_processed += 1
                alpha_chan = img.split()[-1]
                extrema = alpha_chan.getextrema()
                bbox = img.getbbox()

                if extrema == (0, 0) or bbox is None:
                    continue

                opaque_pixels = sum(1 for y in range(img.height) for x in range(img.width) if img.getpixel((x, y))[3] > 16)
                tot_pixels = img.width * img.height
                density = opaque_pixels / tot_pixels if tot_pixels > 0 else 0
                is_alpha_isolated = extrema[0] < 255

                cat = categorize_tile(arch_name, idx, img, bbox, density)

                extra = {
                    "source_archive": arch_name,
                    "alpha_bbox": bbox,
                    "opaque_pixels": opaque_pixels,
                    "density": round(density, 4),
                    "is_alpha_isolated": is_alpha_isolated,
                    "category": cat
                }

                if is_alpha_isolated:
                    alpha_tiles.append((idx, img, extra))
                    all_categorized_tiles.setdefault(cat, []).append((idx, img, extra))
                    total_alpha_count += 1

            cols = 32
            atlas_img, atlas_meta = assemble_atlas(alpha_tiles, 32, 32, cols=cols)
            atlas_filename = f"pmu_{arch_name.lower()}_alpha_atlas.png"
            atlas_path = sheets_out / atlas_filename
            atlas_img.save(atlas_path, "PNG", optimize=True)

            global_manifest["pmu_archives"][arch_name] = {
                "file": str(atlas_path.relative_to(base_out)),
                "dimensions": [atlas_img.width, atlas_img.height],
                "alpha_tile_count": len(alpha_tiles),
                "grid_columns": cols,
                "grid_rows": math.ceil(len(alpha_tiles) / cols) if alpha_tiles else 0,
                "tiles_sample": atlas_meta[:20]
            }
            print(f"  -> Generated {atlas_filename} ({len(alpha_tiles)} alpha tiles, {atlas_img.size})")

    print("\n=== 2. Extracting Canonical PMD Explorers of Sky / PMDO Biomes ===")
    eos_biomes_to_extract = [
        "TreasureTownEast.tile",
        "TreasureTownWest.tile",
        "SpindaCafe1.tile",
        "SpindaCafe2.tile",
        "HotSpring1.tile",
        "HotSpringDetail.tile",
        "DuskBeach.tile",
        "BeachCavePit.tile",
        "Aegis Cave Entrance Layer 1.tile",
        "Aegis Cave Entrance Layer 2.tile",
        "Apple Woods Entrance Layer 1.tile",
        "Apple Woods End Layer 1.tile",
        "Foggy Forest Entrance Layer 1.tile",
        "Steam Cave Entrance Layer 1.tile",
        "Crystal Cave Entrance Layer 1.tile",
        "Dark Crater Entrance Layer 1.tile",
        "Temporal Spire Red Sky Base.tile",
        "Northern Desert Entrance Layer 1.tile",
        "Brine Cave Entrance.tile",
        "Dusk Forest Entrance Layer 1.tile",
        "Deep Dusk Forest Entrance Layer 1.tile",
        "Altere_Pond_Objects.tile",
        "Altere_Pond_Cliffs.tile",
        "Altere_Pond_Fringe.tile",
        "Apricorn_Glade_Big_Tree.tile",
        "Apricorn_Glade_Objects.tile",
        "Apricorn Grove Green.tile",
        "FA_Furnace_Desert_RTRB.tile"
    ]

    for biome_name in eos_biomes_to_extract:
        p = Path(f"Content/Tile/{biome_name}")
        if not p.exists():
            matches = list(Path("Content/Tile").glob(f"*{biome_name.split('.')[0]}*"))
            if matches:
                p = matches[0]
            else:
                continue

        raw_tiles = decode_pmdo_archive(p)
        if not raw_tiles:
            continue

        tile_w, tile_h = raw_tiles[0][1].size
        alpha_tiles = []

        for idx, img in raw_tiles:
            total_tiles_processed += 1
            alpha_chan = img.split()[-1]
            extrema = alpha_chan.getextrema()
            bbox = img.getbbox()

            if extrema == (0, 0) or bbox is None:
                continue

            opaque_pixels = sum(1 for y in range(img.height) for x in range(img.width) if img.getpixel((x, y))[3] > 16)
            tot_pixels = img.width * img.height
            density = opaque_pixels / tot_pixels if tot_pixels > 0 else 0
            is_alpha_isolated = extrema[0] < 255

            cat = categorize_tile(p.stem, idx, img, bbox, density)

            extra = {
                "source_archive": p.name,
                "alpha_bbox": bbox,
                "opaque_pixels": opaque_pixels,
                "density": round(density, 4),
                "is_alpha_isolated": is_alpha_isolated,
                "category": cat
            }

            if is_alpha_isolated:
                alpha_tiles.append((idx, img, extra))
                all_categorized_tiles.setdefault(cat, []).append((idx, img, extra))
                total_alpha_count += 1

        if alpha_tiles:
            cols = min(32, max(8, len(alpha_tiles)))
            atlas_img, atlas_meta = assemble_atlas(alpha_tiles, tile_w, tile_h, cols=cols)
            slug = p.stem.lower().replace(" ", "_").replace("-", "_")
            atlas_filename = f"eos_{slug}_alpha_atlas.png"
            atlas_path = sheets_out / atlas_filename
            atlas_img.save(atlas_path, "PNG", optimize=True)

            global_manifest["eos_biomes"][p.stem] = {
                "file": str(atlas_path.relative_to(base_out)),
                "dimensions": [atlas_img.width, atlas_img.height],
                "alpha_tile_count": len(alpha_tiles),
                "tile_size": [tile_w, tile_h],
                "grid_columns": cols,
                "grid_rows": math.ceil(len(alpha_tiles) / cols),
                "tiles_sample": atlas_meta[:20]
            }
            print(f"  -> Generated {atlas_filename} ({len(alpha_tiles)} alpha tiles, {atlas_img.size})")

    print("\n=== 3. Assembling Master Category Collections ===")
    for cat_name, tiles in all_categorized_tiles.items():
        sample_subset = tiles[:1024]
        cols = 32
        sample_w = sample_subset[0][1].width if sample_subset else 32
        sample_h = sample_subset[0][1].height if sample_subset else 32

        atlas_img, atlas_meta = assemble_atlas(sample_subset, sample_w, sample_h, cols=cols)
        cat_filename = f"category_{cat_name}_atlas.png"
        cat_path = cats_out / cat_filename
        atlas_img.save(cat_path, "PNG", optimize=True)

        global_manifest["category_summary"][cat_name] = {
            "total_tiles_in_category": len(tiles),
            "master_atlas_file": str(cat_path.relative_to(base_out)),
            "atlas_dimensions": [atlas_img.width, atlas_img.height]
        }
        print(f"  -> Category [{cat_name}]: {len(tiles)} tiles -> {cat_filename}")

    global_manifest["total_isolated_alpha_tiles"] = total_alpha_count
    global_manifest["total_processed_tiles"] = total_tiles_processed

    # Write JSON manifest
    manifest_file = base_out / "manifest.json"
    manifest_file.write_text(json.dumps(global_manifest, indent=2), encoding="utf-8")
    print(f"\nWrote global manifest: {manifest_file} ({len(manifest_file.read_bytes())} bytes)")

    # Build Documentation Overview Sheet
    print("Building composite documentation showcase sheet...")
    showcase_w = 1200
    showcase_h = 800
    showcase = Image.new("RGBA", (showcase_w, showcase_h), (20, 24, 32, 255))
    draw = ImageDraw.Draw(showcase)

    # Header bar
    draw.rectangle([(0, 0), (showcase_w, 60)], fill=(30, 36, 48, 255))

    cat_previews = sorted(list(cats_out.glob("category_*.png")))
    for i, cp in enumerate(cat_previews[:6]):
        try:
            im = Image.open(cp)
            thumb = im.crop((0, 0, min(im.width, 360), min(im.height, 220)))
            x = 30 + (i % 3) * 380
            y = 80 + (i // 3) * 230
            draw.rectangle([(x - 2, y - 2), (x + thumb.width + 1, y + thumb.height + 1)], outline=(70, 80, 105, 255))
            showcase.paste(thumb, (x, y), thumb)
        except Exception:
            pass

    showcase_path = docs_out / "pmu_eos_tilesets_showcase.png"
    showcase.save(showcase_path, "PNG")
    print(f"Saved showcase sheet: {showcase_path}")


if __name__ == "__main__":
    main()
