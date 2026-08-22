#!/usr/bin/env python3
"""Build the clean Chapter 6 reconstruction of Sinister Woods.

This builder is intentionally *not* a map-layout cache.  It writes PMDO
``ChanceFloorGen`` entries whose RogueElements plans are selected and rolled by
the engine every time a procedural floor is entered.  The fixed entrance,
midpoint, and boss Grounds are the sole deliberately static pieces.

The auto-tile writer mirrors ``RogueEssence.Dungeon.AutoTileAdjacent``'s
neighbour-code calculation.  It only assigns an AutoTileset and lets PMDO's
existing DTEF-derived AutoTile data choose the appropriate edge/corner; it
never paints a transition tile by hand.

Usage:
    python3 tools/build_chapter6_sinister_woods.py --write
    python3 tools/build_chapter6_sinister_woods.py --check

``--write`` is idempotent and regenerates only the Chapter 6 canonical bundle.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import sys
from pathlib import Path
from typing import Any, Iterable

ROOT = Path(__file__).resolve().parents[1]
ZONE_ID = "gloomy_forest"  # preserved for save compatibility
PUBLIC_NAME = "Sinister Woods"
PUBLIC_NAME_FR = "Forêt Sinistre"
MUSIC = "Sinister Woods.ogg"
BOSS_MUSIC = "Boss Battle!.ogg"

# The runtime material is a unique PMDO AutoTileAdjacent namespace.  Its source
# binding to RawAsset/TileDtef/TreeshroudForest1 is recorded in
# docs/canonical_dungeons/dtef_bindings.json.  These names are deliberately
# never shared with Relic Forest.
DTEF_AUTOTILES = {
    "floor": "sinister_woods_b41_floor",
    "wall": "sinister_woods_b41_wall",
    "secondary": "sinister_woods_b41_secondary",
}

VERSION = "0.8.12.0"


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, value: Any, *, bom: bool = True) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    prefix = "\ufeff" if bom else ""
    path.write_text(prefix + json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def priority(*parts: int) -> dict[str, list[int]]:
    return {"str": list(parts)}


def loc(x: int, y: int) -> dict[str, int]:
    return {"X": x, "Y": y}


def autotile(name: str, *, associates: list[str] | None = None, neighbor: int = -1) -> dict[str, Any]:
    return {
        "AutoTileset": name,
        "Associates": associates or [],
        "Layers": [],
        "NeighborCode": neighbor,
    }


def walk(value: Any) -> Iterable[Any]:
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def find_first(value: Any, token: str) -> dict[str, Any]:
    for node in walk(value):
        if isinstance(node, dict) and token in node.get("$type", ""):
            return node
    raise ValueError(f"Could not find {token}")


def step_values(grid: dict[str, Any]) -> list[dict[str, Any]]:
    return [entry["Value"] for entry in grid.get("GenSteps", []) if isinstance(entry, dict) and isinstance(entry.get("Value"), dict)]


def find_grid_step(grid: dict[str, Any], token: str) -> dict[str, Any]:
    for value in step_values(grid):
        if token in value.get("$type", ""):
            return value
    raise ValueError(f"Grid generator is missing {token}")


def auto_neighbor_codes(cells: list[list[dict[str, Any]]]) -> None:
    """Populate PMDO AutoTileAdjacent codes exactly from topology.

    This is the topology portion of RogueEssence's ``AutoTileAdjacent``:
    bits 0..3 are blocked cardinal neighbours (down, left, up, right) and
    bits 4..7 are blocked diagonals when their adjacent cardinals are also
    blocked.  The 47 PMDO adjacent cases then resolve the 256 DTEF masks.
    """
    width = len(cells)
    height = len(cells[0]) if width else 0
    cardinal = ((0, 1), (-1, 0), (0, -1), (1, 0))
    diagonal = ((-1, 1), (-1, -1), (1, -1), (1, 1))

    for x in range(width):
        for y in range(height):
            current = cells[x][y]
            tileset = current.get("AutoTileset", "")
            if not tileset:
                current["NeighborCode"] = -1
                continue

            blocked: list[bool] = []
            for dx, dy in cardinal:
                nx, ny = x + dx, y + dy
                same = (
                    0 <= nx < width
                    and 0 <= ny < height
                    and cells[nx][ny].get("AutoTileset") == tileset
                )
                blocked.append(not same)

            code = sum((1 << index) for index, is_blocked in enumerate(blocked) if is_blocked)
            for index, (dx, dy) in enumerate(diagonal):
                if not (blocked[index] and blocked[(index + 1) % 4]):
                    continue
                nx, ny = x + dx, y + dy
                same = (
                    0 <= nx < width
                    and 0 <= ny < height
                    and cells[nx][ny].get("AutoTileset") == tileset
                )
                if not same:
                    code |= 1 << (index + 4)
            # Variant byte intentionally stays zero.  PMDO is free to select
            # animation frames/variants through the imported AutoTile data.
            current["NeighborCode"] = code


def retile_ground_with_dtef(ground: dict[str, Any]) -> None:
    """Retexture a fixed Ground from its collision geometry with AutoTiles."""
    obstacles = ground["obstacles"]
    obstacle_w = len(obstacles)
    obstacle_h = len(obstacles[0])

    for layer in ground["Layers"]:
        tiles = layer["Tiles"]
        width = len(tiles)
        height = len(tiles[0])
        if obstacle_w % width or obstacle_h % height:
            raise ValueError(
                f"Ground {ground.get('AssetName')} has incompatible visual/collision grids "
                f"{width}x{height} vs {obstacle_w}x{obstacle_h}"
            )
        scale_x, scale_y = obstacle_w // width, obstacle_h // height
        generated: list[list[dict[str, Any]]] = [[{} for _ in range(height)] for _ in range(width)]
        for x in range(width):
            for y in range(height):
                blocked = 0
                total = scale_x * scale_y
                for ox in range(x * scale_x, (x + 1) * scale_x):
                    for oy in range(y * scale_y, (y + 1) * scale_y):
                        if obstacles[ox][oy].get("Tags", 0) != 0:
                            blocked += 1
                # A visual cell can cover multiple 8px collision cells on a
                # TexSize=3 Ground.  Majority classification preserves the
                # original walkable footprint while allowing the auto-tile
                # system—not hand-drawn transitions—to resolve its border.
                material = DTEF_AUTOTILES["wall"] if blocked * 2 >= total else DTEF_AUTOTILES["floor"]
                generated[x][y] = autotile(material)
        auto_neighbor_codes(generated)
        layer["Tiles"] = generated


def retile_map_with_dtef(game_map: dict[str, Any]) -> None:
    """Replace a fixed boss map's visual material with the DTEF AutoTiles."""
    tiles = game_map["Tiles"]
    width = len(tiles)
    height = len(tiles[0])
    visual: list[list[dict[str, Any]]] = [[{} for _ in range(height)] for _ in range(width)]

    for x in range(width):
        for y in range(height):
            cell = tiles[x][y]
            terrain_id = cell.get("Data", {}).get("ID", "wall")
            material = DTEF_AUTOTILES["floor"] if terrain_id == "floor" else DTEF_AUTOTILES["wall"]
            cell["Data"]["TileTex"] = autotile(material)
            visual[x][y] = autotile(material)

    auto_neighbor_codes([[cell["Data"]["TileTex"] for cell in col] for col in tiles])
    auto_neighbor_codes(visual)
    game_map["Layers"] = [{"Name": "DTEF Base", "Layer": 0, "Visible": True, "Tiles": visual}]
    game_map["TextureMap"] = {
        "floor": autotile(DTEF_AUTOTILES["floor"]),
        "wall": autotile(DTEF_AUTOTILES["wall"]),
        "unbreakable": autotile(DTEF_AUTOTILES["wall"]),
        "water": autotile(DTEF_AUTOTILES["secondary"], associates=[DTEF_AUTOTILES["floor"]]),
    }


