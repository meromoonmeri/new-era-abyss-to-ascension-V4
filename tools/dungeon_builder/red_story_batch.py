"""First fail-closed PMD Red story batch: Tiny Woods and Thunderwave Cave.

The batch writes staged definitions and ZoneData only. Promotion is a separate
operation after native PMDO map generation and route validation.
"""
from __future__ import annotations

import copy
import hashlib
import json
import shutil
from pathlib import Path
from typing import Any

import build_canonical_definitions as legacy_mapping

from .canonical_gate import inspect
from .definitions import parse_definition
from .rng import DungeonRng
from .zone_export import build_zone

ROOT = Path(__file__).resolve().parents[2]
BATCH_ID = "red_story_01"
DEFINITION_DIR = ROOT / "DungeonDefs/staging" / BATCH_ID
ZONE_DIR = ROOT / "Staging/dungeon_builder" / BATCH_ID / "Data/Zone"
REPORT_PATH = ROOT / "docs/dungeon_builder/batches" / BATCH_ID / "batch_report.json"

CONFIG = {
    "tiny_woods": {
        "tileset": "tiny_woods",
        "music": "Tiny Woods.ogg",
        "profiles": ("tiny_loop", "tiny_lattice"),
        "source_entrance": "d01p01",
        "source_end": "d01p02",
    },
    "thunderwave_cave": {
        "tileset": "thunderwave_cave",
        "music": "Thunderwave Cave.ogg",
        "profiles": ("cave_branch", "cave_loop"),
        "source_entrance": "d02p01",
        "source_end": "d02p02",
    },
}

PROFILE_SPECS = {
    "tiny_loop": {"name": "looping", "weight": 24, "overrides": {
        "path": "circle", "grid_x": [3, 5], "grid_y": [3, 4],
        "circle_room_ratio": [65, 90], "circle_paths": [1, 3],
        "connect_percent": 10, "combine_rate": 0,
    }},
    "tiny_lattice": {"name": "lattice", "weight": 16, "overrides": {
        "grid_x": [3, 5], "grid_y": [3, 4], "grid_room_ratio": 75,
        "grid_hall_ratio": 50, "connect_percent": 10, "combine_rate": 0,
    }},
    "cave_branch": {"name": "branching", "weight": 24, "overrides": {
        "grid_x": [4, 6], "grid_y": [3, 5], "room_ratio": [65, 85],
        "branch_ratio": [55, 90], "connect_percent": 0,
        "no_forced_branches": False,
    }},
    "cave_loop": {"name": "looping", "weight": 16, "overrides": {
        "path": "circle", "grid_x": [4, 6], "grid_y": [3, 5],
        "circle_room_ratio": [55, 80], "circle_paths": [1, 3],
        "connect_percent": 15,
    }},
}

EXPLICIT_ITEM_MAP = {
    "ITEM_GRAVELEROCK": "ammo_gravelerock",
}


def _species(value: str) -> str:
    result = legacy_mapping.convert_species(value)
    if result is None:
        raise ValueError(f"unmapped PMD Red species: {value}")
    return result


def _item(value: str, conversion: dict[str, str], prices: dict[str, int]) -> str | None:
    if value in {"ITEM_NONE", "ITEM_POKE"}:
        return None
    result = EXPLICIT_ITEM_MAP.get(value) or legacy_mapping.convert_item(value, conversion, prices)
    return result


def _profiles(stem: str, floor: dict[str, Any]) -> list[dict[str, Any]]:
    names = CONFIG[stem]["profiles"]
    rows = [copy.deepcopy(PROFILE_SPECS[name]) for name in names]
    # This is an explicit RogueElements adapter, never presented as a ROM byte
    # replay. Density only narrows native grid ranges; topology remains native.
    density = int(floor["floor_properties"]["roomDensity"])
    for row in rows:
        overrides = row["overrides"]
        if density <= 5:
            overrides["grid_x"] = [3, 5]
            overrides["grid_y"] = [3, 4]
    return rows


def _pokemon(manifest: dict[str, Any], base_level: int) -> list[dict[str, Any]]:
    source_levels = [int(entry["level"])
                     for floor in manifest["floors"] for entry in floor["pokemon"]
                     if int(entry.get("probability", 0)) > 0]
    canonical_min = min(source_levels, default=1)
    rows = []
    for floor in manifest["floors"]:
        number = int(floor["floor"])
        for entry in floor["pokemon"]:
            probability = int(entry.get("probability", 0))
            if probability <= 0:
                continue
            level = base_level + int(entry["level"]) - canonical_min
            rows.append({
                "species": _species(entry["species"]),
                "level": [level, level],
                "weight": probability,
                "floors": [number, number],
            })
    return rows


