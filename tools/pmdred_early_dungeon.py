#!/usr/bin/env python3
"""Shared PMDO 0.8.12 serializer for authenticated early PMD Red dungeons.

This module contains the engine-facing adaptation used by the early-dungeon
batch.  Dungeon-specific builders supply only ROM-authenticated tables and
route metadata; geometry, spawn, texture, stair, and index serialization stay
centralized here.

RogueElements ranges use the values already proven by the Tiny Woods adapter:
integer maxima are serialized exactly as required by PMDO 0.8.12.  Geometry
weights remain explicit rather than being sampled while building the zone.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

MAP_CTX = "RogueEssence.LevelGen.MapGenContext, RogueEssence"
GRID_FLOOR = "RogueEssence.LevelGen.GridFloorGen, RogueEssence"
ROOM_GEN = (
    "RogueElements.RoomGen`1[[RogueEssence.LevelGen.MapGenContext, "
    "RogueEssence]], RogueElements"
)
PERMISSIVE_ROOM_GEN = (
    "RogueElements.PermissiveRoomGen`1[[RogueEssence.LevelGen.MapGenContext, "
    "RogueEssence]], RogueElements"
)
TEAM_SPAWNER = "RogueEssence.LevelGen.TeamSpawner, RogueEssence"
MAP_ITEM = "RogueEssence.Dungeon.MapItem, RogueEssence"
EFFECT_TILE = "RogueEssence.Dungeon.EffectTile, RogueEssence"


def generic_type(generic: str, *args: str, assembly: str) -> str:
    return f"{generic}`{len(args)}[[" + "],[".join(args) + f"]], {assembly}"


def int_range(minimum: int, maximum: int) -> dict[str, int]:
    return {"Min": minimum, "Max": maximum}


def priority(*parts: int) -> dict[str, list[int]]:
    return {"str": list(parts)}


def spawn_list(value_type: str, entries: Iterable[tuple[Any, int]]) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.SpawnList", value_type, assembly="RogueElements"),
        "$values": [{"Spawn": value, "Rate": rate} for value, rate in entries],
    }


def weighted_int(entries: Iterable[tuple[int, int]]) -> dict[str, Any]:
    return spawn_list("System.Int32, System.Private.CoreLib", entries)


def preset(value_type: str, value: Any) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.PresetPicker", value_type, assembly="RogueElements"),
        "ToSpawn": value,
    }


def rand_bag(value_type: str, values: Sequence[Any], *, remove: bool = True) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.RandBag", value_type, assembly="RogueElements"),
        "ToSpawn": list(values),
        "removeOnRoll": remove,
    }


def normal_room_filter() -> dict[str, Any]:
    return {"$type": "RogueElements.RoomFilterDefaultGen, RogueElements", "Negate": True}


def connectivity() -> dict[str, Any]:
    return {"$type": "PMDC.LevelGen.ConnectivityRoom, PMDC", "Connection": 1}


def grid_cell_dimensions(row_count: int, valid_columns: int) -> tuple[int, int]:
    """Derive compact PMDO cells from Red's fixed 56x32 source canvas.

    The caps preserve the already-promoted 2/3-column and 2/3-row serializer
    output exactly (12x14 or 12x8).  Red's large layout can also select 4-6
    columns and four rows, which naturally reduces the corresponding cells.
    """
    if not 2 <= valid_columns <= 6:
        raise ValueError(f"unsupported Red grid column count: {valid_columns}")
    if not 2 <= row_count <= 4:
        raise ValueError(f"unsupported Red grid row count: {row_count}")
    return min(12, 56 // valid_columns - 2), min(14, 32 // row_count - 2)


def room_square(row_count: int, valid_columns: int = 3) -> dict[str, Any]:
    cell_width, cell_height = grid_cell_dimensions(row_count, valid_columns)
    return {
        "$type": generic_type("RogueElements.RoomGenSquare", MAP_CTX, assembly="RogueElements"),
        "Width": int_range(5, cell_width - 2),
        "Height": int_range(4, cell_height - 1),
    }


def hall_anchor() -> dict[str, Any]:
    return {"$type": generic_type("RogueElements.RoomGenDefault", MAP_CTX, assembly="RogueElements")}


def angled_hall() -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.RoomGenAngledHall", MAP_CTX, assembly="RogueElements"),
        "HallTurnBias": 50,
        "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"},
        "Width": int_range(0, 0),
        "Height": int_range(0, 0),
    }


def step(step_priority: tuple[int, ...], value: dict[str, Any]) -> dict[str, Any]:
    return {"Key": priority(*step_priority), "Value": value}


def map_data_step(music: str, *, time_limit: int = 1500) -> dict[str, Any]:
    return {
        "$type": generic_type("PMDC.LevelGen.MapDataStep", MAP_CTX, assembly="PMDC"),
        "Music": music,
        "TimeLimit": time_limit,
        "TileSight": 0,
        "CharSight": 0,
        "ClampCamera": False,
    }


def init_grid_step(row_count: int, valid_columns: int) -> dict[str, Any]:
    cell_width, cell_height = grid_cell_dimensions(row_count, valid_columns)
    return {
        "$type": generic_type("RogueElements.InitGridPlanStep", MAP_CTX, assembly="RogueElements"),
        "CellWidth": cell_width,
        "CellHeight": cell_height,
        "CellX": valid_columns,
        "CellY": row_count,
        "CellWall": 2,
        "Wrap": False,
    }


def grid_path_step(
    row_count: int,
    valid_columns: int,
    normal_rooms: int,
    connectivity_ratio: int = 15,
) -> dict[str, Any]:
    cell_count = valid_columns * row_count
    if not 2 <= normal_rooms <= cell_count:
        raise ValueError(f"invalid room count {normal_rooms} for {valid_columns}x{row_count} grid")
    if not 0 <= connectivity_ratio <= 100:
        raise ValueError(f"invalid connectivity ratio: {connectivity_ratio}")
    room_bag = [room_square(row_count, valid_columns) for _ in range(normal_rooms)]
    room_bag.extend(hall_anchor() for _ in range(cell_count - normal_rooms))
    return {
        "$type": generic_type("RogueElements.GridPathBranch", MAP_CTX, assembly="RogueElements"),
        "RoomRatio": int_range(100, 100),
        "BranchRatio": int_range(connectivity_ratio, connectivity_ratio),
        "NoForcedBranches": False,
        "GenericRooms": rand_bag(ROOM_GEN, room_bag),
        "RoomComponents": [connectivity()],
        "GenericHalls": preset(PERMISSIVE_ROOM_GEN, angled_hall()),
        "HallComponents": [connectivity()],
    }


def mob_spawn(species: str, level: int) -> dict[str, Any]:
    return {
        "BaseForm": {"Species": species, "Form": 0, "Skin": "", "Gender": -1},
        "Level": int_range(level, level),
        "SpecifiedSkills": [],
        "Intrinsic": "",
        "Tactic": "wander_normal",
        "SpawnConditions": [],
        "SpawnFeatures": [],
    }


def team_picker(entries: Sequence[tuple[str, int, int]]) -> dict[str, Any]:
    values = []
    for species, level, rate in entries:
        values.append(({
            "$type": "RogueEssence.LevelGen.SpecificTeamSpawner, RogueEssence",
            "Explorer": False,
            "Spawns": [mob_spawn(species, level)],
        }, rate))
    return spawn_list(TEAM_SPAWNER, values)


def initial_mob_step(
    entries: Sequence[tuple[str, int, int]], count_weights: Sequence[tuple[int, int]]
) -> dict[str, Any]:
    spawner = {
        "$type": generic_type("RogueEssence.LevelGen.LoopedRandTeamSpawner", MAP_CTX, assembly="RogueEssence"),
        "Picker": team_picker(entries),
        "AmountSpawner": weighted_int(count_weights),
    }
    return {
        "$type": generic_type("RogueEssence.LevelGen.PlaceRandomMobsStep", MAP_CTX, assembly="RogueEssence"),
        "Filters": [normal_room_filter()],
        "IncludeHalls": False,
        "Spawn": spawner,
        "Ally": False,
        "ClumpFactor": 0,
    }


def map_item(value: str, *, amount: int = 0, money: bool = False) -> dict[str, Any]:
    return {
        "IsMoney": money,
        "Cursed": False,
        "Value": "" if money else value,
        "HiddenValue": "",
        "Amount": amount,
        "Price": 0,
        "TileLoc": {"X": 0, "Y": 0},
    }


def effect_tile(tile_id: str) -> dict[str, Any]:
    return {
        "TileLoc": {"X": 0, "Y": 0},
        "ID": tile_id,
        "Revealed": True,
        "Owner": 0,
        "TileStates": [],
    }


def looped_picker(
    value_type: str,
    value_entries: Iterable[tuple[Any, int]],
    count_weights: Sequence[tuple[int, int]],
) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.LoopedRand", value_type, assembly="RogueElements"),
        "Spawner": spawn_list(value_type, value_entries),
        "AmountSpawner": weighted_int(count_weights),
    }


def random_room_spawn(value_type: str, picker: dict[str, Any]) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueElements.RandomRoomSpawnStep", MAP_CTX, value_type, assembly="RogueElements"),
        "Filters": [normal_room_filter()],
        "Spawn": {
            "$type": generic_type("RogueElements.PickerSpawner", MAP_CTX, value_type, assembly="RogueElements"),
            "Picker": picker,
        },
        "SuccessPercent": 100,
        "IncludeHalls": False,
    }


def item_step(
    item_entries: Sequence[tuple[dict[str, Any], int]],
    count_weights: Sequence[tuple[int, int]],
) -> dict[str, Any]:
    return random_room_spawn(MAP_ITEM, looped_picker(MAP_ITEM, item_entries, count_weights))


def wonder_tile_step(count_weights: Sequence[tuple[int, int]]) -> dict[str, Any]:
    entries = [(effect_tile("tile_wonder"), 1)]
    return random_room_spawn(EFFECT_TILE, looped_picker(EFFECT_TILE, entries, count_weights))


def stairs_step() -> dict[str, Any]:
    return {
        "$type": generic_type(
            "RogueElements.FloorStairsStep",
            MAP_CTX,
            "RogueEssence.LevelGen.MapGenEntrance, RogueEssence",
            "RogueEssence.LevelGen.MapGenExit, RogueEssence",
            assembly="RogueElements",
        ),
        "MinDistance": 3,
        "Entrances": [{"Loc": {"X": 0, "Y": 0}, "Dir": 0}],
        "Exits": [{
            "Loc": {"X": 0, "Y": 0},
            "Tile": effect_tile("stairs_go_up"),
        }],
        "Filters": [normal_room_filter()],
    }


def respawn_settings_step() -> dict[str, Any]:
    return {
        "$type": generic_type("PMDC.LevelGen.MobSpawnSettingsStep", MAP_CTX, assembly="PMDC"),
        "Priority": priority(15),
        "Respawn": {
            "$type": "PMDC.Dungeon.RespawnFromEligibleEvent, PMDC",
            "MaxFoes": 4,
            "RespawnTime": 36,
        },
        "MaxFoes": 0,
        "RespawnTime": 0,
    }


def perlin_water_step(percent: int) -> dict[str, Any]:
    """Adapt Red's enabled lake formation to PMDO secondary terrain.

    Early Red floor properties always store a lake-density byte, but the
    formation routine only runs when the room flag enables secondary terrain.
    Callers therefore opt in explicitly.  The wall-only stencil matches Red's
    use of the uncarved canvas and keeps rooms/halls traversable.
    """
    if not 0 <= percent <= 100:
        raise ValueError(f"invalid secondary-terrain percent: {percent}")
    return {
        "$type": generic_type("RogueElements.PerlinWaterStep", MAP_CTX, assembly="RogueElements"),
        "OrderComplexity": 3,
        "OrderSoftness": 1,
        "WaterPercent": int_range(percent, percent),
        "Bowl": True,
        "Terrain": {
            "$type": "RogueEssence.Dungeon.Tile, RogueEssence",
            "Data": {
                "ID": "water",
                "TileTex": {
                    "AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1,
                },
                "StableTex": False,
            },
            "Effect": {
                "TileLoc": {"X": 0, "Y": 0}, "ID": "", "Revealed": False,
                "Owner": 0, "TileStates": [],
            },
        },
        "TerrainStencil": {
            "$type": generic_type("RogueElements.MapTerrainStencil", MAP_CTX, assembly="RogueElements"),
            "Room": False,
            "Wall": True,
            "Blocked": False,
            "Not": False,
        },
    }


def texture_step(texture_family: str) -> dict[str, Any]:
    return {
        "$type": generic_type("RogueEssence.LevelGen.MapTextureStep", MAP_CTX, assembly="RogueEssence"),
        "GroundTileset": f"{texture_family}_floor",
        "BlockTileset": f"{texture_family}_wall",
        "WaterTileset": f"{texture_family}_secondary",
        "LayeredGround": False,
        "IndependentGround": False,
        "GroundElement": "normal",
        "Background": {
            "$type": "RogueEssence.Dungeon.MapBG, RogueEssence",
            "MapLoc": {"X": 0, "Y": 0},
            "BGAnim": {
                "AnimIndex": "", "FrameTime": 1, "StartFrame": -1,
                "EndFrame": -1, "AnimDir": -1, "Alpha": 255, "AnimFlip": 0,
            },
            "BGMovement": {"X": 0, "Y": 0},
            "Parallax": "0, 0",
            "RepeatX": False,
            "RepeatY": False,
        },
    }


def build_grid_floor(
    *,
    row_count: int,
    normal_rooms: int,
    valid_columns: int,
    music: str,
    texture_family: str,
    monsters: Sequence[tuple[str, int, int]],
    enemy_count_weights: Sequence[tuple[int, int]],
    items: Sequence[tuple[dict[str, Any], int]],
    item_count_weights: Sequence[tuple[int, int]],
    trap_count_weights: Sequence[tuple[int, int]],
    extra_hallways: int = 5,
    connectivity_ratio: int = 15,
    secondary_water_percent: int | None = None,
) -> dict[str, Any]:
    steps = [
        step((-6,), map_data_step(music)),
        step((-5,), init_grid_step(row_count, valid_columns)),
        step((-4,), grid_path_step(row_count, valid_columns, normal_rooms, connectivity_ratio)),
        step((-3,), {"$type": generic_type("RogueElements.DrawGridToFloorStep", MAP_CTX, assembly="RogueElements")}),
        step((-1,), {
            "$type": generic_type("RogueElements.DrawFloorToTileStep", MAP_CTX, assembly="RogueElements"),
            "Padding": 1,
        }),
        step((0,), {
            "$type": generic_type("RogueEssence.AddTunnelStep", MAP_CTX, assembly="RogueEssence"),
            "TurnLength": int_range(3, 6),
            "MaxLength": int_range(56, 56),
            "AllowDeadEnd": True,
            "TraverseFloor": False,
            "Halls": int_range(extra_hallways, extra_hallways),
            "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"},
        }),
        step((0, 1), {"$type": generic_type("RogueEssence.LevelGen.UnbreakableBorderStep", MAP_CTX, assembly="RogueEssence")}),
        step((1, 2), respawn_settings_step()),
        step((2,), stairs_step()),
        step((4,), texture_step(texture_family)),
        step((6, 1), item_step(items, item_count_weights)),
        step((6, 2), wonder_tile_step(trap_count_weights)),
        step((6, 3), initial_mob_step(monsters, enemy_count_weights)),
        step((7,), {
            "$type": generic_type(
                "RogueElements.DetectIsolatedStairsStep",
                MAP_CTX,
                "RogueEssence.LevelGen.MapGenEntrance, RogueEssence",
                "RogueEssence.LevelGen.MapGenExit, RogueEssence",
                assembly="RogueElements",
            ),
        }),
    ]
    if secondary_water_percent is not None:
        # Priority 3 is after stairs placement and before texture resolution.
        # Insertion at the existing priority-4 slot leaves default callers'
        # serialized output byte-identical.
        steps.insert(9, step((3,), perlin_water_step(secondary_water_percent)))
    return {"$type": GRID_FLOOR, "GenSteps": steps}


def build_load_floor(*, map_id: str, comment: str = "") -> dict[str, Any]:
    """Serialize PMDO 0.8.12's canonical static-map floor generator.

    ``MappedRoomStep<MapLoadContext>`` at priority ``-1`` is the native PMDO
    contract used by shipped zones for loading an ``.rsmap`` in the same
    segment as procedural floors.  Map-local effects and actors are retained
    by the load; a separate ``MapEffectStep`` is only needed for intentionally
    added effects that are not already serialized in the map.
    """
    if not map_id or "/" in map_id or "\\" in map_id:
        raise ValueError(f"invalid PMDO map asset ID: {map_id!r}")
    return {
        "$type": "RogueEssence.LevelGen.LoadGen, RogueEssence",
        "GenSteps": [step((-1,), {
            "$type": (
                "RogueEssence.LevelGen.MappedRoomStep`1[["
                "RogueEssence.LevelGen.MapLoadContext, RogueEssence]], RogueEssence"
            ),
            "MapID": map_id,
        })],
        "Comment": comment,
    }


def build_chance_floor(
    *,
    geometry: Sequence[
        tuple[tuple[int, int], int] | tuple[tuple[int, int, int], int]
    ],
    valid_columns: int,
    music: str,
    texture_family: str,
    monsters: Sequence[tuple[str, int, int]],
    enemy_count_weights: Sequence[tuple[int, int]],
    items: Sequence[tuple[dict[str, Any], int]],
    item_count_weights: Sequence[tuple[int, int]],
    trap_count_weights: Sequence[tuple[int, int]],
    extra_hallways: int = 5,
    connectivity_ratio: int = 15,
    secondary_water_percent: int | None = None,
) -> dict[str, Any]:
    """Build a weighted Red geometry table without sampling at build time.

    Historical callers provide ``(rows, rooms)`` and a shared column count.
    Large Red layouts use ``(columns, rows, rooms)`` per alternative.  Keeping
    both shapes is what lets the reusable serializer gain variable geometry
    without changing any existing Thunderwave Cave or Mt Steel JSON.
    """
    spawns = []
    for shape, rate in geometry:
        if len(shape) == 2:
            row_count, room_count = shape
            columns = valid_columns
        elif len(shape) == 3:
            columns, row_count, room_count = shape
        else:  # pragma: no cover - guarded for external builder diagnostics
            raise ValueError(f"invalid Red geometry shape: {shape!r}")
        floor = build_grid_floor(
            row_count=row_count,
            normal_rooms=room_count,
            valid_columns=columns,
            music=music,
            texture_family=texture_family,
            monsters=monsters,
            enemy_count_weights=enemy_count_weights,
            items=items,
            item_count_weights=item_count_weights,
            trap_count_weights=trap_count_weights,
            extra_hallways=extra_hallways,
            connectivity_ratio=connectivity_ratio,
            secondary_water_percent=secondary_water_percent,
        )
        spawns.append({"Spawn": floor, "Rate": rate})
    return {"$type": "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence", "Spawns": spawns}


def build_red_large_chance_floor(
    *,
    room_density: int,
    reference_id: str,
    music: str,
    texture_family: str,
    monsters: Sequence[tuple[str, int, int]],
    enemy_count_weights: Sequence[tuple[int, int]],
    items: Sequence[tuple[dict[str, Any], int]],
    item_count_weights: Sequence[tuple[int, int]],
    trap_count_weights: Sequence[tuple[int, int]],
    extra_hallways: int = 5,
    connectivity_ratio: int = 15,
    secondary_water_percent: int | None = None,
    attempts: int = 32,
) -> dict[str, Any]:
    """Serialize Red's exact large-layout retry/fallback process.

    Layout 0 draws ``columns in 2..8`` and ``rows in 2..7``.  A draw is
    accepted only for columns ``2..6`` and rows ``2..4``; after 32 failed
    draws Red falls back to a 4x4 grid.  A room-count increment in ``0..2`` is
    then capped to the selected cell count.

    PMDO's ChanceFloorGen rates are signed 32-bit integers, so the final
    probability ``(27/42)^32`` cannot be flattened into one exact weight
    table.  This serializer instead emits the original 32 Bernoulli trials:
    each node has accepted rate 15 and retry rate 27.  The accepted selector,
    fallback selector, and trial chain are shared through standard Newtonsoft
    ``$id``/``$ref`` metadata.  A shallow zero-rate registry declares objects
    in topological order before a final active reference, staying below exact
    PMDO 0.8.12's JsonReader depth limit without changing probability mass.
    The failure branch after trial 32 is the authenticated 4x4 fallback, not
    another draw.
    """
    if room_density < 2:
        raise ValueError(f"invalid Red room density: {room_density}")
    if not reference_id or any(char.isspace() for char in reference_id):
        raise ValueError(f"invalid JSON reference ID: {reference_id!r}")
    if attempts != 32:
        raise ValueError("Red large-layout generation requires exactly 32 attempts")

    common = {
        "valid_columns": 3,  # ignored by explicit three-value geometry entries
        "music": music,
        "texture_family": texture_family,
        "monsters": monsters,
        "enemy_count_weights": enemy_count_weights,
        "items": items,
        "item_count_weights": item_count_weights,
        "trap_count_weights": trap_count_weights,
        "extra_hallways": extra_hallways,
        "connectivity_ratio": connectivity_ratio,
        "secondary_water_percent": secondary_water_percent,
    }
    accepted_geometry = [
        ((columns, rows, min(room_density + increment, columns * rows)), 1)
        for columns in range(2, 7)
        for rows in range(2, 5)
        for increment in range(3)
    ]
    accepted = build_chance_floor(geometry=accepted_geometry, **common)
    # Metadata must precede $type for Newtonsoft's default metadata reader.
    accepted_shared = {"$id": reference_id, **accepted}

    fallback_geometry = [
        ((4, 4, min(room_density + increment, 16)), 1)
        for increment in range(3)
    ]
    fallback_id = f"{reference_id}-fallback"
    fallback = build_chance_floor(geometry=fallback_geometry, **common)
    fallback_shared = {"$id": fallback_id, **fallback}

    # A literally nested 32-node JSON tree exceeds exact PMDO 0.8.12's locked
    # Newtonsoft JsonReader.MaxDepth of 64.  Preserve the same object graph in
    # topological order instead: zero-rate entries register every shared object
    # before it is referenced, and one final positive-rate entry selects trial
    # 1.  Each trial itself still performs the authenticated 15/27 decision.
    # SpawnList accepts zero-rate alternatives; they are never selected and add
    # no probability mass.  This representation is both compact and shallow.
    chance_type = "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence"
    registry_spawns: list[dict[str, Any]] = [
        {"Spawn": accepted_shared, "Rate": 0},
        {"Spawn": fallback_shared, "Rate": 0},
    ]
    retry_reference = fallback_id
    for attempt in range(attempts, 0, -1):
        attempt_id = f"{reference_id}-attempt-{attempt}"
        attempt_node = {
            "$id": attempt_id,
            "$type": chance_type,
            "Spawns": [
                {"Spawn": {"$ref": reference_id}, "Rate": 15},
                {"Spawn": {"$ref": retry_reference}, "Rate": 27},
            ],
        }
        registry_spawns.append({"Spawn": attempt_node, "Rate": 0})
        retry_reference = attempt_id
    registry_spawns.append({"Spawn": {"$ref": retry_reference}, "Rate": 1})
    return {"$type": chance_type, "Spawns": registry_spawns}


def team_spawn_zone_step(
    floor_monsters: Sequence[Sequence[tuple[str, int, int]]]
) -> dict[str, Any]:
    spawns = []
    for floor_index, entries in enumerate(floor_monsters):
        for species, level, rate in entries:
            spawns.append({
                "Spawn": {"Spawn": mob_spawn(species, level), "Role": 0},
                "Rate": rate,
                "Range": int_range(floor_index, floor_index + 1),
            })
    return {
        "$type": "RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence",
        "Priority": priority(1, 2),
        "Spawns": spawns,
        "TeamSizes": [
            {"Spawn": 1, "Rate": 1, "Range": int_range(0, len(floor_monsters))}
        ],
        "SpecificSpawns": [],
    }


def build_zone(
    *,
    zone_name: str,
    comment: str,
    floors: Sequence[dict[str, Any]],
    floor_monsters: Sequence[Sequence[tuple[str, int, int]]],
    segment_comment: str,
    level: int = 1,
    team_size: int = 3,
    bag_restrict: int = 20,
    rescues: int = -1,
    ground_maps: Sequence[str] = (),
) -> dict[str, Any]:
    floor_nodes = [
        {"Item": floor, "Range": int_range(index, index + 1)}
        for index, floor in enumerate(floors)
    ]
    return {
        "Version": "0.8.12.0",
        "Object": {
            "$type": "RogueEssence.Data.ZoneData, RogueEssence",
            "Name": {"DefaultText": zone_name, "LocalTexts": {}},
            "Released": True,
            "Comment": comment,
            "NoEXP": False,
            "ExpPercent": 100,
            "Level": level,
            "LevelCap": False,
            "KeepSkills": False,
            "TeamRestrict": False,
            "TeamSize": team_size,
            "MoneyRestrict": False,
            "BagRestrict": bag_restrict,
            "KeepTreasure": False,
            "BagSize": -1,
            "Persistent": False,
            "Rescues": rescues,
            "Rogue": 0,
            "Segments": [{
                "$type": "RogueEssence.LevelGen.RangeDictSegment, RogueEssence",
                "Floors": {"nodes": floor_nodes},
                "ZoneSteps": [team_spawn_zone_step(floor_monsters)],
                "IsRelevant": True,
                "Comment": segment_comment,
            }],
            "GroundMaps": list(ground_maps),
        },
    }


def zone_index_summary(
    zone: Mapping[str, Any], *, grounds: Sequence[str], comment: str = ""
) -> dict[str, Any]:
    obj = zone["Object"]
    floor_count = len(obj["Segments"][0]["Floors"]["nodes"])
    summary = {
        "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
        "ExpPercent": obj["ExpPercent"],
        "Level": obj["Level"],
        "LevelCap": obj["LevelCap"],
        "KeepSkills": obj["KeepSkills"],
        "TeamRestrict": obj["TeamRestrict"],
        "TeamSize": obj["TeamSize"],
        "MoneyRestrict": obj["MoneyRestrict"],
        "BagRestrict": obj["BagRestrict"],
        "KeepTreasure": obj["KeepTreasure"],
        "BagSize": obj["BagSize"],
        "Rescues": obj["Rescues"],
        "CountedFloors": floor_count,
        "Rogue": obj["Rogue"],
        "Grounds": list(grounds),
        "Maps": [list(range(floor_count))],
        "Name": obj["Name"],
        "Released": obj["Released"],
        "SortOrder": 0,
    }
    if comment:
        summary["Comment"] = comment
    return summary


def dump_container(path: Path, value: Mapping[str, Any]) -> bytes:
    data = json.dumps(value, ensure_ascii=False, indent=2).encode("utf-8")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    return data


def append_index_entries(
    path: Path, entries: Mapping[str, Mapping[str, Any]]
) -> None:
    """Append create-only PMDO index entries without reformatting old metadata.

    PMDO's historical ``index.idx`` files use more than one JSON layout.  A
    normal parse/dump rewrites thousands of unrelated lines even when a builder
    promotes only one key.  All tracked indexes put ``Object`` last, so this
    routine retains their exact bytes (including a UTF-8 BOM and missing final
    newline), inserts only new dictionary members, and verifies the result by
    reparsing it before the atomic-size write.
    """
    if not entries:
        return
    raw = path.read_bytes()
    has_bom = raw.startswith(b"\xef\xbb\xbf")
    text = raw.decode("utf-8-sig")
    index = json.loads(text)
    existing = index.get("Object")
    if not isinstance(existing, dict):
        raise ValueError(f"PMDO index has no Object dictionary: {path}")
    duplicates = [key for key in entries if key in existing]
    if duplicates:
        raise FileExistsError(
            f"create-only index entries already exist in {path}: " + ", ".join(duplicates)
        )

    # Historical indexes may or may not have one terminal newline.  Preserve
    # it byte-for-byte while matching the structural suffix on the JSON body.
    terminal_newline = "\n" if text.endswith("\n") else ""
    body = text[:-1] if terminal_newline else text
    if body.endswith("\n  }\n}"):
        marker = "\n  }\n}"
        member_indent = "    "
    elif body.endswith("\n}\n}"):
        marker = "\n}\n}"
        member_indent = ""
    else:
        raise ValueError(f"unsupported PMDO index suffix/layout: {path}")

    blocks: list[str] = []
    for key, value in entries.items():
        value_lines = json.dumps(value, ensure_ascii=False, indent=2).splitlines()
        if member_indent:
            first = f'{member_indent}{json.dumps(key, ensure_ascii=False)}: {value_lines[0]}'
            rest = [member_indent + line for line in value_lines[1:]]
        else:
            first = f'{json.dumps(key, ensure_ascii=False)}: {value_lines[0]}'
            rest = [line.lstrip() for line in value_lines[1:]]
        blocks.append("\n".join([first, *rest]))

    prefix = body[: -len(marker)]
    updated = prefix + ",\n" + ",\n".join(blocks) + marker + terminal_newline
    parsed = json.loads(updated)
    for key, value in entries.items():
        if parsed["Object"].get(key) != value:
            raise RuntimeError(f"PMDO index append verification failed: {path}:{key}")
    path.write_bytes((b"\xef\xbb\xbf" if has_bom else b"") + updated.encode("utf-8"))


def update_zone_index(path: Path, zone_id: str, summary: Mapping[str, Any]) -> None:
    append_index_entries(path, {zone_id: summary})
