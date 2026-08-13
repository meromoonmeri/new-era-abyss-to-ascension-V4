#!/usr/bin/env python3
"""Certify Tiny Woods opening, action traversal, retry, rescue, and cleanup.

Every scenario runs serially in exact PMDO 0.8.12 and delegates lifecycle
classification to the campaign's strict native runner.  A route PASS therefore
requires real ``ProcessPlayerInput(GameAction)`` stair traversal as well as
``LoadPhase.Unload``/normal process termination.
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
from datetime import date
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
ENDING_GROUND_SHA256 = "ce2e109b082a5a6986fb5768ea315b60dfb5549d882f2f11908842b37e52e47e"
ENDING_TILE_SHA256 = "0aff40efcb0a42849495510eac868402245e0489876da595511b28b74466350f"
ENDING_MUSIC_SHA256 = "4b22c99be63e4ec61055c9a32ea0951e4910132551a8258f58fe2f1a6f9d9cd2"
ENDING_MUSIC = "In the Depths of the Pit.ogg"
EVENTS = Path("/tmp/tiny_woods_route.jsonl")
MODES = ("opening_entry", "defeat_retry", "clear_rescue_cleanup")


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


def events(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line]


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
            env=runner.pmdo_env("tiny_woods_route_index_only"),
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
    result = {
        "schema": "pmdred-eu-tiny-woods-route-zone-index-v1",
        "command": command,
        "return_code": return_code,
        "timed_out": timed_out,
        "status": "passed" if return_code == 0 and not timed_out and index.is_file() else "failed",
        "index": {
            "bytes": index.stat().st_size if index.is_file() else None,
            "sha256": sha256(index) if index.is_file() else None,
        },
        "log": {"bytes": log.stat().st_size, "sha256": sha256(log)},
    }
    dump(evidence / "index_validation.json", result)
    if result["status"] != "passed":
        raise RuntimeError("exact PMDO route fixture zone-index gate failed")
    return result


def authenticate_fixture(fixture: Path) -> tuple[dict[str, Any], Path]:
    manifest_path = fixture / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    route = manifest.get("tiny_woods_route", {})
    authority = route.get("authority", {})
    route_table = route.get("route", {})
    isolation = route.get("fixture_isolation", {})
    validator = route.get("validator", {})
    installed = fixture / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    source = ROOT / "tools/pmdred_tiny_woods_route_validator.lua"
    ending_source = ROOT / "RESERVE/pmdred_direct/grounds/d01p02.rsground"
    tile_source = ROOT / "RESERVE/pmdred_direct/tiles/d01p02_DirectBase.tile"
    music_source = ROOT / f"Content/Music/{ENDING_MUSIC}"
    if (
        route.get("schema") != "pmdred-eu-tiny-woods-route-fixture-v1"
        or authority.get("region") != "EU"
        or authority.get("rom_sha256") != ROM_SHA256
        or authority.get("ending_ground_source_sha256") != ENDING_GROUND_SHA256
        or authority.get("ending_tile_source_sha256") != ENDING_TILE_SHA256
        or authority.get("ending_music_source_sha256") != ENDING_MUSIC_SHA256
        or authority.get("ending_bgm_eu_command", {}).get("rom_address") != "0x084D4C78"
        or authority.get("ending_bgm_eu_command", {}).get("opcode") != "0x44"
        or authority.get("ending_bgm_eu_command", {}).get("music_id") != 114
        or route_table.get("master_zone_d01p01_index") != 308
        or route_table.get("tiny_woods_ground_maps") != ["d01p01", "d01p02"]
        or route_table.get("ending_music") != ENDING_MUSIC
        or route_table.get("silent_restrictions") is not True
        or isolation.get("zone_script_parent_private") is not True
        or isolation.get("zone_script_parent_is_symlink") is not False
        or validator.get("opt_in") != "PMDO_GROUND_VALIDATOR=tiny_woods_route_fixture"
        or validator.get("source_sha256") != sha256(source)
        or validator.get("fixture_sha256") != sha256(installed)
        or sha256(ending_source) != ENDING_GROUND_SHA256
        or sha256(tile_source) != ENDING_TILE_SHA256
        or sha256(music_source) != ENDING_MUSIC_SHA256
    ):
        raise ValueError("route fixture provenance, isolation, validator, or EU BGM differs")

    # Independently rehash every private adaptation named by the fixture.  Do
    # not trust a manifest produced by the same builder without this second
    # read of bytes and sizes.
    for name, expected in route.get("files", {}).items():
        relative = Path(name)
        if relative.is_absolute() or ".." in relative.parts:
            raise ValueError(f"unsafe fixture manifest path: {name}")
        path = fixture / relative
        if (
            not path.is_file()
            or path.is_symlink()
            or path.stat().st_size != expected.get("bytes")
            or sha256(path) != expected.get("sha256")
        ):
            raise ValueError(f"fixture private file differs: {name}")

    zone = json.loads((fixture / "quest/Data/Zone/tiny_woods.json").read_text(encoding="utf-8-sig"))
    if zone["Object"].get("GroundMaps") != ["d01p01", "d01p02"]:
        raise ValueError("Tiny Woods private Ground registration differs")
    ending = fixture / "quest/Data/Ground/d01p02.rsground"
    ending_data = json.loads(ending.read_text(encoding="utf-8-sig"))["Object"]
    markers = [item for layer in ending_data["Entities"] for item in layer.get("Markers", [])]
    if (
        ending_data.get("AssetName") != "d01p02"
        or len(markers) != 1
        or markers[0].get("EntName") != "Main_Entrance_Marker"
        or markers[0].get("Direction") != 0
        or markers[0].get("Collider") != {"X": 164, "Y": 276, "Width": 16, "Height": 16}
    ):
        raise ValueError("d01p02 private identity/entry marker differs")

    sheets: set[str] = set()
    def collect_sheets(value: Any) -> None:
        if isinstance(value, dict):
            if isinstance(value.get("Sheet"), str):
                sheets.add(value["Sheet"])
            for child in value.values():
                collect_sheets(child)
        elif isinstance(value, list):
            for child in value:
                collect_sheets(child)
    collect_sheets(ending_data.get("Layers", []))
    if sheets != {"d01p02_DirectBase"}:
        raise ValueError(f"d01p02 Ground sheet references differ: {sorted(sheets)}")

    tile = fixture / "quest/Content/Tile/d01p02_DirectBase.tile"
    wrong_tile = fixture / "quest/Data/Tile/d01p02_DirectBase.tile"
    base_builder = load_tool("build_pmdred_eu_runtime_fixture")
    expected_node, _ = base_builder.tile_node(tile.read_bytes())
    indexed_node = base_builder.read_tile_index(fixture / "quest/Content/Tile/index.idx").get(tile.stem)
    if sha256(tile) != ENDING_TILE_SHA256 or wrong_tile.exists() or indexed_node != expected_node:
        raise ValueError("d01p02 Content/Tile bytes, location, or index node differ")
    return manifest, installed


def first(items: list[dict[str, Any]], kind: str) -> dict[str, Any]:
    matches = [item for item in items if item.get("event") == kind]
    if len(matches) != 1:
        raise ValueError(f"expected one {kind!r} event, observed {len(matches)}")
    return matches[0]


def validate_lifecycle(items: list[dict[str, Any]]) -> None:
    kinds = [item.get("event") for item in items]
    if "scenario_fail" in kinds:
        failure = next(item for item in items if item.get("event") == "scenario_fail")
        raise ValueError(f"native route validator failed: {failure.get('error')}")
    required_tail = [
        "scenario_verdict",
        "load_phase_unload_requested",
        "native_deinit",
        "native_graphics_unload",
        "end",
    ]
    positions = [kinds.index(kind) for kind in required_tail]
    if positions != sorted(positions) or kinds[-1] != "end":
        raise ValueError(f"route lifecycle events are incomplete/out of order: {kinds}")
    if first(items, "scenario_verdict").get("verdict") != "PASS":
        raise ValueError("scenario verdict is not PASS")
    unload = first(items, "load_phase_unload_requested")
    if unload.get("requested") != "Unload" or unload.get("readback") != "Unload":
        raise ValueError("route validator did not assign/read back LoadPhase.Unload")
    for kind in ("native_deinit", "native_graphics_unload", "end"):
        if first(items, kind).get("load_phase") != "Unload":
            raise ValueError(f"{kind} did not observe LoadPhase.Unload")
    end = first(items, "end")
    if end.get("terminal") is not True or end.get("graceful") is not True:
        raise ValueError("route validator terminal/graceful evidence differs")


def validate_mode(mode: str, items: list[dict[str, Any]]) -> dict[str, Any]:
    validate_lifecycle(items)
    bootstrap = first(items, "bootstrap_new_game")
    verdict = first(items, "scenario_verdict")
    if bootstrap.get("mode") != mode or verdict.get("mode") != mode:
        raise ValueError(f"{mode}: scenario identity differs")
    routes = [item for item in items if item.get("event") == "ground_route"]
    floors = [item for item in items if item.get("event") == "dungeon_floor_entered"]
    actions = [item for item in items if item.get("event") == "player_action"]
    if not routes or routes[0].get("ground") != "d01p01" or routes[0].get("group") != "g1":
        raise ValueError(f"{mode}: canonical d01p01:g1 opening is absent")
    if routes[0].get("hero_x") != 200 or routes[0].get("hero_y") != 196:
        raise ValueError(f"{mode}: opening hero placement differs")

    if mode == "opening_entry":
        if (
            [item.get("floor") for item in floors] != [0]
            or verdict.get("attempts") != 1
            or verdict.get("defeats") != 0
            or verdict.get("actions") != 0
        ):
            raise ValueError("opening_entry route assertions differ")
    elif mode == "defeat_retry":
        native_queues = [item for item in items if item.get("event") == "native_action_queue"]
        native_consumed = [item for item in items if item.get("event") == "native_action_consumed"]
        defeat_modals = [item for item in items if item.get("event") == "defeat_message_log"]
        if (
            [item.get("group") for item in routes] != ["g1", "g2"]
            or [item.get("floor") for item in floors] != [0, 0]
            or len([item for item in items if item.get("event") == "failed_result_action"]) != 1
            or [item.get("kind") for item in actions] != ["GiveUp"]
            or actions[0].get("native_type") != "GiveUp: 20"
            or actions[0].get("native_direction") != "None: -1"
            or actions[0].get("native_argument0") != "1"
            or len(native_queues) != 1
            or native_queues[0].get("dungeon_scene") is not True
            or native_queues[0].get("player_turn") is not True
            or native_queues[0].get("leader_turn") is not True
            or native_queues[0].get("animations_over") is not True
            or len(defeat_modals) != 1
            or defeat_modals[0].get("menu_count") != 1
            or defeat_modals[0].get("action") != "native_close"
            or len(native_consumed) != 1
            or verdict.get("attempts") != 2
            or verdict.get("defeats") != 1
        ):
            raise ValueError("defeat_retry route assertions differ")
    else:
        stair_actions = [item for item in items if item.get("event") == "stair_action_submitted"]
        stair_prompts = [item for item in items if item.get("event") == "stair_prompt_menu"]
        native_queues = [item for item in items if item.get("event") == "native_action_queue"]
        tile_actions = [item for item in actions if item.get("kind") == "Tile"]
        attack_actions = [item for item in actions if item.get("kind") == "Attack"]
        tile_queues = [item for item in native_queues if item.get("scheduler") == "MenuManager.EndAction"]
        occupancy_replans = [item for item in items if item.get("event") == "occupancy_replan"]
        hostile_replans = [
            item for item in occupancy_replans
            if item.get("next_occupied") is True
            and item.get("relation") == "hostile"
            and item.get("selected_action") == "Attack"
        ]
        ending = [item for item in items if item.get("event") == "ending_ground_probe"]
        if (
            [item.get("floor") for item in floors] != [0, 1, 2]
            or [item.get("floor") for item in stair_actions] != [0, 1, 2]
            or [item.get("floor") for item in stair_prompts] != [0, 1, 2]
            or any(item.get("menu_count") != 1 or item.get("selection") != "trigger" for item in stair_prompts)
            or len(actions) == 0
            or any(item.get("kind") not in {"Move", "Attack", "Tile"} for item in actions)
            or len(native_queues) != len(actions)
            or [item.get("number") for item in native_queues] != [item.get("number") for item in actions]
            or any(
                item.get("dungeon_scene") is not True
                or item.get("player_turn") is not True
                or item.get("leader_turn") is not True
                or item.get("animations_over") is not True
                for item in native_queues
            )
            or any(item.get("native_argument0") != "1" for item in actions if item.get("kind") == "Move")
            or len(attack_actions) == 0
            or len(occupancy_replans) == 0
            or len(hostile_replans) == 0
            or verdict.get("occupancy_replans") != len(occupancy_replans)
            or verdict.get("hostile_blocks", 0) < len(hostile_replans)
            or len(tile_actions) != 3
            or any(
                item.get("native_type") != "Tile: 4"
                or item.get("native_direction") != "None: -1"
                or item.get("native_argument0") != "0"
                for item in tile_actions
            )
            or len(tile_queues) != 3
            or [item.get("number") for item in tile_queues] != [item.get("number") for item in tile_actions]
            or len(ending) != 2
            or ending[0].get("cleanup") is not False
            or ending[0].get("verdict") != "PASS"
            or ending[0].get("solid_cells") != 1503
            or ending[0].get("partner") is not True
            or ending[0].get("caterpie") is not True
            or ending[0].get("music") != ENDING_MUSIC
            or ending[1].get("cleanup") is not True
            or ending[1].get("partner") is not False
            or ending[1].get("caterpie") is not False
            or ending[1].get("music") != ""
            or len([item for item in items if item.get("event") == "rescue_completed"]) != 1
            or len([item for item in items if item.get("event") == "post_rescue_relay"]) != 1
            or verdict.get("attempts") != 1
            or verdict.get("defeats") != 0
            or verdict.get("floors_entered") != 3
            or verdict.get("floors_cleared") != 3
            or verdict.get("rescue_complete") is not True
            or verdict.get("actions") != len(actions)
            or verdict.get("replans", 0) <= 0
        ):
            raise ValueError("clear_rescue_cleanup route/action assertions differ")
    return {
        "mode": mode,
        "verdict": verdict,
        "ground_routes": routes,
        "dungeon_floors": floors,
        "player_action_count": len(actions),
        "attack_action_count": len([item for item in actions if item.get("kind") == "Attack"]),
        "occupancy_replan_count": len(
            [item for item in items if item.get("event") == "occupancy_replan"]
        ),
    }


def strict_termination(path: Path) -> dict[str, Any]:
    record = json.loads(path.read_text(encoding="utf-8"))
    if not (
        record.get("result") == "PASS"
        and record.get("exit_classification") == "NORMAL_EXIT"
        and record.get("return_code") == 0
        and record.get("terminal") is True
        and record.get("graceful") is True
        and record.get("watchdog") is False
        and record.get("requested_signal") is None
        and record.get("sigsegv") is False
        and record.get("forced_kill") is False
        and record.get("orphan_process") is False
    ):
        raise ValueError(f"strict native termination failed: {path}")
    return record


def run(args: argparse.Namespace) -> int:
    fixture = args.fixture.resolve()
    evidence = args.evidence_dir.resolve()
    if evidence.exists():
        raise FileExistsError(f"refusing to overwrite route evidence: {evidence}")
    runner = load_tool("run_pmdred_eu_native_fixture")
    if sha256(runner.PMDO) != PMDO_SHA256:
        raise ValueError("PMDO executable is not authenticated exact 0.8.12")
    manifest, installed_validator = authenticate_fixture(fixture)
    evidence.mkdir(parents=True)
    dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(installed_validator, evidence / "validator.lua")
    index = run_index(fixture, evidence, runner)

    records: list[dict[str, Any]] = []
    for mode in MODES:
        wrapper = fixture / "route-runs" / mode
        if wrapper.exists():
            raise FileExistsError(wrapper)
        wrapper.mkdir(parents=True)
        (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True)
        (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
        namespace = argparse.Namespace(
            fixture=wrapper,
            ground=mode,
            expected_screenshots=0,
            timeout_seconds=args.timeout_seconds,
            events=EVENTS,
            validator_mode="tiny_woods_route_fixture",
            environment=[f"TINY_WOODS_ROUTE_MODE={mode}", f"TINY_WOODS_ROUTE_SEED={args.seed}"],
        )
        runner.run(namespace)
        destination = evidence / mode
        destination.mkdir()
        for filename in ("runtime.log", "events.jsonl", "termination.json"):
            shutil.copyfile(wrapper / filename, destination / filename)
        route_events = events(destination / "events.jsonl")
        summary = validate_mode(mode, route_events)
        termination = strict_termination(destination / "termination.json")
        records.append({
            **summary,
            "result": "PASS",
            "events_sha256": sha256(destination / "events.jsonl"),
            "runtime_log_sha256": sha256(destination / "runtime.log"),
            "termination_sha256": sha256(destination / "termination.json"),
            "termination": {
                key: termination[key]
                for key in (
                    "exit_classification", "return_code", "terminal", "graceful",
                    "watchdog", "requested_signal", "sigsegv", "forced_kill", "orphan_process",
                )
            },
        })

    report = {
        "schema": "pmdred-eu-tiny-woods-native-route-v1",
        "date": str(date.today()),
        "status": "passed",
        "scope": "Petit Bois opening, player-action stair traversal, clear/ending, failed-result retry, rescue relay, and actor/music cleanup",
        "authority": {
            "region": "EU",
            "rom_sha256": ROM_SHA256,
            "ending_ground_sha256": ENDING_GROUND_SHA256,
            "ending_tile_sha256": ENDING_TILE_SHA256,
            "ending_music": ENDING_MUSIC,
            "ending_music_sha256": ENDING_MUSIC_SHA256,
            "ending_bgm_eu_command": {
                "rom_address": "0x084D4C78",
                "opcode": "0x44",
                "music_id": 114,
            },
        },
        "runtime": {
            "version": "0.8.12.0",
            "executable_sha256": PMDO_SHA256,
            "validator_mode": "tiny_woods_route_fixture",
        },
        "index_gate": index,
        "runs": records,
        "assertions": {
            "opening_d01p01_g1_to_tiny_woods_1f": True,
            "all_three_floors_traversed_by_process_player_input_game_actions": True,
            "natural_clear_routes_to_d01p02_g1": True,
            "failed_result_routes_to_d01p01_g2_and_retry_1f": True,
            "rescue_completion_routes_to_d01p01_g3": True,
            "ending_ground_geometry_collision_actors_placements_and_eu_bgm": True,
            "ending_sheet_installed_in_content_tile_and_binary_index": True,
            "natural_hostile_occupancy_replanned_and_attacked": True,
            "temporary_actors_and_bgm_cleaned_before_reentry": True,
            "no_leader_teleport_used_for_stair_traversal": True,
            "all_native_terminations_load_phase_unload_normal_and_graceful": True,
            "watchdog_signal_sigsegv_forced_kill_or_orphan": False,
        },
        "limitations": [
            "This milestone proves Tiny Woods route/progression mechanics; EU dialogue and full scene choreography remain a later narrative milestone.",
            "The failed branch uses a real GiveUp GameAction carrying ResultType.Failed; natural combat defeat remains covered by the later combat/progression campaign.",
        ],
        "reproduction": {
            "commands": [
                ".runtime-cache/test-venv/bin/python tools/build_pmdred_tiny_woods_route_fixture.py --output .runtime-cache/tiny-woods-route-fixture-repro",
                ".runtime-cache/test-venv/bin/python tools/run_pmdred_tiny_woods_route.py --fixture .runtime-cache/tiny-woods-route-fixture-repro --evidence-dir .runtime-cache/tiny-woods-route-evidence-repro --seed 424242 --timeout-seconds 180",
            ],
            "immutability": "Fixture and evidence destinations must not exist; both tools refuse overwrite.",
        },
    }
    dump(evidence / "native_route_validation.json", report)
    print(
        "TINY_WOODS_ROUTE_PASS scenarios=3 "
        f"actions={records[2]['player_action_count']} evidence={evidence}"
    )
    return 0


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--fixture", type=Path, required=True)
    result.add_argument("--evidence-dir", type=Path, required=True)
    result.add_argument("--seed", type=int, default=424242)
    result.add_argument("--timeout-seconds", type=int, default=180)
    return result


def main() -> int:
    return run(parser().parse_args())


if __name__ == "__main__":
    raise SystemExit(main())
