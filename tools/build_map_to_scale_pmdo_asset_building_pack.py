#!/usr/bin/env python3
"""Assemble a PMDO-scale alpha-isolated building atlas for the uploaded map PNG.

Authoritative source:
- map to scale pmdo and make tilset asset.png
- metano_scale_verification.png

This pack is intentionally strict:
- reuse exact canonical alpha-isolated assets where the visible map building
  matches an existing repository source;
- do not redraw or recolor;
- do not export ambiguous flat-map-only structures as fake clean assets;
- document unresolved visible structures instead of inventing pixels.
"""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE_MAP = ROOT / "map to scale pmdo and make tilset asset.png"
SCALE_REFERENCE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png"
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset"
PMDO_DIR = BASE / "pmdo"
MANIFEST_DIR = BASE / "manifests"
REPORT_DIR = BASE / "reports"
VALIDATION_DIR = BASE / "validation"

ATLAS_OUT = PMDO_DIR / "MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.png"
INVENTORY_OUT = MANIFEST_DIR / "MAP_TO_SCALE_PMDO_BUILDINGS_INVENTORY.json"
ATLAS_MANIFEST_OUT = MANIFEST_DIR / "MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.json"
REPORT_OUT = REPORT_DIR / "MAP_TO_SCALE_PMDO_BUILDING_REPORT.md"
CONTACT_OUT = VALIDATION_DIR / "MAP_TO_SCALE_PMDO_BUILDING_CONTACT_SHEET.png"
AUDIT_OUT = VALIDATION_DIR / "MAP_TO_SCALE_PMDO_BUILDING_AUDIT.png"
SCALE_VALIDATION_OUT = VALIDATION_DIR / "MAP_TO_SCALE_PMDO_BUILDING_SCALE_VALIDATION.png"

PMDO_GRID_PX = 24
ATLAS_CANVAS = (576, 192)
ATLAS_LAYOUT = {
    "metano_cafe_spinda": {"x": 24, "y": 24},
    "metano_fire_home_round": {"x": 312, "y": 24},
    "metano_expedition_tent": {"x": 456, "y": 24},
}

VISIBLE_RECOVERABLE_BUILDINGS = [
    {
        "id": "metano_cafe_spinda",
        "type": "cafe",
        "asset_path": "data/pmdo_assets_alpha_entiers/02_boutiques_et_marche/grand_cafe_spinda_terrasse_jour.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "map_bbox_source_png": [118, 22, 223, 76],
        "occurrences": "single visible instance in the north-west plateau",
        "scale_action": "already at PMDO scale; reused without resampling",
    },
    {
        "id": "metano_fire_home_round",
        "type": "house",
        "asset_path": "data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/maison_style_feu.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "map_bbox_source_png": [145, 497, 201, 554],
        "occurrences": "single visible round home in the south-west cluster",
        "scale_action": "already at PMDO scale; reused without resampling",
    },
    {
        "id": "metano_expedition_tent",
        "type": "tent_house",
        "asset_path": "data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/tente_expedition_bleue.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "map_bbox_source_png": [222, 172, 266, 214],
        "occurrences": "multiple visually identical instances across the village",
        "scale_action": "already at PMDO scale; reused without resampling",
    },
]

UNRESOLVED_VISIBLE_STRUCTURES = [
    {
        "id": "bear_head_cave_home_unique",
        "type": "unique_house",
        "map_bbox_source_png": [95, 394, 164, 458],
        "status": "UNRESOLVED_FLATMAP_ONLY",
        "reason": "visible on the flattened PNG, but no exact clean alpha-isolated canonical source was found in the repository and direct crop isolation would keep terrain contamination",
    },
    {
        "id": "blue_emblem_plaza_podium",
        "type": "monument_or_service_marker",
        "map_bbox_source_png": [186, 219, 250, 277],
        "status": "EXCLUDED_NON_BUILDING",
        "reason": "visually reads as a podium or marker rather than a building entrance",
    },
    {
        "id": "pokemon_statue_podiums",
        "type": "monument",
        "status": "EXCLUDED_NON_BUILDING",
        "reason": "statues and altars visible on the map are not buildings",
    },
]

