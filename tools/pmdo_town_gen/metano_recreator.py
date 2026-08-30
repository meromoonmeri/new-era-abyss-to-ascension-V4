"""High-Fidelity Metano Town Recreator and Stylistic Engine for PMDO.

Recreates Metano Town using the exact canonical PMD colorimetry, authentic
palette (chartreuse spring grass, turquoise river, ochre cliffs, cobblestone plaza),
and canonical spatial organization (Western Residential Terrace, Eastern River,
Central Plaza with Kecleon Shop, Upper Cafe Terrace).
"""
from __future__ import annotations

import io
import math
import random
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from PIL import Image, ImageDraw

from .models import (
    BiomeType,
    District,
    DistrictType,
    Parcel,
    PlacedDecoration,
    PlacedStructure,
    PlacedVegetation,
    SeasonType,
    StairConnection,
    TileCollision,
    TownLayout,
    TownSpec,
)
from .pmdo_exporter import PMDOExporter
from .structure_library import StructureLibrary
from .validator import TownValidator
from .visual_validator import VisualQualityValidator

# Canonical Metano Town Palette (Sampled from PMDO native tilesets & renders)
METANO_PALETTE = {
    "grass_level_0": (208, 220, 80, 255),      # Canonical vibrant PMD spring grass
    "grass_level_1": (188, 208, 68, 255),      # Elevated terrace grass
    "grass_jitter_1": (218, 226, 92, 255),     # Grass texture highlight
    "grass_jitter_2": (196, 212, 72, 255),     # Grass texture shadow
    "cliff_face": (144, 128, 80, 255),         # Warm ochre rock face
    "cliff_shadow": (96, 80, 48, 255),         # Deep cliff shadow
    "cliff_lip": (208, 220, 80, 255),          # Top grass overhang
    "river_deep": (95, 183, 207, 255),         # Crystal turquoise water
    "river_shallow": (131, 218, 230, 255),     # Water shimmer / ripple
    "road_plaza": (232, 224, 176, 255),        # Cream cobblestone paved plaza
    "road_plaza_grid": (192, 176, 136, 255),   # Cobblestone tile border
    "road_dirt": (208, 184, 136, 255),         # Natural sandy dirt path
    "bridge_wood": (168, 120, 64, 255),        # Warm wooden bridge planks
    "bridge_rail": (104, 72, 32, 255),         # Bridge railing
    "stair_stone": (216, 208, 168, 255),       # Stone stair tread
    "stair_step": (152, 136, 96, 255),         # Stair riser shadow
    "tree_trunk": (112, 72, 40, 255),          # Tree trunk bark
    "tree_canopy_base": (40, 136, 48, 235),    # Deep forest leaf base
    "tree_canopy_dome": (104, 208, 88, 235),   # Vibrant lime leaf highlight
    "tree_canopy_edge": (24, 96, 32, 255),     # Canopy outline
}


