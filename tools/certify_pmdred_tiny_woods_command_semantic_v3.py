#!/usr/bin/env python3
"""Create a durable create-only archive for Tiny Woods semantic native evidence v3."""
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
TOOLS = (
    "tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py",
    "tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py",
    "tools/build_pmdred_tiny_woods_command_semantic_overlay_v3.py",
    "tools/pmdred_tiny_woods_command_semantic_validator_v3.lua",
    "tools/run_pmdred_tiny_woods_command_semantic_v3.py",
    "tools/run_pmdred_tiny_woods_command_semantic_negative_v3.py",
    "tools/certify_pmdred_tiny_woods_command_semantic_v3.py",
    "tools/certify_pmdred_tiny_woods_command_semantic_metadata_correction_v3.py",
    "tools/test_pmdred_tiny_woods_command_semantic_v3.py",
)


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


def copy_file(source: Path, destination: Path) -> dict[str, Any]:
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, destination)
    return {"path": str(destination), "bytes": destination.stat().st_size, "sha256": sha256(destination)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--evidence-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    fixture = args.fixture.resolve()
    evidence = args.evidence_dir.resolve()
    output = args.output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite semantic archive: {output}")

    run = load_tool("run_pmdred_tiny_woods_command_semantic_v3")
    old = load_tool("run_pmdred_tiny_woods_command_complete")
    validate = load_tool("validate_pmdred_tiny_woods_command_semantic_supplement_v3")
    manifest, semantic_manifest = run.authenticate(fixture)
    plan = json.loads(PLAN.read_text(encoding="utf-8"))
    supplement = json.loads(SUPPLEMENT.read_text(encoding="utf-8"))
    report_path = evidence / "native_command_semantic_validation_v3.json"
    report = json.loads(report_path.read_text(encoding="utf-8"))
    if report.get("status") != "passed" or report.get("schema") != "pmdred-eu-tiny-woods-command-semantic-native-v3":
        raise ValueError("native semantic report is not passed v3 evidence")
    if report.get("authority") != semantic_manifest["authority"]:
        raise ValueError("native semantic report authority differs")
    if report.get("runtime", {}).get("executable_sha256") != run.PMDO_SHA256:
        raise ValueError("native semantic runtime identity differs")

    verified = []
    for mode in run.MODES:
        mode_dir = evidence / mode
        events = run.read_events(mode_dir / "events.jsonl")
        summary = run.validate_mode(mode, events, plan, supplement)
        termination = old.strict_termination(mode_dir / "termination.json")
        verified.append({
            **summary,
            "events_sha256": sha256(mode_dir / "events.jsonl"),
            "runtime_log_sha256": sha256(mode_dir / "runtime.log"),
            "termination_sha256": sha256(mode_dir / "termination.json"),
            "exit_classification": termination["exit_classification"],
        })
    if [row.get("mode") for row in report.get("runs", [])] != list(run.MODES):
        raise ValueError("native semantic report modes differ")

    output.mkdir(parents=True)
    copied = []
    for name in ("fixture_manifest.json", "command_plan.json", "command_semantic_supplement_v3.json", "index.log", "index_validation.json", "native_command_semantic_validation_v3.json"):
        copied.append(copy_file(evidence / name, output / name))
    for mode in run.MODES:
        for name in ("events.jsonl", "runtime.log", "termination.json"):
            copied.append(copy_file(evidence / mode / name, output / mode / name))
    commands = output / "commands.sh"
    commands.write_text(
        "#!/usr/bin/env bash\nset -euo pipefail\ncd \"$(git rev-parse --show-toplevel)\"\n"
        "supplement=.runtime-cache/pmdred-tiny-woods-command-semantic-supplement-repro-v3.json\n"
        "fixture=.runtime-cache/pmdred-tiny-woods-command-semantic-fixture-repro-v19\n"
        "evidence=.runtime-cache/pmdred-tiny-woods-command-semantic-evidence-repro-v19\n"
        "archive=.runtime-cache/pmdred-tiny-woods-command-semantic-archive-repro-v19\n"
        "for destination in \"$supplement\" \"$fixture\" \"$evidence\" \"$archive\"; do test ! -e \"$destination\" || { echo \"create-only destination exists: $destination\" >&2; exit 1; }; done\n"
        "python3 tools/build_pmdred_tiny_woods_command_semantic_supplement_v3.py --output \"$supplement\"\n"
        "cmp \"$supplement\" docs/pmdred_eu/playable/tiny_woods/command_semantic_supplement_v3.json\n"
        "python3 tools/validate_pmdred_tiny_woods_command_semantic_supplement_v3.py --supplement \"$supplement\"\n"
        "python3 tools/build_pmdred_tiny_woods_command_semantic_overlay_v3.py --output \"$fixture\" --music-source .runtime-cache/pmdred-tiny-woods-scene-music-v13 --fanfare-source .runtime-cache/pmdred-tiny-woods-fanfares-v13\n"
        "python3 tools/run_pmdred_tiny_woods_command_semantic_v3.py --fixture \"$fixture\" --evidence-dir \"$evidence\" --timeout-seconds 240\n"
        "python3 tools/certify_pmdred_tiny_woods_command_semantic_v3.py --fixture \"$fixture\" --evidence-dir \"$evidence\" --output \"$archive\"\n",
        encoding="utf-8",
    )
    commands.chmod(0o755)
    copied.append({"path": str(commands), "bytes": commands.stat().st_size, "sha256": sha256(commands)})
    certificate = {
        "schema": "pmdred-eu-tiny-woods-command-semantic-certificate-v3",
        "date": datetime.now(ZoneInfo("Europe/Paris")).date().isoformat(),
        "status": "passed",
        "authority": semantic_manifest["authority"],
        "runtime": report["runtime"],
        "verified_runs": verified,
        "combined": report["combined"],
        "source_tools": {name: sha256(ROOT / name) for name in TOOLS},
        "archived_files": copied,
        "assertions": report["assertions"],
        "scope": [
            "This certificate does not mutate command_plan.json and does not reclassify its 15 palette rows.",
            "The 304-row supplement is complete for the 16 portrait/actor/camera/wait opcodes and disjoint from actor.control_unknown.",
            "Non-wait rows certify source-address metadata and PMDO adaptation contracts; production actor binding remains a later serialized route-integration gate.",
        ],
    }
    dump(output / "certificate.json", certificate)
    hashes = []
    for path in sorted(item for item in output.rglob("*") if item.is_file() and item.name != "evidence_hashes.sha256"):
        hashes.append(f"{sha256(path)}  {path.relative_to(output)}")
    (output / "evidence_hashes.sha256").write_text("\n".join(hashes) + "\n", encoding="utf-8")
    print(
        "TINY_WOODS_COMMAND_SEMANTIC_CERTIFICATE_V3_PASS "
        f"commands=304 modes=2 waits=3001 output={output}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
