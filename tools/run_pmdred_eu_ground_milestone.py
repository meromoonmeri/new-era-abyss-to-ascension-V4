#!/usr/bin/env python3
"""Run one or more established exact-PMDO PMD Red EU Ground milestones.

This is an orchestration of the already-audited fixture, exact PMDO 0.8.12,
independent renderer/comparator, additive promotion or hash-gated preserved tile
migration, post-promotion indexing, and checkpoint tools. It supports
rescue-team-base and friend-area Grounds whose roles follow directly from the
pinned GroundMapID symbol. It stops before any unrecognized occupied destination
or unimplemented role rather than guessing or discarding historical bytes.
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

from build_pmdred_eu_entity_migration import MIGRATION_POLICIES, build_migration

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
    match = re.fullmatch(r"MAP_PERSONALITY_TEST_([A-Z0-9]+(?:_[A-Z0-9]+)*)", symbol)
    if match:
        color = match.group(1).lower()
        return {
            "category": "personality_test_screen",
            "classification": f"{color}_personality_test_screen",
            "color": color,
            "cinematic": False,
            "arena": False,
            "boss": False,
        }
    match = re.fullmatch(r"MAP_FUGITIVES_([A-Z0-9]+(?:_[A-Z0-9]+)*)", symbol)
    if match:
        setting = match.group(1).lower()
        return {
            "category": "fugitive_journey_scene",
            "classification": f"{setting}_fugitive_journey_scene",
            "setting": setting,
            "cinematic": False,
            "arena": False,
            "boss": False,
        }
    if symbol == "MAP_SUMMIT_SUNSET":
        return {
            "category": "summit_scene",
            "classification": "sunset_summit_scene",
            "time": "sunset",
            "cinematic": False,
            "arena": False,
            "boss": False,
        }
    raise RuntimeError(f"role classification is not implemented for {symbol}; stopping rather than guessing")


def build_collision_validation(
    plan: dict[str, Any], fixture_entry: dict[str, Any], runtime_event: dict[str, Any]
) -> dict[str, Any]:
    """Require either a real blocked probe or authenticated BMA non-applicability.

    A blocked movement probe cannot exist when the raw-ROM BMA has no collision
    layer and no solid cells.  Accept that condition only when the independently
    generated plan, fixture manifest, and runtime event all agree exactly.
    """
    probes = fixture_entry["spawn"]["movement_probes"]
    successful = probes["successful"]
    base = {
        "result": "PASS",
        "source": plan["resources"]["bma"],
        "collision_layer_count": plan["collision_layer_count"],
        "solid_cells": plan["solid_cells"],
        "collision_sha256": plan["collision_sha256"],
        "successful_probe": {
            "start": [successful["x"], successful["y"]],
            "direction": successful["direction"],
            "observed_delta": [int(x) for x in runtime_event["move_delta"].split(",")],
            "result": "PASS",
        },
    }
    if runtime_event.get("movement_probe") != "PASS":
        raise RuntimeError("successful movement probe did not pass")
    layers = plan["collision_layer_count"]
    solids = plan["solid_cells"]
    if layers > 0 and solids > 0:
        blocked = probes.get("blocked")
        required = [
            isinstance(blocked, dict),
            probes.get("blocked_expectation") == "BMA_SOLID_BLOCK",
            runtime_event.get("blocked_probe") == "PASS",
            runtime_event.get("solid_cells") == solids,
        ]
        if not all(required):
            raise RuntimeError(f"BMA blocked-probe gate failed: {required}")
        base["blocked_probe"] = {
            "applicable": True,
            "start": [blocked["x"], blocked["y"]],
            "direction": blocked["direction"],
            "observed_delta": [int(x) for x in runtime_event["blocked_delta"].split(",")],
            "result": "PASS",
        }
        return base
    if layers == 0 and solids == 0:
        required = [
            probes.get("blocked") is None,
            probes.get("blocked_expectation") == "NO_BMA_COLLISION_LAYER_OR_SOLIDS",
            runtime_event.get("blocked_probe") == "NOT_APPLICABLE_NO_BMA_SOLIDS",
            runtime_event.get("solid_cells") == 0,
        ]
        if not all(required):
            raise RuntimeError(f"BMA no-collision non-applicability gate failed: {required}")
        base["blocked_probe"] = {
            "applicable": False,
            "reason": "AUTHENTICATED_RAW_ROM_BMA_HAS_NO_COLLISION_LAYER_OR_SOLID_CELLS",
            "fixture_expectation": probes["blocked_expectation"],
            "runtime_result": runtime_event["blocked_probe"],
            "result": "NOT_APPLICABLE",
        }
        return base
    raise RuntimeError(
        f"unsupported inconsistent BMA collision facts: layers={layers} solids={solids}"
    )


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


def atomic_replace_preserved(source: Path, destination: Path, reserve: Path, expected_pre_sha256: str) -> None:
    """Replace a destination only after its exact prior bytes have a durable reserve."""
    if not destination.is_file() or sha(destination) != expected_pre_sha256:
        raise RuntimeError(f"pre-promotion destination changed before migration: {destination}")
    if not reserve.is_file() or sha(reserve) != expected_pre_sha256:
        raise RuntimeError(f"durable pre-promotion reserve gate failed: {reserve}")
    fd, temp_name = tempfile.mkstemp(prefix=destination.name + ".migrate.", dir=destination.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(source.read_bytes()); stream.flush(); os.fsync(stream.fileno())
        if sha(Path(temp_name)) != sha(source):
            raise RuntimeError(f"migration temporary copy hash mismatch: {destination}")
        os.replace(temp_name, destination)
        directory = os.open(destination.parent, os.O_RDONLY); os.fsync(directory); os.close(directory)
    finally:
        if os.path.exists(temp_name): os.unlink(temp_name)


def insert_zone(
    ground: str, order: list[str], validated: set[str], *, retain_existing: bool = False
) -> tuple[str, str, str, int]:
    path = ROOT / "Data/Zone/master_zone.json"; before = path.read_bytes()
    if not before.startswith(b"\xef\xbb\xbf"):
        raise RuntimeError("master_zone.json BOM absent")
    values = json.loads(before.decode("utf-8-sig"))["Object"]["GroundMaps"]
    if ground in values:
        if not retain_existing or values.count(ground) != 1:
            raise RuntimeError(f"zone already contains unvalidated {ground}")
        existing_index = values.index(ground)
        if existing_index == 0:
            raise RuntimeError(f"preexisting zone entry has no predecessor: {ground}")
        return sha_bytes(before), sha_bytes(before), values[existing_index - 1], existing_index
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


def validate_partial_additive_recovery_record(
    record: dict[str, Any], ground: str, ground_hash: str, tile_hash: str
) -> None:
    """Authenticate a preserved, uncommitted additive install from a failed attempt.

    This never converts that prior attempt into a PASS.  It only permits the exact
    candidate bytes already installed by that attempt to remain in place while a
    fresh, isolated runtime/comparison attempt is performed from the beginning.
    """
    installed = record.get("preserved_partial_additive_install", {})
    policy = record.get("recovery_policy", {})
    required = [
        record.get("schema") == "new-era.pmdred-eu-ground-orchestration-failure.v1",
        record.get("ground") == ground,
        record.get("result") == "ORCHESTRATION_FAIL_AFTER_EXACT_ADDITIVE_INSTALL",
        record.get("failure", {}).get("stage") == "zone_registration_after_runtime_and_comparison_pass",
        record.get("initial_destination_precondition") == {"ground": "absent", "tile": "absent"},
        installed.get("ground", {}).get("sha256") == ground_hash,
        installed.get("tile", {}).get("sha256") == tile_hash,
        installed.get("ground", {}).get("tracked_at_head") is False,
        installed.get("tile", {}).get("tracked_at_head") is False,
        installed.get("ground", {}).get("matches_authenticated_v201_candidate") is True,
        installed.get("tile", {}).get("matches_authenticated_v201_candidate") is True,
        installed.get("deleted_or_overwritten_during_diagnosis") is False,
        policy.get("preserve_this_failed_attempt") is True,
        policy.get("preserve_exact_partial_destination_bytes") is True,
        policy.get("fresh_full_runtime_and_comparison_rerun_required") is True,
        policy.get("official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun") is True,
    ]
    if not all(required):
        raise RuntimeError(f"partial additive recovery record gate failed for {ground}: {required}")


def validate_pre_promotion_collision_failure_record(
    record: dict[str, Any], ground: str
) -> None:
    """Authenticate a preserved no-BMA-collision gate failure before a fresh rerun."""
    facts = record.get("authenticated_collision_facts", {})
    canonical = record.get("canonical_state", {})
    policy = record.get("recovery_policy", {})
    required = [
        record.get("schema") == "new-era.pmdred-eu-ground-orchestration-failure.v1",
        record.get("ground") == ground,
        record.get("result") == "ORCHESTRATION_FAIL_BEFORE_PROMOTION",
        record.get("failure", {}).get("stage") == "comparison_gate_before_promotion",
        record.get("failure", {}).get("gate_index") == 14,
        facts.get("collision_layer_count") == 0,
        facts.get("solid_cells") == 0,
        facts.get("fixture_blocked_probe") is None,
        facts.get("fixture_blocked_expectation") == "NO_BMA_COLLISION_LAYER_OR_SOLIDS",
        facts.get("runtime_blocked_probe") == "NOT_APPLICABLE_NO_BMA_SOLIDS",
        canonical.get("ground_destination_absent") is True,
        canonical.get("tile_destination_absent") is True,
        canonical.get("zone_entry_count") == 0,
        canonical.get("official_pass_evidence_created") is False,
        policy.get("preserve_this_failed_attempt") is True,
        policy.get("do_not_reclassify_as_pass") is True,
        policy.get("narrow_collision_non_applicability_gate_required") is True,
        policy.get("fresh_full_runtime_and_comparison_rerun_required") is True,
        policy.get("official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun") is True,
    ]
    if not all(required):
        raise RuntimeError(f"pre-promotion collision failure record gate failed for {ground}: {required}")


def pre_promotion_collision_failure_record(
    ground: str, ground_dst: Path, tile_dst: Path
) -> Path | None:
    record_path = ROOT / (
        f"docs/pmdred_eu/pmdo_validation/"
        f"{ground}_failed_attempt_no_bma_collision_gate/failure_record.json"
    )
    if not record_path.is_file():
        return None
    record = load(record_path)
    validate_pre_promotion_collision_failure_record(record, ground)
    if ground_dst.exists() or tile_dst.exists():
        raise RuntimeError(f"pre-promotion failure destinations are no longer absent for {ground}")
    maps = load(ROOT / "Data/Zone/master_zone.json")["Object"]["GroundMaps"]
    if maps.count(ground) != 0:
        raise RuntimeError(f"pre-promotion failed Ground is unexpectedly registered: {ground}")
    evidence_root = record_path.parent
    for relative, expected in record["evidence"].items():
        evidence_path = evidence_root / relative
        if not evidence_path.is_file() or sha(evidence_path) != expected:
            raise RuntimeError(f"preserved collision failure evidence hash mismatch: {relative}")
    return record_path


def validate_partial_entity_migration_recovery_record(
    record: dict[str, Any], ground: str, policy: dict[str, Any]
) -> None:
    """Authenticate immutable semantics of a failed occupied-migration attempt."""
    migration = record.get("entity_migration", {})
    canonical = record.get("canonical_state", {})
    recovery = record.get("recovery_policy", {})
    tile_mode = policy.get("tile_migration_mode", "retain_distinct_historical_identity")
    tile_required = (
        [
            migration.get("uppercase_case_tile_retained") is True,
            migration.get("lowercase_canonical_tile_created") is True,
        ]
        if tile_mode == "retain_distinct_historical_identity" else
        [
            migration.get("tile_migration_mode") == "reserve_and_replace_canonical_identity",
            migration.get("historical_active_tile_sha256") == policy["historical_tile_sha256"],
            migration.get("historical_tile_reserved_before_replacement") is True,
            migration.get("canonical_identity_tile_replaced_atomically") is True,
            canonical.get("historical_reserve_tile_sha256") == policy["historical_tile_sha256"],
            canonical.get("active_tile_sha256") == policy["canonical_tile_sha256"],
        ]
    )
    required = [
        record.get("schema") == "new-era.pmdred-eu-ground-orchestration-failure.v1",
        record.get("ground") == ground,
        record.get("result") == "ORCHESTRATION_FAIL_AFTER_AUTHENTICATED_MIGRATION_INSTALL_BEFORE_PROMOTION",
        record.get("failure", {}).get("stage") == "zone_integration_after_migration_install",
        migration.get("historical_ground_sha256") == policy["historical_ground_sha256"],
        migration.get("canonical_baseline_ground_sha256") == policy["canonical_ground_sha256"],
        migration.get("integrated_ground_sha256") == policy["integrated_ground_sha256"],
        migration.get("tile_sha256") == policy["canonical_tile_sha256"],
        migration.get("markers") == policy["expected_entities"]["Markers"],
        migration.get("spawners") == policy["expected_entities"]["Spawners"],
        migration.get("reserve_created") is True,
        *tile_required,
        canonical.get("active_ground_sha256") == policy["integrated_ground_sha256"],
        canonical.get("historical_reserve_ground_sha256") == policy["historical_ground_sha256"],
        canonical.get("official_pass_evidence_created") is False,
        canonical.get("zone_unchanged") is True,
        canonical.get("zone_entry_count") == 1,
        recovery.get("preserve_this_failed_attempt") is True,
        recovery.get("do_not_reclassify_as_pass") is True,
        recovery.get("authenticate_partial_migration_and_reserve") is True,
        recovery.get("retain_singleton_historical_zone_entry_in_place") is True,
        recovery.get("fresh_full_runtime_comparison_and_post_promotion_rerun_required") is True,
        recovery.get("official_pass_may_be_packaged_only_after_all_gates_pass_on_fresh_rerun") is True,
    ]
    if not all(required):
        raise RuntimeError(f"partial entity migration recovery record gate failed for {ground}: {required}")


def partial_entity_migration_recovery_record(
    ground: str, ground_dst: Path, tile_dst: Path, legacy_tile: Path,
    reserve_ground: Path, reserve_legacy_tile: Path, policy: dict[str, Any],
) -> Path | None:
    """Authenticate the exact occupied migration left by a preserved failed attempt."""
    expected_integrated = policy["integrated_ground_sha256"]
    expected_tile = policy["canonical_tile_sha256"]
    active_matches = (
        ground_dst.is_file() and sha(ground_dst) == expected_integrated
        and tile_dst.is_file() and sha(tile_dst) == expected_tile
    )
    if not active_matches:
        return None
    record_path = ROOT / (
        f"docs/pmdred_eu/pmdo_validation/"
        f"{ground}_failed_attempt_preexisting_zone_gate/failure_record.json"
    )
    if not record_path.is_file():
        return None
    record = load(record_path)
    validate_partial_entity_migration_recovery_record(record, ground, policy)
    canonical = record["canonical_state"]
    maps = load(ROOT / "Data/Zone/master_zone.json")["Object"]["GroundMaps"]
    zone_indices = [index for index, value in enumerate(maps) if value == ground]
    tile_replaced = (
        policy.get("tile_migration_mode", "retain_distinct_historical_identity")
        == "reserve_and_replace_canonical_identity"
    )
    required = [
        len(zone_indices) == 1,
        zone_indices == [canonical.get("zone_index")],
        sha(ROOT / "Data/Zone/master_zone.json") == canonical.get("zone_sha256"),
        reserve_ground.is_file() and sha(reserve_ground) == policy["historical_ground_sha256"],
        reserve_legacy_tile.is_file() and sha(reserve_legacy_tile) == policy["historical_tile_sha256"],
        legacy_tile.is_file() and sha(legacy_tile) == (
            policy["canonical_tile_sha256"] if tile_replaced else policy["historical_tile_sha256"]
        ),
    ]
    if not all(required):
        raise RuntimeError(f"partial entity migration recovery gate failed for {ground}: {required}")
    for relative, expected in record["evidence"].items():
        evidence_path = record_path.parent / relative
        if not evidence_path.is_file() or sha(evidence_path) != expected:
            raise RuntimeError(f"preserved entity migration failure evidence hash mismatch: {relative}")
    return record_path


def tracked_at_head(path: Path) -> bool:
    relative = path.relative_to(ROOT).as_posix()
    return subprocess.run(
        ["git", "cat-file", "-e", f"HEAD:{relative}"],
        cwd=ROOT,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0


def partial_additive_recovery_record(
    ground: str, ground_dst: Path, tile_dst: Path, ground_hash: str, tile_hash: str
) -> Path | None:
    if not (ground_dst.is_file() and tile_dst.is_file()):
        return None
    if sha(ground_dst) != ground_hash or sha(tile_dst) != tile_hash:
        return None
    if tracked_at_head(ground_dst) or tracked_at_head(tile_dst):
        return None
    record_path = (
        ROOT
        / f"docs/pmdred_eu/pmdo_validation/{ground}_failed_attempt_pre_zone_recovery/failure_record.json"
    )
    if not record_path.is_file():
        return None
    record = load(record_path)
    validate_partial_additive_recovery_record(record, ground, ground_hash, tile_hash)
    if record["evidence"].get(f"Data/Ground/{ground}.rsground") != ground_hash:
        raise RuntimeError(f"partial recovery Ground evidence hash mismatch for {ground}")
    if record["evidence"].get(f"Content/Tile/{ground}_Base.tile") != tile_hash:
        raise RuntimeError(f"partial recovery tile evidence hash mismatch for {ground}")
    correction_path = ROOT / "docs/pmdred_eu/pmdo_validation/pilot_zone_integration_correction_20260812/correction_record.json"
    if not correction_path.is_file():
        raise RuntimeError("partial recovery requires durable historical pilot zone correction evidence")
    correction = load(correction_path)
    maps = load(ROOT / "Data/Zone/master_zone.json")["Object"]["GroundMaps"]
    if not (
        correction.get("result") == "PASS"
        and correction.get("zone", {}).get("inserted_entries") == ["h26p01", "a01p01"]
        and maps.count("h26p01") == 1
        and maps.count("a01p01") == 1
    ):
        raise RuntimeError("historical pilot zone correction gate failed")
    return record_path


def write_commands(out: Path, ground: str, identity: dict[str, Any], symbol: str, ground_hash: str, tile_hash: str,
                   event_count: int, sample_count: int, unique_count: int, reserve_ground: Path, reserve_tile: Path,
                   migration: dict[str, Any] | None = None) -> None:
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
    if migration is not None:
        canonical_hash = migration["canonical_baseline"]["ground_sha256"]
        source = source.replace(
            'CANONICAL="$ROOT/.runtime-cache/pmdred-eu-remaining-regenerated-v201"',
            'CANONICAL="$ROOT/.runtime-cache/pmdred-eu-remaining-regenerated-v201"\n'
            f'MIGRATED="$ROOT/.runtime-cache/pmdred-eu-{ground}-reproduction-entity-migration"',
        )
        source = source.replace(
            f'test "$(sha256sum "$CANONICAL/grounds/{ground}.rsground" | cut -d\' \' -f1)" = {ground_hash}',
            f'test "$(sha256sum "$CANONICAL/grounds/{ground}.rsground" | cut -d\' \' -f1)" = {canonical_hash}\n'
            'test ! -e "$MIGRATED"\n'
            f'"$PYTHON" tools/build_pmdred_eu_entity_migration.py --ground {ground} --output "$MIGRATED"\n'
            f'test "$(sha256sum "$MIGRATED/grounds/{ground}.rsground" | cut -d\' \' -f1)" = {ground_hash}',
        )
        source = source.replace(
            '--candidate-root "$CANONICAL" \\\n  --plan "$PLAN" \\\n  --ids ' + ground + ' \\\n  --output "$FIX"',
            '--candidate-root "$MIGRATED" \\\n  --canonical-baseline-root "$CANONICAL" \\\n  --entity-integrated-ids ' + ground + ' \\\n  --plan "$PLAN" \\\n  --ids ' + ground + ' \\\n  --output "$FIX"',
        )
        source = source.replace(
            f'--ids {ground} --output "$POST_FIX"',
            f'--ids {ground} --entity-integrated-ids {ground} '
            f'--canonical-baseline-root "$CANONICAL" --output "$POST_FIX"',
        )
    (out / "commands.sh").write_text(source); os.chmod(out / "commands.sh", 0o755)


def package_evidence(ground: str, symbol: str, role: dict[str, Any], identity: dict[str, Any], audit: dict[str, Any], plan: dict[str, Any],
                     fixture: Path, comparison: Path, post_fixture: Path, zone_pre: str, zone_post: str, prior: str, zone_index: int,
                     pre_promotion: dict[str, dict[str, Any]], partial_recovery_record: Path | None = None,
                     pre_promotion_failure_record: Path | None = None,
                     migration_failure_record: Path | None = None,
                     migration: dict[str, Any] | None = None) -> None:
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
    if migration is not None:
        migration_manifest = (
            ROOT / migration["integrated_candidate"]["ground"]
        ).parents[1] / "migration_manifest.json"
        if load(migration_manifest) != migration:
            raise RuntimeError("entity migration manifest changed before evidence packaging")
        shutil.copyfile(migration_manifest, out/"entity_migration_manifest.json")
        for relative, expected in migration["related_scripts_unchanged"].items():
            if sha(ROOT/relative) != expected:
                raise RuntimeError(f"related migration script changed before packaging: {relative}")
    logs = sorted((fixture / "appdata/LOG").glob("*.txt"));
    if not logs: raise RuntimeError("engine log absent")
    shutil.copyfile(logs[-1], out / "engine.log")
    selected = [primary[0], primary[-1], reloads[0]]
    for item in selected:
        phase, tick = item["phase"], item["tick"]
        shutil.copyfile(ROOT / item["source_screenshot"], out / "actual" / f"actual_{phase}_tick{tick}.png")
        shutil.copyfile(ROOT / item["comparative_png"], out / "comparisons" / f"comparison_{phase}_tick{tick}.png")
    canonical_ground_hash = audit["candidate_sha256"]["rsground"]
    ground_hash = (
        migration["integrated_candidate"]["ground_sha256"]
        if migration is not None else canonical_ground_hash
    )
    tile_hash = audit["candidate_sha256"]["tile"]
    events_sha, report_sha, fixture_sha = sha(out/"events.jsonl"),sha(out/"report.json"),sha(out/"fixture_manifest.json")
    termination_sha = sha(out/"termination.json")
    validations={(x["ground"],x["phase"]):x for x in report["runtime"]["validations"]}; main=validations[(ground,"primary")]
    channels=plan["animation_channels"]; ticks=plan["complete_two_local_cycle_boundary_ticks"]
    collision_validation = build_collision_validation(plan, manifest["entries"][0], main)
    reserve_ground=ROOT/f"RESERVE/red_grounds/{ground}.rsground"; reserve_tile=ROOT/f"RESERVE/red_tiles/{ground}_Base.tile"
    reserve_details={"ground":{"present":reserve_ground.is_file(),"sha256":sha(reserve_ground) if reserve_ground.is_file() else None},"tile":{"present":reserve_tile.is_file(),"sha256":sha(reserve_tile) if reserve_tile.is_file() else None}}
    preexisting = any(item["preexisting"] for item in pre_promotion.values())
    recovered_partial_additive = partial_recovery_record is not None
    promotion_result = "PROMOTION_PASS_RECOVERED_EXACT_ADDITIVE_INSTALL" if recovered_partial_additive else ("PROMOTION_PASS_CANONICAL_WITH_PRESERVED_MIGRATION" if preexisting else "PROMOTION_PASS_ADDITIVE_CANONICAL")
    promotion_status = "PROMOTED_RECOVERED_EXACT_ADDITIVE_INSTALL" if recovered_partial_additive else ("PROMOTED_CANONICAL_WITH_PRESERVED_MIGRATION" if preexisting else "PROMOTED_ADDITIVE_CANONICAL")
    precondition = "; ".join(f"{name} {'present at ' + item['sha256'] if item['preexisting'] else 'absent'}" for name, item in pre_promotion.items())
    if recovered_partial_additive:
        precondition += "; exact untracked candidate install preserved from explicitly failed pre-zone attempt"
    pre_reserve_details = {
        name: {"preexisting": item["preexisting"], "sha256": item["sha256"], "reserve": item["reserve"]}
        for name, item in pre_promotion.items()
    }
    retained_zone_entry = migration is not None and zone_pre == zone_post
    zone_change = (
        f"retained authenticated singleton historical entry in place after {prior}"
        if retained_zone_entry else f"one insertion after {prior}"
    )
    zone_registration = (
        f"authenticated singleton retained after {prior} without mutation"
        if retained_zone_entry else f"one insertion after {prior} without reserialization"
    )
    classification={"category":role["category"],"ground_map_symbol":symbol,"canonical_debug_id":identity["canonical_debug_id"],"map_id":identity["map_id"],"map_file_id":identity["map_file_id"],"ground_place_id":identity["ground_place_id"],"stable_ground_id":ground,**role}
    record={
      "schema":1,"ground":ground,"validated_at":DATE,"runtime":"PASS",
      "visual_comparison":{"result":"PASS","dimensions_pixels":plan["dimensions_pixels"],"primary_sample_count":len(primary),"reload_sample_count":1,"exact_sample_count":samples,"unique_rgba_frame_count":unique_count,"mismatched_pixel_count":0,"maximum_channel_delta":0,"all_full_rgba_exact":True,"all_fully_opaque":True,"comparative_png_paths":[str(x.relative_to(ROOT)) for x in sorted((out/"comparisons").glob("*.png"))],"complete_metrics_report":str((out/"report.json").relative_to(ROOT))},
      "tile_palette_validation":{"result":"PASS","reference":"independent authenticated raw EU BPL/BPC/BPA/BMA renderer","resource_hashes":plan["source_normalized_sha256"]},
      "animation_validation":{"result":"PASS","primary_sample_count":len(primary),"first_tick":ticks[0],"last_tick":ticks[-1],"cell_local_schedule_count":len(plan["cell_animation_schedules"]),"maximum_cell_local_cycle_ticks":max((x["source_local_cycle"] for x in plan["cell_animation_schedules"]),default=1),"all_schedules_covered_through_two_complete_cycles":True,"channels":channels,"unique_observed_rgba_frames":unique_count,"reload_tick_zero_exact":True,"orphaned_animation_observed":False},
      "collision_validation":collision_validation,
      "entry_exit_reentry":{"result":"PASS","loads":2,"entries":2,"exits":2,"same_ground_reentries":1,"strict_native_lifecycle_order":"PASS"},
      "cleanup_reload":{"result":"PASS","cleanup_probe_count":4,"ground_exit_cleanup_passes":2,"sink_cleanup":"PASS","final_cleanup":"PASS","reload_load":"LOAD_PASS","reload_tick_zero_full_rgba_exact":True,"terminal_end_seen":True,"state_leakage_observed":False,"stale_assets_observed":False,"permanent_lock_observed":False,"orphan_process_check":"PASS"},
      "native_termination":{"result":"PASS","load_phase":"Unload","deinit_seen":True,"graphics_unload_seen":True,"exit_classification":"NORMAL_EXIT","return_code":0,"terminal":True,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"evidence":str((out/"termination.json").relative_to(ROOT)),"sha256":termination_sha},
      "fixture_isolation":{"canonical_source_ground_sha256":ground_hash,"canonical_source_tile_sha256":tile_hash,"source_entity_counts":{"markers":0,"spawners":0,"map_characters":0,"ground_objects":0},"fixture_only_changes":["deterministic entry marker","ignored validator plumbing"],"source_and_promoted_files_unchanged_by_fixture":True},
      "special_classification":{"canonical_source":classification,"scope":{"cinematic_choreography":"NOT APPLICABLE/NOT CLAIMED; Ground-only lifecycle and rendering validated","arena":False,"boss":False}},
      "identity_validation":{"result":"PASS","authenticated_map_file_id":identity["map_file_id"],"pinned_enum_symbol":symbol,"conversion_type":identity["conversion_type"],"weather_id":identity["weather_id"]},
      "definitive_destination":{"ground":f"Data/Ground/{ground}.rsground","tile":f"Content/Tile/{ground}_Base.tile","zone_registry":"Data/Zone/master_zone.json","zone_registry_entry":ground,"promotion_status":promotion_status,"preexisting_destinations":preexisting,"pre_promotion_destinations":pre_reserve_details,"pre_promotion_record":f"RESERVE/pmdred_pre_promotion/{ground}/README.md","promoted_ground_sha256":ground_hash,"promoted_tile_sha256":tile_hash},
      "provenance":{"rom_sha256":ROM_SHA256,"reference_plan_sha256":PLAN_SHA256,"conversion_report_sha256":CONVERSION_SHA256,"candidate_ground_sha256":ground_hash,"candidate_tile_sha256":tile_hash,"source_normalized_sha256":plan["source_normalized_sha256"],"events_sha256":events_sha,"report_sha256":report_sha,"fixture_manifest_sha256":fixture_sha,"termination_sha256":termination_sha,"detailed_provenance":str((out/"provenance.json").relative_to(ROOT))},
      "execution_note":{"terminal_event_and_all_required_captures_completed":True,"post_terminal_shutdown":"PMDO-native GameBase.LoadPhase.Unload followed by NORMAL_EXIT","return_code":0,"watchdog":False,"requested_signal":None,"evidence_impact":"NONE"},"dungeon_restitution":{"affected":False,"status":"27-relationship bundle retained"},
      "scope_note":"Ground-only; dialogue, choreography, music assignment, and narrative routing are not claimed.",
      "post_promotion_integration":{"result":"PASS","exact_pmdo_index":"PASS","indexed_ground_sha256":ground_hash,"indexed_tile_sha256":tile_hash,"index_log_sha256":INDEX_SHA256,"zone_encoding_bom_preserved":True,"zone_change":zone_change,"zone_ground_map_count":len(load(ROOT/"Data/Zone/master_zone.json")["Object"]["GroundMaps"]),"canonical_index":zone_index,"variant_and_routing_static_checks":"PASS"}}
    promotion={"schema":1,"ground":ground,"validated_at":DATE,"promoted_at":DATE,"result":promotion_result,"method":{"destination_precondition":precondition,"installation_mode":"fsynced temporary files and atomic os.replace after durable preservation where required","historical_bytes_reserved_before_replacement":preexisting,"existing_asset_discarded":False,"existing_scripts_modified":False,"zone_registration":zone_registration},"gates":{"exact_pmdo_version":"0.8.12","exact_pmdo_executable_sha256":PMDO_SHA256,"active_patched_sdl_sha256":SDL_SHA256,"report_sha256":report_sha,"fixture_manifest_sha256":fixture_sha,"reference_plan_sha256":PLAN_SHA256,"canonical_ground_sha256":ground_hash,"canonical_tile_sha256":tile_hash,"planned_primary_tick_count":len(primary),"observed_primary_tick_count":len(primary),"reload_tick_zero_covered":True,"pixel_exact_sample_count":samples,"fully_opaque_sample_count":samples,"mismatched_pixel_count":0,"maximum_channel_delta":0,"runtime_safe":True,"native_lifecycle_order_pass":True,"cleanup_pass":True,"terminal_end_seen":True,"load_phase_unload_pass":True,"exit_classification":"NORMAL_EXIT","return_code":0,"terminal":True,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"termination_sha256":termination_sha,"identity_map_file_id":identity["map_file_id"],"identity_symbol":symbol},"files":[{"candidate":f".runtime-cache/pmdred-eu-remaining-regenerated-v201/grounds/{ground}.rsground","destination":f"Data/Ground/{ground}.rsground","destination_preexisting":pre_promotion["ground"]["preexisting"],"pre_promotion_sha256":pre_promotion["ground"]["sha256"],"pre_promotion_reserve":pre_promotion["ground"]["reserve"],"bytes":(ROOT/f"Data/Ground/{ground}.rsground").stat().st_size,"validated_candidate_sha256":ground_hash,"destination_sha256":ground_hash,"candidate_destination_identical":True},{"candidate":f".runtime-cache/pmdred-eu-remaining-regenerated-v201/tiles/{ground}_Base.tile","destination":f"Content/Tile/{ground}_Base.tile","destination_preexisting":pre_promotion["tile"]["preexisting"],"pre_promotion_sha256":pre_promotion["tile"]["sha256"],"pre_promotion_reserve":pre_promotion["tile"]["reserve"],"bytes":(ROOT/f"Content/Tile/{ground}_Base.tile").stat().st_size,"validated_candidate_sha256":tile_hash,"destination_sha256":tile_hash,"candidate_destination_identical":True}],"zone_registration":{"entry":ground,"entry_count":1,"position":f"after {prior}","mode":"retained_authenticated_historical_singleton" if retained_zone_entry else "additive_insertion","pre_promotion_sha256":zone_pre,"post_promotion_sha256":zone_post},"preserved_variants":[{"role":"pre_promotion_destination_reserve","files":pre_reserve_details,"modified_after_capture":False},{"role":"historical_reserve",**reserve_details,"modified":False},{"role":"historical_v200_and_v201_reports","paths":["docs/pmdred_eu/remaining_grounds/history/v200_pre_period_fix/","docs/pmdred_eu/remaining_grounds/"],"modified_by_promotion":False}],"post_promotion_integration":{"result":"PASS","exact_pmdo_index":"PASS","log_sha256":INDEX_SHA256,"zone_structure":"PASS","existing_routes_unchanged":"PASS"}}
    provenance={"schema":1,"ground":ground,"validated_at":DATE,"result":"PASS","authorities":{"rom":{"sha256":ROM_SHA256,"bytes":33554432,"region":"Europe"},"technical_reference":{"repository":"pret/pmd-red","commit":"bf0092d0e34fd8e49b859a0b5f96f00740faa42d","role":f"{symbol} identity, not EU bytes"},"normalized_extraction":{"source_hashes":plan["source_normalized_sha256"]},"runtime_plan":{"schema":2,"sha256":PLAN_SHA256},"conversion":{"converter":"2.0.1-eu","report_sha256":CONVERSION_SHA256}},"identity":{"canonical_debug_id":identity["canonical_debug_id"],"map_id":identity["map_id"],"map_file_id":identity["map_file_id"],"ground_place_id":identity["ground_place_id"],"conversion_type":identity["conversion_type"],"weather_id":identity["weather_id"],"stable_ground_id":ground,"ground_map_symbol":symbol,"dimensions_tiles":plan["dimensions_tiles"],"dimensions_pixels":plan["dimensions_pixels"],**role},"tested_source":{"ground_sha256":ground_hash,"tile_sha256":tile_hash,"candidate_entities":{"markers":0,"spawners":0,"map_characters":0,"ground_objects":0},"fixture_manifest_sha256":fixture_sha,"static_audit":audit},"runtime":{"name":"PMDO","version":"0.8.12","executable_sha256":PMDO_SHA256,"patched_sdl_sha256":SDL_SHA256,"events_sha256":events_sha,"event_count":sum(1 for _ in (out/"events.jsonl").open()),"primary_samples":len(primary),"reload_samples":1,"terminal_seen":True,"load_phase":"Unload","exit_classification":"NORMAL_EXIT","return_code":0,"graceful":True,"watchdog":False,"requested_signal":None,"sigsegv":False,"forced_kill":False,"orphan_process":False,"termination_sha256":termination_sha},"comparison":{"report_sha256":report_sha,"sample_count":samples,"exact_sample_count":samples,"fully_opaque_sample_count":samples,"mismatched_pixels":0,"maximum_channel_delta":0,"unique_primary_rgba_frames":unique_count},"candidate_provenance_reconciliation":{"historical_v200_reports_preserved_at":"docs/pmdred_eu/remaining_grounds/history/v200_pre_period_fix/","authenticated_v201_ground_sha256":ground_hash,"authenticated_v201_tile_sha256":tile_hash,"decision":"Only authenticated v2.0.1-eu bytes were exact-engine tested and promoted; immutable v2.0.0 reports and active v2.0.1 reports remain distinct provenance."},"preservation":{"historical_reserve":reserve_details,"pre_promotion_destinations":pre_reserve_details,"pre_promotion_record":f"RESERVE/pmdred_pre_promotion/{ground}/README.md"},"promoted":{"ground_sha256":ground_hash,"tile_sha256":tile_hash,"zone_pre_sha256":zone_pre,"zone_post_sha256":zone_post},"durable_evidence":{},"reproduction":{"commands":str((out/"commands.sh").relative_to(ROOT))},"scope":"Ground-only validation","post_promotion_integration":{"exact_pmdo_index":"PASS","log_sha256":INDEX_SHA256,"zone_encoding_bom_preserved":True}}
    if partial_recovery_record is not None:
        recovery_relative = partial_recovery_record.relative_to(ROOT).as_posix()
        recovery_sha = sha(partial_recovery_record)
        recovery_metadata = {
            "prior_attempt_classification": "FAIL",
            "record": recovery_relative,
            "record_sha256": recovery_sha,
            "destination_bytes_preserved_without_replacement": True,
            "fresh_full_runtime_and_comparison_rerun": True,
            "fresh_fixture": fixture.relative_to(ROOT).as_posix(),
            "fresh_comparison": comparison.relative_to(ROOT).as_posix(),
        }
        record["execution_note"]["partial_additive_recovery"] = recovery_metadata
        promotion["method"]["installation_mode"] = "no replacement: retained exact untracked additive bytes after strict failure-record authentication and fresh full rerun"
        promotion["method"]["partial_additive_recovery"] = recovery_metadata
        promotion["preserved_variants"].append({
            "role": "failed_attempt_evidence",
            "record": recovery_relative,
            "sha256": recovery_sha,
            "reclassified_as_pass": False,
        })
        provenance["preservation"]["partial_additive_recovery"] = recovery_metadata
    if pre_promotion_failure_record is not None:
        failure_relative = pre_promotion_failure_record.relative_to(ROOT).as_posix()
        failure_metadata = {
            "prior_attempt_classification": "FAIL",
            "record": failure_relative,
            "record_sha256": sha(pre_promotion_failure_record),
            "failed_before_promotion": True,
            "canonical_destinations_untouched_by_failed_attempt": True,
            "fresh_full_runtime_and_comparison_rerun": True,
            "fresh_fixture": fixture.relative_to(ROOT).as_posix(),
            "fresh_comparison": comparison.relative_to(ROOT).as_posix(),
        }
        record["execution_note"]["prior_pre_promotion_failure"] = failure_metadata
        promotion["preserved_variants"].append({
            "role": "failed_attempt_evidence",
            "record": failure_relative,
            "sha256": failure_metadata["record_sha256"],
            "reclassified_as_pass": False,
        })
        provenance["preservation"]["prior_pre_promotion_failure"] = failure_metadata
    if migration_failure_record is not None:
        failure_relative = migration_failure_record.relative_to(ROOT).as_posix()
        failure_metadata = {
            "prior_attempt_classification": "FAIL",
            "record": failure_relative,
            "record_sha256": sha(migration_failure_record),
            "failed_after_authenticated_migration_install_before_zone_acceptance": True,
            "exact_partial_migration_authenticated_and_retained_without_replacement": True,
            "fresh_full_runtime_comparison_and_post_promotion_rerun": True,
            "historical_singleton_zone_entry_retained_in_place": retained_zone_entry,
            "fresh_fixture": fixture.relative_to(ROOT).as_posix(),
            "fresh_comparison": comparison.relative_to(ROOT).as_posix(),
        }
        record["execution_note"]["partial_entity_migration_recovery"] = failure_metadata
        promotion["method"]["installation_mode"] = (
            "no replacement on recovery: authenticated the preserved historical reserve and exact integrated install, then required a fresh full rerun"
        )
        promotion["preserved_variants"].append({
            "role": "failed_attempt_evidence",
            "record": failure_relative,
            "sha256": failure_metadata["record_sha256"],
            "reclassified_as_pass": False,
        })
        provenance["preservation"]["partial_entity_migration_recovery"] = failure_metadata
    if migration is not None:
        entity_proof = migration["entity_integration"]
        migration_evidence = {
            "result": migration["result"],
            "manifest": str((out/"entity_migration_manifest.json").relative_to(ROOT)),
            "manifest_sha256": sha(out/"entity_migration_manifest.json"),
            "canonical_baseline_ground_sha256": canonical_ground_hash,
            "integrated_validated_ground_sha256": ground_hash,
            "complete_historical_ground_sha256": migration["historical"]["ground_sha256"],
            "complete_historical_tile_sha256": migration["historical"]["tile_sha256"],
            "preserved_entities": entity_proof,
            "tile_migration": migration["tile_migration"],
            "legacy_case_tile_retained_unchanged": migration["legacy_case_tile_retained_unchanged"],
            "historical_tile_replaced_after_reserve": migration["historical_tile_replaced_after_reserve"],
            "canonical_case_tile_identity": migration["canonical_case_tile_identity"],
            "related_scripts_unchanged": migration["related_scripts_unchanged"],
            "existing_asset_discarded": False,
            "existing_entity_silently_deactivated": False,
            "scripts_modified": False,
        }
        record["entity_aware_migration"] = migration_evidence
        record["definitive_destination"]["promotion_status"] = (
            "PROMOTED_INTEGRATION_PRESERVING_ENTITY_MIGRATION_AFTER_FRESH_RECOVERY"
            if migration_failure_record is not None else
            "PROMOTED_INTEGRATION_PRESERVING_ENTITY_MIGRATION"
        )
        record["fixture_isolation"]["authenticated_canonical_baseline_ground_sha256"] = canonical_ground_hash
        record["fixture_isolation"]["source_entity_counts"] = entity_proof["entity_counts"]
        record["provenance"]["authenticated_canonical_baseline_ground_sha256"] = canonical_ground_hash
        record["provenance"]["integrated_candidate_ground_sha256"] = ground_hash
        promotion["result"] = (
            "PROMOTION_PASS_INTEGRATION_PRESERVING_ENTITY_MIGRATION_AFTER_FRESH_RECOVERY"
            if migration_failure_record is not None else
            "PROMOTION_PASS_INTEGRATION_PRESERVING_ENTITY_MIGRATION"
        )
        promotion["method"]["canonical_migration"] = (
            "authenticated canonical visual/collision/animation Ground plus only exact additive historical Markers/Spawners"
        )
        promotion["method"]["existing_project_entities_preserved"] = True
        promotion["method"]["tile_migration"] = migration["tile_migration"]
        promotion["method"]["legacy_case_tile_retained_unchanged"] = bool(
            migration["legacy_case_tile_retained_unchanged"]
        )
        promotion["method"]["historical_tile_replaced_only_after_reserve"] = bool(
            migration["historical_tile_replaced_after_reserve"]
        )
        promotion["gates"]["canonical_ground_sha256"] = canonical_ground_hash
        promotion["gates"]["integrated_ground_sha256"] = ground_hash
        promotion["gates"]["entity_integration_proof"] = "PASS_ADDITIVE_MARKERS_SPAWNERS_ONLY"
        promotion["files"][0]["candidate"] = migration["integrated_candidate"]["ground"]
        promotion["files"][0]["canonical_baseline"] = migration["canonical_baseline"]["ground"]
        promotion["files"][0]["canonical_baseline_sha256"] = canonical_ground_hash
        promotion["entity_integration"] = migration_evidence
        promotion["preserved_variants"].append({
            "role": "occupied_ground_entity_migration",
            "manifest": migration_evidence["manifest"],
            "sha256": migration_evidence["manifest_sha256"],
            "historical_ground_and_tile_reserved": True,
            "tile_migration": migration["tile_migration"],
            "legacy_case_tile_retained": bool(migration["legacy_case_tile_retained_unchanged"]),
        })
        provenance["tested_source"]["authenticated_canonical_baseline_ground_sha256"] = canonical_ground_hash
        provenance["tested_source"]["candidate_entities"] = entity_proof["entity_counts"]
        provenance["candidate_provenance_reconciliation"]["authenticated_v201_ground_sha256"] = canonical_ground_hash
        provenance["candidate_provenance_reconciliation"]["integrated_validated_ground_sha256"] = ground_hash
        provenance["candidate_provenance_reconciliation"]["decision"] = (
            "Authenticated v2.0.1-eu visual/collision bytes were preserved exactly; only hash-gated historical Markers/Spawners were added, and that exact integrated artifact was runtime-tested and promoted."
        )
        provenance["preservation"]["entity_aware_migration"] = migration_evidence
    dump(out/"validation_record.json",record);dump(out/"promotion_record.json",promotion);dump(out/"provenance.json",provenance)
    write_commands(out,ground,identity,symbol,ground_hash,tile_hash,sum(1 for _ in (out/"events.jsonl").open()),samples,unique_count,reserve_ground,reserve_tile,migration)
    with (out/"commands.sh").open("a") as stream:
        for item in pre_promotion.values():
            if item["preexisting"]:
                stream.write(f"test \"$(sha256sum {item['reserve']} | cut -d' ' -f1)\" = {item['sha256']}\n")
    max_cycle=max((x["source_local_cycle"] for x in plan["cell_animation_schedules"]),default=1)
    result_heading = (
        "PASS — INTEGRATION-PRESERVING ENTITY MIGRATION"
        if migration is not None else
        ("PASS — RECOVERED EXACT ADDITIVE INSTALL AFTER FRESH FULL RERUN" if recovered_partial_additive else ("PASS — PROMOTED WITH PRESERVED CANONICAL MIGRATION" if preexisting else "PASS — PROMOTED ADDITIVELY"))
    )
    if recovered_partial_additive:
        promotion_summary = (
            f"A prior attempt additively installed the previously absent exact candidate destinations, then remained a FAIL because zone integration stopped. "
            f"That failed attempt is preserved at `{partial_recovery_record.relative_to(ROOT).as_posix()}`. Its untracked destination bytes were authenticated "
            f"again against the v2.0.1 candidates and durable failure record, retained without replacement, and accepted only after this fresh full runtime and "
            f"comparison rerun passed. The active Ground/tile hashes are `{ground_hash}` / `{tile_hash}`."
        )
    elif migration is not None:
        names = migration["entity_integration"]["ordered_names"]
        if migration["historical_tile_replaced_after_reserve"]:
            tile_summary = (
                f"Historical tile `{migration['historical_tile_replaced_after_reserve']}` was copied byte-exactly into the durable pre-promotion reserve, then its canonical identity was replaced atomically with authenticated tile `{tile_hash}`. "
            )
        else:
            tile_summary = (
                f"Canonical lowercase tile identity `{migration['canonical_case_tile_identity']}` was created additively, while `{migration['legacy_case_tile_retained_unchanged']}` remained unchanged. "
            )
        promotion_summary = (
            f"The complete occupied Ground and historical tile were reserved at their exact hashes before any replacement. "
            f"Its markers {names['markers']} and spawners {names['spawners']} were preserved unchanged as the only additions to canonical Ground "
            f"`{canonical_ground_hash}`. This exact integrated Ground `{ground_hash}` was the runtime/comparison subject and promoted artifact. "
            f"{tile_summary}All related scripts remained unchanged; no entity was silently deactivated."
        )
    elif preexisting:
        migrated = ", ".join(name for name, item in pre_promotion.items() if item["preexisting"])
        promotion_summary = (
            f"Promotion created the previously absent destinations, except for pre-existing {migrated} bytes that were first copied byte-exactly "
            f"into `RESERVE/pmdred_pre_promotion/{ground}/` and hash-verified before canonical replacement. The active Ground/tile hashes are "
            f"`{ground_hash}` / `{tile_hash}`. No historical bytes were discarded."
        )
    else:
        promotion_summary = (
            f"Promotion created previously absent `Data/Ground/{ground}.rsground` (`{ground_hash}`) and "
            f"`Content/Tile/{ground}_Base.tile` (`{tile_hash}`)."
        )
    if pre_promotion_failure_record is not None:
        promotion_summary += (
            f" The first pre-promotion attempt remains classified as FAIL at "
            f"`{pre_promotion_failure_record.parent.relative_to(ROOT).as_posix()}`; this PASS uses a "
            "complete fresh fixture, runtime, and exhaustive comparison after the narrow gate correction."
        )
    if migration_failure_record is not None:
        promotion_summary += (
            f" The first migration attempt remains classified as FAIL at "
            f"`{migration_failure_record.parent.relative_to(ROOT).as_posix()}`; its exact partial install and reserves were authenticated and retained without replacement, and this PASS uses a complete fresh runtime, comparison, and post-promotion indexing attempt."
        )
    if collision_validation["blocked_probe"]["applicable"]:
        collision_summary = "BMA movement and blocking probes passed."
    else:
        collision_summary = (
            "The movement probe passed; a blocked probe is authentically not applicable because the "
            "raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by "
            "the plan, fixture manifest, and runtime event."
        )
    readme=f"""# {ground} exhaustive exact-PMDO pass

