#!/usr/bin/env python3
"""Build the first EU-ROM-authenticated PMD Red dungeon for PMDO.

This builder intentionally does not copy an existing PMDO Tiny Woods.  It
validates the European ROM's ``mapparam`` records, then serializes the narrow
PMDO adaptation documented in the adjacent playable manifest.  ROM bytes are
the content authority; RogueEssence/PMDC classes are only the runtime vehicle.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any, Iterable

# The script must work both as ``python tools/...`` and when imported by tests.
TOOLS = Path(__file__).resolve().parent
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

import audit_pmdred_eu_rom as ground_audit
from pmdred_dungeon_ground import (
    DungeonArchive,
    EXPECTED_EU_ROM_SHA256,
    parse_mapparam,
    sha256,
)

ZONE_ID = "tiny_woods"
ZONE_NAME = "Petit Bois"
MUSIC_FILE = "Tiny Woods.ogg"
MUSIC_SONG_TABLE_INDEX = 125
FLOOR_COUNT = 3

# Exhaustive EU-generation measurements.  The key is
# (effective grid rows, surviving rectangular rooms).  Every vector is an
# integer distribution over 100,000,000 accepted generations.
GEOMETRY_KEYS = ((2, 2), (2, 3), (2, 4), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6))
GEOMETRY_WEIGHTS = (
    (11161202, 26042804, 13641469, 12776833, 20668892, 12777434, 2781036, 150330),
    (3599998, 17999991, 28799986, 6508858, 17708900, 18091114, 6636574, 654579),
    (3599998, 17999991, 28799986, 6508858, 17708900, 18091114, 6636574, 654579),
)

# Red selects a count independently from the object value.
COUNT_WEIGHTS = ((1, 2), (2, 1), (3, 1))
ENEMY_COUNT_WEIGHTS = ((2, 1), (3, 1))
MONEY_WEIGHTS = ((4, 1), (6, 1), (10, 1), (14, 1), (22, 31), (26, 31), (34, 19), (38, 15))
BERRY_WEIGHTS = (("berry_oran", 7500), ("berry_pecha", 2500))

# PMDO identifiers corresponding to the authoritative Red species IDs.
FLOOR_ENEMIES = (
    (("pidgey", 3333), ("sunkern", 3334), ("wurmple", 3333)),
    (("pidgey", 3333), ("sunkern", 3334), ("wurmple", 3333)),
    (("pidgey", 2857), ("exeggcute", 1429), ("sunkern", 2857), ("wurmple", 2857)),
)

# Fully qualified runtime types at the exact PMDO 0.8.12 pin.
MAP_CTX = "RogueEssence.LevelGen.MapGenContext, RogueEssence"
GRID_FLOOR = "RogueEssence.LevelGen.GridFloorGen, RogueEssence"
ROOM_GEN = f"RogueElements.RoomGen`1[[{MAP_CTX}]], RogueElements"
PERMISSIVE_ROOM_GEN = f"RogueElements.PermissiveRoomGen`1[[{MAP_CTX}]], RogueElements"
INV_ITEM = "RogueEssence.Dungeon.InvItem, RogueEssence"
MONEY_SPAWN = "RogueEssence.LevelGen.MoneySpawn, RogueEssence"
TEAM_SPAWNER = "RogueEssence.LevelGen.TeamSpawner, RogueEssence"


def _type(generic: str, *args: str, assembly: str) -> str:
    return f"{generic}`{len(args)}[[" + "],[".join(args) + f"]], {assembly}"


def _range(minimum: int, maximum: int) -> dict[str, Any]:
    return {"Min": minimum, "Max": maximum}


def _priority(*parts: int) -> dict[str, list[int]]:
    return {"str": list(parts)}


def _spawn_list(value_type: str, entries: Iterable[tuple[Any, int]]) -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.SpawnList", value_type, assembly="RogueElements"),
        "$values": [{"Spawn": spawn, "Rate": rate} for spawn, rate in entries],
    }


def _preset(value_type: str, value: Any) -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.PresetPicker", value_type, assembly="RogueElements"),
        "ToSpawn": value,
    }


def _rand_bag(value_type: str, values: list[Any], *, remove: bool) -> dict[str, Any]:
    # RogueElements serializes the private [Serializable] field by this exact
    # lower-camel name.  It is what makes the room assignment finite rather
    # than sampling with replacement.
    return {
        "$type": _type("RogueElements.RandBag", value_type, assembly="RogueElements"),
        "ToSpawn": values,
        "removeOnRoll": remove,
    }


def _normal_room_filter() -> dict[str, Any]:
    # RoomGenDefault is RogueElements' one-tile hallway anchor.  Negating that
    # marker keeps stairs and all ordinary spawns inside rectangular rooms.
    return {
        "$type": "RogueElements.RoomFilterDefaultGen, RogueElements",
        "Negate": True,
    }


def _connectivity() -> dict[str, Any]:
    return {"$type": "PMDC.LevelGen.ConnectivityRoom, PMDC", "Connection": 1}


def _room_square(row_count: int) -> dict[str, Any]:
    max_height = 13 if row_count == 2 else 7
    return {
        "$type": _type("RogueElements.RoomGenSquare", MAP_CTX, assembly="RogueElements"),
        "Width": _range(5, 10),
        "Height": _range(4, max_height),
    }


def _hall_anchor() -> dict[str, Any]:
    return {"$type": _type("RogueElements.RoomGenDefault", MAP_CTX, assembly="RogueElements")}


def _angled_hall() -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.RoomGenAngledHall", MAP_CTX, assembly="RogueElements"),
        "HallTurnBias": 50,
        "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"},
        "Width": _range(0, 0),
        "Height": _range(0, 0),
    }


def _map_data_step() -> dict[str, Any]:
    return {
        "$type": _type("PMDC.LevelGen.MapDataStep", MAP_CTX, assembly="PMDC"),
        "Music": MUSIC_FILE,
        "TimeLimit": 1500,
        "TileSight": 0,
        "CharSight": 0,
        "ClampCamera": False,
    }


def _init_grid_step(row_count: int) -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.InitGridPlanStep", MAP_CTX, assembly="RogueElements"),
        "CellWidth": 12,
        "CellHeight": 14 if row_count == 2 else 8,
        "CellX": 2,
        "CellY": row_count,
        "CellWall": 2,
        "Wrap": False,
    }


def _grid_path_step(row_count: int, normal_rooms: int) -> dict[str, Any]:
    cell_count = 2 * row_count
    assert 2 <= normal_rooms <= cell_count
    room_bag = [_room_square(row_count) for _ in range(normal_rooms)]
    room_bag.extend(_hall_anchor() for _ in range(cell_count - normal_rooms))
    return {
        "$type": _type("RogueElements.GridPathBranch", MAP_CTX, assembly="RogueElements"),
        "RoomRatio": _range(100, 100),
        # Red performs 15 momentum-walk connection attempts.  PMDO's branch
        # ratio is the closest native spanning-tree control; extra Red-style
        # random walks are modeled separately by AddTunnelStep below.
        "BranchRatio": _range(15, 15),
        "NoForcedBranches": False,
        "GenericRooms": _rand_bag(ROOM_GEN, room_bag, remove=True),
        "RoomComponents": [_connectivity()],
        "GenericHalls": _preset(PERMISSIVE_ROOM_GEN, _angled_hall()),
        "HallComponents": [_connectivity()],
    }


def _mob_spawn(species: str) -> dict[str, Any]:
    return {
        "BaseForm": {"Species": species, "Form": 0, "Skin": "", "Gender": -1},
        "Level": _range(1, 1),
        # Empty is deliberate: PMDO 0.8.12 calls RollLatestSkills at level 1.
        "SpecifiedSkills": [],
        "Intrinsic": "",
        "Tactic": "wander_normal",
        "SpawnConditions": [],
        "SpawnFeatures": [],
    }


def _team_picker(floor_index: int) -> dict[str, Any]:
    entries: list[tuple[Any, int]] = []
    for species, rate in FLOOR_ENEMIES[floor_index]:
        entries.append(({
            "$type": "RogueEssence.LevelGen.SpecificTeamSpawner, RogueEssence",
            "Explorer": False,
            "Spawns": [_mob_spawn(species)],
        }, rate))
    return _spawn_list(TEAM_SPAWNER, entries)


def _weighted_int(entries: Iterable[tuple[int, int]]) -> dict[str, Any]:
    return _spawn_list("System.Int32, System.Private.CoreLib", entries)


def _initial_mob_step(floor_index: int) -> dict[str, Any]:
    spawner = {
        "$type": _type("RogueEssence.LevelGen.LoopedRandTeamSpawner", MAP_CTX, assembly="RogueEssence"),
        "Picker": _team_picker(floor_index),
        "AmountSpawner": _weighted_int(ENEMY_COUNT_WEIGHTS),
    }
    return {
        "$type": _type("RogueEssence.LevelGen.PlaceRandomMobsStep", MAP_CTX, assembly="RogueEssence"),
        "Filters": [_normal_room_filter()],
        "IncludeHalls": False,
        "Spawn": spawner,
        "Ally": False,
        "ClumpFactor": 0,
    }


def _inv_item(item_id: str) -> dict[str, Any]:
    return {"ID": item_id, "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}


def _looped_picker(value_type: str, value_entries: Iterable[tuple[Any, int]]) -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.LoopedRand", value_type, assembly="RogueElements"),
        "Spawner": _spawn_list(value_type, value_entries),
        "AmountSpawner": _weighted_int(COUNT_WEIGHTS),
    }


def _random_room_spawn(value_type: str, picker: dict[str, Any]) -> dict[str, Any]:
    return {
        "$type": _type("RogueElements.RandomRoomSpawnStep", MAP_CTX, value_type, assembly="RogueElements"),
        "Filters": [_normal_room_filter()],
        "Spawn": {
            "$type": _type("RogueElements.PickerSpawner", MAP_CTX, value_type, assembly="RogueElements"),
            "Picker": picker,
        },
        "SuccessPercent": 100,
        "IncludeHalls": False,
    }


def _item_step() -> dict[str, Any]:
    return _random_room_spawn(
        INV_ITEM,
        _looped_picker(INV_ITEM, ((_inv_item(item), rate) for item, rate in BERRY_WEIGHTS)),
    )


def _money_step() -> dict[str, Any]:
    values = (({"Amount": amount}, rate) for amount, rate in MONEY_WEIGHTS)
    return _random_room_spawn(MONEY_SPAWN, _looped_picker(MONEY_SPAWN, values))


def _stairs_step() -> dict[str, Any]:
    return {
        "$type": _type(
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
            "Tile": {
                "TileLoc": {"X": 0, "Y": 0},
                "ID": "stairs_go_up",
                "Revealed": True,
                "Owner": 0,
                "TileStates": [],
            },
        }],
        "Filters": [_normal_room_filter()],
    }


def _respawn_settings_step() -> dict[str, Any]:
    return {
        "$type": _type("PMDC.LevelGen.MobSpawnSettingsStep", MAP_CTX, assembly="PMDC"),
        "Priority": _priority(15),
        "Respawn": {
            "$type": "PMDC.Dungeon.RespawnFromEligibleEvent, PMDC",
            "MaxFoes": 4,
            "RespawnTime": 36,
        },
        "MaxFoes": 0,
        "RespawnTime": 0,
    }


def _texture_step() -> dict[str, Any]:
    return {
        "$type": _type("RogueEssence.LevelGen.MapTextureStep", MAP_CTX, assembly="RogueEssence"),
        "GroundTileset": "tiny_woods_floor",
        "BlockTileset": "tiny_woods_wall",
        "WaterTileset": "tiny_woods_secondary",
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


def _step(priority: tuple[int, ...], value: dict[str, Any]) -> dict[str, Any]:
    return {"Key": _priority(*priority), "Value": value}


def build_grid_floor(floor_index: int, row_count: int, normal_rooms: int) -> dict[str, Any]:
    spawn_step = _item_step() if floor_index == 2 else _money_step()
    steps = [
        _step((-6,), _map_data_step()),
        _step((-5,), _init_grid_step(row_count)),
        _step((-4,), _grid_path_step(row_count, normal_rooms)),
        _step((-3,), {"$type": _type("RogueElements.DrawGridToFloorStep", MAP_CTX, assembly="RogueElements")}),
        _step((-1,), {
            "$type": _type("RogueElements.DrawFloorToTileStep", MAP_CTX, assembly="RogueElements"),
            "Padding": 1,
        }),
        _step((0,), {
            "$type": _type("RogueEssence.AddTunnelStep", MAP_CTX, assembly="RogueEssence"),
            "TurnLength": _range(3, 6),
            "MaxLength": _range(56, 56),
            "AllowDeadEnd": True,
            "TraverseFloor": False,
            "Halls": _range(5, 5),
            "Brush": {"$type": "RogueElements.DefaultHallBrush, RogueElements"},
        }),
        _step((0, 1), {"$type": _type("RogueEssence.LevelGen.UnbreakableBorderStep", MAP_CTX, assembly="RogueEssence")}),
        _step((1, 2), _respawn_settings_step()),
        _step((2,), _stairs_step()),
        _step((4,), _texture_step()),
        _step((6, 1), spawn_step),
        _step((6, 2), _initial_mob_step(floor_index)),
        _step((7,), {
            "$type": _type(
                "RogueElements.DetectIsolatedStairsStep",
                MAP_CTX,
                "RogueEssence.LevelGen.MapGenEntrance, RogueEssence",
                "RogueEssence.LevelGen.MapGenExit, RogueEssence",
                assembly="RogueElements",
            ),
        }),
    ]
    return {"$type": GRID_FLOOR, "GenSteps": steps}


def build_chance_floor(floor_index: int) -> dict[str, Any]:
    spawns = []
    for (row_count, room_count), rate in zip(GEOMETRY_KEYS, GEOMETRY_WEIGHTS[floor_index]):
        spawns.append({"Spawn": build_grid_floor(floor_index, row_count, room_count), "Rate": rate})
    return {"$type": "RogueEssence.LevelGen.ChanceFloorGen, RogueEssence", "Spawns": spawns}


def _team_spawn_zone_step() -> dict[str, Any]:
    spawns = []
    for start, enemies in ((0, FLOOR_ENEMIES[0]), (2, FLOOR_ENEMIES[2])):
        end = 2 if start == 0 else 3
        for species, rate in enemies:
            spawns.append({
                "Spawn": {"Spawn": _mob_spawn(species), "Role": 0},
                "Rate": rate,
                "Range": _range(start, end),
            })
    return {
        "$type": "RogueEssence.LevelGen.TeamSpawnZoneStep, RogueEssence",
        "Priority": _priority(1, 2),
        "Spawns": spawns,
        "TeamSizes": [{"Spawn": 1, "Rate": 1, "Range": _range(0, 3)}],
        "SpecificSpawns": [],
    }


def build_zone() -> dict[str, Any]:
    floors = [
        {"Item": build_chance_floor(index), "Range": _range(index, index + 1)}
        for index in range(FLOOR_COUNT)
    ]
    # PMDO data files are SerializationContainer objects.  Version is not
    # optional: PMDO 0.8.12's GetVersion reader searches for it before
    # deserialization, and a missing property leaves that reader at EOF.
    return {
        "Version": "0.8.12.0",
        "Object": {
            "$type": "RogueEssence.Data.ZoneData, RogueEssence",
            "Name": {"DefaultText": ZONE_NAME, "LocalTexts": {}},
            "Released": True,
            "Comment": "EU PMD Red: d01 Petit Bois",
            "NoEXP": False,
            "ExpPercent": 100,
            "Level": 1,
            "LevelCap": False,
            "KeepSkills": False,
            "TeamRestrict": False,
            "TeamSize": 3,
            "MoneyRestrict": False,
            "BagRestrict": 20,
            "KeepTreasure": False,
            "BagSize": -1,
            "Persistent": False,
            "Rescues": -1,
            "Rogue": 0,
            "Segments": [{
                "$type": "RogueEssence.LevelGen.RangeDictSegment, RogueEssence",
                "Floors": {"nodes": floors},
                "ZoneSteps": [_team_spawn_zone_step()],
                "IsRelevant": True,
                "Comment": "EU PMD Red: d01 Petit Bois, playable selector rows 1-3",
            }],
            "GroundMaps": [],
        },
    }


def validate_authoritative_rom(rom: bytes) -> dict[str, Any]:
    actual_hash = sha256(rom)
    if actual_hash != EXPECTED_EU_ROM_SHA256:
        raise ValueError(f"expected EU ROM {EXPECTED_EU_ROM_SHA256}, got {actual_hash}")
    counts = ground_audit.parse_dungeon_floor_counts(rom)
    parsed = parse_mapparam(DungeonArchive(rom), counts)
    rows = parsed["selectors"][0]["rows"]
    expected_rows = (
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 2, 3, 0],
        [1, 0, 0, 4, 1, 2, 3, 0],
        [2, 1, 0, 5, 1, 2, 3, 0],
    )
    if tuple(row["fields"] for row in rows) != expected_rows:
        raise ValueError("EU Tiny Woods selector rows changed")
    expected_properties = (
        (1, 5, 14, 1, 15, 4, 2, 0, 5, 0),
        (1, 6, 14, 1, 15, 4, 2, 0, 5, 0),
        (1, 6, 14, 1, 15, 4, 2, 0, 5, 0),
    )
    property_fields = (
        "layout", "room_density", "tileset", "music", "floor_connectivity",
        "enemy_density", "item_density", "trap_density", "extra_hallways",
        "visibility_range",
    )
    actual_properties = []
    for row in rows[1:]:
        prop = parsed["properties"][row["property_index"]]
        actual_properties.append(tuple(prop[field] for field in property_fields))
    if tuple(actual_properties) != expected_properties:
        raise ValueError("EU Tiny Woods floor properties changed")

    monster_rates = []
    for table_index in (0, 1):
        active = [entry for entry in parsed["monster_spawns"][table_index]["entries"] if entry["cumulative_probability"][0]]
        previous = 0
        rates = []
        for entry in active:
            cumulative = entry["cumulative_probability"][0]
            rates.append(cumulative - previous)
            previous = cumulative
        monster_rates.append(rates)
    if monster_rates != [[3333, 3334, 3333], [2857, 1429, 2857, 2857]]:
        raise ValueError("EU Tiny Woods enemy rates changed")

    return {
        "rom_sha256": actual_hash,
        "mapparam_archive_entry": parsed["archive_entry_index"],
        "mapparam_root_span": parsed["root_span"],
        "selector_rows_span": parsed["selectors"][0]["rows_span"],
        "floor_property_span": parsed["referenced_properties_span"],
        "item_spawn_pointer_span": parsed["item_spawn_pointer_table_span"],
        "monster_spawn_pointer_span": parsed["monster_spawn_pointer_table_span"],
        "trap_spawn_pointer_span": parsed["trap_spawn_pointer_table_span"],
        "selector_rows": [row["fields"] for row in rows],
        "properties": [
            {field: value for field, value in zip(property_fields, values)}
            for values in actual_properties
        ],
        "monster_weight_deltas": monster_rates,
    }


def build_manifest(zone_bytes: bytes, source: dict[str, Any], music: Path | None) -> dict[str, Any]:
    music_record: dict[str, Any] = {
        "filename": MUSIC_FILE,
        "path": f"Content/Music/{MUSIC_FILE}",
        "m4a_song_table_index": MUSIC_SONG_TABLE_INDEX,
        "status": "required-authenticated-render",
    }
    if music is not None and music.is_file():
        data = music.read_bytes()
        music_hash = sha256(data)
        expected_hash = "38c62cb4ce6df879812ce7e6812f0d55b0729a86a52f66c7208c821c37c1fe0a"
        if music_hash != expected_hash:
            raise ValueError(f"Tiny Woods authenticated music hash mismatch: {music_hash}")
        music_record.update({
            "size": len(data),
            "sha256": music_hash,
            "status": "authenticated-rom-render",
            "sample_rate": 48000,
            "samples": 4264800,
            "loop_start": 2216800,
            "loop_length": 2048000,
            "renderer": "tools/render_pmdred_tiny_woods_music.py",
            "validation_report": "docs/pmdred_eu/playable/tiny_woods/music_render_validation.json",
            "dependencies": {
                "m4play": "e16a7964acdd8ef5aff10a0e729c9618d3da0e75",
                "libogg": "e1774cd77f471443541596e09078e78fdc342e4f",
                "libvorbis": "0657aee69dec8508a0011f47f3b69d7538e9d262",
            },
        })
    return {
        "schema": "pmdred-eu-playable-dungeon-v1",
        "zone_id": ZONE_ID,
        "canonical_identity": {
            "rom_dungeon_id": 0,
            "french_name": ZONE_NAME,
            "playable_floors": 3,
            "route": ["d01p01", "tiny_woods:0-2", "d01p02"],
        },
        "authority": {
            "region": "EU",
            "rom_sha256": EXPECTED_EU_ROM_SHA256,
            "mapparam": source,
            "technical_runtime": {
                "pmdo_version": "0.8.12",
                "zone_format": "RogueEssence.Data.ZoneData",
            },
        },
        "adaptation": {
            "geometry_distribution_keys": [list(key) for key in GEOMETRY_KEYS],
            "geometry_weights": [list(row) for row in GEOMETRY_WEIGHTS],
            "weight_denominator": 100000000,
            "extents": {"2_rows": [28, 32], "3_rows": [28, 30]},
            "room_size_ranges": {"width": [5, 10], "height_2_rows": [4, 13], "height_3_rows": [4, 7]},
            "spawn_filters": "RoomFilterDefaultGen(Negate=true)",
            "item_count_weights": [list(row) for row in COUNT_WEIGHTS],
            "enemy_count_weights": [list(row) for row in ENEMY_COUNT_WEIGHTS],
            "money_amount_weights": [list(row) for row in MONEY_WEIGHTS],
            "berry_weights": [list(row) for row in BERRY_WEIGHTS],
            "respawn_turns": 36,
            "normal_room_enemy_cap": 4,
            "known_native_adaptations": [
                "GridPathBranch is not instruction-identical to Red's momentum walk",
                "AddTunnelStep is not instruction-identical to Red's five extra-hallway attempts",
                "PMDO fixed weighted counts differ from Red's finite shuffle with TV 1.1498270606414207e-06 on floor 1",
            ],
        },
        "music": music_record,
        "outputs": {
            "zone": {"path": "Data/Zone/tiny_woods.json", "size": len(zone_bytes), "sha256": sha256(zone_bytes)},
        },
        "validation": {
            "builder_tests": "tools/test_build_pmdred_tiny_woods.py",
            "zone_index": {
                "status": "passed",
                "report": "docs/pmdred_eu/playable/tiny_woods/pmdo_zone_index_validation.json",
            },
            "native_generation": "pending",
            "entry_exit_route": "pending",
        },
    }


def canonical_json_bytes(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom", required=True, type=Path)
    parser.add_argument("--zone", type=Path, default=Path("Data/Zone/tiny_woods.json"))
    parser.add_argument("--manifest", type=Path, default=Path("docs/pmdred_eu/playable/tiny_woods/manifest.json"))
    parser.add_argument("--music", type=Path, default=Path("Content/Music/Tiny Woods.ogg"))
    args = parser.parse_args()

    source = validate_authoritative_rom(args.rom.read_bytes())
    zone_bytes = canonical_json_bytes(build_zone())
    manifest = build_manifest(zone_bytes, source, args.music)
    args.zone.parent.mkdir(parents=True, exist_ok=True)
    args.zone.write_bytes(zone_bytes)
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.write_bytes(canonical_json_bytes(manifest))
    print(json.dumps({
        "zone": str(args.zone), "zone_sha256": hashlib.sha256(zone_bytes).hexdigest(),
        "manifest": str(args.manifest), "music_status": manifest["music"]["status"],
    }, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
