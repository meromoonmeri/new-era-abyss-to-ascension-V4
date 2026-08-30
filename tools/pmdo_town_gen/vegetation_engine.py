"""Vegetation and Decoration Engine for PMDO Town Generator.

Places multi-layer trees (trunk on Mask/Blocked, canopy on Fringe/Walkable),
seasonal foliage, and street furniture.
"""
from __future__ import annotations

import math
import random
from typing import List, Optional, Set, Tuple

from .models import (
    BiomeType,
    Parcel,
    PlacedDecoration,
    PlacedStructure,
    PlacedVegetation,
    SeasonType,
    StairConnection,
    TileCollision,
    TownSpec,
)


class VegetationEngine:
    def __init__(self, spec: TownSpec):
        self.spec = spec
        self.rng = random.Random(spec.seed + 404)

    def generate(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        water_mask: List[List[int]],
        stairs: List[StairConnection],
        parcels: List[Parcel],
        buildings: List[PlacedStructure],
    ) -> Tuple[List[PlacedVegetation], List[PlacedDecoration]]:
        """Generates placed trees, shrubs, and street decorations."""
        w, h = self.spec.width, self.spec.height
        vegetation: List[PlacedVegetation] = []
        decorations: List[PlacedDecoration] = []

        # Mask of forbidden placement cells (roads, doors, stairs, buildings)
        forbidden = [[0 for _ in range(h)] for _ in range(w)]

        # 1. Block roads + 1 tile buffer around roads
        for x in range(w):
            for y in range(h):
                if road_mask[x][y] > 0:
                    forbidden[x][y] = 1
                if water_mask[x][y] > 0:
                    forbidden[x][y] = 1
                if cliff_mask[x][y] == 1:
                    forbidden[x][y] = 1

        # 2. Block building footprints + door paths
        for b in buildings:
            for bx in range(max(0, b.x - 1), min(w, b.x + b.width + 1)):
                for by in range(max(0, b.y - 1), min(h, b.y + b.height + 1)):
                    forbidden[bx][by] = 1
            # Door clearance corridor (3 tiles in front of door)
            dx, dy = b.door_map_pos
            for cy in range(dy, min(h, dy + 4)):
                for cx in range(max(0, dx - 1), min(w, dx + 2)):
                    forbidden[cx][cy] = 1

        # 3. Block stairs + landing zones
        for st in stairs:
            x0, y0, x1, y1 = st.walkable_bounds
            for sx in range(max(0, x0 - 2), min(w, x1 + 3)):
                for sy in range(max(0, y0 - 2), min(h, y1 + 3)):
                    forbidden[sx][sy] = 1

        # 4. Scatter Trees using Poisson-disc distance sampling
        tree_id = 1
        placed_tree_points: List[Tuple[int, int]] = []
        min_tree_dist = 3.5

        # Perimeter tree border density
        for x in range(1, w - 2, 2):
            for y in (1, 2, h - 3, h - 2):
                if not forbidden[x][y] and self.rng.random() < 0.70:
                    tree = self._create_tree(f"tree_{tree_id}", x, y, hmap[x][y], is_large=True)
                    vegetation.append(tree)
                    placed_tree_points.append((x, y))
                    tree_id += 1
                    # Mark trunk
                    forbidden[x][y] = 1

        # Interior & lot buffer tree scattering
        attempts = int(w * h * self.spec.tree_density * 1.5)
        for _ in range(attempts):
            x = self.rng.randint(2, w - 4)
            y = self.rng.randint(2, h - 4)

            if forbidden[x][y] == 1:
                continue

            # Check distance to other trees
            too_close = False
            for tx, ty in placed_tree_points:
                dist = math.sqrt((x - tx) ** 2 + (y - ty) ** 2)
                if dist < min_tree_dist:
                    too_close = True
                    break
            if too_close:
                continue

            is_large = self.rng.random() < 0.65
            tree = self._create_tree(f"tree_{tree_id}", x, y, hmap[x][y], is_large=is_large)
            vegetation.append(tree)
            placed_tree_points.append((x, y))
            tree_id += 1
            forbidden[x][y] = 1

        # 5. Place Signposts at Building Doors & Entrances
        dec_id = 1
        for b in buildings:
            if b.role in ("pokemon_center", "shop", "inn"):
                dx, dy = b.door_map_pos
                sign_x, sign_y = dx - 1, dy
                if 0 <= sign_x < w and 0 <= sign_y < h and road_mask[sign_x][sign_y] == 0:
                    sign_text = [f"{b.role.replace('_', ' ').title()}", "Open 24 Hours", ""]
                    decorations.append(
                        PlacedDecoration(
                            id=f"dec_sign_{dec_id}",
                            prop_type="signpost",
                            x=sign_x,
                            y=sign_y,
                            width=1,
                            height=1,
                            elevation=b.elevation,
                            collision_type=TileCollision.SIGN,
                            text_lines=sign_text,
                        )
                    )
                    dec_id += 1

        # 6. Place Lampposts along Main Avenues
        for x in range(4, w - 4, 6):
            for y in range(4, h - 4, 6):
                if road_mask[x][y] > 0:
                    # Place on adjacent grass tile
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        lx, ly = x + dx, y + dy
                        if 0 <= lx < w and 0 <= ly < h and road_mask[lx][ly] == 0 and not forbidden[lx][ly]:
                            decorations.append(
                                PlacedDecoration(
                                    id=f"dec_lamp_{dec_id}",
                                    prop_type="lamppost",
                                    x=lx,
                                    y=ly,
                                    width=1,
                                    height=2,
                                    elevation=hmap[lx][ly],
                                    collision_type=TileCollision.BLOCKED,
                                )
                            )
                            dec_id += 1
                            forbidden[lx][ly] = 1
                            break

        # 7. Place Benches / Flowerbeds in Plaza
        for p in parcels:
            if p.assigned_structure_id == "fountain":
                fx, fy, fw, fh = p.bounds
                # Place benches North and South of fountain
                decorations.append(
                    PlacedDecoration(
                        id=f"dec_bench_{dec_id}",
                        prop_type="bench",
                        x=fx + 1,
                        y=fy - 2,
                        width=2,
                        height=1,
                        elevation=p.elevation,
                        collision_type=TileCollision.BLOCKED,
                    )
                )
                dec_id += 1

        return vegetation, decorations

    def _create_tree(
        self, tree_id: str, x: int, y: int, elevation: int, is_large: bool
    ) -> PlacedVegetation:
        """Creates multi-layer tree metadata (trunk on Mask, canopy on Fringe)."""
        if is_large:
            # 3x3 canopy, 2x1 trunk
            return PlacedVegetation(
                id=tree_id,
                veg_type="tree_large",
                x=x,
                y=y,
                width=3,
                height=3,
                elevation=elevation,
                trunk_bounds=(x, y + 1, 2, 1),      # Trunk blocked
                canopy_bounds=(x - 1, y - 1, 3, 3),  # Canopy fringe walkable
            )
        else:
            # 2x2 canopy, 1x1 trunk
            return PlacedVegetation(
                id=tree_id,
                veg_type="tree_small",
                x=x,
                y=y,
                width=2,
                height=2,
                elevation=elevation,
                trunk_bounds=(x, y + 1, 1, 1),
                canopy_bounds=(x, y, 2, 2),
            )
