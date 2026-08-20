#!/usr/bin/env python3
"""Independently validate Tiny Woods command-semantic supplement v3."""
from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
PLAN_SHA256 = "ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b"
OPS = {0x2D, 0x2E, 0x54, 0x56, 0x62, 0x6A, 0x6B, 0x8B, 0x91, 0x95, 0x98, 0x99, 0xDB, 0xDD, 0xDE, 0xDF}
EXPECTED = {
    0x2D: ("portrait.configure", "portrait", "UI:SetSpeaker"),
    0x2E: ("portrait.set", "portrait", "UI:SetSpeakerEmotion"),
    0x54: ("actor.animation", "animation", "GROUND:CharSetAnim"),
    0x56: ("actor.animation", "animation", "GROUND:CharSetAnim"),
    0x62: ("actor.motion", "movement", "GROUND:MoveInDirection"),
    0x6A: ("actor.walk_relative", "movement", "GROUND:MoveInDirection"),
    0x6B: ("actor.walk_grid", "movement", "GROUND:MoveInDirection"),
    0x8B: ("actor.face_wait", "facing", "GROUND:CharTurnToChar"),
    0x91: ("actor.rotate", "facing", "GROUND:CharAnimateTurnTo"),
    0x95: ("actor.rotate", "facing", "GROUND:CharAnimateTurnTo"),
    0x98: ("camera.begin", "camera", "GAME:MoveCamera"),
    0x99: ("camera.end", "camera", "GAME:MoveCamera"),
    0xDB: ("timing.wait", "timing", "GAME:WaitFrames"),
    0xDD: ("actor.animation_hold", "animation", "GROUND:CharEndAnim"),
    0xDE: ("actor.state", "actor_state", "GROUND:CharSetAction"),
    0xDF: ("actor.state", "actor_state", "GROUND:CharSetAction"),
}
COPY_KEYS = ("array_id", "source_index", "address", "op", "op_hex", "op_name", "arg_byte", "arg_short", "arg1", "arg2", "pmdo_handler")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def fail(message: str) -> None:
    raise ValueError(message)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--supplement", type=Path, required=True)
    args = parser.parse_args()
    if sha256(PLAN) != PLAN_SHA256:
        fail("command plan identity differs")
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    value = json.loads(args.supplement.read_text(encoding="utf-8"))
    if value.get("schema") != "pmdred-eu-tiny-woods-command-semantic-supplement-v3":
        fail("supplement schema differs")
    authority = value.get("authority", {})
    if authority.get("region") != "EU" or authority.get("command_plan_sha256") != PLAN_SHA256:
        fail("supplement authority differs")

    source = []
    unknown = []
    for array in plan["arrays"]:
        for row in array["commands"]:
            normalized = {**row, "array_id": array["array_id"], "source_index": row["index"]}
            if row["op"] in OPS:
                source.append(normalized)
            if row["pmdo_handler"] == "actor.control_unknown":
                unknown.append(normalized)
    rows = value.get("commands", [])
    if len(rows) != 304 or len(source) != 304:
        fail("304-row boundary differs")
    if [row.get("ordinal") for row in rows] != list(range(304)):
        fail("semantic ordinals differ")
    for actual, expected in zip(rows, source):
        for key in COPY_KEYS:
            if actual.get(key) != expected.get(key):
                fail(f"source field differs at ordinal {actual.get('ordinal')}: {key}")
        handler, category, api = EXPECTED[expected["op"]]
        if (actual.get("pmdo_handler"), actual.get("semantic_category"), actual.get("pmdo_api")) != (handler, category, api):
            fail(f"semantic mapping differs at {actual['address']}")
        retry = "s_gs178_g2_" in expected["array_id"]
        if actual.get("route_class") != ("retry_only" if retry else "selected_route"):
            fail(f"route class differs at {actual['address']}")
        frames = expected["arg_short"] if expected["op"] == 0xDB else 0
        if actual.get("source_frames") != frames or actual.get("blocking") is not (expected["op"] == 0xDB):
            fail(f"wait contract differs at {actual['address']}")
    addresses = [row["address"] for row in rows]
    if len(set(addresses)) != 304:
        fail("semantic addresses are not unique")
    if set(addresses).intersection(row["address"] for row in unknown):
        fail("semantic rows overlap planning unknown rows")
    totals = value.get("totals")
    expected_totals = {
        "commands": 304, "selected_route": 251, "retry_only": 53,
        "opcodes": 16, "source_waits": 108, "source_wait_frames": 3001,
        "selected_route_waits": 92, "selected_route_wait_frames": 2690,
        "planning_unknown_rows": 15, "supplement_unknown_rows": 0,
    }
    if totals != expected_totals:
        fail(f"aggregate totals differ: {totals}")
    contracts = value.get("opcode_contracts", [])
    if [row.get("op") for row in contracts] != list(EXPECTED):
        fail("opcode contract order differs")
    counts = Counter(row["op"] for row in rows)
    if any(row.get("commands") != counts[row["op"]] for row in contracts):
        fail("opcode contract counts differ")
    if value.get("contract", {}).get("command_plan_is_immutable") is not True:
        fail("immutable-plan boundary missing")
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_SUPPLEMENT_V3_VALID "
        f"commands=304 selected=251 retry_only=53 waits=108 frames=3001 sha256={sha256(args.supplement)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
