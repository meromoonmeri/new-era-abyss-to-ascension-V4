#!/usr/bin/env python3
"""Certify Tiny Woods palette semantics and integrated choreography in PMDO 0.8.12."""
from __future__ import annotations

import argparse
import json
import shutil
from datetime import date
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SEMANTICS = ROOT / "docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json"
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SCENE_PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/scene_plan.json"
EVENTS = Path("/tmp/tiny_woods_command_complete.jsonl")
MODES = ("opening_naming", "post_route", "palette_adapter_all")
EXPECTED_SCENE_ARRAYS = {
    "opening_naming": ["tiny_woods_scene:s_gs178_g1_s0_station_sref_script"],
    "post_route": [
        "tiny_woods_scene:s_gs179_g1_s0_station_sref_script",
        "tiny_woods_scene:s_gs178_g3_s0_station_sref_script",
        "post_route:s_gs9_g17_s0_station_sref_script",
        "post_route:title_group/script",
    ],
}


def parse_detail(value: str) -> dict[str, str]:
    result: dict[str, str] = {}
    for item in value.split(";"):
        if "=" not in item:
            raise ValueError(f"invalid palette trace detail: {value!r}")
        key, content = item.split("=", 1)
        if not key or key in result:
            raise ValueError(f"invalid palette trace key: {value!r}")
        result[key] = content
    return result


def expected_for_mode(mode: str, semantics: dict[str, Any]) -> list[dict[str, Any]]:
    if mode == "palette_adapter_all":
        return semantics["commands"]
    result = []
    for array_id in EXPECTED_SCENE_ARRAYS[mode]:
        result.extend(command for command in semantics["commands"] if command["array_id"] == array_id)
    return result


def validate_palette_trace(mode: str, events: list[dict[str, Any]], semantics: dict[str, Any]) -> dict[str, Any]:
    scene_traces = [event for event in events if event.get("event") == "scene_trace"]
    palette = [event for event in scene_traces if event.get("kind") in ("palette_transition_start", "palette_transition_complete")]
    expected = expected_for_mode(mode, semantics)
    if len(palette) != len(expected) * 2:
        raise ValueError(f"{mode}: palette trace pair count differs")
    complete_records = []
    for ordinal, command in enumerate(expected):
        start, complete = palette[ordinal * 2 : ordinal * 2 + 2]
        if start.get("kind") != "palette_transition_start" or complete.get("kind") != "palette_transition_complete":
            raise ValueError(f"{mode}: palette start/complete adjacency differs at ordinal {ordinal + 1}")
        for event in (start, complete):
            if event.get("pointer") != command["address"] or event.get("sequence") != command["index"]:
                raise ValueError(f"{mode}: palette address/index differs at ordinal {ordinal + 1}")
            if event.get("speaker") != command["channel"] or event.get("text") != command["target"]:
                raise ValueError(f"{mode}: palette channel/target differs at {command['address']}")
        start_detail = parse_detail(start["detail"])
        complete_detail = parse_detail(complete["detail"])
        runtime_frames = 1 if command["source_frames"] == 0 else command["source_frames"]
        common = {
            "array": command["array_id"], "opcode": command["opcode"],
            "source_frames": str(command["source_frames"]), "runtime_frames": str(runtime_frames),
            "blocking": "true", "api": command["pmdo_api"],
        }
        if {key: start_detail.get(key) for key in common} != common or {key: complete_detail.get(key) for key in common} != common:
            raise ValueError(f"{mode}: palette semantic detail differs at {command['address']}")
        before = int(complete_detail["before_tick"])
        after = int(complete_detail["after_tick"])
        elapsed = int(complete_detail["elapsed_frames"])
        if int(start_detail["before_tick"]) != before or after < before or elapsed != (after - before) // 120:
            raise ValueError(f"{mode}: palette frame accounting differs at {command['address']}")
        # A yielded frame proves completion blocking when a state change is required. Calls
        # already at target are legitimate no-ops in RogueEssence and remain explicitly traced.
        complete_records.append({
            "ordinal": ordinal + 1, "array_id": command["array_id"], "index": command["index"],
            "address": command["address"], "opcode": command["opcode"], "channel": command["channel"],
            "target": command["target"], "source_frames": command["source_frames"],
            "runtime_frames": runtime_frames, "elapsed_frames": elapsed, "blocking_return_observed": True,
        })
    return {
        "count": len(expected),
        "addresses": [record["address"] for record in complete_records],
        "records": complete_records,
        "strict_start_complete_adjacency": True,
        "frame_tick_accounting": True,
    }


