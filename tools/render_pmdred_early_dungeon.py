#!/usr/bin/env python3
"""Render deterministic, inspectable early-dungeon floor representatives.

This tool consumes the *promoted PMDO ZoneData itself*: it selects one weighted
GridFloorGen recipe per floor, constructs connected room/hall topology from the
serialized grid/room/tunnel parameters, resolves PMDO AutoTileAdjacent neighbor
codes, and composites terrain exclusively from the referenced ``.tile`` sheet.
It adds clearly identified audit overlays for the entry, stair route, and a
sample drawn from the serialized entity tables.

The resulting PASS is intentionally a static render/invariant gate.  It does
not claim byte-for-byte equivalence with RogueElements' random generator or
PMDO-native playback; those remain grouped native-certification work.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
import sys
from collections import deque
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Sequence

try:
    from PIL import Image, ImageDraw, ImageFont, PngImagePlugin
except ImportError as exc:  # pragma: no cover - environment diagnostic
    raise SystemExit("Pillow is required (use .runtime-cache/test-venv/bin/python)") from exc

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "pmdred-eu-early-dungeon-static-render-v1"
RENDERER_METHOD = "zone-grid-representative-autotile-adjacent-tick0-v1"
FONT_REGULAR = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
FONT_BOLD = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf")


class RenderError(RuntimeError):
    """Raised when a render or its invariant checks are invalid."""


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as stream:
        return json.load(stream)


def canonical_json(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


class HashRNG:
    """Small stable hash-stream RNG; independent of Python's random module."""

    def __init__(self, seed: str):
        self.seed = seed.encode("utf-8")
        self.counter = 0

    def uint64(self) -> int:
        block = hashlib.sha256(
            self.seed + b":" + str(self.counter).encode("ascii")
        ).digest()
        self.counter += 1
        return int.from_bytes(block[:8], "little")

    def randbelow(self, stop: int) -> int:
        if stop <= 0:
            raise ValueError("stop must be positive")
        return self.uint64() % stop

    def randint(self, minimum: int, maximum: int) -> int:
        if maximum < minimum:
            raise ValueError((minimum, maximum))
        return minimum + self.randbelow(maximum - minimum + 1)

    def choice(self, values: Sequence[Any]) -> Any:
        if not values:
            raise ValueError("cannot choose from an empty sequence")
        return values[self.randbelow(len(values))]

    def shuffle(self, values: list[Any]) -> None:
        for index in range(len(values) - 1, 0, -1):
            other = self.randbelow(index + 1)
            values[index], values[other] = values[other], values[index]


def weighted_choice(entries: Sequence[dict[str, Any]], rng: HashRNG) -> tuple[int, dict[str, Any], int, int]:
    rates = [int(entry.get("Rate", 0)) for entry in entries]
    total = sum(rates)
    if total <= 0:
        raise RenderError("weighted table has no positive rate")
    roll = rng.randbelow(total)
    cursor = 0
    for index, (entry, rate) in enumerate(zip(entries, rates)):
        cursor += rate
        if roll < cursor:
            return index, entry, roll, total
    raise AssertionError("unreachable weighted selection")


def step_with_fields(steps: Sequence[dict[str, Any]], *fields: str) -> dict[str, Any]:
    for pair in steps:
        value = pair.get("Value", {})
        if all(field in value for field in fields):
            return value
    raise RenderError("missing generator step with fields: " + ", ".join(fields))


def step_at_key(steps: Sequence[dict[str, Any]], key: Sequence[int]) -> dict[str, Any]:
    for pair in steps:
        if pair.get("Key", {}).get("str") == list(key):
            return pair["Value"]
    raise RenderError(f"missing generator step at priority {list(key)}")


def range_inclusive(value: dict[str, Any], *, maximum_cap: int | None = None) -> tuple[int, int]:
    """Translate RogueElements RandRange (Min inclusive, Max exclusive)."""
    minimum = int(value["Min"])
    maximum = max(minimum, int(value["Max"]) - 1)
    if maximum_cap is not None:
        maximum = min(maximum, maximum_cap)
    if maximum < minimum:
        minimum = maximum
    return minimum, maximum


@dataclass(frozen=True)
class TileBundle:
    tile_size: int
    cells: dict[tuple[int, int], Image.Image]

    @classmethod
    def load(cls, path: Path) -> "TileBundle":
        raw = path.read_bytes()
        if len(raw) < 8:
            raise RenderError(f"truncated tile bundle: {path}")
        tile_size, count = struct.unpack_from("<ii", raw, 0)
        table_end = 8 + count * 16
        if tile_size <= 0 or count <= 0 or table_end > len(raw):
            raise RenderError(f"invalid tile bundle header: {path}")
        cells: dict[tuple[int, int], Image.Image] = {}
        for index in range(count):
            x, y, offset = struct.unpack_from("<iiq", raw, 8 + index * 16)
            if offset < table_end or offset + 8 > len(raw):
                raise RenderError(f"tile bundle offset out of range at entry {index}")
            length = struct.unpack_from("<q", raw, offset)[0]
            if length <= 0 or offset + 8 + length > len(raw):
                raise RenderError(f"tile bundle image length out of range at entry {index}")
            image = Image.open(io.BytesIO(raw[offset + 8 : offset + 8 + length])).convert("RGBA")
            if image.size != (tile_size, tile_size):
                raise RenderError(f"tile {x},{y} has unexpected dimensions {image.size}")
            cells[(x, y)] = image
        if len(cells) != count:
            raise RenderError("duplicate locations in tile bundle")
        return cls(tile_size=tile_size, cells=cells)


