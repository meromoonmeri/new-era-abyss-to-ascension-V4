#!/usr/bin/env python3
"""Build the source-pinned semantic supplement for Tiny Woods palette commands."""
from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from datetime import date
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
PRET = ROOT / ".runtime-cache/pmd-red-reference"
ENGINE = ROOT / ".runtime-cache/RogueEssence-source"
PLAN_SHA256 = "ab9f2a8dcf857181a4dd188e28687cb953ba4789c9b6f39430c50fee4b94c37b"
PRET_COMMIT = "bf0092d0e34fd8e49b859a0b5f96f00740faa42d"
ENGINE_COMMIT = "4961b2271bb0cace74f40f6a85e799e8e4848ace"
OPCODES = (0x22, 0x23, 0x25, 0x26)
MAPPING = {
    0x22: {
        "semantic_name": "main_palette_fade_in",
        "gba_function": "sub_80999E8",
        "gba_channel_state": "gUnknown_2039958",
        "gba_palette_indices": "0-13,16-30,32 except explicit exemptions",
        "gba_target_brightness": "0x100",
        "pmdo_api": "GAME:FadeIn(frames)",
        "pmdo_channel": "main",
        "target": "visible",
    },
    0x23: {
        "semantic_name": "main_palette_fade_out",
        "gba_function": "sub_80999FC",
        "gba_channel_state": "gUnknown_2039958",
        "gba_palette_indices": "0-13,16-30,32 except explicit exemptions",
        "gba_target_brightness": "0x000",
        "pmdo_api": "GAME:FadeOut(false, frames)",
        "pmdo_channel": "main",
        "target": "black",
    },
    0x25: {
        "semantic_name": "reserved_palette_fade_in",
        "gba_function": "sub_8099A34",
        "gba_channel_state": "gUnknown_2039968",
        "gba_palette_indices": "14,15,31",
        "gba_target_brightness": "0x100",
        "pmdo_api": "GAME:FadeInFront(frames)",
        "pmdo_channel": "front",
        "target": "visible",
    },
    0x26: {
        "semantic_name": "reserved_palette_fade_out",
        "gba_function": "sub_8099A48",
        "gba_channel_state": "gUnknown_2039968",
        "gba_palette_indices": "14,15,31",
        "gba_target_brightness": "0x000",
        "pmdo_api": "GAME:FadeOutFront(false, frames)",
        "pmdo_channel": "front",
        "target": "black",
    },
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_head(path: Path) -> str:
    return subprocess.check_output(["git", "-C", str(path), "rev-parse", "HEAD"], text=True).strip()


def file_record(path: Path, lines: str) -> dict[str, Any]:
    return {
        "path": str(path.relative_to(ROOT)),
        "sha256": sha256(path),
        "relevant_lines": lines,
    }


def build() -> dict[str, Any]:
    if sha256(PLAN) != PLAN_SHA256:
        raise ValueError("authenticated command plan differs")
    if git_head(PRET) != PRET_COMMIT:
        raise ValueError("pinned pret technical reference differs")
    if git_head(ENGINE) != ENGINE_COMMIT:
        raise ValueError("pinned RogueEssence engine reference differs")

    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    commands: list[dict[str, Any]] = []
    opcode_counts = {f"0x{opcode:02X}": 0 for opcode in OPCODES}
    affected_arrays: list[str] = []
    for array in plan["arrays"]:
        selected = [row for row in array["commands"] if row["op"] in OPCODES]
        if not selected:
            continue
        affected_arrays.append(array["array_id"])
        by_index = {row["index"]: row for row in array["commands"]}
        for row in selected:
            opcode = row["op"]
            if row["pmdo_handler"] != "actor.control_unknown":
                raise ValueError(f"unknown-opcode planning fallback was unexpectedly changed at {row['address']}")
            if row["arg_byte"] != 1:
                raise ValueError(f"palette command is not blocking at {row['address']}")
            if row["arg_short"] not in (0, 30, 60):
                raise ValueError(f"unexpected palette duration at {row['address']}")
            previous = by_index.get(row["index"] - 1)
            following = by_index.get(row["index"] + 1)
            key = f"0x{opcode:02X}"
            opcode_counts[key] += 1
            commands.append({
                "ordinal": len(commands) + 1,
                "array_id": array["array_id"],
                "index": row["index"],
                "address": row["address"],
                "opcode": key,
                "opcode_value": opcode,
                "source_name": row["op_name"],
                "arg_byte": row["arg_byte"],
                "source_frames": row["arg_short"],
                "blocking": True,
                "planning_handler_retained": row["pmdo_handler"],
                "semantic_name": MAPPING[opcode]["semantic_name"],
                "channel": MAPPING[opcode]["pmdo_channel"],
                "target": MAPPING[opcode]["target"],
                "pmdo_api": MAPPING[opcode]["pmdo_api"],
                "previous_command": None if previous is None else {
                    "index": previous["index"], "address": previous["address"],
                    "opcode": previous["op_hex"], "name": previous["op_name"],
                },
                "next_command": None if following is None else {
                    "index": following["index"], "address": following["address"],
                    "opcode": following["op_hex"], "name": following["op_name"],
                },
            })

    if len(commands) != 15 or opcode_counts != {"0x22": 6, "0x23": 5, "0x25": 2, "0x26": 2}:
        raise ValueError("secondary palette command inventory differs")
    if len(affected_arrays) != 6:
        raise ValueError("affected array inventory differs")

    ground_script = PRET / "src/ground_script.c"
    palette_util = PRET / "src/palette_util.c"
    script_game = ENGINE / "RogueEssence/Lua/ScriptGame.cs"
    game_manager = ENGINE / "RogueEssence/Scene/GameManager.cs"
    fade_effect = ENGINE / "RogueEssence/Scene/FadeEffect.cs"
    result = {
        "schema": "pmdred-eu-tiny-woods-palette-semantics-v1",
        "date": str(date.today()),
        "status": "source_pinned_semantics_pass",
        "scope": {
            "content_authority": "authenticated PMD Red EU command_plan.json extracted from ROM bytes",
            "technical_references_only": ["pret/pmd-red", "RogueEssence/PMDO 0.8.12 engine source"],
            "commands": 15,
            "affected_arrays": len(affected_arrays),
            "opcode_counts": opcode_counts,
            "durations_frames": [0, 30, 60],
            "all_arg_byte_one_and_blocking": True,
        },
        "authority": {
            "region": "EU",
            "rom_sha256": "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd",
            "command_plan": file_record(PLAN, "exact 27-array/975-command decoded surface"),
        },
        "technical_sources": {
            "pret_commit": PRET_COMMIT,
            "pret_files": [
                file_record(ground_script, "550-554 completion dispatch; 1913-1942 opcode dispatch"),
                file_record(palette_util, "125-166 target scheduling; 252-265 channel entry points; 340-370 completion; 436-462 palette indices"),
            ],
            "rogueessence_commit": ENGINE_COMMIT,
            "rogueessence_files": [
                file_record(script_game, "238-275 blocking Lua front APIs; 277-313 blocking Lua main APIs; 1588-1591 coroutine bindings"),
                file_record(game_manager, "390-425 main/front fade targets"),
                file_record(fade_effect, "30-72 frame scheduler and immediate-target behavior"),
            ],
        },
        "opcode_semantics": {f"0x{opcode:02X}": MAPPING[opcode] for opcode in OPCODES},
        "affected_arrays": affected_arrays,
        "commands": commands,
        "adapter_contract": {
            "isolated_module": "halcyon.pmdred_palette_adapter",
            "only_promoted_opcodes": ["0x22", "0x23", "0x25", "0x26"],
            "all_other_unknown_opcodes_keep_actor_control_unknown_fallback": True,
            "trace_fields": ["address", "array_id", "index", "opcode", "source_frames", "runtime_frames", "channel", "target", "blocking", "api", "before_tick", "after_tick", "elapsed_frames"],
            "zero_frame_policy": {
                "source_frames_preserved_in_trace": 0,
                "runtime_frames": 1,
                "reason": "RogueEssence ScreenFadeFX.Fade with fadeTime=0 leaves a non-target fadeAmount unchanged; one PMDO frame is the narrow public-API immediate transition equivalent.",
            },
        },
        "limitations": [
            "pret/pmd-red establishes interpreter and palette-channel structure only; EU ROM-derived command operands and ordering remain content authority.",
            "The PMDO front overlay is the engine-native independent layer above menus; native certification must still prove actual call order, blocking frame progress, strict termination, and selected-route integration.",
        ],
    }
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite semantics supplement: {output}")
    output.parent.mkdir(parents=True, exist_ok=True)
    value = build()
    output.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"TINY_WOODS_PALETTE_SEMANTICS_PASS commands=15 arrays=6 output={output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
