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


def validate_renders(spec: dict[str, Any], zone_path: Path, floor_count: int) -> dict[str, Any]:
    output_dir = root_path(spec["output_dir"])
    audit_path = output_dir / spec.get("audit", "render_audit.json")
    audit = load_json(audit_path)
    require(audit["status"] == "passed", "render audit is not passed")
    require(audit["zone"]["floors"] == floor_count, "render audit floor count mismatch")
    require(audit["inputs"]["zone"]["sha256"] == sha256(zone_path), "render audit is stale for promoted ZoneData")
    require(len(audit["floors"]) == floor_count, "render audit floor records mismatch")
    for expected_floor, floor in enumerate(audit["floors"], 1):
        require(floor["floor"] == expected_floor, "render audit floor order mismatch")
        invariants = floor["static_invariants"]
        require(all(invariants.values()), f"render invariant failed on floor {expected_floor}: {invariants}")
        require(floor["stairs"]["count"] == 1 and floor["stairs"]["reachable"] is True,
                f"stair gate failed on floor {expected_floor}")
        require(floor["terrain"]["black_cells"] == 0, f"black terrain on floor {expected_floor}")
        require(floor["terrain"]["transparent_cells"] == 0, f"transparent terrain on floor {expected_floor}")
    for name, output in audit["outputs"].items():
        path = output_dir / name
        require(path.is_file(), f"missing render output: {path.relative_to(ROOT)}")
        require(path.stat().st_size == output["bytes"] and sha256(path) == output["sha256"],
                f"render output hash/size mismatch: {name}")
        require(path.read_bytes().startswith(b"\x89PNG\r\n\x1a\n"), f"render is not PNG: {name}")
    return {
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
    require(all(node["Item"]["$type"].endswith("ChanceFloorGen, RogueEssence") for node in nodes),
            "non-ChanceFloorGen floor in early dungeon")
    gates.append({
        "gate": "pmdo_0_8_12_zone_schema_and_floors",
        "status": "PASS",
        "path": zone_spec["path"],
        "sha256": sha256(zone_path),
        "floors": len(nodes),
        "ground_maps": zone["GroundMaps"],
    })

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
    gates.append(validate_renders(config["renders"], zone_path, zone_spec["floors"]))

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
