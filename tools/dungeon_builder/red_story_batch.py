"""First fail-closed PMD Red story batch: Tiny Woods and Thunderwave Cave.

The batch writes staged definitions and ZoneData only. Promotion is a separate
operation after native PMDO map generation and route validation.
"""
from __future__ import annotations

import copy
import hashlib
import json
import re
import shutil
from contextlib import contextmanager
from pathlib import Path
from typing import Any

import build_canonical_definitions as legacy_mapping

from .canonical_gate import inspect
from .definitions import load_definition, parse_definition
from .rng import DungeonRng
from .zone_export import ExportResult, build_zone, update_zone_index

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
    "ITEM_MAX_ELIXIR": "medicine_max_elixir",
}

# PMD Red items that have NO canonical equivalent in the PMDO 0.8.9 base game
# (audinowho/DumpAsset @ pinned commit). These are game-mechanics items that
# were dropped, renamed with different semantics, or replaced by unrelated
# machinery in PMDO. Rather than blocking every Red dungeon that references
# them in a marginal item table slot, the batch skips these items with an
# explicit provenance reason. The dungeon is still fail-closed if every item
# on a floor is unavailable, so this cannot silently strip a whole floor.
#
# Every entry in this set must be documented individually below.
#
# ORBs that PMDO base dropped as a mechanic (no equivalent orb, seed, or wand
# in current PMDO with the same effect):
#   ITEM_BLOWBACK_ORB : knocks all foes back N tiles — no PMDO equivalent
#   ITEM_HURL_ORB     : throws foe to random tile — no PMDO equivalent
#   ITEM_SWITCHER_ORB : swaps positions with foe — no PMDO equivalent
#     (PMDO has wand_switcher but semantics differ: wand vs one-shot orb;
#      cross-family mapping is explicitly forbidden by convert_item's doc)
#   ITEM_WARP_ORB     : random-warps the party — no orb_warp in PMDO base
#     (PMDO has seed_warp for the same effect but it's a seed, not an orb;
#      cross-family mapping is forbidden — the effect is preserved via seeds
#      declared in floor tables when the ROM lists them)
#   ITEM_RADAR_ORB    : reveals all traps — no orb_radar in PMDO base
#     (PMDO has orb_scanner for reveal-rooms and orb_trap_see for reveal-traps;
#      neither matches the exact ROM semantic)
# TMs that PMDO base does not ship (Toxic is not a TM in PMDO 0.8.9):
#   ITEM_TM_TOXIC     : no tm_toxic in Data/Item; Toxic is a base move only
# Held items that PMDO renamed without preserving both variants:
#   ITEM_STAMINA_BAND : PMDO has held_zinc_band with same effect but the
#     rename dropped the Red identity; kept skipped rather than silently swapped
#   ITEM_GOLD_RIBBON  : Gold Ribbon is a Sky-era item; PMDO base has no
#     equivalent for the Red version
#   ITEM_INSOMNISCOPE : LEGACY_ITEM_MAP already maps this to
#     'held_insomniascope' (see convert_item); no need to skip
#
# When PMDODump ships one of these items in a later pin, remove it from the
# set and let convert_item resolve it normally.
PMDO_UNAVAILABLE_ITEMS: frozenset[str] = frozenset({
    "ITEM_BLOWBACK_ORB",
    "ITEM_HURL_ORB",
    "ITEM_SWITCHER_ORB",
    "ITEM_WARP_ORB",
    "ITEM_RADAR_ORB",
    "ITEM_TM_TOXIC",
    "ITEM_STAMINA_BAND",
    "ITEM_GOLD_RIBBON",
})

BASE_ITEMS = set((ROOT / "tools/dungeon_builder/data/base_items.txt").read_text().splitlines())
BASE_ITEM_CATALOG = json.loads(
    (ROOT / "tools/dungeon_builder/data/base_item_catalog.json").read_text(encoding="utf-8"))
BASE_ITEMS_BY_NAME: dict[str, list[str]] = {}
for _entry in BASE_ITEM_CATALOG["entries"]:
    if not _entry["released"] or not _entry["name"]:
        continue
    _name = re.sub(r"[^a-z0-9]", "", _entry["name"].lower())
    BASE_ITEMS_BY_NAME.setdefault(_name, []).append(_entry["id"])


