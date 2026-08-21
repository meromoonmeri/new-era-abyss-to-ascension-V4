#!/usr/bin/env python3
"""Build authenticated PMD Red EU Mount Steel (Mt Acier), 1F through 9F.

The builder reuses the grouped early-dungeon serializer, authenticates every
content-driving selector against the exact EU ROM, emits eight procedural
floors plus the decoded 9F arena, and promotes only absent DumpAsset/direct-ROM
dependencies.  Every destination and every index key is create-only.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any, Iterable

from audit_pmdred_eu_rom import parse_dungeon_floor_counts
from pmdred_dungeon_ground import DungeonArchive, parse_mapparam
from pmdred_early_dungeon import (
    append_index_entries,
    build_chance_floor,
    build_load_floor,
    build_zone,
    dump_container,
    fixed_mob_spawn,
    map_item,
    update_zone_index,
    zone_index_summary,
)

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / ".runtime-cache/downloads/pmdred-eu.gba"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ZONE_ID = "mt_steel"
MAP_ID = "mt_steel_peak"
CONTRACT_ID = "pmdred-eu-mt-steel-arena-v1"
ZONE_PATH = ROOT / f"Data/Zone/{ZONE_ID}.json"
MAP_PATH = ROOT / f"Data/Map/{MAP_ID}.rsmap"
ZONE_INDEX = ROOT / "Data/Zone/index.idx"
DOC_DIR = ROOT / "docs/pmdred_eu/playable/mt_steel"
MUSIC_PATH = ROOT / "RESERVE/pmdred_music/PMD Red EU - Mt. Steel.ogg"
MUSIC_REPORT = DOC_DIR / "music_eu_corrected_2026-08-21.json"

DENSITY = {
    7: [
        ((2, 5), 12_500_000), ((2, 6), 37_500_000),
        ((3, 4), 2_651_515), ((3, 5), 12_196_970),
        ((3, 6), 20_151_515), ((3, 7), 12_575_758),
        ((3, 8), 2_348_485), ((3, 9), 75_757),
    ],
    8: [
        ((2, 6), 50_000_000), ((3, 5), 4_242_424),
        ((3, 6), 14_848_485), ((3, 7), 20_909_091),
        ((3, 8), 9_166_667), ((3, 9), 833_333),
    ],
    9: [
        ((2, 6), 50_000_000), ((3, 6), 6_363_636),
        ((3, 7), 17_272_727), ((3, 8), 21_363_636),
        ((3, 9), 5_000_001),
    ],
}

MONSTER_TABLES: dict[int, list[tuple[str, int, int]]] = {
    5: [("spearow", 4, 2353), ("zigzagoon", 5, 2353),
        ("aron", 6, 2941), ("baltoy", 5, 2353)],
    6: [("geodude", 5, 1905), ("tyrogue", 6, 1905),
        ("zigzagoon", 5, 1904), ("aron", 6, 2381),
        ("meditite", 6, 1905)],
    7: [("geodude", 5, 2051), ("tyrogue", 6, 2052),
        ("aron", 6, 2564), ("meditite", 6, 2051),
        ("beldum", 5, 1282)],
    8: [("geodude", 5, 1633), ("pinsir", 6, 2040),
        ("tyrogue", 6, 1633), ("aron", 6, 2041),
        ("meditite", 6, 1633), ("beldum", 5, 1020)],
    9: [("aron", 6, 6667), ("beldum", 5, 3333)],
}
FLOOR_MONSTER_TABLES = [5, 5, 5, 5, 6, 7, 8, 8]

# Exact combined item/Poke picker.  The denominator is 20,000,000.  Unsupported
# Red orbs use documented PMDO wand adapters: Switcher, Blowback/Whirlwind,
# Warp, Petrify/Whirlwind, Escape/Warp, and Hurl/Lob respectively.
ITEMS = [
    (map_item("ammo_gravelerock", amount=3), 1_460_000),
    (map_item("ammo_gravelerock", amount=4), 1_460_000),
    (map_item("ammo_gravelerock", amount=5), 1_460_000),
    (map_item("berry_oran"), 2_384_837),
    (map_item("berry_pecha"), 681_163),
    (map_item("berry_cheri"), 681_163),
    (map_item("seed_blast"), 1_022_000),
    (map_item("medicine_max_elixir"), 340_837),
    (map_item("gummi_white"), 875_000),
    (map_item("gummi_orange"), 875_000),
    (map_item("wand_switcher"), 417_268),
    (map_item("wand_whirlwind"), 416_976),
    (map_item("wand_warp"), 417_268),
    (map_item("wand_whirlwind"), 416_976),
    (map_item("wand_warp"), 834_244),
    (map_item("wand_lob"), 417_268),
]
for amount, rate in [
    (4, 58_400), (6, 58_400), (10, 58_400), (14, 58_400),
    (22, 58_400), (26, 58_400), (34, 58_400), (38, 58_400),
    (46, 467_200), (58, 876_000), (62, 876_000), (74, 876_000),
    (82, 642_400), (86, 408_800), (94, 408_800),
    (106, 408_800), (118, 408_800),
]:
    ITEMS.append((map_item("", amount=amount, money=True), rate))

EXPECTED_SELECTOR_ROWS = [
    (8, 5, 1, [8, 1, 2, 3]), (9, 5, 1, [8, 1, 2, 3]),
    (10, 5, 1, [8, 1, 2, 3]), (11, 5, 1, [9, 1, 2, 3]),
    (12, 6, 1, [9, 1, 2, 3]), (13, 7, 1, [9, 1, 2, 3]),
    (14, 8, 1, [10, 1, 2, 3]), (15, 8, 1, [10, 1, 2, 3]),
    (16, 9, 1, [10, 1, 2, 3]),
]
EXPECTED_PROPERTY_FIELDS = [
    # layout, rooms, tileset, music, connectivity, foes, items, traps,
    # floor number, fixed room, extra halls, secondary budget, lakes, money
    (11, 9, 39, 3, 12, 5, 3, 3, 1, 0, 0, 0, 11, 3),
    (11, 9, 39, 3, 12, 5, 3, 3, 2, 0, 0, 0, 11, 3),
    (11, 8, 39, 3, 12, 6, 3, 3, 3, 0, 0, 0, 11, 3),
    (8, 8, 39, 3, 12, 6, 4, 3, 4, 0, 0, 0, 11, 3),
    (8, 7, 39, 3, 12, 6, 4, 3, 5, 0, 0, 0, 11, 3),
    (8, 7, 40, 3, 12, 7, 5, 3, 6, 0, 0, 0, 11, 3),
    (8, 7, 40, 3, 12, 7, 5, 3, 7, 0, 0, 0, 11, 3),
    (8, 7, 40, 3, 12, 7, 5, 3, 8, 0, 0, 0, 11, 3),
    (0, 7, 64, 0, 12, 0, 3, 3, 9, 1, 0, 0, 11, 3),
]
EXPECTED_TABLE_HASHES = {
    "monster": {
        5: "f9101aee369ce2cc5f088f61eee6b78f81b7cb73824ce104a46a84997614dd93",
        6: "26b67885b1daa72f9af2152fe7a85074afa08b6a7ad6f7ba76f4374a717e4acc",
        7: "c6b750f6302c33a316eac58e60b628f949f3b5667206ab3789fc12f67408358d",
        8: "4d600582185c3918224ed73fbf3dbc3f587dc0642cc09d57b37a3bba14f3d827",
        9: "627c6238ab9d9d77779dea1bae07fecaf19611e9f4067fbb85fe6b8b013e7cb9",
    },
    "item": {
        8: "5b4b92ff6dea5ebeeaa5e8bd07a78b3dad837931df0467660612f8edbe399c4b",
        9: "5b4b92ff6dea5ebeeaa5e8bd07a78b3dad837931df0467660612f8edbe399c4b",
        10: "5b4b92ff6dea5ebeeaa5e8bd07a78b3dad837931df0467660612f8edbe399c4b",
    },
    "trap": {1: "4c1860c20b430bc816e45fcae9f12a2d855bd2385bee14c4e26d4b504254ec0c"},
}

PROMOTIONS: dict[Path, Path] = {
    **{
        ROOT / f".runtime-cache/DumpAsset/Data/AutoTile/mt_steel_{family}_{terrain}.json":
        ROOT / f"Data/AutoTile/mt_steel_{family}_{terrain}.json"
        for family in (1, 2) for terrain in ("floor", "wall", "secondary")
    },
    ROOT / ".runtime-cache/DumpAsset/Content/Tile/MtSteel1.tile": ROOT / "Content/Tile/MtSteel1.tile",
    ROOT / ".runtime-cache/DumpAsset/Content/Tile/MtSteel2.tile": ROOT / "Content/Tile/MtSteel2.tile",
    ROOT / ".runtime-cache/DumpAsset/Data/Status/all_protect.json": ROOT / "Data/Status/all_protect.json",
    ROOT / ".runtime-cache/DumpAsset/Data/AI/wait_only.json": ROOT / "Data/AI/wait_only.json",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/medicine_max_elixir.json": ROOT / "Data/Item/medicine_max_elixir.json",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/wand_switcher.json": ROOT / "Data/Item/wand_switcher.json",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/wand_whirlwind.json": ROOT / "Data/Item/wand_whirlwind.json",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/wand_warp.json": ROOT / "Data/Item/wand_warp.json",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/wand_lob.json": ROOT / "Data/Item/wand_lob.json",
    ROOT / ".runtime-cache/DumpAsset/Content/Item/Medicine_Purple.dir": ROOT / "Content/Item/Medicine_Purple.dir",
    ROOT / ".runtime-cache/DumpAsset/Content/Item/Wand_Red.dir": ROOT / "Content/Item/Wand_Red.dir",
    ROOT / ".runtime-cache/DumpAsset/Content/Item/Wand_White.dir": ROOT / "Content/Item/Wand_White.dir",
    ROOT / ".runtime-cache/DumpAsset/Content/Item/Wand_Pink.dir": ROOT / "Content/Item/Wand_Pink.dir",
    ROOT / "RESERVE/pmdred_direct/grounds/d03p02.rsground": ROOT / "Data/Ground/d03p02.rsground",
    ROOT / "RESERVE/pmdred_direct/tiles/d03p02_DirectBase.tile": ROOT / "Content/Tile/d03p02_DirectBase.tile",
    ROOT / "RESERVE/pmdred_direct/scripts/d03p02/animation_callbacks.lua": ROOT / "Data/Script/halcyon/ground/d03p02/animation_callbacks.lua",
    ROOT / "RESERVE/pmdred_direct/scripts/d03p02/animation_metadata.lua": ROOT / "Data/Script/halcyon/ground/d03p02/animation_metadata.lua",
}
EXPECTED_PROMOTION_HASHES = {
    "Data/AutoTile/mt_steel_1_floor.json": "4188be01470265c214cace6ec46a4749a19e0feec54b0edd208f0a904d3e9c68",
    "Data/AutoTile/mt_steel_1_wall.json": "f74b5902ae15372b45efe329d7c56cee2bdeab322fb5a74b18e04304a44bd00a",
    "Data/AutoTile/mt_steel_1_secondary.json": "945702775a6fd7944c40cb6c1b8ab0f087ff6911c34136de5d97ede40a7f72d2",
    "Data/AutoTile/mt_steel_2_floor.json": "d5e65ef7025b1e672f128e19458997049c0e6cf68231a8c1fe61e0280f1a87af",
    "Data/AutoTile/mt_steel_2_wall.json": "84652406eedb539caccba81b48c58bd0c6d9818755b15a7bdbd9a092196b7ed0",
    "Data/AutoTile/mt_steel_2_secondary.json": "a8561a049e405e4f07a0539ff68b352c1f407584090559369c71b1038aac7444",
    "Content/Tile/MtSteel1.tile": "d14096e06b0f7aad6b82f77a92a83149d07ee3bd2c87659f9b199459c2546949",
    "Content/Tile/MtSteel2.tile": "e618d7fbd527a5a4fc2a08c573984b6ac6254a257ae0a3679a389031fb96db22",
    "Data/Status/all_protect.json": "6080fe3086a13312268c33495432b369e71acf710cb969c2ab15426d4a8c6e9c",
    "Data/AI/wait_only.json": "cdbea6ccd712b04a7cd9037e22fc85b51e9493003a6f9b4cd65717b7cb8e979f",
    "Data/Item/medicine_max_elixir.json": "3a2634303cb259066277e2d9fcc893e8ba066a705a310bb23404b4a282bfee01",
    "Data/Item/wand_switcher.json": "a0025809a04570d1dcfe5dea1183c36efdaf42c942262ac69b11094f1a62d70d",
    "Data/Item/wand_whirlwind.json": "51c668cb568c4988b31b62fa50243e5c2ead4ce62b8494a573f26c1a34c23096",
    "Data/Item/wand_warp.json": "2d1f22964525abcd5eb5b4a1b9488ccd7b05ad7043549a37d38ee8eeaaf0347b",
    "Data/Item/wand_lob.json": "ac8711756222ab2a230068177be6a03a29bcf5c565945b04bb1344f91bbcf038",
    "Content/Item/Medicine_Purple.dir": "c9ee1df8d037e393022b7de87603e3acb5d165cea29eab4fc9898ab38786297c",
    "Content/Item/Wand_Red.dir": "ac020d1a393d5196d423d5b57451de6c4d8d478fe2bfde24b54494cb345f1bbd",
    "Content/Item/Wand_White.dir": "3ba92b519ea23c8dd8774ce8a3d9e63e26a430e4e905687d74c8515b27857fa5",
    "Content/Item/Wand_Pink.dir": "2a60215cbeff0c6d57cc0fda844f6a5d5cca4a5947bb89ce335a4e2f9898cb61",
    "Data/Ground/d03p02.rsground": "afa76be6c9377c5647c7dfca4098bd2b1a16d50cf169fb7df63c7f72bedbe371",
    "Content/Tile/d03p02_DirectBase.tile": "227db617181651c0b2a7a22a4f193babb0a418e7de38d33ad414482432ab566e",
    "Data/Script/halcyon/ground/d03p02/animation_callbacks.lua": "d74e0ef0ed649bc0ea1822bdc8df19847fe81e29f5c504527e2d1e69d2ceaab4",
    "Data/Script/halcyon/ground/d03p02/animation_metadata.lua": "767491a55e2cc2d19abd01630c7a3fb597f50e7eb8fc31ceb3449ef506cc0475",
}

INDEX_PROMOTIONS = {
    ROOT / "Data/AutoTile/index.idx": [
        "mt_steel_1_floor", "mt_steel_1_wall", "mt_steel_1_secondary",
        "mt_steel_2_floor", "mt_steel_2_wall", "mt_steel_2_secondary",
    ],
    ROOT / "Data/Status/index.idx": ["all_protect"],
    ROOT / "Data/AI/index.idx": ["wait_only"],
    ROOT / "Data/Item/index.idx": [
        "medicine_max_elixir", "wand_switcher", "wand_whirlwind", "wand_warp", "wand_lob",
    ],
}

FIXED_ROOM_OFFSET = 0x72F8FB
FIXED_ROOM_SIZE = 130
FIXED_ROOM_SHA256 = "5dcd3fd820aaab24d71ebc78be14d87ef742beef97c653fabdbadbad2909f3b7"
ALLOWED_UNREACHABLE = {(3, 3), (4, 3), (5, 3), (0, 5), (8, 5)}
ALLOWED_UNREACHABLE_SECONDARY = {
    (0, 0), (8, 0), (0, 1), (8, 1),
    (1, 4), (2, 4), (3, 4), (4, 4), (5, 4), (6, 4), (7, 4),
    (1, 5), (2, 5), (3, 5), (4, 5), (5, 5), (6, 5), (7, 5),
    (3, 15), (4, 15), (5, 15), (3, 16), (4, 16), (5, 16),
}

GROUND_ADAPTER = """-- d03p02 — sortie authentifiée du Mt Acier (D03).\nrequire 'origin.common'\nlocal Animation = require 'halcyon.ground.d03p02.animation_callbacks'\n\nlocal d03p02 = {}\n\nfunction d03p02.Init(map)\n  DEBUG.EnableDbgCoro()\n  if SV.CanonicalDungeons and SV.CanonicalDungeons.Pending == 'mt_steel_exit' then\n    local hero = CH('PLAYER')\n    if hero ~= nil then GROUND:TeleportTo(hero, 216, 256, Direction.Up) end\n  end\n  Animation.Init(map)\nend\n\nfunction d03p02.Enter(map)\n  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then\n    GAME:CutsceneMode(false)\n    GAME:FadeIn(1)\n    return\n  end\n  SV.CanonicalDungeons = SV.CanonicalDungeons or {}\n  if SV.CanonicalDungeons.Pending == 'mt_steel_exit' then\n    GAME:CutsceneMode(true)\n    GAME:FadeIn(30)\n    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D03_CLEAR_001']))\n    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['D03_CLEAR_002']))\n    SV.CanonicalDungeons.Pending = nil\n    SV.CanonicalDungeons.D03Cleared = true\n    GAME:FadeOut(false, 30)\n    GAME:CutsceneMode(false)\n    GAME:EnterZone('master_zone', -1, 1, 0)\n  else\n    GAME:FadeIn(20)\n  end\nend\n\nfunction d03p02.Update(map) Animation.Update(map) end\nfunction d03p02.Exit(map) Animation.Exit(map) end\nfunction d03p02.GameSave(map) end\nfunction d03p02.GameLoad(map) GAME:FadeIn(20) end\n\nreturn d03p02\n"""
GROUND_STRINGS = """<?xml version='1.0' encoding='utf-8'?>\n<root>\n  <data name=\"D03_CLEAR_001\" xml:space=\"preserve\"><value>Airmure est vaincu. Taupiqueur est sauvé !</value></data>\n  <data name=\"D03_CLEAR_002\" xml:space=\"preserve\"><value>L'équipe de secours quitte le Mt Acier.</value></data>\n</root>\n"""
ZONE_SCRIPT = """-- Mt Acier (D03) : huit étages procéduraux et l'arène authentifiée du 9e.\nlocal Route = require 'halcyon.RedEarlyDungeonRoute'\nlocal mt_steel = {}\n\nfunction mt_steel.Init(zone) Route.Init(zone, 'mt_steel') end\nfunction mt_steel.EnterSegment(zone, rescuing, segment_id, map_id)\n  Route.EnterSegment(zone, rescuing, segment_id, map_id, false)\nend\nfunction mt_steel.Rescued(zone, name, mail) Route.Rescued(zone, name, mail) end\nfunction mt_steel.ExitSegment(zone, result, rescue, segment_id, map_id)\n  Route.ExitSegment(zone, result, rescue, segment_id, {\n    pending = 'mt_steel_exit', ending_ground = 'd03p02',\n    ending_map = 1, ending_entry = 0,\n    completion_display = false, completion_fanfare = false,\n    failure_zone = 'master_zone', failure_segment = -1,\n    failure_map = 1, failure_entry = 0,\n    failure_display = true, failure_fanfare = true,\n  })\nend\nreturn mt_steel\n"""


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def decode_fixed_room(rom: bytes) -> tuple[list[list[int]], bytes]:
    source = rom[FIXED_ROOM_OFFSET:FIXED_ROOM_OFFSET + FIXED_ROOM_SIZE]
    if len(source) != FIXED_ROOM_SIZE or hashlib.sha256(source).hexdigest() != FIXED_ROOM_SHA256:
        raise RuntimeError("authenticated Mount Steel fixed-room byte gate failed")
    width, height, flags = source[:3]
    if (width, height, flags) != (9, 17, 0):
        raise RuntimeError(f"unexpected Mount Steel arena header: {(width, height, flags)}")
    pos, value, remaining = 3, 0, 0
    actions: list[int] = []
    while len(actions) < width * height:
        if remaining:
            remaining -= 1
        else:
            value = source[pos]
            pos += 1
            if value == 0x0E:
                value = source[pos]
                pos += 1
            else:
                remaining = value & 0x0F
                value >>= 4
        actions.append(value)
    if pos != len(source) or len(actions) != 153:
        raise RuntimeError(f"fixed-room decode did not consume 130/130 bytes: {pos}/130")
    rows = [actions[y * width:(y + 1) * width] for y in range(height)]
    return rows, source


