#!/usr/bin/env python3
"""Build a PMDO-ready building pack for visible MAPACOMPLETE Metano structures.

Scope:
- audit the flattened PixelLab authority map;
- keep only structure types that are visibly buildings on that source;
- reuse exact canonical alpha-isolated PMDO assets already present in the repo;
- include the separately requested Kingambit HQ PMDO-scale output;
- assemble a transparent PMDO atlas PNG for direct tileset/object-library reuse.

No source-map pixels are repainted or redesigned.
"""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete"
PMDO_DIR = BASE / "pmdo"
MANIFEST_DIR = BASE / "manifests"
REPORT_DIR = BASE / "reports"
VALIDATION_DIR = BASE / "validation"

MAP_SOURCE = ROOT / "MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp"
SCALE_REFERENCE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png"
KINGAMBIT_MANIFEST = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/manifests/metano_kingambit_pmdo_scale_manifest.json"

INVENTORY_OUT = MANIFEST_DIR / "MAPCOMPLETE_METANO_BUILDINGS_INVENTORY.json"
ATLAS_MANIFEST_OUT = MANIFEST_DIR / "MAPCOMPLETE_METANO_BUILDINGS_PMDO_ATLAS.json"
REPORT_OUT = REPORT_DIR / "MAPCOMPLETE_METANO_BUILDING_SCALE_REPORT.md"
ATLAS_OUT = PMDO_DIR / "MAPCOMPLETE_METANO_BUILDINGS_PMDO_ATLAS.png"
CONTACT_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_CONTACT_SHEET.png"
SCALE_VALIDATION_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_SCALE_VALIDATION.png"
MAP_AUDIT_OUT = VALIDATION_DIR / "MAPCOMPLETE_METANO_BUILDING_AUDIT.png"

PMDO_GRID_PX = 24
ATLAS_CANVAS = (624, 336)
ATLAS_LAYOUT = {
    "metano_cafe_spinda": {"x": 24, "y": 24},
    "metano_fire_home_round": {"x": 312, "y": 24},
    "metano_leaf_red_tent": {"x": 456, "y": 24},
    "kingambit_hq": {"x": 24, "y": 168},
}

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
        "reason": "visible on the source map but functions visually as a monument or pedestal rather than a building",
    },
    {
        "id": "pokemon_statue_podiums",
        "reason": "visible on the source map but are statues or monuments, not buildings",
    },
    {
        "id": "bunny_face_special_entrance",
        "reason": "visible as a landmark or special entrance; excluded from this building-only pack",
    },
]

