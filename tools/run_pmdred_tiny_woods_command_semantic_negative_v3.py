#!/usr/bin/env python3
"""Prove graceful propagation of an ordinal-0 semantic metadata failure."""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

import run_pmdred_tiny_woods_command_semantic_v3 as semantic

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--certifier-output", type=Path, required=True)
    parser.add_argument("--timeout-seconds", type=int, default=240)
    args = parser.parse_args()
    fixture = args.fixture.resolve(); evidence = args.evidence_dir.resolve(); rejected = args.certifier_output.resolve()
    if evidence.exists() or rejected.exists():
        raise FileExistsError("negative proof destinations are create-only")
    manifest, semantic_manifest = semantic.authenticate(fixture, allow_fault=True)
    if semantic_manifest.get("fault_injection") != {"kind": "address_mismatch", "ordinal": 0} or semantic_manifest.get("certification_eligible") is not False:
        raise ValueError("negative fixture is not the explicit ordinal-0 address mismatch")
    runner = semantic.load_tool("run_pmdred_eu_native_fixture")
    old = semantic.load_tool("run_pmdred_tiny_woods_command_complete")
    evidence.mkdir(parents=True)
    semantic.dump(evidence / "fixture_manifest.json", manifest)
    shutil.copyfile(semantic.PLAN, evidence / "command_plan.json")
    shutil.copyfile(semantic.SUPPLEMENT, evidence / "command_semantic_supplement_v3.json")
    index_gate = old.index_fixture(fixture, evidence, runner)

    wrapper = fixture / "command-semantic-v3-negative" / "ordinal-0-address-mismatch"
    wrapper.mkdir(parents=True)
    (wrapper / "asset").symlink_to(fixture / "asset", target_is_directory=True)
    (wrapper / "appdata").symlink_to(fixture / "appdata", target_is_directory=True)
    namespace = argparse.Namespace(
        fixture=wrapper, ground="semantic_selected_v3_negative", expected_screenshots=0,
        timeout_seconds=args.timeout_seconds, events=semantic.EVENTS,
        validator_mode="tiny_woods_command_semantic_v3",
        environment=["TINY_WOODS_COMMAND_MODE=semantic_selected_v3", "TINY_WOODS_COMMAND_SEED=424242"],
    )
    runner.run(namespace)
    run_dir = evidence / "semantic_selected_v3"
    run_dir.mkdir()
    for name in ("runtime.log", "events.jsonl", "termination.json"):
        shutil.copyfile(wrapper / name, run_dir / name)
    events = semantic.read_events(run_dir / "events.jsonl")
    errors = [event for event in events if event.get("event") == "command_semantic_error"]
    traces = [event for event in events if event.get("event") == "command_semantic_trace"]
    verdicts = [event for event in events if event.get("event") == "command_semantic_verdict"]
    termination = old.strict_termination(run_dir / "termination.json")
    if len(errors) != 1 or errors[0].get("kind") != "start" or errors[0].get("ordinal") != 0 or errors[0].get("expected_address") != "0x084CB178":
        raise ValueError("ordinal-0 semantic error did not propagate exactly")
    if traces or len(verdicts) != 1 or verdicts[0].get("verdict") != "FAIL" or verdicts[0].get("fault") is not True:
        raise ValueError("negative semantic verdict/zero-completion boundary differs")
    if verdicts[0].get("semantic_completes") != 0:
        raise ValueError("faulted semantic command completed unexpectedly")
    if len([event for event in events if event.get("event") == "command_trace"]) != 975:
        raise ValueError("negative proof lost authenticated command-plan tracing")
    failed_report = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-native-v3", "status": "failed",
        "authority": semantic_manifest["authority"], "runtime": {"version": "0.8.12.0", "executable_sha256": semantic.PMDO_SHA256},
        "index_gate": index_gate, "failure": errors[0], "verdict": verdicts[0],
    }
    semantic.dump(evidence / "native_command_semantic_validation_v3.json", failed_report)

    invocation = [
        str(ROOT / ".runtime-cache/test-venv/bin/python"),
        str(ROOT / "tools/certify_pmdred_tiny_woods_command_semantic_v3.py"),
        "--fixture", str(fixture), "--evidence-dir", str(evidence), "--output", str(rejected),
    ]
    proc = subprocess.run(invocation, cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode != 1 or rejected.exists():
        raise ValueError(f"negative evidence was not rejected by certifier: rc={proc.returncode}")
    (evidence / "expected_certifier.stdout.log").write_text(proc.stdout, encoding="utf-8")
    (evidence / "expected_certifier.stderr.log").write_text(proc.stderr, encoding="utf-8")
    report = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-failure-propagation-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(), "status": "passed",
        "fault": semantic_manifest["fault_injection"],
        "native": {
            "attempted_starts": 1, "accepted_starts": 0, "completes": 0,
            "explicit_error": errors[0], "verdict": verdicts[0],
            "termination": {key: termination[key] for key in ("exit_classification", "return_code", "terminal", "graceful", "watchdog", "requested_signal", "sigsegv", "forced_kill", "orphan_process")},
        },
        "certifier": {"expected_return_code": 1, "actual_return_code": proc.returncode, "archive_created": False},
        "assertions": {
            "fault_is_detected_at_ordinal_zero_before_any_completion": True,
            "semantic_FAIL_is_not_rewritten_as_PASS": True,
            "native_process_still_reaches_LoadPhase_Unload_NORMAL_EXIT_rc0": True,
            "certifier_rejects_failed_native_evidence": True,
        },
    }
    semantic.dump(evidence / "failure_propagation_v3.json", report)
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_FAILURE_PROPAGATION_V3_PASS "
        f"attempted_starts=1 accepted_starts=0 completes=0 native_rc=0 certifier_rc=1 evidence={evidence}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