def validate_rom() -> tuple[dict[str, Any], dict[str, Any], list[list[int]]]:
    rom = ROM.read_bytes()
    if len(rom) != 33_554_432 or hashlib.sha256(rom).hexdigest() != ROM_SHA256:
        raise RuntimeError("Mount Steel build requires the authenticated 32 MiB PMD Red EU ROM")
    counts = parse_dungeon_floor_counts(rom)
    if [row["floor_count"] - 1 for row in counts[:8]] != [3, 5, 9, 13, 9, 10, 3, 12]:
        raise RuntimeError("authenticated early-dungeon floor-count gate failed")
    parsed = parse_mapparam(DungeonArchive(rom), counts)
    selector = parsed["selectors"][2]
    rows = selector["rows"][1:]
    if selector["playable_floor_count"] != 9 or len(rows) != 9:
        raise RuntimeError("Mount Steel must contain exactly nine playable rows")

    extracted_rows = []
    for floor, (row, selector_gate, property_gate) in enumerate(
        zip(rows, EXPECTED_SELECTOR_ROWS, EXPECTED_PROPERTY_FIELDS), 1
    ):
        actual_selectors = (
            row["property_index"], row["monster_spawn_index"],
            row["trap_spawn_index"], row["item_spawn_indices"],
        )
        if actual_selectors != selector_gate:
            raise RuntimeError(f"Mount Steel selector gate failed on floor {floor}: {actual_selectors}")
        prop = parsed["properties"][row["property_index"]]
        actual_properties = (
            prop["layout"], prop["room_density"], prop["tileset"], prop["music"],
            prop["floor_connectivity"], prop["enemy_density"], prop["item_density"],
            prop["trap_density"], prop["floor_number"], prop["fixed_room_number"],
            prop["extra_hallways"], prop["secondary_structures_budget"],
            prop["standalone_lake_density"], prop["money_upper_bound"],
        )
        if actual_properties != property_gate:
            raise RuntimeError(f"Mount Steel property gate failed on floor {floor}: {actual_properties}")
        if prop["allow_dead_ends"] != 0 or prop["room_flags"] != 0:
            raise RuntimeError(f"Mount Steel dead-end/room-flag gate failed on floor {floor}")
        extracted_rows.append({"floor": floor, "selectors": actual_selectors, "properties": prop})

    for kind, tables in EXPECTED_TABLE_HASHES.items():
        parsed_key = {"monster": "monster_spawns", "item": "item_spawns", "trap": "trap_spawns"}[kind]
        for table_id, expected in tables.items():
            if parsed[parsed_key][table_id]["raw_sha256"] != expected:
                raise RuntimeError(f"{kind} table {table_id} hash gate failed")

    matrix, fixed_source = decode_fixed_room(rom)
    action_counts: dict[str, int] = {}
    for action in [cell for row in matrix for cell in row]:
        action_counts[f"0x{action:02X}"] = action_counts.get(f"0x{action:02X}", 0) + 1
    if matrix[8][4] != 0x10 or matrix[9][4] != 0x04 or matrix[3][4] != 0x11:
        raise RuntimeError("fixed-room actor/entry actions do not match the authenticated arena")

    source = {
        "schema": "pmdred-eu-mt-steel-source-v1",
        "authority": {"rom": str(ROM.relative_to(ROOT)), "size": len(rom),
                      "sha256": ROM_SHA256, "region": "EU"},
        "dungeon_id": 2,
        "playable_floor_count": 9,
        "rows": extracted_rows,
        "table_hashes": EXPECTED_TABLE_HASHES,
        "music": {"floor_property_selector": 3, "authenticated_m4a_song_index": 120,
                  "target": str(MUSIC_PATH.relative_to(ROOT))},
        "fixed_room": {
            "offset": FIXED_ROOM_OFFSET, "offset_hex": f"0x{FIXED_ROOM_OFFSET:08X}",
            "size": len(fixed_source), "sha256": FIXED_ROOM_SHA256,
            "dimensions": {"width": 9, "height": 17},
            "action_matrix": [[f"0x{value:02X}" for value in row] for row in matrix],
            "action_counts": action_counts,
            "entry": [4, 9], "skarmory": [4, 8], "diglett": [4, 3],
            "allowed_unreachable_normal": [list(point) for point in sorted(ALLOWED_UNREACHABLE)],
            "allowed_unreachable_secondary": [
                list(point) for point in sorted(ALLOWED_UNREACHABLE_SECONDARY, key=lambda point: (point[1], point[0]))
            ],
            "contract_id": CONTRACT_ID,
        },
        "item_picker": {
            "denominator": 20_000_000,
            "outcome_count": len(ITEMS),
            "unsupported_orb_adapters": {
                "Switcher Orb": "wand_switcher", "Blowback Orb": "wand_whirlwind",
                "Warp Orb": "wand_warp", "Petrify Orb": "wand_whirlwind",
                "Escape Orb": "wand_warp", "Hurl Orb": "wand_lob",
            },
        },
        "secondary_terrain_decision": {
            "room_flags": 0, "secondary_structures_budget": 0,
            "standalone_lake_density": 11, "generated_on_procedural_floors": False,
            "reason": "Red's formation routine returns when the requested room flag is absent.",
        },
    }
    return parsed, source, matrix


