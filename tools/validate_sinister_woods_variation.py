#!/usr/bin/env python3
"""Non-repetition contract for the procedural floors of Sinister Woods.

The game-side generator is RogueElements, so this tool deliberately does not
replace it with a home-grown dungeon generator.  It checks the serialized
RogueElements contract (three genuinely different ChanceFloorGen families per
floor and no serialized seed), then can validate a real PMDO probe transcript
from 5–10 or more visits.

Static use during CI:
    python3 tools/validate_sinister_woods_variation.py --passes 10

Runtime use after adding a PMDO debug probe that emits JSON lines with at least
``event=map, segment, map_id, layout, reachable``:
    python3 tools/validate_sinister_woods_variation.py \
        --runtime-events /tmp/sinister-woods-layouts.jsonl --passes 10
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any, Iterator

ROOT = Path(__file__).resolve().parents[1]
ZONE_PATH = ROOT / "Data/Zone/gloomy_forest.json"
MATERIALS = {"sinister_woods_b41_floor", "sinister_woods_b41_wall", "sinister_woods_b41_secondary"}


def walk(value: Any) -> Iterator[Any]:
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def first_step(grid: dict[str, Any], token: str) -> dict[str, Any]:
    for entry in grid.get("GenSteps", []):
        value = entry.get("Value", {})
        if token in value.get("$type", ""):
            return value
    raise ValueError(f"{token} absent")


def signature(grid: dict[str, Any]) -> tuple[Any, ...]:
    init = first_step(grid, "InitGridPlanStep")
    path = next(
        value for value in (entry.get("Value", {}) for entry in grid.get("GenSteps", []))
        if "GridPath" in value.get("$type", "")
    )
    connect = next(
        (value for value in (entry.get("Value", {}) for entry in grid.get("GenSteps", [])) if "ConnectGridBranchStep" in value.get("$type", "")),
        {},
    )
    tunnels = [
        value for value in (entry.get("Value", {}) for entry in grid.get("GenSteps", []))
        if "AddTunnelStep" in value.get("$type", "")
    ]
    return (
        init.get("CellX"), init.get("CellY"), init.get("CellWidth"), init.get("CellHeight"), init.get("CellWall"),
        path.get("$type", "").split("`")[0],
        json.dumps(path.get("RoomRatio", path.get("TierConnections", {})), sort_keys=True),
        json.dumps(path.get("BranchRatio", {}), sort_keys=True),
        connect.get("ConnectPercent"),
        len(tunnels),
        json.dumps(tunnels[0].get("Halls", {}) if tunnels else {}, sort_keys=True),
    )


def static_contract(zone: dict[str, Any], passes: int) -> list[str]:
    errors: list[str] = []
    if len(zone.get("Segments", [])) != 3:
        return ["expected exactly three canonical segments"]

    all_floor_signatures: set[tuple[Any, ...]] = set()
    for segment_index, floor_count in ((0, 10), (1, 2)):
        nodes = zone["Segments"][segment_index].get("Floors", {}).get("nodes", [])
        if len(nodes) != floor_count:
            errors.append(f"segment {segment_index}: expected {floor_count} floor nodes")
            continue
        for floor, node in enumerate(nodes):
            chance = node.get("Item", {})
            spawns = chance.get("Spawns", [])
            if "ChanceFloorGen" not in chance.get("$type", "") or len(spawns) < 3:
                errors.append(f"segment {segment_index} floor {floor}: fewer than three runtime families")
                continue
            variants: set[tuple[Any, ...]] = set()
            for spawn in spawns:
                grid = spawn.get("Spawn", {})
                payload = json.dumps(grid, sort_keys=True)
                if "FirstSeed" in payload or '"seed"' in payload.lower():
                    errors.append(f"segment {segment_index} floor {floor}: fixed seed serialized")
                if not all(material in payload for material in MATERIALS):
                    errors.append(f"segment {segment_index} floor {floor}: incomplete DTEF material triplet")
                try:
                    stairs = first_step(grid, "FloorStairsStep")
                    if stairs.get("MinDistance", 0) < 1:
                        errors.append(f"segment {segment_index} floor {floor}: stairs have no fairness distance")
                    variants.add(signature(grid))
                except (StopIteration, ValueError) as exc:
                    errors.append(f"segment {segment_index} floor {floor}: invalid generator ({exc})")
            if len(variants) < 3:
                errors.append(f"segment {segment_index} floor {floor}: families collapse to identical skeletons")
            all_floor_signatures.update(variants)

    # A reproducible *test-only* schedule visits all real candidate generators
    # over N passes.  It never feeds a seed into production ZoneData.
    seen: set[str] = set()
    nodes = zone["Segments"][0]["Floors"]["nodes"]
    for passage in range(passes):
        digest = hashlib.sha256(f"sinister-woods-static-sample:{passage}".encode()).digest()
        floor = digest[0] % len(nodes)
        variants = nodes[floor]["Item"]["Spawns"]
        choice = digest[1] % len(variants)
        seen.add(repr((floor, choice, signature(variants[choice]["Spawn"]))))
    if passes >= 5 and len(seen) < min(5, passes):
        errors.append(f"only {len(seen)} distinct generator fingerprints in {passes} sample passages")
    if len(all_floor_signatures) < 12:
        errors.append("floor plan signatures are unexpectedly shared across the 12 procedural floors")
    return errors


def runtime_contract(path: Path, passes: int) -> list[str]:
    if not path.is_file():
        return [f"runtime transcript missing: {path}"]
    rows: list[dict[str, Any]] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        raw = raw.strip()
        if not raw:
            continue
        try:
            row = json.loads(raw)
        except json.JSONDecodeError as exc:
            return [f"invalid JSONL runtime transcript: {exc}"]
        if row.get("event") == "map" and row.get("segment") in (0, 1):
            rows.append(row)
    if len(rows) < passes:
        return [f"runtime transcript has {len(rows)} procedural maps; {passes} required"]

    fingerprints: set[str] = set()
    errors: list[str] = []
    for index, row in enumerate(rows[:passes]):
        if row.get("reachable") is not True:
            errors.append(f"runtime map {index}: not fully traversable")
        # A probe should include room/hall/stair/item placement data.  Keeping
        # it opaque here lets the engine decide its exact shape while making
        # repeated output mechanically visible to the test.
        layout = row.get("layout")
        if not isinstance(layout, (dict, list, str)):
            errors.append(f"runtime map {index}: layout fingerprint missing")
            continue
        fingerprints.add(json.dumps(layout, sort_keys=True, ensure_ascii=False))
    if len(fingerprints) != min(passes, len(rows)):
        errors.append(f"runtime duplicate layout detected: {len(fingerprints)}/{min(passes, len(rows))} unique")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--passes", type=int, default=10, help="minimum 5, default 10")
    parser.add_argument("--runtime-events", type=Path, help="optional JSONL PMDO probe transcript")
    args = parser.parse_args()
    if args.passes < 5:
        parser.error("--passes must be at least 5")

    zone = json.loads(ZONE_PATH.read_text(encoding="utf-8-sig"))["Object"]
    errors = static_contract(zone, args.passes)
    if args.runtime_events:
        errors.extend(runtime_contract(args.runtime_events, args.passes))
    if errors:
        print("Sinister Woods variation contract: FAILED", file=sys.stderr)
        for error in errors:
            print(f" - {error}", file=sys.stderr)
        return 1
    mode = "static + runtime" if args.runtime_events else "static"
    print(f"Sinister Woods variation contract: OK ({mode}, {args.passes} passes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
