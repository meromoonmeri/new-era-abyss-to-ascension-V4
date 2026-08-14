#!/usr/bin/env python3
"""Certify Caterpie's authenticated EU efob108 attachment in PMDO 0.8.12."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import signal
import subprocess
from datetime import datetime
from pathlib import Path
from types import ModuleType
from typing import Any
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PARTICLE_SHA256 = "18d392d82c2c8b6aa101aa0a49bab0af58aae16aa6e5aebba92a7bf288f46def"
EVENTS = Path("/tmp/pmdred_efob108_attachment.jsonl")
EXPECTED_FRAMES = [value for frame in range(13) for value in (frame, frame)]
SOURCE_VALIDATOR = ROOT / "tools/pmdred_efob108_attachment_validator.lua"
SOURCE_MODULE = ROOT / "tools/pmdred_efob108_attachment_fixture.lua"
SOURCE_PARTICLE_MANIFEST = ROOT / "docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json"


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


def read_events(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line]


def one(items: list[dict[str, Any]], kind: str) -> dict[str, Any]:
    found = [item for item in items if item.get("event") == kind]
    if len(found) != 1:
        raise ValueError(f"expected one {kind!r} event, observed {len(found)}")
    return found[0]


def authenticate_fixture(fixture: Path) -> dict[str, Any]:
    manifest_path = fixture / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    route = manifest.get("tiny_woods_route", {})
    section = manifest.get("efob108_attachment", {})
    authority = section.get("authority", {})
    isolation = section.get("fixture_isolation", {})
    effect = section.get("native_effect", {})
    validator = fixture / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    module = fixture / "quest/Data/Script/halcyon/pmdred_efob108_attachment_fixture.lua"
    particle_parent = fixture / "quest/Content/Particle"
    particle = particle_parent / "PMDRed_Efob108.dir"
    if (
        route.get("schema") != "pmdred-eu-tiny-woods-route-fixture-v1"
        or route.get("authority", {}).get("region") != "EU"
        or route.get("authority", {}).get("rom_sha256") != ROM_SHA256
        or route.get("route", {}).get("tiny_woods_ground_maps") != ["d01p01", "d01p02"]
        or section.get("schema") != "pmdred-eu-efob108-attachment-fixture-v1"
        or authority.get("region") != "EU"
        or authority.get("rom_sha256") != ROM_SHA256
        or authority.get("effect_sha256") != PARTICLE_SHA256
        or authority.get("source_command_address") != "0x084D5578"
        or authority.get("source_opcode") != "0x56"
        or authority.get("source_arguments") != [62, 0]
        or authority.get("completion_command_address") != "0x084D55A8"
        or authority.get("completion_opcode") != "0xDE"
        or section.get("validator", {}).get("opt_in") != "PMDO_GROUND_VALIDATOR=pmdred_efob108_attachment_fixture"
        or section.get("validator", {}).get("source_sha256") != sha256(SOURCE_VALIDATOR)
        or section.get("validator", {}).get("fixture_sha256") != sha256(validator)
        or sha256(module) != sha256(SOURCE_MODULE)
        or sha256(particle) != PARTICLE_SHA256
        or authority.get("effect_manifest_sha256") != sha256(SOURCE_PARTICLE_MANIFEST)
        or effect.get("expected_frame_indices") != EXPECTED_FRAMES
        or effect.get("duration_frames") != 26
        or effect.get("loc_height") != 4
        or effect.get("draw_size") != [128, 128]
        or isolation.get("built_directly_from_route_fixture") is not True
        or isolation.get("palette_overlay_invoked") is not False
        or isolation.get("particle_parent_private") is not True
        or isolation.get("particle_parent_is_symlink") is not False
        or particle_parent.is_symlink()
        or particle.is_symlink()
    ):
        raise ValueError("attachment fixture identity, authority, semantics, or isolation differs")
    for name, expected in section.get("files", {}).items():
        path = fixture / name
        if path.is_symlink() or not path.is_file() or path.stat().st_size != expected.get("bytes") or sha256(path) != expected.get("sha256"):
            raise ValueError(f"attachment fixture private file differs: {name}")
    # Preserve the route fixture's private adapted files.  Its validator is the
    # sole intentional replacement and is authenticated by the section above.
    replaced = "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    for name, expected in route.get("files", {}).items():
        if name == replaced:
            continue
        path = fixture / name
        if path.is_symlink() or not path.is_file() or path.stat().st_size != expected.get("bytes") or sha256(path) != expected.get("sha256"):
            raise ValueError(f"base route fixture file differs: {name}")
    return manifest


def run_zone_index(fixture: Path, evidence: Path, runner: ModuleType) -> dict[str, Any]:
    command = [
        str(runner.PMDO), "-asset", str(fixture / "asset") + "/",
        "-appdata", str(fixture / "appdata") + "/", "-quest", "pmdred_eu_fixture",
        "-index", "zone",
    ]
    log = evidence / "index.log"
    with log.open("wb") as stream:
        process = subprocess.Popen(
            command, cwd=ROOT, env=runner.pmdo_env("pmdred_efob108_attachment_index_only"),
            stdout=stream, stderr=subprocess.STDOUT, start_new_session=True,
        )
        try:
            return_code = process.wait(timeout=120); timed_out = False
        except subprocess.TimeoutExpired:
            timed_out = True; os.killpg(process.pid, signal.SIGTERM)
            try: return_code = process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL); return_code = process.wait()
    index = fixture / "quest/Data/Zone/index.idx"
    result = {
        "schema": "pmdred-eu-efob108-attachment-zone-index-v1",
        "command": command, "return_code": return_code, "timed_out": timed_out,
        "status": "passed" if return_code == 0 and not timed_out and index.is_file() else "failed",
        "index": {"bytes": index.stat().st_size if index.is_file() else None, "sha256": sha256(index) if index.is_file() else None},
        "log": {"bytes": log.stat().st_size, "sha256": sha256(log)},
    }
    dump(evidence / "index_validation.json", result)
    if result["status"] != "passed":
        raise RuntimeError("exact PMDO attachment zone-index gate failed")
    return result


def validate_trace(items: list[dict[str, Any]]) -> dict[str, Any]:
    if len(items) != 44:
        raise ValueError(f"attachment event count differs: {len(items)}")
    if any(item.get("event") == "fixture_fail" for item in items):
        raise ValueError("native attachment fixture emitted fixture_fail")
    route = one(items, "route_staged")
    ground = one(items, "ground_enter")
    begin = one(items, "fixture_begin")
    starts = one(items, "attachment_started")
    pre = one(items, "attachment_pre_boundary")
    boundary = one(items, "attachment_boundary")
    selected = one(items, "coordinate_convention_selected")
    complete = one(items, "fixture_complete")
    verdict = one(items, "fixture_verdict")
    samples = [item for item in items if item.get("event") == "terminal_walk_sample"]
    completions = [item for item in items if item.get("event") == "terminal_walk_completion"]
    frames = [item for item in items if item.get("event") == "attachment_frame"]
    if (
        route != {"event":"route_staged","attempts":1,"floors_cleared":3,"floors_entered":3,"status":"cleared"}
        or ground.get("ground") != "d01p02" or ground.get("visit") != 1
        or begin.get("actor") != "CATERPIE" or begin.get("species") != "caterpie"
        or begin.get("initial_x") != 180 or begin.get("initial_y") != 148 or begin.get("initial_direction") != "Up: 4"
        or len(samples) != 2 or len(completions) != 2
    ):
        raise ValueError("route, actor staging, or terminal Walk cardinality differs")
    expected_points = {
        "eu_center_literal": (180, 148, 187, 161),
        "pmdo_top_left_normalized": (172, 140, 179, 153),
    }
    for sample in samples:
        expected = expected_points.get(sample.get("candidate"))
        if expected is None or (
            (sample.get("placement_x"), sample.get("placement_y"), sample.get("terminal_head_x"), sample.get("terminal_head_y")) != expected
            or sample.get("native_type") != "RogueEssence.Ground.IdleAnimGroundAction"
            or sample.get("direction") != "Down: 0" or sample.get("anim_id") != sample.get("walk_anim_id")
            or sample.get("anim_id") != 2 or sample.get("action_time_frames") != 28
            or sample.get("anim_total_time_frames") != 30 or sample.get("complete") is not False
            or sample.get("current_action_identity") is not True
        ):
            raise ValueError(f"terminal Walk pre-boundary sample differs: {sample.get('candidate')}")
    for completion in completions:
        expected = expected_points.get(completion.get("candidate"))
        if expected is None or (
            (completion.get("terminal_head_x"), completion.get("terminal_head_y")) != expected[2:]
            or completion.get("native_type") != "RogueEssence.Ground.IdleAnimGroundAction"
            or completion.get("anim_id") != 2 or completion.get("action_time_frames") != 30
            or completion.get("anim_total_time_frames") != 30 or completion.get("complete") is not True
            or completion.get("current_action_identity") is not True
        ):
            raise ValueError(f"terminal Walk completion sample differs: {completion.get('candidate')}")
    if (
        starts.get("native_type") != "RogueEssence.Content.Emote"
        or starts.get("anim_index") != "PMDRed_Efob108" or starts.get("frame_time") != 2
        or starts.get("selected_frames") != 13 or starts.get("cycles") != 1
        or starts.get("duration_frames") != 26 or starts.get("loc_height") != 4
        or (starts.get("draw_width"), starts.get("draw_height")) != (128, 128)
        or (starts.get("head_x"), starts.get("head_y")) != (179, 153)
        or (starts.get("effect_center_x"), starts.get("effect_center_y")) != (179, 149)
    ):
        raise ValueError("native Emote construction or attachment center differs")
    if len(frames) != 26 or [item.get("elapsed_frames") for item in frames] != list(range(26)) or [item.get("selected_frame") for item in frames] != EXPECTED_FRAMES:
        raise ValueError("native efob108 frame chronology differs")
    if any(
        item.get("finished") is not False or item.get("terminal_walk_current") is not True
        or (item.get("head_x"), item.get("head_y")) != (179, 153)
        or (item.get("effect_center_x"), item.get("effect_center_y")) != (179, 149)
        for item in frames
    ):
        raise ValueError("native attachment lifecycle, Head, or effect center differs")
    if pre != {"event":"attachment_pre_boundary","elapsed_frames":25,"finished":False,"selected_frame":12}:
        raise ValueError("efob108 pre-boundary state differs")
    if boundary != {"event":"attachment_boundary","elapsed_frames":26,"finished":True}:
        raise ValueError("efob108 completion boundary differs")
    if (
        selected.get("convention") != "eu_center_to_pmdo_top_left_minus_8_minus_8"
        or (selected.get("source_center_x"), selected.get("source_center_y")) != (180, 148)
        or (selected.get("pmdo_position_x"), selected.get("pmdo_position_y")) != (172, 140)
        or (selected.get("terminal_head_x"), selected.get("terminal_head_y")) != (179, 153)
        or (selected.get("effect_center_x"), selected.get("effect_center_y")) != (179, 149)
        or (selected.get("authenticated_ax_x"), selected.get("authenticated_ax_y")) != (179, 149)
        or selected.get("verdict") != "PASS"
        or complete.get("verdict") != "PASS" or complete.get("effect_frames") != 26
        or complete.get("selected_coordinate_convention") != "normalized_minus_8_minus_8"
        or verdict.get("verdict") != "PASS" or verdict.get("visits") != 1
    ):
        raise ValueError("coordinate convention selection or fixture verdict differs")
    expected_tail = ["fixture_verdict","load_phase_unload_requested","native_deinit","native_graphics_unload","end"]
    if [item.get("event") for item in items[-5:]] != expected_tail:
        raise ValueError("native attachment unload lifecycle differs")
    return {
        "events": len(items), "route": ["tiny_woods:-1:1", "d01p02:g1"],
        "terminal_walk": {"anim_id": 2, "native_type": "RogueEssence.Ground.IdleAnimGroundAction", "total_frames": 30, "completion_sampled_before_transition": True},
        "coordinate_candidates": [
            {"name":"eu_center_literal","position":[180,148],"terminal_head":[187,161]},
            {"name":"pmdo_top_left_normalized","position":[172,140],"terminal_head":[179,153]},
        ],
        "selected_coordinate_convention": "eu_center_to_pmdo_top_left_minus_8_minus_8",
        "effect": {"native_type":"RogueEssence.Content.Emote","frames":13,"frame_time":2,"cycles":1,"duration_frames":26,"loc_height":4,"draw_size":[128,128],"effect_center":[179,149],"frame_indices":EXPECTED_FRAMES,"finished_at_frame":26},
    }


def strict_termination(path: Path) -> dict[str, Any]:
    record = json.loads(path.read_text(encoding="utf-8"))
    required = {
        "result":"PASS", "exit_classification":"NORMAL_EXIT", "return_code":0,
        "terminal":True, "graceful":True, "watchdog":False, "requested_signal":None,
        "sigsegv":False, "forced_kill":False, "orphan_process":False,
    }
    if any(record.get(key) != value for key, value in required.items()):
        raise ValueError("strict native attachment termination differs")
    return record


def run(args: argparse.Namespace) -> int:
    fixture = args.fixture.resolve(); evidence = args.evidence_dir.resolve()
    if evidence.exists():
        raise FileExistsError(f"refusing to overwrite attachment evidence: {evidence}")
    runner = load_tool("run_pmdred_eu_native_fixture")
    if sha256(runner.PMDO) != PMDO_SHA256:
        raise ValueError("PMDO executable is not authenticated exact 0.8.12")
    manifest = authenticate_fixture(fixture)
    evidence.mkdir(parents=True)
    dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(SOURCE_VALIDATOR, evidence / "validator.lua")
    shutil.copyfile(SOURCE_MODULE, evidence / "attachment_fixture.lua")
    shutil.copyfile(SOURCE_PARTICLE_MANIFEST, evidence / "efob108_particle_manifest.json")
    index = run_zone_index(fixture, evidence, runner)

    wrapper = fixture / args.run_name
    if wrapper.exists(): raise FileExistsError(wrapper)
    wrapper.mkdir(); (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True); (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
    namespace = argparse.Namespace(
        fixture=wrapper, ground="efob108_attachment", expected_screenshots=0,
        timeout_seconds=args.timeout_seconds, events=EVENTS,
        validator_mode="pmdred_efob108_attachment_fixture",
        environment=[f"PMDRED_EFOB108_SEED={args.seed}"],
    )
    runner.run(namespace)
    for filename in ("runtime.log", "events.jsonl", "termination.json"):
        shutil.copyfile(wrapper / filename, evidence / filename)
    trace = validate_trace(read_events(evidence / "events.jsonl"))
    termination = strict_termination(evidence / "termination.json")
    report = {
        "schema":"pmdred-eu-efob108-attachment-native-v1",
        "date":str(datetime.now(ZoneInfo("Europe/Paris")).date()), "status":"passed",
        "authority": {
            "region":"EU", "rom_sha256":ROM_SHA256,
            "source_owner":"s_gs179_g1_s0_lives2_dlg0", "source_command_address":"0x084D5578",
            "source_opcode":"0x56", "source_arguments":[62,0],
            "completion_command_address":"0x084D55A8", "completion_opcode":"0xDE",
            "particle_sha256":PARTICLE_SHA256,
            "particle_manifest_sha256":sha256(SOURCE_PARTICLE_MANIFEST),
        },
        "runtime":{"version":"0.8.12.0","executable_sha256":PMDO_SHA256,"validator_mode":"pmdred_efob108_attachment_fixture"},
        "index_gate":index, "trace":trace,
        "termination": {key:termination[key] for key in ("exit_classification","return_code","terminal","graceful","watchdog","requested_signal","sigsegv","forced_kill","orphan_process")},
        "evidence": {name:{"bytes":(evidence/name).stat().st_size,"sha256":sha256(evidence/name)} for name in ("events.jsonl","runtime.log","termination.json")},
        "assertions": {
            "direct_and_normalized_eu_coordinate_candidates_sampled_natively":True,
            "normalized_minus_8_minus_8_matches_authenticated_ax_attachment":True,
            "down_facing_non_looping_walk_terminal_frame_and_completion_sampled_before_idle_transition":True,
            "actual_groundchar_startemote_path_updates_one_native_emote":True,
            "actual_terminal_head_and_emote_loc_height_produce_effect_center_179_149":True,
            "all_26_native_frame_selections_match_13_frame_two_tick_strip":True,
            "finished_is_false_at_frame_25_and_true_at_frame_26":True,
            "load_phase_unload_normal_exit_rc0_terminal_graceful_without_watchdog_signal_sigsegv_kill_or_orphan":True,
        },
        "scope": [
            "This bounded fixture selects the coordinate convention and certifies opcode 0x56/0xDE attachment semantics needed by the pending Tiny Woods command supplement.",
            "It does not by itself claim integration of the remaining 304 pending commands; that is a subsequent serialized promotion gate.",
        ],
        "reproduction": {
            "commands":[
                ".runtime-cache/test-venv/bin/python tools/build_pmdred_efob108_particle.py --output Content/Particle/PMDRed_Efob108.dir --manifest docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json",
                ".runtime-cache/test-venv/bin/python tools/build_pmdred_efob108_attachment_fixture.py --output .runtime-cache/pmdred-efob108-attachment-repro",
                ".runtime-cache/test-venv/bin/python tools/run_pmdred_efob108_attachment_certification.py --fixture .runtime-cache/pmdred-efob108-attachment-repro --evidence-dir .runtime-cache/pmdred-efob108-attachment-evidence-repro --seed 424242 --timeout-seconds 180",
            ],
            "immutability":"Particle, fixture, and evidence outputs are create-only and refuse overwrite.",
        },
    }
    dump(evidence / "native_attachment_validation.json", report)
    print(f"PMDRED_EFOB108_ATTACHMENT_NATIVE_PASS frames=26 center=179,149 convention=normalized_minus_8_minus_8 evidence={evidence}")
    return 0


def main() -> int:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fixture',type=Path,required=True);parser.add_argument('--evidence-dir',type=Path,required=True)
    parser.add_argument('--seed',type=int,default=424242);parser.add_argument('--timeout-seconds',type=int,default=180)
    parser.add_argument('--run-name',default='certification-run',help='create-only wrapper directory inside the fixture')
    return run(parser.parse_args())


if __name__ == '__main__':
    raise SystemExit(main())
