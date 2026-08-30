"""Organic Road and Path Network Generator for PMDO Town Generator.

Constructs hierarchical road networks using Minimum Spanning Trees (MST),
A* pathfinding with terrain-aware cost metrics, and plaza hubs.
"""
from __future__ import annotations

import heapq
import math
import random
from typing import Dict, List, Optional, Set, Tuple

from .models import District, DistrictType, RoadEdge, RoadHierarchy, RoadNode, StairConnection, TownSpec


class RoadNetworkEngine:
    def __init__(self, spec: TownSpec):
        self.spec = spec
        self.rng = random.Random(spec.seed + 202)

    def generate(
        self,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        stairs: List[StairConnection],
    ) -> Tuple[List[List[int]], List[District], List[RoadNode], List[RoadEdge]]:
        """Generates road_mask [width][height], districts, road nodes, and road edges."""
        w, h = self.spec.width, self.spec.height
        road_mask = [[0 for _ in range(h)] for _ in range(w)]

        # 1. Define Key Districts & Anchor Nodes
        districts: List[District] = []
        nodes: List[RoadNode] = []
        edges: List[RoadEdge] = []

        # Plaza District (Center / South-Central)
        plaza_x = w // 2
        plaza_y = int(h * 0.62)
        plaza_elev = hmap[plaza_x][plaza_y]
        districts.append(
            District(
                id="district_plaza",
                district_type=DistrictType.PLAZA,
                center_x=plaza_x,
                center_y=plaza_y,
                radius=6,
                elevation=plaza_elev,
                bounds=(plaza_x - 6, plaza_y - 6, plaza_x + 6, plaza_y + 6),
            )
        )
        nodes.append(RoadNode(id="node_plaza", x=plaza_x, y=plaza_y, elevation=plaza_elev, node_type="plaza_center"))

        # South Entrance Node
        south_y = h - 2
        south_x = w // 2
        nodes.append(RoadNode(id="node_entrance_south", x=south_x, y=south_y, elevation=hmap[south_x][south_y], node_type="entrance"))

        # North Exit Node
        north_y = 2
        north_x = w // 2
        nodes.append(RoadNode(id="node_exit_north", x=north_x, y=north_y, elevation=hmap[north_x][north_y], node_type="entrance"))

        # Commercial District (East of Plaza)
        comm_x = min(w - 8, int(w * 0.72))
        comm_y = int(h * 0.65)
        districts.append(
            District(
                id="district_commercial",
                district_type=DistrictType.COMMERCIAL,
                center_x=comm_x,
                center_y=comm_y,
                radius=7,
                elevation=hmap[comm_x][comm_y],
                bounds=(comm_x - 7, comm_y - 7, comm_x + 7, comm_y + 7),
            )
        )
        nodes.append(RoadNode(id="node_commercial", x=comm_x, y=comm_y, elevation=hmap[comm_x][comm_y], node_type="district_hub"))

        # Residential Districts (Terraces / North-West & North-East)
        res1_x = max(8, int(w * 0.28))
        res1_y = int(h * 0.35)
        districts.append(
            District(
                id="district_residential_west",
                district_type=DistrictType.RESIDENTIAL,
                center_x=res1_x,
                center_y=res1_y,
                radius=9,
                elevation=hmap[res1_x][res1_y],
                bounds=(res1_x - 9, res1_y - 9, res1_x + 9, res1_y + 9),
            )
        )
        nodes.append(RoadNode(id="node_residential_west", x=res1_x, y=res1_y, elevation=hmap[res1_x][res1_y], node_type="district_hub"))

        res2_x = min(w - 8, int(w * 0.72))
        res2_y = int(h * 0.35)
        districts.append(
            District(
                id="district_residential_east",
                district_type=DistrictType.RESIDENTIAL,
                center_x=res2_x,
                center_y=res2_y,
                radius=9,
                elevation=hmap[res2_x][res2_y],
                bounds=(res2_x - 9, res2_y - 9, res2_x + 9, res2_y + 9),
            )
        )
        nodes.append(RoadNode(id="node_residential_east", x=res2_x, y=res2_y, elevation=hmap[res2_x][res2_y], node_type="district_hub"))

        # Stair landing nodes
        for stair in stairs:
            # Bottom landing
            nodes.append(
                RoadNode(
                    id=f"node_{stair.id}_bottom",
                    x=stair.x + stair.width // 2,
                    y=stair.y + stair.length + 1,
                    elevation=stair.from_level,
                    node_type="stair_bottom",
                )
            )
            # Top landing
            nodes.append(
                RoadNode(
                    id=f"node_{stair.id}_top",
                    x=stair.x + stair.width // 2,
                    y=stair.y - 1,
                    elevation=stair.to_level,
                    node_type="stair_top",
                )
            )

        # 2. Build MST + Cycle Connections
        node_dict = {n.id: n for n in nodes}
        planned_connections: List[Tuple[str, str, RoadHierarchy]] = [
            ("node_entrance_south", "node_plaza", RoadHierarchy.PRIMARY_AVENUE),
            ("node_plaza", "node_commercial", RoadHierarchy.PRIMARY_AVENUE),
            ("node_residential_west", "node_exit_north", RoadHierarchy.SECONDARY_STREET),
            ("node_residential_east", "node_exit_north", RoadHierarchy.SECONDARY_STREET),
            ("node_residential_west", "node_residential_east", RoadHierarchy.SECONDARY_STREET),
        ]

        # Connect stairs to nearest district hubs
        for stair in stairs:
            bot_id = f"node_{stair.id}_bottom"
            top_id = f"node_{stair.id}_top"
            # Stair ramp itself is primary avenue
            planned_connections.append((bot_id, top_id, RoadHierarchy.PRIMARY_AVENUE))
            # Connect bottom to plaza or commercial
            planned_connections.append(("node_plaza", bot_id, RoadHierarchy.SECONDARY_STREET))
            # Connect top to nearest residential
            stair_mid_x = stair.x + stair.width // 2
            if stair_mid_x < w // 2:
                planned_connections.append((top_id, "node_residential_west", RoadHierarchy.SECONDARY_STREET))
            else:
                planned_connections.append((top_id, "node_residential_east", RoadHierarchy.SECONDARY_STREET))

        # 3. Pathfind each planned road connection using A*
        for na_id, nb_id, hierarchy in planned_connections:
            if na_id not in node_dict or nb_id not in node_dict:
                continue
            na, nb = node_dict[na_id], node_dict[nb_id]
            path = self._astar_road(na.x, na.y, nb.x, nb.y, hmap, cliff_mask, w, h)
            if path:
                width = 3 if hierarchy == RoadHierarchy.PRIMARY_AVENUE else 2
                edges.append(RoadEdge(node_a=na_id, node_b=nb_id, path_points=path, hierarchy=hierarchy, width=width))
                # Rasterize into road mask
                for px, py in path:
                    for dx in range(-width // 2, width // 2 + 1):
                        for dy in range(-width // 2, width // 2 + 1):
                            rx, ry = px + dx, py + dy
                            if 0 <= rx < w and 0 <= ry < h:
                                road_mask[rx][ry] = max(road_mask[rx][ry], 2 if hierarchy == RoadHierarchy.PRIMARY_AVENUE else 1)

        # 4. Rasterize Central Plaza Open Hub
        plaza_r = 5
        for px in range(plaza_x - plaza_r, plaza_x + plaza_r + 1):
            for py in range(plaza_y - plaza_r, plaza_y + plaza_r + 1):
                if 0 <= px < w and 0 <= py < h:
                    dist = math.sqrt((px - plaza_x) ** 2 + (py - plaza_y) ** 2)
                    if dist <= plaza_r + 0.5:
                        road_mask[px][py] = 2  # Primary avenue paved surface

        return road_mask, districts, nodes, edges

    def _astar_road(
        self,
        start_x: int,
        start_y: int,
        goal_x: int,
        goal_y: int,
        hmap: List[List[int]],
        cliff_mask: List[List[int]],
        w: int,
        h: int,
    ) -> List[Tuple[int, int]]:
        """A* pathfinder with gentle curve bias and elevation penalty."""
        frontier: List[Tuple[float, int, int]] = []
        heapq.heappush(frontier, (0.0, start_x, start_y))
        came_from: Dict[Tuple[int, int], Optional[Tuple[int, int]]] = {(start_x, start_y): None}
        cost_so_far: Dict[Tuple[int, int], float] = {(start_x, start_y): 0.0}

        while frontier:
            _, cx, cy = heapq.heappop(frontier)

            if cx == goal_x and cy == goal_y:
                break

            for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                nx, ny = cx + dx, cy + dy
                if not (0 <= nx < w and 0 <= ny < h):
                    continue

                # Terrain traversal cost
                elev_diff = abs(hmap[nx][ny] - hmap[cx][cy])
                is_cliff = cliff_mask[nx][ny] == 1

                step_cost = 1.0
                if is_cliff:
                    step_cost += 50.0  # Strongly avoid cliffs unless stairs present
                if elev_diff > 0:
                    step_cost += 20.0 * elev_diff

                # Slight organic curve jitter
                jitter = 0.05 * math.sin((nx * 7 + ny * 13) * 0.5)
                new_cost = cost_so_far[(cx, cy)] + step_cost + jitter

                if (nx, ny) not in cost_so_far or new_cost < cost_so_far[(nx, ny)]:
                    cost_so_far[(nx, ny)] = new_cost
                    priority = new_cost + math.sqrt((goal_x - nx) ** 2 + (goal_y - ny) ** 2)
                    heapq.heappush(frontier, (priority, nx, ny))
                    came_from[(nx, ny)] = (cx, cy)

        # Reconstruct path
        path: List[Tuple[int, int]] = []
        curr = (goal_x, goal_y)
        if curr not in came_from:
            return path

        while curr is not None:
            path.append(curr)
            curr = came_from.get(curr)
        path.reverse()
        return path
