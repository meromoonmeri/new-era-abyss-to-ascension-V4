"""PMU Golden reference renderer and collision visualizer."""
from __future__ import annotations

import io
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFont

from .constants import (
    CONDITIONAL_BLOCK_TYPES,
    DEFINITE_BLOCK_TYPES,
    LAYER_PAIRS,
    PMU_TILE_SIZE,
)
from PMU_EXTRACTION.src.pmu_extraction.tilesets import TileArchive


class PMURenderer:
    def __init__(self, tiles_directory: Path):
        self.tiles_directory = Path(tiles_directory)
        self.archives: dict[int, TileArchive] = {}
        for path in sorted(self.tiles_directory.glob("Tiles*.tile"), key=lambda p: int(p.stem.removeprefix("Tiles"))):
            number = int(path.stem.removeprefix("Tiles"))
            archive = TileArchive(path, number)
            archive.__enter__()
            self.archives[number] = archive
        self.invalid_references: list[dict[str, Any]] = []

    def close(self):
        for archive in self.archives.values():
            archive.__exit__(None, None, None)

    def tile(self, map_id: str, x: int, y: int, layer: str, tileset: int, tile_number: int) -> Image.Image:
        archive = self.archives.get(tileset)
        if archive is None:
            self.invalid_references.append({
                "map_id": map_id, "x": x, "y": y, "layer": layer,
                "tileset": tileset, "tile": tile_number, "reason": "missing tileset",
            })
            archive = self.archives.get(0)
            tile_number = 0
            if archive is None:
                return Image.new("RGBA", (PMU_TILE_SIZE, PMU_TILE_SIZE), (0, 0, 0, 0))
        elif not 0 <= tile_number < archive.tile_count:
            self.invalid_references.append({
                "map_id": map_id, "x": x, "y": y, "layer": layer,
                "tileset": tileset, "tile": tile_number,
                "reason": "out-of-range tile; original client falls back to tile 0",
            })
            tile_number = 0
        return archive.image(tile_number)

    def render_map(self, map_data: dict[str, Any], animated: bool = False) -> Image.Image:
        max_x = int(map_data.get("dimensions", {}).get("max_x", map_data.get("max_x", 0)))
        max_y = int(map_data.get("dimensions", {}).get("max_y", map_data.get("max_y", 0)))
        width = (max_x + 1) * PMU_TILE_SIZE
        height = (max_y + 1) * PMU_TILE_SIZE

        # PMU MapViewer fills white background
        output = Image.new("RGBA", (width, height), (255, 255, 255, 255))
        tiles = map_data.get("tiles", [])
        map_id = map_data.get("map_id", "unknown")

        for tile in tiles:
            x, y = int(tile["x"]), int(tile["y"])
            for base, base_set, anim, anim_set in LAYER_PAIRS:
                field, set_field = (anim, anim_set) if animated and tile.get(anim) != 0 else (base, base_set)
                tile_number = int(tile.get(field) or 0)
                if tile_number == 0:
                    continue
                sheet_id = int(tile.get(set_field) or 0)
                image = self.tile(map_id, x, y, field, sheet_id, tile_number)
                output.alpha_composite(image, (x * PMU_TILE_SIZE, y * PMU_TILE_SIZE))
        return output.convert("RGB")

    def render_preview(self, base_image: Image.Image, max_dimension: int = 512) -> Image.Image:
        w, h = base_image.size
        scale = min(1.0, max_dimension / max(w, h))
        if scale >= 1.0:
            return base_image.copy()
        new_w = max(1, int(round(w * scale)))
        new_h = max(1, int(round(h * scale)))
        return base_image.resize((new_w, new_h), Image.Resampling.NEAREST)

    def render_collision_overlay(
        self, base_image: Image.Image, map_data: dict[str, Any]
    ) -> Image.Image:
        w, h = base_image.size
        overlay = base_image.convert("RGBA").copy()
        draw = ImageDraw.Draw(overlay)
        font = ImageFont.load_default()

        tiles = map_data.get("tiles", [])
        for tile in tiles:
            x, y = int(tile["x"]) * PMU_TILE_SIZE, int(tile["y"]) * PMU_TILE_SIZE
            t_type = int(tile["type"])

            # Color coding for collision overlay:
            # Blocked: Red
            # Sign / ScriptedSign: Amber
            # Warp / Door: Blue
            # Script: Magenta
            # Item: Yellow
            # Conditional (MobileBlock, SpriteBlock, LevelBlock): Orange
            # Walkable / NPCAvoid / etc.: Transparent Green tint or subtle border
            if t_type in (1,):  # Blocked
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(220, 20, 20, 110), outline=(255, 0, 0, 220))
            elif t_type in (14, 31):  # Sign
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(255, 191, 0, 140), outline=(255, 215, 0, 240))
                draw.text((x + 4, y + 8), "SGN", fill=(0, 0, 0, 255), font=font)
            elif t_type in (2, 15, 30, 34):  # Warp / Door / Exit
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(30, 144, 255, 140), outline=(0, 191, 255, 240))
                draw.text((x + 2, y + 8), "WRP", fill=(255, 255, 255, 255), font=font)
            elif t_type in (19, 28):  # Script / Story
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(186, 85, 211, 140), outline=(218, 112, 214, 240))
                draw.text((x + 4, y + 8), "SCR", fill=(255, 255, 255, 255), font=font)
            elif t_type in (10, 24, 25, 35):  # Conditional
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(255, 140, 0, 130), outline=(255, 165, 0, 240))
                draw.text((x + 4, y + 8), "CND", fill=(255, 255, 255, 255), font=font)
            elif t_type == 3:  # Item
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], fill=(255, 255, 0, 120), outline=(255, 255, 100, 240))
                draw.text((x + 4, y + 8), "ITM", fill=(0, 0, 0, 255), font=font)
            elif t_type in (0, 4, 33):  # Walkable
                # Draw subtle light green grid outline
                draw.rectangle([x, y, x + PMU_TILE_SIZE - 1, y + PMU_TILE_SIZE - 1], outline=(0, 220, 0, 40))

        return overlay.convert("RGB")