def tile_tex(auto: str, associates: Iterable[str] = ()) -> dict[str, Any]:
    return {"AutoTileset": auto, "Associates": list(associates), "Layers": [], "NeighborCode": -1}


def dungeon_tile(tile_id: str, visual: dict[str, Any], x: int, y: int) -> dict[str, Any]:
    return {
        "Data": {"ID": tile_id, "TileTex": copy.deepcopy(visual), "StableTex": False},
        "Effect": {"TileLoc": {"X": x, "Y": y}, "ID": "", "Revealed": False,
                   "Owner": 0, "TileStates": []},
    }


def build_static_map(matrix: list[list[int]]) -> dict[str, Any]:
    # Use a native PMDO 0.8.12 map container.  The former 0.8.9 Spiritomb
    # template serialized ``rand`` as an obsolete interface payload and could
    # never be loaded by the exact runtime.
    template_container = json.loads(
        (ROOT / "Data/Map/boss_artifact_water.rsmap").read_text(encoding="utf-8-sig")
    )
    container = copy.deepcopy(template_container)
    container["Version"] = "0.8.12.0"
    obj = container["Object"]
    width, height = 9, 17
    floor = tile_tex("mt_steel_2_floor")
    wall = tile_tex("mt_steel_2_wall")
    secondary = tile_tex("mt_steel_2_secondary", ["mt_steel_2_floor"])

    obj["Name"] = {"DefaultText": "Sommet du Mt Acier", "LocalTexts": {}}
    obj["Released"] = True
    obj["Comment"] = (
        f"PMD Red EU D03 9F; fixed-room ROM 0x{FIXED_ROOM_OFFSET:08X}; "
        f"authenticated static isolation contract {CONTRACT_ID}."
    )
    obj["StaticAudit"] = {
        "ContractID": CONTRACT_ID,
        "AllowedUnreachableWalkable": [
            {"X": x, "Y": y} for x, y in sorted(ALLOWED_UNREACHABLE)
        ],
        "AllowedUnreachableSecondary": [
            {"X": x, "Y": y} for x, y in sorted(ALLOWED_UNREACHABLE_SECONDARY, key=lambda point: (point[1], point[0]))
        ],
        # Runtime characters are created by typed MobSpawn steps in ZoneData.
        # The map intentionally contains no hand-serialized Character objects.
        "RequiredActors": [],
        "RequiredLoadedHostiles": [
            {"id": "skarmory", "level": 10, "x": 4, "y": 8, "direction": 0},
        ],
        "RequiredLoadedAllies": [
            {"id": "diglett", "level": 5, "x": 4, "y": 3, "direction": 0},
        ],
    }
    obj["AssetName"] = MAP_ID
    obj["Music"] = "PMD Red EU - Mt. Steel.ogg"
    obj["Element"] = "steel"
    obj["NoRescue"] = True
    obj["BlankBG"] = copy.deepcopy(wall)
    obj["TextureMap"] = {
        "floor": copy.deepcopy(floor), "wall": copy.deepcopy(wall),
        "unbreakable": copy.deepcopy(wall), "water": copy.deepcopy(secondary),
    }

    # Actors are spawned after MappedRoomStep from typed PMDO MobSpawn records.
    # Keeping these arrays empty prevents stale Character schemas from making
    # the otherwise canonical fixed map impossible to deserialize.
    obj["MapTeams"] = []
    obj["AllyTeams"] = []

    obj["EntryPoints"] = [{"Loc": {"X": 4, "Y": 9}, "Dir": 4}]
    obj["Layers"] = [{"Name": "Mt Acier — salle fixe EU", "Layer": 0,
                      "Visible": True, "Tiles": []}]
    family_grid: list[list[tuple[dict[str, Any], str]]] = []
    for y in range(height):
        row = []
        for x in range(width):
            action = matrix[y][x]
            if action in (0x02, 0x0D, 0x0E):
                row.append((wall, "unbreakable"))
            elif action == 0x0A:
                row.append((secondary, "water"))
            elif action == 0x06:
                row.append((secondary, "floor"))
            else:
                row.append((floor, "floor"))
        family_grid.append(row)

    def neighbor_code(x: int, y: int) -> int:
        expected = family_grid[y][x][0]["AutoTileset"]

        def same(xx: int, yy: int) -> bool:
            if xx < 0 or yy < 0 or xx >= width or yy >= height:
                return True
            return family_grid[yy][xx][0]["AutoTileset"] == expected

        cardinals = ((0, 1), (-1, 0), (0, -1), (1, 0))
        diagonals = ((-1, 1), (-1, -1), (1, -1), (1, 1))
        code, blocked = 0, []
        for index, (dx, dy) in enumerate(cardinals):
            value = same(x + dx, y + dy)
            blocked.append(value)
            if value:
                code |= 1 << index
        for index, (dx, dy) in enumerate(diagonals):
            if blocked[index] and blocked[(index + 1) % 4] and same(x + dx, y + dy):
                code |= 1 << (index + 4)
        return code

    obj["Tiles"] = []
    for x in range(width):
        visual_column, collision_column = [], []
        for y in range(height):
            visual, collision = family_grid[y][x]
            resolved = copy.deepcopy(visual)
            resolved["NeighborCode"] = neighbor_code(x, y)
            visual_column.append(resolved)
            collision_column.append(dungeon_tile(collision, resolved, x, y))
        obj["Layers"][0]["Tiles"].append(visual_column)
        obj["Tiles"].append(collision_column)
    obj["DiscoveryArray"] = [[2 for _ in range(height)] for _ in range(width)]
    obj["Decorations"] = [{
        "Name": "Mt Acier — décor",
        "Layer": 0,
        "Visible": True,
        "Anims": [],
    }]
    obj["Items"] = []
    obj["TeamSpawns"] = []
    obj["MapEffect"]["OnMapStarts"] = [
        {"Key": {"str": [-15]}, "Value": {
            "$type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
            # BattlePositionEvent locations are offsets from the entry point,
            # not absolute map coordinates.
            "StartLocs": [
                {"Loc": {"X": 0, "Y": 0}, "Dir": 4},
                {"Loc": {"X": -1, "Y": 1}, "Dir": 4},
                {"Loc": {"X": 1, "Y": 1}, "Dir": 4},
            ], "Positions": None,
        }},
        {"Key": {"str": [-5]}, "Value": {
            "$type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
            "Script": "LuaBeginBattleEvent",
            "ArgTable": "{ CustomClearEvent = 'MountSteelSkarmoryClear' }",
        }},
        {"Key": {"str": [0]}, "Value": {
            "$type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
            "Script": "ResetTurnCounter", "ArgTable": "{}",
        }},
    ]
    return container


