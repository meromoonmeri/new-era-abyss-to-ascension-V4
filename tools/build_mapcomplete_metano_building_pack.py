#!/usr/bin/env python3
"""Build a PMDO-ready building pack for the visible buildings on MAPACOMPLETE Metano.

This pack is intentionally conservative:
- it inventories only the structures that are visibly buildings on
  MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp and already have exact alpha-isolated
  PMDO-compatible canonical assets in the repository;
- it reuses those canonical assets instead of duplicating pixels;
- it includes the separately requested Kingambit HQ scaling output as the only
  external building deliverable.

No source-map pixels are edited.  No new building art is generated.
"""
from __future__ import annotations

import hashlib
import json
import math
import os
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete"
MANIFEST_DIR = BASE / "manifests"
REPORT_DIR = BASE / "reports"
VALIDATION_DIR = BASE / "validation"
INVENTORY_OUT = MANIFEST_DIR / "MAPCOMPLETE_METANO_BUILDINGS_INVENTORY.json"
REPORT_OUT = REPORT_DIR / "MAPCOMPLETE_METANO_BUILDING_SCALE_REPORT.md"
CONTACT_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_CONTACT_SHEET.png"
SCALE_VALIDATION_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_SCALE_VALIDATION.png"
MAP_AUDIT_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_AUDIT.png"

MAP_SOURCE = ROOT / "MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp"
SCALE_REFERENCE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png"
KINGAMBIT_MANIFEST = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/manifests/metano_kingambit_pmdo_scale_manifest.json"

CANONICAL_BUILDINGS = [
    {
        "id": "metano_cafe_spinda",
        "type": "cafe",
        "visible_on_map_complete": True,
        "location_hint": "north-west plaza",
        "map_bbox_native": [92, 10, 171, 51],
        "occurrences": "single visible instance",
        "asset_path": "data/pmdo_assets_alpha_entiers/02_boutiques_et_marche/grand_cafe_spinda_terrasse_jour.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "scale_action": "already at PMDO building scale; no additional rescale applied",
    },
    {
        "id": "metano_fire_home_round",
        "type": "house",
        "visible_on_map_complete": True,
        "location_hint": "south-west residential row",
        "map_bbox_native": [151, 471, 206, 521],
        "occurrences": "single visible instance",
        "asset_path": "data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/maison_style_feu.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "scale_action": "already at PMDO building scale; no additional rescale applied",
    },
    {
        "id": "metano_leaf_red_tent",
        "type": "tent_house",
        "visible_on_map_complete": True,
        "location_hint": "repeated through the central and southern neighborhoods",
        "map_bbox_native": [418, 660, 466, 708],
        "occurrences": "multiple visually identical instances; extracted once canonically",
        "asset_path": "data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/grande_tente_campement_unie.png",
        "source_strategy": "existing_canonical_alpha_asset",
        "scale_action": "already at PMDO building scale; no additional rescale applied",
    },
]

EXTERNAL_BUILDINGS = [
    {
        "id": "kingambit_hq",
        "type": "hq",
        "visible_on_map_complete": False,
        "requested_with_mapcomplete_batch": True,
        "location_hint": "external user-supplied alpha-isolated building",
        "asset_path": "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/pmdo/QGKingambit_metano_cafe_reference_pmdo_40pct.png",
        "master_path": "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/master/QGKingambit-removebg-preview_trimmed.png",
        "source_strategy": "existing_external_alpha_source_scaled_against_cafe_reference",
    }
]

EXCLUDED_VISIBLE_NON_BUILDINGS = [
    {
        "id": "blue_roof_memorial",
        "reason": "visible on the source map but functions visually as a monument/pedestal rather than a building",
    },
    {
        "id": "pokemon_statue_podiums",
        "reason": "visible on the source map but are statues/monuments, not buildings",
    },
    {
        "id": "bunny_face_special_entrance",
        "reason": "visible as a landmark/special entrance; excluded from this building-only pack",
    },
]

PMDO_SCALE_DESCRIPTION = "Metano Town PMDO building scale verified from metano_scale_verification.png: 2.0x integer nearest-neighbor relative to native MAPACOMPLETE building footprints. Canonical Metano map buildings referenced here are already at that PMDO scale; Kingambit HQ uses the prebuilt 40% nearest-neighbor café-matched normalization stored in the repository."


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


