"""High-Fidelity Multi-Layer Visual Rasterizer for PMDO Town Generator.

Uses real PMDO pixel art sprites, multi-level cliff shading, organic road textures,
integrated staircases, and multi-layer canopy rendering.
"""
from __future__ import annotations

import io
import math
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw, ImageFilter, ImageFont

from .models import (
    BiomeType,
    DistrictType,
    PlacedDecoration,
    PlacedStructure,
    PlacedVegetation,
    SeasonType,
    StairConnection,
    TileCollision,
    TownLayout,
)
from .structure_library import StructureLibrary


class TownRenderer:
    def __init__(self, tile_size: int = 24, project_root: Optional[Path] = None):
        self.tile_size = tile_size
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.library = StructureLibrary(self.project_root)

    def render_final(self, layout: TownLayout) -> Image.Image:
        """Renders complete composite visual representation using real PMDO sprites & autotiles."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (54, 130, 62, 255))
        draw = ImageDraw.Draw(img)

        # 1. Base Terrain & Elevation Tiers
        elev_palette = {
            0: (52, 126, 58, 255),   # Base grass
            1: (66, 154, 74, 255),   # Mid terrace grass
            2: (82, 176, 90, 255),   # Highland grass
        }
        for x in range(w):
            for y in range(h):
                elev = layout.heightmap[x][y]
                base_c = elev_palette.get(elev, elev_palette[0])
                # Subtle organic grass texture variation
                jitter = int(6.0 * math.sin((x * 17 + y * 23) * 0.4))
                c = (
                    max(0, min(255, base_c[0] + jitter)),
                    max(0, min(255, base_c[1] + jitter)),
                    max(0, min(255, base_c[2] + jitter)),
                    255,
                )
                draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=c)

        # 2. Water / River Feature & Bridges
        water_deep = (45, 115, 195, 255)
        water_shallow = (70, 145, 220, 255)
        bridge_wood = (150, 100, 55, 255)
        bridge_rail = (90, 55, 25, 255)

        for x in range(w):
            for y in range(h):
                if layout.water_mask[x][y] == 1:
                    if layout.road_mask[x][y] > 0:
                        # Wooden Bridge over river
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=bridge_wood)
                        # Bridge plank lines
                        draw.line((x * ts, y * ts + ts // 2, (x + 1) * ts - 1, y * ts + ts // 2), fill=bridge_rail, width=1)
                    else:
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=water_deep)
                        if (x + y) % 3 == 0:
                            draw.line((x * ts + 2, y * ts + ts // 2, (x + 1) * ts - 3, y * ts + ts // 2), fill=water_shallow, width=1)

        # 3. Roads & Plaza (Avenue vs Street)
        road_primary = (212, 192, 152, 255)    # Cobblestone plaza
        road_secondary = (188, 158, 118, 255)  # Natural dirt lane
        road_edge = (160, 130, 95, 255)

        for x in range(w):
            for y in range(h):
                rm = layout.road_mask[x][y]
                if rm == 2:  # Primary Avenue / Plaza
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=road_primary)
                    # Subtle brick pattern
                    draw.rectangle((x * ts + 1, y * ts + 1, (x + 1) * ts - 2, (y + 1) * ts - 2), outline=road_edge, width=1)
                elif rm == 1:  # Secondary Street
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=road_secondary)

        # 4. Multi-Level Cliffs with Natural Ledges
        cliff_base = (118, 92, 64, 255)
        cliff_shadow = (88, 68, 46, 255)
        cliff_grass_lip = (76, 170, 84, 255)

        for x in range(w):
            for y in range(h):
                if layout.cliff_mask[x][y] == 1:
                    # Stone cliff wall face
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=cliff_base)
                    # Lower rock shadow
                    draw.rectangle((x * ts, y * ts + (2 * ts // 3), (x + 1) * ts - 1, (y + 1) * ts - 1), fill=cliff_shadow)
                    # Top grass lip overhang
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, y * ts + 4), fill=cliff_grass_lip)

        # 5. Integrated PMD-Style Staircases
        stair_step_light = (195, 170, 130, 255)
        stair_step_dark = (145, 120, 85, 255)
        stair_rail = (95, 70, 45, 255)

        for st in layout.stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y, st.y + st.length):
                    if 0 <= sx < w and 0 <= sy < h:
                        draw.rectangle((sx * ts, sy * ts, (sx + 1) * ts - 1, (sy + 1) * ts - 1), fill=stair_step_light)
                        # Step treads
                        step_h = ts // 3
                        for step_i in range(3):
                            draw.line((sx * ts, sy * ts + step_i * step_h, (sx + 1) * ts - 1, sy * ts + step_i * step_h), fill=stair_step_dark, width=2)
            # Side wood/stone railings
            draw.rectangle((st.x * ts - 2, st.y * ts, st.x * ts + 2, (st.y + st.length) * ts - 1), fill=stair_rail)
            draw.rectangle(((st.x + st.width) * ts - 2, st.y * ts, (st.x + st.width) * ts + 2, (st.y + st.length) * ts - 1), fill=stair_rail)

        # 6. Real Pixel Art Buildings & Stamps
        for b in layout.buildings:
            bx, by, bw, bh = b.x, b.y, b.width, b.height
            sprite = self.library.get_sprite(b.prefab_id)

            if sprite:
                # Scale sprite cleanly to building footprint
                target_w = bw * ts
                target_h = bh * ts
                scaled_sprite = sprite.resize((target_w, target_h), Image.Resampling.NEAREST)
                img.alpha_composite(scaled_sprite, (bx * ts, by * ts))
            else:
                # Fallback architectural render
                roof_colors = {
                    "pokemon_center": (225, 75, 75, 255),
                    "shop": (75, 130, 225, 255),
                    "inn": (215, 145, 60, 255),
                    "fountain": (65, 165, 230, 255),
                    "well": (140, 140, 150, 255),
                    "house_small": (180, 85, 60, 255),
                    "house_medium": (160, 95, 140, 255),
                    "house_large": (105, 135, 175, 255),
                }
                roof_c = roof_colors.get(b.prefab_id, (160, 100, 70, 255))
                draw.rectangle((bx * ts + 2, by * ts + 2, (bx + bw) * ts - 3, (by + bh) * ts - 3), fill=(235, 225, 205, 255), outline=(50, 40, 30, 255), width=2)
                draw.rectangle((bx * ts, by * ts, (bx + bw) * ts - 1, (by + bh - 2) * ts - 1), fill=roof_c, outline=(40, 30, 20, 255), width=2)
                dx, dy = b.door_map_pos
                draw.rectangle((dx * ts + 4, dy * ts + 2, (dx + 1) * ts - 5, (dy + 1) * ts - 1), fill=(90, 55, 30, 255))

        # 7. Multi-Layer Vegetation (Trunk on lower layer, Canopy on Fringe)
        tree_trunk_c = (96, 62, 34, 255)
        tree_canopy_base = (38, 122, 50, 235)
        tree_canopy_hi = (56, 152, 68, 235)
        tree_canopy_edge = (24, 82, 32, 255)

        for veg in layout.vegetation:
            tx, ty, tw, th = veg.trunk_bounds
            cx, cy, cw, ch = veg.canopy_bounds
            # Draw trunk
            draw.rectangle((tx * ts + 4, ty * ts + 4, (tx + tw) * ts - 5, (ty + th) * ts - 1), fill=tree_trunk_c)
            # Draw leaf canopy
            draw.ellipse((cx * ts, cy * ts, (cx + cw) * ts - 1, (cy + ch) * ts - 1), fill=tree_canopy_base, outline=tree_canopy_edge, width=2)
            # Leaf highlight dome
            draw.ellipse((cx * ts + 4, cy * ts + 2, (cx + cw) * ts - 6, cy * ts + (ch * ts // 2)), fill=tree_canopy_hi)

        # 8. Street Furniture & Decorations
        for dec in layout.decorations:
            dx, dy, dw, dh = dec.x, dec.y, dec.width, dec.height
            if dec.prop_type == "signpost":
                draw.rectangle((dx * ts + 6, dy * ts + 4, (dx + 1) * ts - 7, (dy + 1) * ts - 2), fill=(160, 110, 50, 255), outline=(60, 40, 20, 255))
            elif dec.prop_type == "lamppost":
                draw.rectangle((dx * ts + 9, dy * ts + 4, (dx + 1) * ts - 10, (dy + dh) * ts - 2), fill=(60, 65, 70, 255))
                draw.ellipse((dx * ts + 5, dy * ts, (dx + 1) * ts - 6, dy * ts + ts // 2), fill=(255, 235, 130, 255))
            elif dec.prop_type == "bench":
                draw.rectangle((dx * ts + 2, dy * ts + 6, (dx + dw) * ts - 3, (dy + dh) * ts - 4), fill=(140, 90, 45, 255), outline=(50, 30, 15, 255))

        return img

    def render_layout(self, layout: TownLayout) -> Image.Image:
        """Renders abstract layout showing districts, roads, and parcel footprints."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (30, 35, 45, 255))
        draw = ImageDraw.Draw(img)

        district_colors = {
            DistrictType.PLAZA: (80, 140, 210, 100),
            DistrictType.COMMERCIAL: (210, 160, 60, 100),
            DistrictType.RESIDENTIAL: (90, 180, 100, 100),
            DistrictType.NATURE: (60, 120, 70, 100),
            DistrictType.WATERFRONT: (50, 160, 220, 100),
        }
        for d in layout.districts:
            fill_c = district_colors.get(d.district_type, (120, 120, 120, 80))
            x0, y0, x1, y1 = d.bounds
            draw.rectangle((x0 * ts, y0 * ts, x1 * ts, y1 * ts), fill=fill_c, outline=(200, 220, 255, 160), width=1)
            draw.text((d.center_x * ts - 20, d.center_y * ts - 6), d.district_type.value.upper(), fill=(255, 255, 255, 220))

        for x in range(w):
            for y in range(h):
                if layout.road_mask[x][y] == 2:
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=(220, 200, 160, 200))
                elif layout.road_mask[x][y] == 1:
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=(180, 160, 120, 180))

        for p in layout.parcels:
            px, py, pw, ph = p.bounds
            draw.rectangle((px * ts, py * ts, (px + pw) * ts - 1, (py + ph) * ts - 1), fill=(240, 100, 80, 180), outline=(255, 255, 255, 255), width=2)
            dx, dy = p.door_target_pos
            draw.rectangle((dx * ts + 2, dy * ts + 2, (dx + 1) * ts - 3, (dy + 1) * ts - 3), fill=(255, 255, 0, 255))

        for st in layout.stairs:
            draw.rectangle((st.x * ts, st.y * ts, (st.x + st.width) * ts - 1, (st.y + st.length) * ts - 1), fill=(255, 140, 0, 220), outline=(255, 255, 255, 255), width=2)

        return img

    def render_elevation(self, layout: TownLayout) -> Image.Image:
        """Renders discrete elevation tiers."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (0, 0, 0, 255))
        draw = ImageDraw.Draw(img)

        colors = {
            0: (35, 75, 145, 255),
            1: (55, 145, 75, 255),
            2: (185, 140, 50, 255),
        }
        for x in range(w):
            for y in range(h):
                elev = layout.heightmap[x][y]
                draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=colors.get(elev, (100, 100, 100, 255)))

        for x in range(w):
            for y in range(h):
                if layout.cliff_mask[x][y] == 1:
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=(255, 255, 255, 200))
        return img

    def render_cliffs(self, layout: TownLayout) -> Image.Image:
        """Renders isolated cliff boundaries & stairs."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (20, 24, 30, 255))
        draw = ImageDraw.Draw(img)

        for x in range(w):
            for y in range(h):
                if layout.cliff_mask[x][y] == 1:
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=(210, 120, 60, 255))

        for st in layout.stairs:
            draw.rectangle((st.x * ts, st.y * ts, (st.x + st.width) * ts - 1, (st.y + st.length) * ts - 1), fill=(80, 200, 120, 255), outline=(255, 255, 255, 255), width=2)
        return img

    def render_collision(self, layout: TownLayout) -> Image.Image:
        """Renders collision grid."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (0, 0, 0, 255))
        draw = ImageDraw.Draw(img)

        col_colors = {
            TileCollision.WALKABLE.value: (40, 180, 50, 255),
            TileCollision.BLOCKED.value: (220, 40, 40, 255),
            TileCollision.WARP.value: (40, 180, 230, 255),
            TileCollision.SIGN.value: (240, 210, 40, 255),
            TileCollision.NPC_AVOID.value: (180, 60, 220, 255),
        }
        for x in range(w):
            for y in range(h):
                c_val = layout.collision[x][y]
                draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=col_colors.get(c_val, (128, 128, 128, 255)))
        return img

    def render_navigation(self, layout: TownLayout) -> Image.Image:
        """Renders navigation graph connecting entrance to all POIs."""
        img = self.render_final(layout)
        draw = ImageDraw.Draw(img)
        ts = self.tile_size

        start_x, start_y = layout.width // 2, layout.height - 2
        plaza_x, plaza_y = layout.width // 2, int(layout.height * 0.62)

        draw.line((start_x * ts + ts // 2, start_y * ts + ts // 2, plaza_x * ts + ts // 2, plaza_y * ts + ts // 2), fill=(255, 255, 0, 255), width=4)

        for b in layout.buildings:
            dx, dy = b.door_map_pos
            draw.line((plaza_x * ts + ts // 2, plaza_y * ts + ts // 2, dx * ts + ts // 2, dy * ts + ts // 2), fill=(0, 255, 255, 220), width=3)
            draw.ellipse((dx * ts, dy * ts, (dx + 1) * ts, (dy + 1) * ts), fill=(255, 0, 0, 255))

        for st in layout.stairs:
            sx = st.x + st.width // 2
            sy = st.y + st.length // 2
            draw.line((plaza_x * ts + ts // 2, plaza_y * ts + ts // 2, sx * ts + ts // 2, sy * ts + ts // 2), fill=(255, 128, 0, 255), width=3)

        return img