def free_rect(obstacles: list[list[dict[str, Any]]], desired_x: int, desired_y: int, size: int = 2) -> tuple[int, int]:
    """Find an unblocked ``size`` square nearest to an intended location."""
    width, height = len(obstacles), len(obstacles[0])

    def free(x: int, y: int) -> bool:
        return 0 <= x <= width - size and 0 <= y <= height - size and all(
            obstacles[ix][iy].get("Tags", 0) == 0
            for ix in range(x, x + size)
            for iy in range(y, y + size)
        )

    for distance in range(max(width, height)):
        for x in range(max(0, desired_x - distance), min(width - size, desired_x + distance) + 1):
            for y in range(max(0, desired_y - distance), min(height - size, desired_y + distance) + 1):
                if abs(x - desired_x) + abs(y - desired_y) == distance and free(x, y):
                    return x, y
    raise ValueError("No free ground cell available for a marker")


def collider(x: int, y: int, width: int = 16, height: int = 16) -> dict[str, int]:
    return {"X": x, "Y": y, "Width": width, "Height": height}


def ground_marker(name: str, x: int, y: int, direction: int = 4) -> dict[str, Any]:
    return {
        "EntName": name,
        "Direction": direction,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 0,
        "Collider": collider(x, y),
    }


def template_entity(path: str, category: str, name: str) -> dict[str, Any]:
    source = read_json(ROOT / path)["Object"]["Entities"][0][category]
    for entity in source:
        if entity.get("EntName") == name or entity.get("NPCName") == name:
            return copy.deepcopy(entity)
    raise ValueError(f"{path}: {category}/{name} missing")


