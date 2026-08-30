"""PMDO Visual and Collision Validator.
Renders PMDO native Ground maps, validates pixel identity against PMU Golden reference,
and checks 100% collision preservation.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFont

from .constants import (
    DEFINITE_BLOCK_TYPES,
    PMDO_SUBTILE_SIZE,
    PMU_TILE_SIZE,
    SUBTILES_PER_PMU_TILE,
)
from .converter import read_pmdo_tile_file


class PMDOValidator:
    def __init__(self, repo_root: Path):
        self.repo_root = Path(repo_root)

    def render_pmdo_map(
        self,
        rsground_data: dict[str, Any],
        tile_images: dict[tuple[int, int], Image.Image],
        frame_index: int = 0,
    ) -> Image.Image:
        """Render a PMDO Ground map by compositing its layers using the tile atlas."""
        obj = rsground_data["Object"]
        layers = obj.get("Layers", [])
        if not layers:
            raise ValueError("No layers found in GroundData")

        first_layer_tiles = layers[0]["Tiles"]
        grid_w = len(first_layer_tiles)
        grid_h = len(first_layer_tiles[0]) if grid_w else 0
        tex_size = obj.get("TexSize", 1)
        subtile_px = tex_size * 8

        width_px = grid_w * subtile_px
        height_px = grid_h * subtile_px

        output = Image.new("RGBA", (width_px, height_px), (255, 255, 255, 255))

        for layer in layers:
            if not layer.get("Visible", True):
                continue
            for gx in range(grid_w):
                for gy in range(grid_h):
                    cell = layer["Tiles"][gx][gy]
                    for tile_layer in cell.get("Layers", []):
                        frames = tile_layer.get("Frames", [])
                        if not frames:
                            continue
                        f = frames[frame_index % len(frames)]
                        sx = int(f["TexLoc"]["X"])
                        sy = int(f["TexLoc"]["Y"])
                        tile_img = tile_images.get((sx, sy))
                        if tile_img is not None:
                            output.alpha_composite(tile_img, (gx * subtile_px, gy * subtile_px))

        return output.convert("RGB")

    def render_pmdo_collision(
        self,
        base_image: Image.Image,
        rsground_data: dict[str, Any],
    ) -> Image.Image:
        """Render PMDO collision overlay on top of the rendered ground image."""
        w, h = base_image.size
        overlay = base_image.convert("RGBA").copy()
        draw = ImageDraw.Draw(overlay)
        font = ImageFont.load_default()

        obj = rsground_data["Object"]
        obstacles = obj.get("obstacles", [])
        grid_w = len(obstacles)
        grid_h = len(obstacles[0]) if grid_w else 0

        for gx in range(grid_w):
            for gy in range(grid_h):
                cell = obstacles[gx][gy]
                tag = cell.get("Tags", 0)
                bounds = cell.get("Bounds", {"X": gx * 8, "Y": gy * 8, "Width": 8, "Height": 8})
                bx, by = bounds["X"], bounds["Y"]
                bw, bh = bounds["Width"], bounds["Height"]
                if tag != 0:
                    draw.rectangle([bx, by, bx + bw - 1, by + bh - 1], fill=(220, 20, 20, 120), outline=(255, 0, 0, 200))
                else:
                    # Subtle green outline for walkable
                    draw.rectangle([bx, by, bx + bw - 1, by + bh - 1], outline=(0, 200, 0, 30))

        # Draw markers & entities
        for ent_layer in obj.get("Entities", []):
            for marker in ent_layer.get("Markers", []):
                mx = marker["Position"]["X"]
                my = marker["Position"]["Y"]
                draw.rectangle([mx - 8, my - 8, mx + 8, my + 8], fill=(30, 144, 255, 180), outline=(0, 255, 255, 255))
                draw.text((mx - 6, my - 6), "W", fill=(255, 255, 255, 255), font=font)
            for npc in ent_layer.get("MapChars", []):
                nx = npc["Position"]["X"]
                ny = npc["Position"]["Y"]
                draw.ellipse([nx - 6, ny - 6, nx + 6, ny + 6], fill=(0, 206, 209, 200), outline=(255, 255, 255, 255))

        return overlay.convert("RGB")

    def validate_visual(
        self,
        pmu_golden_base: Image.Image,
        pmdo_render_base: Image.Image,
        pmu_golden_anim: Image.Image | None = None,
        pmdo_render_anim: Image.Image | None = None,
    ) -> dict[str, Any]:
        """Compare PMU Golden render with PMDO Render pixel by pixel."""
        # 1. Dimensions check
        dims_match = (pmu_golden_base.size == pmdo_render_base.size)
        if not dims_match:
            return {
                "status": "REFUSED",
                "reason": f"Dimensions mismatch: PMU {pmu_golden_base.size} vs PMDO {pmdo_render_base.size}",
                "dimensions_pmu": list(pmu_golden_base.size),
                "dimensions_pmdo": list(pmdo_render_base.size),
                "diff_pixels_base": -1,
                "diff_percentage_base": 100.0,
            }

        w, h = pmu_golden_base.size
        total_pixels = w * h

        # 2. Base frame pixel diff
        pmu_base_bytes = pmu_golden_base.tobytes()
        pmdo_base_bytes = pmdo_render_base.tobytes()

        diff_pixels_base = 0
        min_diff_x, min_diff_y = w, h
        max_diff_x, max_diff_y = -1, -1

        for i in range(0, len(pmu_base_bytes), 3):
            if pmu_base_bytes[i : i + 3] != pmdo_base_bytes[i : i + 3]:
                diff_pixels_base += 1
                pixel_idx = i // 3
                px = pixel_idx % w
                py = pixel_idx // w
                min_diff_x = min(min_diff_x, px)
                min_diff_y = min(min_diff_y, py)
                max_diff_x = max(max_diff_x, px)
                max_diff_y = max(max_diff_y, py)

        diff_pct_base = (diff_pixels_base / total_pixels) * 100.0

        # 3. Animated frame pixel diff (if applicable)
        diff_pixels_anim = 0
        diff_pct_anim = 0.0
        if pmu_golden_anim and pmdo_render_anim:
            pmu_anim_bytes = pmu_golden_anim.tobytes()
            pmdo_anim_bytes = pmdo_render_anim.tobytes()
            for i in range(0, len(pmu_anim_bytes), 3):
                if pmu_anim_bytes[i : i + 3] != pmdo_anim_bytes[i : i + 3]:
                    diff_pixels_anim += 1
            diff_pct_anim = (diff_pixels_anim / total_pixels) * 100.0

        is_valid = (diff_pixels_base == 0 and diff_pixels_anim == 0)

        return {
            "status": "VALIDATED" if is_valid else "REFUSED",
            "dimensions_match": dims_match,
            "dimensions": [w, h],
            "total_pixels": total_pixels,
            "diff_pixels_base": diff_pixels_base,
            "diff_percentage_base": round(diff_pct_base, 4),
            "diff_pixels_anim": diff_pixels_anim,
            "diff_percentage_anim": round(diff_pct_anim, 4),
            "diff_bounding_box": [min_diff_x, min_diff_y, max_diff_x, max_diff_y] if diff_pixels_base > 0 else None,
            "perfect_byte_match": is_valid,
        }

    def validate_collision(
        self,
        pmu_collision_doc: dict[str, Any],
        rsground_data: dict[str, Any],
    ) -> dict[str, Any]:
        """Validate that PMU collision maps 100% deterministically to PMDO 8px obstacles."""
        pmu_grid = pmu_collision_doc["grid"]
        w_tiles = len(pmu_grid)
        h_tiles = len(pmu_grid[0]) if w_tiles else 0

        obstacles = rsground_data["Object"].get("obstacles", [])
        grid_w = len(obstacles)
        grid_h = len(obstacles[0]) if grid_w else 0

        expected_grid_w = w_tiles * SUBTILES_PER_PMU_TILE
        expected_grid_h = h_tiles * SUBTILES_PER_PMU_TILE

        if grid_w != expected_grid_w or grid_h != expected_grid_h:
            return {
                "status": "REFUSED",
                "reason": f"Obstacle grid dimension mismatch: PMDO {grid_w}x{grid_h} vs expected {expected_grid_w}x{expected_grid_h}",
                "total_pmu_cells": w_tiles * h_tiles,
                "total_pmdo_cells": grid_w * grid_h,
                "matched_cells": 0,
                "mismatched_cells": grid_w * grid_h,
            }

        matched_cells = 0
        added_blocked_cells = 0
        lost_blocked_cells = 0
        mismatched_cells = 0

        total_pmdo_cells = grid_w * grid_h
        for tx in range(w_tiles):
            for ty in range(h_tiles):
                pmu_cell = pmu_grid[tx][ty]
                pmu_type = int(pmu_cell.get("type_id", 0))
                expected_blocked = 1 if pmu_type in DEFINITE_BLOCK_TYPES else 0

                for dx in range(SUBTILES_PER_PMU_TILE):
                    for dy in range(SUBTILES_PER_PMU_TILE):
                        gx = tx * SUBTILES_PER_PMU_TILE + dx
                        gy = ty * SUBTILES_PER_PMU_TILE + dy
                        actual_blocked = obstacles[gx][gy].get("Tags", 0)

                        if actual_blocked == expected_blocked:
                            matched_cells += 1
                        else:
                            mismatched_cells += 1
                            if actual_blocked == 1 and expected_blocked == 0:
                                added_blocked_cells += 1
                            elif actual_blocked == 0 and expected_blocked == 1:
                                lost_blocked_cells += 1

        is_valid = (lost_blocked_cells == 0 and mismatched_cells == 0)

        return {
            "status": "VALIDATED" if is_valid else "REFUSED",
            "total_pmu_cells": w_tiles * h_tiles,
            "total_pmdo_cells": total_pmdo_cells,
            "matched_cells": matched_cells,
            "mismatched_cells": mismatched_cells,
            "lost_blocked_cells": lost_blocked_cells,
            "added_blocked_cells": added_blocked_cells,
            "expansion_ratio": SUBTILES_PER_PMU_TILE * SUBTILES_PER_PMU_TILE,
            "perfect_collision_match": is_valid,
        }
