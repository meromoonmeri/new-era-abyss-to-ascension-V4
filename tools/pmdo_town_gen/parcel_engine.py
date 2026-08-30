"""Parcel Allocation and Structure Placement Engine for PMDO Town Generator.

Subdivides buildable land along road networks, tests elevation and clearance
constraints, and places multi-layer building prefabs.
"""
from __future__ import annotations

import math
import random
from collections import deque
from typing import Dict, List, Optional, Set, Tuple

from .models import District, DistrictType, Parcel, PlacedStructure, StairConnection, StructurePrefab, TownSpec
from .structure_library import StructureLibrary


class ParcelEngine:
    def __init__(self, spec: TownSpec, library: StructureLibrary):
        self.spec = spec
        self.library = library
        self.rng = random.Random(spec.seed + 303)

    def generate(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        stairs: List[StairConnection],
        districts: List[District],
    ) -> Tuple[List[Parcel], List[PlacedStructure]]:
        """Generates validated parcels and placed building instances."""
        w, h = self.spec.width, self.spec.height
        parcels: List[Parcel] = []
        placed_structures: List[PlacedStructure] = []

        # 1. Compute reachable road cells from Plaza / Entrance
        reachable_roads = self._compute_reachable_roads(hmap, cliff_mask, road_mask, stairs, w, h)

        # 2. Reserved grid: 1 where occupied by structure, stair, or clearance
        occupied = [[0 for _ in range(h)] for _ in range(w)]

        # Mark cliffs and map borders as occupied
        for x in range(w):
            for y in range(h):
                if cliff_mask[x][y] == 1:
                    occupied[x][y] = 1
                if x <= 1 or x >= w - 2 or y <= 1 or y >= h - 2:
                    occupied[x][y] = 1

        # Mark stair landing bounds + margins as occupied
        for st in stairs:
            x0, y0, x1, y1 = st.walkable_bounds
            for sx in range(max(0, x0 - 2), min(w, x1 + 3)):
                for sy in range(max(0, y0 - 2), min(h, y1 + 3)):
                    occupied[sx][sy] = 1

        # 3. Build priority list of requested structures
        priority_order = [
            "pokemon_center", "shop", "inn", "fountain", "house_large", "house_medium", "house_small", "well", "windmill"
        ]
        to_place: List[str] = []
        for p_id in priority_order:
            count = self.spec.structures.get(p_id, 0)
            for _ in range(count):
                to_place.append(p_id)

        # 4. Place structures on validated candidate parcels
        parcel_idx = 1
        for struct_id in to_place:
            prefab = self.library.get_prefab(struct_id)
            if not prefab:
                continue

            pref_district = self._preferred_district(prefab.role, districts)
            best_spot = self._find_best_parcel_spot(
                prefab, pref_district, hmap, cliff_mask, road_mask, reachable_roads, occupied, w, h
            )

            # Fallback to any district if preferred is full
            if not best_spot:
                for alt_d in districts:
                    if alt_d.id != pref_district.id:
                        best_spot = self._find_best_parcel_spot(
                            prefab, alt_d, hmap, cliff_mask, road_mask, reachable_roads, occupied, w, h
                        )
                        if best_spot:
                            pref_district = alt_d
                            break

            if best_spot:
                px, py, elev, front_side, road_conn = best_spot
                parcel = Parcel(
                    id=f"parcel_{parcel_idx:03d}",
                    district_id=pref_district.id,
                    bounds=(px, py, prefab.width, prefab.height),
                    elevation=elev,
                    front_road_side=front_side,
                    road_connection_point=road_conn,
                    door_target_pos=(px + prefab.door_pos[0], py + prefab.door_pos[1]),
                    clearance=prefab.clearance_margin,
                    assigned_structure_id=prefab.id,
                )
                parcels.append(parcel)

                placed_structures.append(
                    PlacedStructure(
                        instance_id=f"{prefab.id}_{parcel_idx}",
                        prefab_id=prefab.id,
                        role=prefab.role,
                        x=px,
                        y=py,
                        width=prefab.width,
                        height=prefab.height,
                        elevation=elev,
                        door_map_pos=(px + prefab.door_pos[0], py + prefab.door_pos[1]),
                        door_warp_target=prefab.door_warp_target,
                        parcel_id=parcel.id,
                    )
                )

                self._mark_occupied(occupied, px, py, prefab.width, prefab.height, clearance=prefab.clearance_margin, w=w, h=h)
                parcel_idx += 1

        return parcels, placed_structures

    def _compute_reachable_roads(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        stairs: List[StairConnection],
        w: int,
        h: int,
    ) -> Set[Tuple[int, int]]:
        """Finds all road cells connected to the main entrance/plaza."""
        start_x, start_y = w // 2, h - 2
        # If start is blocked, find nearest road
        if road_mask[start_x][start_y] == 0:
            for dy in range(-3, 4):
                if 0 <= start_y + dy < h and road_mask[start_x][start_y + dy] > 0:
                    start_y += dy
                    break

        visited: Set[Tuple[int, int]] = set()
        queue: deque[Tuple[int, int]] = deque([(start_x, start_y)])
        visited.add((start_x, start_y))

        # Build fast lookup for stair crossings
        stair_cells: Set[Tuple[int, int]] = set()
        for st in stairs:
            x0, y0, x1, y1 = st.walkable_bounds
            for sx in range(x0, x1 + 1):
                for sy in range(y0, y1 + 1):
                    stair_cells.add((sx, sy))

        while queue:
            cx, cy = queue.popleft()
            for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                nx, ny = cx + dx, cy + dy
                if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                    if road_mask[nx][ny] > 0 or (nx, ny) in stair_cells:
                        # Check elevation transition: must be same level OR via stair
                        is_stair = (cx, cy) in stair_cells or (nx, ny) in stair_cells
                        if hmap[nx][ny] == hmap[cx][cy] or is_stair:
                            visited.add((nx, ny))
                            queue.append((nx, ny))
        return visited

    def _preferred_district(self, role: str, districts: List[District]) -> District:
        """Returns the district best suited for this structure role."""
        if role in ("pokemon_center", "shop", "inn"):
            for d in districts:
                if d.district_type in (DistrictType.COMMERCIAL, DistrictType.PLAZA):
                    return d
        elif role == "monument":
            for d in districts:
                if d.district_type == DistrictType.PLAZA:
                    return d
        else:
            for d in districts:
                if d.district_type == DistrictType.RESIDENTIAL:
                    return d
        return districts[0]

    def _find_best_parcel_spot(
        self,
        prefab: StructurePrefab,
        target_district: District,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        reachable_roads: Set[Tuple[int, int]],
        occupied: List[List[int]],
        w: int,
        h: int,
    ) -> Optional[Tuple[int, int, int, str, Tuple[int, int]]]:
        """Scans for valid building placement spots adjacent to reachable roads."""
        candidates: List[Tuple[float, int, int, int, str, Tuple[int, int]]] = []

        pw, ph = prefab.width, prefab.height
        door_dx, door_dy = prefab.door_pos

        margin = 14
        min_x = max(2, target_district.bounds[0] - margin)
        max_x = min(w - pw - 2, target_district.bounds[2] + margin)
        min_y = max(2, target_district.bounds[1] - margin)
        max_y = min(h - ph - 2, target_district.bounds[3] + margin)

        for x in range(min_x, max_x):
            for y in range(min_y, max_y):
                # 1. Elevation must be uniform across all cells of footprint
                base_elev = hmap[x][y]
                if base_elev not in prefab.allowed_elevations:
                    continue

                flat = True
                for bx in range(x, x + pw):
                    for by in range(y, y + ph):
                        if hmap[bx][by] != base_elev:
                            flat = False
                            break
                    if not flat:
                        break
                if not flat:
                    continue

                # 2. Footprint must not overlap occupied grid
                overlap = False
                for bx in range(x, x + pw):
                    for by in range(y, y + ph):
                        if occupied[bx][by] == 1:
                            overlap = True
                            break
                    if overlap:
                        break
                if overlap:
                    continue

                # 3. Door clearance & road connection check
                door_map_x = x + door_dx
                door_map_y = y + door_dy

                has_road_access = False
                road_conn_point = (door_map_x, door_map_y + 1)

                if prefab.role == "monument":
                    if (door_map_x, door_map_y) in reachable_roads or (door_map_x, door_map_y + 1) in reachable_roads:
                        has_road_access = True
                        road_conn_point = (door_map_x, min(h - 1, door_map_y + 1))
                else:
                    for dy in range(1, 4):
                        ry = door_map_y + dy
                        if 0 <= ry < h:
                            if (door_map_x, ry) in reachable_roads and hmap[door_map_x][ry] == base_elev and cliff_mask[door_map_x][ry] == 0:
                                has_road_access = True
                                road_conn_point = (door_map_x, ry)
                                break

                if not has_road_access:
                    continue

                # Score candidate spot: closer to district center is better
                dist_to_center = math.sqrt((x - target_district.center_x) ** 2 + (y - target_district.center_y) ** 2)
                candidates.append((dist_to_center, x, y, base_elev, "south", road_conn_point))

        if not candidates:
            return None

        candidates.sort(key=lambda item: item[0])
        best = candidates[0]
        return (best[1], best[2], best[3], best[4], best[5])

    def _mark_occupied(
        self, occupied: List[List[int]], x: int, y: int, pw: int, ph: int, clearance: int, w: int, h: int
    ) -> None:
        """Marks footprint + clearance buffer as occupied."""
        for bx in range(max(0, x - clearance), min(w, x + pw + clearance)):
            for by in range(max(0, y - clearance), min(h, y + ph + clearance)):
                occupied[bx][by] = 1
