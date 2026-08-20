#!/usr/bin/env python3
"""Archive a create-only Tiny Woods palette-semantics native certification."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
from datetime import date
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SEMANTICS = ROOT / "docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json"
PLAN = ROOT / "docs/pmdred_eu/playable/tiny_woods/command_plan.json"
SOURCE_FILES = [
    ROOT / "tools/build_pmdred_tiny_woods_palette_semantics.py",
    ROOT / "tools/build_pmdred_tiny_woods_palette_overlay.py",
    ROOT / "tools/pmdred_tiny_woods_palette_validator.lua",
    ROOT / "tools/run_pmdred_tiny_woods_palette_certification.py",
    ROOT / "tools/certify_pmdred_tiny_woods_palette_semantics.py",
]
FIXTURE_SCRIPTS = [
    "quest/Data/Script/halcyon/pmdred_palette_adapter.lua",
    "quest/Data/Script/halcyon/pmdred_tiny_woods_scenes.lua",
    "quest/Data/Script/halcyon/pmdred_tiny_woods_command_campaign.lua",
    "quest/Data/Script/halcyon/ground/d01p01/init.lua",
    "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def record(path: Path) -> dict[str, Any]:
    return {"bytes": path.stat().st_size, "sha256": sha256(path)}


def copy_file(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, destination)


def strict_termination(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not (
        value.get("result") == "PASS" and value.get("exit_classification") == "NORMAL_EXIT"
        and value.get("return_code") == 0 and value.get("terminal") is True and value.get("graceful") is True
        and value.get("watchdog") is False and value.get("requested_signal") is None
        and value.get("sigsegv") is False and value.get("forced_kill") is False
        and value.get("orphan_process") is False and value.get("load_phase_unload", {}).get("pass") is True
    ):
        raise ValueError(f"strict native termination differs: {path}")
    return value


def build(fixture: Path, evidence: Path, output: Path) -> dict[str, Any]:
    fixture = fixture.resolve();evidence = evidence.resolve();output = output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite palette archive: {output}")
    report_path = evidence / "native_palette_validation.json"
    report = json.loads(report_path.read_text(encoding="utf-8"))
    if report.get("schema") != "pmdred-eu-tiny-woods-palette-native-v1" or report.get("status") != "passed":
        raise ValueError("native palette report differs")
    if report.get("combined", {}).get("exact_palette_commands_isolated") != 15 or report.get("combined", {}).get("selected_route_palette_commands_integrated") != 14:
        raise ValueError("native palette aggregate differs")
    if [run.get("mode") for run in report.get("runs", [])] != ["opening_naming", "post_route", "palette_adapter_all"]:
        raise ValueError("native palette mode order differs")
    for run in report["runs"]:
        mode = run["mode"]
        if run.get("result") != "PASS" or run.get("palette", {}).get("strict_start_complete_adjacency") is not True:
            raise ValueError(f"native palette run differs: {mode}")
        strict_termination(evidence / mode / "termination.json")
        for key, name in (("events_sha256", "events.jsonl"), ("runtime_log_sha256", "runtime.log"), ("termination_sha256", "termination.json")):
            if run.get(key) != sha256(evidence / mode / name):
                raise ValueError(f"native palette evidence identity differs: {mode}/{name}")

    fixture_manifest = json.loads((fixture / "fixture_manifest.json").read_text(encoding="utf-8"))
    palette_manifest = fixture_manifest.get("tiny_woods_palette_semantics", {})
    if palette_manifest.get("semantics_sha256") != sha256(SEMANTICS) or palette_manifest.get("commands") != 15:
        raise ValueError("fixture palette manifest differs")
    for relative in FIXTURE_SCRIPTS:
        path = fixture / relative
        expected = palette_manifest["files"].get(relative)
        if not path.is_file() or expected is None or record(path) != expected:
            raise ValueError(f"fixture script identity differs: {relative}")
    for source in SOURCE_FILES:
        if not source.is_file():
            raise FileNotFoundError(source)

    output.mkdir(parents=True)
    for source in evidence.rglob("*"):
        if source.is_file():
            copy_file(source, output / source.relative_to(evidence))
    for relative in FIXTURE_SCRIPTS:
        copy_file(fixture / relative, output / "fixture_scripts" / relative)
    for source in SOURCE_FILES:
        copy_file(source, output / "sources" / source.relative_to(ROOT))

    provenance = {
        "schema": "pmdred-eu-tiny-woods-palette-provenance-v1", "date": str(date.today()),
        "repository_head_before_palette_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
        "authority": {
            "region": "EU", "rom_sha256": "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd",
            "command_plan": {"path": str(PLAN.relative_to(ROOT)), **record(PLAN)},
            "semantics": {"path": str(SEMANTICS.relative_to(ROOT)), **record(SEMANTICS)},
        },
        "technical_references": {
            "pret_pmd_red_commit": "bf0092d0e34fd8e49b859a0b5f96f00740faa42d",
            "rogueessence_commit": "4961b2271bb0cace74f40f6a85e799e8e4848ace",
            "pmdo_version": "0.8.12.0",
            "pmdo_sha256": "faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327",
        },
        "source_files": {str(path.relative_to(ROOT)): record(path) for path in SOURCE_FILES},
        "fixture_scripts": {relative: record(fixture / relative) for relative in FIXTURE_SCRIPTS},
        "source_evidence": str(evidence),
        "source_fixture": str(fixture),
    }
    (output / "provenance.json").write_text(json.dumps(provenance, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    commands = """#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
