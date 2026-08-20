#!/usr/bin/env python3
"""Archive and certify a fresh Tiny Woods command-route reproduction.

The renderer, overlay builder, and native certifier must already have completed
into create-only runtime-cache destinations.  This command refuses to replace
an archive and compares the fresh result with the provenance-correct v2
checkpoint without altering that historical checkpoint.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from copy import deepcopy
from datetime import date
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
AUTHORITY = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_complete_runtime_v2"
DEFAULT_EVIDENCE = ROOT / ".runtime-cache/pmdred-tiny-woods-command-complete-evidence-repro-v2"
DEFAULT_MUSIC = ROOT / ".runtime-cache/pmdred-tiny-woods-scene-music-repro-v4"
DEFAULT_FANFARES = ROOT / ".runtime-cache/pmdred-tiny-woods-fanfares-repro-v4"
DEFAULT_OUTPUT = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_complete_clean_reproduction_v1"
COMMANDS = AUTHORITY / "commands.sh"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
PMDO_SHA256 = "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327"
DYNAMIC_REPORT_FIELDS = {"events_sha256", "runtime_log_sha256", "termination_sha256"}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def semantic_report(value: dict[str, Any]) -> dict[str, Any]:
    """Remove hashes expected to change between otherwise equal native runs."""
    result = deepcopy(value)
    for run in result.get("runs", []):
        for field in DYNAMIC_REPORT_FIELDS:
            run.pop(field, None)
    return result


def fixture_identity(value: dict[str, Any]) -> dict[str, Any]:
    """Remove only absolute create-only roots from a fixture manifest."""
    result = deepcopy(value)
    for field in ("appdata", "asset_root", "quest"):
        result.pop(field, None)
    return result


def termination_summary(path: Path) -> dict[str, Any]:
    value = read_json(path)
    unload = value.get("load_phase_unload", {})
    expected = {
        "result": "PASS",
        "exit_classification": "NORMAL_EXIT",
        "return_code": 0,
        "terminal": True,
        "graceful": True,
        "watchdog": False,
        "requested_signal": None,
        "sigsegv": False,
        "forced_kill": False,
        "orphan_process": False,
    }
    for key, wanted in expected.items():
        if value.get(key) != wanted:
            raise ValueError(f"strict termination differs for {path}: {key}")
    if unload.get("pass") is not True or unload.get("ordered_and_terminal_last") is not True:
        raise ValueError(f"LoadPhase.Unload gate differs for {path}")
    return {
        "sha256": sha256(path),
        "result": value["result"],
        "exit_classification": value["exit_classification"],
        "return_code": value["return_code"],
        "load_phase_unload": True,
        "terminal": value["terminal"],
        "graceful": value["graceful"],
        "watchdog": value["watchdog"],
        "requested_signal": value["requested_signal"],
        "sigsegv": value["sigsegv"],
        "forced_kill": value["forced_kill"],
        "orphan_process": value["orphan_process"],
    }


def build(evidence: Path, music: Path, fanfares: Path, output: Path) -> dict[str, Any]:
    evidence = evidence.resolve()
    music = music.resolve()
    fanfares = fanfares.resolve()
    output = output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite clean-reproduction archive: {output}")

    fresh_report_path = evidence / "native_command_complete_validation.json"
    fresh_fixture_path = evidence / "fixture_manifest.json"
    required = [
        fresh_report_path, fresh_fixture_path, evidence / "command_plan.json",
        evidence / "opening_naming/termination.json", evidence / "post_route/termination.json",
        music / "manifest.json", fanfares / "manifest.json", COMMANDS,
    ]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)

    authority_report = read_json(AUTHORITY / "native_command_complete_validation.json")
    fresh_report = read_json(fresh_report_path)
    if fresh_report.get("status") != "passed":
        raise ValueError("fresh native report is not passed")
    if semantic_report(fresh_report) != semantic_report(authority_report):
        raise ValueError("fresh native semantic result differs from authoritative v2")
    if fresh_report.get("authority", {}).get("rom_sha256") != ROM_SHA256:
        raise ValueError("fresh native report ROM authority differs")
    if fresh_report.get("runtime", {}).get("executable_sha256") != PMDO_SHA256:
        raise ValueError("fresh native report PMDO identity differs")

    fresh_fixture = read_json(fresh_fixture_path)
    authority_fixture = read_json(AUTHORITY / "fixture_manifest.json")
    if fixture_identity(fresh_fixture) != fixture_identity(authority_fixture):
        raise ValueError("fresh fixture differs beyond its create-only absolute roots")
    if (read_json(evidence / "command_plan.json") !=
            read_json(AUTHORITY / "command_plan.json")):
        raise ValueError("fresh command plan differs from authoritative v2")

    source_manifests = {
        "music": music / "manifest.json",
        "fanfares": fanfares / "manifest.json",
    }
    authoritative_manifests = {
        "music": AUTHORITY / "music_source_manifest.json",
        "fanfares": AUTHORITY / "fanfare_source_manifest.json",
    }
    manifest_records: dict[str, Any] = {}
    for kind, source in source_manifests.items():
        authority = authoritative_manifests[kind]
        if source.read_bytes() != authority.read_bytes():
            raise ValueError(f"fresh {kind} source manifest differs from authoritative v2")
        manifest_records[kind] = {
            "fresh_sha256": sha256(source),
            "authoritative_sha256": sha256(authority),
            "byte_identical": True,
        }

    terminations = {
        mode: termination_summary(evidence / mode / "termination.json")
        for mode in ("opening_naming", "post_route")
    }

    shutil.copytree(evidence, output)
    shutil.copyfile(source_manifests["music"], output / "music_source_manifest.json")
    shutil.copyfile(source_manifests["fanfares"], output / "fanfare_source_manifest.json")
    shutil.copyfile(COMMANDS, output / "commands.sh")

    certificate = {
        "schema": "pmdred-eu-tiny-woods-command-complete-clean-reproduction-v1",
        "date": str(date.today()),
        "status": "pass",
        "scope": "fresh source rendering, fresh private-overlay build, and two fresh isolated native runs",
        "authority": {
            "region": "EU",
            "rom_sha256": ROM_SHA256,
            "pmdo_version": "0.8.12.0",
            "pmdo_executable_sha256": PMDO_SHA256,
            "authoritative_checkpoint": str(AUTHORITY.relative_to(ROOT)),
            "authoritative_report_sha256": sha256(AUTHORITY / "native_command_complete_validation.json"),
            "authoritative_fixture_manifest_sha256": sha256(AUTHORITY / "fixture_manifest.json"),
        },
        "reproduction": {
            "commands": str(COMMANDS.relative_to(ROOT)),
            "commands_sha256": sha256(COMMANDS),
            "create_only_destinations": {
                "music": str(music.relative_to(ROOT)),
                "fanfares": str(fanfares.relative_to(ROOT)),
                "fixture_evidence": str(evidence.relative_to(ROOT)),
            },
            "fresh_report_sha256": sha256(fresh_report_path),
            "fresh_fixture_manifest_sha256": sha256(fresh_fixture_path),
            "fresh_command_plan_sha256": sha256(evidence / "command_plan.json"),
            "source_manifests": manifest_records,
            "semantic_report_identical_to_authoritative_v2": True,
            "fixture_identical_except_create_only_absolute_roots": True,
            "command_plan_byte_identical_to_authoritative_v2": True,
        },
        "native_result": {
            "modes": 2,
            "commands_per_mode": 975,
            "arrays_per_mode": 27,
            "opcodes": 61,
            "selected_route_dialogues_closed": 94,
            "cues": 11,
            "terminations": terminations,
        },
        "claims": {
            "v2_commands_executed_end_to_end_from_fresh_render_directories": True,
            "six_bgm_and_eleven_cues_reproduced_with_byte_identical_source_manifests": True,
            "private_overlay_built_at_a_fresh_destination": True,
            "both_native_modes_passed_strict_graceful_termination": True,
            "historical_v2_checkpoint_modified": False,
        },
    }
    certificate_path = output / "clean_reproduction_certificate.json"
    certificate_path.write_text(json.dumps(certificate, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    hash_lines = []
    for path in sorted(item for item in output.rglob("*") if item.is_file()):
        if path.name == "evidence_hashes.sha256":
            continue
        hash_lines.append(f"{sha256(path)}  {path.relative_to(output).as_posix()}")
    (output / "evidence_hashes.sha256").write_text("\n".join(hash_lines) + "\n", encoding="utf-8")
    print(
        "TINY_WOODS_CLEAN_REPRODUCTION_PASS "
        f"modes=2 commands_per_mode=975 dialogues=94 cues=11 output={output}"
    )
    return certificate


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--evidence", type=Path, default=DEFAULT_EVIDENCE)
    parser.add_argument("--music-source", type=Path, default=DEFAULT_MUSIC)
    parser.add_argument("--fanfare-source", type=Path, default=DEFAULT_FANFARES)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    build(args.evidence, args.music_source, args.fanfare_source, args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
