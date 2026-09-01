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
KINGAMBIT_MANIFEST = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/manifests/metano_kingambit_pmdo_scale_manifest.json"


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def identify(path: Path) -> dict:
    text = run("identify", "-format", "width=%w\nheight=%h\nchannels=%[channels]\nopaque=%[opaque]\nformat=%m\n", str(path))
    data = {}
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
    kingambit = json.loads(KINGAMBIT_MANIFEST.read_text(encoding="utf-8"))

    assert inventory["counts"]["total_assets"] == 4
    assert inventory["counts"]["visible_map_buildings"] == 3
    assert inventory["counts"]["external_requested_buildings"] == 1
    assert inventory["pmdo_scale"]["canonical_map_buildings_integer_scale"] == "2.0x"
    assert len(inventory["excluded_visible_non_buildings"]) == 3

    ids = {row["id"] for row in inventory["buildings"]}
    assert ids == {
        "metano_cafe_spinda",
        "metano_fire_home_round",
        "metano_leaf_red_tent",
        "kingambit_hq",
    }

    hashes = set()
    for row in inventory["buildings"]:
        path = ROOT / row["asset_path"]
        assert path.exists(), path
        meta = identify(path)
        opaque, transparent = pixel_counts(path)
        assert meta["format"] == "PNG"
        assert meta["channels"].lower().endswith("a")
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

    assert len(hashes) == 4
    assert inventory["duplicate_hash_groups"] == {}

    qg = next(row for row in inventory["buildings"] if row["id"] == "kingambit_hq")
    assert abs(qg["chosen_scale"] - kingambit["method"]["chosen_scale"]) < 1e-12
    assert [qg["width"], qg["height"]] == [kingambit["pmdo"]["width"], kingambit["pmdo"]["height"]]
    assert qg["sha256"] == kingambit["pmdo"]["sha256"]

    for key in ("contact_sheet", "scale_validation", "map_audit", "report"):
        path = ROOT / inventory["deliverables"][key]
        assert path.exists(), path

    print(
        "MAPCOMPLETE_METANO_BUILDING_PACK_PASS",
        f"assets={inventory['counts']['total_assets']}",
        f"visible_map_buildings={inventory['counts']['visible_map_buildings']}",
        f"external={inventory['counts']['external_requested_buildings']}",
        "duplicates=0",
    )


if __name__ == "__main__":
    main()