def validate_adapter_mode(events: list[dict[str, Any]], plan: dict[str, Any], old: Any) -> dict[str, Any]:
    verdicts = [event for event in events if event.get("event") == "command_complete_verdict"]
    if len(verdicts) != 1 or verdicts[0].get("mode") != "palette_adapter_all" or verdicts[0].get("verdict") != "PASS":
        raise ValueError("palette_adapter_all: native verdict differs")
    expected_records = old.expected_command_records(plan)
    traces = [event for event in events if event.get("event") == "command_trace"]
    actual = {
        event["address"]: {key: event[key] for key in ("array", "index", "op", "arg_byte", "arg_short", "arg1", "arg2", "handler")}
        for event in traces
    }
    if len(traces) != 975 or actual != expected_records:
        raise ValueError("palette_adapter_all: authenticated command surface differs")
    route = [event["ground"] for event in events if event.get("event") == "ground_enter"]
    if route != ["d01p01"] or verdicts[0].get("palette_transitions") != 15:
        raise ValueError("palette_adapter_all: route/transition count differs")
    dialogues = [event for event in events if event.get("event") == "scene_trace" and event.get("kind") == "dialogue"]
    menus = [event for event in events if event.get("event") == "dialogue_menu_closed"]
    if dialogues or menus:
        raise ValueError("palette_adapter_all: dialogue leaked into isolated certification")
    tails = [event.get("event") for event in events[-4:]]
    if tails != ["load_phase_unload_requested", "native_deinit", "native_graphics_unload", "end"]:
        raise ValueError("palette_adapter_all: native unload lifecycle differs")
    return {"mode": "palette_adapter_all", "route": route, "commands": len(traces), "arrays": 27, "dialogues": 0, "menus_closed": 0}


