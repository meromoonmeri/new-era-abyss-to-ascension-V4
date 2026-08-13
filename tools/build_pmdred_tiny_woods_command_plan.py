#!/usr/bin/env python3
"""Build an address-complete Tiny Woods command plan from authenticated graphs.

The two input graphs are immutable ROM evidence.  This tool does not infer or
flatten control flow: it preserves every declared script array, command address,
operand and French multilingual association for the PMDO implementation layer.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any, Iterator

ROOT = Path(__file__).resolve().parents[1]
SCENE = ROOT / "docs/pmdred_eu/playable/tiny_woods/eu_scene_graph.json"
POST = ROOT / "docs/pmdred_eu/playable/tiny_woods/post_route/eu_post_route_graph.json"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"

# Names come from pret/pmd-red's data_script.h technical structure. Unknown
# opcodes deliberately remain named by byte rather than acquiring invented
# semantics. Every operand remains the EU-ROM-authenticated value either way.
OP_NAMES = {
    0x02: "NEXT_DUNGEON", 0x08: "SELECT_MAP", 0x0C: "SELECT_ENTITIES",
    0x0D: "SELECT_LIVES", 0x1E: "EXECUTE_SUBSTATION",
    0x22: "CMD_UNK_22", 0x23: "CMD_UNK_23", 0x25: "CMD_UNK_25",
    0x26: "CMD_UNK_26", 0x2D: "CMD_UNK_2D", 0x2E: "PORTRAIT",
    0x30: "TEXTBOX_CLEAR", 0x33: "MSG_QUIET", 0x34: "MSG_NPC",
    0x39: "MSG_ON_BG_AUTO", 0x3B: "CONDITIONAL_SPECIAL_TEXT",
    0x3C: "SPECIAL_TEXT", 0x3D: "RENAME_ALLY", 0x3E: "RENAME_TEAM",
    0x44: "BGM_SWITCH", 0x45: "BGM_FADEIN", 0x47: "BGM_STOP",
    0x48: "BGM_FADEOUT", 0x4C: "FANFARE_PLAY2", 0x4D: "FANFARE_STOP2",
    0x54: "SELECT_ANIMATION", 0x56: "CMD_UNK_56", 0x62: "CMD_UNK_62",
    0x6A: "WALK_RELATIVE", 0x6B: "WALK_GRID", 0x8B: "SET_DIR_WAIT",
    0x91: "ROTATE_TO", 0x95: "CMD_UNK_95", 0x98: "CAMERA_INIT_PAN",
    0x99: "CAMERA_END_PAN", 0xA9: "SCENARIO_CALC",
    0xB0: "SET_RESCUE_CONQUERED", 0xC0: "CJUMP_VAR", 0xCC: "COND_EQUAL",
    0xCF: "MSG_VAR", 0xD0: "VARIANT", 0xD1: "VARIANT_DEFAULT",
    0xD8: "ASK3_VAR", 0xD9: "CHOICE", 0xDA: "CMD_UNK_DA",
    0xDB: "WAIT", 0xDD: "STOP_ANIMATION_ON_CURRENT_FRAME",
    0xDE: "CMD_UNK_DE", 0xDF: "CMD_UNK_DF", 0xE2: "WAIT_FANFARE2",
    0xE3: "AWAIT_CUE", 0xE4: "ALERT_CUE", 0xE5: "CMD_UNK_E5",
    0xE7: "JUMP_LABEL", 0xE8: "CALL_SCRIPT", 0xE9: "JUMP_SCRIPT",
    0xEF: "RET", 0xF0: "HALT", 0xF1: "END_DELETE", 0xF2: "CMD_F2",
    0xF4: "LABEL",
}

HANDLERS = {
    0x02: "route.next_dungeon", 0x08: "route.select_map",
    0x0C: "entities.select_all", 0x0D: "entities.select_lives",
    0x1E: "flow.execute_substation", 0x2D: "portrait.configure",
    0x2E: "portrait.set", 0x30: "dialogue.clear", 0x33: "dialogue.quiet",
    0x34: "dialogue.actor", 0x39: "dialogue.narration",
    0x3B: "choice.conditional", 0x3C: "choice.special",
    0x3D: "naming.partner", 0x3E: "naming.team", 0x44: "audio.bgm_switch",
    0x45: "audio.bgm_fadein", 0x47: "audio.bgm_stop",
    0x48: "audio.bgm_fadeout", 0x4C: "audio.cue_play",
    0x4D: "audio.cue_stop", 0x54: "actor.animation", 0x56: "actor.animation",
    0x62: "actor.motion", 0x6A: "actor.walk_relative", 0x6B: "actor.walk_grid",
    0x8B: "actor.face_wait", 0x91: "actor.rotate", 0x95: "actor.rotate",
    0x98: "camera.begin", 0x99: "camera.end", 0xA9: "progress.scenario_calc",
    0xB0: "progress.rescue_conquered", 0xC0: "flow.computed_jump",
    0xCC: "flow.condition", 0xCF: "dialogue.variable", 0xD0: "dialogue.variant",
    0xD1: "dialogue.variant_default", 0xD8: "choice.ask_variable",
    0xD9: "choice.option", 0xDA: "choice.commit", 0xDB: "timing.wait",
    0xDD: "actor.animation_hold", 0xDE: "actor.state", 0xDF: "actor.state",
    0xE2: "audio.cue_wait", 0xE3: "sync.await", 0xE4: "sync.alert",
    0xE5: "flow.branch_unlock", 0xE7: "flow.jump_label",
    0xE8: "flow.call_script", 0xE9: "flow.jump_script", 0xEF: "flow.return",
    0xF0: "flow.halt", 0xF1: "flow.end_delete", 0xF2: "flow.noop",
    0xF4: "flow.label",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def walk(value: Any, path: tuple[str, ...] = ()) -> Iterator[tuple[tuple[str, ...], dict[str, Any]]]:
    if isinstance(value, dict):
        yield path, value
        for key, child in value.items():
            yield from walk(child, path + (str(key),))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk(child, path + (str(index),))


def text_lookup(graph: dict[str, Any]) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for _, node in walk(graph):
        languages = node.get("languages")
        if not isinstance(languages, dict) or "en" not in languages or "fr" not in languages:
            continue
        english_address = languages["en"].get("address")
        if english_address:
            if english_address in result and result[english_address] != node:
                raise RuntimeError(f"conflicting multilingual block at {english_address}")
            result[english_address] = node
    return result


def arrays(graph: dict[str, Any], graph_id: str) -> list[dict[str, Any]]:
    lookup = text_lookup(graph)
    result = []
    for path, node in walk(graph):
        commands = node.get("commands")
        if not isinstance(commands, list):
            continue
        identity = node.get("array_name") or node.get("name") or node.get("id")
        if identity is None:
            identity = "/".join(path)
        rows = []
        for command in commands:
            op = command["op"]
            if op not in OP_NAMES:
                raise RuntimeError(f"unclassified opcode 0x{op:02X}")
            row = {
                "index": command["index"], "address": command["address"],
                "op": op, "op_hex": command["op_hex"], "op_name": OP_NAMES[op],
                "arg_byte": command["arg_byte"], "arg_short": command["arg_short"],
                "arg1": command["arg1"], "arg2": command["arg2"],
                "pointer": command["pointer"], "pret_source_index": command.get("pret_source_index"),
                "categories": command.get("categories", []),
                "pmdo_handler": HANDLERS.get(op, "actor.control_unknown"),
            }
            pointer = command.get("text_block")
            if pointer:
                block = lookup.get(pointer)
                if block is None:
                    raise RuntimeError(f"{command['address']}: no multilingual block for {pointer}")
                french = block["languages"]["fr"]
                row["french"] = {
                    "block_address": block.get("address", block["languages"]["en"]["address"]),
                    "address": french["address"], "raw_hex": french["raw_hex"],
                    "text": french["text"],
                }
            rows.append(row)
        result.append({
            "graph": graph_id, "source_path": "/".join(path),
            "array_id": f"{graph_id}:{identity}", "declared_count": len(commands),
            "commands": rows,
        })
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite {output}")
    scene = json.loads(SCENE.read_text(encoding="utf-8"))
    post = json.loads(POST.read_text(encoding="utf-8"))
    all_arrays = arrays(scene, "tiny_woods_scene") + arrays(post, "post_route")
    commands = [command for array in all_arrays for command in array["commands"]]
    addresses = [command["address"] for command in commands]
    text_rows = [command for command in commands if "french" in command]
    if len(all_arrays) != 27 or len(commands) != 975 or len(set(addresses)) != 975:
        raise RuntimeError("authenticated boundary gate differs from 27 arrays / 975 unique commands")
    if len(text_rows) != 195:
        raise RuntimeError(f"expected 195 French command associations, got {len(text_rows)}")
    opcodes = sorted({command["op"] for command in commands})
    if len(opcodes) != 61:
        raise RuntimeError(f"expected 61 opcodes, got {len(opcodes)}")
    plan = {
        "schema_version": 1,
        "authority": {"kind": "PMD Red Rescue Team EU ROM", "rom_sha256": ROM_SHA256},
        "sources": [
            {"path": str(SCENE.relative_to(ROOT)), "sha256": sha256(SCENE)},
            {"path": str(POST.relative_to(ROOT)), "sha256": sha256(POST)},
        ],
        "method": {
            "control_flow": "array boundaries and operands preserved; no branch flattening",
            "text": "command pointer matched to languages.en.address; official languages.fr bytes selected",
            "technical_names": "pret/pmd-red data_script.h structural reference only",
        },
        "totals": {"arrays": 27, "commands": 975, "unique_addresses": 975,
                   "opcodes": 61, "french_text_associations": 195},
        "opcode_inventory": [
            {"op": op, "op_hex": f"0x{op:02X}", "op_name": OP_NAMES[op],
             "pmdo_handler": HANDLERS.get(op, "actor.control_unknown"),
             "count": sum(command["op"] == op for command in commands)}
            for op in opcodes
        ],
        "arrays": all_arrays,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(plan, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"PMDRED_TINY_WOODS_COMMAND_PLAN_PASS arrays=27 commands=975 opcodes=61 french=195 output={output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
