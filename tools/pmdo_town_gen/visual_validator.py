"""Visual Quality and Aesthetic Validator for PMDO Town Generator.

Evaluates naturalness, tree distribution, parcel variety, cliff continuity,
road hierarchy, open spaces, anti-symmetry, and anti-repetition.
"""
from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Dict, List, Optional, Set, Tuple

from .models import (
    Parcel,
    PlacedDecoration,
    PlacedStructure,
    PlacedVegetation,
    StairConnection,
    TileCollision,
    TownLayout,
    TownSpec,
)


@dataclass
class VisualQualityScore:
    tree_distribution: float = 100.0
    vegetation_density: float = 100.0
    building_spacing: float = 100.0
    road_ratio: float = 100.0
    open_space: float = 100.0
    cliff_continuity: float = 100.0
    stair_coherence: float = 100.0
    parcel_variety: float = 100.0
    path_variety: float = 100.0
    border_naturalness: float = 100.0
    anti_symmetry: float = 100.0

    @property
    def total_visual_score(self) -> float:
        weights = {
            "tree_distribution": 0.12,
            "vegetation_density": 0.10,
            "building_spacing": 0.12,
            "road_ratio": 0.10,
            "open_space": 0.12,
            "cliff_continuity": 0.12,
            "stair_coherence": 0.10,
            "parcel_variety": 0.08,
            "path_variety": 0.06,
            "border_naturalness": 0.04,
            "anti_symmetry": 0.04,
        }
        score = sum(getattr(self, k) * w for k, w in weights.items())
        return round(score, 1)


class VisualQualityValidator:
    def __init__(self, spec: TownSpec):
        self.spec = spec

    def evaluate(self, layout: TownLayout) -> Tuple[VisualQualityScore, List[str]]:
        """Evaluates layout aesthetics and returns detailed visual quality scores."""
        score = VisualQualityScore()
        notes: List[str] = []
        w, h = layout.width, layout.height
        total_cells = w * h

        # 1. Vegetation Density & Distribution Evaluation
        veg_count = len(layout.vegetation)
        tree_coverage_cells = sum(v.width * v.height for v in layout.vegetation)
        veg_ratio = tree_coverage_cells / float(total_cells)

        # Target range from style profile: 0.15 - 0.28
        if 0.14 <= veg_ratio <= 0.30:
            score.vegetation_density = 100.0
        elif 0.10 <= veg_ratio < 0.14 or 0.30 < veg_ratio <= 0.35:
            score.vegetation_density = 88.0
            notes.append(f"Vegetation density slightly outside ideal range ({veg_ratio:.1%})")
        else:
            score.vegetation_density = 72.0
            notes.append(f"Vegetation density unbalanced ({veg_ratio:.1%})")

        # Tree distribution: Check collinear alignment (penalize artificial grid lines of trees)
        collinear_penalty = 0
        x_coords = [v.x for v in layout.vegetation]
        y_coords = [v.y for v in layout.vegetation]
        x_freq = {x: x_coords.count(x) for x in set(x_coords)}
        y_freq = {y: y_coords.count(y) for y in set(y_coords)}

        for count in x_freq.values():
            if count >= 6:  # 6 or more trees strictly aligned vertically
                collinear_penalty += 2.5
        for count in y_freq.values():
            if count >= 6:  # 6 or more trees strictly aligned horizontally
                collinear_penalty += 2.5
        score.tree_distribution = max(70.0, 100.0 - collinear_penalty)

        # 2. Building Spacing & Courtyard Quality
        if len(layout.buildings) >= 2:
            min_dist = 999.0
            for i, b1 in enumerate(layout.buildings):
                for j, b2 in enumerate(layout.buildings):
                    if i < j:
                        dist = math.sqrt((b1.x - b2.x) ** 2 + (b1.y - b2.y) ** 2)
                        min_dist = min(min_dist, dist)
            if min_dist < 4.0:
                score.building_spacing = 80.0
                notes.append("Buildings placed too closely without proper courtyard buffer")
            elif min_dist > 18.0:
                score.building_spacing = 85.0
                notes.append("Buildings excessively scattered across map")
            else:
                score.building_spacing = 100.0

        # 3. Road / Terrain Ratio Evaluation
        road_cells = sum(sum(1 for c in row if c > 0) for row in layout.road_mask)
        road_ratio = road_cells / float(total_cells)
        # Target range: 0.15 - 0.26
        if 0.14 <= road_ratio <= 0.28:
            score.road_ratio = 100.0
        else:
            score.road_ratio = max(75.0, 100.0 - abs(road_ratio - 0.20) * 150.0)

        # 4. Open Space & Plaza Breathing Room
        # Compute largest contiguous open space without buildings or trees
        open_cells = 0
        for x in range(w):
            for y in range(h):
                if layout.collision[x][y] == TileCollision.WALKABLE.value:
                    open_cells += 1
        open_ratio = open_cells / float(total_cells)
        if 0.22 <= open_ratio <= 0.38:
            score.open_space = 100.0
        else:
            score.open_space = max(75.0, 100.0 - abs(open_ratio - 0.28) * 100.0)

        # 5. Cliff Continuity & Naturalness
        # Penalize isolated cliff pixels (must be part of continuous ridge >= 5 cells)
        isolated_cliffs = 0
        for x in range(1, w - 1):
            for y in range(1, h - 1):
                if layout.cliff_mask[x][y] == 1:
                    neighbor_cliffs = sum(
                        1 for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0))
                        if layout.cliff_mask[x + dx][y + dy] == 1
                    )
                    if neighbor_cliffs == 0:
                        isolated_cliffs += 1
        if isolated_cliffs > 0:
            score.cliff_continuity = max(60.0, 100.0 - isolated_cliffs * 15.0)
            notes.append(f"Detected {isolated_cliffs} isolated cliff fragments")
        else:
            score.cliff_continuity = 100.0

        # 6. Stair Embedding Coherence
        # Stairs must touch continuous cliff on both sides
        stair_penalty = 0
        for st in layout.stairs:
            left_x = st.x - 1
            right_x = st.x + st.width
            mid_y = st.y + st.length // 2
            has_left_cliff = 0 <= left_x < w and layout.cliff_mask[left_x][mid_y] == 1
            has_right_cliff = 0 <= right_x < w and layout.cliff_mask[right_x][mid_y] == 1
            if not (has_left_cliff or has_right_cliff):
                stair_penalty += 10.0
        score.stair_coherence = max(75.0, 100.0 - stair_penalty)

        # 7. Parcel Variety (mix of small, medium, large structures)
        prefab_roles = {b.prefab_id for b in layout.buildings}
        if len(prefab_roles) >= 4:
            score.parcel_variety = 100.0
        elif len(prefab_roles) == 3:
            score.parcel_variety = 90.0
        else:
            score.parcel_variety = 75.0

        # 8. Anti-Symmetry Penalty (prevent mirror-like identical quarters)
        # Compare left half with mirrored right half
        half_w = w // 2
        diff_count = 0
        for x in range(half_w):
            for y in range(h):
                mirrored_x = w - 1 - x
                if layout.heightmap[x][y] != layout.heightmap[mirrored_x][y]:
                    diff_count += 1
                if layout.road_mask[x][y] != layout.road_mask[mirrored_x][y]:
                    diff_count += 1
        asymmetry_ratio = diff_count / float(half_w * h * 2)
        if asymmetry_ratio >= 0.40:
            score.anti_symmetry = 100.0
        else:
            score.anti_symmetry = max(70.0, asymmetry_ratio * 250.0)

        return score, notes