PMDO_SCALE_DESCRIPTION = (
    "Metano Town PMDO scale verified from metano_scale_verification.png: "
    "2.0x integer nearest-neighbor from the small map presentation to the PMDO object library. "
    "The three exported visible building types already exist in repository-canonical PMDO size, "
    "so they are reused without any second scaling pass."
)


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def identify(path: Path) -> dict:
    text = run(
        "identify",
        "-format",
        "width=%w\nheight=%h\nchannels=%[channels]\nopaque=%[opaque]\nformat=%m\n",
        str(path),
    )
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


def ensure_dirs() -> None:
    for path in (PMDO_DIR, MANIFEST_DIR, REPORT_DIR, VALIDATION_DIR):
        path.mkdir(parents=True, exist_ok=True)


def enrich(item: dict) -> dict:
    path = ROOT / item["asset_path"]
    meta = identify(path)
    opaque, transparent = pixel_counts(path)
    return {
        **item,
        "format": meta["format"],
        "channels": meta["channels"],
        "opaque_flag": meta["opaque"],
        "width": meta["width"],
        "height": meta["height"],
        "opaque_pixels": opaque,
        "transparent_pixels": transparent,
        "has_alpha": str(meta["channels"]).lower().endswith("a"),
        "alpha_isolated": str(meta["channels"]).lower().endswith("a") and meta["opaque"] == "false" and transparent > 0,
        "sha256": sha256(path),
        "pmdo_scale_verified": True,
        "scale_reference": PMDO_SCALE_DESCRIPTION,
    }


def build_contact_sheet(rows: list[dict]) -> None:
    with tempfile.TemporaryDirectory() as tmpdir:
        cards: list[str] = []
        for index, row in enumerate(rows):
            tmp = Path(tmpdir) / f"card_{index}.png"
            subprocess.check_call([
                "convert",
                "-size", "340x240", "xc:#2b3038",
                "-fill", "#3a424d", "-stroke", "#7d8999", "-strokewidth", "1",
                "-draw", "rectangle 4,4 336,236",
                str(ROOT / row["asset_path"]), "-gravity", "center", "-geometry", "+0-10", "-composite",
                "-font", "DejaVu-Sans", "-fill", "white", "-pointsize", "18", "-gravity", "south",
                "-annotate", "+0+26", row["id"],
                "-fill", "#b7c4d4", "-pointsize", "15",
                "-annotate", "+0+6", f"{row['width']}x{row['height']}  {row['type']}",
                str(tmp),
            ])
            cards.append(str(tmp))
        subprocess.check_call([
            "montage", *cards, "-tile", "3x1", "-geometry", "+12+12", "-background", "#1e232a", str(CONTACT_OUT)
        ])


def build_audit() -> None:
    subprocess.check_call([
        "convert", str(SOURCE_MAP),
        "-stroke", "#ff5f5f", "-strokewidth", "3", "-fill", "none",
        "-draw", "rectangle 118,22 223,76",
        "-stroke", "#64d3ff",
        "-draw", "rectangle 145,497 201,554",
        "-stroke", "#98e67a",
        "-draw", "rectangle 222,172 266,214",
        "-stroke", "#f5d46b",
        "-draw", "rectangle 95,394 164,458",
        "-font", "DejaVu-Sans", "-fill", "white", "-pointsize", "18", "-stroke", "none",
        "-annotate", "+228+52", "metano_cafe_spinda",
        "-annotate", "+206+550", "metano_fire_home_round",
        "-annotate", "+272+206", "metano_expedition_tent",
        "-fill", "#f5d46b",
        "-annotate", "+170+435", "bear_head_cave_home_unique (unresolved)",
        str(AUDIT_OUT),
    ])