def _items(manifest: dict[str, Any]) -> tuple[dict[str, Any], list[str]]:
    conversion = legacy_mapping.load_item_conversion()
    prices = legacy_mapping.known_items()
    entries = []
    missing: set[str] = set()
    for floor in manifest["floors"]:
        number = int(floor["floor"])
        table = manifest["tables"]["items"][str(floor["table_ids"]["Items"])]
        for category in table.get("categories", []):
            category_probability = int(category.get("categoryProbability", 0))
            for raw in category.get("items", []):
                probability = int(raw.get("itemProbability", 0))
                if category_probability <= 0 or probability <= 0:
                    continue
                item = _item(raw["item"], conversion, prices)
                if item is None:
                    if raw["item"] not in {"ITEM_NONE", "ITEM_POKE"}:
                        missing.add(raw["item"])
                    continue
                absolute_weight = max(1, round(category_probability * probability / 10000))
                entries.append({"item": item, "weight": absolute_weight,
                                "floors": [number, number]})
    if not entries:
        return {}, sorted(missing)
    return {"canonical_floor_items": {"amount": [1, 2], "entries": entries}}, sorted(missing)


def _traps(manifest: dict[str, Any]) -> dict[str, Any]:
    floor_rows = []
    for floor in manifest["floors"]:
        density = int(floor["floor_properties"]["trapDensity"])
        if density > 0:
            floor_rows.append((int(floor["floor"]), density))
    if not floor_rows:
        return {"enabled": False, "reason": "PMD_RED_ROM trapDensity=0 on every floor"}
    entries = []
    for table in manifest["tables"]["traps"].values():
        wonder = int((table.get("traps") or {}).get("Wonder Tile", 0))
        if wonder > 0:
            entries.append({"source": "Wonder Tile", "tile": "tile_wonder",
                            "weight": wonder, "revealed": True})
    lo, hi = min(row[0] for row in floor_rows), max(row[0] for row in floor_rows)
    return {"enabled": True, "floors": [lo, hi], "amount": [1, 2], "entries": entries}


