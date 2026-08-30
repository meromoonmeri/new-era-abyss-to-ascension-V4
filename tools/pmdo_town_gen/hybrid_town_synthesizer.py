"""Hybrid Town Synthesizer for PMDO Town Engine.

Composes canonical PMDO foundations with PixelLab procedural innovations:
- Canonical PMDO terrain + multi-tier cliffs + stone stairs
- PixelLab-generated river, lake, and cascading 4-frame animated waterfalls (.dir)
- PixelLab multi-frame animated campfires, torches, and river ripples
- Canonical + PixelLab building stamps and multi-layer canopy foliage
- 8x8 sub-cell obstacle tagging, 11-layer ground compilation, and 100% pathfinding reachability.
"""
from __future__ import annotations

import io
import math
import random
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from PIL import Image, ImageDraw

from .animation_engine import AnimationEngine
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
from .pixellab_client import PixelLabClient
from .pixellab_structure_engine import PixelLabStructureEngine
from .pixellab_tileset_engine import PixelLabTilesetEngine
from .pmdo_exporter import PMDOExporter
from .renderer import TownRenderer
from .validator import TownValidator
from .visual_validator import VisualQualityValidator


class HybridTownSynthesizer:
    """Master synthesizer creating novel PMDO towns combining canonical assets & PixelLab generations."""

    def __init__(
        self,
        project_root: Optional[Path] = None,
        pixellab_client: Optional[PixelLabClient] = None,
    ):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.pixellab_client = pixellab_client or PixelLabClient(project_root=self.project_root)
        self.tileset_engine = PixelLabTilesetEngine(
            client=self.pixellab_client,
            tile_size=24,
            project_root=self.project_root,
        )
        self.struct_engine = PixelLabStructureEngine(
            client=self.pixellab_client,
            tile_size=24,
            project_root=self.project_root,
        )
        self.anim_engine = AnimationEngine(self.project_root)
        self.exporter = PMDOExporter(self.project_root)

    def synthesize_waterfall_haven(
        self,
        name: str = "metano_waterfall_haven",
        display_name: str = "Metano Waterfall Haven",
        seed: int = 20260830,
        width: int = 63,
        height: int = 63,
    ) -> Tuple[TownLayout, Dict[str, Path]]:
        """Synthesizes a new hybrid town layout featuring a Level 1 plateau, waterfall cascade, and river lake."""
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

        # 1. Multi-tier Topography (Highland North-East Plateau & Lowland Valley)
        hmap = [[0 for _ in range(h)] for _ in range(w)]
        cliff_mask = [[0 for _ in range(h)] for _ in range(w)]

        for x in range(w):
            for y in range(h):
                # North-East Mountain Plateau: Level 1 (Y <= 24, X >= 28)
                is_ne_plateau = (y <= 22 + int(3.0 * math.cos(x * 0.25)) and x >= 26)
                # West Terrace: Level 1 (X <= 22, Y <= 32)
                is_west_terrace = (x <= 22 and y <= 32 + int(2.0 * math.sin(x * 0.4)))
                # Far North Peak: Level 1
                is_far_north = (y <= 12)

                if is_ne_plateau or is_west_terrace or is_far_north:
                    hmap[x][y] = 1
                else:
                    hmap[x][y] = 0

        # Guarantee Southern Entrance and Central Basin are Level 0
        for x in range(24, 40):
            for y in range(30, h):
                hmap[x][y] = 0

        # Create Cliff Boundaries
        for x in range(w):
            for y in range(h):
                if hmap[x][y] == 0:
                    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                        nx, ny = x + dx, y + dy
                        if 0 <= nx < w and 0 <= ny < h and hmap[nx][ny] == 1:
                            if dy == -1:
                                cliff_mask[x][y] = 1

        # 2. PixelLab Procedural River & Waterfall Basin
        water_mask = [[0 for _ in range(h)] for _ in range(w)]

        # River originates on Highland Plateau (Level 1, X: 48..52, Y: 0..20)
        for y in range(0, 22):
            rx = 48 + int(2.0 * math.sin(y * 0.2))
            for dx in range(-2, 3):
                if 0 <= rx + dx < w:
                    water_mask[rx + dx][y] = 1

        # Waterfall Location: Cliff drop at (X: 47..51, Y: 21..24) connecting Level 1 to Level 0
        waterfall_x, waterfall_y = 47, 21
        for wx in range(waterfall_x, waterfall_x + 5):
            for wy in range(waterfall_y, waterfall_y + 4):
                if 0 <= wx < w and 0 <= wy < h:
                    water_mask[wx][wy] = 1
                    cliff_mask[wx][wy] = 0

        # Waterfall Impact Lake (Level 0, X: 42..56, Y: 24..34)
        for y in range(24, 35):
            for x in range(42, 58):
                dist = math.sqrt(((x - 49) / 7.0) ** 2 + ((y - 29) / 5.0) ** 2)
                if dist <= 1.0:
                    water_mask[x][y] = 1
                    cliff_mask[x][y] = 0

        # Downstream River corridor (Level 0, Y: 34..h-1)
        for y in range(34, h):
            rx = 50 + int(3.0 * math.sin(y * 0.16))
            for dx in range(-2, 3):
                if 0 <= rx + dx < w:
                    water_mask[rx + dx][y] = 1

        # 3. Stairs Connections
        stairs: List[StairConnection] = [
            StairConnection(
                id="stair_west_terrace", x=20, y=33, width=3, length=2,
                from_level=0, to_level=1, orientation="north",
                walkable_bounds=(20, 32, 22, 35),
            ),
            StairConnection(
                id="stair_waterfall_lookout", x=38, y=20, width=3, length=2,
                from_level=0, to_level=1, orientation="north",
                walkable_bounds=(38, 19, 40, 22),
            ),
        ]
        for st in stairs:
            for sx in range(st.x, st.x + st.width):
                for sy in range(st.y - 1, st.y + st.length + 1):
                    if 0 <= sx < w and 0 <= sy < h:
                        cliff_mask[sx][sy] = 0

        # 4. Roads & Plaza Network
        road_mask = [[0 for _ in range(h)] for _ in range(w)]

        # South Avenue (Cobblestone)
        for y in range(48, h - 1):
            for x in range(30, 34):
                road_mask[x][y] = 2

        # Central Basin Plaza (X: 24..40, Y: 34..48)
        for y in range(34, 49):
            for x in range(24, 41):
                dx = abs(x - 32)
                dy = abs(y - 41)
                if dx + dy <= 12:
                    road_mask[x][y] = 2

        # West Residential Lane
        for x in range(6, 22):
            road_mask[x][20] = 1
            road_mask[x][28] = 1
        for y in range(20, 33):
            road_mask[20][y] = 1
            road_mask[6][y] = 1

        # Waterfall Promenade & Lookout Road
        for x in range(32, 44):
            road_mask[x][34] = 1
        for y in range(22, 35):
            road_mask[38][y] = 1
        for x in range(38, 48):
            road_mask[x][16] = 1

        # Wooden Bridge across River (X: 46..56, Y: 44)
        for bx in range(44, 58):
            if water_mask[bx][44] == 1:
                road_mask[bx][44] = 2

        # 5. Districts & Buildings
        districts = [
            District(id="district_plaza", district_type=DistrictType.PLAZA, center_x=32, center_y=41, radius=8, elevation=0, bounds=(24, 34, 40, 48)),
            District(id="district_residential", district_type=DistrictType.RESIDENTIAL, center_x=12, center_y=24, radius=10, elevation=1, bounds=(4, 14, 22, 32)),
            District(id="district_waterfall", district_type=DistrictType.COMMERCIAL, center_x=44, center_y=16, radius=8, elevation=1, bounds=(34, 10, 56, 24)),
            District(id="district_waterfront", district_type=DistrictType.WATERFRONT, center_x=50, center_y=32, radius=8, elevation=0, bounds=(42, 24, 58, 48)),
        ]

        parcels: List[Parcel] = []
        buildings: List[PlacedStructure] = []

        # 5.1 Kecleon Shop (Central Plaza: 36, 36)
        p_shop = Parcel(
            id="p_shop", district_id="district_plaza",
            bounds=(36, 36, 4, 3), elevation=0, front_road_side="south",
            road_connection_point=(38, 40), door_target_pos=(38, 38),
            clearance=1, assigned_structure_id="shop",
        )
        parcels.append(p_shop)
        buildings.append(
            PlacedStructure(
                instance_id="haven_shop", prefab_id="shop", role="shop",
                x=36, y=36, width=4, height=3, elevation=0,
                door_map_pos=(38, 38), door_warp_target="interior_shop",
                parcel_id=p_shop.id,
            )
        )

        # 5.2 Waterfall Lookout Cafe (Spinda Cafe overlooking cascade: 40, 10)
        p_cafe = Parcel(
            id="p_cafe", district_id="district_waterfall",
            bounds=(40, 10, 5, 4), elevation=1, front_road_side="south",
            road_connection_point=(42, 16), door_target_pos=(42, 13),
            clearance=1, assigned_structure_id="pokemon_center",
        )
        parcels.append(p_cafe)
        buildings.append(
            PlacedStructure(
                instance_id="haven_cafe", prefab_id="pokemon_center", role="cafe",
                x=40, y=10, width=5, height=4, elevation=1,
                door_map_pos=(42, 13), door_warp_target="interior_cafe",
                parcel_id=p_cafe.id,
            )
        )

        # 5.3 Riverside Inn (South Plaza: 22, 42)
        p_inn = Parcel(
            id="p_inn", district_id="district_plaza",
            bounds=(22, 42, 4, 4), elevation=0, front_road_side="south",
            road_connection_point=(24, 47), door_target_pos=(24, 45),
            clearance=1, assigned_structure_id="inn",
        )
        parcels.append(p_inn)
        buildings.append(
            PlacedStructure(
                instance_id="haven_inn", prefab_id="inn", role="inn",
                x=22, y=42, width=4, height=4, elevation=0,
                door_map_pos=(24, 45), door_warp_target="interior_inn",
                parcel_id=p_inn.id,
            )
        )

        # 5.4 Residential Homes (West Terrace)
        p_h1 = Parcel(
            id="p_h1", district_id="district_residential",
            bounds=(6, 14, 3, 3), elevation=1, front_road_side="south",
            road_connection_point=(7, 20), door_target_pos=(7, 16),
            clearance=1, assigned_structure_id="house_small",
        )
        parcels.append(p_h1)
        buildings.append(
            PlacedStructure(
                instance_id="house_1", prefab_id="house_small", role="residential",
                x=6, y=14, width=3, height=3, elevation=1,
                door_map_pos=(7, 16), door_warp_target="interior_house_1",
                parcel_id=p_h1.id,
            )
        )

        p_h2 = Parcel(
            id="p_h2", district_id="district_residential",
            bounds=(14, 14, 4, 3), elevation=1, front_road_side="south",
            road_connection_point=(16, 20), door_target_pos=(16, 16),
            clearance=1, assigned_structure_id="house_medium",
        )
        parcels.append(p_h2)
        buildings.append(
            PlacedStructure(
                instance_id="house_2", prefab_id="house_medium", role="residential",
                x=14, y=14, width=4, height=3, elevation=1,
                door_map_pos=(16, 16), door_warp_target="interior_house_2",
                parcel_id=p_h2.id,
            )
        )

        p_h3 = Parcel(
            id="p_h3", district_id="district_residential",
            bounds=(6, 22, 4, 4), elevation=1, front_road_side="south",
            road_connection_point=(8, 28), door_target_pos=(8, 25),
            clearance=1, assigned_structure_id="house_large",
        )
        parcels.append(p_h3)
        buildings.append(
            PlacedStructure(
                instance_id="house_3", prefab_id="house_large", role="residential",
                x=6, y=22, width=4, height=4, elevation=1,
                door_map_pos=(8, 25), door_warp_target="interior_house_3",
                parcel_id=p_h3.id,
            )
        )

        # 5.5 Central Plaza Fountain (30, 39)
        p_fountain = Parcel(
            id="p_fountain", district_id="district_plaza",
            bounds=(30, 39, 3, 3), elevation=0, front_road_side="south",
            road_connection_point=(31, 43), door_target_pos=(31, 41),
            clearance=1, assigned_structure_id="fountain",
        )
        parcels.append(p_fountain)
        buildings.append(
            PlacedStructure(
                instance_id="haven_fountain", prefab_id="fountain", role="monument",
                x=30, y=39, width=3, height=3, elevation=0,
                door_map_pos=(31, 41), door_warp_target="",
                parcel_id=p_fountain.id,
            )
        )

        # 6. Multi-Layer Vegetation
        vegetation: List[PlacedVegetation] = []
        tree_id = 1
        for x in range(0, w, 3):
            for y in range(0, 7, 3):
                vegetation.append(
                    PlacedVegetation(
                        id=f"tree_{tree_id}", veg_type="tree_large",
                        x=x, y=y, width=3, height=3, elevation=hmap[x][y],
                        trunk_bounds=(x, y + 1, 2, 1), canopy_bounds=(x - 1, y - 1, 3, 3),
                    )
                )
                tree_id += 1

        for gx, gy in [(12, 10), (22, 18), (36, 12), (54, 18), (56, 36), (46, 50)]:
            vegetation.append(
                PlacedVegetation(
                    id=f"tree_{tree_id}", veg_type="tree_large",
                    x=gx, y=gy, width=3, height=3, elevation=hmap[gx][gy],
                    trunk_bounds=(gx, gy + 1, 2, 1), canopy_bounds=(gx - 1, gy - 1, 3, 3),
                )
            )
            tree_id += 1

        # 7. Animated Multi-Frame Assets & Street Decorations
        # Compile Waterfall .dir animation
        wf_asset = self.anim_engine.create_waterfall_animation(
            width=48, height=72, frame_count=4, asset_id="waterfall_cascade"
        )
        # Compile River Ripple .dir
        ripple_asset = self.anim_engine.create_river_ripple_animation(
            width=24, height=24, frame_count=4, asset_id="river_shimmer"
        )
        # Compile Campfire .dir
        fire_asset = self.anim_engine.create_campfire_animation(
            width=36, height=36, frame_count=4, asset_id="Campfire_haven"
        )

        decorations: List[PlacedDecoration] = [
            PlacedDecoration(
                id="sign_welcome", prop_type="signpost",
                x=32, y=52, width=1, height=1, elevation=0,
                collision_type=TileCollision.SIGN,
                text_lines=["Welcome to Waterfall Haven!", "Crystal waters and mountain breezes", ""],
            ),
            PlacedDecoration(
                id="sign_waterfall", prop_type="signpost",
                x=44, y=20, width=1, height=1, elevation=1,
                collision_type=TileCollision.SIGN,
                text_lines=["Waterfall Lookout Point", "Spinda's Cafe & Terrace", ""],
            ),
            PlacedDecoration(
                id="campfire_plaza", prop_type="campfire",
                x=28, y=44, width=2, height=2, elevation=0,
                collision_type=TileCollision.BLOCKED,
            ),
        ]

        # 8. Terrain Matrix & Collision Grid
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

        gameplay_val = report.score.connectivity
        geom_val = (report.score.geometry + report.score.elevation + report.score.cliffs + report.score.stairs) / 4.0
        vis_val = visual_score.total_visual_score
        pmdo_val = 100.0 if report.status == "PASS" else 70.0
        layout.composite_score = round((0.35 * gameplay_val) + (0.25 * geom_val) + (0.20 * vis_val) + (0.20 * pmdo_val), 1)

        # 9. Multi-pass Rendering & PMDO Native Export
        render_dir = self.project_root / "docs/pmu_maps/renders" / name
        render_dir.mkdir(parents=True, exist_ok=True)

        renderer = TownRenderer(
            tile_size=24,
            project_root=self.project_root,
            pixellab_client=self.pixellab_client,
        )
        final_img = renderer.render_final(layout)
        # Stamp the waterfall graphic onto the final render
        if len(wf_asset.frames) > 0:
            wf_frame = wf_asset.frames[0]
            final_img.alpha_composite(wf_frame, (waterfall_x * 24, waterfall_y * 24))

        final_img.save(render_dir / "final.png", optimize=True)
        final_img.save(render_dir / "preview.png", optimize=True)

        renderer.render_layout(layout).save(render_dir / "layout.png", optimize=True)
        renderer.render_elevation(layout).save(render_dir / "elevation.png", optimize=True)
        renderer.render_cliffs(layout).save(render_dir / "cliffs.png", optimize=True)
        renderer.render_collision(layout).save(render_dir / "collision.png", optimize=True)
        renderer.render_navigation(layout).save(render_dir / "navigation.png", optimize=True)

        artifacts = self.exporter.export(layout)
        return layout, artifacts