def count_weights(density: int, *, item: bool = False) -> list[tuple[int, int]]:
    if item:
        return [(density - 2 + offset, 25) for offset in range(4)]
    return [(density - 2, 50), (density - 1, 50)]


def build() -> tuple[dict[str, Any], dict[str, Any], dict[str, Any]]:
    _, source, matrix = validate_rom()
    if sum(rate for _, rate in ITEMS) != 20_000_000 or len(ITEMS) != 33:
        raise RuntimeError("Mount Steel item/Poke picker must contain 33 outcomes over 20,000,000")
    for density, geometry in DENSITY.items():
        if sum(rate for _, rate in geometry) != 100_000_000:
            raise RuntimeError(f"density-{density} geometry denominator gate failed")

    property_rows = [row["properties"] for row in source["rows"]]
    floor_monsters = [MONSTER_TABLES[table] for table in FLOOR_MONSTER_TABLES]
    floors = []
    for floor_index in range(8):
        prop = property_rows[floor_index]
        floors.append(build_chance_floor(
            geometry=DENSITY[prop["room_density"]], valid_columns=3,
            music="PMD Red EU - Mt. Steel.ogg",
            texture_family="mt_steel_1" if prop["tileset"] == 39 else "mt_steel_2",
            monsters=floor_monsters[floor_index],
            enemy_count_weights=count_weights(prop["enemy_density"]),
            items=ITEMS, item_count_weights=count_weights(prop["item_density"], item=True),
            trap_count_weights=count_weights(prop["trap_density"]),
            extra_hallways=0, connectivity_ratio=12,
        ))
    skarmory = fixed_mob_spawn(
        "skarmory", 10, (4, 8), direction=0,
        tactic="wander_dumb_two_range",
        skills=("peck", "leer", "sand_attack"),
    )
    skarmory["SpawnFeatures"].append({
        "$type": "PMDC.LevelGen.MobSpawnUnrecruitable, PMDC",
    })
    diglett = fixed_mob_spawn(
        "diglett", 5, (4, 3), direction=0,
        tactic="wait_only",
        skills=("sand_attack", "scratch", "growl"),
    )
    diglett["SpawnFeatures"].extend([
        {
            "$type": "RogueEssence.LevelGen.MobSpawnStatus, RogueEssence",
            "Statuses": [{
                "Spawn": {
                    "ID": "all_protect",
                    "StatusStates": [{
                        "$type": "RogueEssence.Dungeon.CountDownState, RogueEssence",
                        "Counter": -1,
                    }],
                },
                "Rate": 10,
            }],
        },
        {"$type": "PMDC.LevelGen.MobSpawnUnrecruitable, PMDC"},
    ])
    floors.append(build_load_floor(
        map_id=MAP_ID,
        comment=f"Mt Acier 9F — salle fixe PMD Red EU ({CONTRACT_ID}).",
        hostile_teams=[[skarmory]],
        ally_teams=[[diglett]],
    ))
    zone = build_zone(
        zone_name="Mt Acier",
        comment=("PMD Red EU D03: huit étages procéduraux authentifiés, salle fixe "
                 "9F, Airmure/Taupiqueur, sélecteurs exacts et musique 121."),
        floors=floors, floor_monsters=floor_monsters + [[]],
        segment_comment="Mt Acier — neuf étages authentifiés (D03).",
        level=1, team_size=3, bag_restrict=20, rescues=-1,
        ground_maps=["d03p01", "d03p02"],
    )
    return zone, build_static_map(matrix), source


