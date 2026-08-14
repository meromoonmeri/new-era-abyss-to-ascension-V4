#!/usr/bin/env python3
"""Create an isolated Tiny Woods fixture for Caterpie's EU efob108 attachment.

This builder deliberately starts from the direct Tiny Woods route fixture.  It
never invokes the palette overlay builder, and therefore has no dependency on
that builder's scene-music cache.  Every destination is create-only.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import shutil
from pathlib import Path
from types import ModuleType
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PARTICLE_NAME = "PMDRed_Efob108.dir"
PARTICLE_SHA256 = "18d392d82c2c8b6aa101aa0a49bab0af58aae16aa6e5aebba92a7bf288f46def"
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
SOURCE_PARTICLE = ROOT / "Content/Particle" / PARTICLE_NAME
SOURCE_MODULE = ROOT / "tools/pmdred_efob108_attachment_fixture.lua"
SOURCE_VALIDATOR = ROOT / "tools/pmdred_efob108_attachment_validator.lua"
SOURCE_EFFECT_MANIFEST = ROOT / "docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json"


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


def file_record(path: Path) -> dict[str, Any]:
    return {"bytes": path.stat().st_size, "sha256": sha256(path)}


def private_particle_tree(fixture: Path) -> Path:
    destination = fixture / "quest/Content/Particle"
    if not destination.is_symlink():
        raise ValueError("direct route fixture Particle parent is not the expected symlink")
    if destination.resolve() != (ROOT / "Content/Particle").resolve():
        raise ValueError("direct route fixture Particle source differs")
    destination.unlink()
    destination.mkdir()
    for source in sorted((ROOT / "Content/Particle").iterdir(), key=lambda item: item.name):
        target = destination / source.name
        if source.name == PARTICLE_NAME:
            continue
        target.symlink_to(source, target_is_directory=source.is_dir())
    shutil.copyfile(SOURCE_PARTICLE, destination / PARTICLE_NAME)
    return destination / PARTICLE_NAME


def build(output: Path) -> dict[str, Any]:
    output = output.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite attachment fixture: {output}")
    required = (SOURCE_PARTICLE, SOURCE_MODULE, SOURCE_VALIDATOR, SOURCE_EFFECT_MANIFEST)
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        raise FileNotFoundError("missing attachment fixture inputs: " + ", ".join(missing))
    if sha256(SOURCE_PARTICLE) != PARTICLE_SHA256:
        raise ValueError("efob108 particle source identity differs")

    route_builder = load_tool("build_pmdred_tiny_woods_route_fixture")
    route_builder.build(output)

    particle = private_particle_tree(output)
    module = output / "quest/Data/Script/halcyon/pmdred_efob108_attachment_fixture.lua"
    shutil.copyfile(SOURCE_MODULE, module)
    validator = output / "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua"
    if validator.is_symlink():
        raise ValueError("route fixture validator unexpectedly aliases repository state")
    shutil.copyfile(SOURCE_VALIDATOR, validator)

    manifest_path = output / "fixture_manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    relative_files = {
        "quest/Content/Particle/PMDRed_Efob108.dir": particle,
        "quest/Data/Script/halcyon/pmdred_efob108_attachment_fixture.lua": module,
        "quest/Data/Script/halcyon/services/ground_gameplay_validator/init.lua": validator,
    }
    manifest["efob108_attachment"] = {
        "schema": "pmdred-eu-efob108-attachment-fixture-v1",
        "authority": {
            "region": "EU",
            "rom_sha256": ROM_SHA256,
            "effect_manifest": str(SOURCE_EFFECT_MANIFEST.relative_to(ROOT)),
            "effect_manifest_sha256": sha256(SOURCE_EFFECT_MANIFEST),
            "effect_sha256": PARTICLE_SHA256,
            "source_owner": "s_gs179_g1_s0_lives2_dlg0",
            "source_command_address": "0x084D5578",
            "source_opcode": "0x56",
            "source_arguments": [62, 0],
            "completion_command_address": "0x084D55A8",
            "completion_opcode": "0xDE",
        },
        "validator": {
            "opt_in": "PMDO_GROUND_VALIDATOR=pmdred_efob108_attachment_fixture",
            "events": "/tmp/pmdred_efob108_attachment.jsonl",
            "source_sha256": sha256(SOURCE_VALIDATOR),
            "fixture_sha256": sha256(validator),
        },
        "coordinate_candidates": {
            "eu_center_literal": [180, 148],
            "pmdo_top_left_normalized": [172, 140],
            "expected_literal_terminal_head": [187, 161],
            "expected_normalized_terminal_head": [179, 153],
            "authenticated_ax_attachment": [179, 149],
        },
        "native_effect": {
            "anim_index": "PMDRed_Efob108",
            "frame_time": 2,
            "strip_frames": 13,
            "cycles": 1,
            "duration_frames": 26,
            "loc_height": 4,
            "draw_size": [128, 128],
            "expected_frame_indices": [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12],
        },
        "fixture_isolation": {
            "built_directly_from_route_fixture": True,
            "palette_overlay_invoked": False,
            "particle_parent_private": True,
            "particle_parent_is_symlink": False,
            "effect_file_private": True,
            "effect_file_is_symlink": False,
        },
        "files": {name: file_record(path) for name, path in sorted(relative_files.items())},
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    manifest = build(args.output)
    section = manifest["efob108_attachment"]
    print(
        "PMDRED_EFOB108_ATTACHMENT_FIXTURE_CREATED "
        f"output={args.output.resolve()} effect={section['authority']['effect_sha256']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