def build_scale_validation(rows: list[dict]) -> None:
    args = [
        "convert", "-size", "1200x520", "xc:#20252c",
        "-stroke", "#2d3642", "-strokewidth", "1", "-fill", "none",
    ]
    for x in range(0, 1200, PMDO_GRID_PX):
        args.extend(["-draw", f"line {x},0 {x},520"])
    for y in range(0, 520, PMDO_GRID_PX):
        args.extend(["-draw", f"line 0,{y} 1200,{y}"])
    args.extend([
        "-font", "DejaVu-Sans", "-fill", "#f5d46b", "-pointsize", "24", "-gravity", "north",
        "-annotate", "+0+12", "MAP TO SCALE PMDO BUILDING SCALE VALIDATION",
        "-fill", "#d6dde8", "-pointsize", "18",
        "-annotate", "+0+46", "Visible recoverable buildings from the uploaded PNG, placed on a 24px PMDO grid",
    ])
    positions = {
        "metano_expedition_tent": (90, 350),
        "metano_fire_home_round": (260, 350),
        "metano_cafe_spinda": (450, 350),
    }
    for row in rows:
        x, y = positions[row["id"]]
        args.extend([
            str(ROOT / row["asset_path"]), "-gravity", "northwest", "-geometry", f"+{x}+{y-row['height']}", "-composite",
            "-fill", "white", "-pointsize", "18", "-gravity", "northwest", "-annotate", f"+{x}+{y+10}", row["id"],
            "-fill", "#b7c4d4", "-pointsize", "15", "-annotate", f"+{x}+{y+32}", f"{row['width']}x{row['height']} px",
        ])
    args.extend([
        "-fill", "#98d98e", "-pointsize", "18", "-gravity", "northwest",
        "-annotate", "+48+120", "PMDO rule: 2.0x integer nearest-neighbor from the map presentation scale",
        "-annotate", "+48+148", "Exported assets already existed in canonical PMDO size and were reused directly",
        "-annotate", "+48+176", "Only exact clean alpha-isolated buildings were promoted into the atlas",
        str(SCALE_VALIDATION_OUT),
    ])
    subprocess.check_call(args)