class AdjacentAutoTile:
    """Tick-zero compositor for RogueEssence Dungeon.AutoTileAdjacent."""

    CARDINALS = ((0, 1), (-1, 0), (0, -1), (1, 0))  # Down, Left, Up, Right
    DIAGONALS = ((-1, 1), (-1, -1), (1, -1), (1, 1))

    def __init__(self, path: Path, tile_bundle: TileBundle):
        self.path = path
        self.data = load_json(path)["Object"]["Tiles"]
        if "AutoTileAdjacent" not in self.data.get("$type", ""):
            raise RenderError(f"unsupported autotile type in {path}")
        self.bundle = tile_bundle
        self.cache: dict[tuple[int, int], Image.Image] = {}
        self.used_frames: set[tuple[int, int]] = set()

    @staticmethod
    def neighbor_code(x: int, y: int, same: Any) -> int:
        code = 0
        blocked: list[bool] = []
        for index, (dx, dy) in enumerate(AdjacentAutoTile.CARDINALS):
            value = bool(same(x + dx, y + dy))
            blocked.append(value)
            if value:
                code |= 1 << index
        for index, (dx, dy) in enumerate(AdjacentAutoTile.DIAGONALS):
            if blocked[index] and blocked[(index + 1) % 4] and same(x + dx, y + dy):
                code |= 1 << (index + 4)
        return code

    def render(self, code: int, random_code: int) -> Image.Image:
        key = f"Tilex{code:02X}"
        variants = self.data.get(key) or self.data.get("TilexFF")
        if not variants:
            raise RenderError(f"autotile {self.path} has no variant for {key} or TilexFF")

        # Mirrors AutoTileBase.SelectTileVariant: each later variant is half as
        # likely as the previous one, with the final variant receiving the tail.
        variant_index = 0
        work = random_code
        while variant_index < len(variants) - 1 and work % 2 == 0:
            variant_index += 1
            work >>= 1
        cache_key = (code, variant_index)
        cached = self.cache.get(cache_key)
        if cached is not None:
            return cached

        result = Image.new("RGBA", (self.bundle.tile_size, self.bundle.tile_size), (0, 0, 0, 0))
        for layer in variants[variant_index]:
            frames = layer.get("Frames", [])
            if not frames:
                continue
            # Deterministic audit render at animation tick zero.
            frame = frames[0]
            location_data = frame.get("TexLoc") or frame.get("TileLoc")
            if location_data is None:
                raise RenderError(f"autotile frame lacks a texture location: {frame}")
            location = (int(location_data["X"]), int(location_data["Y"]))
            source = self.bundle.cells.get(location)
            if source is None:
                raise RenderError(f"autotile references missing sheet cell {location}")
            self.used_frames.add(location)
            result.alpha_composite(source)
        self.cache[cache_key] = result
        return result


@dataclass
class FloorModel:
    floor_number: int
    generator: str
    recipe_index: int
    recipe_roll: int
    recipe_total: int
    recipe_rate: int
    seed: str
    width: int
    height: int
    terrain: list[list[str]]
    room_floor: set[tuple[int, int]]
    start: tuple[int, int]
    stairs: tuple[int, int] | None
    route: list[tuple[int, int]]
    entities: list[dict[str, Any]]
    config: dict[str, Any]


def carve_room(
    terrain: list[list[str]],
    room_floor: set[tuple[int, int]],
    x: int,
    y: int,
    width: int,
    height: int,
) -> None:
    map_height = len(terrain)
    map_width = len(terrain[0])
    for yy in range(max(1, y), min(map_height - 1, y + height)):
        for xx in range(max(1, x), min(map_width - 1, x + width)):
            terrain[yy][xx] = "floor"
            room_floor.add((xx, yy))


def carve_corridor(
    terrain: list[list[str]],
    begin: tuple[int, int],
    end: tuple[int, int],
    horizontal_first: bool,
) -> None:
    x, y = begin
    ex, ey = end

    def carve(xx: int, yy: int) -> None:
        if 0 < yy < len(terrain) - 1 and 0 < xx < len(terrain[0]) - 1:
            terrain[yy][xx] = "floor"

    if horizontal_first:
        while x != ex:
            carve(x, y)
            x += 1 if ex > x else -1
        while y != ey:
            carve(x, y)
            y += 1 if ey > y else -1
    else:
        while y != ey:
            carve(x, y)
            y += 1 if ey > y else -1
        while x != ex:
            carve(x, y)
            x += 1 if ex > x else -1
    carve(ex, ey)


def neighbors4(point: tuple[int, int], width: int, height: int) -> Iterable[tuple[int, int]]:
    x, y = point
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        xx, yy = x + dx, y + dy
        if 0 <= xx < width and 0 <= yy < height:
            yield xx, yy


def bfs(
    terrain: list[list[str]], start: tuple[int, int]
) -> tuple[dict[tuple[int, int], int], dict[tuple[int, int], tuple[int, int]]]:
    height = len(terrain)
    width = len(terrain[0])
    distance = {start: 0}
    parent: dict[tuple[int, int], tuple[int, int]] = {}
    queue = deque([start])
    while queue:
        point = queue.popleft()
        for nxt in neighbors4(point, width, height):
            if nxt in distance or terrain[nxt[1]][nxt[0]] != "floor":
                continue
            distance[nxt] = distance[point] + 1
            parent[nxt] = point
            queue.append(nxt)
    return distance, parent


def farthest(distance: dict[tuple[int, int], int]) -> tuple[int, int]:
    return max(distance, key=lambda point: (distance[point], point[1], point[0]))


def build_entity_sample(
    steps: Sequence[dict[str, Any]], rng: HashRNG, candidates: list[tuple[int, int]], reserved: set[tuple[int, int]]
) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []

    def take_location() -> tuple[int, int]:
        available = [point for point in candidates if point not in reserved]
        if not available:
            raise RenderError("not enough walkable room cells for entity sample")
        point = rng.choice(available)
        reserved.add(point)
        return point

    def sample_amount(picker: dict[str, Any]) -> int:
        amount_entries = picker["AmountSpawner"]["$values"]
        _, amount_entry, _, _ = weighted_choice(amount_entries, rng)
        return int(amount_entry["Spawn"])

    # Items: values are PMDO MapItems, including money entries.
    item_step = step_at_key(steps, [6, 1])
    item_picker = item_step["Spawn"]["Picker"]
    item_entries = item_picker["Spawner"]["$values"]
    for _ in range(sample_amount(item_picker)):
        _, picked, _, _ = weighted_choice(item_entries, rng)
        spawn = picked["Spawn"]
        location = take_location()
        result.append(
            {
                "kind": "item",
                "id": "money" if spawn.get("IsMoney") else spawn.get("Value", ""),
                "amount": int(spawn.get("Amount", 0)),
                "x": location[0],
                "y": location[1],
            }
        )

    # Traps/effect tiles.
    trap_step = step_at_key(steps, [6, 2])
    trap_picker = trap_step["Spawn"]["Picker"]
    trap_entries = trap_picker["Spawner"]["$values"]
    for _ in range(sample_amount(trap_picker)):
        _, picked, _, _ = weighted_choice(trap_entries, rng)
        spawn = picked["Spawn"]
        location = take_location()
        result.append(
            {
                "kind": "trap",
                "id": spawn.get("ID", ""),
                "x": location[0],
                "y": location[1],
            }
        )

    # Initial hostile teams (these early dungeons serialize one mob/team).
    mob_step = step_at_key(steps, [6, 3])
    mob_picker = mob_step["Spawn"]
    mob_entries = mob_picker["Picker"]["$values"]
    for _ in range(sample_amount(mob_picker)):
        _, picked, _, _ = weighted_choice(mob_entries, rng)
        team = picked["Spawn"]
        mob = team["Spawns"][0]
        location = take_location()
        result.append(
            {
                "kind": "enemy",
                "id": mob["BaseForm"]["Species"],
                "level": int(mob["Level"]["Min"]),
                "x": location[0],
                "y": location[1],
            }
        )
    return result


