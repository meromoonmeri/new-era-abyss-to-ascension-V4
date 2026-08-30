<<<<<<< HEAD
"""Master Town Layout Generator for PMDO.

Orchestrates the complete 16-stage deterministic procedural generation pipeline,
incorporating reference-style layout synthesis, PixelLab tileset/stamp engines,
and dual-engine validation.
"""
from __future__ import annotations

import json
import math
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

from .autotiler import Autotiler
from .elevation_engine import ElevationEngine
from .models import (
    BiomeType,
    SeasonType,
    TileCollision,
    TownLayout,
    TownSpec,
    ValidationReport,
)
from .parcel_engine import ParcelEngine
from .pixellab_client import PixelLabClient
from .pixellab_tileset_engine import PixelLabTilesetEngine
from .pmdo_exporter import PMDOExporter
from .renderer import TownRenderer
from .road_network import RoadNetworkEngine
from .structure_library import StructureLibrary
from .validator import TownValidator
from .vegetation_engine import VegetationEngine
from .visual_validator import VisualQualityScore, VisualQualityValidator


class TownGenerator:
    def __init__(
        self,
        project_root: Optional[Path] = None,
        pixellab_client: Optional[PixelLabClient] = None,
    ):
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.pixellab_client = pixellab_client or PixelLabClient(project_root=self.project_root)
        self.library = StructureLibrary(self.project_root, pixellab_client=self.pixellab_client)
        self.tileset_engine = PixelLabTilesetEngine(
            client=self.pixellab_client,
            tile_size=24,
            project_root=self.project_root,
        )
        self.exporter = PMDOExporter(self.project_root)

    def generate(self, spec: TownSpec) -> TownLayout:
        """Executes full 16-stage procedural generation pipeline."""
        # 1. Apply reference style presets if specified
        active_spec = TownSpec.from_dict(spec.to_dict())
        if active_spec.reference_style == "metano":
            active_spec.has_river = True
            active_spec.river_side = "east"
            active_spec.elevation_levels = 2
            if not active_spec.structures or len(active_spec.structures) == 0:
                active_spec.structures = {
                    "pokemon_center": 1,
                    "shop": 1,
                    "inn": 1,
                    "fountain": 1,
                    "house_small": 3,
                    "house_medium": 2,
                    "house_large": 1,
                }
        elif active_spec.reference_style == "grasstown":
            active_spec.has_river = False
            active_spec.elevation_levels = 2
            if not active_spec.structures or len(active_spec.structures) == 0:
                active_spec.structures = {
                    "shop": 1,
                    "inn": 1,
                    "fountain": 1,
                    "house_small": 4,
                    "house_medium": 3,
                    "house_large": 2,
                    "well": 1,
                }

        w, h = active_spec.width, active_spec.height

        # Stage 4-7: Elevation, Water, Cliffs, Stairs
        elev_engine = ElevationEngine(active_spec)
        hmap, cliff_mask, stairs = elev_engine.generate()

        # Water feature (River if requested)
        water_mask = [[0 for _ in range(h)] for _ in range(w)]
        if active_spec.has_river:
            river_x_base = int(w * 0.85) if active_spec.river_side == "east" else int(w * 0.15)
            for y in range(h):
                rx = river_x_base + int(2.0 * math.sin(y * 0.35))
                for dx in range(-2, 3):
                    if 0 <= rx + dx < w:
                        water_mask[rx + dx][y] = 1

        # Clear water from stair landings to prevent submerged stairs
        for st in stairs:
            for sx in range(st.x - 1, st.x + st.width + 2):
                for sy in range(st.y - 2, st.y + st.length + 3):
                    if 0 <= sx < w and 0 <= sy < h:
                        water_mask[sx][sy] = 0

        # Stage 8-9: Primary Terrain & Road Network
        road_engine = RoadNetworkEngine(active_spec)
        road_mask, districts, road_nodes, road_edges = road_engine.generate(hmap, cliff_mask, stairs)

        # Base terrain types matrix
        terrain_types = [["grass" for _ in range(h)] for _ in range(w)]
        for x in range(w):
            for y in range(h):
                if water_mask[x][y] == 1:
                    terrain_types[x][y] = "water"
                elif cliff_mask[x][y] == 1:
                    terrain_types[x][y] = "cliff"
                elif road_mask[x][y] > 0:
                    terrain_types[x][y] = "dirt"

        # Stage 10-11: Parcels & Building Stamping via PixelLab
        parcel_engine = ParcelEngine(active_spec, self.library)
        parcels, buildings = parcel_engine.generate(hmap, cliff_mask, road_mask, stairs, districts)

        # Stage 12-13: Trees, Foliage & Street Decorations
        veg_engine = VegetationEngine(active_spec)
        vegetation, decorations = veg_engine.generate(
            hmap, cliff_mask, road_mask, water_mask, stairs, parcels, buildings
        )

        # Stage 14: Autotiling
        # Autotiler handles border adjacency transitions

        # Stage 15: Collision Assembly
        validator = TownValidator(active_spec)
        collision_grid = validator.build_collision_grid(
            hmap, cliff_mask, road_mask, water_mask, stairs, buildings, vegetation, decorations, w, h
        )

        # Stage 16: Technical Validation
        report = validator.validate(
            hmap, cliff_mask, road_mask, stairs, buildings, vegetation, decorations, collision_grid, w, h
        )

        # Stage 17: Visual Quality Validation
        visual_validator = VisualQualityValidator(active_spec)
        layout_temp = TownLayout(
            spec=active_spec,
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
        visual_score, visual_notes = visual_validator.evaluate(layout_temp)
        layout_temp.visual_score = visual_score

        # Composite Score Calculation
        # Weights: 35% Gameplay, 25% Geometry, 20% Visual Quality, 20% PMDO Export
        gameplay_val = report.score.connectivity
        geom_val = (report.score.geometry + report.score.elevation + report.score.cliffs + report.score.stairs) / 4.0
        vis_val = visual_score.total_visual_score
        pmdo_val = 100.0 if report.status == "PASS" else 70.0

        composite = (0.35 * gameplay_val) + (0.25 * geom_val) + (0.20 * vis_val) + (0.20 * pmdo_val)
        layout_temp.composite_score = round(composite, 1)

        return layout_temp

    def generate_and_export(
        self, spec: TownSpec, out_dir: Optional[Path] = None, render_passes: bool = True
    ) -> Tuple[TownLayout, Dict[str, Path]]:
        """Generates layout, saves all render passes, and exports PMDO native bundle."""
        layout = self.generate(spec)

        target_dir = out_dir or (self.project_root / "data/pmu_imports" / spec.name)
        target_dir.mkdir(parents=True, exist_ok=True)

        render_dir = self.project_root / "docs/pmu_maps/renders" / spec.name
        render_dir.mkdir(parents=True, exist_ok=True)

        renderer = TownRenderer(
            tile_size=24,
            project_root=self.project_root,
            pixellab_client=self.pixellab_client,
        )
        if render_passes:
            final_img = renderer.render_final(layout)
            final_img.save(render_dir / "final.png", optimize=True)
            final_img.save(render_dir / "preview.png", optimize=True)

            layout_img = renderer.render_layout(layout)
            layout_img.save(render_dir / "layout.png", optimize=True)

            elev_img = renderer.render_elevation(layout)
            elev_img.save(render_dir / "elevation.png", optimize=True)

            cliff_img = renderer.render_cliffs(layout)
            cliff_img.save(render_dir / "cliffs.png", optimize=True)

            col_img = renderer.render_collision(layout)
            col_img.save(render_dir / "collision.png", optimize=True)

            nav_img = renderer.render_navigation(layout)
            nav_img.save(render_dir / "navigation.png", optimize=True)

        artifacts = self.exporter.export(layout, target_dir)
        return layout, artifacts

    def generate_variants(self, base_spec: TownSpec, count: int = 5) -> List[TownLayout]:
        """Generates multiple distinct layout variants from the same high-level intent."""
        variants: List[TownLayout] = []
        for i in range(count):
            var_spec = TownSpec.from_dict(base_spec.to_dict())
            var_spec.name = f"{base_spec.name}_var_{chr(ord('a') + i)}"
            var_spec.display_name = f"{base_spec.display_name} (Variant {chr(ord('A') + i)})"
            var_spec.seed = base_spec.seed + (i + 1) * 7777
            layout = self.generate(var_spec)
            variants.append(layout)
        return variants

    def generate_batch_and_rank(self, base_spec: TownSpec, count: int = 20) -> List[TownLayout]:
        """Generates a batch of N layouts and ranks them by composite score descending."""
        batch: List[TownLayout] = []
        for i in range(count):
            spec = TownSpec.from_dict(base_spec.to_dict())
            spec.name = f"{base_spec.name}_seed_{i+1:03d}"
            spec.seed = base_spec.seed + (i * 1337) + 42
            layout = self.generate(spec)
            batch.append(layout)

        # Sort by composite score descending
        batch.sort(key=lambda l: l.composite_score, reverse=True)
        return batch
=======
"""Master 16-stage pipeline generator for procedural PMDO towns."""
from __future__ import annotations

import random
from pathlib import Path
from typing import List, Optional, Tuple

from .hybrid_town_synthesizer import HybridTownSynthesizer
from .models import TownLayout, TownSpec
from .pixellab_client import PixelLabClient


class TownGenerator:
    """Generates towns across procedural seeds and variants."""

    def __init__(self, pixellab_client: Optional[PixelLabClient] = None, project_root: Optional[Path] = None):
        self.client = pixellab_client or PixelLabClient()
        self.project_root = project_root or Path(__file__).resolve().parents[2]
        self.synth = HybridTownSynthesizer(pixellab_client=self.client, project_root=self.project_root)

    def generate_and_export(self, spec: TownSpec, out_dir: Optional[Path] = None) -> Tuple[TownLayout, dict]:
        return self.synth.synthesize_waterfall_haven(spec.name, spec.display_name, spec.seed)

    def generate_variants(self, spec: TownSpec, count: int = 5) -> List[TownLayout]:
        results = []
        for i in range(count):
            s = TownSpec(
                name=f"{spec.name}_var_{i+1}",
                display_name=f"{spec.display_name} Var #{i+1}",
                seed=spec.seed + i * 101,
            )
            layout, _ = self.generate_and_export(s)
            results.append(layout)
        return results

    def generate_batch_and_rank(self, spec: TownSpec, count: int = 20) -> List[TownLayout]:
        layouts = self.generate_variants(spec, count=count)
        layouts.sort(key=lambda l: l.composite_score, reverse=True)
        return layouts
>>>>>>> fab534f9 (feat(skytemple): Pipeline de creation et validation de maps PMD/PMDO conformes SkyTemple)
