#!/usr/bin/env python3
"""Build an isolated exact-PMDO fixture for native Tiny Woods generation.

The Ground launcher is sourced from the already authenticated 219-Ground
conversion campaign.  The tracked Tiny Woods ZoneData and an opt-in validator
are copied only into a new ignored overlay; canonical quest and reserve files
are never modified.  PMDO indexing and runtime execution are deliberately left
to ``run_pmdred_tiny_woods_native.py``.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import shutil
from pathlib import Path
from types import ModuleType

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUTPUT = ROOT / ".runtime-cache/tiny-woods-native-fixture-v2"
DEFAULT_CANDIDATES = ROOT / ".runtime-cache/pmdred-eu-remaining-regenerated-v201"
DEFAULT_PLAN = ROOT / ".runtime-cache/pmdred-eu-reference-plan-v2.json"
ZONE = ROOT / "Data/Zone/tiny_woods.json"
VALIDATOR = ROOT / "tools/pmdred_tiny_woods_native_validator.lua"
EXPECTED_ZONE_SHA256 = "e4f3edaf4af60bc625ce8e5c3b9d1d36372c2a1b009b4b1d21d13774e7eb92f7"
EXPECTED_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def load_base_builder() -> ModuleType:
    path = ROOT / "tools/build_pmdred_eu_runtime_fixture.py"
    spec = importlib.util.spec_from_file_location("build_pmdred_eu_runtime_fixture", path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rooted(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


def build(output: Path, candidate_root: Path, plan: Path) -> Path:
    output = output.resolve()
    candidate_root = candidate_root.resolve()
    plan = plan.resolve()
    if output.exists():
        raise FileExistsError(
            f"refusing to overwrite existing evidence fixture: {output}; choose a new --output"
        )
    if sha256(ZONE) != EXPECTED_ZONE_SHA256:
        raise ValueError("tracked Tiny Woods ZoneData differs from the authenticated milestone")

    base = load_base_builder()
    quest = base.build(
        ROOT,
        output,
        conversion_set="remaining",
        candidate_root=candidate_root,
        plan_path=plan,
        ids=["d01p01"],
        pilot_ticks=[0],
    )

    fixture_manifest_path = output / "fixture_manifest.json"
    fixture_manifest = json.loads(fixture_manifest_path.read_text(encoding="utf-8"))
    launcher = fixture_manifest["entries"]
    if len(launcher) != 1 or launcher[0]["id"] != "d01p01":
        raise ValueError("base fixture did not select the authenticated d01p01 launcher")
    ground_index = launcher[0]["zone_index"]

    destination_zone = quest / "Data/Zone/tiny_woods.json"
    shutil.copyfile(ZONE, destination_zone)
    validator_text = VALIDATOR.read_text(encoding="utf-8")
    token = "@@LAUNCHER_GROUND_INDEX@@"
    if validator_text.count(token) != 1:
        raise ValueError("Tiny Woods validator must contain one launcher-index token")
    validator_text = validator_text.replace(token, str(ground_index))
    destination_validator = (
        quest / "Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    )
    destination_validator.write_text(validator_text, encoding="utf-8")

    fixture_manifest["tiny_woods_native"] = {
        "schema": "pmdred-eu-tiny-woods-native-fixture-v1",
        "authority": {
            "region": "EU",
            "rom_sha256": EXPECTED_ROM_SHA256,
            "zone_source": str(ZONE.relative_to(ROOT)),
            "zone_sha256": sha256(ZONE),
        },
        "launcher": {
            "ground": "d01p01",
            "master_zone_index": ground_index,
            "silent_restrictions": True,
        },
        "validator": {
            "source": str(VALIDATOR.relative_to(ROOT)),
            "source_sha256": sha256(VALIDATOR),
            "fixture_sha256": sha256(destination_validator),
            "opt_in": "PMDO_GROUND_VALIDATOR=tiny_woods_native_fixture",
        },
        "pending_operation": "exact PMDO 0.8.12 zone indexing before native execution",
    }
    fixture_manifest_path.write_text(
        json.dumps(fixture_manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return quest


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    result.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    result.add_argument("--candidate-root", type=Path, default=DEFAULT_CANDIDATES)
    result.add_argument("--plan", type=Path, default=DEFAULT_PLAN)
    return result


def main() -> int:
    args = parser().parse_args()
    quest = build(rooted(args.output), rooted(args.candidate_root), rooted(args.plan))
    print(quest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
