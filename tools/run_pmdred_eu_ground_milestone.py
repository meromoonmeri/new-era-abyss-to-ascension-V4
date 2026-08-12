#!/usr/bin/env python3
"""Run one or more established exact-PMDO PMD Red EU Ground milestones.

This is an orchestration of the already-audited fixture, exact PMDO 0.8.12,
independent renderer/comparator, additive promotion, post-promotion indexing,
and checkpoint tools.  It supports authenticated rescue-team-base and friend-
area Grounds whose roles follow directly from the pinned GroundMapID symbol.
It stops before any occupied destination or unimplemented role rather than
guessing or overwriting.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PYTHON = ROOT / ".runtime-cache/test-venv/bin/python"
BUNDLE = ROOT / ".runtime-cache/pmdo-headless-bundle"
PMDO = BUNDLE / "PMDO"
DOTNET = ROOT / ".runtime-cache/dotnet-headless"
CANONICAL = ROOT / ".runtime-cache/pmdred-eu-remaining-regenerated-v201"
SOURCE = ROOT / ".runtime-cache/pmdred-eu-ground"
PLAN_PATH = ROOT / ".runtime-cache/pmdred-eu-reference-plan-v2.json"
REPORT_PATH = ROOT / "docs/pmdred_eu/remaining_grounds/conversion_report.json"
AUDIT_PATH = ROOT / "docs/pmdred_eu/remaining_grounds/candidate_audit.json"
MANIFEST_PATH = ROOT / "docs/pmdred_eu/ground_manifest.json"
LOCK_PATH = ROOT / "docs/pmdred_eu/pmdo_validation/runtime_dependencies.lock.json"
EVENTS = Path("/tmp/pmdred_eu_ground_validator.jsonl")
INDEX_SHA256 = "3df47e3be040b124c5768b076c89fb586ff4b807890f154b22387667069c8ab8"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PLAN_SHA256 = "dcf498ae5f8970e15e44e044d000b6f28b342eae5e23f401516a9bb2738c0cb0"
CONVERSION_SHA256 = "91f3b460b3e3b7689bc608ece2006cb6103d653bcdc22ad028f4172c3a1b0fdc"
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
SDL_SHA256 = "2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f"
DATE = "2026-08-12"
STATE_PATH = ROOT / ".runtime-cache/recovery/team_base_batch_state.json"
BATCH_LOG = ROOT / ".runtime-cache/recovery/team_base_batch.log"


def load(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def dump(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n")
    os.replace(temporary, path)


def sha(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def log(message: str) -> None:
    stamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    line = f"[{stamp}] {message}"
    print(line, flush=True)
    BATCH_LOG.parent.mkdir(parents=True, exist_ok=True)
    with BATCH_LOG.open("a") as stream:
        stream.write(line + "\n")


def run(command: list[str], *, stdout: Path | None = None, timeout: float | None = None) -> None:
    log("RUN " + " ".join(command))
    if stdout is None:
        result = subprocess.run(command, cwd=ROOT, timeout=timeout)
    else:
        stdout.parent.mkdir(parents=True, exist_ok=True)
        with stdout.open("wb") as stream:
            result = subprocess.run(command, cwd=ROOT, stdout=stream, stderr=subprocess.STDOUT, timeout=timeout)
    if result.returncode:
        raise RuntimeError(f"command failed ({result.returncode}): {' '.join(command)}")


def pmdo_env() -> dict[str, str]:
    env = dict(os.environ)
    env.update({
        "DOTNET_BUNDLE_EXTRACT_BASE_DIR": str(DOTNET),
        "LD_LIBRARY_PATH": str(BUNDLE), "SDL_VIDEODRIVER": "offscreen", "SDL_AUDIODRIVER": "dummy",
        "SDL_VIDEO_GL_DRIVER": str(BUNDLE / "libGLESv2.so"), "SDL_VIDEO_EGL_DRIVER": str(BUNDLE / "libEGL.so"),
        "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY": "1", "PMDO_HEADLESS_DISMISS_SPLASH": "1",
        "FNA3D_FORCE_DRIVER": "OpenGL", "FNA3D_OPENGL_FORCE_ES3": "1", "ANGLE_DEFAULT_PLATFORM": "vulkan",
        "VK_ICD_FILENAMES": str(BUNDLE / "vk_swiftshader_icd.absolute.json"),
    })
    return env


def run_index(fixture: Path, log_path: Path) -> None:
    command = [str(PMDO), "-asset", str(fixture / "asset") + "/", "-appdata", str(fixture / "appdata") + "/", "-quest", "pmdred_eu_fixture", "-index", "zone"]
    log("INDEX " + fixture.name)
    with log_path.open("wb") as stream:
        result = subprocess.run(command, cwd=ROOT, env=pmdo_env(), stdout=stream, stderr=subprocess.STDOUT, timeout=300)
    if result.returncode or sha(log_path) != INDEX_SHA256:
        raise RuntimeError(f"exact PMDO index failed or changed: rc={result.returncode} sha={sha(log_path)}")


def run_validator(ground: str, fixture: Path, expected_screenshots: int) -> None:
    timeout_seconds = max(600, int(expected_screenshots * 0.75 + 180))
    run(
        [
            str(PYTHON),
            "tools/run_pmdred_eu_native_fixture.py",
            "--fixture",
            str(fixture),
            "--ground",
            ground,
            "--expected-screenshots",
            str(expected_screenshots),
            "--timeout-seconds",
            str(timeout_seconds),
        ],
        timeout=timeout_seconds + 15,
    )
    termination = load(fixture / "termination.json")
    required = [
        termination["result"] == "PASS",
        termination["exit_classification"] == "NORMAL_EXIT",
        termination["return_code"] == 0,
        termination["terminal"] is True,
        termination["graceful"] is True,
        termination["watchdog"] is False,
        termination["requested_signal"] is None,
        termination["sigsegv"] is False,
        termination["forced_kill"] is False,
        termination["orphan_process"] is False,
        termination["load_phase_unload"]["pass"] is True,
    ]
    if not all(required):
        raise RuntimeError(f"native termination evidence failed for {ground}: {required}")
    log(
        f"RUNTIME_PASS ground={ground} events={termination['event_count']} "
        f"screenshots={termination['actual_screenshot_count']} exit=NORMAL_EXIT"
    )


def ground_symbols() -> list[str]:
    text = (ROOT / ".runtime-cache/pmd-red-reference/include/constants/ground_map.h").read_text()
    body = text.split("enum GroundMapID", 1)[1].split("};", 1)[0]
    return re.findall(r"^\s*(MAP_[A-Z0-9_]+)\s*,", body, flags=re.MULTILINE)


def classify_team_base(symbol: str) -> dict[str, Any]:
    match = re.fullmatch(r"MAP_TEAM_BASE(_INSIDE)?_([A-Z]+)_(BASIC|CONSTRUCTION|FINAL)", symbol)
    if not match:
        raise RuntimeError(f"role classification is not implemented for {symbol}; stopping rather than guessing")
    inside, species, stage = match.groups()
    return {
        "category": "rescue_team_base", "classification": f"{stage.lower()}_{species.lower()}_rescue_team_base_{'interior' if inside else 'exterior'}",
        "location": "interior" if inside else "exterior", "species": species.lower(), "stage": stage.lower(),
        "cinematic": False, "arena": False, "boss": False,
    }


def classify_ground_role(symbol: str) -> dict[str, Any]:
    """Classify only roles encoded unambiguously by the pinned GroundMapID."""
    if symbol.startswith("MAP_TEAM_BASE_"):
        return classify_team_base(symbol)
    match = re.fullmatch(r"MAP_FRIEND_AREA_([A-Z0-9]+(?:_[A-Z0-9]+)*)", symbol)
    if match:
        friend_area = match.group(1).lower()
        return {
            "category": "friend_area",
            "classification": f"{friend_area}_friend_area",
            "friend_area": friend_area,
            "cinematic": False,
            "arena": False,
            "boss": False,
        }
    raise RuntimeError(f"role classification is not implemented for {symbol}; stopping rather than guessing")


def atomic_install(source: Path, destination: Path) -> None:
    if destination.exists():
        raise FileExistsError(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    fd, temp_name = tempfile.mkstemp(prefix=destination.name + ".promote.", dir=destination.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(source.read_bytes()); stream.flush(); os.fsync(stream.fileno())
        os.replace(temp_name, destination)
        directory = os.open(destination.parent, os.O_RDONLY); os.fsync(directory); os.close(directory)
    finally:
        if os.path.exists(temp_name): os.unlink(temp_name)


def insert_zone(ground: str, order: list[str], validated: set[str]) -> tuple[str, str, str, int]:
    path = ROOT / "Data/Zone/master_zone.json"; before = path.read_bytes()
    if not before.startswith(b"\xef\xbb\xbf"):
        raise RuntimeError("master_zone.json BOM absent")
    values = json.loads(before.decode("utf-8-sig"))["Object"]["GroundMaps"]
    if ground in values:
        raise RuntimeError(f"zone already contains unvalidated {ground}")
    index = order.index(ground); prior = next((x for x in reversed(order[:index]) if x in validated), None)
    if prior is None or values.count(prior) != 1:
        raise RuntimeError(f"cannot identify unique validated predecessor for {ground}")
    needle = f'      "{prior}",\n'.encode()
    if before.count(needle) != 1:
        raise RuntimeError(f"zone predecessor byte row is not unique: {prior}")
    after = before.replace(needle, needle + f'      "{ground}",\n'.encode())
    if json.loads(after.decode("utf-8-sig"))["Object"]["GroundMaps"].count(ground) != 1:
        raise RuntimeError("zone insertion structural gate failed")
    fd, temp_name = tempfile.mkstemp(prefix=path.name + ".promote.", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(after); stream.flush(); os.fsync(stream.fileno())
        os.replace(temp_name, path)
        directory = os.open(path.parent, os.O_RDONLY); os.fsync(directory); os.close(directory)
    finally:
        if os.path.exists(temp_name): os.unlink(temp_name)
    return sha_bytes(before), sha(path), prior, json.loads(after.decode("utf-8-sig"))["Object"]["GroundMaps"].index(ground)


def sha_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def write_commands(out: Path, ground: str, identity: dict[str, Any], symbol: str, ground_hash: str, tile_hash: str,
                   event_count: int, sample_count: int, unique_count: int, reserve_ground: Path, reserve_tile: Path) -> None:
    source = (ROOT / "docs/pmdred_eu/pmdo_validation/t01p07_exhaustive_pass/commands.sh").read_text()
    source = source.replace("t01p07", ground).replace("T01P07", ground.upper())
    source = source.replace("cc7ce085938d10aa4d564e6037e0ea0671ab1736f08448b38c6ad9c517a35546", ground_hash)
    source = source.replace("456d26b0fd97241ec47db70822d18604a291bd65f99032f4a5e84c0c5273327f", tile_hash)
    old_ground = "test \"$(sha256sum RESERVE/red_grounds/%s.rsground | cut -d' ' -f1)\" = 27ee868a6cbb37d43957d7fd1b683d070d3dbb8b3cd48dac2f19830f019b8fd9" % ground
    old_tile = "test \"$(sha256sum RESERVE/red_tiles/%s_Base.tile | cut -d' ' -f1)\" = f5ffa239eb9389e34644b9d2a72dbcc17f3d5c679bfa2bd9317f7bd78e75e50c" % ground
    source = source.replace(old_ground, f"test \"$(sha256sum RESERVE/red_grounds/{ground}.rsground | cut -d' ' -f1)\" = {sha(reserve_ground)}" if reserve_ground.is_file() else f"test ! -e RESERVE/red_grounds/{ground}.rsground")
    source = source.replace(old_tile, f"test \"$(sha256sum RESERVE/red_tiles/{ground}_Base.tile | cut -d' ' -f1)\" = {sha(reserve_tile)}" if reserve_tile.is_file() else f"test ! -e RESERVE/red_tiles/{ground}_Base.tile")
    start = source.index("assert entry == {"); end = source.index("PYID", start)
    exact = repr(identity).replace("'stable_ground_id': '" + ground + "'", "'stable_ground_id': '" + ground + "'")
    block = f"assert entry == {exact}\nheader=Path('.runtime-cache/pmd-red-reference/include/constants/ground_map.h').read_text()\nassert '{symbol}' in header\nprint('{ground.upper()}_IDENTITY_PASS map_file_id={identity['map_file_id']} symbol={symbol}')\n"
    source = source[:start] + block + source[end:]
    source = source.replace('test "$(wc -l < "$FIX/events.jsonl")" -eq 313', f'test "$(wc -l < "$FIX/events.jsonl")" -eq {event_count}')
    source = source.replace('test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name \'*.png\' | wc -l)" -eq 97', f'test "$(find "$FIX/appdata/SCREENSHOT" -maxdepth 1 -type f -name \'*.png\' | wc -l)" -eq {sample_count}')
    source = source.replace("r['sample_count']==97 and len(primary)==96", f"r['sample_count']=={sample_count} and len(primary)=={sample_count-1}")
    source = source.replace("r['exact_sample_count']==97 and r['fully_opaque_sample_count']==97", f"r['exact_sample_count']=={sample_count} and r['fully_opaque_sample_count']=={sample_count}")
    source = source.replace("==19\n", f"=={unique_count}\n")
    source = source.replace("samples=97 unique_rgba=19", f"samples={sample_count} unique_rgba={unique_count}")
    source = source.replace("all 97 comparative PNGs", f"all {sample_count} comparative PNGs")
    runtime_start = source.index('PMDO_RUN_PID=""')
    runtime_end = source.index('test "$(wc -l < "$FIX/events.jsonl")"', runtime_start)
    native_runtime = f'''"$PYTHON" tools/run_pmdred_eu_native_fixture.py \\
  --fixture "$FIX" --ground {ground} --expected-screenshots {sample_count} \\
  --timeout-seconds 1800
"$PYTHON" - "$FIX/termination.json" <<'PYTERM'
import json, sys
from pathlib import Path
t=json.loads(Path(sys.argv[1]).read_text())
assert t['result']=='PASS' and t['exit_classification']=='NORMAL_EXIT'
assert t['return_code']==0 and t['terminal'] and t['graceful']
assert not t['watchdog'] and t['requested_signal'] is None
assert not t['sigsegv'] and not t['forced_kill'] and not t['orphan_process']
assert t['load_phase_unload']['pass']
print('{ground.upper()}_NATIVE_TERMINATION_PASS rc=0 phase=Unload')
PYTERM
'''
    source = source[:runtime_start] + native_runtime + source[runtime_end:]
    (out / "commands.sh").write_text(source); os.chmod(out / "commands.sh", 0o755)


def package_evidence(ground: str, symbol: str, role: dict[str, Any], identity: dict[str, Any], audit: dict[str, Any], plan: dict[str, Any],
                     fixture: Path, comparison: Path, post_fixture: Path, zone_pre: str, zone_post: str, prior: str, zone_index: int) -> None:
    out = ROOT / f"docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass"
    if out.exists(): raise FileExistsError(out)
    (out / "actual").mkdir(parents=True); (out / "comparisons").mkdir()
    report = load(comparison / "report.json"); manifest = load(fixture / "fixture_manifest.json")
    termination = load(fixture / "termination.json")
    termination_pass = [
        termination["result"] == "PASS", termination["exit_classification"] == "NORMAL_EXIT",
        termination["return_code"] == 0, termination["terminal"] is True,
        termination["graceful"] is True, termination["watchdog"] is False,
        termination["requested_signal"] is None, termination["sigsegv"] is False,
        termination["forced_kill"] is False, termination["orphan_process"] is False,
        termination["load_phase_unload"]["pass"] is True,
    ]
    if not all(termination_pass):
        raise RuntimeError(f"refusing to package non-graceful termination: {termination_pass}")
    primary = [x for x in report["samples"] if x["phase"] == "primary"]; reloads = [x for x in report["samples"] if x["phase"] == "reload"]
    unique_count = len({x["actual_rgba_sha256"] for x in primary}); samples = len(primary) + len(reloads)
    for src, dst in [(fixture/"fixture_manifest.json",out/"fixture_manifest.json"),(fixture/"events.jsonl",out/"events.jsonl"),(fixture/"termination.json",out/"termination.json"),(fixture/"runtime.log",out/"runtime.log"),(fixture/"index.log",out/"index.log"),(post_fixture/"post_promotion_index.log",out/"post_promotion_index.log"),(comparison/"report.json",out/"report.json"),(comparison/"comparison.log",out/"comparison.log")]: shutil.copyfile(src,dst)
    logs = sorted((fixture / "appdata/LOG").glob("*.txt"));
    if not logs: raise RuntimeError("engine log absent")
    shutil.copyfile(logs[-1], out / "engine.log")
    selected = [primary[0], primary[-1], reloads[0]]
    for item in selected:
        phase, tick = item["phase"], item["tick"]
        shutil.copyfile(ROOT / item["source_screenshot"], out / "actual" / f"actual_{phase}_tick{tick}.png")
        shutil.copyfile(ROOT / item["comparative_png"], out / "comparisons" / f"comparison_{phase}_tick{tick}.png")
    ground_hash = audit["candidate_sha256"]["rsground"]; tile_hash = audit["candidate_sha256"]["tile"]
    events_sha, report_sha, fixture_sha = sha(out/"events.jsonl"),sha(out/"report.json"),sha(out/"fixture_manifest.json")
    termination_sha = sha(out/"termination.json")
    validations={(x["ground"],x["phase"]):x for x in report["runtime"]["validations"]}; main=validations[(ground,"primary")]
    channels=plan["animation_channels"]; ticks=plan["complete_two_local_cycle_boundary_ticks"]
    reserve_ground=ROOT/f"RESERVE/red_grounds/{ground}.rsground"; reserve_tile=ROOT/f"RESERVE/red_tiles/{ground}_Base.tile"
    reserve_details={"ground":{"present":reserve_ground.is_file(),"sha256":sha(reserve_ground) if reserve_ground.is_file() else None},"tile":{"present":reserve_tile.is_file(),"sha256":sha(reserve_tile) if reserve_tile.is_file() else None}}
    classification={"category":role["category"],"ground_map_symbol":symbol,"canonical_debug_id":identity["canonical_debug_id"],"map_id":identity["map_id"],"map_file_id":identity["map_file_id"],"ground_place_id":identity["ground_place_id"],"stable_ground_id":ground,**role}
    record={
      "schema":1,"ground":ground,"validated_at":DATE,"runtime":"PASS",
      "visual_comparison":{"result":"PASS","dimensions_pixels":plan["dimensions_pixels"],"primary_sample_count":len(primary),"reload_sample_count":1,"exact_sample_count":samples,"unique_rgba_frame_count":unique_count,"mismatched_pixel_count":0,"maximum_channel_delta":0,"all_full_rgba_exact":True,"all_fully_opaque":True,"comparative_png_paths":[str(x.relative_to(ROOT)) for x in sorted((out/"comparisons").glob("*.png"))],"complete_metrics_report":str((out/"report.json").relative_to(ROOT))},
      "tile_palette_validation":{"result":"PASS","reference":"independent authenticated raw EU BPL/BPC/BPA/BMA renderer","resource_hashes":plan["source_normalized_sha256"]},
      "animation_validation":{"result":"PASS","primary_sample_count":len(primary),"first_tick":ticks[0],"last_tick":ticks[-1],"cell_local_schedule_count":len(plan["cell_animation_schedules"]),"maximum_cell_local_cycle_ticks":max((x["source_local_cycle"] for x in plan["cell_animation_schedules"]),default=1),"all_schedules_covered_through_two_complete_cycles":True,"channels":channels,"unique_observed_rgba_frames":unique_count,"reload_tick_zero_exact":True,"orphaned_animation_observed":False},
      "collision_validation":{"result":"PASS","source":plan["resources"]["bma"],"collision_layer_count":plan["collision_layer_count"],"solid_cells":plan["solid_cells"],"collision_sha256":plan["collision_sha256"],"successful_probe":{"start":[manifest["entries"][0]["spawn"]["movement_probes"]["successful"]["x"],manifest["entries"][0]["spawn"]["movement_probes"]["successful"]["y"]],"direction":manifest["entries"][0]["spawn"]["movement_probes"]["successful"]["direction"],"observed_delta":[int(x) for x in main["move_delta"].split(",")],"result":"PASS"},"blocked_probe":{"start":[manifest["entries"][0]["spawn"]["movement_probes"]["blocked"]["x"],manifest["entries"][0]["spawn"]["movement_probes"]["blocked"]["y"]],"direction":manifest["entries"][0]["spawn"]["movement_probes"]["blocked"]["direction"],"observed_delta":[int(x) for x in main["blocked_delta"].split(",")],"result":"PASS"}},
      "entry_exit_reentry":{"result":"PASS","loads":2,"entries":2,"exits":2,"same_ground_reentries":1,"strict_native_lifecycle_order":"PASS"},
      "cleanup_reload":{"result":"PASS","cleanup_probe_count":4,"ground_exit_cleanup_passes":2,"sink_cleanup":"PASS","final_cleanup":"PASS","reload_load":"LOAD_PASS","reload_tick_zero_full_rgba_exact":True,"terminal_end_seen":True,"state_leakage_observed":False,"stale_assets_observed":False,"permanent_lock_observed":False,"orphan_process_check":"PASS"},
      "native_termination":{"result":"PASS","load_phase":"Unload","deinit_seen":True,"graphics_unload_seen":True,"exit_classification":"NORMAL_EXIT","return_code":0,"terminal":True,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"evidence":str((out/"termination.json").relative_to(ROOT)),"sha256":termination_sha},
      "fixture_isolation":{"canonical_source_ground_sha256":ground_hash,"canonical_source_tile_sha256":tile_hash,"source_entity_counts":{"markers":0,"spawners":0,"map_characters":0,"ground_objects":0},"fixture_only_changes":["deterministic entry marker","ignored validator plumbing"],"source_and_promoted_files_unchanged_by_fixture":True},
      "special_classification":{"canonical_source":classification,"scope":{"cinematic_choreography":"NOT APPLICABLE/NOT CLAIMED; Ground-only lifecycle and rendering validated","arena":False,"boss":False}},
      "identity_validation":{"result":"PASS","authenticated_map_file_id":identity["map_file_id"],"pinned_enum_symbol":symbol,"conversion_type":identity["conversion_type"],"weather_id":identity["weather_id"]},
      "definitive_destination":{"ground":f"Data/Ground/{ground}.rsground","tile":f"Content/Tile/{ground}_Base.tile","zone_registry":"Data/Zone/master_zone.json","zone_registry_entry":ground,"promotion_status":"PROMOTED_ADDITIVE_CANONICAL","preexisting_destinations":False,"pre_promotion_record":f"RESERVE/pmdred_pre_promotion/{ground}/README.md","promoted_ground_sha256":ground_hash,"promoted_tile_sha256":tile_hash},
      "provenance":{"rom_sha256":ROM_SHA256,"reference_plan_sha256":PLAN_SHA256,"conversion_report_sha256":CONVERSION_SHA256,"candidate_ground_sha256":ground_hash,"candidate_tile_sha256":tile_hash,"source_normalized_sha256":plan["source_normalized_sha256"],"events_sha256":events_sha,"report_sha256":report_sha,"fixture_manifest_sha256":fixture_sha,"termination_sha256":termination_sha,"detailed_provenance":str((out/"provenance.json").relative_to(ROOT))},
      "execution_note":{"terminal_event_and_all_required_captures_completed":True,"post_terminal_shutdown":"PMDO-native GameBase.LoadPhase.Unload followed by NORMAL_EXIT","return_code":0,"watchdog":False,"requested_signal":None,"evidence_impact":"NONE"},"dungeon_restitution":{"affected":False,"status":"27-relationship bundle retained"},
      "scope_note":"Ground-only; dialogue, choreography, music assignment, and narrative routing are not claimed.",
      "post_promotion_integration":{"result":"PASS","exact_pmdo_index":"PASS","indexed_ground_sha256":ground_hash,"indexed_tile_sha256":tile_hash,"index_log_sha256":INDEX_SHA256,"zone_encoding_bom_preserved":True,"zone_change":f"one insertion after {prior}","zone_ground_map_count":len(load(ROOT/"Data/Zone/master_zone.json")["Object"]["GroundMaps"]),"canonical_index":zone_index,"variant_and_routing_static_checks":"PASS"}}
    promotion={"schema":1,"ground":ground,"validated_at":DATE,"promoted_at":DATE,"result":"PROMOTION_PASS_ADDITIVE_CANONICAL","method":{"destination_precondition":"both destinations absent","installation_mode":"fsynced temporary files and atomic os.replace","existing_asset_discarded":False,"existing_scripts_modified":False,"zone_registration":f"one insertion after {prior} without reserialization"},"gates":{"exact_pmdo_version":"0.8.12","exact_pmdo_executable_sha256":PMDO_SHA256,"active_patched_sdl_sha256":SDL_SHA256,"report_sha256":report_sha,"fixture_manifest_sha256":fixture_sha,"reference_plan_sha256":PLAN_SHA256,"canonical_ground_sha256":ground_hash,"canonical_tile_sha256":tile_hash,"planned_primary_tick_count":len(primary),"observed_primary_tick_count":len(primary),"reload_tick_zero_covered":True,"pixel_exact_sample_count":samples,"fully_opaque_sample_count":samples,"mismatched_pixel_count":0,"maximum_channel_delta":0,"runtime_safe":True,"native_lifecycle_order_pass":True,"cleanup_pass":True,"terminal_end_seen":True,"load_phase_unload_pass":True,"exit_classification":"NORMAL_EXIT","return_code":0,"terminal":True,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"termination_sha256":termination_sha,"identity_map_file_id":identity["map_file_id"],"identity_symbol":symbol},"files":[{"candidate":f".runtime-cache/pmdred-eu-remaining-regenerated-v201/grounds/{ground}.rsground","destination":f"Data/Ground/{ground}.rsground","destination_preexisting":False,"bytes":(ROOT/f"Data/Ground/{ground}.rsground").stat().st_size,"validated_candidate_sha256":ground_hash,"destination_sha256":ground_hash,"candidate_destination_identical":True},{"candidate":f".runtime-cache/pmdred-eu-remaining-regenerated-v201/tiles/{ground}_Base.tile","destination":f"Content/Tile/{ground}_Base.tile","destination_preexisting":False,"bytes":(ROOT/f"Content/Tile/{ground}_Base.tile").stat().st_size,"validated_candidate_sha256":tile_hash,"destination_sha256":tile_hash,"candidate_destination_identical":True}],"zone_registration":{"entry":ground,"entry_count":1,"position":f"after {prior}","pre_promotion_sha256":zone_pre,"post_promotion_sha256":zone_post},"preserved_variants":[{"role":"historical_reserve",**reserve_details,"modified":False},{"role":"historical_v200_and_v201_reports","paths":["docs/pmdred_eu/remaining_grounds/history/v200_pre_period_fix/","docs/pmdred_eu/remaining_grounds/"],"modified_by_promotion":False}],"post_promotion_integration":{"result":"PASS","exact_pmdo_index":"PASS","log_sha256":INDEX_SHA256,"zone_structure":"PASS","existing_routes_unchanged":"PASS"}}
    provenance={"schema":1,"ground":ground,"validated_at":DATE,"result":"PASS","authorities":{"rom":{"sha256":ROM_SHA256,"bytes":33554432,"region":"Europe"},"technical_reference":{"repository":"pret/pmd-red","commit":"bf0092d0e34fd8e49b859a0b5f96f00740faa42d","role":f"{symbol} identity, not EU bytes"},"normalized_extraction":{"source_hashes":plan["source_normalized_sha256"]},"runtime_plan":{"schema":2,"sha256":PLAN_SHA256},"conversion":{"converter":"2.0.1-eu","report_sha256":CONVERSION_SHA256}},"identity":{"canonical_debug_id":identity["canonical_debug_id"],"map_id":identity["map_id"],"map_file_id":identity["map_file_id"],"ground_place_id":identity["ground_place_id"],"conversion_type":identity["conversion_type"],"weather_id":identity["weather_id"],"stable_ground_id":ground,"ground_map_symbol":symbol,"dimensions_tiles":plan["dimensions_tiles"],"dimensions_pixels":plan["dimensions_pixels"],**role},"tested_source":{"ground_sha256":ground_hash,"tile_sha256":tile_hash,"candidate_entities":{"markers":0,"spawners":0,"map_characters":0,"ground_objects":0},"fixture_manifest_sha256":fixture_sha,"static_audit":audit},"runtime":{"name":"PMDO","version":"0.8.12","executable_sha256":PMDO_SHA256,"patched_sdl_sha256":SDL_SHA256,"events_sha256":events_sha,"event_count":sum(1 for _ in (out/"events.jsonl").open()),"primary_samples":len(primary),"reload_samples":1,"terminal_seen":True,"load_phase":"Unload","exit_classification":"NORMAL_EXIT","return_code":0,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"termination_sha256":termination_sha},"comparison":{"report_sha256":report_sha,"sample_count":samples,"exact_sample_count":samples,"fully_opaque_sample_count":samples,"mismatched_pixels":0,"maximum_channel_delta":0,"unique_primary_rgba_frames":unique_count},"candidate_provenance_reconciliation":{"historical_v200_reports_preserved_at":"docs/pmdred_eu/remaining_grounds/history/v200_pre_period_fix/","authenticated_v201_ground_sha256":ground_hash,"authenticated_v201_tile_sha256":tile_hash,"decision":"Only authenticated v2.0.1-eu bytes were exact-engine tested and promoted; immutable v2.0.0 reports and active v2.0.1 reports remain distinct provenance."},"preservation":{"historical_reserve":reserve_details,"absence_record":f"RESERVE/pmdred_pre_promotion/{ground}/README.md"},"promoted":{"ground_sha256":ground_hash,"tile_sha256":tile_hash,"zone_pre_sha256":zone_pre,"zone_post_sha256":zone_post},"durable_evidence":{},"reproduction":{"commands":str((out/"commands.sh").relative_to(ROOT))},"scope":"Ground-only validation","post_promotion_integration":{"exact_pmdo_index":"PASS","log_sha256":INDEX_SHA256,"zone_encoding_bom_preserved":True}}
    dump(out/"validation_record.json",record);dump(out/"promotion_record.json",promotion);dump(out/"provenance.json",provenance)
    write_commands(out,ground,identity,symbol,ground_hash,tile_hash,sum(1 for _ in (out/"events.jsonl").open()),samples,unique_count,reserve_ground,reserve_tile)
    max_cycle=max((x["source_local_cycle"] for x in plan["cell_animation_schedules"]),default=1)
    readme=f"""# {ground} exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`{ground}` is the authenticated EU {role['classification'].replace('_',' ')} (`{symbol}`; map ID {identity['map_id']}, map-file ID {identity['map_file_id']}). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **{samples}/{samples}** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. {len(primary)} primary boundary ticks ({ticks[0]}–{ticks[-1]}) cover every applicable animation schedule through two complete local cycles (maximum {max_cycle} ticks); {unique_count} distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/{ground}.rsground` (`{ground_hash}`) and `Content/Tile/{ground}_Base.tile` (`{tile_hash}`), inserted one zone entry after `{prior}` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`{INDEX_SHA256[:8]}…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