class MetanoRecreator:
    def __init__(self, project_root: Optional[Path] = None):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.library = StructureLibrary(self.project_root)
        self.exporter = PMDOExporter(self.project_root)

    def build_metano_layout(
        self,
        name: str = "metano_town_recreated",
        display_name: str = "Metano Town (Recreated)",
        seed: int = 184729,
        width: int = 63,
        height: int = 63,
    ) -> TownLayout:
        """Constructs an authentic, high-fidelity Metano Town layout with exact spatial logic."""
        rng = random.Random(seed)
        w, h = width, height

        spec = TownSpec(
            name=name,
            display_name=display_name,
            biome=BiomeType.GRASSLAND,
            season=SeasonType.SPRING,
            seed=seed,
            width=w,
            height=h,
            elevation_levels=2,
            reference_style="metano",
            has_river=True,
            river_side="east",
        )

        # 1. Heightmap & Relief Synthesis
        # Level 0 in central valley and south; Level 1 on western residential terrace and north cafe terrace
        hmap = [[0 for _ in range(h)] for _ in range(w)]
        cliff_mask = [[0 for _ in range(h)] for _ in range(w)]

        for x in range(w):
            for y in range(h):
                # Western Terrace: X <= 24, Y <= 34
                is_west_terrace = (x <= 24 and y <= 34 + int(2.0 * math.sin(x * 0.4)))
                # Northern/East Terrace: Y <= 26 and X >= 36
                is_north_terrace = (y <= 26 + int(2.0 * math.cos(x * 0.3)) and x >= 34)
                # Far North Hill: Y <= 14
                is_far_north = (y <= 14 + int(2.0 * math.sin(x * 0.2)))

                if is_west_terrace or is_north_terrace or is_far_north:
                    hmap[x][y] = 1
                else:
                    hmap[x][y] = 0

        # Guarantee southern main entrance corridor is flat Level 0
        for x in range(w // 2 - 8, w // 2 + 8):
            for y in range(h - 10, h):
                hmap[x][y] = 0

        # Compute cliff contours
        for x in range(w):
            for y in range(h):
                if hmap[x][y] == 1:
                    for nx, ny in ((x, y + 1), (x, y - 1), (x + 1, y), (x - 1, y)):
                        if 0 <= nx < w and 0 <= ny < h and hmap[nx][ny] == 0:
                            cliff_mask[x][y] = 1
                            break

        # 2. Structural Staircases
        stairs: List[StairConnection] = []

        # Stair 1: West Residential Ascent (connecting valley to western terrace)
        st1_x, st1_y = 22, 33
        stairs.append(
            StairConnection(
                id="stair_west_terrace",
                from_level=0,
                to_level=1,
                x=st1_x,
                y=st1_y,
                width=3,
                length=2,
                orientation="north",
                walkable_bounds=(st1_x, st1_y - 1, st1_x + 2, st1_y + 2),
            )
        )

        # Stair 2: North Central Pass
        st2_x, st2_y = 31, 14
        stairs.append(
            StairConnection(
                id="stair_north_pass",
                from_level=0,
                to_level=1,
                x=st2_x,
                y=st2_y,
                width=3,
                length=2,
                orientation="north",
                walkable_bounds=(st2_x, st2_y - 1, st2_x + 2, st2_y + 2),
            )
        )

        # Stair 3: East Cafe Terrace Ascent
        st3_x, st3_y = 44, 25
        stairs.append(
            StairConnection(
                id="stair_cafe_terrace",
                from_level=0,
                to_level=1,
                x=st3_x,
                y=st3_y,
                width=3,
                length=2,
                orientation="north",
                walkable_bounds=(st3_x, st3_y - 1, st3_x + 2, st3_y + 2),
            )
        )

        # Clear cliff mask at stair locations
        for st in stairs:
            for sx in range(st.x - 1, st.x + st.width + 1):
                for sy in range(st.y - 1, st.y + st.length + 1):
                    if 0 <= sx < w and 0 <= sy < h:
                        cliff_mask[sx][sy] = 0

        # 3. River & Waterways
        water_mask = [[0 for _ in range(h)] for _ in range(w)]
        river_base_x = 42
        for y in range(h):
            rx = river_base_x + int(3.0 * math.sin(y * 0.18))
            for dx in range(-2, 3):
                if 0 <= rx + dx < w:
                    water_mask[rx + dx][y] = 1

        # Clear water at stairs
        for st in stairs:
            for sx in range(st.x - 2, st.x + st.width + 3):
                for sy in range(st.y - 2, st.y + st.length + 3):
                    if 0 <= sx < w and 0 <= sy < h:
                        water_mask[sx][sy] = 0

        # 4. Districts & Road Hierarchy
        districts = [
            District(id="district_plaza", district_type=DistrictType.PLAZA, center_x=31, center_y=42, radius=8, elevation=0, bounds=(23, 34, 39, 50)),
            District(id="district_residential", district_type=DistrictType.RESIDENTIAL, center_x=12, center_y=20, radius=12, elevation=1, bounds=(2, 6, 22, 32)),
            District(id="district_cafe", district_type=DistrictType.COMMERCIAL, center_x=48, center_y=16, radius=10, elevation=1, bounds=(36, 6, 60, 24)),
            District(id="district_waterfront", district_type=DistrictType.WATERFRONT, center_x=42, center_y=42, radius=6, elevation=0, bounds=(38, 36, 46, 48)),
        ]

        road_mask = [[0 for _ in range(h)] for _ in range(w)]

        # Southern Entrance Avenue (Width 4, Cobblestone)
        for y in range(48, h - 1):
            for x in range(29, 34):
                road_mask[x][y] = 2

        # Central Plaza Hub (Radius 7)
        for x in range(24, 39):
            for y in range(36, 49):
                dist = math.sqrt((x - 31) ** 2 + (y - 42) ** 2)
                if dist <= 7.0:
                    road_mask[x][y] = 2

        # Road West to Western Stairs
        for x in range(12, 28):
            for y in range(32, 35):
                road_mask[x][y] = 1

        # Western Residential Street
        for y in range(12, 34):
            for x in range(10, 13):
                road_mask[x][y] = 1
        for x in range(4, 22):
            for y in range(18, 21):
                road_mask[x][y] = 1

        # Road East across River Bridge to East Terrace
        for x in range(36, 52):
            for y in range(40, 43):
                road_mask[x][y] = 2

        # Road to Cafe on Upper East Terrace
        for y in range(16, 27):
            for x in range(44, 47):
                road_mask[x][y] = 1
        for x in range(44, 56):
            for y in range(16, 19):
                road_mask[x][y] = 1

        # 5. Buildings Allocation (Exact Metano Ensemble)
        parcels: List[Parcel] = []
        buildings: List[PlacedStructure] = []

        # 5.1 Kecleon Shop (at Plaza hub: 35, 38)
        p_shop = Parcel(
            id="parcel_kecleon_shop", district_id="district_plaza",
            bounds=(34, 37, 5, 5), elevation=0, front_road_side="south",
            road_connection_point=(36, 42), door_target_pos=(36, 41),
            clearance=1, assigned_structure_id="shop",
        )
        parcels.append(p_shop)
        buildings.append(
            PlacedStructure(
                instance_id="metano_kecleon_shop", prefab_id="shop", role="shop",
                x=34, y=37, width=5, height=5, elevation=0,
                door_map_pos=(36, 41), door_warp_target="interior_shop",
                parcel_id=p_shop.id,
            )
        )

        # 5.2 Metano Inn (South Plaza: 22, 44)
        p_inn = Parcel(
            id="parcel_inn", district_id="district_plaza",
            bounds=(20, 43, 8, 6), elevation=0, front_road_side="south",
            road_connection_point=(24, 49), door_target_pos=(24, 48),
            clearance=1, assigned_structure_id="inn",
        )
        parcels.append(p_inn)
        buildings.append(
            PlacedStructure(
                instance_id="metano_inn", prefab_id="inn", role="inn",
                x=20, y=43, width=8, height=6, elevation=0,
                door_map_pos=(24, 48), door_warp_target="interior_inn",
                parcel_id=p_inn.id,
            )
        )

        # 5.3 Spinda Cafe (Upper East Terrace: 46, 10)
        p_cafe = Parcel(
            id="parcel_cafe", district_id="district_cafe",
            bounds=(46, 9, 8, 6), elevation=1, front_road_side="south",
            road_connection_point=(50, 16), door_target_pos=(50, 14),
            clearance=1, assigned_structure_id="pokemon_center",
        )
        parcels.append(p_cafe)
        buildings.append(
            PlacedStructure(
                instance_id="metano_cafe", prefab_id="pokemon_center", role="cafe",
                x=46, y=9, width=8, height=6, elevation=1,
                door_map_pos=(50, 14), door_warp_target="interior_cafe",
                parcel_id=p_cafe.id,
            )
        )

        # 5.4 Residential Homes (Upper West Terrace)
        # Normal Home (4, 12)
        p_norm = Parcel(
            id="parcel_house_normal", district_id="district_residential",
            bounds=(4, 12, 4, 4), elevation=1, front_road_side="south",
            road_connection_point=(6, 18), door_target_pos=(6, 15),
            clearance=1, assigned_structure_id="house_small",
        )
        parcels.append(p_norm)
        buildings.append(
            PlacedStructure(
                instance_id="house_normal", prefab_id="house_small", role="residential",
                x=4, y=12, width=4, height=4, elevation=1,
                door_map_pos=(6, 15), door_warp_target="interior_normal_home",
                parcel_id=p_norm.id,
            )
        )

        # Rock Home (14, 12)
        p_rock = Parcel(
            id="parcel_house_rock", district_id="district_residential",
            bounds=(14, 12, 5, 4), elevation=1, front_road_side="south",
            road_connection_point=(16, 18), door_target_pos=(16, 15),
            clearance=1, assigned_structure_id="house_medium",
        )
        parcels.append(p_rock)
        buildings.append(
            PlacedStructure(
                instance_id="house_rock", prefab_id="house_medium", role="residential",
                x=14, y=12, width=5, height=4, elevation=1,
                door_map_pos=(16, 15), door_warp_target="interior_rock_home",
                parcel_id=p_rock.id,
            )
        )

        # Fire Home (4, 22)
        p_fire = Parcel(
            id="parcel_house_fire", district_id="district_residential",
            bounds=(4, 22, 6, 5), elevation=1, front_road_side="south",
            road_connection_point=(6, 28), door_target_pos=(7, 26),
            clearance=1, assigned_structure_id="house_large",
        )
        parcels.append(p_fire)
        buildings.append(
            PlacedStructure(
                instance_id="house_fire", prefab_id="house_large", role="residential",
                x=4, y=22, width=6, height=5, elevation=1,
                door_map_pos=(7, 26), door_warp_target="interior_fire_home",
                parcel_id=p_fire.id,
            )
        )

        # 5.5 Plaza Fountain (Center: 29, 39)
        p_fountain = Parcel(
            id="parcel_fountain", district_id="district_plaza",
            bounds=(29, 39, 4, 4), elevation=0, front_road_side="south",
            road_connection_point=(31, 44), door_target_pos=(31, 42),
            clearance=1, assigned_structure_id="fountain",
        )
        parcels.append(p_fountain)
        buildings.append(
            PlacedStructure(
                instance_id="metano_fountain", prefab_id="fountain", role="monument",
                x=29, y=39, width=4, height=4, elevation=0,
                door_map_pos=(31, 42), door_warp_target="",
                parcel_id=p_fountain.id,
            )
        )

        # 6. Vegetation & Trees (Perimeter buffer + Courtyard shade trees)
        vegetation: List[PlacedVegetation] = []
        decorations: List[PlacedDecoration] = []

        # Perimeter tree border
        tree_id = 1
        for x in range(1, w - 2, 3):
            for y in (1, 2, h - 3, h - 2):
                if not (28 <= x <= 34 and y >= h - 4):  # Don't block main entrance
                    vegetation.append(
                        PlacedVegetation(
                            id=f"tree_{tree_id}", veg_type="tree_large",
                            x=x, y=y, width=3, height=3, elevation=hmap[x][y],
                            trunk_bounds=(x, y + 1, 2, 1), canopy_bounds=(x - 1, y - 1, 3, 3),
                        )
                    )
                    tree_id += 1

        for y in range(4, h - 4, 4):
            for x in (1, w - 3):
                vegetation.append(
                    PlacedVegetation(
                        id=f"tree_{tree_id}", veg_type="tree_large",
                        x=x, y=y, width=3, height=3, elevation=hmap[x][y],
                        trunk_bounds=(x, y + 1, 2, 1), canopy_bounds=(x - 1, y - 1, 3, 3),
                    )
                )
                tree_id += 1

        # Terrace garden trees
        garden_tree_spots = [(12, 8), (22, 16), (22, 24), (38, 12), (56, 22), (52, 36), (48, 50)]
        for gx, gy in garden_tree_spots:
            vegetation.append(
                PlacedVegetation(
                    id=f"tree_{tree_id}", veg_type="tree_large",
                    x=gx, y=gy, width=3, height=3, elevation=hmap[gx][gy],
                    trunk_bounds=(gx, gy + 1, 2, 1), canopy_bounds=(gx - 1, gy - 1, 3, 3),
                )
            )
            tree_id += 1

        # 7. Street Decorations (Signposts, Lampposts, Benches)
        decorations.append(
            PlacedDecoration(
                id="sign_welcome", prop_type="signpost",
                x=33, y=52, width=1, height=1, elevation=0,
                collision_type=TileCollision.SIGN,
                text_lines=["Welcome to Metano Town!", "Center of Trade & Adventure", ""],
            )
        )
        decorations.append(
            PlacedDecoration(
                id="sign_cafe", prop_type="signpost",
                x=45, y=12, width=1, height=1, elevation=1,
                collision_type=TileCollision.SIGN,
                text_lines=["Spinda's Cafe", "Best Gummi Drinks in the World!", ""],
            )
        )
        decorations.append(
            PlacedDecoration(
                id="sign_shop", prop_type="signpost",
                x=33, y=41, width=1, height=1, elevation=0,
                collision_type=TileCollision.SIGN,
                text_lines=["Kecleon Shop", "High quality items and orbs!", ""],
            )
        )

        # Lampposts
        lamp_spots = [(28, 50), (34, 50), (24, 40), (38, 40), (44, 38), (48, 18), (14, 20)]
        for idx, (lx, ly) in enumerate(lamp_spots, 1):
            decorations.append(
                PlacedDecoration(
                    id=f"lamp_{idx}", prop_type="lamppost",
                    x=lx, y=ly, width=1, height=2, elevation=hmap[lx][ly],
                    collision_type=TileCollision.BLOCKED,
                )
            )

        # 8. Terrain Matrix & Collision Assembly
        terrain_types = [["grass" for _ in range(h)] for _ in range(w)]
        for x in range(w):
            for y in range(h):
                if water_mask[x][y] == 1:
                    terrain_types[x][y] = "water"
                elif cliff_mask[x][y] == 1:
                    terrain_types[x][y] = "cliff"
                elif road_mask[x][y] > 0:
                    terrain_types[x][y] = "dirt"

        validator = TownValidator(spec)
        collision_grid = validator.build_collision_grid(
            hmap, cliff_mask, road_mask, water_mask, stairs, buildings, vegetation, decorations, w, h
        )

        # 9. Validation & Scoring
        report = validator.validate(
            hmap, cliff_mask, road_mask, stairs, buildings, vegetation, decorations, collision_grid, w, h
        )

        layout = TownLayout(
            spec=spec,
            width=w,
            height=h,
            heightmap=hmap,
            terrain_types=terrain_types,
            cliff_mask=cliff_mask,
            water_mask=water_mask,
            road_mask=road_mask,
            stairs=stairs,
            districts=districts,
            parcels=parcels,
            buildings=buildings,
            vegetation=vegetation,
            decorations=decorations,
            collision=collision_grid,
            validation=report,
        )

        visual_validator = VisualQualityValidator(spec)
        visual_score, _ = visual_validator.evaluate(layout)
        layout.visual_score = visual_score

        # Composite score
        gameplay_val = report.score.connectivity
        geom_val = (report.score.geometry + report.score.elevation + report.score.cliffs + report.score.stairs) / 4.0
        vis_val = visual_score.total_visual_score
        pmdo_val = 100.0 if report.status == "PASS" else 70.0
        layout.composite_score = round((0.35 * gameplay_val) + (0.25 * geom_val) + (0.20 * vis_val) + (0.20 * pmdo_val), 1)

        return layout

    def render_metano_canonical(self, layout: TownLayout, tile_size: int = 24) -> Image.Image:
        """Renders Metano Town with exact PMD canonical colorimetry and real sprites."""
        w, h = layout.width, layout.height
        ts = tile_size
        img = Image.new("RGBA", (w * ts, h * ts), METANO_PALETTE["grass_level_0"])
        draw = ImageDraw.Draw(img)

        # 1. Base Grass with Subtle PMD Texture
        for x in range(w):
            for y in range(h):
                elev = layout.heightmap[x][y]
                base_c = METANO_PALETTE["grass_level_1"] if elev == 1 else METANO_PALETTE["grass_level_0"]
                jitter_val = int(5.0 * math.sin((x * 13 + y * 19) * 0.5))
                c = (
                    max(0, min(255, base_c[0] + jitter_val)),
                    max(0, min(255, base_c[1] + jitter_val)),
                    max(0, min(255, base_c[2] + jitter_val)),
                    255,
                )
                draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=c)

        # 2. Turquoise River & Wooden Bridges
        for x in range(w):
            for y in range(h):
                if layout.water_mask[x][y] == 1:
                    if layout.road_mask[x][y] > 0:
                        # Wooden Plank Bridge
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["bridge_wood"])
                        draw.line((x * ts, y * ts + ts // 2, (x + 1) * ts - 1, y * ts + ts // 2), fill=METANO_PALETTE["bridge_rail"], width=1)
                    else:
                        draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["river_deep"])
                        if (x + y) % 3 == 0:
                            draw.line((x * ts + 2, y * ts + ts // 2, (x + 1) * ts - 3, y * ts + ts // 2), fill=METANO_PALETTE["river_shallow"], width=1)

        # 3. Cobblestone Plaza & Sandy Roads
        for x in range(w):
            for y in range(h):
                rm = layout.road_mask[x][y]
                if rm == 2:  # Primary Avenue / Plaza
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["road_plaza"])
                    draw.rectangle((x * ts + 1, y * ts + 1, (x + 1) * ts - 2, (y + 1) * ts - 2), outline=METANO_PALETTE["road_plaza_grid"], width=1)
                elif rm == 1:  # Dirt Street
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["road_dirt"])

        # 4. Ochre Cliffs with Shaded Rock Faces & Top Grass Lip
        for x in range(w):
            for y in range(h):
                if layout.cliff_mask[x][y] == 1:
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["cliff_face"])
                    draw.rectangle((x * ts, y * ts + (2 * ts // 3), (x + 1) * ts - 1, (y + 1) * ts - 1), fill=METANO_PALETTE["cliff_shadow"])
                    draw.rectangle((x * ts, y * ts, (x + 1) * ts - 1, y * ts + 4), fill=METANO_PALETTE["cliff_lip"])

        # 5. Integrated Stone Stairs
        for st in layout.stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y, st.y + st.length):
                    if 0 <= sx < w and 0 <= sy < h:
                        draw.rectangle((sx * ts, sy * ts, (sx + 1) * ts - 1, (sy + 1) * ts - 1), fill=METANO_PALETTE["stair_stone"])
                        for step_i in range(3):
                            step_y = sy * ts + step_i * (ts // 3)
                            draw.line((sx * ts, step_y, (sx + 1) * ts - 1, step_y), fill=METANO_PALETTE["stair_step"], width=2)
            draw.rectangle((st.x * ts - 2, st.y * ts, st.x * ts + 2, (st.y + st.length) * ts - 1), fill=METANO_PALETTE["bridge_rail"])
            draw.rectangle(((st.x + st.width) * ts - 2, st.y * ts, (st.x + st.width) * ts + 2, (st.y + st.length) * ts - 1), fill=METANO_PALETTE["bridge_rail"])

        # 6. Real Pixel Art Building Stamps
        for b in layout.buildings:
            bx, by, bw, bh = b.x, b.y, b.width, b.height
            sprite = self.library.get_sprite(b.prefab_id)
            if sprite:
                target_w = bw * ts
                target_h = bh * ts
                scaled_sprite = sprite.resize((target_w, target_h), Image.Resampling.NEAREST)
                img.alpha_composite(scaled_sprite, (bx * ts, by * ts))

        # 7. Trees (Multi-layer)
        for veg in layout.vegetation:
            tx, ty, tw, th = veg.trunk_bounds
            cx, cy, cw, ch = veg.canopy_bounds
            draw.rectangle((tx * ts + 4, ty * ts + 4, (tx + tw) * ts - 5, (ty + th) * ts - 1), fill=METANO_PALETTE["tree_trunk"])
            draw.ellipse((cx * ts, cy * ts, (cx + cw) * ts - 1, (cy + ch) * ts - 1), fill=METANO_PALETTE["tree_canopy_base"], outline=METANO_PALETTE["tree_canopy_edge"], width=2)
            draw.ellipse((cx * ts + 4, cy * ts + 2, (cx + cw) * ts - 6, cy * ts + (ch * ts // 2)), fill=METANO_PALETTE["tree_canopy_dome"])

        # 8. Street Props
        for dec in layout.decorations:
            dx, dy, dw, dh = dec.x, dec.y, dec.width, dec.height
            if dec.prop_type == "signpost":
                draw.rectangle((dx * ts + 6, dy * ts + 4, (dx + 1) * ts - 7, (dy + 1) * ts - 2), fill=(160, 110, 50, 255), outline=(60, 40, 20, 255))
            elif dec.prop_type == "lamppost":
                draw.rectangle((dx * ts + 9, dy * ts + 4, (dx + 1) * ts - 10, (dy + dh) * ts - 2), fill=(60, 65, 70, 255))
                draw.ellipse((dx * ts + 5, dy * ts, (dx + 1) * ts - 6, dy * ts + ts // 2), fill=(255, 235, 130, 255))

        return img

    def execute_and_export(self, out_dir: Optional[Path] = None) -> Tuple[TownLayout, Dict[str, Path]]:
        """Generates, renders, and exports full Metano Town recreation."""
        layout = self.build_metano_layout()
        target_dir = out_dir or (self.project_root / "data/pmu_imports/metano_town_recreated")
        target_dir.mkdir(parents=True, exist_ok=True)

        render_dir = self.project_root / "docs/pmu_maps/renders/metano_town_recreated"
        render_dir.mkdir(parents=True, exist_ok=True)

        final_img = self.render_metano_canonical(layout, tile_size=24)
        final_img.save(render_dir / "final.png", optimize=True)
        final_img.save(render_dir / "preview.png", optimize=True)

        from .renderer import TownRenderer
        r = TownRenderer(tile_size=24, project_root=self.project_root)
        r.render_layout(layout).save(render_dir / "layout.png", optimize=True)
        r.render_elevation(layout).save(render_dir / "elevation.png", optimize=True)
        r.render_cliffs(layout).save(render_dir / "cliffs.png", optimize=True)
        r.render_collision(layout).save(render_dir / "collision.png", optimize=True)
        r.render_navigation(layout).save(render_dir / "navigation.png", optimize=True)

        artifacts = self.exporter.export(layout, target_dir)
        return layout, artifacts