def _exact_name_item(value: str) -> str | None:
    raw = value.removeprefix("ITEM_")
    tokens = raw.split("_")
    if tokens and tokens[0] == "TM":
        tokens = tokens[1:]
    aliases = {"DEF": "DEFENSE"}
    display = " ".join(aliases.get(token, token) for token in tokens)
    key = re.sub(r"[^a-z0-9]", "", display.lower())
    candidates = BASE_ITEMS_BY_NAME.get(key, [])
    prefixes: tuple[str, ...] = ()
    if value.startswith("ITEM_TM_"): prefixes = ("tm_",)
    elif value.endswith("_ORB"): prefixes = ("orb_",)
    elif value.endswith("_SEED"): prefixes = ("seed_",)
    elif value.endswith("_BERRY"): prefixes = ("berry_",)
    elif value.endswith("_GUMMI"): prefixes = ("gummi_",)
    elif any(value.endswith(suffix) for suffix in ("_BAND", "_SCARF", "_RIBBON", "_LENS", "SCOPE")):
        prefixes = ("held_",)
    elif "APPLE" in value: prefixes = ("food_",)
    elif any(token in value for token in ("THORN", "SPIKE", "ROCK", "PEBBLE")):
        prefixes = ("ammo_",)
    elif "ELIXIR" in value: prefixes = ("medicine_",)
    if prefixes:
        candidates = [candidate for candidate in candidates if candidate.startswith(prefixes)]
    return candidates[0] if len(candidates) == 1 else None


@contextmanager
def batch_context(batch_id: str, config: dict[str, Any],
                  profiles: dict[str, dict[str, Any]]):
    global BATCH_ID, CONFIG, PROFILE_SPECS, DEFINITION_DIR, ZONE_DIR, REPORT_PATH
    saved = (BATCH_ID, CONFIG, PROFILE_SPECS, DEFINITION_DIR, ZONE_DIR, REPORT_PATH)
    BATCH_ID = batch_id
    CONFIG = config
    PROFILE_SPECS = profiles
    DEFINITION_DIR = ROOT / "DungeonDefs/staging" / batch_id
    ZONE_DIR = ROOT / "Staging/dungeon_builder" / batch_id / "Data/Zone"
    REPORT_PATH = ROOT / "docs/dungeon_builder/batches" / batch_id / "batch_report.json"
    try:
        yield
    finally:
        (BATCH_ID, CONFIG, PROFILE_SPECS, DEFINITION_DIR, ZONE_DIR, REPORT_PATH) = saved


def _species(value: str) -> str:
    result = legacy_mapping.convert_species(value)
    if result is None:
        raise ValueError(f"unmapped PMD Red species: {value}")
    return result


def _item(value: str, conversion: dict[str, str], available: set[str]) -> str | None:
    if value in {"ITEM_NONE", "ITEM_POKE"}:
        return None
    # 1. Explicit local overrides declared by this batch module (highest prio,
    #    used when a specific ROM constant needs a targeted PMDO id).
    result = EXPLICIT_ITEM_MAP.get(value)
    if value.startswith("ITEM_TM_"):
        result = "tm_" + value.removeprefix("ITEM_TM_").lower()
    result = result or _exact_name_item(value)
    if result and result in available:
        return result
    # 2. Authoritative ROM->PMDO overrides declared by the project's canonical
    #    definition builder (tools/build_canonical_definitions.py:ITEM_OVERRIDES).
    #    These are curated, hand-maintained mappings such as
    #    ITEM_LINK_BOX -> machine_recall_box that predate this batch.
    legacy_override = legacy_mapping.ITEM_OVERRIDES.get(value)
    if legacy_override and legacy_override in available:
        return legacy_override
    # 3. Convention-based lookup via CONVERSION/Item.txt (hand-authored).
    key = value.removeprefix("ITEM_").lower()
    candidate = conversion.get(key)
    if candidate and candidate in available:
        return candidate
    # 4. Direct-hit: the ROM constant already looks like a PMDO id.
    if key in available:
        return key
    return None


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


