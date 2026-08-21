#!/usr/bin/env python3
"""Grouped static/integration validator for PMD Red EU early dungeons.

A per-dungeon JSON descriptor supplies identities and route contracts.  This
validator checks the promoted PMDO ZoneData, zone index, direct-ROM ending
Ground, collision-safe scripted landing, assets, music, French resources,
Lua lifecycle tokens, and deterministic inspectable renders in one run.

This is deliberately not a native-playback certificate.  It locks the exact
PMDO 0.8.12 executable that grouped final certification must execute, while
recording native gameplay/audio/unload as deferred rather than inferred.
Evidence writes are create-only; --check rebuilds and compares existing
validation evidence when it is present.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any, Iterable, Sequence

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "pmdred-eu-early-dungeon-grouped-static-integration-v1"


class ValidationError(RuntimeError):
    pass


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as stream:
        return json.load(stream)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def canonical_json(value: Any) -> bytes:
    return (json.dumps(value, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def root_path(value: str) -> Path:
    path = (ROOT / value).resolve()
    require(path == ROOT or ROOT in path.parents, f"path escapes repository: {value}")
    return path


def check_hash(path: Path, expected: str, label: str) -> dict[str, Any]:
    require(path.is_file(), f"missing {label}: {path.relative_to(ROOT)}")
    actual = sha256(path)
    require(actual == expected, f"{label} hash mismatch: {actual} != {expected}")
    return {
        "gate": label,
        "status": "PASS",
        "path": str(path.relative_to(ROOT)),
        "bytes": path.stat().st_size,
        "sha256": actual,
    }


def assert_tokens(path: Path, required: Iterable[str], forbidden: Iterable[str]) -> dict[str, Any]:
    require(path.is_file(), f"missing script: {path.relative_to(ROOT)}")
    text = path.read_text(encoding="utf-8")
    missing = [token for token in required if token not in text]
    present = [token for token in forbidden if token in text]
    require(not missing, f"missing script tokens in {path.relative_to(ROOT)}: {missing}")
    require(not present, f"forbidden script tokens in {path.relative_to(ROOT)}: {present}")
    return {
        "gate": f"script:{path.relative_to(ROOT)}",
        "status": "PASS",
        "required_tokens": list(required),
        "forbidden_tokens_absent": list(forbidden),
        "sha256": sha256(path),
    }


def validate_resources(spec: dict[str, Any]) -> dict[str, Any]:
    paths = [root_path(item) for item in spec["paths"]]
    parsed: list[dict[str, str]] = []
    for path in paths:
        require(path.is_file(), f"missing dialogue resource: {path.relative_to(ROOT)}")
        root = ET.parse(path).getroot()
        values = {
            node.attrib["name"]: (node.findtext("value") or "").strip()
            for node in root.findall("data")
        }
        parsed.append(values)
    for key in spec["keys"]:
        require(all(values.get(key) for values in parsed), f"empty/missing French dialogue key: {key}")
    require(all(values == parsed[0] for values in parsed[1:]), "default/French dialogue resources diverge")
    joined = "\n".join(parsed[0][key] for key in spec["keys"])
    for token in spec.get("required_text", []):
        require(token in joined, f"French dialogue token missing: {token}")
    return {
        "gate": "french_dialogue_resources",
        "status": "PASS",
        "paths": [str(path.relative_to(ROOT)) for path in paths],
        "keys": spec["keys"],
        "values_nonempty": True,
        "default_and_fr_identical": True,
    }


def validate_static_maps(specs: Sequence[dict[str, Any]]) -> list[dict[str, Any]]:
    """Validate optional mixed-segment static maps without weakening global gates."""
    records: list[dict[str, Any]] = []
    for spec in specs:
        path = root_path(spec["path"])
        identity = check_hash(path, spec["sha256"], f"authenticated static map:{spec['map_id']}")
        room = load_json(path)["Object"]
        require(room.get("AssetName") == spec["map_id"], "static map AssetName mismatch")
        columns = room.get("Tiles", [])
        width = len(columns)
        height = len(columns[0]) if columns else 0
        require([width, height] == spec["dimensions"], "static map dimensions mismatch")
        require(all(len(column) == height for column in columns), "static map has ragged tile columns")
        require(room.get("Music") == spec["music"], "static map music mismatch")
        entries = room.get("EntryPoints", [])
        require(len(entries) == 1, "static map must have exactly one entry")
        entry = entries[0]
        require(
            [entry["Loc"]["X"], entry["Loc"]["Y"], entry["Dir"]] == spec["entry"],
            "static map entry point mismatch",
        )
        stair_count = sum(
            1 for column in columns for tile in column
            if tile.get("Effect", {}).get("ID") == "stairs_go_up"
        )
        require(stair_count == spec.get("stairs", 0), "static map stair count mismatch")

        audit_spec = spec.get("audit")
        if audit_spec is not None:
            audit = room.get("StaticAudit", {})
            require(audit.get("ContractID") == audit_spec["contract_id"], "static audit contract mismatch")
            normal = sorted([point["X"], point["Y"]] for point in audit.get("AllowedUnreachableWalkable", []))
            secondary = sorted([point["X"], point["Y"]] for point in audit.get("AllowedUnreachableSecondary", []))
            require(normal == sorted(audit_spec["unreachable_normal"]), "static normal-isolation contract mismatch")
            require(secondary == sorted(audit_spec["unreachable_secondary"]), "static secondary-isolation contract mismatch")

        actor_records = []
        for actor_spec in spec.get("actors", []):
            faction = actor_spec["faction"]
            candidates = [
                actor
                for team in room.get(faction, [])
                for actor in team.get("Players", []) + team.get("Guests", [])
                if (actor.get("BaseForm") or actor.get("CurrentForm"))["Species"] == actor_spec["species"]
            ]
            require(len(candidates) == 1, f"static actor multiplicity mismatch: {actor_spec['species']}")
            actor = candidates[0]
            location = actor["serializationLoc"]
            require([location["X"], location["Y"]] == actor_spec["loc"], "static actor location mismatch")
            require(actor["Level"] == actor_spec["level"] and actor["HP"] == actor_spec["hp"],
                    "static actor level/HP mismatch")
            if "tactic" in actor_spec:
                require(actor.get("Tactic") == actor_spec["tactic"], "static actor tactic mismatch")
            if "status" in actor_spec:
                status = actor.get("StatusEffects", {}).get(actor_spec["status"])
                require(status is not None, "required protected-actor status is absent")
                counters = [
                    state.get("Counter") for state in status.get("StatusStates", [])
                    if "CountDownState" in state.get("$type", "")
                ]
                require(counters == [actor_spec["status_counter"]], "protected-actor status counter mismatch")
            actor_records.append({
                "species": actor_spec["species"], "faction": faction,
                "loc": actor_spec["loc"], "level": actor_spec["level"], "hp": actor_spec["hp"],
                **({"tactic": actor_spec["tactic"]} if "tactic" in actor_spec else {}),
                **({"status": actor_spec["status"], "status_counter": actor_spec["status_counter"]}
                   if "status" in actor_spec else {}),
            })

        starts = room.get("MapEffect", {}).get("OnMapStarts", [])
        actual_events = [
            {
                "priority": event.get("Key", {}).get("str"),
                "type": event.get("Value", {}).get("$type"),
                "script": event.get("Value", {}).get("Script"),
                "args": event.get("Value", {}).get("ArgTable"),
            }
            for event in starts
        ]
        for expected in spec.get("startup_events", []):
            require(expected in actual_events, f"static map startup event mismatch: {expected}")
        records.append({
            **identity,
            "gate": f"static_map_contract:{spec['map_id']}",
            "map_id": spec["map_id"], "dimensions": [width, height],
            "music": room["Music"], "stairs": stair_count,
            "actors": actor_records,
            "startup_priorities": [event["priority"] for event in actual_events],
            "static_audit_contract": audit_spec["contract_id"] if audit_spec else None,
        })
    return records


def validate_ground(spec: dict[str, Any]) -> tuple[dict[str, Any], dict[str, Any]]:
    path = root_path(spec["path"])
    identity = check_hash(path, spec["sha256"], "authenticated ending Ground")
    document = load_json(path)
    obj = document["Object"]
    require(obj["AssetName"] == spec["asset_name"], "ending Ground AssetName mismatch")
    obstacles = obj["obstacles"]
    width = len(obstacles)
    height = len(obstacles[0]) if obstacles else 0
    require(width == spec["obstacle_cells_x"], "ending Ground obstacle width mismatch")
    require(height == spec["obstacle_cells_y"], "ending Ground obstacle height mismatch")
    require(all(len(column) == height for column in obstacles), "ragged ending Ground obstacle grid")
    cell_size = spec["cell_size"]
    for x, column in enumerate(obstacles):
        for y, cell in enumerate(column):
            bounds = cell["Bounds"]
            require(
                bounds == {"X": x * cell_size, "Y": y * cell_size, "Width": cell_size, "Height": cell_size},
                f"ending Ground obstacle bounds mismatch at {x},{y}",
            )
    entities = obj["Entities"]
    require(len(entities) == 1, "ending Ground must have one entity layer")
    counts = {
        key: len(entities[0][key])
        for key in ("MapChars", "GroundObjects", "Spawners", "Markers")
    }
    require(counts == spec["entity_counts"], f"ending Ground entity counts changed: {counts}")

    landing = spec["scripted_landing"]
    first_x = landing["x"] // cell_size
    first_y = landing["y"] // cell_size
    last_x = math.ceil((landing["x"] + landing["width"]) / cell_size) - 1
    last_y = math.ceil((landing["y"] + landing["height"]) / cell_size) - 1
    require(0 <= first_x <= last_x < width and 0 <= first_y <= last_y < height, "scripted landing is out of bounds")
    cells = []
    for x in range(first_x, last_x + 1):
        for y in range(first_y, last_y + 1):
            tags = obstacles[x][y]["Tags"]
            require(tags == 0, f"scripted landing intersects collision at obstacle cell {x},{y}")
            cells.append([x, y])
    collision = {
        "gate": "ending_ground_collision_safe_scripted_landing",
        "status": "PASS",
        "landing_pixels": landing,
        "walkable_obstacle_cells": cells,
        "ground_pixels": [width * cell_size, height * cell_size],
        "marker_policy": "no invented marker; numeric entry 0 is relocated during Ground.Init",
    }
    return identity, collision


def expand_generator_contracts(
    zone_spec: dict[str, Any], floor_count: int
) -> list[dict[str, Any]]:
    """Expand optional range declarations into one strict contract per floor.

    Legacy all-procedural descriptors intentionally produce the exact contract
    that this validator enforced before mixed segments were supported.
    """
    declarations = zone_spec.get("generator_contracts")
    if declarations is None:
        return [{"generator": "chance", "stairs": 1} for _ in range(floor_count)]

    contracts: list[dict[str, Any] | None] = [None] * floor_count
    for declaration in declarations:
        floors = declaration["floors"]
        require(
            isinstance(floors, list) and len(floors) in (1, 2),
            "generator contract floors must be [floor] or inclusive [first,last]",
        )
        first = int(floors[0])
        last = int(floors[-1])
        require(1 <= first <= last <= floor_count, "generator contract floor range is invalid")
        generator = declaration["generator"]
        require(generator in ("chance", "static_load"), f"unsupported floor generator contract: {generator}")
        contract = {
            "generator": generator,
            "stairs": int(declaration.get("stairs", 1 if generator == "chance" else 0)),
        }
        if generator == "static_load":
            map_id = declaration.get("map_id")
            require(isinstance(map_id, str) and map_id, "static_load contract requires map_id")
            contract["map_id"] = map_id
            for field in ("loaded_hostiles", "loaded_allies"):
                if field in declaration:
                    records = declaration[field]
                    require(isinstance(records, list), f"{field} must be a list")
                    contract[field] = records
        require(contract["stairs"] in (0, 1), "floor stair contract must be zero or one")
        require(
            generator != "chance" or contract["stairs"] == 1,
            "procedural ChanceFloorGen floors require exactly one stair",
        )
        for floor in range(first, last + 1):
            require(contracts[floor - 1] is None, f"overlapping generator contract for floor {floor}")
            contracts[floor - 1] = dict(contract)
    missing = [index + 1 for index, contract in enumerate(contracts) if contract is None]
    require(not missing, f"missing generator contracts for floors: {missing}")
    return [contract for contract in contracts if contract is not None]


def mapped_room_id(load_gen: dict[str, Any], floor: int) -> str:
    for entry in load_gen.get("GenSteps", []):
        # PMDO 0.8.12 serializes Priority as its canonical composite form.
        # Keep scalar -1 compatibility for older hand-authored fixtures, but
        # never require the canonical serializer to flatten {"str": [-1]}.
        key = entry.get("Key")
        priority_minus_one = key == -1 or key == {"str": [-1]}
        if priority_minus_one and "MappedRoomStep" in entry.get("Value", {}).get("$type", ""):
            map_id = entry["Value"].get("MapID")
            require(isinstance(map_id, str) and map_id, f"floor {floor}: mapped room has no MapID")
            return map_id
    raise ValidationError(f"floor {floor}: LoadGen has no priority -1 MappedRoomStep")


def loaded_teams(
    load_gen: dict[str, Any], floor: int, *, ally: bool
) -> list[dict[str, Any]]:
    """Return canonical fixed team records from a loaded-floor generator."""
    records: list[dict[str, Any]] = []
    label = "ally" if ally else "hostile"
    for entry in load_gen.get("GenSteps", []):
        value = entry.get("Value", {})
        if "PlaceNoLocMobsStep" not in value.get("$type", ""):
            continue
        if value.get("Ally") is not ally:
            continue
        spawner = value.get("Spawn", {})
        require(
            "PresetMultiTeamSpawner" in spawner.get("$type", ""),
            f"floor {floor}: loaded {label} step has an unsupported team spawner",
        )
        for team_spawn in spawner.get("Spawns", []):
            # Canonical PMDO 0.8.12 records are direct SpecificTeamSpawner
            # objects.  Keep compatibility with older wrapped fixtures only.
            team = team_spawn.get("Spawn", team_spawn)
            require(
                bool(team.get("Explorer")) is ally,
                f"floor {floor}: loaded {label} Explorer flag differs",
            )
            for mob in team.get("Spawns", []):
                locations = [
                    feature for feature in mob.get("SpawnFeatures", [])
                    if "MobSpawnLoc" in feature.get("$type", "")
                ]
                require(
                    len(locations) == 1,
                    f"floor {floor}: loaded {label} requires exactly one MobSpawnLoc",
                )
                feature = locations[0]
                loc = feature["Loc"]
                records.append({
                    "id": mob["BaseForm"]["Species"],
                    "level": int(mob["Level"]["Min"]),
                    "x": int(loc["X"]),
                    "y": int(loc["Y"]),
                    "direction": int(feature["Dir"]),
                })
    return records


def loaded_hostiles(load_gen: dict[str, Any], floor: int) -> list[dict[str, Any]]:
    return loaded_teams(load_gen, floor, ally=False)


def loaded_allies(load_gen: dict[str, Any], floor: int) -> list[dict[str, Any]]:
    return loaded_teams(load_gen, floor, ally=True)


def validate_zone_generators(
    nodes: list[dict[str, Any]], contracts: list[dict[str, Any]]
) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for floor, (node, contract) in enumerate(zip(nodes, contracts, strict=True), 1):
        generator = node["Item"]
        type_name = generator.get("$type", "")
        if contract["generator"] == "chance":
            require(
                type_name.endswith("ChanceFloorGen, RogueEssence"),
                f"floor {floor}: expected ChanceFloorGen, got {type_name}",
            )
            records.append({"floor": floor, "generator": "ChanceFloorGen", "stairs": 1})
        else:
            require(
                type_name == "RogueEssence.LevelGen.LoadGen, RogueEssence",
                f"floor {floor}: expected LoadGen, got {type_name}",
            )
            map_id = mapped_room_id(generator, floor)
            require(map_id == contract["map_id"], f"floor {floor}: static map mismatch: {map_id}")
            actual_hostiles = loaded_hostiles(generator, floor)
            expected_hostiles = contract.get("loaded_hostiles", [])
            require(
                actual_hostiles == expected_hostiles,
                f"floor {floor}: loaded hostiles mismatch: {actual_hostiles} != {expected_hostiles}",
            )
            actual_allies = loaded_allies(generator, floor)
            expected_allies = contract.get("loaded_allies", [])
            require(
                actual_allies == expected_allies,
                f"floor {floor}: loaded allies mismatch: {actual_allies} != {expected_allies}",
            )
            records.append({
                "floor": floor,
                "generator": "LoadGen",
                "map_id": map_id,
                "stairs": contract["stairs"],
                "loaded_hostiles": actual_hostiles,
                "loaded_allies": actual_allies,
            })
    return records


def validate_renders(
    spec: dict[str, Any],
    zone_path: Path,
    floor_count: int,
    generator_contracts: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    output_dir = root_path(spec["output_dir"])
    audit_path = output_dir / spec.get("audit", "render_audit.json")
    audit = load_json(audit_path)
    require(audit["status"] == "passed", "render audit is not passed")
    require(audit["zone"]["floors"] == floor_count, "render audit floor count mismatch")
    require(audit["inputs"]["zone"]["sha256"] == sha256(zone_path), "render audit is stale for promoted ZoneData")
    require(len(audit["floors"]) == floor_count, "render audit floor records mismatch")
    contracts = generator_contracts or [{"generator": "chance", "stairs": 1}] * floor_count
    for expected_floor, (floor, contract) in enumerate(zip(audit["floors"], contracts, strict=True), 1):
        require(floor["floor"] == expected_floor, "render audit floor order mismatch")
        invariants = floor["static_invariants"]
        require(all(invariants.values()), f"render invariant failed on floor {expected_floor}: {invariants}")
        stairs = floor["stairs"]
        if contract["generator"] == "chance":
            require("generator" not in floor, f"floor {expected_floor}: procedural render changed generator contract")
            require(stairs["count"] == 1 and stairs["reachable"] is True,
                    f"stair gate failed on procedural floor {expected_floor}")
        else:
            require(floor.get("generator") == "static_load",
                    f"floor {expected_floor}: render is not declared static_load")
            require(floor["generation"]["map_id"] == contract["map_id"],
                    f"floor {expected_floor}: rendered static map mismatch")
            require(stairs["count"] == contract["stairs"],
                    f"floor {expected_floor}: static stair count mismatch")
            if contract["stairs"] == 0:
                require(stairs.get("required") is False and stairs.get("reachable") is None,
                        f"floor {expected_floor}: static no-stair policy mismatch")
                require(stairs.get("policy") == "static boss arena",
                        f"floor {expected_floor}: static arena policy mismatch")
        require(floor["terrain"]["black_cells"] == 0, f"black terrain on floor {expected_floor}")
        require(floor["terrain"]["transparent_cells"] == 0, f"transparent terrain on floor {expected_floor}")
    for name, output in audit["outputs"].items():
        path = output_dir / name
        require(path.is_file(), f"missing render output: {path.relative_to(ROOT)}")
        require(path.stat().st_size == output["bytes"] and sha256(path) == output["sha256"],
                f"render output hash/size mismatch: {name}")
        require(path.read_bytes().startswith(b"\x89PNG\r\n\x1a\n"), f"render is not PNG: {name}")
    result = {
        "gate": "deterministic_inspectable_floor_renders",
        "status": "PASS",
        "output_dir": str(output_dir.relative_to(ROOT)),
        "audit_sha256": sha256(audit_path),
        "floors": floor_count,
        "pngs": sorted(audit["outputs"]),
        "black_terrain_cells": 0,
        "transparent_terrain_cells": 0,
        "reachable_stairs_per_floor": 1,
    }
    if generator_contracts is not None:
        result["stair_contracts"] = [contract["stairs"] for contract in contracts]
        result["reachable_stairs_per_floor"] = "per_declared_generator_contract"
    return result


def build_report(config_path: Path) -> dict[str, Any]:
    config = load_json(config_path)
    require(config["schema"] == "pmdred-eu-early-dungeon-validation-config-v1", "unsupported validation config")
    gates: list[dict[str, Any]] = []

    gates.append(check_hash(root_path(config["rom"]["path"]), config["rom"]["sha256"], "authenticated PMD Red EU ROM"))
    gates.append(check_hash(root_path(config["pmdo"]["path"]), config["pmdo"]["sha256"], "exact PMDO 0.8.12 executable lock"))

    zone_spec = config["zone"]
    zone_path = root_path(zone_spec["path"])
    zone_doc = load_json(zone_path)
    require(zone_doc["Version"] == "0.8.12.0", "ZoneData PMDO version mismatch")
    zone = zone_doc["Object"]
    require(zone["$type"] == "RogueEssence.Data.ZoneData, RogueEssence", "ZoneData type mismatch")
    require(zone["GroundMaps"] == zone_spec["ground_maps"], "ZoneData GroundMaps mismatch")
    require(len(zone["Segments"]) == 1, "expected one early-dungeon segment")
    nodes = zone["Segments"][0]["Floors"]["nodes"]
    require(len(nodes) == zone_spec["floors"], "ZoneData floor count mismatch")
    contracts_declared = "generator_contracts" in zone_spec
    generator_contracts = expand_generator_contracts(zone_spec, len(nodes))
    generator_records = validate_zone_generators(nodes, generator_contracts)
    zone_gate = {
        "gate": "pmdo_0_8_12_zone_schema_and_floors",
        "status": "PASS",
        "path": zone_spec["path"],
        "sha256": sha256(zone_path),
        "floors": len(nodes),
        "ground_maps": zone["GroundMaps"],
    }
    if contracts_declared:
        zone_gate["floor_generators"] = generator_records
    gates.append(zone_gate)

    index_path = root_path(zone_spec["index"])
    require(index_path.read_bytes().startswith(b"\xef\xbb\xbf"), "zone index UTF-8 BOM was not preserved")
    summary = load_json(index_path)["Object"][config["zone_id"]]
    require(summary["Grounds"] == zone["GroundMaps"], "zone/index GroundMaps mismatch")
    require(summary["Maps"] == [list(range(zone_spec["floors"]))], "zone/index floor registry mismatch")
    require(summary["CountedFloors"] == zone_spec["floors"], "zone/index CountedFloors mismatch")
    gates.append({
        "gate": "zone_index_schema_bom_and_route_binding",
        "status": "PASS",
        "path": zone_spec["index"],
        "zone_id": config["zone_id"],
        "grounds": summary["Grounds"],
        "maps": summary["Maps"],
        "utf8_bom": True,
    })

    for asset in config["assets"]:
        gates.append(check_hash(root_path(asset["path"]), asset["sha256"], f"asset:{asset['path']}"))
    gates.extend(validate_static_maps(config.get("static_maps", [])))

    ground_identity, landing_gate = validate_ground(config["ending_ground"])
    gates.extend([ground_identity, landing_gate])

    music_spec = config["music"]
    music_path = root_path(music_spec["path"])
    gates.append(check_hash(music_path, music_spec["sha256"], "authenticated dungeon music"))
    music_report = load_json(root_path(music_spec["report"]))
    require(music_report["status"] == "PASS", "music source/dependency/Vorbis report failed")
    require(music_report["sha256"] == music_spec["sha256"], "music report/output identity mismatch")
    require(music_report["song_index"] == music_spec["song_index"], "music song index mismatch")
    gates.append({
        "gate": "music_source_dependency_loop_vorbis_report",
        "status": "PASS",
        "report": music_spec["report"],
        "song_index": music_report["song_index"],
        "sample_rate": music_report["sample_rate"],
        "samples": music_report["samples"],
        "loop_start": music_report["loop_start"],
        "loop_length": music_report["loop_length"],
        "native_playback": "DEFERRED_NOT_EXECUTED",
    })

    for script in config["scripts"]:
        gates.append(assert_tokens(root_path(script["path"]), script["required"], script.get("forbidden", [])))
    gates.append(validate_resources(config["dialogue"]))
    gates.append(validate_renders(
        config["renders"],
        zone_path,
        zone_spec["floors"],
        generator_contracts if contracts_declared else None,
    ))

    manifest = load_json(root_path(config["manifest"]["path"]))
    require(manifest["route"] == config["manifest"]["route"], "manifest route mismatch")
    require(manifest["floors"] == zone_spec["floors"], "manifest floor count mismatch")
    gates.append({
        "gate": "manifest_route_and_scope",
        "status": "PASS",
        "path": config["manifest"]["path"],
        "route": manifest["route"],
    })

    return {
        "schema": SCHEMA,
        "status": "PASS_STATIC_INTEGRATION",
        "zone_id": config["zone_id"],
        "title": config["title"],
        "config": {
            "path": str(config_path.relative_to(ROOT)),
            "sha256": sha256(config_path),
        },
        "gates": gates,
        "summary": {
            "gate_count": len(gates),
            "floor_count": zone_spec["floors"],
            "all_static_integration_gates_passed": True,
            "converted_floor_pngs_inspectable": True,
            "exact_pmdo_binary_locked": True,
            "exact_pmdo_native_route_gameplay_audio_unload": "DEFERRED_NOT_EXECUTED",
            "reason_deferred": "grouped final native certification follows the bulk early-dungeon conversion batch",
        },
        "claims": {
            "proved": [
                "exact EU ROM and promoted source asset hashes",
                "PMDO 0.8.12 ZoneData/index schema and complete floor registry",
                "ending Ground identity, dimensions, route binding, and collision-safe scripted landing",
                "French completion resources and shared Lua lifecycle contract",
                "authenticated music source/dependency/loop/Vorbis gates",
                "byte-for-byte deterministic floor PNG render check inputs and invariants",
            ],
            "not_claimed": [
                "PMDO-native dungeon generation or gameplay",
                "PMDO-native music playback",
                "PMDO-native end-to-end route and graceful unload",
            ],
        },
    }


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write-evidence", action="store_true")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        config_path = args.config.resolve()
        require(config_path == ROOT or ROOT in config_path.parents, "config escapes repository")
        config = load_json(config_path)
        evidence_path = root_path(config["evidence"])
        report = build_report(config_path)
        expected = canonical_json(report)
        if args.write_evidence:
            evidence_path.parent.mkdir(parents=True, exist_ok=True)
            with evidence_path.open("xb") as stream:
                stream.write(expected)
            action = "created"
        else:
            if evidence_path.exists():
                require(evidence_path.read_bytes() == expected, "existing grouped evidence is stale or changed")
                action = "verified with byte-identical evidence"
            else:
                action = "validated in memory (evidence absent)"
        print(f"PASS: {action}: {config['zone_id']} ({len(report['gates'])} grouped static/integration gates)")
        print("DEFERRED_NOT_EXECUTED: exact-PMDO native route/gameplay/audio/unload final certification")
        return 0
    except Exception as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
