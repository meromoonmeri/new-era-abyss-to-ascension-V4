#!/usr/bin/env python3
"""Verify the single-building Kingambit PMDO scaling deliverable."""
from __future__ import annotations

import hashlib
import json
import math
import re
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit"
MANIFEST = BASE / "manifests/metano_kingambit_pmdo_scale_manifest.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)


def identify(path: Path) -> dict:
    text = run("identify", "-format", "width=%w\nheight=%h\nchannels=%[channels]\nopaque=%[opaque]\nformat=%m\n", str(path))
    data = {}
    for line in text.strip().splitlines():
        k, v = line.split("=", 1)
        data[k] = v
    data["width"] = int(data["width"])
    data["height"] = int(data["height"])
    return data


def pixel_counts(path: Path) -> tuple[int, int]:
    text = run("convert", str(path), "txt:-")
    opaque = 0
    transparent = 0
    rgba = re.compile(r"(\d+),(\d+): \((\d+),(\d+),(\d+),(\d+)\)")
    rgb = re.compile(r"(\d+),(\d+): \((\d+),(\d+),(\d+)\)")
    for line in text.splitlines()[1:]:
        match = rgba.match(line)
        if match:
            a = int(match.group(6))
        else:
            match = rgb.match(line)
            if not match:
                continue
            a = 255
        if a == 0:
            transparent += 1
        else:
            opaque += 1
    return opaque, transparent


def main() -> None:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))

    master = ROOT / manifest["files"]["master"]
    pmdo = ROOT / manifest["files"]["pmdo"]
    cafe = ROOT / manifest["source_authority"]["metano_cafe_pmdo_reference"]
    contact = ROOT / manifest["files"]["contact_sheet"]
    validation = ROOT / manifest["files"]["validation_sheet"]
    report = ROOT / manifest["files"]["report"]

    for path in (master, pmdo, cafe, contact, validation, report):
        assert path.exists(), f"missing file: {path}"

    master_meta = identify(master)
    pmdo_meta = identify(pmdo)
    assert master_meta["format"] == "PNG"
    assert pmdo_meta["format"] == "PNG"
    assert master_meta["channels"].lower().endswith("a")
    assert pmdo_meta["channels"].lower().endswith("a")
    assert pmdo_meta["opaque"] == "false"

    master_opaque, master_transparent = pixel_counts(master)
    cafe_opaque, _cafe_transparent = pixel_counts(cafe)
    pmdo_opaque, pmdo_transparent = pixel_counts(pmdo)

    assert master_opaque == manifest["master"]["opaque_pixels"]
    assert pmdo_opaque == manifest["pmdo"]["opaque_pixels"]
    assert pmdo_transparent > 0
    assert manifest["master"]["opaque_bbox"] == [0, 0, master_meta["width"] - 1, master_meta["height"] - 1], (
        "trimmed master should have no fully transparent outer border"
    )

    expected_target = math.sqrt(cafe_opaque / master_opaque)
    assert abs(expected_target - manifest["method"]["cafe_derived_target_scale"]) < 1e-12
    assert abs(manifest["method"]["chosen_scale"] - 0.4) < 1e-12

    assert sha256(master) == manifest["master"]["sha256"]
    assert sha256(pmdo) == manifest["pmdo"]["sha256"]

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp = Path(tmpdir) / "rebuild.png"
        subprocess.check_call([
            "convert",
            str(master),
            "-filter",
            "point",
            "-resize",
            "40%",
            str(tmp),
        ])
        proc = subprocess.run(
            ["compare", "-metric", "AE", str(tmp), str(pmdo), "null:"],
            text=True,
            capture_output=True,
            check=False,
        )
        delta = (proc.stderr or proc.stdout).strip()
        assert delta == "0", "scaled output pixels are not reproducible from the declared nearest-neighbor recipe"

    print(
        "METANO_KINGAMBIT_PMDO_SCALE_PASS",
        f"master={master_meta['width']}x{master_meta['height']}",
        f"pmdo={pmdo_meta['width']}x{pmdo_meta['height']}",
        f"target={expected_target:.9f}",
        f"opaque={pmdo_opaque}",
        f"transparent={pmdo_transparent}",
    )


if __name__ == "__main__":
    main()