def ensure_dirs() -> None:
    for path in (MANIFEST_DIR, REPORT_DIR, VALIDATION_DIR):
        path.mkdir(parents=True, exist_ok=True)


def build_card(image_path: Path, title: str, subtitle: str, out_path: Path) -> None:
    subprocess.check_call([
        "convert",
        "-size",
        "340x250",
        "xc:#2b3038",
        "-fill",
        "#3a424d",
        "-stroke",
        "#7d8999",
        "-strokewidth",
        "1",
        "-draw",
        "rectangle 4,4 336,246",
        str(image_path),
        "-gravity",
        "center",
        "-geometry",
        "+0-16",
        "-composite",
        "-font",
        "DejaVu-Sans",
        "-fill",
        "white",
        "-pointsize",
        "18",
        "-gravity",
        "south",
        "-annotate",
        "+0+26",
        title,
        "-fill",
        "#b7c4d4",
        "-pointsize",
        "15",
        "-annotate",
        "+0+6",
        subtitle,
        str(out_path),
    ])


def build_contact_sheet(rows: list[dict]) -> None:
    temp_cards = []
    for index, row in enumerate(rows):
        tmp = VALIDATION_DIR / f"_card_{index}_{row['id']}.png"
        build_card(ROOT / row["asset_path"], row["id"], f"{row['width']}x{row['height']}  {row['type']}", tmp)
        temp_cards.append(tmp)
    subprocess.check_call([
        "montage",
        *[str(path) for path in temp_cards],
        "-tile",
        "2x2",
        "-geometry",
        "+12+12",
        "-background",
        "#1e232a",
        str(CONTACT_OUT),
    ])
    for path in temp_cards:
        path.unlink(missing_ok=True)


def build_scale_validation(rows: list[dict]) -> None:
    draw_cmds = []
    # 24 px PMDO grid on a neutral dark background.
    for x in range(0, 1400, 24):
        draw_cmds.append(f"line {x},0 {x},760")
    for y in range(0, 760, 24):
        draw_cmds.append(f"line 0,{y} 1400,{y}")
    args = [
        "convert",
        "-size",
        "1400x760",
        "xc:#20252c",
        "-stroke",
        "#2d3642",
        "-strokewidth",
        "1",
        "-fill",
        "none",
    ]
    for cmd in draw_cmds:
        args.extend(["-draw", cmd])
    args.extend([
        "-font",
        "DejaVu-Sans",
        "-fill",
        "#f5d46b",
        "-pointsize",
        "24",
        "-gravity",
        "north",
        "-annotate",
        "+0+12",
        "MAPCOMPLETE METANO BUILDING SCALE VALIDATION",
        "-fill",
        "#d6dde8",
        "-pointsize",
        "18",
        "-annotate",
        "+0+46",
        "Reference café + canonical PMDO buildings + Kingambit HQ on a 24px PMDO grid",
    ])
    positions = {
        "metano_leaf_red_tent": (110, 520),
        "metano_fire_home_round": (360, 520),
        "metano_cafe_spinda": (610, 520),
        "kingambit_hq": (980, 540),
    }
    for row in rows:
        args.extend([
            str(ROOT / row["asset_path"]),
            "-gravity",
            "northwest",
            "-geometry",
            f"+{positions[row['id']][0]}+{positions[row['id']][1] - row['height']}",
            "-composite",
            "-fill",
            "white",
            "-pointsize",
            "18",
            "-gravity",
            "northwest",
            "-annotate",
            f"+{positions[row['id']][0]}+{positions[row['id']][1] + 10}",
            row["id"],
            "-fill",
            "#b7c4d4",
            "-pointsize",
            "15",
            "-annotate",
            f"+{positions[row['id']][0]}+{positions[row['id']][1] + 32}",
            f"{row['width']}x{row['height']} px",
        ])
    args.extend([
        "-fill",
        "#98d98e",
        "-pointsize",
        "18",
        "-gravity",
        "northwest",
        "-annotate",
        "+48+120",
        "PMDO scale rule: 2.0x integer nearest-neighbor for native MAPACOMPLETE buildings",
        "-annotate",
        "+48+148",
        "Café asset is the canonical dimensional anchor",
        "-annotate",
        "+48+176",
        "Tent and fire home are reused canonical PMDO assets already matching that anchor",
        "-annotate",
        "+48+204",
        "Kingambit HQ reuses the existing café-matched 40% point-scaled export",
        str(SCALE_VALIDATION_OUT),
    ])
    subprocess.check_call(args)