def assert_create_only(paths: Iterable[Path]) -> None:
    existing = [str(path.relative_to(ROOT)) for path in paths if path.exists()]
    if existing:
        raise FileExistsError("create-only destinations already exist: " + ", ".join(existing))


def validate_promotions() -> None:
    for source, destination in PROMOTIONS.items():
        expected = EXPECTED_PROMOTION_HASHES[str(destination.relative_to(ROOT))]
        if not source.is_file() or sha256(source) != expected:
            raise RuntimeError(f"promotion source hash gate failed: {source.relative_to(ROOT)}")
    for index_path, keys in INDEX_PROMOTIONS.items():
        destination = json.loads(index_path.read_text(encoding="utf-8-sig"))["Object"]
        source = json.loads((ROOT / f".runtime-cache/DumpAsset/{index_path.relative_to(ROOT)}").read_text(
            encoding="utf-8-sig"))["Object"]
        for key in keys:
            if key in destination:
                raise FileExistsError(f"create-only index key already exists: {index_path.relative_to(ROOT)}:{key}")
            if key not in source:
                raise RuntimeError(f"DumpAsset index summary is absent: {index_path.relative_to(ROOT)}:{key}")


def promote_assets() -> list[dict[str, Any]]:
    records = []
    for source, destination in PROMOTIONS.items():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, destination)
        records.append({"source": str(source.relative_to(ROOT)),
                        "destination": str(destination.relative_to(ROOT)),
                        "sha256": sha256(destination), "create_only": True})
    return records