def reconcile(stem: str) -> dict[str, Any]:
    if stem not in CONFIG:
        raise KeyError(stem)
    base_path = ROOT / "DungeonDefs/canonical" / f"{stem}.json"
    manifest_path = ROOT / "docs/canonical/red" / f"{stem}_rom_manifest.json"
    raw = json.loads(base_path.read_text(encoding="utf-8-sig"))
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest["fixed_floors"]:
        raise ValueError(f"{stem}: generic story batch cannot stage fixed floors")
    if int(raw["floors"]) != int(manifest["floor_count"]):
        raise ValueError(f"{stem}: floor count mismatch")
    config = CONFIG[stem]
    floors = int(manifest["floor_count"])
    items, missing_items = _items(manifest)
    segment = raw["segments"][0]
    segment.update({
        "name": raw.get("biome", stem),
        "floors": [1, floors],
        "biome": raw.get("biome", stem),
        "profiles": [copy.deepcopy(PROFILE_SPECS[name]) for name in config["profiles"]],
        "pokemon": _pokemon(manifest, int(raw["level"])),
        "inherit_pokemon": False,
        "items": items,
        "inherit_items": False,
        "floor_overrides": {},
    })
    for floor in manifest["floors"]:
        number = int(floor["floor"])
        props = floor["floor_properties"]
        segment["floor_overrides"][str(number)] = {
            "profiles": _profiles(stem, floor),
            "item_amount": [int(props["itemDensity"]), int(props["itemDensity"]) + 1],
            "initial_mobs": [max(1, int(props["enemyDensity"]) // 2),
                             max(2, int(props["enemyDensity"]) + 1)],
            "trap_amount": [int(props["trapDensity"]), int(props["trapDensity"]) + 1],
            "notes": "RogueElements adapter is INFERRED; source bytes retained below.",
            "source_floor": {
                "kind": "PMD_RED_ROM", "raw_hex": props["raw_hex"],
                "layout": props["layout"], "room_density": props["roomDensity"],
                "floor_connectivity": props["floorConnectivity"],
                "allow_dead_ends": props["allowDeadEnds"],
                "extra_hallways": props["numExtraHallways"],
                "item_density": props["itemDensity"], "trap_density": props["trapDensity"],
                "tileset": props["tileset"], "weather": props["weather"],
                "fixed_room": props["fixedRoomNumber"],
            },
        }
    tileset = config["tileset"]
    raw["dtef"] = {
        "floor": f"{tileset}_floor", "wall": f"{tileset}_wall",
        "secondary": f"{tileset}_secondary", "name": tileset,
        "element": "normal",
        "justification": f"Canonical PMDO base package matching {raw['name']['en']}; source tileset IDs retained per floor.",
    }
    raw["music"] = config["music"]
    raw["profiles"] = [copy.deepcopy(PROFILE_SPECS[name]) for name in config["profiles"]]
    raw["pokemon"] = []
    raw["items"] = {}
    raw["features"] = {
        "shop": {"enabled": False, "reason": "PMD_RED_ROM kecleonShopChance=0"},
        "monster_house": {"enabled": False, "reason": "PMD_RED_ROM monsterHouseChance=0"},
        "traps": _traps(manifest),
    }
    raw["minibosses"] = []
    raw["midpoint"] = {}
    raw["boss"] = {}
    if raw.get("scenes"):
        raw["scenes"]["battle_ground"] = ""
        raw["scenes"]["rule"] = "Canonical rescue/end scene on the source Ground; no invented battle."
    raw["canonical_items_without_pmdo_equivalent"] = missing_items
    raw["comment"] = (
        f"{raw['name']['en']} staged canonical candidate from PMD Red ROM tables. "
        "Architecture translation to native RogueElements profiles is explicitly INFERRED."
    )
    manifest_rel = str(manifest_path.relative_to(ROOT))
    raw["provenance"] = {
        "schema": "new-era.dungeon-provenance.v1", "game": "PMD_RED",
        "status": {"configuration": "validated", "runtime": "missing",
                   "batch_approved": False,
                   "reason": f"{BATCH_ID}: native PMDO validation not run yet"},
        "categories": {
            "floor_parameters": [
                {"kind": "PMD_RED_ROM", "path": manifest_rel,
                 "definition_floor_mode": "all", "evidence": "Per-floor raw bytes and table IDs."},
                {"kind": "INFERRED", "path": "tools/dungeon_builder/red_story_batch.py",
                 "reason": "PMD Red geometry bytes require a native RogueElements adapter."},
            ],
            "pokemon": [
                {"kind": "PMD_RED_ROM", "path": manifest_rel,
                 "evidence": "Per-floor species, source levels, and probabilities."},
                {"kind": "SUPPLEMENTAL", "path": str(DEFINITION_DIR.relative_to(ROOT)),
                 "reason": "Source levels translated to the New Era chapter tier."},
            ],
            "items": [
                {"kind": "PMD_RED_ROM", "path": manifest_rel,
                 "evidence": "Per-floor category and item probabilities."},
                {"kind": "INFERRED", "path": "CONVERSION/Item.txt",
                 "reason": "Explicit PMD Red constant to PMDO item ID mapping."},
            ],
            "tileset": [
                {"kind": "PMD_RED_ROM", "path": manifest_rel,
                 "evidence": "Per-floor source tileset IDs."},
                {"kind": "PROJECT_DATA", "path": "tools/dungeon_builder/data/base_autotiles.txt",
                 "evidence": f"PMDO base DTEF triplet {tileset}."},
            ],
            "grounds": [
                {"kind": "PMD_RED_RESERVED_GROUND",
                 "path": f"RESERVE/red_grounds/{config['source_entrance']}.rsground",
                 "evidence": "Canonical entrance Ground."},
                {"kind": "PMD_RED_RESERVED_GROUND",
                 "path": f"RESERVE/red_grounds/{config['source_end']}.rsground",
                 "evidence": "Canonical rescue/end Ground."},
            ],
            "scenes": [
                {"kind": "PMD_RED_ROM",
                 "path": f"RESERVE/red_cinematics/{config['source_entrance']}.cif.json",
                 "evidence": "Canonical entrance scene IR."},
                {"kind": "PMD_RED_ROM",
                 "path": f"RESERVE/red_cinematics/{config['source_end']}.cif.json",
                 "evidence": "Canonical end scene IR."},
            ],
        },
    }
    return raw


def build(write: bool = False) -> dict[str, Any]:
    rows = []
    for stem in CONFIG:
        raw = reconcile(stem)
        definition_path = DEFINITION_DIR / f"{stem}.json"
        definition = parse_definition(raw, definition_path)
        gate_path = definition_path
        if write:
            DEFINITION_DIR.mkdir(parents=True, exist_ok=True)
            definition_path.write_text(json.dumps(raw, ensure_ascii=False, indent=2) + "\n")
        export = build_zone(definition, DungeonRng(label=f"staging:{BATCH_ID}:{stem}"))
        zone_path = ZONE_DIR / f"{definition.id}.json"
        if write:
            ZONE_DIR.mkdir(parents=True, exist_ok=True)
            zone_path.write_text("\ufeff" + json.dumps(export.zone_json, ensure_ascii=False, indent=2))
        gate = inspect(gate_path) if write else None
        rows.append({
            "definition": stem, "zone": definition.id, "floors": definition.floors,
            "definition_path": str(definition_path.relative_to(ROOT)),
            "zone_path": str(zone_path.relative_to(ROOT)),
            "configuration_gate": (gate.config_ready if gate else True),
            "warnings": export.warnings,
            "status": "STAGED_AWAITING_PMDO_RUNTIME",
        })
    report = {
        "schema": "new-era.red-story-batch.v1", "batch": BATCH_ID,
        "summary": {"requested": len(rows), "staged": len(rows),
                    "runtime_validated": 0, "promoted": 0, "blocked": 0},
        "entries": rows,
    }
    if write:
        REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
        REPORT_PATH.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    return report


def record_runtime(jsonl_path: Path, report_path: Path | None = None) -> dict[str, Any]:
    rows = [json.loads(line) for line in jsonl_path.read_text(encoding="utf-8").splitlines()
            if line.strip()]
    floors = [row for row in rows if row.get("event") == "floor"]
    terminal = next((row for row in rows if row.get("event") == "end"), None)
    if terminal is None:
        raise ValueError("native runtime JSONL has no terminal event")
    expected = sum(raw["floors"] for raw in (reconcile(stem) for stem in CONFIG)) * 10
    if (int(terminal.get("attempted", -1)) != expected
            or int(terminal.get("generated", -1)) != expected
            or int(terminal.get("failures", -1)) != 0
            or int(terminal.get("non_traversable", -1)) != 0
            or int(terminal.get("invalid", -1)) != 0):
        raise ValueError(f"native runtime batch rejected: {terminal}")
    report = json.loads(REPORT_PATH.read_text(encoding="utf-8"))
    for entry in report["entries"]:
        runs = [row for row in floors if row.get("zone") == entry["zone"]]
        expected_zone = int(entry["floors"]) * 10
        if len(runs) != expected_zone or any(not row.get("valid") for row in runs):
            raise ValueError(f"{entry['zone']}: incomplete/invalid native runtime evidence")
        entry.update({
            "runtime": {
                "engine": "PMDO 0.8.12", "attempted": len(runs), "generated": len(runs),
                "failures": sum(row.get("status") != "OK" for row in runs),
                "non_traversable": sum(not row.get("traversable") for row in runs),
                "invalid": sum(not row.get("valid") for row in runs),
                "seeds_logged": sum(bool(row.get("seed")) for row in runs),
            },
            "status": "NATIVE_MAPGEN_VALIDATED_ROUTE_PENDING",
            "blockers": ["ROUTE_RUNTIME_NOT_VALIDATED", "NOT_PROMOTED"],
        })
        definition_path = ROOT / entry["definition_path"]
        definition = json.loads(definition_path.read_text(encoding="utf-8"))
        definition["provenance"]["status"].update({
            "runtime": "map_generation_validated_route_pending",
            "reason": (f"{len(runs)}/{len(runs)} native PMDO generations passed; "
                       "canonical Ground route pending"),
        })
        definition_path.write_text(json.dumps(definition, ensure_ascii=False, indent=2) + "\n")
        zone_path = ROOT / entry["zone_path"]
        entry["artifacts"] = {
            "definition_sha256": hashlib.sha256(definition_path.read_bytes()).hexdigest(),
            "zone_sha256": hashlib.sha256(zone_path.read_bytes()).hexdigest(),
        }
    runtime_dir = REPORT_PATH.parent / "runtime"
    runtime_dir.mkdir(parents=True, exist_ok=True)
    target_jsonl = runtime_dir / "native_mapgen.jsonl"
    shutil.copy2(jsonl_path, target_jsonl)
    target_report = REPORT_PATH.parent / "native_mapgen_report.md"
    if report_path:
        shutil.copy2(report_path, target_report)
    report["summary"] = {
        "requested": len(CONFIG), "staged": len(CONFIG), "generated": len(CONFIG),
        "runtime_pmdo_mapgen_validated": len(CONFIG), "route_validated": 0,
        "promoted": 0, "blocked": len(CONFIG),
    }
    report["runtime_evidence"] = {
        "jsonl": str(target_jsonl.relative_to(ROOT)),
        "jsonl_sha256": hashlib.sha256(target_jsonl.read_bytes()).hexdigest(),
        "report": str(target_report.relative_to(ROOT)) if target_report.is_file() else None,
        "report_sha256": (hashlib.sha256(target_report.read_bytes()).hexdigest()
                          if target_report.is_file() else None),
        "end": terminal,
    }
    REPORT_PATH.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    return report