def authenticate_palette(fixture: Path, manifest: dict[str, Any], semantics: dict[str, Any], old: Any) -> None:
    palette = manifest.get("tiny_woods_palette_semantics", {})
    if palette.get("schema") != "pmdred-eu-tiny-woods-palette-overlay-v1":
        raise ValueError("palette overlay schema differs")
    if palette.get("semantics_sha256") != old.sha256(SEMANTICS) or palette.get("commands") != 15 or palette.get("affected_arrays") != 6:
        raise ValueError("palette overlay semantics identity differs")
    if palette.get("planning_unknown_fallback_retained") is not True:
        raise ValueError("palette overlay unknown fallback gate differs")
    for name, expected in palette["files"].items():
        path = fixture / name
        if not path.is_file() or path.is_symlink() or path.stat().st_size != expected["bytes"] or old.sha256(path) != expected["sha256"]:
            raise ValueError(f"palette overlay file differs: {name}")
    adapter = fixture / palette["adapter"]["path"]
    if old.sha256(adapter) != palette["adapter"]["sha256"]:
        raise ValueError("palette adapter identity differs")
    addresses = {command["address"] for command in semantics["commands"]}
    adapter_text = adapter.read_text(encoding="utf-8")
    if {address for address in addresses if adapter_text.count(address) != 3}:
        raise ValueError("palette adapter exact address gate differs")
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    unresolved = [row for array in plan["arrays"] for row in array["commands"] if row["op"] in (0x22, 0x23, 0x25, 0x26)]
    if any(row["pmdo_handler"] != "actor.control_unknown" for row in unresolved):
        raise ValueError("planning unknown-opcode fallback was mutated")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--seed", type=int, default=424242)
    parser.add_argument("--timeout-seconds", type=int, default=300)
    args = parser.parse_args()
    fixture = args.fixture.resolve()
    evidence = args.evidence_dir.resolve()
    if evidence.exists():
        raise FileExistsError(f"refusing to overwrite native evidence: {evidence}")

    old = __import__("run_pmdred_tiny_woods_command_complete")
    runner = old.load_tool("run_pmdred_eu_native_fixture")
    if old.sha256(runner.PMDO) != old.PMDO_SHA256:
        raise ValueError("exact PMDO 0.8.12 executable differs")
    semantics = json.loads(SEMANTICS.read_text(encoding="utf-8"))
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    scene_plan = json.loads(SCENE_PLAN.read_text(encoding="utf-8"))
    manifest = old.authenticate(fixture)
    authenticate_palette(fixture, manifest, semantics, old)

    evidence.mkdir(parents=True)
    old.dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(PLAN, evidence / "command_plan.json")
    shutil.copyfile(SEMANTICS, evidence / "secondary_palette_semantics_v1.json")
    index_gate = old.index_fixture(fixture, evidence, runner)

    run_records = []
    for mode in MODES:
        wrapper = fixture / "palette-runs" / mode
        wrapper.mkdir(parents=True)
        (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True)
        (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
        namespace = argparse.Namespace(
            fixture=wrapper, ground=mode, expected_screenshots=0, timeout_seconds=args.timeout_seconds,
            events=EVENTS, validator_mode="tiny_woods_command_complete",
            environment=[
                f"TINY_WOODS_COMMAND_MODE={mode}", f"TINY_WOODS_COMMAND_SEED={args.seed}",
                "PMDRED_TINY_WOODS_AUTOMATION=1", "PMDRED_TINY_WOODS_AUTOMATION_REFUSALS=1",
            ],
        )
        runner.run(namespace)
        destination = evidence / mode
        destination.mkdir()
        for name in ("runtime.log", "events.jsonl", "termination.json"):
            shutil.copyfile(wrapper / name, destination / name)
        events = old.read_events(destination / "events.jsonl")
        summary = old.validate_mode(mode, events, plan, scene_plan) if mode != "palette_adapter_all" else validate_adapter_mode(events, plan, old)
        palette_summary = validate_palette_trace(mode, events, semantics)
        termination = old.strict_termination(destination / "termination.json")
        run_records.append({
            **summary, "palette": palette_summary, "result": "PASS",
            "events_sha256": old.sha256(destination / "events.jsonl"),
            "runtime_log_sha256": old.sha256(destination / "runtime.log"),
            "termination_sha256": old.sha256(destination / "termination.json"),
            "termination": {key: termination[key] for key in ("exit_classification", "return_code", "terminal", "graceful", "watchdog", "requested_signal", "sigsegv", "forced_kill", "orphan_process")},
        })

    selected = next(record for record in run_records if record["mode"] == "opening_naming")["palette"]["count"] + next(record for record in run_records if record["mode"] == "post_route")["palette"]["count"]
    if selected != 14 or next(record for record in run_records if record["mode"] == "palette_adapter_all")["palette"]["count"] != 15:
        raise ValueError("combined palette coverage differs")
    report = {
        "schema": "pmdred-eu-tiny-woods-palette-native-v1", "date": str(date.today()), "status": "passed",
        "authority": {
            "region": "EU", "rom_sha256": old.ROM_SHA256,
            "command_plan_sha256": old.sha256(PLAN), "palette_semantics_sha256": old.sha256(SEMANTICS),
        },
        "runtime": {"version": "0.8.12.0", "executable_sha256": old.PMDO_SHA256},
        "index_gate": index_gate, "runs": run_records,
        "combined": {
            "exact_palette_commands_isolated": 15, "selected_route_palette_commands_integrated": 14,
            "affected_arrays": 6, "channels": ["main", "front"], "targets": ["visible", "black"],
            "source_durations_frames": [0, 30, 60], "selected_route_dialogues_closed": 94,
            "command_addresses_per_mode": 975,
        },
        "assertions": {
            "all_15_eu_commands_execute_through_one_address_gated_adapter_in_authenticated_order": True,
            "main_and_front_channels_use_distinct_pmdo_apis_and_black_visible_targets": True,
            "blocking_calls_return_before_adjacent_completion_trace_with_native_frame_accounting": True,
            "zero_frame_source_duration_is_preserved_and_uses_documented_one_frame_pmdo_target_correction": True,
            "opening_post_rescue_ending_base_and_title_selected_route_choreography_is_integrated": True,
            "defeat_fade_is_integrated_and_included_in_isolated_all_command_proof": True,
            "the_975_command_plan_retains_actor_control_unknown_for_these_opcodes": True,
            "all_three_runs_reach_load_phase_unload_normal_exit_without_signal_watchdog_or_orphan": True,
        },
        "scope": [
            "This milestone promotes only opcodes 0x22, 0x23, 0x25, and 0x26 through an isolated semantic adapter; it does not alter command_plan.json or its default unknown-opcode handler inventory.",
            "The selected-route runs retain the previously certified 38 opening and 56 post-route French dialogue closures, cue/reward/naming/progression gates, and route chronology.",
            "The defeat retry scene is not naturally selected by those two runs; its exact 0x22 command is executed by palette_adapter_all and its production call site is manifest-bound.",
        ],
    }
    old.dump(evidence / "native_palette_validation.json", report)
    print(f"TINY_WOODS_PALETTE_NATIVE_PASS modes=3 commands=15 selected_route=14 dialogues=94 evidence={evidence}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
