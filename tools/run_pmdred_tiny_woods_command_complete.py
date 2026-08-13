#!/usr/bin/env python3
"""Strictly certify the two-mode command-complete Tiny Woods production overlay."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import shutil
import signal
import subprocess
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SCENE_PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/scene_plan.json"
EVENTS = Path("/tmp/tiny_woods_command_complete.jsonl")
MODES = ("opening_naming", "post_route")
ROUTES = {"opening_naming": ["d01p01"], "post_route": ["d01p02", "d01p01", "b01p00a", "s02_fre"]}
SCENES = {"opening_naming": ["d01p01_g1"], "post_route": ["d01p02_g1", "d01p01_g3", "b01p00a_g16", "s02_fre_g2"]}
CUES = {
    "opening_naming": {450, 463, 465, 466, 468, 469, 470, 482},
    "post_route": {450, 455, 457, 465, 468, 469, 470, 473},
}
BASE_ARRAY = "post_route:s_gs9_g17_s0_lives0_dlg0"
STATION_ARRAY = "post_route:s_gs9_g17_s0_station_sref_script"
BASE_PATH = [6, 24, 26, 27, 30, 32, 33, 36, 43, 46, 61, 68, 69, 70, 71, 72, 73, 74, 92, 105, 110, 114, 127, 128, 137, 138, 154, 158]
STATION_PATH = [13, 14, 15]


def load_tool(name: str) -> ModuleType:
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dump(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def read_events(path: Path) -> list[dict[str, Any]]:
    result = []
    for line_number, line in enumerate(path.read_text().splitlines(), 1):
        try:
            item = json.loads(line)
        except json.JSONDecodeError as exc:
            raise ValueError(f"invalid validator JSON at {path}:{line_number}") from exc
        if not isinstance(item, dict):
            raise ValueError(f"non-object validator JSON at {path}:{line_number}")
        result.append(item)
    return result


def index_fixture(fixture: Path, evidence: Path, runner: ModuleType) -> dict[str, Any]:
    command = [str(runner.PMDO), "-asset", str(fixture / "asset") + "/", "-appdata", str(fixture / "appdata") + "/", "-quest", "pmdred_eu_fixture", "-index", "zone"]
    log = evidence / "index.log"
    with log.open("wb") as stream:
        process = subprocess.Popen(command, cwd=ROOT, env=runner.pmdo_env("tiny_woods_command_complete_index_only"), stdout=stream, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            return_code = process.wait(timeout=60)
            timed_out = False
        except subprocess.TimeoutExpired:
            timed_out = True
            os.killpg(process.pid, signal.SIGTERM)
            try:
                return_code = process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                return_code = process.wait()
    index = fixture / "quest/Data/Zone/index.idx"
    result = {
        "status": "passed" if return_code == 0 and not timed_out and index.is_file() else "failed",
        "return_code": return_code,
        "timed_out": timed_out,
        "index_sha256": sha256(index) if index.is_file() else None,
        "log_sha256": sha256(log),
    }
    dump(evidence / "index_validation.json", result)
    if result["status"] != "passed":
        raise RuntimeError("command-complete fixture zone index failed")
    return result


def authenticate(fixture: Path) -> dict[str, Any]:
    manifest_path = fixture / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text())
    complete = manifest.get("tiny_woods_command_complete", {})
    if complete.get("schema") != "pmdred-eu-tiny-woods-command-complete-overlay-v1":
        raise ValueError("command-complete fixture schema differs")
    authority = complete.get("authority", {})
    if authority.get("region") != "EU" or authority.get("rom_sha256") != ROM_SHA256 or authority.get("command_plan_sha256") != sha256(PLAN):
        raise ValueError("command-complete EU authority differs")
    if complete.get("command_surface") != {"arrays": 27, "commands": 975, "unique_addresses": 975, "opcodes": 61, "french_text_associations": 195}:
        raise ValueError("command-complete aggregate gate differs")
    if complete.get("fixture_isolation") != {"script_private": True, "music_private": True, "sound_private": True, "promoted_grounds_read_only_bound": True}:
        raise ValueError("command-complete fixture isolation differs")
    for group in ("files", "music", "cues"):
        for name, expected in complete[group].items():
            path = fixture / name
            if not path.is_file() or path.is_symlink() or path.stat().st_size != expected["bytes"] or sha256(path) != expected["sha256"]:
                raise ValueError(f"command-complete fixture file differs: {name}")
    source = ROOT / complete["validator"]["source"]
    installed = fixture / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    if sha256(source) != complete["validator"]["source_sha256"] or sha256(installed) != complete["validator"]["fixture_sha256"]:
        raise ValueError("command-complete validator identity differs")
    if "@@LAUNCHER_GROUND_INDEX@@" in installed.read_text() or "GAME:EnterZone('master_zone',-1,308,0)" not in installed.read_text():
        raise ValueError("private launcher Ground index substitution differs")
    zone = json.loads((fixture / "quest/Data/Zone/master_zone.json").read_text(encoding="utf-8-sig"))["Object"]["GroundMaps"]
    if {name: zone.index(name) for name in ("b01p00a", "d01p01", "s02_fre")} != {"b01p00a": 141, "d01p01": 308, "s02_fre": 329}:
        raise ValueError("master-zone Ground indexes differ")
    return manifest


def strict_termination(path: Path) -> dict[str, Any]:
    record = json.loads(path.read_text())
    required = (
        record.get("result") == "PASS",
        record.get("exit_classification") == "NORMAL_EXIT",
        record.get("return_code") == 0,
        record.get("terminal") is True,
        record.get("graceful") is True,
        record.get("watchdog") is False,
        record.get("requested_signal") is None,
        record.get("sigsegv") is False,
        record.get("forced_kill") is False,
        record.get("orphan_process") is False,
        record.get("event_parse_error") is None,
        record.get("load_phase_unload", {}).get("pass") is True,
    )
    if not all(required):
        raise ValueError(f"strict native termination differs: {path}")
    return record


def expected_command_records(plan: dict[str, Any]) -> dict[str, dict[str, Any]]:
    result = {}
    for array in plan["arrays"]:
        for command in array["commands"]:
            result[command["address"]] = {
                "array": array["array_id"], "index": command["index"], "op": command["op"],
                "arg_byte": command["arg_byte"], "arg_short": command["arg_short"],
                "arg1": command["arg1"], "arg2": command["arg2"], "handler": command["pmdo_handler"],
            }
    return result


def plan_pointers(plan: dict[str, Any], array_id: str, indices: list[int]) -> list[str]:
    array = next(value for value in plan["arrays"] if value["array_id"] == array_id)
    rows = {row["index"]: row for row in array["commands"]}
    return [rows[index]["address"] for index in indices]


def validate_mode(mode: str, events: list[dict[str, Any]], plan: dict[str, Any], scene_plan: dict[str, Any]) -> dict[str, Any]:
    verdicts = [event for event in events if event.get("event") == "command_complete_verdict"]
    if len(verdicts) != 1 or verdicts[0].get("mode") != mode or verdicts[0].get("verdict") != "PASS":
        raise ValueError(f"{mode}: command-complete verdict differs")
    expected_records = expected_command_records(plan)
    traces = [event for event in events if event.get("event") == "command_trace"]
    if len(traces) != 975 or len({event.get("address") for event in traces}) != 975:
        raise ValueError(f"{mode}: exact command-address execution coverage differs")
    actual_records = {
        event["address"]: {key: event[key] for key in ("array", "index", "op", "arg_byte", "arg_short", "arg1", "arg2", "handler")}
        for event in traces
    }
    if actual_records != expected_records:
        raise ValueError(f"{mode}: command operands/handlers differ from authenticated plan")
    if len({record["array"] for record in actual_records.values()}) != 27:
        raise ValueError(f"{mode}: command-array coverage differs")

    scene_traces = [event for event in events if event.get("event") == "scene_trace"]
    starts = [event["scene"] for event in scene_traces if event.get("kind") == "scene_start"]
    completes = [event["scene"] for event in scene_traces if event.get("kind") == "scene_complete"]
    if starts != SCENES[mode] or completes != SCENES[mode]:
        raise ValueError(f"{mode}: scene chronology differs")
    route = [event["ground"] for event in events if event.get("event") == "ground_enter"]
    if route != ROUTES[mode] or verdicts[0].get("route") != ">".join(route):
        raise ValueError(f"{mode}: Ground route differs")
    dialogues = [event for event in scene_traces if event.get("kind") == "dialogue"]
    expected_dialogue_pointers = [row["pointer"] for scene in SCENES[mode] if scene in scene_plan["scenes"] for row in scene_plan["scenes"][scene]["dialogue"]]
    if mode == "post_route":
        expected_dialogue_pointers += plan_pointers(plan, BASE_ARRAY, BASE_PATH) + plan_pointers(plan, STATION_ARRAY, STATION_PATH)
    if [event.get("pointer") for event in dialogues] != expected_dialogue_pointers:
        raise ValueError(f"{mode}: selected authenticated French pointer order differs")
    expected_count = 38 if mode == "opening_naming" else 56
    menus = [event for event in events if event.get("event") == "dialogue_menu_closed"]
    if len(dialogues) != expected_count or len(menus) != expected_count or verdicts[0].get("dialogues") != expected_count or verdicts[0].get("menus_closed") != expected_count:
        raise ValueError(f"{mode}: native French dialogue/menu closure count differs")

    cue_ids = {int(event["detail"]) for event in scene_traces if event.get("kind") == "audio_cue"}
    if cue_ids != CUES[mode] or verdicts[0].get("cues") != len(CUES[mode]):
        raise ValueError(f"{mode}: authenticated cue coverage differs")
    if mode == "opening_naming":
        naming = [event for event in scene_traces if event.get("kind") == "naming_hero"]
        if len(naming) != 1 or not naming[0].get("text") or naming[0].get("sequence") != 23 or verdicts[0].get("hero_naming_after_dialogues") != 23:
            raise ValueError("opening_naming: native hero naming placement differs")
        if any(event.get("kind") in ("reward", "naming_team", "progression") for event in scene_traces):
            raise ValueError("opening_naming: post-route state leaked into isolated opening")
    else:
        naming = [event for event in scene_traces if event.get("kind") == "naming_team"]
        rewards = [event.get("detail") for event in scene_traces if event.get("kind") == "reward"]
        safe = [event.get("detail") for event in scene_traces if event.get("kind") == "safe_marker"]
        progression = [event for event in scene_traces if event.get("kind") == "progression"]
        if len(naming) != 1 or not naming[0].get("text") or rewards != ["berry_oran", "berry_pecha", "berry_rawst"]:
            raise ValueError("post_route: native naming/reward execution differs")
        if safe != ["cell=34,34;pixel=272,272", "cell=18,27;pixel=144,216"]:
            raise ValueError("post_route: safe staging markers differ")
        if len(progression) != 1 or progression[0].get("detail") != "SCENARIO_MAIN=3,0;EVENT_DIVIDE":
            raise ValueError("post_route: progression trace differs")
        if verdicts[0].get("tiny_woods_unlock") != "Completed: 2" or verdicts[0].get("scenario_main") != 3 or verdicts[0].get("scenario_level") != 0 or verdicts[0].get("event_division") != "EVENT_DIVIDE":
            raise ValueError("post_route: persistent completion state differs")

    tails = [event.get("event") for event in events[-4:]]
    if tails != ["load_phase_unload_requested", "native_deinit", "native_graphics_unload", "end"]:
        raise ValueError(f"{mode}: native unload lifecycle differs")
    if events[-1].get("terminal") is not True or events[-1].get("graceful") is not True or events[-1].get("load_phase") != "Unload":
        raise ValueError(f"{mode}: terminal event differs")
    return {
        "mode": mode, "route": route, "scenes": SCENES[mode], "commands": len(traces), "arrays": 27,
        "dialogues": len(dialogues), "menus_closed": len(menus), "cue_ids": sorted(cue_ids), "verdict": verdicts[0],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--seed", type=int, default=424242)
    parser.add_argument("--timeout-seconds", type=int, default=240)
    args = parser.parse_args()
    fixture = args.fixture.resolve()
    evidence = args.evidence_dir.resolve()
    if evidence.exists():
        raise FileExistsError(f"refusing to overwrite native evidence: {evidence}")
    runner = load_tool("run_pmdred_eu_native_fixture")
    if sha256(runner.PMDO) != PMDO_SHA256:
        raise ValueError("exact PMDO 0.8.12 executable differs")
    manifest = authenticate(fixture)
    plan = json.loads(PLAN.read_text())
    scene_plan = json.loads(SCENE_PLAN.read_text())
    evidence.mkdir(parents=True)
    dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(PLAN, evidence / "command_plan.json")
    index_gate = index_fixture(fixture, evidence, runner)

    run_records = []
    for mode in MODES:
        wrapper = fixture / "command-complete-runs" / mode
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
        events = read_events(destination / "events.jsonl")
        summary = validate_mode(mode, events, plan, scene_plan)
        termination = strict_termination(destination / "termination.json")
        run_records.append({
            **summary, "result": "PASS", "events_sha256": sha256(destination / "events.jsonl"),
            "runtime_log_sha256": sha256(destination / "runtime.log"), "termination_sha256": sha256(destination / "termination.json"),
            "termination": {key: termination[key] for key in ("exit_classification", "return_code", "terminal", "graceful", "watchdog", "requested_signal", "sigsegv", "forced_kill", "orphan_process")},
        })

    combined_cues = set().union(*(set(record["cue_ids"]) for record in run_records))
    if combined_cues != {450, 455, 457, 463, 465, 466, 468, 469, 470, 473, 482}:
        raise ValueError("combined authenticated eleven-cue coverage differs")
    complete = manifest["tiny_woods_command_complete"]
    if {record["song_index"] for record in complete["music"].values()} != {1, 10, 46, 101, 103, 114}:
        raise ValueError("authenticated six-BGM installation differs")
    report = {
        "schema": "pmdred-eu-tiny-woods-command-complete-native-v1", "date": str(date.today()), "status": "passed",
        "authority": {"region": "EU", "rom_sha256": ROM_SHA256, "command_plan_sha256": sha256(PLAN)},
        "runtime": {"version": "0.8.12.0", "executable_sha256": PMDO_SHA256}, "index_gate": index_gate,
        "runs": run_records,
        "combined": {"unique_command_addresses_per_mode": 975, "arrays_per_mode": 27, "opcodes": 61, "french_associations_preserved": 195, "selected_route_dialogues_closed": 94, "cue_ids": sorted(combined_cues), "bgm_ids": [1, 10, 46, 101, 103, 114]},
        "assertions": {
            "all_authenticated_command_records_loaded_with_exact_operands_and_handlers_in_each_isolated_mode": True,
            "hero_naming_occurs_natively_immediately_after_opening_row_23": True,
            "corrected_post_g3_route_crosses_tiny_woods_and_master_zone_in_canonical_order": True,
            "one_refusal_then_acceptance_and_native_team_naming_execute": True,
            "three_authenticated_rewards_and_tiny_woods_completion_persist": True,
            "six_authenticated_bgm_and_eleven_authenticated_cues_are_installed_and_covered": True,
            "all_94_selected_french_dialogues_open_and_close_native_menus": True,
            "both_processes_reach_load_phase_unload_normal_exit_without_signal_watchdog_or_orphan": True,
        },
        "branch_scope": [
            "The native proof selects the authenticated D1/default grammatical branch used by the existing scene plan.",
            "The refusal loop executes once before acceptance; all 27 command arrays and 195 French associations remain preserved in command_plan.json.",
            "The opening and corrected post-route are isolated because post-route entry at d01p02 cannot faithfully re-execute opening hero naming.",
        ],
    }
    dump(evidence / "native_command_complete_validation.json", report)
    print(f"TINY_WOODS_COMMAND_COMPLETE_NATIVE_PASS modes=2 commands_per_mode=975 dialogues=94 cues=11 evidence={evidence}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
