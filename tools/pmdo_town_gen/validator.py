"""Validator and Connectivity Verification Suite for PMDO Town Generator.

Simulates player navigation (A*), verifies collision integrity, and scores
town layouts across 11 geometric and gameplay metrics.
"""
from __future__ import annotations

from collections import deque
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
    ValidationReport,
    ValidationScore,
)


class TownValidator:
    def __init__(self, spec: TownSpec):
        self.spec = spec

    def build_collision_grid(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        water_mask: List[List[int]],
        stairs: List[StairConnection],
        buildings: List[PlacedStructure],
        vegetation: List[PlacedVegetation],
        decorations: List[PlacedDecoration],
        w: int,
        h: int,
    ) -> List[List[int]]:
        """Assembles authoritative 2D collision grid (TileCollision enum values)."""
        grid = [[TileCollision.WALKABLE.value for _ in range(h)] for _ in range(w)]

        # 1. Map Borders: Blocked except entrances/exits
        for x in range(w):
            grid[x][0] = TileCollision.BLOCKED.value
            grid[x][h - 1] = TileCollision.BLOCKED.value
        for y in range(h):
            grid[0][y] = TileCollision.BLOCKED.value
            grid[w - 1][y] = TileCollision.BLOCKED.value

        for ent in self.spec.entrances + self.spec.exits:
            ew = ent.width
            if ent.side == "south":
                mid_x = ent.position if ent.position is not None else w // 2
                for gx in range(mid_x - ew // 2, mid_x + ew // 2 + 1):
                    if 0 <= gx < w:
                        grid[gx][h - 1] = TileCollision.WALKABLE.value
            elif ent.side == "north":
                mid_x = ent.position if ent.position is not None else w // 2
                for gx in range(mid_x - ew // 2, mid_x + ew // 2 + 1):
                    if 0 <= gx < w:
                        grid[gx][0] = TileCollision.WALKABLE.value

        # 2. Water cells: Blocked (except where bridged by road)
        for x in range(w):
            for y in range(h):
                if water_mask[x][y] == 1 and road_mask[x][y] == 0:
                    grid[x][y] = TileCollision.BLOCKED.value

        # 3. Cliff walls: Blocked
        for x in range(w):
            for y in range(h):
                if cliff_mask[x][y] == 1:
                    grid[x][y] = TileCollision.BLOCKED.value

        # 4. Stairs: Clear walkable corridor across cliffs
        for st in stairs:
            x0, y0, x1, y1 = st.walkable_bounds
            for sx in range(x0, x1 + 1):
                for sy in range(y0, y1 + 1):
                    if 0 <= sx < w and 0 <= sy < h:
                        grid[sx][sy] = TileCollision.WALKABLE.value

        # 5. Buildings: Mark walls as Blocked, doors as Warp/Walkable
        for b in buildings:
            for bx in range(b.x, b.x + b.width):
                for by in range(b.y, b.y + b.height):
                    if 0 <= bx < w and 0 <= by < h:
                        grid[bx][by] = TileCollision.BLOCKED.value

            dx, dy = b.door_map_pos
            if 0 <= dx < w and 0 <= dy < h:
                if b.door_warp_target:
                    grid[dx][dy] = TileCollision.WARP.value
                else:
                    grid[dx][dy] = TileCollision.WALKABLE.value

        # 6. Trees: Trunk is Blocked, Canopy is Walkable (Fringe)
        for veg in vegetation:
            tx, ty, tw, th = veg.trunk_bounds
            for bx in range(tx, tx + tw):
                for by in range(ty, ty + th):
                    if 0 <= bx < w and 0 <= by < h:
                        grid[bx][by] = TileCollision.BLOCKED.value

        # 7. Decorations
        for dec in decorations:
            for dx in range(dec.x, dec.x + dec.width):
                for dy in range(dec.y, dec.y + dec.height):
                    if 0 <= dx < w and 0 <= dy < h:
                        grid[dx][dy] = dec.collision_type.value

        return grid

    def validate(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        road_mask: List[List[int]],
        stairs: List[StairConnection],
        buildings: List[PlacedStructure],
        vegetation: List[PlacedVegetation],
        decorations: List[PlacedDecoration],
        grid: List[List[int]],
        w: int,
        h: int,
    ) -> ValidationReport:
        """Executes full constraint validation and gameplay reachability testing."""
        errors: List[str] = []
        warnings: List[str] = []
        score = ValidationScore()

        # 1. Test Stair Connections
        stairs_valid = True
        for st in stairs:
            top_y = st.y - 1
            bot_y = st.y + st.length + 1
            mid_x = st.x + st.width // 2
            if 0 <= top_y < h and 0 <= bot_y < h:
                if hmap[mid_x][top_y] != st.to_level or hmap[mid_x][bot_y] != st.from_level:
                    stairs_valid = False
                    errors.append(f"Stair {st.id} does not bridge levels {st.from_level} -> {st.to_level}")
        if not stairs_valid:
            score.stairs = 70.0

        # 2. Test Building Placement & Overlap
        building_overlap = 0
        for i, b1 in enumerate(buildings):
            for bx in range(b1.x, b1.x + b1.width):
                for by in range(b1.y, b1.y + b1.height):
                    if hmap[bx][by] != b1.elevation:
                        errors.append(f"Building {b1.instance_id} has split elevation at ({bx}, {by})")
                        score.building_placement -= 10.0
                        break

            for j, b2 in enumerate(buildings):
                if i < j:
                    if (
                        b1.x < b2.x + b2.width and
                        b1.x + b1.width > b2.x and
                        b1.y < b2.y + b2.height and
                        b1.y + b1.height > b2.y
                    ):
                        building_overlap += 1
                        errors.append(f"Building overlap between {b1.instance_id} and {b2.instance_id}")
        if building_overlap > 0:
            score.building_placement = max(0.0, score.building_placement - building_overlap * 25.0)

        # 3. Simulate Player Navigation (Reachability BFS from Entrance)
        start_x = w // 2
        start_y = h - 2
        if grid[start_x][start_y] != TileCollision.WALKABLE.value:
            for dx in range(-4, 5):
                if 0 <= start_x + dx < w and grid[start_x + dx][start_y] == TileCollision.WALKABLE.value:
                    start_x += dx
                    break

        reachable = self._bfs_reachable(start_x, start_y, grid, w, h)

        # List gameplay objectives to verify
        objectives: List[Tuple[str, int, int]] = []
        
        # Central Plaza objective: find nearest walkable tile in plaza
        plaza_raw_x, plaza_raw_y = w // 2, int(h * 0.62)
        plaza_target = self._find_nearest_walkable(plaza_raw_x, plaza_raw_y, grid, w, h, max_r=5)
        if plaza_target:
            objectives.append(("Central Plaza", plaza_target[0], plaza_target[1]))
        else:
            objectives.append(("Central Plaza", plaza_raw_x, plaza_raw_y))

        # North Exit
        north_target = self._find_nearest_walkable(w // 2, 2, grid, w, h, max_r=3)
        if north_target:
            objectives.append(("North Exit", north_target[0], north_target[1]))
        else:
            objectives.append(("North Exit", w // 2, 2))

        # Buildings doors
        for b in buildings:
            dx, dy = b.door_map_pos
            door_step = self._find_nearest_walkable(dx, dy + 1, grid, w, h, max_r=2)
            if door_step:
                objectives.append((f"{b.role.title()} ({b.instance_id}) Door", door_step[0], door_step[1]))
            else:
                objectives.append((f"{b.role.title()} ({b.instance_id}) Door", dx, dy + 1))

        # Stairs landings
        for st in stairs:
            mid_x = st.x + st.width // 2
            top_target = self._find_nearest_walkable(mid_x, st.y - 1, grid, w, h, max_r=2)
            bot_target = self._find_nearest_walkable(mid_x, st.y + st.length + 1, grid, w, h, max_r=2)
            if top_target:
                objectives.append((f"Stair {st.id} Top", top_target[0], top_target[1]))
            if bot_target:
                objectives.append((f"Stair {st.id} Bottom", bot_target[0], bot_target[1]))

        reachable_count = 0
        unreachable_nodes: List[str] = []

        for name, ox, oy in objectives:
            if 0 <= ox < w and 0 <= oy < h and (ox, oy) in reachable:
                reachable_count += 1
            else:
                unreachable_nodes.append(name)
                errors.append(f"Unreachable objective: {name} at ({ox}, {oy})")

        total_obj = len(objectives)
        connectivity_pct = (reachable_count / float(total_obj)) * 100.0 if total_obj > 0 else 100.0
        score.connectivity = connectivity_pct

        if connectivity_pct < 100.0:
            score.collision = max(70.0, score.collision - (total_obj - reachable_count) * 10.0)

        # 4. Check Tree & Vegetation Integrity
        for veg in vegetation:
            tx, ty, tw, th = veg.trunk_bounds
            for bx in range(tx, tx + tw):
                for by in range(ty, ty + th):
                    if 0 <= bx < w and 0 <= by < h and road_mask[bx][by] > 0:
                        warnings.append(f"Tree {veg.id} trunk on road at ({bx}, {by})")
                        score.vegetation = max(80.0, score.vegetation - 5.0)

        report = ValidationReport(
            status=score.status,
            score=score,
            reachable_objectives=reachable_count,
            total_objectives=total_obj,
            stair_connections_valid=stairs_valid,
            building_overlap_count=building_overlap,
            unreachable_nodes=unreachable_nodes,
            warnings=warnings,
            errors=errors,
        )
        return report

    def _find_nearest_walkable(
        self, x: int, y: int, grid: List[List[int]], w: int, h: int, max_r: int = 3
    ) -> Optional[Tuple[int, int]]:
        """Finds closest walkable cell to (x, y) within max_r radius."""
        if 0 <= x < w and 0 <= y < h and grid[x][y] in (TileCollision.WALKABLE.value, TileCollision.WARP.value):
            return (x, y)
        for r in range(1, max_r + 1):
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and grid[nx][ny] in (TileCollision.WALKABLE.value, TileCollision.WARP.value):
                        return (nx, ny)
        return None

    def _bfs_reachable(self, sx: int, sy: int, grid: List[List[int]], w: int, h: int) -> Set[Tuple[int, int]]:
        """Finds all walkable/passable cells reachable from (sx, sy)."""
        visited: Set[Tuple[int, int]] = set()
        queue: deque[Tuple[int, int]] = deque()

        if 0 <= sx < w and 0 <= sy < h and grid[sx][sy] in (TileCollision.WALKABLE.value, TileCollision.WARP.value):
            queue.append((sx, sy))
            visited.add((sx, sy))

        while queue:
            cx, cy = queue.popleft()
            for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                nx, ny = cx + dx, cy + dy
                if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                    cell_val = grid[nx][ny]
                    if cell_val in (TileCollision.WALKABLE.value, TileCollision.WARP.value):
                        visited.add((nx, ny))
                        queue.append((nx, ny))
        return visited
