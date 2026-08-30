<<<<<<< HEAD
"""High-Fidelity Multi-Layer Visual Rasterizer for PMDO Town Generator.

Uses PixelLab Wang autotilesets, PixelLab structure stamps, multi-level cliff shading,
organic road textures, integrated staircases, and multi-layer canopy rendering.
"""
from __future__ import annotations

import io
import math
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw, ImageFilter, ImageFont

from .autotiler import Autotiler
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
from .pixellab_client import PixelLabClient
from .pixellab_structure_engine import PixelLabStructureEngine
from .pixellab_tileset_engine import PixelLabTilesetEngine
=======
"""Multi-layer PNG rasterizer and visualization engine for PMD maps."""
from __future__ import annotations

import math
from pathlib import Path
from typing import Optional, Tuple
from PIL import Image, ImageDraw

from .models import TileCollision, TownLayout
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
from .structure_library import StructureLibrary


class TownRenderer:
<<<<<<< HEAD
    def __init__(
        self,
        tile_size: int = 24,
        project_root: Optional[Path] = None,
        pixellab_client: Optional[PixelLabClient] = None,
    ):
        self.tile_size = tile_size
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.pixellab_client = pixellab_client or PixelLabClient(project_root=self.project_root)
        self.library = StructureLibrary(self.project_root, pixellab_client=self.pixellab_client)
        self.tileset_engine = PixelLabTilesetEngine(
            client=self.pixellab_client,
            tile_size=self.tile_size,
            project_root=self.project_root,
        )

    def render_final(self, layout: TownLayout) -> Image.Image:
        """Renders complete composite visual representation using PixelLab Wang tilesets & stamps."""
        w, h = layout.width, layout.height
        ts = self.tile_size
        img = Image.new("RGBA", (w * ts, h * ts), (54, 130, 62, 255))
        draw = ImageDraw.Draw(img)

        # 1. Base Terrain & Elevation Tiers using PixelLab Grass Palettes
        elev_palette = {
            0: (208, 220, 80, 255),  # PMD Canonical Spring Chartreuse grass
            1: (188, 208, 68, 255),  # Terrace grass
            2: (168, 196, 56, 255),  # Highland grass
        }
        for x in range(w):
            for y in range(h):
                elev = layout.heightmap[x][y]
                base_c = elev_palette.get(elev, elev_palette[0])
                jitter = int(4.0 * math.sin((x * 17 + y * 23) * 0.4))
                c = (
                    max(0, min(255, base_c[0] + jitter)),
                    max(0, min(255, base_c[1] + jitter)),
                    max(0, min(255, base_c[2] + jitter)),
                    255,
                )
                draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=c)

        # 2. Water / River Feature & Bridges via PixelLab Water Tiles
        water_deep = (95, 183, 207, 255)      # PMD Turquoise water
        water_shallow = (131, 218, 230, 255)  # Shimmer highlight
        bridge_wood = (168, 120, 64, 255)
        bridge_rail = (104, 72, 32, 255)

        for x in range(w):
            for y in range(h):
                if layout.water_mask[x][y] == 1:
                    if layout.road_mask[x][y] > 0:
                        # Wooden Bridge over river
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=bridge_wood)
                        draw.line((x * ts, y * ts + ts // 2, (x + 1) * ts - 1, y * ts + ts // 2), fill=bridge_rail, width=1)
                        draw.line((x * ts, y * ts + 1, (x + 1) * ts - 1, y * ts + 1), fill=bridge_rail, width=1)
                        draw.line((x * ts, (y + 1) * ts - 2, (x + 1) * ts - 1, (y + 1) * ts - 2), fill=bridge_rail, width=1)
                    else:
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=water_deep)
                        if (x + y) % 3 == 0:
                            draw.line((x * ts + 2, y * ts + ts // 2, (x + 1) * ts - 3, y * ts + ts // 2), fill=water_shallow, width=1)

        # 3. Roads & Plaza (Cobblestone vs Dirt Path)
        road_primary = (232, 224, 176, 255)    # Cobblestone plaza
        road_secondary = (208, 184, 136, 255)  # Natural dirt lane
        road_edge = (192, 176, 136, 255)

        for x in range(w):
            for y in range(h):
                rm = layout.road_mask[x][y]
                if rm == 2:  # Primary Avenue / Plaza
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=road_primary)
                    draw.rectangle((x * ts + 1, y * ts + 1, (x + 1) * ts - 2, (y + 1) * ts - 2), outline=road_edge, width=1)
                elif rm == 1:  # Secondary Street
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=road_secondary)

        # 4. Multi-Level Cliffs with Natural Ledges
        cliff_base = (144, 128, 80, 255)
        cliff_shadow = (96, 80, 48, 255)
        cliff_grass_lip = (208, 220, 80, 255)

        for x in range(w):
            for y in range(h):
                if layout.cliff_mask[x][y] == 1:
                    # Stone cliff wall face
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=cliff_base)
                    # Lower rock shadow
                    draw.rectangle((x * ts, y * ts + (2 * ts // 3), (x + 1) * ts - 1, (y + 1) * ts - 1), fill=cliff_shadow)
                    # Top grass lip overhang
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, y * ts + 3), fill=cliff_grass_lip)

        # 5. Integrated PMD-Style Staircases
        stair_step_light = (216, 208, 168, 255)
        stair_step_dark = (152, 136, 96, 255)
        stair_rail = (112, 96, 64, 255)

        for st in layout.stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y, st.y + st.length):
                    if 0 <= sx < w and 0 <= sy < h:
                        draw.rectangle((sx * ts, sy * ts, (sx + 1) * ts - 1, (sy + 1) * ts - 1), fill=stair_step_light)
                        step_h = ts // 3
                        for step_i in range(3):
                            draw.line((sx * ts, sy * ts + step_i * step_h, (sx + 1) * ts - 1, sy * ts + step_i * step_h), fill=stair_step_dark, width=2)
            # Side stone/wood railings
            draw.rectangle((st.x * ts - 2, st.y * ts, st.x * ts + 2, (st.y + st.length) * ts - 1), fill=stair_rail)
            draw.rectangle(((st.x + st.width) * ts - 2, st.y * ts, (st.x + st.width) * ts + 2, (st.y + st.length) * ts - 1), fill=stair_rail)

        # 6. Real Pixel Art Buildings & Stamps (PixelLab)
        for b in layout.buildings:
            bx, by, bw, bh = b.x, b.y, b.width, b.height
            sprite = self.library.get_sprite(b.prefab_id)

            if sprite:
                target_w = bw * ts
                target_h = bh * ts
                scaled_sprite = sprite.resize((target_w, target_h), Image.Resampling.NEAREST)
                img.alpha_composite(scaled_sprite, (bx * ts, by * ts))
            else:
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

        # 7. Multi-Layer Vegetation
        tree_trunk_c = (112, 72, 40, 255)
        tree_canopy_base = (40, 136, 48, 235)
        tree_canopy_hi = (104, 208, 88, 235)
        tree_canopy_edge = (24, 82, 32, 255)

        for veg in layout.vegetation:
            tx, ty, tw, th = veg.trunk_bounds
            cx, cy, cw, ch = veg.canopy_bounds
            draw.rectangle((tx * ts + 4, ty * ts + 4, (tx + tw) * ts - 5, (ty + th) * ts - 1), fill=tree_trunk_c)
            draw.ellipse((cx * ts, cy * ts, (cx + cw) * ts - 1, (cy + ch) * ts - 1), fill=tree_canopy_base, outline=tree_canopy_edge, width=2)
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
=======
    """Renders pixel-perfect PMD maps across multiple visualization passes."""

    def __init__(self, tile_size: int = 24, project_root: Optional[Path] = None):
        self.tile_size = tile_size
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.library = StructureLibrary(self.project_root)

        # Authentic PMD Explorers Color Palette
        self.col_grass_low = (108, 172, 72, 255)      # Level 0 Lush Grass
        self.col_grass_high = (124, 188, 84, 255)     # Level 1 Highland Grass
        self.col_cliff_top = (175, 138, 76, 255)      # Cliff Face Ochre
        self.col_cliff_shade = (130, 95, 48, 255)     # Cliff Base Shadow
        self.col_cliff_edge = (90, 145, 55, 255)      # Overhanging Grass Lip
        self.col_water_deep = (48, 112, 184, 255)     # River Channel
        self.col_water_shallow = (78, 155, 225, 255)  # River Bank / Shallows
        self.col_water_foam = (210, 240, 255, 255)    # Waterfall Foam
        self.col_dirt_road = (215, 185, 135, 255)     # Dirt Trail
        self.col_stone_plaza = (185, 180, 170, 255)   # Cobblestone Plaza
        self.col_stair_step = (165, 160, 150, 255)    # Chiseled Stone Stair
        self.col_bridge_wood = (145, 100, 60, 255)    # Wooden Bridge Plank

    def render_final(self, layout: TownLayout) -> Image.Image:
        """Renders comprehensive final beauty pass with all 11 PMDO layers."""
        w_px = layout.width * self.tile_size
        h_px = layout.height * self.tile_size
        img = Image.new("RGBA", (w_px, h_px), self.col_grass_low)
        draw = ImageDraw.Draw(img)

        # 1. Base Grass & Elevation Fill
        for x in range(layout.width):
            for y in range(layout.height):
                elev = layout.heightmap[x][y]
                col = self.col_grass_high if elev >= 1 else self.col_grass_low
                px, py = x * self.tile_size, y * self.tile_size
                draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=col)

        # 2. Roads & Plazas
        for x in range(layout.width):
            for y in range(layout.height):
                r = layout.road_mask[x][y]
                px, py = x * self.tile_size, y * self.tile_size
                if r == 1:  # Dirt trail
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_dirt_road)
                    # Texture flecks
                    draw.point((px + 4, py + 6), fill=(195, 165, 115, 255))
                    draw.point((px + 16, py + 18), fill=(225, 195, 145, 255))
                elif r == 2:  # Cobblestone Plaza / Bridge
                    # Check if bridge over water
                    if layout.water_mask[x][y] == 1:
                        draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_bridge_wood)
                        draw.line([(px, py + 4), (px + self.tile_size, py + 4)], fill=(110, 70, 40, 255))
                        draw.line([(px, py + 12), (px + self.tile_size, py + 12)], fill=(110, 70, 40, 255))
                        draw.line([(px, py + 20), (px + self.tile_size, py + 20)], fill=(110, 70, 40, 255))
                    else:
                        draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_stone_plaza)
                        # Cobble pattern
                        draw.rectangle([px + 2, py + 2, px + 10, py + 10], outline=(150, 145, 135, 255))
                        draw.rectangle([px + 12, py + 2, px + 22, py + 10], outline=(150, 145, 135, 255))
                        draw.rectangle([px + 2, py + 12, px + 22, py + 22], outline=(150, 145, 135, 255))

        # 3. Water & River Network
        for x in range(layout.width):
            for y in range(layout.height):
                if layout.water_mask[x][y] == 1 and layout.road_mask[x][y] != 2:
                    px, py = x * self.tile_size, y * self.tile_size
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_water_deep)
                    # Water ripples
                    draw.line([(px + 4, py + 8), (px + 16, py + 8)], fill=self.col_water_shallow, width=2)
                    draw.line([(px + 8, py + 16), (px + 20, py + 16)], fill=self.col_water_shallow, width=2)

        # 4. Cliffs & Rock Faces
        for x in range(layout.width):
            for y in range(layout.height):
                if layout.cliff_mask[x][y] == 1 and layout.water_mask[x][y] == 0:
                    px, py = x * self.tile_size, y * self.tile_size
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_cliff_top)
                    # Top lip grass fringe
                    draw.line([(px, py), (px + self.tile_size, py)], fill=self.col_cliff_edge, width=3)
                    # Base shadow
                    draw.line([(px, py + self.tile_size - 3), (px + self.tile_size, py + self.tile_size - 3)], fill=self.col_cliff_shade, width=3)

        # 5. Stairs
        for st in layout.stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y, st.y + st.length):
                    px, py = sx * self.tile_size, sy * self.tile_size
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=self.col_stair_step)
                    draw.line([(px, py + 6), (px + self.tile_size, py + 6)], fill=(120, 115, 105, 255), width=2)
                    draw.line([(px, py + 16), (px + self.tile_size, py + 16)], fill=(120, 115, 105, 255), width=2)

        # 6. Buildings & Monuments
        for b in layout.buildings:
            bx_px = b.x * self.tile_size
            by_px = b.y * self.tile_size
            sprite = self.library.render_structure_sprite(b.prefab_id, self.tile_size)
            img.alpha_composite(sprite, (bx_px, by_px))

        # 7. Vegetation & Trees
        for veg in layout.vegetation:
            vx_px = veg.x * self.tile_size
            vy_px = veg.y * self.tile_size
            # Draw trunk
            draw.rectangle([vx_px + 28, vy_px + 36, vx_px + 44, vy_px + 64], fill=(115, 75, 45, 255), outline=(70, 40, 20, 255), width=2)
            # Draw lush canopy
            draw.ellipse([vx_px + 4, vy_px + 4, vx_px + 68, vy_px + 52], fill=(55, 140, 45, 255), outline=(30, 85, 25, 255), width=2)
            # Leaf highlights
            draw.ellipse([vx_px + 12, vy_px + 10, vx_px + 44, vy_px + 32], fill=(85, 175, 65, 255))
            draw.ellipse([vx_px + 32, vy_px + 14, vx_px + 60, vy_px + 38], fill=(95, 190, 75, 255))

        # 8. Decorations
        for dec in layout.decorations:
            dx_px = dec.x * self.tile_size
            dy_px = dec.y * self.tile_size
            if dec.prop_type == "signpost":
                draw.rectangle([dx_px + 10, dy_px + 12, dx_px + 14, dy_px + 22], fill=(110, 70, 40, 255))
                draw.rectangle([dx_px + 4, dy_px + 4, dx_px + 20, dy_px + 14], fill=(220, 185, 130, 255), outline=(90, 50, 25, 255), width=1)
            elif dec.prop_type == "campfire":
                draw.ellipse([dx_px + 8, dy_px + 16, dx_px + 40, dy_px + 40], fill=(70, 65, 60, 255))
                draw.polygon([(dx_px + 24, dy_px + 8), (dx_px + 16, dy_px + 30), (dx_px + 32, dy_px + 30)], fill=(255, 120, 20, 255))
                draw.polygon([(dx_px + 24, dy_px + 14), (dx_px + 19, dy_px + 28), (dx_px + 29, dy_px + 28)], fill=(255, 230, 60, 255))
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

        return img

    def render_layout(self, layout: TownLayout) -> Image.Image:
