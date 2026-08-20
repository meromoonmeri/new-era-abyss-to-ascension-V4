#!/usr/bin/env python3
"""Build the five-floor authenticated PMD Red EU Thunderwave Cave adapter.

This is the first consumer of pmdred_early_dungeon.py.  It validates all
content-driving floor/item/monster/trap records against the authenticated EU
ROM before emitting PMDO data.  Existing live destinations are never
replaced: promotion is deliberately create-only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

from audit_pmdred_eu_rom import parse_dungeon_floor_counts
from pmdred_dungeon_ground import DungeonArchive, parse_mapparam
from pmdred_early_dungeon import (
    build_chance_floor,
    build_zone,
    dump_container,
    map_item,
    update_zone_index,
    zone_index_summary,
)

ROOT = Path(__file__).resolve().parents[1]
ROM = ROOT / ".runtime-cache/downloads/pmdred-eu.gba"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ZONE_ID = "thunderwave_cave"
ZONE_PATH = ROOT / f"Data/Zone/{ZONE_ID}.json"
INDEX_PATH = ROOT / "Data/Zone/index.idx"
DOC_DIR = ROOT / "docs/pmdred_eu/playable/thunderwave_cave"

DENSITY_7 = [
    ((2, 5), 12_500_000), ((2, 6), 37_500_000),
    ((3, 4), 2_651_515), ((3, 5), 12_196_970),
    ((3, 6), 20_151_515), ((3, 7), 12_575_758),
    ((3, 8), 2_348_485), ((3, 9), 75_757),
]
DENSITY_8 = [
    ((2, 6), 50_000_000), ((3, 5), 4_242_424),
    ((3, 6), 14_848_485), ((3, 7), 20_909_091),
    ((3, 8), 9_166_667), ((3, 9), 833_333),
]

MONSTER_TABLES = {
    2: [("rattata", 3, 5_000), ("nidoran_f", 4, 2_500), ("poochyena", 3, 2_500)],
    3: [
        ("rattata", 3, 4_167), ("nidoran_f", 4, 2_083),
        ("voltorb", 3, 1_667), ("poochyena", 3, 2_083),
    ],
    4: [
        ("voltorb", 3, 3_846), ("elekid", 4, 3_077),
        ("plusle", 3, 1_539), ("minun", 3, 1_538),
    ],
}
FLOOR_MONSTER_TABLES = [2, 2, 3, 4, 4]

# A single picker reproduces Red's item-or-Poke roll.  Inventory and Poke
# category-local deltas are multiplied by three; each legal Gravelerock stack
# (3, 4, 5) receives the original Gravelerock weight.  Denominator: 300M.
ITEMS = [
    (map_item("ammo_gravelerock", amount=3), 12_500_000),
    (map_item("ammo_gravelerock", amount=4), 12_500_000),
    (map_item("ammo_gravelerock", amount=5), 12_500_000),
    (map_item("berry_oran"), 42_187_500),
    (map_item("berry_pecha"), 21_093_750),
    (map_item("berry_cheri"), 14_062_500),
    (map_item("seed_sleep"), 14_062_500),
    (map_item("seed_blast"), 21_093_750),
    (map_item("food_apple"), 75_000_000),
    (map_item("", amount=4, money=True), 750_000),
    (map_item("", amount=6, money=True), 750_000),
    (map_item("", amount=10, money=True), 750_000),
    (map_item("", amount=14, money=True), 750_000),
    (map_item("", amount=22, money=True), 750_000),
    (map_item("", amount=26, money=True), 750_000),
    (map_item("", amount=34, money=True), 14_250_000),
    (map_item("", amount=38, money=True), 11_250_000),
    (map_item("", amount=46, money=True), 11_250_000),
    (map_item("", amount=58, money=True), 11_250_000),
    (map_item("", amount=62, money=True), 11_250_000),
    (map_item("", amount=74, money=True), 11_250_000),
]

EXPECTED_SELECTOR_ROWS = [
    (3, 2, 1, [6, 1, 2, 3]),
    (4, 2, 1, [6, 1, 2, 3]),
    (5, 3, 1, [6, 1, 2, 3]),
    (6, 4, 1, [7, 1, 2, 3]),
    (7, 4, 1, [7, 1, 2, 3]),
]
EXPECTED_PROPERTY_FIELDS = [
    # layout, room density, connectivity, extra halls, enemy/item/trap density,
    # money bound, maze/chance, room flags, secondary budget, lake density,
    # music selector, tileset, fixed room
    (11, 7, 15, 5, 4, 4, 3, 2, 0, 0, 0, 10, 2, 50, 0),
    (11, 7, 15, 5, 4, 4, 3, 2, 0, 0, 0, 10, 2, 50, 0),
    (11, 8, 15, 5, 4, 5, 3, 2, 0, 0, 0, 10, 2, 50, 0),
    (11, 8, 15, 5, 4, 5, 3, 2, 0, 0, 0, 10, 2, 50, 0),
    (11, 8, 15, 5, 4, 5, 3, 2, 0, 0, 0, 10, 2, 50, 0),
]
EXPECTED_TABLE_HASHES = {
    "monster": {
        2: "27ef501aacbd5a0f7dc408f593183aa38c9f31e1fe06d9af6579cff5c8673bc9",
        3: "193aba6f9ceb048c136e70509d5aac349ad62fabaf84ec405ee00c5b30382ff7",
        4: "5d611d65e8d84213175c6de1fe5e402e59b24f1006997def998f085445bceb54",
    },
    "item": {
        6: "db25a3a20c27eaddbe8cc10cc9aa5343d471b799f37900a82a1f105531c05fe7",
        7: "db25a3a20c27eaddbe8cc10cc9aa5343d471b799f37900a82a1f105531c05fe7",
    },
    "trap": {1: "4c1860c20b430bc816e45fcae9f12a2d855bd2385bee14c4e26d4b504254ec0c"},
}

PROMOTIONS = {
    ROOT / ".runtime-cache/DumpAsset/Data/AutoTile/thunderwave_cave_floor.json": ROOT / "Data/AutoTile/thunderwave_cave_floor.json",
    ROOT / ".runtime-cache/DumpAsset/Data/AutoTile/thunderwave_cave_wall.json": ROOT / "Data/AutoTile/thunderwave_cave_wall.json",
    ROOT / ".runtime-cache/DumpAsset/Data/AutoTile/thunderwave_cave_secondary.json": ROOT / "Data/AutoTile/thunderwave_cave_secondary.json",
    ROOT / ".runtime-cache/DumpAsset/Content/Tile/ThunderwaveCave.tile": ROOT / "Content/Tile/ThunderwaveCave.tile",
    ROOT / ".runtime-cache/DumpAsset/Data/Item/ammo_gravelerock.json": ROOT / "Data/Item/ammo_gravelerock.json",
    ROOT / "RESERVE/pmdred_direct/grounds/d02p02.rsground": ROOT / "Data/Ground/d02p02.rsground",
    ROOT / "RESERVE/pmdred_direct/tiles/d02p02_DirectBase.tile": ROOT / "Content/Tile/d02p02_DirectBase.tile",
    ROOT / "RESERVE/pmdred_direct/scripts/d02p02/animation_callbacks.lua": ROOT / "Data/Script/halcyon/ground/d02p02/animation_callbacks.lua",
    ROOT / "RESERVE/pmdred_direct/scripts/d02p02/animation_metadata.lua": ROOT / "Data/Script/halcyon/ground/d02p02/animation_metadata.lua",
}

EXPECTED_PROMOTION_HASHES = {
    "Data/AutoTile/thunderwave_cave_floor.json": "d1dbaa4805fb4d623f420f6cdb82e36686e82ba56882260d250e63ba58811259",
    "Data/AutoTile/thunderwave_cave_wall.json": "90bd144ae0b0d2c3ef8654f7a2e1e7d0a9c9033a847bdd571cce278cba49bf8a",
    "Data/AutoTile/thunderwave_cave_secondary.json": "0e442cbd681b2dba35f6ccee0f199daff1f8a5e7299a12e240e21f4a5f7e59a6",
    "Content/Tile/ThunderwaveCave.tile": "75e602b0102b41584c9ced0f4d1b04068c03f777427289c313e1bfea9da8ea40",
    "Data/Item/ammo_gravelerock.json": "a8b77f3eb1dfc8c6a8c39c16cb6460a6e5b338782c738ea69359d0d3d2104717",
    "Data/Ground/d02p02.rsground": "23208c1c4773efea2e6ef581848550e1cf15eba1e3b504d3189204c0560430b3",
    "Content/Tile/d02p02_DirectBase.tile": "cfd329cb0f4090733b72c99d7c02f52b1ed6d83f3ecad172d72db99001dfdb71",
    "Data/Script/halcyon/ground/d02p02/animation_callbacks.lua": "6b95a4db8700ad849d6bf8f1bdaa91e104d5ac10fdcb41df3f05d7cc3382366a",
    "Data/Script/halcyon/ground/d02p02/animation_metadata.lua": "88bbaef60c5030c2662b9edd095a8410df4737f3a66977f6b009af2e2d948e1e",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_rom() -> tuple[dict[str, Any], dict[str, Any]]:
    rom = ROM.read_bytes()
    if len(rom) != 33_554_432 or hashlib.sha256(rom).hexdigest() != ROM_SHA256:
        raise RuntimeError("Thunderwave build requires the authenticated 32 MiB PMD Red EU ROM")
    floor_counts = parse_dungeon_floor_counts(rom)
    # The Red table counts its mandatory selector-0 sentinel; playable rows are
    # therefore floor_count - 1.
    playable_counts = [row["floor_count"] - 1 for row in floor_counts]
    if playable_counts[:8] != [3, 5, 9, 13, 9, 10, 3, 12]:
        raise RuntimeError("authenticated early-dungeon floor-count gate failed")
    parsed = parse_mapparam(DungeonArchive(rom), floor_counts)
    selector = parsed["selectors"][1]
    rows = selector["rows"][1:]
    if selector["playable_floor_count"] != 5 or len(rows) != 5:
        raise RuntimeError("Thunderwave must contain exactly five playable rows")

    extracted_rows = []
    for index, (row, selector_gate, property_gate) in enumerate(
        zip(rows, EXPECTED_SELECTOR_ROWS, EXPECTED_PROPERTY_FIELDS), 1
    ):
        actual_selectors = (
            row["property_index"], row["monster_spawn_index"],
            row["trap_spawn_index"], row["item_spawn_indices"],
        )
        if actual_selectors != selector_gate:
            raise RuntimeError(f"Thunderwave selector gate failed on floor {index}: {actual_selectors}")
        prop = parsed["properties"][row["property_index"]]
        actual_properties = (
            prop["layout"], prop["room_density"], prop["floor_connectivity"],
            prop["extra_hallways"], prop["enemy_density"], prop["item_density"],
            prop["trap_density"], prop["money_upper_bound"], prop["maze_room_chance"],
            prop["room_flags"], prop["secondary_structures_budget"],
            prop["standalone_lake_density"], prop["music"], prop["tileset"],
            prop["fixed_room_number"],
        )
        if actual_properties != property_gate:
            raise RuntimeError(f"Thunderwave property gate failed on floor {index}: {actual_properties}")
        if prop["allow_dead_ends"] != 1:
            raise RuntimeError(f"Thunderwave dead-end gate failed on floor {index}")
        extracted_rows.append({
            "floor": index,
            "selectors": {
                "floor_properties": row["property_index"],
                "monsters": row["monster_spawn_index"],
                "traps": row["trap_spawn_index"],
                "items": row["item_spawn_indices"],
            },
            "properties": prop,
        })

    for table_id, expected in EXPECTED_TABLE_HASHES["monster"].items():
        if parsed["monster_spawns"][table_id]["raw_sha256"] != expected:
            raise RuntimeError(f"monster table {table_id} hash gate failed")
    for table_id, expected in EXPECTED_TABLE_HASHES["item"].items():
        if parsed["item_spawns"][table_id]["raw_sha256"] != expected:
            raise RuntimeError(f"item table {table_id} hash gate failed")
    for table_id, expected in EXPECTED_TABLE_HASHES["trap"].items():
        if parsed["trap_spawns"][table_id]["raw_sha256"] != expected:
            raise RuntimeError(f"trap table {table_id} hash gate failed")

    source = {
        "authority": {
            "rom": str(ROM.relative_to(ROOT)), "size": len(rom),
            "sha256": ROM_SHA256, "region": "EU",
        },
        "dungeon_id": 1,
        "playable_floor_count": len(rows),
        "rows": extracted_rows,
        "table_hashes": EXPECTED_TABLE_HASHES,
        "music": {
            "floor_property_selector": 2,
            "authenticated_m4a_song_index": 14,
            "target": "Music/Thunderwave Cave.ogg",
        },
        "secondary_terrain_decision": {
            "room_flags": 0,
            "secondary_structures_budget": 0,
            "standalone_lake_density": 10,
            "generated": False,
            "reason": "Red's formation routine returns when the requested room flag is absent.",
        },
    }
    return parsed, source


def build() -> tuple[dict[str, Any], dict[str, Any]]:
    _, source = validate_rom()
    if sum(rate for _, rate in ITEMS) != 300_000_000:
        raise RuntimeError("combined item/Poke picker denominator is not 300,000,000")
    if sum(rate for _, rate in DENSITY_7) != 100_000_000:
        raise RuntimeError("density-7 geometry weights do not sum to 100,000,000")
    if sum(rate for _, rate in DENSITY_8) != 100_000_000:
        raise RuntimeError("density-8 geometry weights do not sum to 100,000,000")

    floor_monsters = [MONSTER_TABLES[table] for table in FLOOR_MONSTER_TABLES]
    floors = []
    for floor_index in range(5):
        late = floor_index >= 2
        floors.append(build_chance_floor(
            geometry=DENSITY_8 if late else DENSITY_7,
            valid_columns=3,
            music="Thunderwave Cave.ogg",
            texture_family="thunderwave_cave",
            monsters=floor_monsters[floor_index],
            enemy_count_weights=[(2, 50), (3, 50)],
            items=ITEMS,
            item_count_weights=[
                (3, 25), (4, 25), (5, 25), (6, 25)
            ] if late else [(2, 25), (3, 25), (4, 25), (5, 25)],
            trap_count_weights=[(1, 50), (2, 50)],
            extra_hallways=5,
        ))
    zone = build_zone(
        zone_name="Grotte Éclair",
        comment=(
            "PMD Red EU D02: five authenticated floors; shared early-dungeon "
            "adapter, exact selectors, weighted geometry/entities, song 14."
        ),
        floors=floors,
        floor_monsters=floor_monsters,
        segment_comment="Grotte Éclair — cinq sous-sols authentifiés (D02).",
        level=1,
        team_size=3,
        bag_restrict=20,
        rescues=-1,
        ground_maps=["d02p01", "d02p02"],
    )
    return zone, source


def assert_create_only(paths: list[Path]) -> None:
    existing = [str(path.relative_to(ROOT)) for path in paths if path.exists()]
    if existing:
        raise FileExistsError("create-only destinations already exist: " + ", ".join(existing))


def promote_assets() -> list[dict[str, Any]]:
    records = []
    for source, destination in PROMOTIONS.items():
        expected = EXPECTED_PROMOTION_HASHES[str(destination.relative_to(ROOT))]
        if not source.is_file() or sha256(source) != expected:
            raise RuntimeError(f"promotion source hash gate failed: {source.relative_to(ROOT)}")
    for source, destination in PROMOTIONS.items():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, destination)
        records.append({
            "source": str(source.relative_to(ROOT)),
            "destination": str(destination.relative_to(ROOT)),
            "sha256": sha256(destination),
            "create_only": True,
        })
    return records


def write_outputs() -> None:
    zone, source = build()
    summary = zone_index_summary(
        zone,
        grounds=["d02p01", "d02p02"],
        comment="PMD Red EU D02; exact five-floor Thunderwave Cave route.",
    )
    assert_create_only(
        [ZONE_PATH, DOC_DIR / "source_tables.json", DOC_DIR / "manifest.json"]
        + list(PROMOTIONS.values())
    )
    if ZONE_ID in json.loads(INDEX_PATH.read_text(encoding="utf-8-sig"))["Object"]:
        raise FileExistsError(f"create-only index entry already exists: {ZONE_ID}")

    promotions = promote_assets()
    dump_container(ZONE_PATH, zone)
    update_zone_index(INDEX_PATH, ZONE_ID, summary)
    dump_container(DOC_DIR / "source_tables.json", source)
    manifest = {
        "schema": "pmdred-eu-playable-dungeon-v1",
        "zone_id": ZONE_ID,
        "french_name": "Grotte Éclair",
        "dungeon_id": 1,
        "floors": 5,
        "entry_ground": "d02p01",
        "ending_ground": "d02p02",
        "ending_geometry": {
            "obstacle_cells_x": 45, "obstacle_cells_y": 42,
            "pixels_x": 360, "pixels_y": 336,
            "collision_layers": 1, "tileset": 50,
        },
        "route": [
            "d02p01", "thunderwave_cave/0/0",
            "thunderwave_cave/-1/1/0", "master_zone/-1/1/0",
        ],
        "geometry_denominator": 100_000_000,
        "item_poke_denominator": 300_000_000,
        "promotions": promotions,
        "renders": [
            f"renders_integrated_v2/floor_{floor}.png" for floor in range(1, 6)
        ] + ["renders_integrated_v2/overview.png"],
        "certification": {
            "static_integration": "pending grouped validator",
            "exact_pmdo_0_8_12_native": "deferred to grouped final certification; never inferred from static output",
        },
    }
    dump_container(DOC_DIR / "manifest.json", manifest)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="validate and build in memory only")
    parser.add_argument("--write", action="store_true", help="perform one create-only promotion")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check or --write")
    if args.check:
        zone, source = build()
        print(json.dumps({
            "status": "PASS", "floors": len(zone["Object"]["Segments"][0]["Floors"]["nodes"]),
            "rom_sha256": source["authority"]["sha256"],
        }, indent=2))
    else:
        write_outputs()
        print(f"created {ZONE_PATH.relative_to(ROOT)} and authenticated D02 promotion set")