def promote_index_summaries() -> list[dict[str, Any]]:
    records = []
    for index_path, keys in INDEX_PROMOTIONS.items():
        source_path = ROOT / f".runtime-cache/DumpAsset/{index_path.relative_to(ROOT)}"
        source = json.loads(source_path.read_text(encoding="utf-8-sig"))["Object"]
        append_index_entries(index_path, {key: source[key] for key in keys})
        for key in keys:
            records.append({"index": str(index_path.relative_to(ROOT)), "key": key,
                            "source": str(source_path.relative_to(ROOT)), "create_only": True})
    return records


def build_validation_config(promotions: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "schema": "pmdred-eu-early-dungeon-validation-config-v1",
        "zone_id": ZONE_ID,
        "title": "Mt Acier / Mount Steel",
        "rom": {
            "path": str(ROM.relative_to(ROOT)),
            "sha256": ROM_SHA256,
        },
        "pmdo": {
            "path": ".runtime-cache/pmdo-headless-bundle/PMDO",
            "sha256": "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327",
        },
        "zone": {
            "path": str(ZONE_PATH.relative_to(ROOT)),
            "index": str(ZONE_INDEX.relative_to(ROOT)),
            "floors": 9,
            "ground_maps": ["d03p01", "d03p02"],
            "generator_contracts": [
                {"floors": [1, 8], "generator": "chance", "stairs": 1},
                {
                    "floors": [9], "generator": "static_load", "map_id": MAP_ID,
                    "stairs": 0,
                    "loaded_hostiles": [
                        {"id": "skarmory", "level": 10, "x": 4, "y": 8, "direction": 0},
                    ],
                    "loaded_allies": [
                        {"id": "diglett", "level": 5, "x": 4, "y": 3, "direction": 0},
                    ],
                },
            ],
        },
        "assets": [
            {"path": record["destination"], "sha256": record["sha256"]}
            for record in promotions
            if record["destination"] != "Data/Ground/d03p02.rsground"
        ],
        "static_maps": [{
            "path": str(MAP_PATH.relative_to(ROOT)),
            "sha256": sha256(MAP_PATH),
            "map_id": MAP_ID,
            "dimensions": [9, 17],
            "music": "PMD Red EU - Mt. Steel.ogg",
            "entry": [4, 9, 4],
            "stairs": 0,
            "audit": {
                "contract_id": CONTRACT_ID,
                "unreachable_normal": [list(point) for point in sorted(ALLOWED_UNREACHABLE)],
                "unreachable_secondary": [
                    list(point) for point in sorted(ALLOWED_UNREACHABLE_SECONDARY, key=lambda point: (point[1], point[0]))
                ],
            },
            "actors": [],
            "loaded_hostiles": [
                {"species": "skarmory", "loc": [4, 8], "level": 10, "direction": 0},
            ],
            "loaded_allies": [
                {"species": "diglett", "loc": [4, 3], "level": 5, "direction": 0,
                 "tactic": "wait_only", "status": "all_protect", "status_counter": -1},
            ],
            "startup_events": [
                {"priority": [-15], "type": "PMDC.Dungeon.BattlePositionEvent, PMDC",
                 "script": None, "args": None},
                {"priority": [-5],
                 "type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
                 "script": "LuaBeginBattleEvent",
                 "args": "{ CustomClearEvent = 'MountSteelSkarmoryClear' }"},
                {"priority": [0],
                 "type": "RogueEssence.Dungeon.SingleCharScriptEvent, RogueEssence",
                 "script": "ResetTurnCounter", "args": "{}"},
            ],
        }],
        "ending_ground": {
            "path": "Data/Ground/d03p02.rsground",
            "sha256": sha256(ROOT / "Data/Ground/d03p02.rsground"),
            "asset_name": "d03p02",
            "obstacle_cells_x": 57,
            "obstacle_cells_y": 69,
            "cell_size": 8,
            "entity_counts": {"MapChars": 0, "GroundObjects": 0, "Spawners": 0, "Markers": 0},
            "scripted_landing": {"x": 216, "y": 256, "width": 24, "height": 24},
        },
        "music": {
            "path": str(MUSIC_PATH.relative_to(ROOT)),
            "sha256": sha256(MUSIC_PATH),
            "report": str(MUSIC_REPORT.relative_to(ROOT)),
            "song_index": 120,
        },
        "scripts": [
            {
                "path": "Data/Script/halcyon/RedEarlyDungeonRoute.lua",
                "required": [
                    "COMMON.ExitDungeonMissionCheck",
                    "RogueEssence.Data.GameProgress.ResultType.Cleared",
                    "GeneralFunctions.EndDungeonRun(",
                    "zone.ID,",
                    "config.ending_map",
                    "config.ending_entry or 0",
                ],
                "forbidden": ["GAME:EnterGroundMap(config.ending_ground"],
            },
            {
                "path": "Data/Script/halcyon/zone/mt_steel/init.lua",
                "required": [
                    "pending = 'mt_steel_exit'",
                    "ending_ground = 'd03p02'",
                    "ending_map = 1",
                    "ending_entry = 0",
                    "failure_zone = 'master_zone'",
                ],
                "forbidden": ["marker = 'Main_Entrance_Marker'"],
            },
            {
                "path": "Data/Script/halcyon/ground/d03p02/init.lua",
                "required": [
                    "SV.CanonicalDungeons.Pending == 'mt_steel_exit'",
                    "GROUND:TeleportTo(hero, 216, 256, Direction.Up)",
                    "SV.CanonicalDungeons.D03Cleared = true",
                    "GAME:EnterZone('master_zone', -1, 1, 0)",
                    "Animation.Init(map)",
                    "Animation.Update(map)",
                    "Animation.Exit(map)",
                ],
                "forbidden": ["COMMON.RespawnAllies(true)", "MRKR('Main_Entrance_Marker')"],
            },
            {
                "path": "Data/Script/halcyon/event_single.lua",
                "required": [
                    "function SINGLE_CHAR_SCRIPT.MountSteelSkarmoryClear",
                    "actor.BaseForm.Species == 'skarmory' and not actor.Dead",
                    "args.CustomClearEvent",
                    "RogueEssence.Data.GameProgress.ResultType.Cleared",
                ],
                "forbidden": [],
            },
        ],
        "dialogue": {
            "paths": [
                "Data/Script/halcyon/ground/d03p02/strings.resx",
                "Data/Script/halcyon/ground/d03p02/strings.fr.resx",
            ],
            "keys": ["D03_CLEAR_001", "D03_CLEAR_002"],
            "required_text": ["Airmure", "Taupiqueur", "Mt Acier"],
        },
        "renders": {
            "output_dir": "docs/pmdred_eu/playable/mt_steel/renders_integrated",
            "audit": "render_audit.json",
        },
        "manifest": {
            "path": "docs/pmdred_eu/playable/mt_steel/manifest.json",
            "route": ["d03p01", "mt_steel/0/0", "mt_steel/-1/1/0", "master_zone/-1/1/0"],
        },
        "evidence": "docs/pmdred_eu/playable/mt_steel/grouped_validation.json",
        "floor_monsters": [[species for species, _, _ in monsters] for monsters in
                           [MONSTER_TABLES[table] for table in FLOOR_MONSTER_TABLES]] + [[]],
        "load_floors": {"9": {
            "map_id": MAP_ID,
            "contract_id": CONTRACT_ID,
            "allowed_unreachable_normal": [list(point) for point in sorted(ALLOWED_UNREACHABLE)],
            "allowed_unreachable_secondary": [
                list(point) for point in sorted(ALLOWED_UNREACHABLE_SECONDARY, key=lambda point: (point[1], point[0]))
            ],
            "required_static_actors": [],
            "required_loaded_hostiles": [
                {"species": "skarmory", "loc": [4, 8], "level": 10, "direction": 0},
            ],
            "required_loaded_allies": [
                {"species": "diglett", "loc": [4, 3], "level": 5, "direction": 0,
                 "required_tactic": "wait_only", "required_status": "all_protect",
                 "status_counter": -1},
            ],
        }},
    }


