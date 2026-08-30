"""Elevation and Topography Engine for PMDO Town Generator.

Generates discrete multi-level heightmaps, natural cliff contours,
and structural staircase connections between elevation tiers.
"""
from __future__ import annotations

import math
import random
from typing import List, Optional, Tuple

from .models import StairConnection, TownSpec


class ElevationEngine:
    def __init__(self, spec: TownSpec):
        self.spec = spec
        self.rng = random.Random(spec.seed + 101)

    def generate(self) -> Tuple[List[List[int]], List[List[int]], List[StairConnection]]:
        """Generates heightmap [width][height], cliff_mask [width][height], and stair connections."""
        w, h = self.spec.width, self.spec.height
        levels = max(1, min(3, self.spec.elevation_levels))

        # Base noise generation using multi-frequency sine/cosine gradients
        heightmap = [[0 for _ in range(h)] for _ in range(w)]

        if levels == 1:
            cliff_mask = [[0 for _ in range(h)] for _ in range(w)]
            return heightmap, cliff_mask, []

        # Generate organic gradient + noise field
        # Primary gradient: Y axis (North is higher, South is lower valley)
        # Plus randomized frequency waves
        freq1_x = self.rng.uniform(1.2, 2.5) / w
        freq1_y = self.rng.uniform(1.5, 3.0) / h
        freq2_x = self.rng.uniform(3.0, 5.0) / w
        freq2_y = self.rng.uniform(3.0, 5.0) / h
        phase_x = self.rng.uniform(0, math.pi * 2)
        phase_y = self.rng.uniform(0, math.pi * 2)

        raw_values = [[0.0 for _ in range(h)] for _ in range(w)]

        for x in range(w):
            for y in range(h):
                # Normalized coordinate: 0.0 at South/Center, 1.0 at North/Borders
                # Natural Pokémon town topography: South is main gate (Level 0), North/Hills is Level 1/2
                y_bias = 1.0 - (y / float(h))
                
                # Distance from southern center entrance
                dx = (x - w * 0.5) / (w * 0.5)
                dy = (y - h * 0.85) / (h * 0.85)
                dist_valley = math.sqrt(dx * dx + dy * dy)

                wave = (
                    0.5 * math.sin(x * freq1_x * math.pi * 2 + phase_x) +
                    0.5 * math.cos(y * freq1_y * math.pi * 2 + phase_y) +
                    0.25 * math.sin((x + y) * freq2_x * math.pi * 2)
                )

                score = y_bias * 0.65 + dist_valley * 0.35 + wave * 0.25
                raw_values[x][y] = score

        # Map raw scores to discrete elevation levels (0, 1, 2)
        # Thresholds tuned for typical town ratios (~60% Level 0, ~35% Level 1, ~5% Level 2)
        thresh_1 = 0.52
        thresh_2 = 0.88

        for x in range(w):
            for y in range(h):
                val = raw_values[x][y]
                if levels == 2:
                    heightmap[x][y] = 1 if val >= thresh_1 else 0
                else:  # levels >= 3
                    if val >= thresh_2:
                        heightmap[x][y] = 2
                    elif val >= thresh_1:
                        heightmap[x][y] = 1
                    else:
                        heightmap[x][y] = 0

        # Guarantee boundaries for main gate at south (must be level 0)
        gate_w = 12
        for gx in range(w // 2 - gate_w // 2, w // 2 + gate_w // 2):
            for gy in range(h - 8, h):
                if 0 <= gx < w and 0 <= gy < h:
                    heightmap[gx][gy] = 0

        # Cellular automata smoothing (3 iterations) to eliminate jagged 1-tile noise
        for _ in range(3):
            heightmap = self._smooth_heightmap(heightmap, w, h)

        # Detect cliff cells: cell is cliff if it has a neighbor with lower elevation
        cliff_mask = self._compute_cliff_mask(heightmap, w, h)

        # Place stair connections between levels
        stairs = self._place_stairs(heightmap, cliff_mask, w, h, levels)

        return heightmap, cliff_mask, stairs

    def _smooth_heightmap(self, hmap: List[List[int]], w: int, h: int) -> List[List[int]]:
        """Applies majority voting to clean up isolated elevation pixels."""
        new_map = [[hmap[x][y] for y in range(h)] for x in range(w)]
        for x in range(1, w - 1):
            for y in range(1, h - 1):
                neighbors = [
                    hmap[x - 1][y], hmap[x + 1][y],
                    hmap[x][y - 1], hmap[x][y + 1],
                    hmap[x - 1][y - 1], hmap[x + 1][y - 1],
                    hmap[x - 1][y + 1], hmap[x + 1][y + 1],
                ]
                # Count frequency
                counts = {}
                for val in neighbors:
                    counts[val] = counts.get(val, 0) + 1
                majority_val = max(counts.items(), key=lambda item: item[1])[0]
                if counts[majority_val] >= 5:
                    new_map[x][y] = majority_val
        return new_map

    def _compute_cliff_mask(self, hmap: List[List[int]], w: int, h: int) -> List[List[int]]:
        """Calculates 1 for cliff wall cells where higher ground meets lower ground."""
        cliffs = [[0 for _ in range(h)] for _ in range(w)]
        for x in range(w):
            for y in range(h):
                curr_elev = hmap[x][y]
                for nx, ny in ((x, y + 1), (x, y - 1), (x + 1, y), (x - 1, y)):
                    if 0 <= nx < w and 0 <= ny < h:
                        if curr_elev > hmap[nx][ny]:
                            cliffs[x][y] = 1
                            break
        return cliffs

    def _place_stairs(
        self, hmap: List[List[int]], cliff_mask: List[List[int]], w: int, h: int, levels: int
    ) -> List[StairConnection]:
        """Places 2 to 4 stair connections along cliff transition contours."""
        stairs: List[StairConnection] = []
        if levels <= 1:
            return stairs

        # Find cliff transition points between Level 0 and Level 1
        candidates: List[Tuple[int, int, str]] = []  # x, y, orientation

        for x in range(6, w - 6):
            for y in range(6, h - 6):
                # North-facing stair candidate: cell (x, y) is Level 1, south neighbor (x, y+1) is Level 0
                if hmap[x][y] == 1 and hmap[x][y + 1] == 0:
                    # Check if 3-tile wide area is uniform
                    if (
                        x + 2 < w and
                        hmap[x + 1][y] == 1 and hmap[x + 2][y] == 1 and
                        hmap[x + 1][y + 1] == 0 and hmap[x + 2][y + 1] == 0 and
                        hmap[x][y - 1] == 1 and hmap[x + 1][y - 1] == 1 and hmap[x + 2][y - 1] == 1 and
                        hmap[x][y + 2] == 0 and hmap[x + 1][y + 2] == 0 and hmap[x + 2][y + 2] == 0
                    ):
                        candidates.append((x, y, "north"))

        # Select 2 to 3 well-spaced stairs (e.g. West, Center, East)
        if not candidates:
            # Fallback: force carve a center stair at midpoint
            mid_x = w // 2 - 1
            for y in range(h // 4, 3 * h // 4):
                if hmap[mid_x][y] != hmap[mid_x][y + 1]:
                    candidates.append((mid_x, y, "north"))
                    break

        selected: List[Tuple[int, int, str]] = []
        # Sort candidates by X coordinate
        candidates.sort(key=lambda item: item[0])

        if len(candidates) <= 2:
            selected = candidates
        else:
            # Pick left, center, right
            selected.append(candidates[0])
            mid_idx = len(candidates) // 2
            selected.append(candidates[mid_idx])
            selected.append(candidates[-1])

        stair_id = 1
        for sx, sy, orient in selected:
            stair_width = 3
            stair_len = 2
            stair = StairConnection(
                id=f"stair_{stair_id}",
                from_level=0,
                to_level=1,
                x=sx,
                y=sy,
                width=stair_width,
                length=stair_len,
                orientation=orient,
                walkable_bounds=(sx, sy - 1, sx + stair_width - 1, sy + stair_len),
            )
            stairs.append(stair)
            stair_id += 1

            # Carve ramp through cliff mask so path is walkable
            for tx in range(sx, sx + stair_width):
                for ty in range(sy - 1, sy + stair_len + 1):
                    if 0 <= tx < w and 0 <= ty < h:
                        cliff_mask[tx][ty] = 0

        return stairs