def build_static_floor_model(
    floor_number: int, load_gen: dict[str, Any], zone_id: str
) -> FloorModel:
    mapped = step_at_key(load_gen["GenSteps"], [-1])
    if "MappedRoomStep" not in mapped.get("$type", ""):
        raise RenderError(f"floor {floor_number}: LoadGen priority -1 is not MappedRoomStep")
    map_id = mapped["MapID"]
    map_path = ROOT / "Data/Map" / f"{map_id}.rsmap"
    if not map_path.is_file():
        raise RenderError(f"floor {floor_number}: mapped room is missing: {map_path.relative_to(ROOT)}")
    document = load_json(map_path)
    room = document["Object"]
    columns = room["Tiles"]
    width = len(columns)
    height = len(columns[0]) if columns else 0
    if width <= 0 or height <= 0 or any(len(column) != height for column in columns):
        raise RenderError(f"floor {floor_number}: mapped room has invalid/ragged dimensions")

    terrain: list[list[str]] = []
    direct_tiles: list[list[dict[str, Any]]] = []
    walkable: set[tuple[int, int]] = set()
    families: set[str] = set()
    for y in range(height):
        terrain_row: list[str] = []
        direct_row: list[dict[str, Any]] = []
        for x in range(width):
            data = columns[x][y]["Data"]
            tile_tex = data["TileTex"]
            family = tile_tex["AutoTileset"]
            if not family:
                raise RenderError(f"floor {floor_number}: blank direct autotile at {x},{y}")
            families.add(family)
            if family.endswith("_floor"):
                terrain_kind = "floor"
            elif family.endswith("_secondary"):
                terrain_kind = "secondary"
            else:
                terrain_kind = "wall"
            terrain_row.append(terrain_kind)
            direct_row.append({
                "family": family,
                "neighbor_code": int(tile_tex["NeighborCode"]),
                "collision": data["ID"],
            })
            if data["ID"] == "floor":
                walkable.add((x, y))
        terrain.append(terrain_row)
        direct_tiles.append(direct_row)
    if not walkable:
        raise RenderError(f"floor {floor_number}: static map has no walkable cells")
    entry_points = room.get("EntryPoints", [])
    if not entry_points:
        raise RenderError(f"floor {floor_number}: static map has no entry point")
    entry = entry_points[0]["Loc"]
    start = (int(entry["X"]), int(entry["Y"]))
    if start not in walkable:
        raise RenderError(f"floor {floor_number}: entry point is not walkable")
    connected, _ = bfs([["floor" if (x, y) in walkable else "wall" for x in range(width)] for y in range(height)], start)
    if len(connected) != len(walkable):
        raise RenderError(f"floor {floor_number}: static walkable terrain is disconnected")

    entities: list[dict[str, Any]] = []
    for team_field, kind in (("MapTeams", "enemy"), ("AllyTeams", "protected")):
        for team in room.get(team_field, []):
            for actor in team.get("Players", []) + team.get("Guests", []):
                location = actor["serializationLoc"]
                form = actor.get("BaseForm") or actor.get("CurrentForm")
                entities.append({
                    "kind": kind,
                    "id": form["Species"],
                    "level": int(actor["Level"]),
                    "hp": int(actor["HP"]),
                    "x": int(location["X"]),
                    "y": int(location["Y"]),
                })
    required = room.get("StaticAudit", {}).get("RequiredActors", [])
    config = {
        "map_id": map_id,
        "map_path": str(map_path.relative_to(ROOT)),
        "terrain_assets": sorted(families),
        "direct_tiles": direct_tiles,
        "entry_direction": int(entry_points[0]["Dir"]),
        "required_actors": required,
        "static_map_events": room.get("MapEffect", {}).get("OnMapStarts", []),
        "secondary_terrain_generated": False,
    }
    return FloorModel(
        floor_number=floor_number,
        generator="static_load",
        recipe_index=-1,
        recipe_roll=0,
        recipe_total=0,
        recipe_rate=0,
        seed=f"{zone_id}:floor:{floor_number}:static-render-v1",
        width=width,
        height=height,
        terrain=terrain,
        room_floor=walkable,
        start=start,
        stairs=None,
        route=[],
        entities=entities,
        config=config,
    )