## Result

`{result_heading}`

`{ground}` is the authenticated EU {role['classification'].replace('_',' ')} (`{symbol}`; map ID {identity['map_id']}, map-file ID {identity['map_file_id']}). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **{samples}/{samples}** full-RGBA samples with zero mismatched pixels and full opacity. {collision_summary} Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. {len(primary)} primary boundary ticks ({ticks[0]}–{ticks[-1]}) cover every applicable animation schedule through two complete local cycles (maximum {max_cycle} ticks); {unique_count} distinct primary RGBA frames were observed.

{promotion_summary} Zone integration {zone_registration}, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`{INDEX_SHA256[:8]}…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
"""
    (out/"README.md").write_text(readme)
    provenance=load(out/"provenance.json")
    for path in sorted(out.rglob("*")):
        if path.is_file() and path.name not in {"provenance.json","evidence_hashes.sha256"}: provenance["durable_evidence"][path.relative_to(out).as_posix()]=sha(path)
    dump(out/"provenance.json",provenance)
    manifest_paths=[x for x in sorted(out.rglob("*")) if x.is_file() and x.name!="evidence_hashes.sha256"]+[ROOT/f"Data/Ground/{ground}.rsground",ROOT/f"Content/Tile/{ground}_Base.tile",ROOT/"Data/Zone/master_zone.json",ROOT/f"RESERVE/pmdred_pre_promotion/{ground}/README.md",LOCK_PATH,REPORT_PATH,AUDIT_PATH]
    manifest_paths.extend(ROOT / item["reserve"] for item in pre_promotion.values() if item["preexisting"])
    if partial_recovery_record is not None:
        manifest_paths.append(partial_recovery_record)
    if pre_promotion_failure_record is not None:
        manifest_paths.append(pre_promotion_failure_record)
    if migration_failure_record is not None:
        manifest_paths.append(migration_failure_record)
    if migration is not None:
        if migration["legacy_case_tile_retained_unchanged"]:
            manifest_paths.append(ROOT/migration["legacy_case_tile_retained_unchanged"])
        manifest_paths.extend(ROOT/relative for relative in migration["related_scripts_unchanged"])
        manifest_paths.append(ROOT/migration["canonical_baseline"]["ground"])
    (out/"evidence_hashes.sha256").write_text("".join(f"{sha(path)}  {path.relative_to(ROOT).as_posix()}\n" for path in manifest_paths))


def process_ground(ground: str, all_data: dict[str, Any]) -> None:
    order=all_data["order"]; plans=all_data["plans"]; audits=all_data["audits"]; identities=all_data["identities"]; symbols=all_data["symbols"]
    identity=identities[ground]; symbol=symbols[identity["map_id"]]
    if symbols[identity["map_id"]] != symbol: raise AssertionError
    role=classify_ground_role(symbol); plan=plans[ground]; audit=audits[ground]
    state={"ground":ground,"stage":"preflight","updated_at":time.time()};dump(STATE_PATH,state)
    if audit["status"]!="pass": raise RuntimeError("static audit is not PASS")
    canonical_ground_src=CANONICAL/f"grounds/{ground}.rsground"; tile_src=CANONICAL/f"tiles/{ground}_Base.tile"
    canonical_ground_hash=audit["candidate_sha256"]["rsground"];tile_hash=audit["candidate_sha256"]["tile"]
    if sha(canonical_ground_src)!=canonical_ground_hash or sha(tile_src)!=tile_hash: raise RuntimeError("candidate hash mismatch")
    ground_dst=ROOT/f"Data/Ground/{ground}.rsground";tile_dst=ROOT/f"Content/Tile/{ground}_Base.tile"; evidence=ROOT/f"docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass"
    if evidence.exists():
        log(f"SKIP already evidenced {ground}");return
    reserve_dir=ROOT/f"RESERVE/pmdred_pre_promotion/{ground}"
    pre_ground_reserve=reserve_dir/ground_dst.name; pre_tile_reserve=reserve_dir/tile_dst.name
    recovery_record_path=partial_additive_recovery_record(ground,ground_dst,tile_dst,canonical_ground_hash,tile_hash)
    pre_promotion_failure_path = pre_promotion_collision_failure_record(ground, ground_dst, tile_dst)
    migration_policy = MIGRATION_POLICIES.get(ground) if ground_dst.is_file() and recovery_record_path is None else None
    legacy_tile: Path | None = ROOT / migration_policy["historical_tile"] if migration_policy is not None else None
    pre_legacy_tile_reserve: Path | None = reserve_dir / legacy_tile.name if legacy_tile is not None else None
    migration_tile_replaces_canonical = bool(
        migration_policy is not None
        and migration_policy.get("tile_migration_mode", "retain_distinct_historical_identity")
        == "reserve_and_replace_canonical_identity"
    )
    migration_recovery_path: Path | None = None
    if migration_policy is not None:
        assert legacy_tile is not None and pre_legacy_tile_reserve is not None
        migration_recovery_path = partial_entity_migration_recovery_record(
            ground, ground_dst, tile_dst, legacy_tile,
            pre_ground_reserve, pre_legacy_tile_reserve, migration_policy,
        )
    recovery_modes = [
        recovery_record_path is not None,
        pre_promotion_failure_path is not None,
        migration_recovery_path is not None,
    ]
    if sum(recovery_modes) > 1:
        raise RuntimeError(f"conflicting recovery modes for {ground}")
    if ground_dst.is_file() and recovery_record_path is None and migration_policy is None:
        raise RuntimeError(f"occupied Ground destination for {ground}; entity-aware migration is required")
    if migration_policy is not None and pre_promotion_failure_path is not None:
        raise RuntimeError(f"occupied migration cannot reuse a pre-promotion failure mode for {ground}")
    if recovery_record_path is not None:
        # These fields describe the historical destination precondition, not the
        # exact additive bytes retained from the explicitly failed first attempt.
        pre_promotion = {
            "ground": {"preexisting": False, "sha256": None, "reserve": None},
            "tile": {"preexisting": False, "sha256": None, "reserve": None},
        }
        log(f"PARTIAL_ADDITIVE_RECOVERY_AUTHENTICATED ground={ground} record={recovery_record_path.relative_to(ROOT)}")
    elif migration_recovery_path is not None:
        assert migration_policy is not None and legacy_tile is not None and pre_legacy_tile_reserve is not None
        pre_promotion = {
            "ground": {"preexisting": True, "sha256": migration_policy["historical_ground_sha256"],
                       "reserve": pre_ground_reserve.relative_to(ROOT).as_posix()},
            "tile": {
                "preexisting": migration_tile_replaces_canonical,
                "sha256": migration_policy["historical_tile_sha256"] if migration_tile_replaces_canonical else None,
                "reserve": pre_legacy_tile_reserve.relative_to(ROOT).as_posix() if migration_tile_replaces_canonical else None,
            },
        }
        if not migration_tile_replaces_canonical:
            pre_promotion["legacy_case_tile"] = {
                "preexisting": True,
                "sha256": migration_policy["historical_tile_sha256"],
                "reserve": pre_legacy_tile_reserve.relative_to(ROOT).as_posix(),
            }
        log(
            f"PARTIAL_ENTITY_MIGRATION_RECOVERY_AUTHENTICATED ground={ground} "
            f"record={migration_recovery_path.relative_to(ROOT)} fresh_rerun=true"
        )
    else:
        pre_promotion = {
            "ground": {"preexisting": ground_dst.is_file(), "sha256": sha(ground_dst) if ground_dst.is_file() else None,
                       "reserve": pre_ground_reserve.relative_to(ROOT).as_posix() if ground_dst.is_file() else None},
            "tile": {"preexisting": tile_dst.is_file(), "sha256": sha(tile_dst) if tile_dst.is_file() else None,
                     "reserve": pre_tile_reserve.relative_to(ROOT).as_posix() if tile_dst.is_file() else None},
        }
    if migration_policy is not None and migration_recovery_path is None:
        assert legacy_tile is not None and pre_legacy_tile_reserve is not None
        if migration_tile_replaces_canonical:
            migration_tile_record = pre_promotion["tile"]
        else:
            pre_promotion["legacy_case_tile"] = {
                "preexisting": legacy_tile.is_file(),
                "sha256": sha(legacy_tile) if legacy_tile.is_file() else None,
                "reserve": pre_legacy_tile_reserve.relative_to(ROOT).as_posix(),
            }
            migration_tile_record = pre_promotion["legacy_case_tile"]
        required = [
            pre_promotion["ground"]["sha256"] == migration_policy["historical_ground_sha256"],
            tile_dst.is_file() if migration_tile_replaces_canonical else not tile_dst.exists(),
            migration_tile_record["sha256"] == migration_policy["historical_tile_sha256"],
            migration_tile_record["reserve"] == pre_legacy_tile_reserve.relative_to(ROOT).as_posix(),
            not reserve_dir.exists(),
        ]
        if not all(required):
            raise RuntimeError(f"occupied Ground migration precondition failed for {ground}: {required}")
        log(
            f"ENTITY_AWARE_MIGRATION_REQUIRED ground={ground} "
            f"historical_ground_sha256={pre_promotion['ground']['sha256']} "
            f"historical_tile_sha256={migration_tile_record['sha256']} "
            f"tile_mode={migration_policy.get('tile_migration_mode', 'retain_distinct_historical_identity')}"
        )
    elif migration_policy is None and tile_dst.exists() and recovery_record_path is None:
        historical_tile=ROOT/f"RESERVE/red_tiles/{ground}_Base.tile"
        if not historical_tile.is_file() or sha(historical_tile) != pre_promotion["tile"]["sha256"]:
            raise RuntimeError(f"occupied tile for {ground} does not match its preserved historical reserve")
        if reserve_dir.exists():
            raise RuntimeError(f"pre-promotion reserve path already exists for unvalidated {ground}")
        log(f"PRESERVED_MIGRATION_REQUIRED ground={ground} tile_sha256={pre_promotion['tile']['sha256']}")
    if pre_promotion_failure_path is not None:
        log(
            f"PRE_PROMOTION_FAILURE_PRESERVED ground={ground} "
            f"record={pre_promotion_failure_path.relative_to(ROOT)} fresh_rerun=true"
        )
    suffix="-recovery-rerun" if any(recovery_modes) else ""
    fixture=ROOT/f".runtime-cache/pmdred-eu-{ground}-runtime{suffix}"; comparison=ROOT/f".runtime-cache/pmdred-eu-{ground}-comparison{suffix}"
    post_candidate=ROOT/f".runtime-cache/pmdred-eu-{ground}-promoted-candidate{suffix}";post_fixture=ROOT/f".runtime-cache/pmdred-eu-{ground}-promoted-fixture{suffix}"
    migration_root=ROOT/f".runtime-cache/pmdred-eu-{ground}-entity-integrated-candidate{suffix}"
    runtime_candidate_root=CANONICAL
    migration: dict[str, Any] | None = None
    create_only_paths=[fixture,comparison,post_candidate,post_fixture]
    if migration_policy is not None:
        create_only_paths.append(migration_root)
    for path in create_only_paths:
        if path.exists(): raise FileExistsError(f"create-only runtime path exists: {path}")
    if migration_policy is not None:
        assert legacy_tile is not None
        migration = build_migration(
            ROOT, ground, migration_root, policy=migration_policy,
            historical_ground=pre_ground_reserve if migration_recovery_path is not None else ground_dst,
            historical_tile=(
                pre_legacy_tile_reserve
                if migration_recovery_path is not None and migration_tile_replaces_canonical
                else legacy_tile
            ),
            canonical_root=CANONICAL,
        )
        runtime_candidate_root=migration_root
        ground_src=migration_root/f"grounds/{ground}.rsground"
        ground_hash=migration["integrated_candidate"]["ground_sha256"]
        if sha(ground_src) != ground_hash or migration["canonical_baseline"]["ground_sha256"] != canonical_ground_hash:
            raise RuntimeError("entity-integrated candidate readback failed")
        entity_counts = migration["entity_integration"]["entity_counts"]
        log(
            f"ENTITY_INTEGRATION_PASS ground={ground} canonical={canonical_ground_hash} "
            f"integrated={ground_hash} markers={entity_counts['markers']} "
            f"spawners={entity_counts['spawners']}"
        )
    else:
        ground_src=canonical_ground_src
        ground_hash=canonical_ground_hash
    fixture_command=[str(PYTHON),"tools/build_pmdred_eu_runtime_fixture.py","--conversion-set","remaining","--candidate-root",str(runtime_candidate_root),"--plan",str(PLAN_PATH),"--ids",ground,"--output",str(fixture)]
    if migration is not None:
        fixture_command.extend(["--entity-integrated-ids",ground,"--canonical-baseline-root",str(CANONICAL)])
    run(fixture_command)
    run_index(fixture,fixture/"index.log");state["stage"]="indexed";dump(STATE_PATH,state)
    run_validator(ground,fixture,plan["sample_count"]+1);state["stage"]="runtime_terminal";dump(STATE_PATH,state)
    comparison.mkdir()
    with (comparison/"comparison.log").open("wb") as stream:
        command=[str(PYTHON),"tools/compare_pmdred_eu_pmdo_renders.py","--events",str(fixture/"events.jsonl"),"--screenshots",str(fixture/"appdata/SCREENSHOT"),"--reference-plan",str(PLAN_PATH),"--source-dir",str(SOURCE),"--conversion-report",str(CANONICAL/"conversion_report.json"),"--output",str(comparison),"--report",str(comparison/"report.json"),"--workers","2"]
        result=subprocess.run(command,cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT)
    if result.returncode: raise RuntimeError("comparator failed")
    report=load(comparison/"report.json");rt=report["runtime"];primary=[x for x in report["samples"] if x["phase"]=="primary"]
    vals={(x["ground"],x["phase"]):x for x in rt["validations"]}
    collision_validation = build_collision_validation(
        plan, load(fixture / "fixture_manifest.json")["entries"][0], vals[(ground,"primary")]
    )
    expected=plan["sample_count"]+1
    gates=[report["grounds"]==[ground],report["sample_count"]==expected,len(primary)==plan["sample_count"],report["exact_sample_count"]==expected,report["fully_opaque_sample_count"]==expected,report["all_exact"],report["all_fully_opaque"],rt["all_runtime_safe"],rt["runtime_sequence_consistent"],rt["native_lifecycle_order"]["pass"],rt["all_cleanups_pass"],rt["end_event_seen"],rt["same_ground_reentry_count"]==1,vals[(ground,"primary")]["movement_probe"]=="PASS",collision_validation["result"]=="PASS",vals[(ground,"reload")]["load"]=="LOAD_PASS",all(x["mismatched_pixels"]==0 and x["maximum_channel_delta"]==0 for x in report["samples"])]
    if not all(gates): raise RuntimeError(f"comparison/runtime gate failed for {ground}: {gates}")
    state["stage"]="comparison_pass";dump(STATE_PATH,state);log(f"COMPARE_PASS ground={ground} samples={expected} unique={len({x['actual_rgba_sha256'] for x in primary})}")
    if recovery_record_path is not None:
        if sha(ground_dst)!=ground_hash or sha(tile_dst)!=tile_hash:
            raise RuntimeError("partial additive recovery bytes changed during fresh runtime/comparison")
        log(f"PARTIAL_ADDITIVE_INSTALL_RETAINED ground={ground} replacement=false")
    elif migration is not None:
        assert legacy_tile is not None and pre_legacy_tile_reserve is not None
        if migration_recovery_path is not None:
            historical_tile_record = (
                pre_promotion["tile"]
                if migration_tile_replaces_canonical
                else pre_promotion["legacy_case_tile"]
            )
            recovery_gates = [
                sha(ground_dst) == ground_hash,
                sha(tile_dst) == tile_hash,
                sha(pre_ground_reserve) == pre_promotion["ground"]["sha256"],
                sha(pre_legacy_tile_reserve) == historical_tile_record["sha256"],
                sha(legacy_tile) == (
                    tile_hash if migration_tile_replaces_canonical else historical_tile_record["sha256"]
                ),
            ]
            if not all(recovery_gates):
                raise RuntimeError(f"partial entity migration install changed during fresh rerun: {recovery_gates}")
            log(f"PARTIAL_ENTITY_MIGRATION_INSTALL_RETAINED ground={ground} replacement=false")
        else:
            migration_tile_record = (
                pre_promotion["tile"]
                if migration_tile_replaces_canonical
                else pre_promotion["legacy_case_tile"]
            )
            reserve_dir.mkdir(parents=True)
            atomic_install(ground_dst,pre_ground_reserve)
            atomic_install(legacy_tile,pre_legacy_tile_reserve)
            reserve_gates = [
                sha(pre_ground_reserve) == pre_promotion["ground"]["sha256"],
                sha(pre_legacy_tile_reserve) == migration_tile_record["sha256"],
                sha(legacy_tile) == migration_tile_record["sha256"],
            ]
            if not all(reserve_gates):
                raise RuntimeError(f"occupied migration reserve readback failed: {reserve_gates}")
            atomic_replace_preserved(
                ground_src, ground_dst, pre_ground_reserve, pre_promotion["ground"]["sha256"]
            )
            if migration_tile_replaces_canonical:
                atomic_replace_preserved(
                    tile_src, tile_dst, pre_legacy_tile_reserve, migration_tile_record["sha256"]
                )
            else:
                atomic_install(tile_src,tile_dst)
            log(
                f"ENTITY_AWARE_MIGRATION_INSTALLED ground={ground} historical_reserved=true "
                f"tile_mode={migration['tile_migration']['mode']}"
            )
    else:
        if pre_promotion["tile"]["preexisting"]:
            reserve_dir.mkdir(parents=True)
            atomic_install(tile_dst,pre_tile_reserve)
            if sha(pre_tile_reserve) != pre_promotion["tile"]["sha256"]:
                raise RuntimeError("pre-promotion tile reserve readback failed")
        atomic_install(ground_src,ground_dst)
        if pre_promotion["tile"]["preexisting"]:
            atomic_replace_preserved(tile_src,tile_dst,pre_tile_reserve,pre_promotion["tile"]["sha256"])
        else:
            atomic_install(tile_src,tile_dst)
    validated=set(load(ROOT/"docs/pmdred_eu/pmdo_validation/progress.json")["validated_ids"])
    zone_pre,zone_post,prior,zone_index=insert_zone(
        ground, order, validated, retain_existing=migration is not None
    )
    if migration is not None and zone_pre == zone_post:
        log(f"ENTITY_MIGRATION_ZONE_ENTRY_RETAINED ground={ground} index={zone_index} predecessor={prior}")
    if sha(ground_dst)!=ground_hash or sha(tile_dst)!=tile_hash: raise RuntimeError("promotion readback failed")
    reserve_dir.mkdir(parents=True,exist_ok=True)
    reserve_ground=ROOT/f"RESERVE/red_grounds/{ground}.rsground";reserve_tile=ROOT/f"RESERVE/red_tiles/{ground}_Base.tile"
    if any(item["preexisting"] for item in pre_promotion.values()):
        preserved_rows="\n".join(
            f"| `{Path(item['reserve']).name}` | `{item['sha256']}` |"
            for item in pre_promotion.values() if item["preexisting"]
        )
        if migration is not None:
            tile_preservation_note = (
                "The pre-existing canonical-identity tile was also reserved byte-exactly and then replaced atomically with the independently validated authenticated tile. "
                if migration_tile_replaces_canonical else
                "The canonical lowercase tile identity was created additively, while the distinct legacy-case tile remained unchanged. "
            )
            migration_note = (
                "The complete occupied Ground and historical tile were copied byte-exactly into this directory and hash-verified. "
                "Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. "
                "The active Ground was then replaced atomically. " + tile_preservation_note
            )
        else:
            migration_note = (
                "The destination Ground was absent. Every pre-existing tile byte was copied into this directory and hash-verified before the active destination was replaced atomically with the independently validated authenticated EU v2.0.1 candidate. "
            )
        reserve_note=f"""# `{ground}` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on {DATE}. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
{preserved_rows}

{migration_note}No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `{zone_pre}`.

Historical reserve Ground: `{sha(reserve_ground) if reserve_ground.is_file() else 'absent'}`. Historical reserve tile: `{sha(reserve_tile) if reserve_tile.is_file() else 'absent'}`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `{symbol}` / map ID {identity['map_id']} / map-file ID {identity['map_file_id']}.

Evidence: `docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass/`.
"""
    else:
        recovery_note=(f" The exact additive installation occurred during a prior attempt that remains classified as FAIL at `{recovery_record_path.relative_to(ROOT).as_posix()}`; its bytes were retained without replacement only after hash authentication and a fresh full rerun." if recovery_record_path is not None else "")
        reserve_note=f"# `{ground}` pre-promotion record\n\nBoth canonical lowercase destinations were absent before the {DATE} additive promotion.{recovery_note} Pre-promotion `master_zone.json` SHA-256: `{zone_pre}`. No existing worktree asset was replaced.\n\nHistorical reserve Ground: `{sha(reserve_ground) if reserve_ground.is_file() else 'absent'}`. Historical reserve tile: `{sha(reserve_tile) if reserve_tile.is_file() else 'absent'}`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `{symbol}` / map ID {identity['map_id']} / map-file ID {identity['map_file_id']}.\n\nEvidence: `docs/pmdred_eu/pmdo_validation/{ground}_exhaustive_pass/`.\n"
    (reserve_dir/"README.md").write_text(reserve_note)
    state["stage"]="promoted";dump(STATE_PATH,state)
    (post_candidate/"grounds").mkdir(parents=True);(post_candidate/"tiles").mkdir()
    shutil.copyfile(ground_dst,post_candidate/"grounds"/ground_dst.name);shutil.copyfile(tile_dst,post_candidate/"tiles"/tile_dst.name);shutil.copyfile(CANONICAL/"conversion_report.json",post_candidate/"conversion_report.json")
    post_fixture_command=[str(PYTHON),"tools/build_pmdred_eu_runtime_fixture.py","--conversion-set","remaining","--candidate-root",str(post_candidate),"--plan",str(PLAN_PATH),"--ids",ground,"--output",str(post_fixture)]
    if migration is not None:
        post_fixture_command.extend(["--entity-integrated-ids",ground,"--canonical-baseline-root",str(CANONICAL)])
    run(post_fixture_command)
    run_index(post_fixture,post_fixture/"post_promotion_index.log")
    package_evidence(
        ground,symbol,role,identity,audit,plan,fixture,comparison,post_fixture,
        zone_pre,zone_post,prior,zone_index,pre_promotion,recovery_record_path,
        pre_promotion_failure_path,migration_recovery_path,migration,
    )
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