def write_outputs() -> None:
    zone, arena, source = build()
    script_paths = [
        ROOT / "Data/Script/halcyon/ground/d03p02/init.lua",
        ROOT / "Data/Script/halcyon/ground/d03p02/strings.resx",
        ROOT / "Data/Script/halcyon/ground/d03p02/strings.fr.resx",
        ROOT / "Data/Script/halcyon/zone/mt_steel/init.lua",
    ]
    doc_paths = [DOC_DIR / "source_tables.json", DOC_DIR / "manifest.json",
                 DOC_DIR / "validation_config.json"]
    assert_create_only([ZONE_PATH, MAP_PATH, *PROMOTIONS.values(), *script_paths, *doc_paths])
    if ZONE_ID in json.loads(ZONE_INDEX.read_text(encoding="utf-8-sig"))["Object"]:
        raise FileExistsError(f"create-only zone index entry already exists: {ZONE_ID}")
    if not MUSIC_PATH.is_file() or not MUSIC_REPORT.is_file():
        raise RuntimeError("render authenticated song 121 and its report before --write")
    music = json.loads(MUSIC_REPORT.read_text(encoding="utf-8-sig"))
    if music.get("status") != "PASS" or music.get("song_index") != 120:
        raise RuntimeError("authenticated song-121 report gate failed")
    if music.get("sha256") != sha256(MUSIC_PATH):
        raise RuntimeError("authenticated song-121 output hash does not match its report")
    validate_promotions()

    promotions = promote_assets()
    index_records = promote_index_summaries()
    dump_container(ZONE_PATH, zone)
    dump_container(MAP_PATH, arena)
    update_zone_index(ZONE_INDEX, ZONE_ID, zone_index_summary(
        zone, grounds=["d03p01", "d03p02"],
        comment="PMD Red EU D03; exact nine-floor Mount Steel route.",
    ))
    for path, text in zip(
        script_paths, [GROUND_ADAPTER, GROUND_STRINGS, GROUND_STRINGS, ZONE_SCRIPT], strict=True
    ):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
    dump_container(DOC_DIR / "source_tables.json", source)
    validation_config = build_validation_config(promotions)
    dump_container(DOC_DIR / "validation_config.json", validation_config)
    manifest = {
        "schema": "pmdred-eu-playable-dungeon-v1", "zone_id": ZONE_ID,
        "french_name": "Mt Acier", "dungeon_id": 2, "floors": 9,
        "entry_ground": "d03p01", "ending_ground": "d03p02",
        "arena_map": MAP_ID, "arena_contract": CONTRACT_ID,
        "ending_geometry": {"obstacle_cells_x": 57, "obstacle_cells_y": 69,
                            "pixels_x": 456, "pixels_y": 552, "collision_layers": 1},
        "route": ["d03p01", "mt_steel/0/0", "mt_steel/-1/1/0", "master_zone/-1/1/0"],
        "geometry_denominator": 100_000_000,
        "item_poke_denominator": 20_000_000,
        "promotions": promotions, "index_promotions": index_records,
        "renders": [f"renders_integrated/floor_{floor}.png" for floor in range(1, 10)]
                   + ["renders_integrated/overview.png"],
        "certification": {"static_integration": "pending grouped validator",
                          "exact_pmdo_0_8_12_native": "pending exact native fixture"},
    }
    dump_container(DOC_DIR / "manifest.json", manifest)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="authenticate and build in memory only")
    parser.add_argument("--write", action="store_true", help="perform one create-only promotion")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check or --write")
    if args.check:
        zone, arena, source = build()
        print(json.dumps({
            "status": "PASS", "floors": len(zone["Object"]["Segments"][0]["Floors"]["nodes"]),
            "arena_dimensions": [len(arena["Object"]["Tiles"]), len(arena["Object"]["Tiles"][0])],
            "item_outcomes": source["item_picker"]["outcome_count"],
            "rom_sha256": source["authority"]["sha256"],
        }, indent=2))
    else:
        write_outputs()
        print(f"created {ZONE_PATH.relative_to(ROOT)} and authenticated D03 promotion set")
