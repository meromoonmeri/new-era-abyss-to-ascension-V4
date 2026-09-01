#!/usr/bin/env python3
"""Verify the uploaded-map PMDO building atlas."""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset"
INVENTORY = BASE / "manifests/MAP_TO_SCALE_PMDO_BUILDINGS_INVENTORY.json"
ATLAS_MANIFEST = BASE / "manifests/MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.json"


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def identify(path: Path) -> dict:
    text = run("identify", "-format", "width=%w\nheight=%h\nchannels=%[channels]\nopaque=%[opaque]\nformat=%m\n", str(path))
    data: dict[str, str | int] = {}
    for line in text.strip().splitlines():
        key, value = line.split("=", 1)
        data[key] = value
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
    inventory = json.loads(INVENTORY.read_text(encoding="utf-8"))
    atlas_manifest = json.loads(ATLAS_MANIFEST.read_text(encoding="utf-8"))

    assert inventory["counts"]["exported_buildings"] == 3
    assert inventory["counts"]["unresolved_or_excluded_visible_structures"] == 3
    assert inventory["pmdo_scale"]["presentation_to_pmdo_reference"] == "2.0x integer nearest-neighbor"
    assert inventory["pmdo_scale"]["pmdo_grid_px"] == 24
    assert inventory["duplicate_hash_groups"] == {}

    ids = [row["id"] for row in inventory["buildings"]]
    assert ids == ["metano_cafe_spinda", "metano_fire_home_round", "metano_expedition_tent"]

    opaque_sum = 0
    for row in inventory["buildings"]:
        path = ROOT / row["asset_path"]
        assert path.exists(), path
        meta = identify(path)
        opaque, transparent = pixel_counts(path)
        assert meta["format"] == "PNG"
        assert str(meta["channels"]).lower().endswith("a")
        assert meta["opaque"] == "false"
        assert row["alpha_isolated"] is True
        assert row["pmdo_scale_verified"] is True
        assert meta["width"] == row["width"]
        assert meta["height"] == row["height"]
        assert opaque == row["opaque_pixels"]
        assert transparent == row["transparent_pixels"]
        assert sha256(path) == row["sha256"]
        opaque_sum += opaque

    atlas_png = ROOT / inventory["deliverables"]["atlas_png"]
    assert atlas_png.exists(), atlas_png
    atlas_meta = identify(atlas_png)
    atlas_opaque, atlas_transparent = pixel_counts(atlas_png)
    assert atlas_meta["format"] == "PNG"
    assert str(atlas_meta["channels"]).lower().endswith("a")
    assert atlas_meta["opaque"] == "false"
    assert atlas_transparent > 0
    assert atlas_manifest["format"] == atlas_meta["format"]
    assert atlas_manifest["channels"] == atlas_meta["channels"]
    assert atlas_manifest["opaque_flag"] == atlas_meta["opaque"]
    assert atlas_manifest["opaque_pixels"] == atlas_opaque
    assert atlas_manifest["transparent_pixels"] == atlas_transparent
    assert atlas_manifest["sha256"] == sha256(atlas_png)
    assert atlas_manifest["expected_opaque_sum_without_overlap"] == opaque_sum
    assert atlas_opaque == opaque_sum
    assert atlas_manifest["pmdo_grid_px"] == 24
    assert len(atlas_manifest["placements"]) == 3

    placement_by_id = {row["id"]: row for row in atlas_manifest["placements"]}
    for row in inventory["buildings"]:
        place = placement_by_id[row["id"]]
        assert place["grid_aligned"] is True
        assert place["x"] % 24 == 0
        assert place["y"] % 24 == 0
        assert place["width"] == row["width"]
        assert place["height"] == row["height"]
        assert place["source_path"] == row["asset_path"]

    unresolved = {row["id"]: row["status"] for row in inventory["unresolved_visible_structures"]}
    assert unresolved["bear_head_cave_home_unique"] == "UNRESOLVED_FLATMAP_ONLY"
    assert unresolved["blue_emblem_plaza_podium"] == "EXCLUDED_NON_BUILDING"
    assert unresolved["pokemon_statue_podiums"] == "EXCLUDED_NON_BUILDING"

    for key in ("atlas_png", "atlas_manifest", "contact_sheet", "audit", "scale_validation", "report"):
        path = ROOT / inventory["deliverables"][key]
        assert path.exists(), path

    print(
        "MAP_TO_SCALE_PMDO_BUILDING_PACK_PASS",
        f"exported={inventory['counts']['exported_buildings']}",
        f"unresolved={inventory['counts']['unresolved_or_excluded_visible_structures']}",
        f"atlas={atlas_meta['width']}x{atlas_meta['height']}",
        "duplicates=0",
    )


if __name__ == "__main__":
    main()