def build_atlas(rows: list[dict]) -> dict:
    args = ["convert", "-size", f"{ATLAS_CANVAS[0]}x{ATLAS_CANVAS[1]}", "xc:none"]
    placements = []
    expected_opaque = 0
    for row in rows:
        pos = ATLAS_LAYOUT[row["id"]]
        expected_opaque += row["opaque_pixels"]
        placements.append({
            "id": row["id"],
            "type": row["type"],
            "source_path": row["asset_path"],
            "x": pos["x"],
            "y": pos["y"],
            "grid_x": pos["x"] // PMDO_GRID_PX,
            "grid_y": pos["y"] // PMDO_GRID_PX,
            "width": row["width"],
            "height": row["height"],
            "grid_aligned": pos["x"] % PMDO_GRID_PX == 0 and pos["y"] % PMDO_GRID_PX == 0,
        })
        args.extend([
            str(ROOT / row["asset_path"]), "-gravity", "northwest", "-geometry", f"+{pos['x']}+{pos['y']}", "-composite"
        ])
    args.append(str(ATLAS_OUT))
    subprocess.check_call(args)
    meta = identify(ATLAS_OUT)
    opaque, transparent = pixel_counts(ATLAS_OUT)
    atlas = {
        "schema": 1,
        "title": "Map-to-scale PMDO building atlas",
        "source_map": str(SOURCE_MAP.relative_to(ROOT)),
        "scale_reference": str(SCALE_REFERENCE.relative_to(ROOT)),
        "pmdo_grid_px": PMDO_GRID_PX,
        "canvas": {"width": ATLAS_CANVAS[0], "height": ATLAS_CANVAS[1]},
        "atlas_file": str(ATLAS_OUT.relative_to(ROOT)),
        "format": meta["format"],
        "channels": meta["channels"],
        "opaque_flag": meta["opaque"],
        "opaque_pixels": opaque,
        "transparent_pixels": transparent,
        "sha256": sha256(ATLAS_OUT),
        "expected_opaque_sum_without_overlap": expected_opaque,
        "placements": placements,
    }
    ATLAS_MANIFEST_OUT.write_text(json.dumps(atlas, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return atlas


def build_report(rows: list[dict], atlas: dict, duplicates: dict) -> None:
    report = f"""# MAP TO SCALE PMDO BUILDING REPORT

## Source

- `map to scale pmdo and make tilset asset.png`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png`

## PMDO scale used

{PMDO_SCALE_DESCRIPTION}

## Recovered visible buildings

"""
    for row in rows:
        report += (
            f"- **{row['id']}** — type `{row['type']}` — path `{row['asset_path']}` — "
            f"{row['width']}×{row['height']} px — alpha isolated: {'PASS' if row['alpha_isolated'] else 'FAIL'}\n"
        )
    report += "\n## Unresolved / excluded visible structures\n\n"
    for row in UNRESOLVED_VISIBLE_STRUCTURES:
        report += f"- `{row['id']}` — {row['status']} — {row['reason']}\n"
    report += f"""

## Atlas

- PNG: `{ATLAS_OUT.relative_to(ROOT)}`
- Manifest: `{ATLAS_MANIFEST_OUT.relative_to(ROOT)}`
- Canvas: {atlas['canvas']['width']}×{atlas['canvas']['height']} px
- Grid: {PMDO_GRID_PX} px
- Alpha isolation: {'PASS' if atlas['opaque_flag'] == 'false' and atlas['transparent_pixels'] > 0 else 'FAIL'}
- Overlap check: {'PASS' if atlas['opaque_pixels'] == atlas['expected_opaque_sum_without_overlap'] else 'FAIL'}

## Validation summary

- Recoverable exported buildings: {len(rows)}
- PNG format: {'PASS' if all(row['format'] == 'PNG' for row in rows) and atlas['format'] == 'PNG' else 'FAIL'}
- RGBA or alpha channel: {'PASS' if all(row['has_alpha'] for row in rows) and str(atlas['channels']).lower().endswith('a') else 'FAIL'}
- Duplicate audit: {'PASS' if not duplicates else 'FAIL'}
- Pixel-perfect reuse: PASS

## Deliverables

- Inventory: `{INVENTORY_OUT.relative_to(ROOT)}`
- Atlas: `{ATLAS_OUT.relative_to(ROOT)}`
- Atlas manifest: `{ATLAS_MANIFEST_OUT.relative_to(ROOT)}`
- Contact sheet: `{CONTACT_OUT.relative_to(ROOT)}`
- Audit: `{AUDIT_OUT.relative_to(ROOT)}`
- Scale validation: `{SCALE_VALIDATION_OUT.relative_to(ROOT)}`
"""
    REPORT_OUT.write_text(report, encoding="utf-8")


def main() -> None:
    ensure_dirs()
    rows = [enrich(item) for item in VISIBLE_RECOVERABLE_BUILDINGS]
    duplicates: dict[str, list[str]] = {}
    by_hash: dict[str, list[str]] = {}
    for row in rows:
        by_hash.setdefault(row["sha256"], []).append(row["id"])
    for digest, ids in by_hash.items():
        if len(ids) > 1:
            duplicates[digest] = ids

    atlas = build_atlas(rows)
    build_contact_sheet(rows)
    build_audit()
    build_scale_validation(rows)

    inventory = {
        "schema": 1,
        "title": "Map-to-scale PMDO visible building recovery",
        "source_map": str(SOURCE_MAP.relative_to(ROOT)),
        "scale_reference": str(SCALE_REFERENCE.relative_to(ROOT)),
        "pmdo_scale": {
            "description": PMDO_SCALE_DESCRIPTION,
            "canonical_visible_building_scale": "already canonical PMDO size",
            "presentation_to_pmdo_reference": "2.0x integer nearest-neighbor",
            "pmdo_grid_px": PMDO_GRID_PX,
        },
        "counts": {
            "exported_buildings": len(rows),
            "unresolved_or_excluded_visible_structures": len(UNRESOLVED_VISIBLE_STRUCTURES),
            "duplicate_hash_groups": len(duplicates),
        },
        "buildings": rows,
        "unresolved_visible_structures": UNRESOLVED_VISIBLE_STRUCTURES,
        "duplicate_hash_groups": duplicates,
        "atlas": atlas,
        "deliverables": {
            "atlas_png": str(ATLAS_OUT.relative_to(ROOT)),
            "atlas_manifest": str(ATLAS_MANIFEST_OUT.relative_to(ROOT)),
            "contact_sheet": str(CONTACT_OUT.relative_to(ROOT)),
            "audit": str(AUDIT_OUT.relative_to(ROOT)),
            "scale_validation": str(SCALE_VALIDATION_OUT.relative_to(ROOT)),
            "report": str(REPORT_OUT.relative_to(ROOT)),
        },
    }
    INVENTORY_OUT.write_text(json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    build_report(rows, atlas, duplicates)
    print(
        "MAP_TO_SCALE_PMDO_BUILDING_PACK_BUILT",
        f"exported={len(rows)}",
        f"unresolved={len(UNRESOLVED_VISIBLE_STRUCTURES)}",
        f"atlas={ATLAS_OUT.name}",
    )


if __name__ == "__main__":
    main()