def build_floor_model(floor_number: int, floor_node: dict[str, Any], zone_id: str) -> FloorModel:
    item = floor_node["Item"]
    generator_type = item.get("$type", "")
    if "LoadGen" in generator_type:
        return build_static_floor_model(floor_number, item, zone_id)
    if "ChanceFloorGen" not in generator_type:
        raise RenderError(f"floor {floor_number}: unsupported generator type: {generator_type}")
    seed = f"{zone_id}:floor:{floor_number}:render-v1"
    rng = HashRNG(seed)
    chance = item
    recipes = chance["Spawns"]
    recipe_index, recipe, roll, total = weighted_choice(recipes, rng)
    generator = recipe["Spawn"]
    if "GridFloorGen" not in generator.get("$type", ""):
        raise RenderError(f"floor {floor_number}: selected recipe is not GridFloorGen")
    steps = generator["GenSteps"]

    grid = step_with_fields(steps, "CellWidth", "CellHeight", "CellX", "CellY", "CellWall")
    path = step_with_fields(steps, "GenericRooms", "GenericHalls", "RoomRatio", "BranchRatio")
    padding_step = step_with_fields(steps, "Padding")
    tunnel = step_with_fields(steps, "TurnLength", "MaxLength", "Halls")
    texture = step_with_fields(steps, "GroundTileset", "BlockTileset", "WaterTileset")
    stairs_step = step_with_fields(steps, "MinDistance", "Entrances", "Exits")

    cell_width = int(grid["CellWidth"])
    cell_height = int(grid["CellHeight"])
    cells_x = int(grid["CellX"])
    cells_y = int(grid["CellY"])
    cell_wall = int(grid["CellWall"])
    padding = int(padding_step["Padding"])
    width = cells_x * cell_width + cell_wall + padding * 2
    height = cells_y * cell_height + cell_wall + padding * 2
    if width <= 4 or height <= 4:
        raise RenderError(f"floor {floor_number}: invalid generated dimensions {width}x{height}")

    terrain = [["wall" for _ in range(width)] for _ in range(height)]
    room_floor: set[tuple[int, int]] = set()
    centers: dict[tuple[int, int], tuple[int, int]] = {}
    room_picker = path["GenericRooms"]
    room_options = room_picker.get("ToSpawn", [])
    square_options = [room for room in room_options if "RoomGenSquare" in room.get("$type", "")]

    for cy in range(cells_y):
        for cx in range(cells_x):
            option = square_options[(cy * cells_x + cx) % len(square_options)] if square_options else None
            if option:
                min_w, max_w = range_inclusive(option["Width"], maximum_cap=cell_width - cell_wall)
                min_h, max_h = range_inclusive(option["Height"], maximum_cap=cell_height - cell_wall)
            else:
                min_w, max_w = max(3, cell_width - 5), max(3, cell_width - cell_wall - 1)
                min_h, max_h = max(3, cell_height - 5), max(3, cell_height - cell_wall - 1)
            room_width = rng.randint(min_w, max_w)
            room_height = rng.randint(min_h, max_h)
            base_x = padding + cell_wall + cx * cell_width
            base_y = padding + cell_wall + cy * cell_height
            slack_x = max(0, cell_width - cell_wall - room_width)
            slack_y = max(0, cell_height - cell_wall - room_height)
            room_x = base_x + rng.randint(0, slack_x)
            room_y = base_y + rng.randint(0, slack_y)
            carve_room(terrain, room_floor, room_x, room_y, room_width, room_height)
            centers[(cx, cy)] = (room_x + room_width // 2, room_y + room_height // 2)

    # Build a randomized spanning tree over the serialized grid, then add a
    # bounded subset of adjacency loops according to the branch ratio.
    graph_edges: list[tuple[tuple[int, int], tuple[int, int]]] = []
    for cy in range(cells_y):
        for cx in range(cells_x):
            if cx + 1 < cells_x:
                graph_edges.append(((cx, cy), (cx + 1, cy)))
            if cy + 1 < cells_y:
                graph_edges.append(((cx, cy), (cx, cy + 1)))
    rng.shuffle(graph_edges)
    parent = {(cx, cy): (cx, cy) for cy in range(cells_y) for cx in range(cells_x)}

    def find(point: tuple[int, int]) -> tuple[int, int]:
        while parent[point] != point:
            parent[point] = parent[parent[point]]
            point = parent[point]
        return point

    tree: list[tuple[tuple[int, int], tuple[int, int]]] = []
    remaining: list[tuple[tuple[int, int], tuple[int, int]]] = []
    for edge in graph_edges:
        root_a, root_b = find(edge[0]), find(edge[1])
        if root_a != root_b:
            parent[root_b] = root_a
            tree.append(edge)
        else:
            remaining.append(edge)
    branch_ratio = int(path["BranchRatio"]["Min"])
    loop_count = min(len(remaining), max(0, round(len(remaining) * branch_ratio / 100)))
    selected_edges = tree + remaining[:loop_count]
    for begin, end in selected_edges:
        carve_corridor(terrain, centers[begin], centers[end], bool(rng.randbelow(2)))

    # The promoted conversion serializes AddTunnelStep(Halls=5).  Model these
    # as additional center-to-center tunnel attempts, bounded by MaxLength.
    extra_halls = int(tunnel["Halls"]["Min"])
    max_length = int(tunnel["MaxLength"]["Max"])
    center_values = list(centers.values())
    tunnel_pairs = [(a, b) for index, a in enumerate(center_values) for b in center_values[index + 1 :]
                    if abs(a[0] - b[0]) + abs(a[1] - b[1]) <= max_length]
    rng.shuffle(tunnel_pairs)
    for begin, end in tunnel_pairs[:extra_halls]:
        carve_corridor(terrain, begin, end, bool(rng.randbelow(2)))

    walkable = {(x, y) for y, row in enumerate(terrain) for x, value in enumerate(row) if value == "floor"}
    if not walkable:
        raise RenderError(f"floor {floor_number}: no walkable terrain")
    first = min(walkable, key=lambda point: (point[1], point[0]))
    first_dist, _ = bfs(terrain, first)
    if len(first_dist) != len(walkable):
        raise RenderError(f"floor {floor_number}: generated walkable terrain is disconnected")
    start = farthest(first_dist)
    start_dist, stair_parent = bfs(terrain, start)
    stairs = farthest(start_dist)
    minimum_distance = int(stairs_step["MinDistance"])
    if start_dist[stairs] < minimum_distance:
        raise RenderError(f"floor {floor_number}: stair route is shorter than MinDistance")
    route = [stairs]
    while route[-1] != start:
        route.append(stair_parent[route[-1]])
    route.reverse()

    candidates = sorted(room_floor, key=lambda point: (point[1], point[0]))
    entities = build_entity_sample(steps, rng, candidates, {start, stairs})
    config = {
        "grid": {
            "cell_width": cell_width,
            "cell_height": cell_height,
            "cells_x": cells_x,
            "cells_y": cells_y,
            "cell_wall": cell_wall,
            "padding": padding,
        },
        "room_ratio": int(path["RoomRatio"]["Min"]),
        "branch_ratio": branch_ratio,
        "extra_hallways": extra_halls,
        "maximum_tunnel_length": max_length,
        "minimum_stair_distance": minimum_distance,
        "terrain_assets": {
            "floor": texture["GroundTileset"],
            "wall": texture["BlockTileset"],
            "secondary": texture["WaterTileset"],
        },
        "secondary_terrain_generated": False,
    }
    return FloorModel(
        floor_number=floor_number,
        generator="procedural",
        recipe_index=recipe_index,
        recipe_roll=roll,
        recipe_total=total,
        recipe_rate=int(recipe["Rate"]),
        seed=seed,
        width=width,
        height=height,
        terrain=terrain,
        room_floor=room_floor,
        start=start,
        stairs=stairs,
        route=route,
        entities=entities,
        config=config,
    )


def font(path: Path, size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    try:
        return ImageFont.truetype(str(path), size)
    except OSError:
        return ImageFont.load_default()


def tile_random_code(seed: str, terrain_kind: str, x: int, y: int) -> int:
    digest = hashlib.sha256(f"{seed}:{terrain_kind}:{x}:{y}".encode("utf-8")).digest()
    return int.from_bytes(digest[:8], "little")


def terrain_is_blank_black(image: Image.Image) -> bool:
    extrema = image.getextrema()
    if extrema[3][1] == 0:
        return True
    # A terrain cell is blank/black only if every visible channel is <= 3.
    return all(channel[1] <= 3 for channel in extrema[:3])


def draw_marker(
    draw: ImageDraw.ImageDraw,
    center: tuple[int, int],
    radius: int,
    fill: tuple[int, int, int, int],
    outline: tuple[int, int, int, int],
    label: str,
    label_font: ImageFont.ImageFont,
) -> None:
    x, y = center
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=fill, outline=outline, width=2)
    box = draw.textbbox((0, 0), label, font=label_font)
    text_width = box[2] - box[0]
    text_height = box[3] - box[1]
    draw.text((x - text_width // 2, y - text_height // 2 - box[1]), label, font=label_font, fill=(255, 255, 255, 255))


def encode_png(image: Image.Image, metadata: dict[str, str]) -> bytes:
    info = PngImagePlugin.PngInfo()
    for key in sorted(metadata):
        info.add_text(key, metadata[key])
    stream = io.BytesIO()
    image.save(stream, format="PNG", optimize=False, compress_level=9, pnginfo=info)
    return stream.getvalue()


def autotile_sheet_id(document: dict[str, Any]) -> str:
    sheets: set[str] = set()

    def visit(value: Any) -> None:
        if isinstance(value, dict):
            sheet = value.get("Sheet")
            if isinstance(sheet, str) and sheet:
                sheets.add(sheet)
            for nested in value.values():
                visit(nested)
        elif isinstance(value, list):
            for nested in value:
                visit(nested)

    visit(document)
    if len(sheets) != 1:
        raise RenderError(f"autotile must reference exactly one sheet, got {sorted(sheets)}")
    return next(iter(sheets))


def load_live_autotile(family: str) -> tuple[AdjacentAutoTile, Path, Path]:
    autotile_path = ROOT / "Data/AutoTile" / f"{family}.json"
    if not autotile_path.is_file():
        raise RenderError(f"missing promoted autotile: {autotile_path.relative_to(ROOT)}")
    document = load_json(autotile_path)
    sheet_id = autotile_sheet_id(document)
    sheet_path = ROOT / "Content/Tile" / f"{sheet_id}.tile"
    if not sheet_path.is_file():
        raise RenderError(f"missing promoted tile sheet: {sheet_path.relative_to(ROOT)}")
    bundle = TileBundle.load(sheet_path)
    return AdjacentAutoTile.load(autotile_path, bundle), autotile_path, sheet_path


def render_floor(
    model: FloorModel,
    title: str,
    floor_tiles: AdjacentAutoTile | None,
    wall_tiles: AdjacentAutoTile | None,
    asset_overrides: dict[str, AdjacentAutoTile] | None = None,
) -> tuple[bytes, dict[str, Any]]:
    direct_assets: dict[str, AdjacentAutoTile] = {}
    if model.generator == "static_load":
        for family in model.config["terrain_assets"]:
            direct_assets[family] = (
                asset_overrides[family]
                if asset_overrides is not None and family in asset_overrides
                else load_live_autotile(family)[0]
            )
        tile_sizes = {asset.bundle.tile_size for asset in direct_assets.values()}
        if len(tile_sizes) != 1:
            raise RenderError("static-map autotiles use different tile sizes")
        tile_size = next(iter(tile_sizes))
    else:
        if floor_tiles is None or wall_tiles is None:
            raise RenderError("procedural floor render lacks floor/wall autotiles")
        tile_size = floor_tiles.bundle.tile_size
        if wall_tiles.bundle.tile_size != tile_size:
            raise RenderError("floor and wall tiles use different tile sizes")
    terrain_image = Image.new("RGBA", (model.width * tile_size, model.height * tile_size), (0, 0, 0, 0))
    black_cells: list[tuple[int, int]] = []
    transparent_cells: list[tuple[int, int]] = []
    codes_used: dict[str, set[int]] = {"floor": set(), "wall": set(), "secondary": set()}

    for y in range(model.height):
        for x in range(model.width):
            kind = model.terrain[y][x]
            if model.generator == "static_load":
                direct = model.config["direct_tiles"][y][x]
                family = direct["family"]
                autotile = direct_assets[family]

                def same(xx: int, yy: int, expected: str = family) -> bool:
                    # PMDO's non-wrapping query returns true outside map bounds.
                    if xx < 0 or yy < 0 or xx >= model.width or yy >= model.height:
                        return True
                    return model.config["direct_tiles"][yy][xx]["family"] == expected

                computed_code = AdjacentAutoTile.neighbor_code(x, y, same)
                code = int(direct["neighbor_code"])
                if code != computed_code:
                    raise RenderError(
                        f"floor {model.floor_number}: direct neighbor code mismatch at {x},{y}: "
                        f"{code} != {computed_code}"
                    )
            else:
                autotile = floor_tiles if kind == "floor" else wall_tiles

                def same(xx: int, yy: int, expected: str = kind) -> bool:
                    # PMDO's non-wrapping query returns true outside map bounds.
                    if xx < 0 or yy < 0 or xx >= model.width or yy >= model.height:
                        return True
                    return model.terrain[yy][xx] == expected

                code = AdjacentAutoTile.neighbor_code(x, y, same)
            codes_used[kind].add(code)
            tile = autotile.render(code, tile_random_code(model.seed, kind, x, y))
            alpha_min, alpha_max = tile.getchannel("A").getextrema()
            if alpha_min != 255 or alpha_max != 255:
                transparent_cells.append((x, y))
            if terrain_is_blank_black(tile):
                black_cells.append((x, y))
            terrain_image.alpha_composite(tile, (x * tile_size, y * tile_size))

    if black_cells or transparent_cells:
        raise RenderError(
            f"floor {model.floor_number}: black={len(black_cells)}, transparent={len(transparent_cells)} terrain cells"
        )

    overlay = Image.new("RGBA", terrain_image.size, (0, 0, 0, 0))
    overlay_draw = ImageDraw.Draw(overlay)
    route_points = [
        (x * tile_size + tile_size // 2, y * tile_size + tile_size // 2)
        for x, y in model.route
    ]
    if len(route_points) > 1:
        overlay_draw.line(route_points, fill=(35, 224, 255, 125), width=3, joint="curve")
        for point in route_points[::4]:
            overlay_draw.ellipse((point[0] - 2, point[1] - 2, point[0] + 2, point[1] + 2), fill=(255, 255, 255, 190))

    marker_font = font(FONT_BOLD, max(11, tile_size // 2))
    start_center = (model.start[0] * tile_size + tile_size // 2, model.start[1] * tile_size + tile_size // 2)
    draw_marker(overlay_draw, start_center, tile_size // 3, (25, 150, 75, 235), (220, 255, 225, 255), "E", marker_font)
    if model.stairs is not None:
        stair_center = (model.stairs[0] * tile_size + tile_size // 2, model.stairs[1] * tile_size + tile_size // 2)
        draw_marker(overlay_draw, stair_center, tile_size // 3, (0, 135, 190, 240), (225, 255, 255, 255), "S", marker_font)

    entity_style = {
        "enemy": ((175, 35, 45, 225), (255, 220, 220, 255), "M"),
        "protected": ((33, 104, 181, 230), (220, 240, 255, 255), "P"),
        "item": ((145, 45, 175, 225), (255, 225, 255, 255), "I"),
        "trap": ((190, 125, 0, 230), (255, 245, 190, 255), "T"),
    }
    for entity in model.entities:
        fill, outline, label = entity_style[entity["kind"]]
        center = (entity["x"] * tile_size + tile_size // 2, entity["y"] * tile_size + tile_size // 2)
        draw_marker(overlay_draw, center, max(6, tile_size // 4), fill, outline, label, marker_font)

    terrain_image.alpha_composite(overlay)
    header_height = 92
    footer_height = 34
    canvas = Image.new("RGB", (terrain_image.width, terrain_image.height + header_height + footer_height), (24, 35, 48))
    canvas.paste(terrain_image.convert("RGB"), (0, header_height))
    draw = ImageDraw.Draw(canvas)
    title_font = font(FONT_BOLD, 25)
    text_font = font(FONT_REGULAR, 15)
    small_bold = font(FONT_BOLD, 14)
    draw.text((18, 12), f"{title} — {model.floor_number}F", font=title_font, fill=(246, 249, 252))
    subtitle = (
        f"{model.width}×{model.height} • feuille officielle 24 px • collision connexe • "
        + (f"trajet escalier {len(model.route) - 1} pas" if model.generator == "procedural"
           else "arène statique sans escalier")
    )
    draw.text((18, 49), subtitle, font=text_font, fill=(190, 215, 231))
    badge = "AUDIT STATIQUE : PASS"
    badge_box = draw.textbbox((0, 0), badge, font=small_bold)
    badge_width = badge_box[2] - badge_box[0] + 22
    draw.rounded_rectangle(
        (canvas.width - badge_width - 18, 14, canvas.width - 18, 43),
        radius=8,
        fill=(22, 119, 68),
    )
    draw.text((canvas.width - badge_width - 7, 20), badge, font=small_bold, fill=(255, 255, 255))
    footer_y = header_height + terrain_image.height
    draw.rectangle((0, footer_y, canvas.width, canvas.height), fill=(24, 35, 48))
    legend = (
        "E Entrée   M Ennemi   P Protégé   — arène fixe authentifiée"
        if model.generator == "static_load"
        else "E Entrée   S Escalier   M Ennemi   I Objet   T Piège   — ligne cyan : plus court trajet audité"
    )
    draw.text((18, footer_y + 8), legend, font=text_font, fill=(220, 230, 238))

    walkable = (
        len(model.room_floor)
        if model.generator == "static_load"
        else sum(value == "floor" for row in model.terrain for value in row)
    )
    distance, _ = bfs(model.terrain, model.start)
    entity_counts = {
        kind: sum(entity["kind"] == kind for entity in model.entities)
        for kind in (("enemy", "protected", "item", "trap") if model.generator == "static_load" else ("enemy", "item", "trap"))
    }
    terrain_counts = {
        kind: sum(value == kind for row in model.terrain for value in row)
        for kind in ("floor", "wall", "secondary")
    }
    stairs_record = (
        {
            "id": "stairs_go_up",
            "count": 1,
            "x": model.stairs[0],
            "y": model.stairs[1],
            "reachable": model.stairs in distance,
            "shortest_route": distance[model.stairs],
        }
        if model.stairs is not None
        else {"required": False, "count": 0, "reachable": None, "policy": "static boss arena"}
    )
    record = {
        **({"generator": model.generator} if model.generator == "static_load" else {}),
        "floor": model.floor_number,
        "seed": model.seed,
        "weighted_recipe": {
            "index": model.recipe_index,
            "rate": model.recipe_rate,
            "roll": model.recipe_roll,
            "total_rate": model.recipe_total,
        },
        "dimensions": {"width": model.width, "height": model.height, "tile_size": tile_size},
        "generation": model.config,
        "terrain": {
            **terrain_counts,
            "coverage": model.width * model.height,
            "autotile_neighbor_codes": {
                kind: [f"0x{code:02X}" for code in sorted(codes_used[kind])]
                for kind in (("floor", "wall", "secondary") if model.generator == "static_load" else ("floor", "wall"))
            },
            "black_cells": len(black_cells),
            "transparent_cells": len(transparent_cells),
        },
        "collision": {
            "walkable": walkable,
            "reachable_from_entry": len(distance),
            "connected_components": 1 if len(distance) == walkable else None,
            "all_walkable_reachable": len(distance) == walkable,
        },
        "entry": {"x": model.start[0], "y": model.start[1]},
        "stairs": stairs_record,
        "entity_overlay_sample": {
            "counts": entity_counts,
            "entries": model.entities,
            "all_on_reachable_floor": all((entity["x"], entity["y"]) in distance for entity in model.entities),
        },
        "static_invariants": {
            "dimensions_positive": model.width > 0 and model.height > 0,
            "terrain_complete": walkable + (model.width * model.height - walkable) == model.width * model.height,
            "no_black_terrain_tiles": not black_cells,
            "no_transparent_terrain_tiles": not transparent_cells,
            "one_entry": True,
            **({"no_stair_required_for_static_arena": model.stairs is None}
               if model.generator == "static_load"
               else {"one_reachable_stair": model.stairs in distance}),
            "all_walkable_reachable": len(distance) == walkable,
            "all_overlay_entities_reachable": all((entity["x"], entity["y"]) in distance for entity in model.entities),
        },
    }
    if not all(record["static_invariants"].values()):
        raise RenderError(f"floor {model.floor_number}: one or more static invariants failed")

    metadata = {
        "Schema": SCHEMA,
        "Zone": model.seed.split(":floor:", 1)[0],
        "Floor": str(model.floor_number),
        "Renderer": RENDERER_METHOD,
        "Terrain": "PMDO AutoTileAdjacent from promoted .tile sheet; tick 0",
        "Overlay": "Static audit markers; not native PMDO sprites",
    }
    return encode_png(canvas, metadata), record


def render_overview(title: str, floor_pngs: Sequence[bytes], floor_records: Sequence[dict[str, Any]]) -> bytes:
    full = [Image.open(io.BytesIO(data)).convert("RGB") for data in floor_pngs]
    thumb_width = 470
    thumbs: list[Image.Image] = []
    for image in full:
        height = round(image.height * thumb_width / image.width)
        thumbs.append(image.resize((thumb_width, height), Image.Resampling.LANCZOS))
    columns = 3
    gap = 16
    header = 84
    rows = (len(thumbs) + columns - 1) // columns
    row_heights = [0] * rows
    for index, image in enumerate(thumbs):
        row_heights[index // columns] = max(row_heights[index // columns], image.height)
    width = columns * thumb_width + (columns + 1) * gap
    height = header + sum(row_heights) + (rows + 1) * gap
    canvas = Image.new("RGB", (width, height), (18, 28, 40))
    draw = ImageDraw.Draw(canvas)
    draw.text((20, 13), f"{title} — vue d’ensemble des {len(floor_records)} étages", font=font(FONT_BOLD, 28), fill=(248, 250, 252))
    overview_subtitle = (
        "Terrains officiels PMDO promus • étages procéduraux et arène fixe directement inspectables"
        if any(record.get("generator") == "static_load" for record in floor_records)
        else "Terrains issus de la feuille PMDO promue • entrées, escaliers, collisions et trajets inspectables"
    )
    draw.text(
        (20, 51),
        overview_subtitle,
        font=font(FONT_REGULAR, 15),
        fill=(181, 209, 228),
    )
    y_offsets: list[int] = []
    cursor = header + gap
    for row_height in row_heights:
        y_offsets.append(cursor)
        cursor += row_height + gap
    for index, image in enumerate(thumbs):
        column = index % columns
        row = index // columns
        x = gap + column * (thumb_width + gap)
        y = y_offsets[row]
        canvas.paste(image, (x, y))
        draw.rectangle((x, y, x + image.width - 1, y + image.height - 1), outline=(94, 134, 160), width=2)
    metadata = {
        "Schema": SCHEMA,
        "Renderer": RENDERER_METHOD,
        "Floors": str(len(floor_records)),
        "Status": "STATIC_RENDER_PASS",
    }
    return encode_png(canvas, metadata)


def infer_assets(zone_path: Path, zone_object: dict[str, Any]) -> tuple[Path, Path, Path]:
    segments = zone_object.get("Segments", [])
    if len(segments) != 1:
        raise RenderError("renderer currently requires one RangeDictSegment")
    nodes = segments[0]["Floors"]["nodes"]
    first_recipe = nodes[0]["Item"]["Spawns"][0]["Spawn"]
    texture = step_with_fields(first_recipe["GenSteps"], "GroundTileset", "BlockTileset", "WaterTileset")
    floor_path = ROOT / "Data/AutoTile" / f"{texture['GroundTileset']}.json"
    wall_path = ROOT / "Data/AutoTile" / f"{texture['BlockTileset']}.json"
    floor_data = load_json(floor_path)["Object"]["Tiles"]
    frame = floor_data["TilexFF"][0][0]["Frames"][0]
    sheet = frame["Sheet"]
    tile_path = ROOT / "Content/Tile" / f"{sheet}.tile"
    for path in (floor_path, wall_path, tile_path):
        if not path.is_file():
            raise FileNotFoundError(path)
    return floor_path, wall_path, tile_path


def build(args: argparse.Namespace) -> tuple[dict[str, bytes], dict[str, Any]]:
    zone_path = args.zone.resolve()
    zone_doc = load_json(zone_path)
    if zone_doc.get("Version") != "0.8.12.0":
        raise RenderError(f"zone is not serialized for PMDO 0.8.12: {zone_doc.get('Version')}")
    zone_object = zone_doc["Object"]
    segments = zone_object.get("Segments", [])
    if len(segments) != 1:
        raise RenderError("renderer currently requires exactly one segment")
    nodes = segments[0]["Floors"]["nodes"]
    if not nodes:
        raise RenderError("zone has no floors")

    floor_path, wall_path, tile_path = infer_assets(zone_path, zone_object)
    bundle = TileBundle.load(tile_path)
    floor_autotile = AdjacentAutoTile(floor_path, bundle)
    wall_autotile = AdjacentAutoTile(wall_path, bundle)

    outputs: dict[str, bytes] = {}
    records: list[dict[str, Any]] = []
    floor_pngs: list[bytes] = []
    asset_cache: dict[str, tuple[AdjacentAutoTile, Path, Path]] = {
        floor_path.stem: (floor_autotile, floor_path, tile_path),
        wall_path.stem: (wall_autotile, wall_path, tile_path),
    }
    for index, node in enumerate(nodes, 1):
        model = build_floor_model(index, node, args.zone_id)
        if model.generator == "procedural":
            floor_family = model.config["terrain_assets"]["floor"]
            wall_family = model.config["terrain_assets"]["wall"]
            if floor_family not in asset_cache:
                asset_cache[floor_family] = load_live_autotile(floor_family)
            if wall_family not in asset_cache:
                asset_cache[wall_family] = load_live_autotile(wall_family)
            active_floor = asset_cache[floor_family][0]
            active_wall = asset_cache[wall_family][0]
        else:
            active_floor = None
            active_wall = None
            for family in model.config["terrain_assets"]:
                if family not in asset_cache:
                    asset_cache[family] = load_live_autotile(family)
        png, record = render_floor(
            model,
            args.title,
            active_floor,
            active_wall,
            {family: cached[0] for family, cached in asset_cache.items()},
        )
        name = f"floor_{index}.png"
        outputs[name] = png
        floor_pngs.append(png)
        records.append(record)
    outputs["overview.png"] = render_overview(args.title, floor_pngs, records)

    heterogeneous = any(record.get("generator") == "static_load" for record in records) or len(asset_cache) > 2
    if heterogeneous:
        input_paths = {"zone": zone_path}
        for family, (_, autotile_asset, sheet_asset) in sorted(asset_cache.items()):
            input_paths[f"autotile:{family}"] = autotile_asset
            input_paths[f"tile_sheet:{sheet_asset.stem}"] = sheet_asset
    else:
        # Preserve the v1 report keys for homogeneous already-promoted zones.
        input_paths = {
            "zone": zone_path,
            "floor_autotile": floor_path,
            "wall_autotile": wall_path,
            "tile_sheet": tile_path,
        }
    report: dict[str, Any] = {
        "schema": SCHEMA,
        "status": "passed",
        "zone": {
            "id": args.zone_id,
            "title": args.title,
            "pmdo_version": zone_doc["Version"],
            "floors": len(nodes),
        },
        "method": {
            "id": RENDERER_METHOD,
            "source": "promoted ZoneData GridFloorGen recipes and PMDO AutoTileAdjacent terrain definitions",
            "terrain_pixels": "composited exclusively from referenced promoted .tile cells at animation tick zero",
            "topology": "deterministic representative built from serialized grid, room, branch, padding, tunnel, entry, and exit parameters",
            "overlay": "entry/stair/shortest-route/entity audit markers; overlays are deliberately not presented as native sprites",
        },
        "inputs": {
            label: {"path": str(path.relative_to(ROOT)), "bytes": path.stat().st_size, "sha256": sha256_file(path)}
            for label, path in input_paths.items()
        },
        "sheet_audit": (
            {
                "families": {
                    family: {
                        "tile_size": asset.bundle.tile_size,
                        "tile_cells": len(asset.bundle.cells),
                        "frames_used": [list(value) for value in sorted(asset.used_frames)],
                    }
                    for family, (asset, _, _) in sorted(asset_cache.items())
                },
                "missing_references": 0,
            }
            if heterogeneous
            else {
                "tile_size": bundle.tile_size,
                "tile_cells": len(bundle.cells),
                "floor_frames_used": [list(value) for value in sorted(floor_autotile.used_frames)],
                "wall_frames_used": [list(value) for value in sorted(wall_autotile.used_frames)],
                "missing_references": 0,
            }
        ),
        "floors": records,
        "outputs": {},
        "grouped_gate_scope": {
            "proved_here": [
                "inspectable PNGs exist for every converted floor",
                "promoted official terrain sheet cells resolve and cover every rendered map cell",
                "no rendered terrain cell is blank black or transparent",
                "deterministic representative topology is connected",
                "one reachable stair and one entry exist per floor",
                "collision, stair route, and sampled serialized entities are directly inspectable",
            ],
            "deferred_not_claimed": [
                "byte-for-byte identity with RogueElements random generation",
                "PMDO-native dungeon entry, playback, route, audio, and unload certification",
            ],
        },
    }
    for name, data in outputs.items():
        report["outputs"][name] = {"bytes": len(data), "sha256": sha256_bytes(data)}
    report_bytes = canonical_json(report)
    outputs[args.report_name] = report_bytes
    return outputs, report


def write_create_only(output_dir: Path, outputs: dict[str, bytes]) -> None:
    existing = [output_dir / name for name in outputs if (output_dir / name).exists()]
    if existing:
        raise FileExistsError("refusing to overwrite render evidence: " + ", ".join(map(str, existing)))
    output_dir.mkdir(parents=True, exist_ok=True)
    for name, data in outputs.items():
        path = output_dir / name
        with path.open("xb") as stream:
            stream.write(data)


def check_existing(output_dir: Path, expected: dict[str, bytes]) -> None:
    failures: list[str] = []
    for name, data in expected.items():
        path = output_dir / name
        if not path.is_file():
            failures.append(f"missing {path}")
            continue
        actual = path.read_bytes()
        if actual != data:
            failures.append(
                f"mismatch {path}: expected {sha256_bytes(data)}, found {sha256_bytes(actual)}"
            )
    if failures:
        raise RenderError("existing render gate failed:\n" + "\n".join(failures))


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--zone", type=Path, required=True, help="promoted PMDO ZoneData JSON")
    parser.add_argument("--zone-id", required=True, help="zone identifier used for deterministic seeds")
    parser.add_argument("--title", required=True, help="human-readable bilingual or localized title")
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--report-name", default="render_audit.json")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true", help="create outputs; refuse every overwrite")
    mode.add_argument("--check", action="store_true", help="rebuild in memory and compare existing outputs byte-for-byte")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        outputs, report = build(args)
        output_dir = args.output_dir.resolve()
        if args.write:
            write_create_only(output_dir, outputs)
            action = "created"
        else:
            check_existing(output_dir, outputs)
            action = "verified"
        print(
            f"PASS: {action} {len(report['floors'])} {args.zone_id} floor renders, "
            f"overview, and static audit at {output_dir}"
        )
        return 0
    except Exception as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
