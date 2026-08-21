#!/usr/bin/env python3
"""Build the authenticated PMD Red EU Sinister Woods gameplay source manifest.

The EU ROM remains content authority.  The pinned pret checkout supplies only
symbolic species labels and table structure; every level and cumulative spawn
probability is compared back to the decoded ROM mapparam record.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path
from typing import Any

from audit_pmdred_eu_rom import parse_dungeon_floor_counts
from pmdred_dungeon_ground import DungeonArchive, parse_mapparam

ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
DUNGEON_ID = 3
EXCEPTIONS = {
    "MR_MIME": "mr_mime", "FARFETCHD": "farfetchd",
    "NIDORAN_F": "nidoran_f", "NIDORAN_M": "nidoran_m",
}


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def symbolic_monster_tables(pret: Path) -> list[list[dict[str, Any]]]:
    source = pret / "data/dungeon/SinisterWoods/pokemon_found.json"
    raw = json.loads(source.read_text())
    result: list[list[dict[str, Any]]] = []
    for table in raw["tables"]:
        rows = []
        for pokemon in table["pokemon"]:
            symbol = pokemon["species"].removeprefix("MONSTER_")
            if pokemon["probability"] <= 0 or symbol in ("KECLEON", "DECOY"):
                continue
            rows.append({
                "species": EXCEPTIONS.get(symbol, symbol.lower()),
                "level": pokemon["level"],
                "probability": pokemon["probability"],
            })
        result.append(rows)
    # Red reuses table 17 on floors 8 and 9.  pret's symbolic floor corpus has
    # one row per playable floor, so duplicate the same structural table here.
    return result[:8] + [result[7]] + result[8:]


def build(rom_path: Path, pret: Path) -> dict[str, Any]:
    rom = rom_path.read_bytes()
    if len(rom) != 33_554_432 or sha256_bytes(rom) != ROM_SHA256:
        raise ValueError("Sinister Woods audit requires the exact PMD Red EU ROM")
    head = subprocess.check_output(["git", "-C", str(pret), "rev-parse", "HEAD"], text=True).strip()
    if head != PRET_COMMIT:
        raise ValueError(f"pret checkout differs: {head}")

    floor_counts = parse_dungeon_floor_counts(rom)
    parsed = parse_mapparam(DungeonArchive(rom), floor_counts)
    selector = parsed["selectors"][DUNGEON_ID]
    rows = selector["rows"][1:]
    if selector["playable_floor_count"] != 13 or len(rows) != 13:
        raise ValueError("Sinister Woods must expose exactly 13 playable rows")
    symbols = symbolic_monster_tables(pret)
    if len(symbols) != 13:
        raise ValueError(f"unexpected symbolic table count: {len(symbols)}")

    floors = []
    for floor, (row, named) in enumerate(zip(rows, symbols, strict=True), 1):
        monster = parsed["monster_spawns"][row["monster_spawn_index"]]
        runtime_entries = [
            entry for entry in monster["entries"]
            if entry["cumulative_probability"][0] > 0
        ]
        if len(runtime_entries) != len(named):
            raise ValueError(f"floor {floor}: symbolic/ROM monster cardinal differs")
        previous = 0
        monsters = []
        for source, label in zip(runtime_entries, named, strict=True):
            cumulative = source["cumulative_probability"][0]
            probability = cumulative - previous
            previous = cumulative
            if source["level"] != label["level"] or probability != label["probability"]:
                raise ValueError(f"floor {floor}: symbolic/ROM monster semantics differ")
            monsters.append({
                "species": label["species"],
                "species_id": source["species_id"],
                "level": source["level"],
                "probability": probability,
                "cumulative_probability": cumulative,
            })
        if previous != 10_000:
            raise ValueError(f"floor {floor}: monster table does not total 10000")
        prop = parsed["properties"][row["property_index"]]
        floors.append({
            "floor": floor,
            "selector": {
                "property_index": row["property_index"],
                "monster_spawn_index": row["monster_spawn_index"],
                "trap_spawn_index": row["trap_spawn_index"],
                "item_spawn_indices": row["item_spawn_indices"],
            },
            "properties": prop,
            "monster_table_sha256": monster["raw_sha256"],
            "monsters": monsters,
        })

    item_ids = sorted({index for row in rows for index in row["item_spawn_indices"]})
    trap_ids = sorted({row["trap_spawn_index"] for row in rows})
    return {
        "schema": "new-era.pmdred-eu-sinister-woods-source.v1",
        "authority": {
            "region": "EU",
            "rom_sha256": ROM_SHA256,
            "rom_bytes": len(rom),
            "pret_commit": PRET_COMMIT,
            "pret_role": "symbolic species labels and structure only",
        },
        "dungeon": {
            "id": DUNGEON_ID,
            "name_fr": "Bois Sinistre",
            "playable_floor_count": 13,
            "selector_row_count_with_dummy": selector["selector_row_count"],
            "procedural_tileset": 41,
            "ending_ground": "d04p02",
            "ending_material_tileset": 65,
        },
        "floors": floors,
        "item_tables": {
            str(index): parsed["item_spawns"][index]
            for index in item_ids
        },
        "trap_tables": {
            str(index): parsed["trap_spawns"][index]
            for index in trap_ids
        },
        "validation": {
            "floor_count": len(floors),
            "all_monster_probabilities_rom_exact": True,
            "all_property_rows_rom_exact": True,
            "item_table_ids": item_ids,
            "trap_table_ids": trap_ids,
            "status": "PASS",
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("rom", type=Path)
    parser.add_argument("--pret-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise FileExistsError(f"refusing overwrite: {args.output}")
    result = build(args.rom, args.pret_root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(f"SINISTER_WOODS_SOURCE_PASS floors=13 output={args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