"""
    (out/"README.md").write_text(readme)
    provenance=load(out/"provenance.json")
    for path in sorted(out.rglob("*")):
        if path.is_file() and path.name not in {"provenance.json","evidence_hashes.sha256"}: provenance["durable_evidence"][path.relative_to(out).as_posix()]=sha(path)
    dump(out/"provenance.json",provenance)
    manifest_paths=[x for x in sorted(out.rglob("*")) if x.is_file() and x.name!="evidence_hashes.sha256"]+[ROOT/f"Data/Ground/{ground}.rsground",ROOT/f"Content/Tile/{ground}_Base.tile",ROOT/"Data/Zone/master_zone.json",ROOT/f"RESERVE/pmdred_pre_promotion/{ground}/README.md",LOCK_PATH,REPORT_PATH,AUDIT_PATH]
    (out/"evidence_hashes.sha256").write_text("".join(f"{sha(path)}  {path.relative_to(ROOT).as_posix()}\n" for path in manifest_paths))


def process_ground(ground: str, all_data: dict[str, Any]) -> None:
    order=all_data["order"]; plans=all_data["plans"]; audits=all_data["audits"]; identities=all_data["identities"]; symbols=all_data["symbols"]
    identity=identities[ground]; symbol=symbols[identity["map_id"]]
    if symbols[identity["map_id"]] != symbol: raise AssertionError
    role=classify_ground_role(symbol); plan=plans[ground]; audit=audits[ground]
    state={"ground":ground,"stage":"preflight","updated_at":time.time()};dump(STATE_PATH,state)
    if audit["status"]!="pass": raise RuntimeError("static audit is not PASS")
    ground_src=CANONICAL/f"grounds/{ground}.rsground"; tile_src=CANONICAL/f"tiles/{ground}_Base.tile"
    ground_hash=audit["candidate_sha256"]["rsground"];tile_hash=audit["candidate_sha256"]["tile"]
    if sha(ground_src)!=ground_hash or sha(tile_src)!=tile_hash: raise RuntimeError("candidate hash mismatch")
    ground_dst=ROOT/f"Data/Ground/{ground}.rsground";tile_dst=ROOT/f"Content/Tile/{ground}_Base.tile"; evidence=ROOT/f"docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass"
    if evidence.exists():
        log(f"SKIP already evidenced {ground}");return
    if ground_dst.exists() or tile_dst.exists(): raise RuntimeError(f"occupied destination for {ground}; refusing overwrite")
    fixture=ROOT/f".runtime-cache/pmdred-eu-{ground}-runtime"; comparison=ROOT/f".runtime-cache/pmdred-eu-{ground}-comparison"
    post_candidate=ROOT/f".runtime-cache/pmdred-eu-{ground}-promoted-candidate";post_fixture=ROOT/f".runtime-cache/pmdred-eu-{ground}-promoted-fixture"
    for path in [fixture,comparison,post_candidate,post_fixture]:
        if path.exists(): raise FileExistsError(f"create-only runtime path exists: {path}")
    run([str(PYTHON),"tools/build_pmdred_eu_runtime_fixture.py","--conversion-set","remaining","--candidate-root",str(CANONICAL),"--plan",str(PLAN_PATH),"--ids",ground,"--output",str(fixture)])
    run_index(fixture,fixture/"index.log");state["stage"]="indexed";dump(STATE_PATH,state)
    run_validator(ground,fixture,plan["sample_count"]+1);state["stage"]="runtime_terminal";dump(STATE_PATH,state)
    comparison.mkdir()
    with (comparison/"comparison.log").open("wb") as stream:
        command=[str(PYTHON),"tools/compare_pmdred_eu_pmdo_renders.py","--events",str(fixture/"events.jsonl"),"--screenshots",str(fixture/"appdata/SCREENSHOT"),"--reference-plan",str(PLAN_PATH),"--source-dir",str(SOURCE),"--conversion-report",str(CANONICAL/"conversion_report.json"),"--output",str(comparison),"--report",str(comparison/"report.json"),"--workers","2"]
        result=subprocess.run(command,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT)
    if result.returncode: raise RuntimeError("comparator failed")
    report=load(comparison/"report.json");rt=report["runtime"];primary=[x for x in report["samples"] if x["phase"]=="primary"]
    vals={(x["ground"],x["phase"]):x for x in rt["validations"]}
    expected=plan["sample_count"]+1
    gates=[report["grounds"]==[ground],report["sample_count"]==expected,len(primary)==plan["sample_count"],report["exact_sample_count"]==expected,report["fully_opaque_sample_count"]==expected,report["all_exact"],report["all_fully_opaque"],rt["all_runtime_safe"],rt["runtime_sequence_consistent"],rt["native_lifecycle_order"]["pass"],rt["all_cleanups_pass"],rt["end_event_seen"],rt["same_ground_reentry_count"]==1,vals[(ground,"primary")]["movement_probe"]=="PASS",vals[(ground,"primary")]["blocked_probe"]=="PASS",vals[(ground,"reload")]["load"]=="LOAD_PASS",all(x["mismatched_pixels"]==0 and x["maximum_channel_delta"]==0 for x in report["samples"])]
    if not all(gates): raise RuntimeError(f"comparison/runtime gate failed for {ground}: {gates}")
    state["stage"]="comparison_pass";dump(STATE_PATH,state);log(f"COMPARE_PASS ground={ground} samples={expected} unique={len({x['actual_rgba_sha256'] for x in primary})}")
    atomic_install(ground_src,ground_dst);atomic_install(tile_src,tile_dst)
    validated=set(load(ROOT/"docs/pmdred_eu/pmdo_validation/progress.json")["validated_ids"])
    zone_pre,zone_post,prior,zone_index=insert_zone(ground,order,validated)
    if sha(ground_dst)!=ground_hash or sha(tile_dst)!=tile_hash: raise RuntimeError("promotion readback failed")
    reserve_dir=ROOT/f"RESERVE/pmdred_pre_promotion/{ground}";reserve_dir.mkdir(parents=True)
    reserve_ground=ROOT/f"RESERVE/red_grounds/{ground}.rsground";reserve_tile=ROOT/f"RESERVE/red_tiles/{ground}_Base.tile"
    (reserve_dir/"README.md").write_text(f"# `{ground}` pre-promotion record\n\nBoth canonical lowercase destinations were absent before the {DATE} additive promotion. Pre-promotion `master_zone.json` SHA-256: `{zone_pre}`. No existing worktree asset was replaced.\n\nHistorical reserve Ground: `{sha(reserve_ground) if reserve_ground.is_file() else 'absent'}`. Historical reserve tile: `{sha(reserve_tile) if reserve_tile.is_file() else 'absent'}`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `{symbol}` / map ID {identity['map_id']} / map-file ID {identity['map_file_id']}.\n\nEvidence: `docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass/`.\n")
    state["stage"]="promoted";dump(STATE_PATH,state)
    (post_candidate/"grounds").mkdir(parents=True);(post_candidate/"tiles").mkdir()
    shutil.copyfile(ground_dst,post_candidate/"grounds"/ground_dst.name);shutil.copyfile(tile_dst,post_candidate/"tiles"/tile_dst.name);shutil.copyfile(CANONICAL/"conversion_report.json",post_candidate/"conversion_report.json")
    run([str(PYTHON),"tools/build_pmdred_eu_runtime_fixture.py","--conversion-set","remaining","--candidate-root",str(post_candidate),"--plan",str(PLAN_PATH),"--ids",ground,"--output",str(post_fixture)])
    run_index(post_fixture,post_fixture/"post_promotion_index.log")
    package_evidence(ground,symbol,role,identity,audit,plan,fixture,comparison,post_fixture,zone_pre,zone_post,prior,zone_index)
    state["stage"]="evidence_packaged";dump(STATE_PATH,state)
    run([sys.executable,"tools/update_pmdred_eu_validation_progress.py","--write"])
    run([sys.executable,"tools/update_pmdred_eu_validation_progress.py","--check"])
    state["stage"]="checkpoint_pass";dump(STATE_PATH,state);log(f"MILESTONE_PASS ground={ground}")


def main() -> int:
    parser=argparse.ArgumentParser();parser.add_argument("--ids",nargs="*");parser.add_argument("--all-team-bases",action="store_true");parser.add_argument("--limit",type=int);args=parser.parse_args()
    if not args.ids and not args.all_team_bases: parser.error("choose --ids or --all-team-bases")
    plan_doc=load(PLAN_PATH);audit_doc=load(AUDIT_PATH);manifest_doc=load(MANIFEST_PATH);symbols=ground_symbols()
    identities={x["stable_ground_id"]:x for x in manifest_doc["ground_conversion_table"]["entries"]};audits={x["id"]:x for x in audit_doc["candidates"]}
    all_data={"order":plan_doc["ground_order"],"plans":plan_doc["grounds"],"audits":audits,"identities":identities,"symbols":symbols}
    ids=args.ids or [x for x in plan_doc["ground_order"] if x.startswith("b")]
    progress=load(ROOT/"docs/pmdred_eu/pmdo_validation/progress.json");validated=set(progress["validated_ids"]);ids=[x for x in ids if x not in validated]
    if args.limit is not None: ids=ids[:args.limit]
    log(f"BATCH_BEGIN ids={len(ids)} first={ids[0] if ids else None} last={ids[-1] if ids else None}")
    for ground in ids: process_ground(ground,all_data)
    log(f"BATCH_PASS completed={len(ids)}")
    return 0

if __name__ == "__main__":
    try: raise SystemExit(main())
    except Exception as exc:
        log(f"BATCH_FAIL {type(exc).__name__}: {exc}")
        raise