PY=.runtime-cache/test-venv/bin/python
SEM=.runtime-cache/pmdred-tiny-woods-palette-semantics-repro-v1.json
FIX=.runtime-cache/pmdred-tiny-woods-palette-repro-v1
EVD=.runtime-cache/pmdred-tiny-woods-palette-evidence-repro-v1
$PY tools/build_pmdred_tiny_woods_palette_semantics.py --output "$SEM"
cmp "$SEM" docs/pmdred_eu/playable/tiny_woods/secondary_palette_semantics_v1.json
$PY tools/build_pmdred_tiny_woods_palette_overlay.py --output "$FIX"
PYTHONPATH=tools $PY tools/run_pmdred_tiny_woods_palette_certification.py --fixture "$FIX" --evidence-dir "$EVD" --timeout-seconds 300
$PY tools/certify_pmdred_tiny_woods_palette_semantics.py --fixture "$FIX" --evidence-dir "$EVD" --output .runtime-cache/pmdred-tiny-woods-palette-archive-repro-v1
"""
    commands_path = output / "commands.sh"
    commands_path.write_text(commands, encoding="utf-8");os.chmod(commands_path, 0o755)

    certificate = {
        "schema": "pmdred-eu-tiny-woods-palette-certificate-v1", "date": str(date.today()), "status": "PASS",
        "native_report_sha256": sha256(output / "native_palette_validation.json"),
        "fixture_manifest_sha256": sha256(output / "fixture_manifest.json"),
        "semantics_sha256": sha256(output / "secondary_palette_semantics_v1.json"),
        "provenance_sha256": sha256(output / "provenance.json"),
        "modes": 3, "exact_palette_commands": 15, "selected_route_integrated_commands": 14,
        "selected_route_dialogues_closed": 94,
        "strict_native_terminations": 3,
        "unknown_planning_fallback_retained": True,
        "result": "TINY_WOODS_PALETTE_NATIVE_PASS modes=3 commands=15 selected_route=14 dialogues=94",
    }
    (output / "palette_certificate.json").write_text(json.dumps(certificate, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    hash_entries = []
    for path in sorted(output.rglob("*")):
        if path.is_file() and path.name != "evidence_hashes.sha256":
            hash_entries.append(f"{sha256(path)}  {path.relative_to(output)}")
    (output / "evidence_hashes.sha256").write_text("\n".join(hash_entries) + "\n", encoding="utf-8")
    print(f"TINY_WOODS_PALETTE_ARCHIVE_PASS files={len(hash_entries) + 1} output={output}")
    return certificate


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    build(args.fixture, args.evidence_dir, args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
