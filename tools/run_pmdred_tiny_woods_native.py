#!/usr/bin/env python3
"""Certify all Tiny Woods floors in exact PMDO 0.8.12 native execution.

The gate indexes the isolated fixture, generates floors 1F--3F, repeats 1F to
prove deterministic generation from the explicit bootstrap seed, validates
connectivity/content/routing invariants, and delegates every process lifecycle
to the campaign's strict native termination runner.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import signal
import subprocess
import sys
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ZONE_SHA256 = "e4f3edaf4af60bc625ce8e5c3b9d1d36372c2a1b009b4b1d21d13774e7eb92f7"
DEFAULT_EVENTS = Path("/tmp/tiny_woods_native.jsonl")
EVENT_ORDER = (
    "bootstrap_new_game",
    "launcher_ground_entered",
    "launcher_map_update",
    "launcher_coroutine_started",
    "floor_probe",
    "load_phase_unload_requested",
    "native_deinit",
    "native_graphics_unload",
    "end",
)
ALLOWED_MONEY = {4, 6, 10, 14, 22, 26, 34, 38}
ALLOWED_ENEMIES = (
    {"pidgey", "sunkern", "wurmple"},
    {"pidgey", "sunkern", "wurmple"},
    {"pidgey", "exeggcute", "sunkern", "wurmple"},
)


def load_tool(name: str) -> ModuleType:
    path = ROOT / "tools" / f"{name}.py"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def dump(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def run_index(fixture: Path, evidence: Path, runner: ModuleType) -> dict[str, Any]:
    command = [
        str(runner.PMDO),
        "-asset", str(fixture / "asset") + "/",
        "-appdata", str(fixture / "appdata") + "/",
        "-quest", "pmdred_eu_fixture",
        "-index", "zone",
    ]
    log = evidence / "index.log"
    with log.open("wb") as stream:
        process = subprocess.Popen(
            command,
            cwd=ROOT,
            env=runner.pmdo_env("tiny_woods_index_only"),
            stdout=stream,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
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
    record = {
        "schema": "pmdred-eu-tiny-woods-zone-index-v1",
        "command": command,
        "return_code": return_code,
        "timed_out": timed_out,
        "status": "passed" if return_code == 0 and not timed_out and index.is_file() else "failed",
        "zone_sha256_after_index": sha256(fixture / "quest/Data/Zone/tiny_woods.json"),
        "index": {
            "bytes": index.stat().st_size if index.is_file() else None,
            "sha256": sha256(index) if index.is_file() else None,
        },
        "log": {"bytes": log.stat().st_size, "sha256": sha256(log)},
    }
    dump(evidence / "index_validation.json", record)
    if record["status"] != "passed" or record["zone_sha256_after_index"] != ZONE_SHA256:
        raise RuntimeError("exact PMDO zone-index gate failed")
    return record


def read_events(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line]


def validate_fixture(fixture: Path) -> dict[str, Any]:
    """Authenticate the ignored overlay inputs before native execution."""
    manifest_path = fixture / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    native = manifest.get("tiny_woods_native", {})
    authority = native.get("authority", {})
    launcher = native.get("launcher", {})
    validator = native.get("validator", {})
    installed_validator = (
        fixture
        / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    )
    source_validator = ROOT / "tools/pmdred_tiny_woods_native_validator.lua"
    if (
        native.get("schema") != "pmdred-eu-tiny-woods-native-fixture-v1"
        or authority.get("region") != "EU"
        or authority.get("rom_sha256") != ROM_SHA256
        or authority.get("zone_sha256") != ZONE_SHA256
        or launcher.get("ground") != "d01p01"
        or launcher.get("master_zone_index") != 308
        or launcher.get("silent_restrictions") is not True
        or validator.get("opt_in") != "PMDO_GROUND_VALIDATOR=tiny_woods_native_fixture"
        or validator.get("source_sha256") != sha256(source_validator)
        or validator.get("fixture_sha256") != sha256(installed_validator)
    ):
        raise ValueError("fixture provenance or installed native validator is not authenticated")
    return {
        "fixture_manifest": manifest_path,
        "validator": installed_validator,
        "validator_template_sha256": sha256(source_validator),
    }


def validate_probe(events: list[dict[str, Any]], floor: int, seed: int) -> dict[str, Any]:
    kinds = tuple(event.get("event") for event in events)
    if kinds != EVENT_ORDER:
        raise ValueError(f"floor {floor}: unexpected event order {kinds}")
    probe = events[4]
    if probe.get("verdict") != "PASS":
        raise ValueError(f"floor {floor}: validator verdict is not PASS")
    if (
        probe.get("bootstrap_seed") != seed
        or probe.get("requested_floor") != floor
        or probe.get("zone") != "tiny_woods"
        or probe.get("segment") != 0
        or probe.get("map") != floor
        or probe.get("music") != "Tiny Woods.ogg"
    ):
        raise ValueError(f"floor {floor}: destination or seed identity mismatch")
    width, height = probe["width"], probe["height"]
    if width != 28 or height not in {30, 32}:
        raise ValueError(f"floor {floor}: non-authenticated adaptation extent")
    if probe["terrain"].get("floor") != probe["walkable"]:
        raise ValueError(f"floor {floor}: walkable/floor count differs")
    if sum(probe["terrain"].values()) != width * height:
        raise ValueError(f"floor {floor}: terrain does not cover the map")
    if probe["reachable"] != probe["walkable"] or not probe["all_walkable_reachable"]:
        raise ValueError(f"floor {floor}: disconnected walkable terrain")
    if probe["effects"] != {"stairs_go_up": 1} or probe["traps"] != 0:
        raise ValueError(f"floor {floor}: stair/trap population mismatch")
    if len(probe["entries"]) != 1 or probe["entries"][0] != probe["start"]:
        raise ValueError(f"floor {floor}: leader start does not match the sole entry")
    if len(probe["stairs"]) != 1:
        raise ValueError(f"floor {floor}: expected exactly one stair")
    stair = probe["stairs"][0]
    if (
        stair["id"] != "stairs_go_up"
        or stair["reachable"] is not True
        or stair["distance"] < 0
        or probe["shortest_stair_route"] != stair["distance"]
    ):
        raise ValueError(f"floor {floor}: stair route is invalid")

    items = probe["items"]
    if len(items) not in {1, 2, 3} or not all(item["reachable"] for item in items):
        raise ValueError(f"floor {floor}: item count/reachability mismatch")
    if floor < 2:
        if not all(
            item["money"] is True and item["id"] == "" and item["amount"] in ALLOWED_MONEY
            for item in items
        ):
            raise ValueError(f"floor {floor}: non-authenticated money spawn")
    elif not all(
        item["money"] is False
        and item["id"] in {"berry_oran", "berry_pecha"}
        and item["amount"] == 0
        for item in items
    ):
        raise ValueError("floor 2: non-authenticated berry spawn")

    mobs = probe["mobs"]
    if probe["mob_count"] not in {2, 3} or len(mobs) != probe["mob_count"]:
        raise ValueError(f"floor {floor}: initial enemy count mismatch")
    if not all(
        mob["species"] in ALLOWED_ENEMIES[floor]
        and mob["level"] == 1
        and mob["reachable"] is True
        for mob in mobs
    ):
        raise ValueError(f"floor {floor}: enemy identity/level/reachability mismatch")
    return probe


def run(args: argparse.Namespace) -> int:
    fixture = args.fixture.resolve()
    evidence = args.evidence_dir.resolve()
    if evidence.exists():
        raise FileExistsError(f"refusing to overwrite native evidence: {evidence}")
    runner = load_tool("run_pmdred_eu_native_fixture")
    if sha256(runner.PMDO) != PMDO_SHA256:
        raise ValueError("PMDO executable is not the authenticated 0.8.12 runtime")
    zone = fixture / "quest/Data/Zone/tiny_woods.json"
    if not zone.is_file() or sha256(zone) != ZONE_SHA256:
        raise ValueError("fixture does not contain the authenticated Tiny Woods ZoneData")
    fixture_artifacts = validate_fixture(fixture)

    evidence.mkdir(parents=True)
    shutil.copyfile(fixture_artifacts["fixture_manifest"], evidence / "fixture_manifest.json")
    shutil.copyfile(fixture_artifacts["validator"], evidence / "validator.lua")
    index_record = run_index(fixture, evidence, runner)
    run_specs = ((0, "floor_1_run_a"), (1, "floor_2"), (2, "floor_3"), (0, "floor_1_run_b"))
    records: list[dict[str, Any]] = []
    probes: dict[str, dict[str, Any]] = {}
    for floor, name in run_specs:
        wrapper = fixture / "native-runs" / name
        if wrapper.exists():
            raise FileExistsError(wrapper)
        wrapper.mkdir(parents=True)
        (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True)
        (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
        namespace = argparse.Namespace(
            fixture=wrapper,
            ground=name,
            expected_screenshots=0,
            timeout_seconds=args.timeout_seconds,
            events=DEFAULT_EVENTS,
            validator_mode="tiny_woods_native_fixture",
            environment=[f"TINY_WOODS_FLOOR={floor}", f"TINY_WOODS_SEED={args.seed}"],
        )
        runner.run(namespace)
        destination = evidence / name
        destination.mkdir()
        for filename in ("runtime.log", "events.jsonl", "termination.json"):
            shutil.copyfile(wrapper / filename, destination / filename)
        events = read_events(destination / "events.jsonl")
        probe = validate_probe(events, floor, args.seed)
        termination = json.loads((destination / "termination.json").read_text(encoding="utf-8"))
        if not (
            termination.get("result") == "PASS"
            and termination.get("exit_classification") == "NORMAL_EXIT"
            and termination.get("return_code") == 0
            and termination.get("terminal") is True
            and termination.get("graceful") is True
            and termination.get("watchdog") is False
            and termination.get("requested_signal") is None
            and termination.get("sigsegv") is False
            and termination.get("forced_kill") is False
            and termination.get("orphan_process") is False
        ):
            raise ValueError(f"{name}: strict native termination record failed")
        probes[name] = probe
        records.append({
            "name": name,
            "floor_index": floor,
            "floor_number": floor + 1,
            "result": "PASS",
            "events_sha256": sha256(destination / "events.jsonl"),
            "runtime_log_sha256": sha256(destination / "runtime.log"),
            "termination_sha256": sha256(destination / "termination.json"),
            "probe": probe,
        })

    deterministic = probes["floor_1_run_a"] == probes["floor_1_run_b"]
    if not deterministic:
        raise ValueError("repeated 1F generation differs at the same bootstrap seed")
    report = {
        "schema": "pmdred-eu-tiny-woods-native-generation-v1",
        "date": str(date.today()),
        "status": "passed",
        "scope": "exact PMDO 0.8.12 native generation for Petit Bois 1F-3F plus deterministic 1F replay",
        "runtime": {
            "version": "0.8.12.0",
            "executable_sha256": PMDO_SHA256,
            "validator_mode": "tiny_woods_native_fixture",
        },
        "input": {
            "zone": "Data/Zone/tiny_woods.json",
            "zone_sha256": ZONE_SHA256,
            "bootstrap_seed": args.seed,
            "fixture_manifest": "fixture_manifest.json",
            "fixture_manifest_sha256": sha256(evidence / "fixture_manifest.json"),
            "validator": "validator.lua",
            "validator_sha256": sha256(evidence / "validator.lua"),
            "validator_template_sha256": fixture_artifacts["validator_template_sha256"],
        },
        "index_gate": index_record,
        "runs": records,
        "reproduction": {
            "working_directory": str(ROOT),
            "commands": [
                ".runtime-cache/test-venv/bin/python tools/build_pmdred_tiny_woods_runtime_fixture.py --output .runtime-cache/tiny-woods-native-fixture-repro",
                ".runtime-cache/test-venv/bin/python tools/run_pmdred_tiny_woods_native.py --fixture .runtime-cache/tiny-woods-native-fixture-repro --evidence-dir .runtime-cache/tiny-woods-native-evidence-repro --seed 424242 --timeout-seconds 60",
                "PMDRED_EU_ROM=.runtime-cache/downloads/pmdred-eu.gba PYTHONPATH=tools .runtime-cache/test-venv/bin/python -m unittest tools.test_pmdred_dungeon_ground tools.test_build_pmdred_tiny_woods tools.test_pmdred_tiny_woods_native -v",
            ],
            "immutability": "Both output paths must be absent; builders and certifier refuse overwrite.",
        },
        "assertions": {
            "all_three_floors_generated": True,
            "same_seed_floor_1_probe_byte_equivalent": deterministic,
            "all_walkable_tiles_connected": True,
            "single_reachable_stair_per_floor": True,
            "authenticated_item_classes_and_counts": True,
            "authenticated_enemy_classes_levels_and_counts": True,
            "no_traps": True,
            "authenticated_music_selected": True,
            "all_native_terminations_normal_and_graceful": True,
            "all_native_terminations_load_phase_unload": True,
            "watchdog_signal_sigsegv_forced_kill_or_orphan": False,
        },
        "limitations": [
            "This gate proves generation and generated-floor invariants, not player-driven stair traversal.",
            "The d01p01 -> dungeon transition is fixture-driven with silent restrictions; canonical story trigger integration remains pending.",
            "Dungeon completion routing to d01p02, retry/defeat behavior, progression state, and narrative choreography remain pending.",
        ],
    }
    dump(evidence / "native_generation_validation.json", report)
    print(
        f"TINY_WOODS_NATIVE_PASS floors=3 runs=4 seed={args.seed} "
        f"deterministic={str(deterministic).lower()} evidence={evidence}"
    )
    return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--fixture", required=True, type=Path)
    result.add_argument("--evidence-dir", required=True, type=Path)
    result.add_argument("--seed", type=int, default=424242)
    result.add_argument("--timeout-seconds", type=int, default=60)
    return result


def main() -> int:
    return run(parser().parse_args())


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {type(exc).__name__}: {exc}", file=sys.stderr, flush=True)
        raise
