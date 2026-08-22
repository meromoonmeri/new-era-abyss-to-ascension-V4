#!/usr/bin/env python3
"""Cross-bundle non-repetition gate for all generated canonical zones.

It validates the serialized RogueElements contract rather than replacing the
engine with a fake map generator: every procedural segment must expose three
structurally distinct ``ChanceFloorGen`` candidates and no production seed.
The optional PMDO smoke-test remains the final live proof.
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "docs/canonical_dungeons/complete_bundle_registry.json"


def signature(grid: dict):
    steps = [row["Value"] for row in grid["GenSteps"]]
    init = next(row for row in steps if "InitGridPlanStep" in row.get("$type", ""))
    path = next(row for row in steps if "GridPath" in row.get("$type", ""))
    tunnels = sum("AddTunnelStep" in row.get("$type", "") for row in steps)
    return (
        init["CellX"], init["CellY"], init["CellWidth"], init["CellHeight"], init["CellWall"],
        path["$type"].split("`")[0], json.dumps(path.get("RoomRatio", path.get("TierConnections", {})), sort_keys=True),
        json.dumps(path.get("BranchRatio", {}), sort_keys=True), tunnels,
    )


def main() -> int:
    registry = json.loads(REGISTRY.read_text())
    physical = [row for row in registry["main_route"] + registry["pmd_red_roster"] if not row.get("existing") and not row.get("alias_of")]
    errors = []
    checked = 0
    for entry in physical:
        zone = json.loads((ROOT / "Data/Zone" / f"{entry['id']}.json").read_text(encoding="utf-8-sig"))["Object"]
        fingerprints = set()
        passages = set()
        for segment in zone["Segments"]:
            if "RangeDictSegment" not in segment.get("$type", ""):
                continue
            for node in segment["Floors"]["nodes"]:
                candidates = node["Item"].get("Spawns", [])
                if len(candidates) < 3:
                    errors.append(f"{entry['id']}: fewer than three candidates")
                    continue
                variants = set()
                for candidate in candidates:
                    grid = candidate["Spawn"]
                    payload = json.dumps(grid, sort_keys=True)
                    if "FirstSeed" in payload or '"seed"' in payload.lower():
                        errors.append(f"{entry['id']}: fixed seed")
                    try:
                        variants.add(signature(grid))
                    except StopIteration:
                        errors.append(f"{entry['id']}: incomplete RogueElements steps")
                if len(variants) < 3:
                    errors.append(f"{entry['id']}: repeated topology family")
                fingerprints.update(variants)
                # Test-only deterministic coverage over ten possible visits;
                # this never writes or supplies a seed to production data.
                for visit in range(10):
                    digest = hashlib.sha256(f"{entry['id']}:{node['Range']}:{visit}".encode()).digest()
                    selected = candidates[digest[0] % len(candidates)]["Spawn"]
                    passages.add(repr((node["Range"], signature(selected), digest[1])))
        if len(fingerprints) < 3:
            errors.append(f"{entry['id']}: no topology diversity")
        if len(passages) < 5:
            errors.append(f"{entry['id']}: fewer than five distinct 10-pass fingerprints")
        checked += 1
    if errors:
        print("Complete variation gate: FAILED", *[" - " + error for error in errors], sep="\n", file=sys.stderr)
        return 1
    print(f"Complete variation gate: OK ({checked} physical zones, 10 test visits each)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