def build_entrance_ground() -> dict[str, Any]:
    ground = copy.deepcopy(read_json(ROOT / "Data/Ground/d04p01.rsground")["Object"])
    ground.update(
        {
            "Name": {"DefaultText": "Sinister Woods Entrance", "LocalTexts": {"fr": "Entrée de la Forêt Sinistre"}},
            "AssetName": "sinister_woods_entrance",
            "Music": MUSIC,
            "Released": True,
            "Comment": (
                "D04P01 geometry preserved as the canonical Sinister Woods approach. "
                "Retextured with the unique DTEF-derived Sinister Woods AutoTiles."
            ),
        }
    )
    retile_ground_with_dtef(ground)

    obstacles = ground["obstacles"]
    entry_x, entry_y = free_rect(obstacles, len(obstacles) // 2, len(obstacles[0]) - 4)
    north_x, north_y = free_rect(obstacles, len(obstacles) // 2, 8)
    teammate_x, teammate_y = free_rect(obstacles, max(0, entry_x - 3), entry_y)

    teammate = template_entity("Data/Ground/crooked_den.rsground", "Spawners", "TEAMMATE_1")
    teammate["Collider"] = collider(teammate_x * 8, teammate_y * 8)
    teammate["NPCName"] = "Teammate1"
    teammate["EntName"] = "TEAMMATE_1"

    north = template_entity("Data/Ground/searing_tunnel_midpoint.rsground", "GroundObjects", "North_Exit")
    north["Collider"] = collider(north_x * 8, north_y * 8)
    south = template_entity("Data/Ground/searing_tunnel_midpoint.rsground", "GroundObjects", "South_Exit")
    south["Collider"] = collider(entry_x * 8, entry_y * 8)

    ground["Entities"] = [
        {
            "Markers": [
                ground_marker("Main_Entrance_Marker", entry_x * 8, entry_y * 8),
                ground_marker("Entrance", entry_x * 8, entry_y * 8),
            ],
            "Spawners": [teammate],
            "GroundObjects": [north, south],
            "MapChars": [],
        }
    ]
    return ground


def build_midpoint_ground() -> dict[str, Any]:
    # Searing Tunnel's functional checkpoint supplies the Kangaskhan Rock,
    # forward/back exits and partner spawn.  Only the visual material changes.
    ground = copy.deepcopy(read_json(ROOT / "Data/Ground/searing_tunnel_midpoint.rsground")["Object"])
    ground.update(
        {
            "Name": {"DefaultText": "Sinister Woods Midpoint", "LocalTexts": {"fr": "Relais de la Forêt Sinistre"}},
            "AssetName": "sinister_woods_mid",
            "Music": MUSIC,
            "Released": True,
            "Comment": (
                "Functional Searing Tunnel checkpoint template: Kangaskhan save/storage/rest, "
                "forward/back exits, rethemed through the Sinister Woods DTEF AutoTiles. "
                "Entity colliders are re-anchored on its proven connected collision component."
            ),
        }
    )
    retile_ground_with_dtef(ground)

    # The historic Searing art grid is TexSize=3 while its collision grid is
    # 8px.  Its original chapter scene positioned some entities outside the
    # walkable component.  Re-anchor only the interactive points, preserving
    # the template's statue and collision topology, so the checkpoint is
    # actually usable rather than merely visually cloned.
    obstacles = ground["obstacles"]
    entry_x, entry_y = free_rect(obstacles, 30, 40)
    north_x, north_y = free_rect(obstacles, 45, 20)
    mate_x, mate_y = free_rect(obstacles, max(0, entry_x - 3), entry_y)
    entities = ground["Entities"][0]
    for marker in entities["Markers"]:
        if marker.get("EntName") in {"Main_Entrance_Marker", "Entrance"}:
            marker["Collider"] = collider(entry_x * 8, entry_y * 8)
    for spawner in entities["Spawners"]:
        if spawner.get("EntName") == "TEAMMATE_1":
            spawner["Collider"] = collider(mate_x * 8, mate_y * 8)
    for obj in entities["GroundObjects"]:
        if obj.get("EntName") == "North_Exit":
            obj["Collider"] = collider(north_x * 8, north_y * 8)
        elif obj.get("EntName") == "South_Exit":
            obj["Collider"] = collider(entry_x * 8, entry_y * 8)
    return ground


def build_boss_ground() -> dict[str, Any]:
    # Crooked Den is the approved compact boss-room template.  The fixed
    # battle map is loaded only after this narrative staging Ground.
    ground = copy.deepcopy(read_json(ROOT / "Data/Ground/crooked_den.rsground")["Object"])
    ground.update(
        {
            "Name": {"DefaultText": "Sinister Woods Boss", "LocalTexts": {"fr": "Clairière de la Forêt Sinistre"}},
            "AssetName": "sinister_woods_boss",
            "Music": BOSS_MUSIC,
            "Released": True,
            "Comment": (
                "Crooked Den boss-room template calibrated for the three-member Team Meanies encounter; "
                "retextured through the Sinister Woods DTEF AutoTiles."
            ),
        }
    )
    retile_ground_with_dtef(ground)
    return ground


def item_spawn(item_id: str, rate: int, floor_min: int, floor_max: int) -> dict[str, Any]:
    return {
        "Spawn": {"ID": item_id, "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0},
        "Rate": rate,
        "Range": {"Min": floor_min, "Max": floor_max},
    }


def item_group(items: list[tuple[str, int]], category_rate: int, floor_count: int) -> dict[str, Any]:
    return {
        "Spawns": [item_spawn(item_id, rate, 0, floor_count) for item_id, rate in items],
        "SpawnRates": {"nodes": [{"Item": category_rate, "Range": {"Min": 0, "Max": floor_count}}]},
    }


def build_item_zone_step(floor_count: int) -> dict[str, Any]:
    """A PMDO table adapted from the Generation III Sinister Woods pool.

    Values are intentionally weights in PMDO categories, not a copy of the
    source table.  Every listed item is available throughout 1F-12F, matching
    the source availability while keeping the game's native item model.
    """
    gummies = [
        ("gummi_blue", 2), ("gummi_brown", 2), ("gummi_clear", 2), ("gummi_gold", 2),
        ("gummi_grass", 3), ("gummi_green", 2), ("gummi_orange", 2), ("gummi_pink", 2),
        ("gummi_sky", 2), ("gummi_white", 2), ("gummi_yellow", 2),
    ]
    return {
        "$type": "RogueEssence.LevelGen.ItemSpawnZoneStep, RogueEssence",
        "Priority": priority(2, 1),
        "Spawns": {
            "necessities": item_group(
                [("food_apple", 18), ("berry_cheri", 7), ("berry_oran", 12), ("berry_pecha", 7), ("berry_rawst", 7)],
                38,
                floor_count,
            ),
            "Seeds": item_group([("seed_blast", 9), ("seed_reviver", 7)], 14, floor_count),
            "Orbs": item_group(
                [("orb_escape", 11), ("orb_luminous", 5), ("orb_scanner", 5), ("orb_rollcall", 5), ("orb_stayaway", 5)],
                16,
                floor_count,
            ),
            "Other": item_group([("medicine_max_elixir", 10), *gummies], 12, floor_count),
        },
    }


def mob_record(
    template: dict[str, Any],
    species: str,
    level: int,
    rate: int,
    floor_min: int,
    floor_max: int,
) -> dict[str, Any]:
    row = copy.deepcopy(template)
    mob = row["Spawn"]["Spawn"]
    mob["BaseForm"] = {"Species": species, "Form": 0, "Skin": "", "Gender": -1}
    mob["Level"] = {"Min": level, "Max": level + 1}
    mob["SpecifiedSkills"] = []
    mob["Intrinsic"] = ""
    mob["Tactic"] = "wander_dumb"
    mob["SpawnConditions"] = []
    mob["SpawnFeatures"] = [{"$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"}]
    mob["Comment"] = "CANONICAL_SINISTER_WOODS_BULBAPEDIA_ADAPTED"
    row["Rate"] = rate
    row["Range"] = {"Min": floor_min, "Max": floor_max}
    row["Role"] = 0
    return row


def build_team_zone_step(template: dict[str, Any], segment: int) -> dict[str, Any]:
    """Official Gen III wildlife, represented as PMDO weighted floor ranges."""
    base = copy.deepcopy(template)
    record_template = base["Spawns"][0]
    if segment == 0:
        # Ranges are local zero-based PMDO spans for canonical floors 1..10.
        entries = [
            ("swinub", 8, 12, 0, 3),
            ("oddish", 7, 13, 0, 4),
            ("sudowoodo", 7, 11, 0, 4),
            ("sunflora", 8, 8, 1, 7),
            ("sentret", 6, 9, 2, 6),
            ("silcoon", 8, 5, 3, 6),
            ("cascoon", 8, 5, 3, 6),
            ("shroomish", 9, 12, 5, 10),
            ("linoone", 8, 7, 6, 9),
            ("ledyba", 7, 10, 6, 10),
            ("wooper", 10, 10, 7, 10),
            ("scyther", 10, 8, 7, 10),
        ]
    else:
        # Canonical 11F-12F represented in local 0..2 indices.
        entries = [
            ("shroomish", 9, 12, 0, 2),
            ("scyther", 10, 8, 0, 1),
            ("exeggutor", 8, 6, 0, 2),
            ("hoothoot", 6, 9, 0, 2),
            ("slakoth", 8, 9, 0, 2),
        ]
    base["Spawns"] = [mob_record(record_template, *entry) for entry in entries]
    return base


def build_money_zone_step(floor_count: int, start_min: int, start_max: int) -> dict[str, Any]:
    return {
        "$type": "RogueEssence.LevelGen.MoneySpawnZoneStep, RogueEssence",
        "Priority": priority(2),
        "StartAmount": {"Min": start_min, "Max": start_max},
        "AddAmount": {"Min": 1, "Max": 5},
        "ModStates": [],
    }


def floor_name_step(name: str, local_name: str) -> dict[str, Any]:
    return {
        "$type": "PMDC.LevelGen.FloorNameDropZoneStep, PMDC",
        "DropPriority": priority(-15),
        "Name": {"DefaultText": name, "LocalTexts": {"fr": local_name}},
        "Priority": priority(-6),
    }


def zone_steps(
    *,
    floor_count: int,
    team_template: dict[str, Any],
    segment: int,
    floor_name: dict[str, Any] | None,
) -> list[dict[str, Any]]:
    steps: list[dict[str, Any]] = [
        {"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC", "Priority": priority(1, 1)},
    ]
    if floor_name is not None:
        steps.append(floor_name)
    steps.extend(
        [
            build_money_zone_step(floor_count, 4 if segment == 0 else 50, 40 if segment == 0 else 76),
            build_item_zone_step(floor_count),
            build_team_zone_step(team_template, segment),
            # Canonical RB Sinister Woods has no traps.  Keep an explicit empty
            # native step so future edits cannot silently inherit a trap pool.
            {"$type": "RogueEssence.LevelGen.TileSpawnZoneStep, RogueEssence", "Priority": priority(2, 3), "Spawns": []},
        ]
    )
    return steps


def direct_floor_name_step(offset: int) -> list[dict[str, Any]]:
    """Display global 11/12 rather than a reset segment-local number."""
    return [
        {
            "Key": priority(-6, 1),
            "Value": {
                "$type": "RogueEssence.LevelGen.MapNameIDStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueEssence",
                "Name": {"DefaultText": "Sinister Woods {0}", "LocalTexts": {"fr": "Forêt Sinistre {0}"}},
                "IDOffset": offset,
            },
        },
        {
            "Key": priority(-6, 2),
            "Value": {
                "$type": "PMDC.LevelGen.MapTitleDropStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC",
                "DropPriority": priority(-15),
            },
        },
    ]


def dark_step() -> dict[str, Any]:
    return {
        "Key": priority(-6, 0),
        "Value": {
            "$type": "PMDC.LevelGen.StateMapStatusStep`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], PMDC",
            "MapStatus": "darkness",
            "States": [],
        },
    }


def update_grid_generator(
    grid: dict[str, Any],
    *,
    floor_index: int,
    variant_index: int,
    variant: str,
    dark: bool,
    global_name_offset: int | None,
    connect_template: dict[str, Any],
    tunnel_template: dict[str, Any],
) -> dict[str, Any]:
    grid = copy.deepcopy(grid)
    strip_tokens = ("PerlinWaterStep", "AddTunnelStep", "MapEffectStep", "ScriptGenStep")
    grid["GenSteps"] = [
        entry
        for entry in grid["GenSteps"]
        if not any(token in entry.get("Value", {}).get("$type", "") for token in strip_tokens)
    ]

    map_data = find_grid_step(grid, "MapDataStep")
    map_data.update({"Music": MUSIC, "TimeLimit": 1000, "TileSight": 0, "CharSight": 1, "ClampCamera": False})

    texture = find_grid_step(grid, "MapTextureStep")
    texture.update(
        {
            "GroundTileset": DTEF_AUTOTILES["floor"],
            "BlockTileset": DTEF_AUTOTILES["wall"],
            "WaterTileset": DTEF_AUTOTILES["secondary"],
            "LayeredGround": False,
            "IndependentGround": False,
            "GroundElement": "grass",
        }
    )

    init = find_grid_step(grid, "InitGridPlanStep")
    shapes = ((4, 3, 9, 9, 3), (5, 3, 8, 9, 2), (4, 4, 8, 8, 3), (5, 4, 7, 8, 2), (6, 3, 7, 9, 2), (3, 5, 9, 7, 3))
    cell_x, cell_y, cell_w, cell_h, cell_wall = shapes[(floor_index * 3 + variant_index) % len(shapes)]
    init.update({"CellX": cell_x, "CellY": cell_y, "CellWidth": cell_w, "CellHeight": cell_h, "CellWall": cell_wall, "Wrap": False})

    stairs = find_grid_step(grid, "FloorStairsStep")
    stairs["MinDistance"] = 8
    stairs["Exits"][0]["Tile"]["ID"] = "stairs_go_up"

    path_steps = [step for step in step_values(grid) if "GridPath" in step.get("$type", "")]
    if not path_steps:
        raise ValueError("No GridPath step in template")
    path = path_steps[0]
    if variant == "tiered":
        # Tiered grids make broad lateral rooms and a readable progression.
        path["TierAxis"] = (floor_index + variant_index) % 2
        path["TierConnections"] = {"Min": 2, "Max": 3 + (floor_index % 2)}
    else:
        # Branch plans make loops, optional side areas, and dead ends.  Their
        # room/hall generators remain the engine's native SpawnLists.
        if "GridPathBranch" not in path.get("$type", ""):
            path["$type"] = "RogueElements.GridPathBranch`1[[RogueEssence.LevelGen.MapGenContext, RogueEssence]], RogueElements"
            path.pop("TierAxis", None)
            path.pop("TierConnections", None)
            path["RoomRatio"] = {"Min": 55, "Max": 75}
            path["BranchRatio"] = {"Min": 30, "Max": 60}
            path["NoForcedBranches"] = False
        else:
            path["RoomRatio"] = {"Min": 48 + (floor_index % 4) * 6, "Max": 68 + (variant_index % 3) * 5}
            path["BranchRatio"] = {"Min": 25 + (floor_index % 3) * 10, "Max": 58 + (variant_index % 2) * 12}
            path["NoForcedBranches"] = False

    connect_steps = [step for step in step_values(grid) if "ConnectGridBranchStep" in step.get("$type", "")]
    if connect_steps:
        connect = connect_steps[0]
    else:
        connect = copy.deepcopy(connect_template)
        grid["GenSteps"].append({"Key": priority(-4, 1), "Value": connect})
    connect["ConnectPercent"] = 42 + ((floor_index * 11 + variant_index * 17) % 48)

    if variant == "loop":
        tunnel = copy.deepcopy(tunnel_template)
        tunnel["Halls"] = {"Min": 3 + (floor_index % 3), "Max": 6 + (variant_index % 3)}
        grid["GenSteps"].append({"Key": priority(0, 3), "Value": tunnel})

    if dark:
        grid["GenSteps"].insert(0, dark_step())
    if global_name_offset is not None:
        grid["GenSteps"].extend(direct_floor_name_step(global_name_offset))

    grid["Comment"] = (
        f"Sinister Woods canonical procedural floor {floor_index + 1}; "
        f"runtime layout family={variant}; no static seed or cached layout."
    )
    return grid


def make_chance_floor(
    tiered_template: dict[str, Any],
    branch_template: dict[str, Any],
    connect_template: dict[str, Any],
    tunnel_template: dict[str, Any],
    *,
    floor_index: int,
    dark: bool,
    global_name_offset: int | None,
) -> dict[str, Any]:
    choices = (("branch", branch_template, 8), ("tiered", tiered_template, 7), ("loop", branch_template, 6))
    return {
        "$type": "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence",
        "Spawns": [
            {
                "Spawn": update_grid_generator(
                    template,
                    floor_index=floor_index,
                    variant_index=variant_index,
                    variant=kind,
                    dark=dark,
                    global_name_offset=global_name_offset,
                    connect_template=connect_template,
                    tunnel_template=tunnel_template,
                ),
                "Rate": rate,
            }
            for variant_index, (kind, template, rate) in enumerate(choices)
        ],
    }


def make_range_segment(
    segment_template: dict[str, Any],
    *,
    floor_count: int,
    segment_number: int,
    tiered_template: dict[str, Any],
    branch_template: dict[str, Any],
    connect_template: dict[str, Any],
    tunnel_template: dict[str, Any],
    team_template: dict[str, Any],
) -> dict[str, Any]:
    segment = copy.deepcopy(segment_template)
    nodes = []
    for local_floor in range(floor_count):
        global_floor = local_floor if segment_number == 0 else local_floor + 10
        # RB darkness: 5F-7F, 11F and 12F.  It is gameplay visibility,
        # not a substitute for the material/biome transition.
        dark = global_floor in {4, 5, 6, 10, 11}
        offset = 11 if segment_number == 1 else None
        nodes.append(
            {
                "Item": make_chance_floor(
                    tiered_template,
                    branch_template,
                    connect_template,
                    tunnel_template,
                    floor_index=global_floor,
                    dark=dark,
                    global_name_offset=offset,
                ),
                "Range": {"Min": local_floor, "Max": local_floor + 1},
            }
        )
    segment["Floors"] = {"nodes": nodes}
    segment["ZoneSteps"] = zone_steps(
        floor_count=floor_count,
        team_template=team_template,
        segment=segment_number,
        floor_name=floor_name_step("Sinister Woods {0}", "Forêt Sinistre {0}") if segment_number == 0 else None,
    )
    segment["IsRelevant"] = True
    segment["Comment"] = (
        "Sinister Woods F1-F10: canonical forest approach with three runtime RogueElements layout families."
        if segment_number == 0
        else "Sinister Woods F11-F12: darker final approach, still regenerated at every visit."
    )
    return segment


def build_zone() -> dict[str, Any]:
    base = read_json(ROOT / "Data/Zone/mt_blaze.json")["Object"]
    crooked = read_json(ROOT / "Data/Zone/crooked_cavern.json")["Object"]
    zone = copy.deepcopy(base)

    tiered_template = copy.deepcopy(base["Segments"][0]["Floors"]["nodes"][0]["Item"]["Spawns"][0]["Spawn"])
    branch_template = copy.deepcopy(crooked["Segments"][0]["Floors"]["nodes"][0]["Item"])
    connect_template = copy.deepcopy(find_first(branch_template, "ConnectGridBranchStep"))
    tunnel_template = copy.deepcopy(find_first(branch_template, "AddTunnelStep"))
    team_template = copy.deepcopy(base["Segments"][0]["ZoneSteps"][4])

    segment0 = make_range_segment(
        base["Segments"][0],
        floor_count=10,
        segment_number=0,
        tiered_template=tiered_template,
        branch_template=branch_template,
        connect_template=connect_template,
        tunnel_template=tunnel_template,
        team_template=team_template,
    )
    segment1 = make_range_segment(
        base["Segments"][1],
        floor_count=2,
        segment_number=1,
        tiered_template=tiered_template,
        branch_template=branch_template,
        connect_template=connect_template,
        tunnel_template=tunnel_template,
        team_template=team_template,
    )
    boss_segment = copy.deepcopy(base["Segments"][2])
    boss_segment["Floors"][0]["GenSteps"][0]["Value"]["MapID"] = "sinister_woods_boss"
    boss_segment["ZoneSteps"] = [
        {"$type": "PMDC.LevelGen.SaveVarsZoneStep, PMDC", "Priority": priority(1, 1)},
        floor_name_step("Sinister Woods 13", "Forêt Sinistre 13"),
    ]
    boss_segment["IsRelevant"] = True
    boss_segment["Comment"] = "Canonical fixed 13F Team Meanies battle, loaded from sinister_woods_boss.rsmap."

    zone.update(
        {
            "Name": {"DefaultText": PUBLIC_NAME, "LocalTexts": {"fr": PUBLIC_NAME_FR}},
            "Released": True,
            "Comment": (
                "Canonical PMD Red/Blue Rescue Team Sinister Woods reconstruction: 12 regenerated exploration floors, "
                "a fixed midpoint checkpoint after 10F, and the fixed Team Meanies 13F confrontation. "
                "RawAsset DTEF binding and Bulbapedia adaptation are documented in docs/canonical_dungeons/."
            ),
            "NoEXP": False,
            "ExpPercent": 100,
            "Level": -1,
            "LevelCap": False,
            "KeepSkills": False,
            "TeamRestrict": False,
            "TeamSize": 3,
            "MoneyRestrict": False,
            "BagRestrict": -1,
            "KeepTreasure": False,
            "BagSize": -1,
            "Persistent": False,
            "Rescues": 10,
            "Rogue": 0,
            "Segments": [segment0, segment1, boss_segment],
            "GroundMaps": ["sinister_woods_entrance", "sinister_woods_mid", "sinister_woods_boss"],
            "CanonicalSource": {
                "Dungeon": "Sinister Woods",
                "Game": "Pokémon Mystery Dungeon: Red Rescue Team / Blue Rescue Team",
                "Bulbapedia": "https://bulbapedia.bulbagarden.net/wiki/Sinister_Woods",
                "FloorCount": 13,
                "ProceduralFloors": 12,
                "FixedBossFloor": 13,
                "DTEFBinding": "docs/canonical_dungeons/dtef_bindings.json",
            },
        }
    )
    return zone


def set_boss_character(character: dict[str, Any], *, species: str, level: int, hp: int, elements: tuple[str, str], skills: list[tuple[str, int]], position: tuple[int, int], nickname: str) -> None:
    form = {"Species": species, "Form": 0, "Skin": "normal", "Gender": -1}
    character["Element1"], character["Element2"] = elements
    character["serializationLoc"] = loc(*position)
    character["serializationDir"] = 4
    character["CurrentForm"] = copy.deepcopy(form)
    character["BaseForm"] = copy.deepcopy(form)
    character["Skills"] = [
        {"Element": {"SkillNum": skill, "Charges": charges, "Enabled": True, "Sealed": False}, "BackRef": index}
        for index, (skill, charges) in enumerate(skills)
    ]
    character["BaseSkills"] = [{"SkillNum": skill, "Charges": charges, "CanForget": False} for skill, charges in skills]
    character["Intrinsics"] = []
    character["BaseIntrinsics"] = ["none"]
    character["HP"] = hp
    character["MaxHPBonus"] = 0
    character["Level"] = level
    character["EXP"] = 0
    character["Nickname"] = nickname
    character["Unrecruitable"] = True
    character["EnemyOfFriend"] = False
    character["AttackFriend"] = False


def build_boss_map() -> dict[str, Any]:
    # chapter_3_boss_fight is the validated Crooked Den-derived 3-enemy map
    # shape.  Its 15x18 interior is intentionally tight enough for the
    # canonical low-level trio without becoming a one-tile corridor.
    game_map = copy.deepcopy(read_json(ROOT / "Data/Map/chapter_3_boss_fight.rsmap")["Object"])
    game_map.update(
        {
            "Name": {"DefaultText": "Sinister Woods 13", "LocalTexts": {"fr": "Forêt Sinistre 13"}},
            "AssetName": "sinister_woods_boss",
            "Music": BOSS_MUSIC,
            "Element": "grass",
            "Released": True,
            "Comment": (
                "Crooked Den-derived 15x18 fixed boss room. Canonical Team Meanies stats/levels are adapted "
                "from Sinister Woods (RB); all tile transitions are DTEF AutoTiles."
            ),
            "NoRescue": True,
        }
    )

    teams = copy.deepcopy(game_map["MapTeams"])
    specs = [
        ("gengar", 15, 80, ("ghost", "poison"), [("curse", 10), ("lick", 20), ("spite", 10), ("hypnosis", 15)], (7, 4), "Gengar"),
        ("ekans", 15, 58, ("poison", "none"), [("wrap", 15), ("leer", 30), ("bite", 20), ("poison_sting", 20)], (5, 5), "Ekans"),
        ("medicham", 12, 60, ("fighting", "psychic"), [("meditate", 20), ("confusion", 20), ("detect", 5), ("thunder_punch", 15)], (9, 5), "Medicham"),
    ]
    for team, spec in zip(teams, specs):
        set_boss_character(team["Players"][0], species=spec[0], level=spec[1], hp=spec[2], elements=spec[3], skills=spec[4], position=spec[5], nickname=spec[6])
        team["Name"] = spec[6]
        team["LeaderIndex"] = 0
        team["FoeConflict"] = False
    game_map["MapTeams"] = teams
    game_map["EntryPoints"] = [
        {"Loc": loc(7, 12), "Dir": 4},
        {"Loc": loc(6, 12), "Dir": 4},
        {"Loc": loc(8, 12), "Dir": 4},
    ]
    retile_map_with_dtef(game_map)
    return game_map


def rebuild_index(zone: dict[str, Any]) -> None:
    index_path = ROOT / "Data/Zone/index.idx"
    index = read_json(index_path)
    entries = index["Object"]
    summary_template = copy.deepcopy(entries["mt_blaze"])
    summary_template.update(
        {
            "ExpPercent": zone["ExpPercent"],
            "Level": zone["Level"],
            "LevelCap": zone["LevelCap"],
            "KeepSkills": zone["KeepSkills"],
            "TeamRestrict": zone["TeamRestrict"],
            "TeamSize": zone["TeamSize"],
            "MoneyRestrict": zone["MoneyRestrict"],
            "BagRestrict": zone["BagRestrict"],
            "KeepTreasure": zone["KeepTreasure"],
            "BagSize": zone["BagSize"],
            "Rescues": zone["Rescues"],
            "CountedFloors": 13,
            "Rogue": zone["Rogue"],
            "Grounds": list(zone["GroundMaps"]),
            "Maps": [list(range(10)), list(range(2)), [0]],
            "Name": copy.deepcopy(zone["Name"]),
            "Released": True,
            "SortOrder": 0,
            "Comment": "Canonical Sinister Woods: 10F -> midpoint -> 2F -> Team Meanies 13F.",
        }
    )
    entries[ZONE_ID] = summary_template

    master_path = ROOT / "Data/Zone/master_zone.json"
    master = read_json(master_path)
    grounds = master["Object"].setdefault("GroundMaps", [])
    # D04P02's historical `sinister_woods_clearing` asset remains on disk as
    # protected source material, but it is not an active route any more: the
    # canonical boss Ground is `sinister_woods_boss` by naming contract.
    grounds[:] = [name for name in grounds if name != "sinister_woods_clearing"]
    for name in zone["GroundMaps"]:
        if name not in grounds:
            grounds.append(name)
    entries["master_zone"]["Grounds"] = list(grounds)

    # These pre-existing global files are UTF-8 JSON without a BOM.  Preserve
    # their encoding so a chapter build does not create a meaningless full-file
    # binary/text diff.
    write_json(master_path, master, bom=False)
    write_json(index_path, index, bom=False)


def write_lua_scripts() -> None:
    scripts: dict[str, str] = {
        "Data/Script/halcyon/zone/gloomy_forest/init.lua": """-- Canonical Sinister Woods (Chapter 6): compact, re-generated PMD Red route.\nrequire 'origin.common'\nrequire 'halcyon.GeneralFunctions'\n\nlocal gloomy_forest = {}\n\nfunction gloomy_forest.Init(zone)\n  DEBUG.EnableDbgCoro()\n  SV.TemporaryFlags = SV.TemporaryFlags or {}\n  SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'\nend\n\nfunction gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)\n  -- Rescue Team allows rescues in the exploration, never in the fixed boss room.\n  GAME:SetRescueAllowed(segmentID < 2)\n  if rescuing ~= true then\n    COMMON.BeginDungeon(zone.ID, segmentID, mapID)\n  end\nend\n\nfunction gloomy_forest.Rescued(zone, name, mail)\n  COMMON.Rescued(zone, name, mail)\nend\n\nlocal function return_to_town(result)\n  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)\nend\n\nfunction gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)\n  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end\n  SV.adventure.Thief = false\n  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n\n  if segmentID == 0 then\n    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then\n      SV.CanonicalDungeons.SinisterWoodsCheckpoint = true\n      GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')\n    else\n      return_to_town(result)\n    end\n    return\n  end\n\n  if segmentID == 1 then\n    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then\n      GAME:EnterGroundMap('sinister_woods_boss', 'Main_Entrance_Marker')\n    elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then\n      GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')\n    else\n      SV.CanonicalDungeons.SinisterWoodsBossFailed = true\n      GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')\n    end\n    return\n  end\n\n  -- Segment 2 is the fixed 13F Team Meanies battle.\n  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then\n    SV.CanonicalDungeons.SinisterWoodsCleared = true\n    SV.CanonicalDungeons.SinisterWoodsBossFailed = false\n    return_to_town(result)\n  elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then\n    GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')\n  else\n    SV.CanonicalDungeons.SinisterWoodsBossFailed = true\n    GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')\n  end\nend\n\nreturn gloomy_forest\n""",
        "Data/Script/halcyon/ground/sinister_woods_entrance/init.lua": """-- Canonical Sinister Woods entrance.\nrequire 'origin.common'\nrequire 'halcyon.PartnerEssentials'\n\nlocal sinister_woods_entrance = {}\n\nfunction sinister_woods_entrance.Init(map)\n  DEBUG.EnableDbgCoro()\n  COMMON.RespawnAllies(true)\n  PartnerEssentials.InitializePartnerSpawn()\nend\n\nfunction sinister_woods_entrance.Enter(map)\n  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n  if not SV.CanonicalDungeons.SinisterWoodsApproachSeen then\n    SV.CanonicalDungeons.SinisterWoodsApproachSeen = true\n    UI:ResetSpeaker(false)\n    UI:WaitShowDialogue('La Forêt Sinistre est silencieuse… Restons groupés.')\n  end\n  GAME:FadeIn(20)\nend\n\nfunction sinister_woods_entrance.North_Exit_Touch(obj, activator)\n  UI:ChoiceMenuYesNo('Entrer dans la Forêt Sinistre ?', true)\n  UI:WaitForChoice()\n  if UI:ChoiceResult() then\n    SOUND:FadeOutBGM(30)\n    GAME:FadeOut(false, 30)\n    GAME:EnterDungeon('gloomy_forest', 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)\n  end\nend\n\nfunction sinister_woods_entrance.South_Exit_Touch(obj, activator)\n  SOUND:FadeOutBGM(20)\n  GAME:FadeOut(false, 20)\n  GAME:EnterGroundMap('metano_town', 'Main_Entrance_Marker')\nend\n\nfunction sinister_woods_entrance.Teammate1_Action(chara, activator)\n  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))\nend\n\nreturn sinister_woods_entrance\n""",
        "Data/Script/halcyon/ground/sinister_woods_mid/init.lua": """-- Searing Tunnel checkpoint mechanics, retextured for Sinister Woods.\nrequire 'origin.common'\nrequire 'halcyon.GeneralFunctions'\nrequire 'halcyon.PartnerEssentials'\n\nlocal sinister_woods_mid = {}\n\nfunction sinister_woods_mid.Init(map)\n  DEBUG.EnableDbgCoro()\n  COMMON.RespawnAllies(true)\n  PartnerEssentials.InitializePartnerSpawn()\nend\n\nfunction sinister_woods_mid.Enter(map)\n  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n  SV.CanonicalDungeons.SinisterWoodsCheckpoint = true\n  GAME:FadeIn(20)\nend\n\nfunction sinister_woods_mid.North_Exit_Touch(obj, activator)\n  UI:ChoiceMenuYesNo('Continuer vers les profondeurs de la Forêt Sinistre ?', true)\n  UI:WaitForChoice()\n  if UI:ChoiceResult() then\n    SOUND:FadeOutBGM(30)\n    GAME:FadeOut(false, 30)\n    GAME:EnterDungeon('gloomy_forest', 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)\n  end\nend\n\nfunction sinister_woods_mid.South_Exit_Touch(obj, activator)\n  UI:ChoiceMenuYesNo('Revenir à l’entrée de la Forêt Sinistre ?', true)\n  UI:WaitForChoice()\n  if UI:ChoiceResult() then\n    SOUND:FadeOutBGM(30)\n    GAME:FadeOut(false, 30)\n    GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')\n  end\nend\n\nfunction sinister_woods_mid.Kangaskhan_Rock_Action(obj, activator)\n  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)\nend\n\nfunction sinister_woods_mid.Teammate1_Action(chara, activator)\n  UI:SetSpeaker(chara)\n  UI:WaitShowDialogue('Le rocher de Kangourex peut nous soigner et sauvegarder. Préparons-nous avant de continuer.')\n  UI:ResetSpeaker()\nend\n\nreturn sinister_woods_mid\n""",
        "Data/Script/halcyon/ground/sinister_woods_boss/init.lua": """-- Fixed canonical 13F boss staging Ground.\nrequire 'origin.common'\nrequire 'halcyon.PartnerEssentials'\n\nlocal sinister_woods_boss = {}\n\nfunction sinister_woods_boss.Init(map)\n  DEBUG.EnableDbgCoro()\n  COMMON.RespawnAllies(true)\n  PartnerEssentials.InitializePartnerSpawn()\nend\n\nfunction sinister_woods_boss.Enter(map)\n  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n  UI:ResetSpeaker(false)\n  if SV.CanonicalDungeons.SinisterWoodsBossFailed then\n    UI:WaitShowDialogue('La Team Meanies garde toujours la clairière. Cette fois, nous pouvons les vaincre.')\n  else\n    UI:WaitShowDialogue('Au cœur de la Forêt Sinistre, la Team Meanies nous attend.')\n  end\n  SV.CanonicalDungeons.SinisterWoodsBossStarted = true\n  SOUND:FadeOutBGM(30)\n  GAME:FadeOut(false, 30)\n  GAME:EnterDungeon('gloomy_forest', 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)\nend\n\nreturn sinister_woods_boss\n""",
    }
    for relative, content in scripts.items():
        path = ROOT / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")


def update_chapter6_entry_reference() -> None:
    # Any live route/debug shortcut must target the reconstructed Ground, not
    # the deleted substitute Ground whose filename is intentionally absent.
    targets = (
        ROOT / "Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua",
        ROOT / "Data/Script/halcyon/ground/metano_town/init.lua",
        ROOT / "Data/Script/halcyon/SceneDebug.lua",
    )
    for path in targets:
        if not path.is_file():
            continue
        text = path.read_text(encoding="utf-8")
        text = text.replace("'gloomy_forest_entrance'", "'sinister_woods_entrance'")
        text = text.replace('"gloomy_forest_entrance"', '"sinister_woods_entrance"')
        path.write_text(text, encoding="utf-8")


def validate() -> list[str]:
    errors: list[str] = []
    dtef_root = ROOT / "Content/TileDtef/sinister_woods/TreeshroudForest1"
    provenance_path = dtef_root / "RAWASSET_PROVENANCE.json"
    if not provenance_path.is_file():
        errors.append("RawAsset DTEF provenance manifest missing")
    else:
        provenance = read_json(provenance_path)
        if provenance.get("source_path") != "TileDtef/TreeshroudForest1":
            errors.append("unexpected RawAsset DTEF source path")
        for row in provenance.get("files", []):
            candidate = dtef_root / row.get("name", "")
            if not candidate.is_file():
                errors.append(f"RawAsset DTEF file missing: {candidate.name}")
            elif hashlib.sha256(candidate.read_bytes()).hexdigest() != row.get("sha256"):
                errors.append(f"RawAsset DTEF hash mismatch: {candidate.name}")
    if not (ROOT / "docs/canonical_dungeons/dtef_bindings.json").is_file():
        errors.append("DTEF binding registry missing")

    zone_path = ROOT / "Data/Zone/gloomy_forest.json"
    if not zone_path.is_file():
        return ["Data/Zone/gloomy_forest.json missing"]
    zone = read_json(zone_path)["Object"]
    if zone.get("Name", {}).get("DefaultText") != PUBLIC_NAME:
        errors.append("wrong public name")
    if len(zone.get("Segments", [])) != 3:
        errors.append("Sinister Woods must have exactly 3 segments")
    if zone.get("GroundMaps") != ["sinister_woods_entrance", "sinister_woods_mid", "sinister_woods_boss"]:
        errors.append("ground naming contract broken")

    for index, expected_count in ((0, 10), (1, 2)):
        nodes = zone["Segments"][index].get("Floors", {}).get("nodes", [])
        if len(nodes) != expected_count:
            errors.append(f"segment {index}: expected {expected_count} floor nodes")
            continue
        for local_floor, node in enumerate(nodes):
            if node.get("Range") != {"Min": local_floor, "Max": local_floor + 1}:
                errors.append(f"segment {index} floor {local_floor}: non-unit range")
            chance = node.get("Item", {})
            if "ChanceFloorGen" not in chance.get("$type", "") or len(chance.get("Spawns", [])) < 3:
                errors.append(f"segment {index} floor {local_floor}: needs 3 runtime layout families")
            for spawn in chance.get("Spawns", []):
                grid = spawn.get("Spawn", {})
                serial = json.dumps(grid)
                if "FirstSeed" in serial or '"seed"' in serial.lower():
                    errors.append(f"segment {index} floor {local_floor}: fixed seed found")
                for required in ("InitGridPlanStep", "GridPath", "FloorStairsStep", "MapTextureStep"):
                    if required not in serial:
                        errors.append(f"segment {index} floor {local_floor}: missing {required}")
                if DTEF_AUTOTILES["floor"] not in serial or DTEF_AUTOTILES["wall"] not in serial:
                    errors.append(f"segment {index} floor {local_floor}: missing DTEF material")

    master = read_json(ROOT / "Data/Zone/master_zone.json")["Object"]
    if "sinister_woods_clearing" in master.get("GroundMaps", []):
        errors.append("legacy sinister_woods_clearing is still registered as an active Ground")
    for name in ("sinister_woods_entrance", "sinister_woods_mid", "sinister_woods_boss"):
        path = ROOT / "Data/Ground" / f"{name}.rsground"
        if not path.is_file():
            errors.append(f"missing ground {name}")
            continue
        payload = read_json(path)["Object"]
        if payload.get("AssetName") != name:
            errors.append(f"ground {name}: AssetName mismatch")
        all_auto = [
            tile.get("AutoTileset", "")
            for layer in payload.get("Layers", [])
            for column in layer.get("Tiles", [])
            for tile in column
        ]
        if not all_auto or any(value not in {DTEF_AUTOTILES["floor"], DTEF_AUTOTILES["wall"]} for value in all_auto):
            errors.append(f"ground {name}: not fully DTEF auto-tiled")

    boss = ROOT / "Data/Map/sinister_woods_boss.rsmap"
    if not boss.is_file():
        errors.append("missing fixed boss map")
    else:
        game_map = read_json(boss)["Object"]
        found = {team["Players"][0]["BaseForm"]["Species"]: team["Players"][0]["Level"] for team in game_map["MapTeams"]}
        if found != {"gengar": 15, "ekans": 15, "medicham": 12}:
            errors.append(f"boss roster mismatch: {found}")
    return errors


def write() -> None:
    zone = build_zone()
    write_json(ROOT / "Data/Zone/gloomy_forest.json", {"Version": VERSION, "Object": zone})
    write_json(ROOT / "Data/Ground/sinister_woods_entrance.rsground", {"Version": VERSION, "Object": build_entrance_ground()})
    write_json(ROOT / "Data/Ground/sinister_woods_mid.rsground", {"Version": VERSION, "Object": build_midpoint_ground()})
    write_json(ROOT / "Data/Ground/sinister_woods_boss.rsground", {"Version": VERSION, "Object": build_boss_ground()})
    write_json(ROOT / "Data/Map/sinister_woods_boss.rsmap", {"Version": VERSION, "Object": build_boss_map()})
    rebuild_index(zone)
    write_lua_scripts()
    update_chapter6_entry_reference()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="write the canonical Chapter 6 bundle")
    parser.add_argument("--check", action="store_true", help="validate the current generated bundle")
    args = parser.parse_args()
    if not args.write and not args.check:
        parser.error("Choose --write and/or --check")
    if args.write:
        write()
    if args.check:
        errors = validate()
        if errors:
            print("Sinister Woods validation failed:", file=sys.stderr)
            for error in errors:
                print(f" - {error}", file=sys.stderr)
            return 1
        print("Sinister Woods canonical bundle: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