<<<<<<< HEAD
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
=======
        """Renders functional district zoning and layout parcels."""
        w_px = layout.width * self.tile_size
        h_px = layout.height * self.tile_size
        img = Image.new("RGBA", (w_px, h_px), (40, 45, 50, 255))
        draw = ImageDraw.Draw(img)

        # Draw district bounds
        col_districts = {
            "plaza": (220, 180, 80, 80),
            "residential": (80, 180, 220, 80),
            "commercial": (180, 80, 220, 80),
            "waterfront": (60, 120, 240, 80),
        }

        for d in layout.districts:
            min_x, min_y, max_x, max_y = d.bounds
            px1, py1 = min_x * self.tile_size, min_y * self.tile_size
            px2, py2 = max_x * self.tile_size, max_y * self.tile_size
            col = col_districts.get(d.district_type.value, (120, 120, 120, 80))
            draw.rectangle([px1, py1, px2, py2], fill=col, outline=(255, 255, 255, 180), width=2)
            draw.text((px1 + 8, py1 + 8), f"{d.district_type.value.upper()} (Elev {d.elevation})", fill=(255, 255, 255, 255))

        # Buildings footprints
        for b in layout.buildings:
            bx, by = b.x * self.tile_size, b.y * self.tile_size
            bw, bh = b.width * self.tile_size, b.height * self.tile_size
            draw.rectangle([bx, by, bx + bw, by + bh], fill=(220, 60, 60, 160), outline=(255, 255, 255, 255), width=2)
            draw.text((bx + 4, by + 4), b.instance_id, fill=(255, 255, 255, 255))
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

        return img

    def render_elevation(self, layout: TownLayout) -> Image.Image:
<<<<<<< HEAD
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
=======
        """Renders elevation heightmap."""
        w_px = layout.width * self.tile_size
        h_px = layout.height * self.tile_size
        img = Image.new("RGBA", (w_px, h_px), (0, 0, 0, 255))
        draw = ImageDraw.Draw(img)

        elev_colors = {
            0: (50, 120, 50, 255),
            1: (120, 180, 90, 255),
            2: (200, 220, 140, 255),
        }

        for x in range(layout.width):
            for y in range(layout.height):
                e = layout.heightmap[x][y]
                col = elev_colors.get(e, (255, 255, 255, 255))
                px, py = x * self.tile_size, y * self.tile_size
                draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=col)

        return img

    def render_cliffs(self, layout: TownLayout) -> Image.Image:
        """Renders cliff contours and stair anchors."""
        w_px = layout.width * self.tile_size
        h_px = layout.height * self.tile_size
        img = Image.new("RGBA", (w_px, h_px), (30, 30, 30, 255))
        draw = ImageDraw.Draw(img)

        for x in range(layout.width):
            for y in range(layout.height):
                px, py = x * self.tile_size, y * self.tile_size
                if layout.cliff_mask[x][y] == 1:
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=(200, 130, 50, 255))

        for st in layout.stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y, st.y + st.length):
                    px, py = sx * self.tile_size, sy * self.tile_size
                    draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=(80, 220, 255, 255))

        return img

    def render_collision(self, layout: TownLayout) -> Image.Image:
        """Renders debug collision grid."""
        w_px = layout.width * self.tile_size
        h_px = layout.height * self.tile_size
        img = Image.new("RGBA", (w_px, h_px), (0, 0, 0, 255))
        draw = ImageDraw.Draw(img)

        col_map = {
            TileCollision.WALKABLE.value: (40, 180, 60, 255),    # Green
            TileCollision.BLOCKED.value: (200, 40, 40, 255),     # Red
            TileCollision.WATER.value: (40, 100, 220, 255),     # Blue
            TileCollision.CLIFF.value: (180, 110, 40, 255),     # Brown
            TileCollision.BUILDING.value: (180, 40, 180, 255),  # Magenta
            TileCollision.DOOR.value: (255, 220, 40, 255),      # Yellow
            TileCollision.STAIR.value: (40, 220, 220, 255),     # Cyan
            TileCollision.SIGN.value: (220, 140, 40, 255),      # Orange
        }

        for x in range(layout.width):
            for y in range(layout.height):
                c = layout.collision[x][y]
                col = col_map.get(c, (255, 255, 255, 255))
                px, py = x * self.tile_size, y * self.tile_size
                draw.rectangle([px, py, px + self.tile_size - 1, py + self.tile_size - 1], fill=col, outline=(0, 0, 0, 80))

        return img

    def render_navigation(self, layout: TownLayout) -> Image.Image:
        """Renders full circulation network and reachability paths."""
        img = self.render_final(layout)
        draw = ImageDraw.Draw(img)

        # Draw pathways
        for b in layout.buildings:
            dx, dy = b.door_map_pos
            px, py = dx * self.tile_size + self.tile_size // 2, dy * self.tile_size + self.tile_size // 2
            draw.ellipse([px - 6, py - 6, px + 6, py + 6], fill=(255, 255, 0, 255), outline=(0, 0, 0, 255), width=2)

        for st in layout.stairs:
            sx, sy = (st.x + 1) * self.tile_size, (st.y + 1) * self.tile_size
            draw.rectangle([sx - 8, sy - 8, sx + 8, sy + 8], fill=(0, 255, 255, 255), outline=(0, 0, 0, 255), width=2)
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)

        return img