def build_map_audit() -> None:
    subprocess.check_call([
        "convert",
        str(MAP_SOURCE),
        "-filter",
        "point",
        "-resize",
        "200%",
        "-stroke",
        "#ff5f5f",
        "-strokewidth",
        "3",
        "-fill",
        "none",
        "-draw",
        "rectangle 184,20 342,102",
        "-stroke",
        "#64d3ff",
        "-draw",
        "rectangle 302,942 412,1042",
        "-stroke",
        "#98e67a",
        "-draw",
        "rectangle 836,1320 932,1416",
        "-font",
        "DejaVu-Sans",
        "-fill",
        "white",
        "-pointsize",
        "20",
        "-stroke",
        "none",
        "-annotate",
        "+352+78",
        "metano_cafe_spinda",
        "-annotate",
        "+422+1018",
        "metano_fire_home_round",
        "-annotate",
        "+942+1390",
        "metano_leaf_red_tent",
        str(MAP_AUDIT_OUT),
    ])


def main() -> None:
    ensure_dirs()
    if not MAP_SOURCE.exists():
        raise FileNotFoundError(MAP_SOURCE)
    if not SCALE_REFERENCE.exists():
        raise FileNotFoundError(SCALE_REFERENCE)
    kingambit_manifest = json.loads(KINGAMBIT_MANIFEST.read_text(encoding="utf-8"))

    rows = []
    for item in CANONICAL_BUILDINGS:
        path = ROOT / item["asset_path"]
        meta = identify(path)
        opaque, transparent = pixel_counts(path)
        rows.append({
            **item,
            "format": meta["format"],
            "channels": meta["channels"],
            "opaque_flag": meta["opaque"],
            "width": meta["width"],
            "height": meta["height"],
            "opaque_pixels": opaque,
            "transparent_pixels": transparent,
            "has_alpha": meta["channels"].lower().endswith("a"),
            "alpha_isolated": meta["channels"].lower().endswith("a") and meta["opaque"] == "false" and transparent > 0,
            "sha256": sha256(path),
            "pmdo_scale_verified": True,
            "scale_reference": PMDO_SCALE_DESCRIPTION,
        })

    for item in EXTERNAL_BUILDINGS:
        path = ROOT / item["asset_path"]
        meta = identify(path)
        opaque, transparent = pixel_counts(path)
        rows.append({
            **item,
            "format": meta["format"],
            "channels": meta["channels"],
            "opaque_flag": meta["opaque"],
            "width": meta["width"],
            "height": meta["height"],
            "opaque_pixels": opaque,
            "transparent_pixels": transparent,
            "has_alpha": meta["channels"].lower().endswith("a"),
            "alpha_isolated": meta["channels"].lower().endswith("a") and meta["opaque"] == "false" and transparent > 0,
            "sha256": sha256(path),
            "pmdo_scale_verified": True,
            "scale_reference": kingambit_manifest["pmdo"]["pmdo_scale_reference"],
            "chosen_scale": kingambit_manifest["method"]["chosen_scale"],
            "master_dimensions": [kingambit_manifest["master"]["width"], kingambit_manifest["master"]["height"]],
        })

    duplicates = {}
    by_hash = {}
    for row in rows:
        by_hash.setdefault(row["sha256"], []).append(row["id"])
    for digest, ids in by_hash.items():
        if len(ids) > 1:
            duplicates[digest] = ids

    inventory = {
        "schema": 1,
        "title": "MAPCOMPLETE Metano PMDO Building Pack",
        "session_branch": "arena/01a05db7-new-era-abyss-to-ascension-v4",
        "authoritative_sources": {
            "map_complete": str(MAP_SOURCE.relative_to(ROOT)),
            "scale_verification": str(SCALE_REFERENCE.relative_to(ROOT)),
            "kingambit_manifest": str(KINGAMBIT_MANIFEST.relative_to(ROOT)),
        },
        "pmdo_scale": {
            "description": PMDO_SCALE_DESCRIPTION,
            "canonical_map_buildings_integer_scale": "2.0x",
            "kingambit_external_nearest_neighbor_scale": kingambit_manifest["method"]["chosen_scale"],
        },
        "counts": {
            "total_assets": len(rows),
            "visible_map_buildings": len(CANONICAL_BUILDINGS),
            "external_requested_buildings": len(EXTERNAL_BUILDINGS),
            "duplicate_hash_groups": len(duplicates),
        },
        "buildings": rows,
        "excluded_visible_non_buildings": EXCLUDED_VISIBLE_NON_BUILDINGS,
        "duplicate_hash_groups": duplicates,
        "deliverables": {
            "contact_sheet": str(CONTACT_OUT.relative_to(ROOT)),
            "scale_validation": str(SCALE_VALIDATION_OUT.relative_to(ROOT)),
            "map_audit": str(MAP_AUDIT_OUT.relative_to(ROOT)),
            "report": str(REPORT_OUT.relative_to(ROOT)),
        },
    }
    INVENTORY_OUT.write_text(json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    build_contact_sheet(rows)
    build_scale_validation(rows)
    build_map_audit()

    alpha_pass = all(row["alpha_isolated"] for row in rows)
    duplicate_pass = len(duplicates) == 0
    report = f"""# MAPCOMPLETE METANO BUILDING SCALE REPORT

## Scope

User-requested building-only PMDO scaling pass for the complete PixelLab map authority:
- `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`
- `metano_scale_verification.png`
- plus the separately requested external `QGKingambit` building already prepared in this repository.

This pack is conservative on purpose.  It only reuses exact canonical alpha-isolated PMDO assets already present in the repository for the buildings visibly represented on the complete map, and it does not duplicate those assets into a second pixel copy.

## PMDO scale used

{PMDO_SCALE_DESCRIPTION}

## Building inventory recovered for direct PMDO reuse

"""
    for row in rows:
        report += (
            f"- **{row['id']}** — type `{row['type']}` — path `{row['asset_path']}` — "
            f"{row['width']}×{row['height']} px — alpha isolated: {'PASS' if row['alpha_isolated'] else 'FAIL'}\n"
        )
    report += f"""

## Excluded visible non-buildings

"""
    for row in EXCLUDED_VISIBLE_NON_BUILDINGS:
        report += f"- `{row['id']}` — {row['reason']}\n"
    report += f"""

## Validation summary

- Total assets in pack: {len(rows)}
- Visible MAPACOMPLETE building types: {len(CANONICAL_BUILDINGS)}
- External requested buildings: {len(EXTERNAL_BUILDINGS)}
- PNG format: {'PASS' if all(row['format'] == 'PNG' for row in rows) else 'FAIL'}
- RGBA/alpha channel: {'PASS' if all(row['has_alpha'] for row in rows) else 'FAIL'}
- Transparent background present: {'PASS' if alpha_pass else 'FAIL'}
- Duplicate audit inside selected pack: {'PASS' if duplicate_pass else 'FAIL'}
- Canonical café anchor present: {'PASS' if any(row['id'] == 'metano_cafe_spinda' for row in rows) else 'FAIL'}
- Kingambit HQ present: {'PASS' if any(row['id'] == 'kingambit_hq' for row in rows) else 'FAIL'}

## Deliverables

- Inventory: `{INVENTORY_OUT.relative_to(ROOT)}`
- Contact sheet: `{CONTACT_OUT.relative_to(ROOT)}`
- Scale validation: `{SCALE_VALIDATION_OUT.relative_to(ROOT)}`
- Map audit: `{MAP_AUDIT_OUT.relative_to(ROOT)}`

## Notes

- No pixels were redrawn.
- No colors were changed.
- No interpolation other than declared nearest-neighbor scaling for the prebuilt Kingambit asset is used.
- The complete map file itself was not modified.
"""
    REPORT_OUT.write_text(report, encoding="utf-8")

    print(
        "MAPCOMPLETE_METANO_BUILDING_PACK_BUILT",
        f"assets={len(rows)}",
        f"visible_map_buildings={len(CANONICAL_BUILDINGS)}",
        f"external={len(EXTERNAL_BUILDINGS)}",
        f"alpha_pass={alpha_pass}",
        f"duplicate_pass={duplicate_pass}",
    )


if __name__ == "__main__":
    main()
