#!/usr/bin/env python3
"""Verify the MAPCOMPLETE Metano PMDO building pack."""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete"
INVENTORY = BASE / "manifests/MAPCOMPLETE_METANO_BUILDINGS_INVENTORY.json"
ATLAS_MANIFEST = BASE / "manifests/MAPCOMPLETE_METANO_BUILDINGS_PMDO_ATLAS.json"
KINGAMBIT_MANIFEST = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/manifests/metano_kingambit_pmdo_scale_manifest.json"


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
    kingambit = json.loads(KINGAMBIT_MANIFEST.read_text(encoding="utf-8"))

    assert inventory["counts"]["total_assets"] == 4
    assert inventory["counts"]["visible_map_buildings"] == 3
    assert inventory["counts"]["external_requested_buildings"] == 1
    assert inventory["pmdo_scale"]["canonical_map_buildings_integer_scale"] == "2.0x"
    assert inventory["pmdo_scale"]["pmdo_grid_px"] == 24
    assert len(inventory["excluded_visible_non_buildings"]) == 3

    ids = [row["id"] for row in inventory["buildings"]]
    assert ids == [
        "metano_cafe_spinda",
        "metano_fire_home_round",
        "metano_leaf_red_tent",
        "kingambit_hq",
    ]

    hashes = set()
    opaque_sum = 0
    for row in inventory["buildings"]:
        path = ROOT / row["asset_path"]
        assert path.exists(), path
        meta = identify(path)
        opaque, transparent = pixel_counts(path)
        assert meta["format"] == "PNG"
        assert str(meta["channels"]).lower().endswith("a")
        assert meta["opaque"] == "false"
        assert transparent > 0
        assert opaque == row["opaque_pixels"]
        assert transparent == row["transparent_pixels"]
        assert meta["width"] == row["width"]
        assert meta["height"] == row["height"]
        assert sha256(path) == row["sha256"]
        assert row["alpha_isolated"] is True
        assert row["pmdo_scale_verified"] is True
        hashes.add(row["sha256"])
        opaque_sum += opaque

    assert len(hashes) == 4
    assert inventory["duplicate_hash_groups"] == {}

    qg = next(row for row in inventory["buildings"] if row["id"] == "kingambit_hq")
    assert abs(qg["chosen_scale"] - kingambit["method"]["chosen_scale"]) < 1e-12
    assert [qg["width"], qg["height"]] == [kingambit["pmdo"]["width"], kingambit["pmdo"]["height"]]
    assert qg["sha256"] == kingambit["pmdo"]["sha256"]

    atlas_png = ROOT / inventory["deliverables"]["atlas_png"]
    assert atlas_png.exists(), atlas_png
    atlas_meta = identify(atlas_png)
    atlas_opaque, atlas_transparent = pixel_counts(atlas_png)
    assert atlas_meta["format"] == "PNG"
    assert str(atlas_meta["channels"]).lower().endswith("a")
    assert atlas_meta["opaque"] == "false"
    assert atlas_transparent > 0
    assert atlas_manifest["atlas_file"] == inventory["deliverables"]["atlas_png"]
    assert atlas_manifest["canvas"]["width"] == atlas_meta["width"]
    assert atlas_manifest["canvas"]["height"] == atlas_meta["height"]
    assert atlas_manifest["format"] == atlas_meta["format"]
    assert atlas_manifest["channels"] == atlas_meta["channels"]
    assert atlas_manifest["opaque_flag"] == atlas_meta["opaque"]
    assert atlas_manifest["opaque_pixels"] == atlas_opaque
    assert atlas_manifest["transparent_pixels"] == atlas_transparent
    assert atlas_manifest["sha256"] == sha256(atlas_png)
    assert atlas_manifest["expected_opaque_sum_without_overlap"] == opaque_sum
    assert atlas_opaque == opaque_sum
    assert atlas_manifest["pmdo_grid_px"] == 24
    assert len(atlas_manifest["placements"]) == 4

    placement_by_id = {row["id"]: row for row in atlas_manifest["placements"]}
    for building in inventory["buildings"]:
        place = placement_by_id[building["id"]]
        assert place["width"] == building["width"]
        assert place["height"] == building["height"]
        assert place["source_path"] == building["asset_path"]
        assert place["grid_aligned"] is True
        assert place["x"] % 24 == 0
        assert place["y"] % 24 == 0

    for key in ("atlas_png", "atlas_manifest", "contact_sheet", "scale_validation", "map_audit", "report"):
        path = ROOT / inventory["deliverables"][key]
        assert path.exists(), path

    print(
        "MAPCOMPLETE_METANO_BUILDING_PACK_PASS",
        f"assets={inventory['counts']['total_assets']}",
        f"visible_map_buildings={inventory['counts']['visible_map_buildings']}",
        f"external={inventory['counts']['external_requested_buildings']}",
        f"atlas={atlas_meta['width']}x{atlas_meta['height']}",
        "duplicates=0",
    )


if __name__ == "__main__":
    main()