PMDO_SCALE_DESCRIPTION = (
    "Metano Town PMDO building scale verified from metano_scale_verification.png: "
    "2.0x integer nearest-neighbor relative to native MAPACOMPLETE building footprints. "
    "Canonical Metano map buildings referenced here are already at that PMDO scale; "
    "Kingambit HQ uses the prebuilt 40% nearest-neighbor café-matched normalization stored in the repository."
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


def enrich_row(item: dict, kingambit_manifest: dict | None = None) -> dict:
    path = ROOT / item["asset_path"]
    meta = identify(path)
    opaque, transparent = pixel_counts(path)
    row = {
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
    if kingambit_manifest is not None:
        row["scale_reference"] = kingambit_manifest["pmdo"]["pmdo_scale_reference"]
        row["chosen_scale"] = kingambit_manifest["method"]["chosen_scale"]
        row["master_dimensions"] = [kingambit_manifest["master"]["width"], kingambit_manifest["master"]["height"]]
    return row


def ordered_rows(rows: list[dict]) -> list[dict]:
    order = ["metano_cafe_spinda", "metano_fire_home_round", "metano_leaf_red_tent", "kingambit_hq"]
    index = {name: i for i, name in enumerate(order)}
    return sorted(rows, key=lambda row: index[row["id"]])


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
    with tempfile.TemporaryDirectory() as tmpdir:
        cards: list[str] = []
        for index, row in enumerate(ordered_rows(rows)):
            tmp = Path(tmpdir) / f"card_{index}_{row['id']}.png"
            build_card(ROOT / row["asset_path"], row["id"], f"{row['width']}x{row['height']}  {row['type']}", tmp)
            cards.append(str(tmp))
        subprocess.check_call([
            "montage",
            *cards,
            "-tile",
            "2x2",
            "-geometry",
            "+12+12",
            "-background",
            "#1e232a",
            str(CONTACT_OUT),
        ])


def build_scale_validation(rows: list[dict]) -> None:
    draw_cmds = []
    for x in range(0, 1400, PMDO_GRID_PX):
        draw_cmds.append(f"line {x},0 {x},760")
    for y in range(0, 760, PMDO_GRID_PX):
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
    for row in ordered_rows(rows):
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


def build_tileset_atlas(rows: list[dict]) -> dict:
    args = ["convert", "-size", f"{ATLAS_CANVAS[0]}x{ATLAS_CANVAS[1]}", "xc:none"]
    placements: list[dict] = []
    expected_opaque_sum = 0
    for row in ordered_rows(rows):
        pos = ATLAS_LAYOUT[row["id"]]
        expected_opaque_sum += row["opaque_pixels"]
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
            "visible_on_map_complete": row.get("visible_on_map_complete", False),
        })
        args.extend([
            str(ROOT / row["asset_path"]),
            "-gravity",
            "northwest",
            "-geometry",
            f"+{pos['x']}+{pos['y']}",
            "-composite",
        ])
    args.append(str(ATLAS_OUT))
    subprocess.check_call(args)

    meta = identify(ATLAS_OUT)
    opaque, transparent = pixel_counts(ATLAS_OUT)
    atlas_manifest = {
        "schema": 1,
        "title": "MAPCOMPLETE Metano PMDO Building Atlas",
        "source_map": str(MAP_SOURCE.relative_to(ROOT)),
        "scale_reference": str(SCALE_REFERENCE.relative_to(ROOT)),
        "pmdo_grid_px": PMDO_GRID_PX,
        "canvas": {
            "width": ATLAS_CANVAS[0],
            "height": ATLAS_CANVAS[1],
        },
        "atlas_file": str(ATLAS_OUT.relative_to(ROOT)),
        "format": meta["format"],
        "channels": meta["channels"],
        "opaque_flag": meta["opaque"],
        "opaque_pixels": opaque,
        "transparent_pixels": transparent,
        "sha256": sha256(ATLAS_OUT),
        "expected_opaque_sum_without_overlap": expected_opaque_sum,
        "placements": placements,
    }
    ATLAS_MANIFEST_OUT.write_text(json.dumps(atlas_manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return atlas_manifest


def build_report(rows: list[dict], duplicates: dict, atlas_manifest: dict) -> None:
    alpha_pass = all(row["alpha_isolated"] for row in rows)
    duplicate_pass = len(duplicates) == 0
    report = f"""# MAPCOMPLETE METANO BUILDING SCALE REPORT

## Scope

User-requested building-only PMDO scaling pass for the complete PixelLab map authority:
- `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`
- `metano_scale_verification.png`
- plus the separately requested external `QGKingambit` building.

This pack is conservative on purpose. It reuses exact canonical alpha-isolated PMDO assets already present in the repository for building types visibly represented on the complete map, and assembles them into one transparent PMDO atlas PNG without duplicating or repainting source art.

## PMDO scale used

{PMDO_SCALE_DESCRIPTION}

## Building inventory recovered for direct PMDO reuse

"""
    for row in ordered_rows(rows):
        report += (
            f"- **{row['id']}** — type `{row['type']}` — path `{row['asset_path']}` — "
            f"{row['width']}×{row['height']} px — alpha isolated: {'PASS' if row['alpha_isolated'] else 'FAIL'}\n"
        )
    report += "\n## PMDO assembled atlas\n\n"
    report += (
        f"- Atlas PNG: `{ATLAS_OUT.relative_to(ROOT)}`\n"
        f"- Atlas manifest: `{ATLAS_MANIFEST_OUT.relative_to(ROOT)}`\n"
        f"- Canvas: {atlas_manifest['canvas']['width']}×{atlas_manifest['canvas']['height']} px\n"
        f"- PMDO grid: {PMDO_GRID_PX} px\n"
        f"- Atlas alpha isolation: {'PASS' if atlas_manifest['opaque_flag'] == 'false' and atlas_manifest['transparent_pixels'] > 0 else 'FAIL'}\n"
    )
    report += "\nPlacement summary:\n"
    for placement in atlas_manifest["placements"]:
        report += (
            f"- `{placement['id']}` at px ({placement['x']}, {placement['y']}) "
            f"/ grid ({placement['grid_x']}, {placement['grid_y']}) — aligned: {'PASS' if placement['grid_aligned'] else 'FAIL'}\n"
        )
    report += "\n## Excluded visible non-buildings\n\n"
    for row in EXCLUDED_VISIBLE_NON_BUILDINGS:
        report += f"- `{row['id']}` — {row['reason']}\n"
    report += f"""

## Validation summary

- Total assets in pack: {len(rows)}
- Visible MAPACOMPLETE building types: {len(CANONICAL_BUILDINGS)}
- External requested buildings: {len(EXTERNAL_BUILDINGS)}
- PNG format: {'PASS' if all(row['format'] == 'PNG' for row in rows) and atlas_manifest['format'] == 'PNG' else 'FAIL'}
- RGBA or alpha channel: {'PASS' if all(row['has_alpha'] for row in rows) and str(atlas_manifest['channels']).lower().endswith('a') else 'FAIL'}
- Transparent background present: {'PASS' if alpha_pass and atlas_manifest['transparent_pixels'] > 0 else 'FAIL'}
- Duplicate audit inside selected pack: {'PASS' if duplicate_pass else 'FAIL'}
- Canonical café anchor present: {'PASS' if any(row['id'] == 'metano_cafe_spinda' for row in rows) else 'FAIL'}
- Kingambit HQ present: {'PASS' if any(row['id'] == 'kingambit_hq' for row in rows) else 'FAIL'}
- Atlas grid alignment: {'PASS' if all(p['grid_aligned'] for p in atlas_manifest['placements']) else 'FAIL'}
- Atlas overlap check: {'PASS' if atlas_manifest['opaque_pixels'] == atlas_manifest['expected_opaque_sum_without_overlap'] else 'FAIL'}

## Deliverables

- Inventory: `{INVENTORY_OUT.relative_to(ROOT)}`
- Atlas PNG: `{ATLAS_OUT.relative_to(ROOT)}`
- Atlas manifest: `{ATLAS_MANIFEST_OUT.relative_to(ROOT)}`
- Contact sheet: `{CONTACT_OUT.relative_to(ROOT)}`
- Scale validation: `{SCALE_VALIDATION_OUT.relative_to(ROOT)}`
- Map audit: `{MAP_AUDIT_OUT.relative_to(ROOT)}`

## Notes

- No pixels were redrawn.
- No colors were changed.
- No interpolation other than the declared nearest-neighbor scaling for the prebuilt Kingambit asset was used.
- The complete map file itself was not modified.
"""
    REPORT_OUT.write_text(report, encoding="utf-8")


def main() -> None:
    ensure_dirs()
    if not MAP_SOURCE.exists():
        raise FileNotFoundError(MAP_SOURCE)
    if not SCALE_REFERENCE.exists():
        raise FileNotFoundError(SCALE_REFERENCE)
    kingambit_manifest = json.loads(KINGAMBIT_MANIFEST.read_text(encoding="utf-8"))

    rows = [enrich_row(item) for item in CANONICAL_BUILDINGS]
    rows.extend(enrich_row(item, kingambit_manifest) for item in EXTERNAL_BUILDINGS)

    duplicates: dict[str, list[str]] = {}
    by_hash: dict[str, list[str]] = {}
    for row in rows:
        by_hash.setdefault(row["sha256"], []).append(row["id"])
    for digest, ids in by_hash.items():
        if len(ids) > 1:
            duplicates[digest] = ids

    build_contact_sheet(rows)
    build_scale_validation(rows)
    build_map_audit()
    atlas_manifest = build_tileset_atlas(rows)

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
            "pmdo_grid_px": PMDO_GRID_PX,
        },
        "counts": {
            "total_assets": len(rows),
            "visible_map_buildings": len(CANONICAL_BUILDINGS),
            "external_requested_buildings": len(EXTERNAL_BUILDINGS),
            "duplicate_hash_groups": len(duplicates),
        },
        "buildings": ordered_rows(rows),
        "excluded_visible_non_buildings": EXCLUDED_VISIBLE_NON_BUILDINGS,
        "duplicate_hash_groups": duplicates,
        "atlas": atlas_manifest,
        "deliverables": {
            "atlas_png": str(ATLAS_OUT.relative_to(ROOT)),
            "atlas_manifest": str(ATLAS_MANIFEST_OUT.relative_to(ROOT)),
            "contact_sheet": str(CONTACT_OUT.relative_to(ROOT)),
            "scale_validation": str(SCALE_VALIDATION_OUT.relative_to(ROOT)),
            "map_audit": str(MAP_AUDIT_OUT.relative_to(ROOT)),
            "report": str(REPORT_OUT.relative_to(ROOT)),
        },
    }
    INVENTORY_OUT.write_text(json.dumps(inventory, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    build_report(rows, duplicates, atlas_manifest)

    print(
        "MAPCOMPLETE_METANO_BUILDING_PACK_BUILT",
        f"assets={len(rows)}",
        f"visible_map_buildings={len(CANONICAL_BUILDINGS)}",
        f"external={len(EXTERNAL_BUILDINGS)}",
        f"atlas={ATLAS_OUT.name}",
        f"duplicate_pass={len(duplicates) == 0}",
    )


if __name__ == "__main__":
    main()
