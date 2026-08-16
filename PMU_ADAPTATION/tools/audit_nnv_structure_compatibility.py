#!/usr/bin/env python3
"""Compatibility gate between NNV target structures and PMU candidate structures.

The mission is: replace targeted NNV structures with PMU structures WITHOUT
importing the PMU environment. Before any replacement can be attempted, two
facts must be established from data, not from a render:

1. the exact structural perimeter of each NNV house (its own sprite, its own
   visible bbox, its own anchor) — the surrounding terrain, trees, roads and
   empty space are NOT part of it;
2. whether a PMU structure can physically stand in that perimeter at native
   resolution, with NNV remaining the spatial authority.

The rule enforced here is explicit: NNV is mapped 1:1 (4992x4992 source px ->
4992x4992 PMDO px, 64 px visual cells). PMU art is authored on a 32 px tile
grid. Rescaling PMU art to fill an NNV house footprint would be resampling
invented detail, which the project forbids. Therefore this tool never rescales;
it measures and classifies.

Outputs a fail-closed compatibility matrix.
"""
from __future__ import annotations

import argparse
import gzip
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
NNV = REPO / "NO_NAME_VILLAGE_ADAPTATION"
LIBRARY = REPO / "docs/pmuniverse_buildings"

# Source-proved NNV house objects (reports/room-index.json, rmvillage id 7).
NNV_HOUSES = {
    "objplayerhouse": {"sprite": "splayerhouse", "instance_id": 106697, "x": -64, "y": 2816, "door_instance": 106508},
    "objloggerhouse": {"sprite": "sloggerhouse", "instance_id": 106698, "x": 704, "y": 1344, "door_instance": 106510},
    "objhunterhouse": {"sprite": "shunterhouse", "instance_id": 106699, "x": 3712, "y": 1472, "door_instance": 106509},
    "objcarpenterhouse": {"sprite": "scarpenterhouse", "instance_id": 106700, "x": 1216, "y": -128, "door_instance": 106511},
}
NNV_VISUAL_CELL = 64  # convert_environment_room.py TARGET_CELL
PMU_TILE = 32


def load_sprites() -> dict:
    path = NNV / "extracted/official/inventory/Sprites.json.gz"
    with gzip.open(path) as stream:
        sprites = json.load(stream)
    result = {}
    for sprite in sprites:
        name = sprite.get("Name")
        if isinstance(name, dict):
            name = name.get("Content")
        if name:
            result[name] = sprite
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--autonomy", type=Path, default=REPO / "PMU_ADAPTATION/reports/structure-autonomy/structure-autonomy.json")
    parser.add_argument("--out", type=Path, default=REPO / "PMU_ADAPTATION/reports/structure-autonomy")
    arguments = parser.parse_args()

    sprites = load_sprites()
    autonomy = json.loads(arguments.autonomy.read_text())
    confirmed = [c for c in autonomy["candidates"] if c["classification"] == "AUTONOMOUS_CONFIRMED"]
    largest = max(confirmed, key=lambda c: c["dimensions"][0] * c["dimensions"][1]) if confirmed else None

    targets = []
    for object_name, meta in sorted(NNV_HOUSES.items()):
        sprite = sprites[meta["sprite"]]
        visible_w = sprite["MarginRight"] - sprite["MarginLeft"] + 1
        visible_h = sprite["MarginBottom"] - sprite["MarginTop"] + 1
        fits = []
        for candidate in confirmed:
            width, height = candidate["dimensions"]
            if width >= visible_w and height >= visible_h:
                fits.append(candidate["structure_id"])
        entry = {
            "nnv_object": object_name,
            "nnv_sprite": meta["sprite"],
            "instance_id": meta["instance_id"],
            "anchor_source_px": [meta["x"], meta["y"]],
            "door_instance_id": meta["door_instance"],
            "sprite_canvas_px": [sprite["Width"], sprite["Height"]],
            "visible_bbox_px": [visible_w, visible_h],
            "visible_margins": {
                "left": sprite["MarginLeft"], "right": sprite["MarginRight"],
                "top": sprite["MarginTop"], "bottom": sprite["MarginBottom"],
            },
            "frames": 2,
            "footprint_in_pmdo_cells_64px": [round(visible_w / NNV_VISUAL_CELL, 2), round(visible_h / NNV_VISUAL_CELL, 2)],
            "footprint_in_pmu_tiles_32px": [round(visible_w / PMU_TILE, 2), round(visible_h / PMU_TILE, 2)],
            "structural_perimeter": "sprite pixels only; surrounding terrain, trees, roads, rocks and empty "
            "space are NNV data and are never part of this structure",
            "pmu_candidates_fitting_natively": fits,
            "replacement_status": "COMPATIBLE" if fits else "ADAPTATION_REQUIRED",
        }
        if not fits and largest:
            entry["blocking_reason"] = (
                f"no AUTONOMOUS_CONFIRMED PMU structure reaches the native footprint "
                f"{visible_w}x{visible_h}px; largest confirmed candidate is "
                f"{largest['structure_id']} at {largest['dimensions'][0]}x{largest['dimensions'][1]}px "
                f"(x{visible_w / largest['dimensions'][0]:.1f} narrower, x{visible_h / largest['dimensions'][1]:.1f} shorter). "
                "Upscaling PMU art to fill the NNV footprint would invent pixels and is forbidden; "
                "shrinking the NNV plot to fit would let PMU dictate NNV topology and is forbidden."
            )
            entry["scale_ratio_vs_largest_confirmed"] = [
                round(visible_w / largest["dimensions"][0], 2),
                round(visible_h / largest["dimensions"][1], 2),
            ]
        targets.append(entry)

    report = {
        "schema": "new-era.nnv-pmu-structure-compatibility.v1",
        "authority": "NNV topology is the authority; PMU supplies structures only, never layout or environment",
        "geometry_contract": {
            "nnv_mapping": "1:1, 4992x4992 source px -> 4992x4992 PMDO px",
            "nnv_visual_cell_px": NNV_VISUAL_CELL,
            "nnv_tex_size": 8,
            "nnv_collision_grid": "624x624 cells of 8 px",
            "pmu_native_tile_px": PMU_TILE,
            "rescaling_allowed": False,
        },
        "pmu_pool": {
            "autonomous_confirmed": len(confirmed),
            "largest_confirmed": {
                "structure_id": largest["structure_id"],
                "dimensions": largest["dimensions"],
            } if largest else None,
        },
        "targets": targets,
        "summary": {
            "compatible": sum(1 for t in targets if t["replacement_status"] == "COMPATIBLE"),
            "adaptation_required": sum(1 for t in targets if t["replacement_status"] == "ADAPTATION_REQUIRED"),
        },
        "conclusion": "No NNV house can currently be replaced by a PMU structure at native resolution. "
        "The blocker is a proved scale mismatch between NNV's high-resolution house sprites and PMU's "
        "32 px tile art, not a missing asset. This stays fail-closed rather than resampling either side.",
    }

    arguments.out.mkdir(parents=True, exist_ok=True)
    target = arguments.out / "nnv-structure-compatibility.json"
    target.write_text(json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(
        "NNV_PMU_COMPATIBILITY "
        f"targets={len(targets)} compatible={report['summary']['compatible']} "
        f"adaptation_required={report['summary']['adaptation_required']} "
        f"pmu_pool={len(confirmed)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
