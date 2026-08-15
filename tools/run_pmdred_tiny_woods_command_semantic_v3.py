#!/usr/bin/env python3
"""Run and validate the Tiny Woods semantic supplement on exact PMDO 0.8.12."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import shutil
from datetime import datetime
from pathlib import Path
from types import ModuleType
from typing import Any
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SUPPLEMENT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json"
EVENTS = Path("/tmp/tiny_woods_command_semantic_v3.jsonl")
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
MODES = ("semantic_selected_v3", "semantic_all_v3")
EXPECTATIONS = {
    "semantic_selected_v3": {"commands": 251, "waits": 92, "frames": 2690},
    "semantic_all_v3": {"commands": 304, "waits": 108, "frames": 3001},
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_tool(name: str) -> ModuleType:
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def dump(path: Path, value: Any) -> None:
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def read_events(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def authenticate(fixture: Path, *, allow_fault: bool = False) -> tuple[dict[str, Any], dict[str, Any]]:
    old = load_tool("run_pmdred_tiny_woods_command_complete")
    manifest = old.authenticate(fixture)
    semantic = manifest.get("tiny_woods_command_semantic_v3", {})
    if semantic.get("schema") != "pmdred-eu-tiny-woods-command-semantic-overlay-v3":
        raise ValueError("semantic fixture schema differs")
    authority = semantic.get("authority", {})
    supplement = json.loads(SUPPLEMENT.read_text(encoding="utf-8"))
    if authority != {
        "region": "EU", "rom_sha256": supplement["authority"]["rom_sha256"],
        "command_plan_sha256": sha256(PLAN), "supplement_sha256": sha256(SUPPLEMENT),
    }:
        raise ValueError("semantic fixture authority differs")
    expected_totals = (semantic.get("commands"), semantic.get("selected_route"), semantic.get("retry_only"), semantic.get("source_waits"), semantic.get("source_wait_frames"))
    if expected_totals != (304, 251, 53, 108, 3001):
        raise ValueError("semantic fixture totals differ")
    if not allow_fault and (semantic.get("fault_injection") is not None or semantic.get("certification_eligible") is not True):
        raise ValueError("fault-injected fixture is not certification eligible")
    for name, expected in semantic.get("files", {}).items():
        path = fixture / name
        if not path.is_file() or path.is_symlink() or path.stat().st_size != expected["bytes"] or sha256(path) != expected["sha256"]:
            raise ValueError(f"semantic fixture file differs: {name}")
    validator = semantic["validator"]
    source = ROOT / validator["source"]
    installed = fixture / validator["path"]
    if sha256(source) != validator["source_sha256"] or sha256(installed) != validator["sha256"]:
        raise ValueError("semantic validator identity differs")
    if "@@" in installed.read_text(encoding="utf-8"):
        raise ValueError("semantic validator has unresolved template tokens")
    return manifest, semantic


def validate_mode(mode: str, events: list[dict[str, Any]], plan: dict[str, Any], supplement: dict[str, Any]) -> dict[str, Any]:
    old = load_tool("run_pmdred_tiny_woods_command_complete")
    expected_commands = old.expected_command_records(plan)
    command_traces = [event for event in events if event.get("event") == "command_trace"]
    actual_commands = {
        event["address"]: {key: event[key] for key in ("array", "index", "op", "arg_byte", "arg_short", "arg1", "arg2", "handler")}
        for event in command_traces
    }
    if len(command_traces) != 975 or actual_commands != expected_commands:
        raise ValueError(f"{mode}: authenticated 975-command trace differs")
    semantic_events = [event for event in events if event.get("event") == "command_semantic_trace"]
    expected_rows = [
        row for row in supplement["commands"]
        if mode == "semantic_all_v3" or row["route_class"] == "selected_route"
    ]
    if len(semantic_events) != 2 * len(expected_rows):
        raise ValueError(f"{mode}: start/complete semantic trace count differs")
    for index, row in enumerate(expected_rows):
        start, complete = semantic_events[index * 2:index * 2 + 2]
        if start.get("kind") != "semantic_start" or complete.get("kind") != "semantic_complete":
            raise ValueError(f"{mode}: strict semantic adjacency differs at {row['ordinal']}")
        copied = {
            "ordinal": row["ordinal"], "address": row["address"], "array": row["array_id"], "index": row["source_index"],
            "op": row["op"], "arg_byte": row["arg_byte"], "arg_short": row["arg_short"], "arg1": row["arg1"], "arg2": row["arg2"],
            "handler": row["pmdo_handler"], "category": row["semantic_category"], "api": row["pmdo_api"],
            "route_class": row["route_class"], "source_frames": row["source_frames"],
        }
        for event in (start, complete):
            if {key: event.get(key) for key in copied} != copied:
                raise ValueError(f"{mode}: semantic metadata differs at ordinal {row['ordinal']}")
        if start.get("elapsed_frames") != 0 or complete.get("elapsed_frames") != row["source_frames"]:
            raise ValueError(f"{mode}: native frame accounting differs at ordinal {row['ordinal']}")
        if complete.get("after_tick", -1) < complete.get("before_tick", 0):
            raise ValueError(f"{mode}: native frame ticks reversed at ordinal {row['ordinal']}")
    verdicts = [event for event in events if event.get("event") == "command_semantic_verdict"]
    expected = EXPECTATIONS[mode]
    if len(verdicts) != 1:
        raise ValueError(f"{mode}: semantic verdict cardinality differs")
    verdict = verdicts[0]
    if verdict.get("verdict") != "PASS" or verdict.get("fault") is not False:
        raise ValueError(f"{mode}: semantic verdict is not PASS")
    if (verdict.get("semantic_starts"), verdict.get("semantic_completes"), verdict.get("waits"), verdict.get("wait_frames")) != (expected["commands"], expected["commands"], expected["waits"], expected["frames"]):
        raise ValueError(f"{mode}: semantic verdict totals differ")
    if [event.get("ground") for event in events if event.get("event") == "ground_enter"] != ["d01p01"]:
        raise ValueError(f"{mode}: native Ground route differs")
    if [event.get("event") for event in events[-4:]] != ["load_phase_unload_requested", "native_deinit", "native_graphics_unload", "end"]:
        raise ValueError(f"{mode}: native unload tail differs")
    return {
        "mode": mode, "result": "PASS", "command_plan_traces": len(command_traces),
        "semantic_commands": len(expected_rows), "semantic_trace_events": len(semantic_events),
        "waits": expected["waits"], "source_wait_frames": expected["frames"],
        "route": ["d01p01"], "verdict": verdict,
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
        raise FileExistsError(f"refusing to overwrite semantic evidence: {evidence}")
    runner = load_tool("run_pmdred_eu_native_fixture")
    old = load_tool("run_pmdred_tiny_woods_command_complete")
    if sha256(runner.PMDO) != PMDO_SHA256:
        raise ValueError("exact PMDO 0.8.12 executable differs")
    manifest, semantic_manifest = authenticate(fixture)
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    supplement = json.loads(SUPPLEMENT.read_text(encoding="utf-8"))
    evidence.mkdir(parents=True)
    dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(PLAN, evidence / "command_plan.json")
    shutil.copyfile(SUPPLEMENT, evidence / "command_semantic_supplement_v3.json")
    index_gate = old.index_fixture(fixture, evidence, runner)

    runs = []
    for mode in MODES:
        wrapper = fixture / "command-semantic-v3-runs" / mode
        wrapper.mkdir(parents=True)
        (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True)
        (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
        namespace = argparse.Namespace(
            fixture=wrapper, ground=mode, expected_screenshots=0, timeout_seconds=args.timeout_seconds,
            events=EVENTS, validator_mode="tiny_woods_command_semantic_v3",
            environment=[f"TINY_WOODS_COMMAND_MODE={mode}", f"TINY_WOODS_COMMAND_SEED={args.seed}"],
        )
        runner.run(namespace)
        destination = evidence / mode
        destination.mkdir()
        for name in ("runtime.log", "events.jsonl", "termination.json"):
            shutil.copyfile(wrapper / name, destination / name)
        events = read_events(destination / "events.jsonl")
        summary = validate_mode(mode, events, plan, supplement)
        termination = old.strict_termination(destination / "termination.json")
        runs.append({
            **summary,
            "events_sha256": sha256(destination / "events.jsonl"),
            "runtime_log_sha256": sha256(destination / "runtime.log"),
            "termination_sha256": sha256(destination / "termination.json"),
            "termination": {key: termination[key] for key in ("exit_classification", "return_code", "terminal", "graceful", "watchdog", "requested_signal", "sigsegv", "forced_kill", "orphan_process")},
        })
    report = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-native-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(),
        "status": "passed",
        "authority": semantic_manifest["authority"],
        "runtime": {"version": "0.8.12.0", "executable_sha256": PMDO_SHA256},
        "index_gate": index_gate,
        "runs": runs,
        "combined": {"commands": 304, "selected_route": 251, "retry_only": 53, "source_waits": 108, "source_wait_frames": 3001},
        "assertions": {
            "all_975_authenticated_plan_rows_are_traced_before_semantic_execution": True,
            "all_304_supplement_rows_have_strict_adjacent_start_complete_events": True,
            "selected_route_and_all_command_modes_are_independently_native": True,
            "all_108_waits_execute_exactly_3001_source_frames_in_all_mode": True,
            "non_wait_rows_are_metadata_contracts_pending_actor_context_resolution": True,
            "both_runs_reach_LoadPhase_Unload_NORMAL_EXIT_rc0_without_signal_watchdog_or_orphan": True,
        },
    }
    dump(evidence / "native_command_semantic_validation_v3.json", report)
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_NATIVE_V3_PASS "
        f"modes=2 selected=251 all=304 waits=3001 evidence={evidence}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