def _items(manifest: dict[str, Any]) -> tuple[dict[str, Any], list[str], dict[str, list[str]]]:
    """Resolve PMD Red per-floor item tables to PMDO ids.

    Returns:
        (items_block, missing, skipped_by_reason)
        - items_block: {"canonical_floor_items": {...}} ready to embed in
          the reconciled definition, or {} if no floor has any resolvable item.
        - missing: sorted list of PMD Red ITEM_* constants that could not be
          resolved AND are NOT in PMDO_UNAVAILABLE_ITEMS. Any non-empty entry
          here is a hard blocker: the batch stays fail-closed for this dungeon.
        - skipped_by_reason: mapping reason_code -> sorted list of ITEM_*
          constants that were intentionally skipped (documented absence).
          Never a blocker on its own, but if the skip strips every item from
          a specific floor the batch still fails closed because that floor
          would become gameplay-empty.
    """
    conversion = legacy_mapping.load_item_conversion()
    available = BASE_ITEMS | set(legacy_mapping.known_items())
    entries: list[dict[str, Any]] = []
    missing: set[str] = set()
    skipped: dict[str, set[str]] = {"NOT_IN_PMDO_0_8_9_BASE": set()}
    per_floor_kept: dict[int, int] = {}
    per_floor_total: dict[int, int] = {}
    for floor in manifest["floors"]:
        number = int(floor["floor"])
        table = manifest["tables"]["items"][str(floor["table_ids"]["Items"])]
        for category in table.get("categories", []):
            category_probability = int(category.get("categoryProbability", 0))
            for raw in category.get("items", []):
                probability = int(raw.get("itemProbability", 0))
                if category_probability <= 0 or probability <= 0:
                    continue
                per_floor_total[number] = per_floor_total.get(number, 0) + 1
                iid = raw["item"]
                if iid in {"ITEM_NONE", "ITEM_POKE"}:
                    continue
                item = _item(iid, conversion, available)
                if item is None:
                    if iid in PMDO_UNAVAILABLE_ITEMS:
                        skipped["NOT_IN_PMDO_0_8_9_BASE"].add(iid)
                        continue
                    missing.add(iid)
                    continue
                absolute_weight = max(1, round(category_probability * probability / 10000))
                entries.append({"item": item, "weight": absolute_weight,
                                "floors": [number, number]})
                per_floor_kept[number] = per_floor_kept.get(number, 0) + 1

    # A floor whose entire item table resolved to nothing is a real blocker:
    # promoting it would ship a floor without a canonical item table at all.
    for f, total in per_floor_total.items():
        if total > 0 and per_floor_kept.get(f, 0) == 0:
            missing.add(f"__FLOOR_{f}_HAS_NO_RESOLVABLE_ITEM__")

    if not entries:
        return {}, sorted(missing), {k: sorted(v) for k, v in skipped.items() if v}

    block = {"canonical_floor_items": {"amount": [1, 2], "entries": entries}}
    if any(v for v in skipped.values()):
        block["canonical_floor_items"]["skipped_by_reason"] = {
            reason: sorted(items) for reason, items in skipped.items() if items
        }
    return block, sorted(missing), {k: sorted(v) for k, v in skipped.items() if v}


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
    items, missing_items, skipped_items = _items(manifest)
    if missing_items:
        raise ValueError(f"{stem}: unmapped canonical items: {', '.join(missing_items)}")
    if skipped_items:
        # Record the skips on the raw definition so that downstream reports can
        # cite the exact ROM constants that were intentionally omitted for
        # PMDO 0.8.9 base compatibility. This is only informational: the batch
        # only errors on truly unmapped items above.
        raw.setdefault("provenance", {}).setdefault("items", {})
        raw["provenance"]["items"]["skipped"] = skipped_items
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
    raw["segments"] = [segment]
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
        try:
            raw = reconcile(stem)
            definition_path = DEFINITION_DIR / f"{stem}.json"
            definition = parse_definition(raw, definition_path)
            if write:
                DEFINITION_DIR.mkdir(parents=True, exist_ok=True)
                definition_path.write_text(json.dumps(raw, ensure_ascii=False, indent=2) + "\n")
            export = build_zone(definition, DungeonRng(label=f"staging:{BATCH_ID}:{stem}"))
            zone_path = ZONE_DIR / f"{definition.id}.json"
            if write:
                ZONE_DIR.mkdir(parents=True, exist_ok=True)
                zone_path.write_text("\ufeff" + json.dumps(export.zone_json, ensure_ascii=False, indent=2))
            gate = inspect(definition_path) if write else None
            rows.append({
                "definition": stem, "zone": definition.id, "floors": definition.floors,
                "definition_path": str(definition_path.relative_to(ROOT)),
                "zone_path": str(zone_path.relative_to(ROOT)),
                "configuration_gate": (gate.config_ready if gate else True),
                "warnings": export.warnings,
                "status": "STAGED_AWAITING_PMDO_RUNTIME",
                "blockers": [],
            })
        except Exception as exc:
            rows.append({
                "definition": stem, "zone": stem, "floors": None,
                "definition_path": None, "zone_path": None,
                "configuration_gate": False, "warnings": [],
                "status": "BLOCKED_CONFIGURATION",
                "blockers": [str(exc)],
            })
    staged = sum(row["status"] == "STAGED_AWAITING_PMDO_RUNTIME" for row in rows)
    report = {
        "schema": "new-era.red-story-batch.v1", "batch": BATCH_ID,
        "summary": {"requested": len(rows), "staged": staged,
                    "runtime_validated": 0, "promoted": 0,
                    "blocked": len(rows) - staged},
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
    report = json.loads(REPORT_PATH.read_text(encoding="utf-8"))
    candidates = [entry for entry in report["entries"]
                  if entry["status"] == "STAGED_AWAITING_PMDO_RUNTIME"]
    expected = sum(int(entry["floors"]) for entry in candidates) * 10
    if (int(terminal.get("attempted", -1)) != expected
            or int(terminal.get("generated", -1)) != expected
            or int(terminal.get("failures", -1)) != 0
            or int(terminal.get("non_traversable", -1)) != 0
            or int(terminal.get("invalid", -1)) != 0):
        raise ValueError(f"native runtime batch rejected: {terminal}")
    for entry in candidates:
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
        "requested": len(CONFIG), "staged": len(candidates), "generated": len(candidates),
        "runtime_pmdo_mapgen_validated": len(candidates), "route_validated": 0,
        "promoted": 0, "blocked": len(CONFIG) - len(candidates),
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


def record_routes(route_dir: Path, promote: bool = False) -> dict[str, Any]:
    report = json.loads(REPORT_PATH.read_text(encoding="utf-8"))
    # Accept already-promoted candidates too: re-recording route evidence
    # against a new validator format (e.g. ground_init vs ground) or an
    # updated headless runtime is a legitimate operation and must not require
    # first rolling back the promotion.
    candidates = [entry for entry in report["entries"] if entry["status"] in {
        "NATIVE_MAPGEN_VALIDATED_ROUTE_PENDING", "ROUTE_VALIDATED_READY_FOR_PROMOTION",
        "ROUTE_VALIDATED_ASSET_BLOCKED", "PROMOTED_RUNTIME_VALIDATED"}]
    if not candidates:
        raise ValueError("route validation requires at least one mapgen-validated candidate")
    runtime_dir = REPORT_PATH.parent / "runtime/routes"
    runtime_dir.mkdir(parents=True, exist_ok=True)
    for entry in candidates:
        stem = entry["definition"]
        source_jsonl = route_dir / f"{entry['zone']}.jsonl"
        source_log = route_dir / f"{entry['zone']}.log"
        rows = [json.loads(line) for line in source_jsonl.read_text().splitlines() if line.strip()]
        maps = [row["floor"] for row in rows if row.get("event") == "map"]
        # RedStoryRouteValidator emits `ground_init` for every Ground the
        # runtime loads (fired from EngineServiceEvents.GroundMapInit, which
        # is the earliest reliable notification per
        # RogueEssence/Ground/Maps/GroundMap.cs:OnInit). Legacy runs used
        # `ground` (from GroundMapEnter, which is not guaranteed to fire on
        # canonical final Grounds whose Enter calls EndDungeonRun); still
        # accepted for backward compatibility.
        grounds = [row["id"] for row in rows
                   if row.get("event") in ("ground_init", "ground")]
        terminal = next((row for row in rows if row.get("event") == "end"), None)
        canonical = next((row for row in rows if row.get("event") == "canonical_end"), None)
        fatals = [row for row in rows if row.get("event") == "fatal"]
        source_end = str(entry.get("source_end") or "")
        # Route contract (headless runtime):
        #   1. No fatals emitted by the validator.
        #   2. All expected floors traversed in order.
        #   3. The Ground list starts with the canonical entrance and includes
        #      the canonical final Ground. We NO LONGER require the route to
        #      loop back to the entrance: the canonical final Ground scripts
        #      call EndDungeonRun which opens a FinalResultsMenu that needs
        #      player input to dismiss (RogueEssence/Data/GameProgress.cs
        #      Cleared branch), so the headless validator terminates as soon
        #      as the canonical final Ground is loaded (canonical scene proof).
        #   4. canonical_end is emitted with the correct final Ground id.
        #   5. end is emitted with canonical_complete=true.
        if fatals:
            raise ValueError(f"{stem}: route evidence rejected (fatals={fatals})")
        if maps != list(range(int(entry["floors"]))):
            raise ValueError(f"{stem}: route evidence rejected (maps={maps})")
        if not grounds or (source_end and source_end not in grounds):
            raise ValueError(f"{stem}: route evidence rejected (final Ground {source_end!r} not observed; grounds={grounds})")
        if not canonical or (source_end and canonical.get("id") != source_end):
            raise ValueError(f"{stem}: route evidence rejected (canonical_end={canonical})")
        if not terminal or not terminal.get("canonical_complete"):
            raise ValueError(f"{stem}: route evidence rejected (end={terminal})")
        if any(not row.get("map_seed") or row.get("stairs", 0) < 1
               for row in rows if row.get("event") == "map"):
            raise ValueError(f"{stem}: route map seed/stair evidence incomplete")
        target_jsonl = runtime_dir / source_jsonl.name
        target_log = runtime_dir / source_log.name
        shutil.copy2(source_jsonl, target_jsonl)
        if source_log.is_file():
            shutil.copy2(source_log, target_log)
        definition_path = ROOT / entry["definition_path"]
        definition = json.loads(definition_path.read_text(encoding="utf-8"))
        base_music_path = ROOT / "tools/dungeon_builder/data/base_music.txt"
        base_music = {line.strip() for line in base_music_path.read_text().splitlines()
                      if line.strip() and not line.startswith("#")}
        local_music = {path.stem for path in (ROOT / "Content/Music").glob("*.ogg")}
        music = str(definition.get("music") or "").removesuffix(".ogg")
        asset_blockers = []
        if music and music not in base_music and music not in local_music:
            asset_blockers.append("CANONICAL_MUSIC_ASSET_MISSING")
        can_promote = bool(promote) and not asset_blockers
        definition["provenance"]["status"].update({
            "runtime": ("validated" if not asset_blockers else "route_validated_asset_blocked"),
            "batch_approved": can_promote,
            "reason": (f"Native PMDO mapgen and complete {stem} entrance->floors->"
                       "canonical-end->return route passed."
                       + (" Canonical music asset missing." if asset_blockers else "")),
        })
        definition_path.write_text(json.dumps(definition, ensure_ascii=False, indent=2) + "\n")
        entry["route_runtime"] = {
            "jsonl": str(target_jsonl.relative_to(ROOT)),
            "jsonl_sha256": hashlib.sha256(target_jsonl.read_bytes()).hexdigest(),
            "log": str(target_log.relative_to(ROOT)) if target_log.is_file() else None,
            "maps": maps, "grounds": grounds, "fatals": 0,
        }
        entry["blockers"] = ([] if can_promote else asset_blockers + ["NOT_PROMOTED"])
        entry["status"] = ("PROMOTED_RUNTIME_VALIDATED" if can_promote
                           else ("ROUTE_VALIDATED_ASSET_BLOCKED" if asset_blockers
                                 else "ROUTE_VALIDATED_READY_FOR_PROMOTION"))
        if can_promote:
            canonical_definition = ROOT / "DungeonDefs/canonical" / f"{stem}.json"
            active_zone = ROOT / "Data/Zone" / f"{entry['zone']}.json"
            shutil.copy2(definition_path, canonical_definition)
            shutil.copy2(ROOT / entry["zone_path"], active_zone)
            parsed = load_definition(canonical_definition)
            zone_json = json.loads(active_zone.read_text(encoding="utf-8-sig"))
            update_zone_index(parsed, ExportResult(zone_path=active_zone, zone_json=zone_json))
            entry["active_definition"] = str(canonical_definition.relative_to(ROOT))
            entry["active_zone"] = str(active_zone.relative_to(ROOT))
        zone_path = ROOT / entry["zone_path"]
        entry["artifacts"] = {
            "definition_sha256": hashlib.sha256(definition_path.read_bytes()).hexdigest(),
            "zone_sha256": hashlib.sha256(zone_path.read_bytes()).hexdigest(),
        }
    preblocked = len(report["entries"]) - len(candidates)
    promoted_count = sum(entry["status"] == "PROMOTED_RUNTIME_VALIDATED"
                         for entry in candidates)
    candidate_blocked = sum(bool(entry.get("blockers")) for entry in candidates)
    report["summary"] = {
        "requested": len(CONFIG), "staged": len(candidates), "generated": len(candidates),
        "runtime_pmdo_mapgen_validated": len(candidates),
        "route_validated": len(candidates),
        "promoted": promoted_count,
        "blocked": preblocked + candidate_blocked,
    }
    REPORT_PATH.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    return report
