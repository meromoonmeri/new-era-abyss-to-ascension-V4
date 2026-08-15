#!/usr/bin/env python3
"""Generate the non-mutating Tiny Woods command-semantic supplement v3.

The authenticated EU command plan remains immutable.  This supplement assigns
explicit PMDO adaptation contracts only to the 304 portrait, actor, camera, and
wait commands whose observable semantics can be represented without changing
any of the 975 source rows.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PLAN_SHA256 = "ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b"
HISTORICAL_V1_SHA256 = "2ab85a8535728135b3fdc59455fe970f4957e16c0e23deccc790e505d4e5729b"
HISTORICAL_V2_SHA256 = "a7e6bb030f0a8de06f7256faaf0052954b40556f23c997b2d4bbf4e3249fabd6"

# Content semantics come from authenticated operands.  pret names are used only
# as structural labels already preserved in command_plan.json.
SEMANTICS = {
    0x2D: ("portrait.configure", "portrait", "UI:SetSpeaker", "speaker/portrait configuration"),
    0x2E: ("portrait.set", "portrait", "UI:SetSpeakerEmotion", "portrait expression selection"),
    0x54: ("actor.animation", "animation", "GROUND:CharSetAnim", "selected animation"),
    0x56: ("actor.animation", "animation", "GROUND:CharSetAnim", "selected animation variant"),
    0x62: ("actor.motion", "movement", "GROUND:MoveInDirection", "relative actor motion"),
    0x6A: ("actor.walk_relative", "movement", "GROUND:MoveInDirection", "relative walk"),
    0x6B: ("actor.walk_grid", "movement", "GROUND:MoveInDirection", "grid walk"),
    0x8B: ("actor.face_wait", "facing", "GROUND:CharTurnToChar", "facing change with wait"),
    0x91: ("actor.rotate", "facing", "GROUND:CharAnimateTurnTo", "animated rotation"),
    0x95: ("actor.rotate", "facing", "GROUND:CharAnimateTurnTo", "animated rotation variant"),
    0x98: ("camera.begin", "camera", "GAME:MoveCamera", "camera pan begin"),
    0x99: ("camera.end", "camera", "GAME:MoveCamera", "camera pan completion"),
    0xDB: ("timing.wait", "timing", "GAME:WaitFrames", "blocking source-frame wait"),
    0xDD: ("actor.animation_hold", "animation", "GROUND:CharEndAnim", "hold current animation frame"),
    0xDE: ("actor.state", "actor_state", "GROUND:CharSetAction", "actor state transition"),
    0xDF: ("actor.state", "actor_state", "GROUND:CharSetAction", "actor state transition variant"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def route_class(array_id: str) -> str:
    # d01p01 group 2 is the authenticated defeat/retry station.  Its four
    # arrays contain exactly 53 of the 304 rows; all other rows are selected by
    # opening/post-rescue route certification.
    return "retry_only" if "s_gs178_g2_" in array_id else "selected_route"


def build() -> dict:
    if sha256(PLAN) != PLAN_SHA256:
        raise ValueError("authenticated Tiny Woods command plan identity differs")
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    rows = []
    ordinal = 0
    for array in plan["arrays"]:
        for command in array["commands"]:
            if command["op"] not in SEMANTICS:
                continue
            handler, category, api, interpretation = SEMANTICS[command["op"]]
            if command["pmdo_handler"] != handler:
                raise ValueError(f"plan handler differs at {command['address']}")
            frames = command["arg_short"] if command["op"] == 0xDB else 0
            rows.append({
                "ordinal": ordinal,
                "array_id": array["array_id"],
                "source_index": command["index"],
                "address": command["address"],
                "op": command["op"],
                "op_hex": command["op_hex"],
                "op_name": command["op_name"],
                "arg_byte": command["arg_byte"],
                "arg_short": command["arg_short"],
                "arg1": command["arg1"],
                "arg2": command["arg2"],
                "pmdo_handler": handler,
                "semantic_category": category,
                "pmdo_api": api,
                "interpretation": interpretation,
                "route_class": route_class(array["array_id"]),
                "source_frames": frames,
                "blocking": command["op"] == 0xDB,
            })
            ordinal += 1
    opcode_contracts = [
        {
            "op": op,
            "op_hex": f"0x{op:02X}",
            "pmdo_handler": values[0],
            "semantic_category": values[1],
            "pmdo_api": values[2],
            "interpretation": values[3],
            "commands": sum(row["op"] == op for row in rows),
        }
        for op, values in SEMANTICS.items()
    ]
    selected = [row for row in rows if row["route_class"] == "selected_route"]
    waits = [row for row in rows if row["op"] == 0xDB]
    unknown = [
        row for array in plan["arrays"] for row in array["commands"]
        if row["pmdo_handler"] == "actor.control_unknown"
    ]
    result = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-supplement-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(),
        "authority": {
            "region": "EU",
            "rom_sha256": ROM_SHA256,
            "command_plan": str(PLAN.relative_to(ROOT)),
            "command_plan_sha256": PLAN_SHA256,
            "content_authority": "authenticated PMD Red Rescue Team EU ROM bytes",
            "technical_reference_only": "pret/pmd-red command structure and names",
        },
        "recovery_provenance": {
            "purpose": "fresh create-only recovery after the prior local semantic correction was not accepted by the remote repository",
            "historical_supplement_v1_sha256": HISTORICAL_V1_SHA256,
            "historical_metadata_correction_v2_sha256": HISTORICAL_V2_SHA256,
            "prior_payloads_are_not_recreated_or_overwritten": True,
        },
        "contract": {
            "command_plan_is_immutable": True,
            "source_rows_are_copied_without_operand_mutation": True,
            "supplement_is_address_keyed_and_order_preserving": True,
            "production_execution_requires_actor_context_resolution": True,
            "native_adapter_proof_executes_exact_source_waits_and validates_non_wait_metadata": True,
        },
        "totals": {
            "commands": len(rows),
            "selected_route": len(selected),
            "retry_only": len(rows) - len(selected),
            "opcodes": len(opcode_contracts),
            "source_waits": len(waits),
            "source_wait_frames": sum(row["source_frames"] for row in waits),
            "selected_route_waits": sum(row["op"] == 0xDB for row in selected),
            "selected_route_wait_frames": sum(row["source_frames"] for row in selected),
            "planning_unknown_rows": len(unknown),
            "supplement_unknown_rows": sum(row["pmdo_handler"] == "actor.control_unknown" for row in rows),
        },
        "opcode_contracts": opcode_contracts,
        "commands": rows,
    }
    expected = {
        "commands": 304, "selected_route": 251, "retry_only": 53,
        "opcodes": 16, "source_waits": 108, "source_wait_frames": 3001,
        "selected_route_waits": 92, "selected_route_wait_frames": 2690,
        "planning_unknown_rows": 15, "supplement_unknown_rows": 0,
    }
    if result["totals"] != expected:
        raise ValueError(f"semantic supplement totals differ: {result['totals']}")
    if {row["address"] for row in rows}.intersection(row["address"] for row in unknown):
        raise ValueError("semantic supplement overlaps planning unknown rows")
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        raise FileExistsError(f"refusing to overwrite semantic supplement: {args.output}")
    value = build()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_SUPPLEMENT_V3_PASS "
        "commands=304 selected=251 retry_only=53 opcodes=16 waits=108 frames=3001 "
        f"output={args.output} sha256={sha256(args.output)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
