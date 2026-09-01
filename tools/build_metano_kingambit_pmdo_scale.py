#!/usr/bin/env python3
"""Build a PMDO-scaled Kingambit building asset using Metano café as reference.

Scope intentionally limited to the user-requested external building:
- preserve the provided alpha-isolated source art;
- trim only transparent margins;
- derive a comparable PMDO mass target from the canonical Metano café asset;
- choose a deterministic nearest-neighbor scale (40%) close to the café-derived target;
- emit manifest, validation sheet, contact sheet, and markdown report.
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
BASE = ROOT / "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled"
REFERENCE_CAFE = ROOT / "docs/metano_origins_structure_library/buildings/metano_cafe_day.png"
SOURCE = BASE / "references/QGKingambit-removebg-preview.png"
OUT_ROOT = BASE / "buildings/kingambit"
MASTER_DIR = OUT_ROOT / "master"
PMDO_DIR = OUT_ROOT / "pmdo"
MANIFEST_DIR = OUT_ROOT / "manifests"
REPORT_DIR = OUT_ROOT / "reports"
VALIDATION_DIR = OUT_ROOT / "validation"
MASTER_OUT = MASTER_DIR / "QGKingambit-removebg-preview_trimmed.png"
PMDO_OUT = PMDO_DIR / "QGKingambit_metano_cafe_reference_pmdo_40pct.png"
MANIFEST_OUT = MANIFEST_DIR / "metano_kingambit_pmdo_scale_manifest.json"
REPORT_OUT = REPORT_DIR / "METANO_KINGAMBIT_BUILDING_SCALE_REPORT.md"
CONTACT_SHEET_OUT = VALIDATION_DIR / "METANO_KINGAMBIT_PMDO_CONTACT_SHEET.png"
VALIDATION_SHEET_OUT = VALIDATION_DIR / "METANO_KINGAMBIT_PMDO_SCALE_VALIDATION.png"
PMDO_SCALE_REFERENCE = "Metano Town PMDO standard: existing 2.0x map calibration; external Kingambit building matched to the canonical PMDO café via deterministic 40% nearest-neighbor downscale of the trimmed master"
CHOSEN_SCALE = 0.40


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def identify_metrics(path: Path) -> dict:
    text = run(
        "identify",
        "-format",
        "width=%w\nheight=%h\nchannels=%[channels]\nopaque=%[opaque]\nformat=%m\n",
        str(path),
    )
    result = {}
    for line in text.strip().splitlines():
        key, value = line.split("=", 1)
        result[key] = value
    result["width"] = int(result["width"])
    result["height"] = int(result["height"])
    return result


def pixel_stats(path: Path) -> dict:
    text = run("convert", str(path), "txt:-")
    opaque = 0
    alpha_zero = 0
    xs: list[int] = []
    ys: list[int] = []
    rgba = re.compile(r"(\d+),(\d+): \((\d+),(\d+),(\d+),(\d+)\)")
    rgb = re.compile(r"(\d+),(\d+): \((\d+),(\d+),(\d+)\)")
    for line in text.splitlines()[1:]:
        match = rgba.match(line)
        if match:
            x, y, _r, _g, _b, a = map(int, match.groups())
        else:
            match = rgb.match(line)
            if not match:
                continue
            x, y, _r, _g, _b = map(int, match.groups())
            a = 255
        if a == 0:
            alpha_zero += 1
        else:
            opaque += 1
            xs.append(x)
            ys.append(y)
    bbox = None
    if xs:
        bbox = [min(xs), min(ys), max(xs), max(ys)]
    return {
        "opaque_pixels": opaque,
        "transparent_pixels": alpha_zero,
        "opaque_bbox": bbox,
    }


def ensure_dirs() -> None:
    for path in (MASTER_DIR, PMDO_DIR, MANIFEST_DIR, REPORT_DIR, VALIDATION_DIR):
        path.mkdir(parents=True, exist_ok=True)


def build_assets() -> dict:
    ensure_dirs()
    if not SOURCE.exists():
        raise FileNotFoundError(f"Missing source reference: {SOURCE}")
    if not REFERENCE_CAFE.exists():
        raise FileNotFoundError(f"Missing canonical PMDO café reference: {REFERENCE_CAFE}")

    subprocess.check_call(["convert", str(SOURCE), "-alpha", "on", "-background", "none", "-trim", "+repage", str(MASTER_OUT)])
    subprocess.check_call(["convert", str(MASTER_OUT), "-filter", "point", "-resize", f"{CHOSEN_SCALE * 100:.0f}%", str(PMDO_OUT)])

    cafe_metrics = identify_metrics(REFERENCE_CAFE)
    cafe_pixels = pixel_stats(REFERENCE_CAFE)
    master_metrics = identify_metrics(MASTER_OUT)
    master_pixels = pixel_stats(MASTER_OUT)
    pmdo_metrics = identify_metrics(PMDO_OUT)
    pmdo_pixels = pixel_stats(PMDO_OUT)

    target_scale = math.sqrt(cafe_pixels["opaque_pixels"] / master_pixels["opaque_pixels"])

    manifest = {
        "task": "Scale external Kingambit building to Metano PMDO-compatible size using the café building as reference",
        "source_authority": {
            "metano_map": "MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp",
            "metano_scale_verification": "data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png",
            "metano_cafe_pmdo_reference": str(REFERENCE_CAFE.relative_to(ROOT)),
            "external_building_source": str(SOURCE.relative_to(ROOT)),
        },
        "method": {
            "master_preprocess": "trim transparent margins only",
            "scale_selector": "opaque-pixel-area comparison against canonical Metano café asset",
            "cafe_derived_target_scale": target_scale,
            "chosen_scale": CHOSEN_SCALE,
            "chosen_scale_rationale": "nearest simple deterministic point-scale ratio to the café-derived target that preserves pixel art without interpolation",
            "resampler": "nearest-neighbor / point",
            "palette_changed": False,
            "interpolation_used": False,
            "art_redesigned": False,
        },
        "files": {
            "master": str(MASTER_OUT.relative_to(ROOT)),
            "pmdo": str(PMDO_OUT.relative_to(ROOT)),
            "contact_sheet": str(CONTACT_SHEET_OUT.relative_to(ROOT)),
            "validation_sheet": str(VALIDATION_SHEET_OUT.relative_to(ROOT)),
            "report": str(REPORT_OUT.relative_to(ROOT)),
        },
        "reference_cafe": {
            **cafe_metrics,
            **cafe_pixels,
            "sha256": sha256(REFERENCE_CAFE),
        },
        "master": {
            **master_metrics,
            **master_pixels,
            "sha256": sha256(MASTER_OUT),
        },
        "pmdo": {
            **pmdo_metrics,
            **pmdo_pixels,
            "sha256": sha256(PMDO_OUT),
            "alpha_isolation": pmdo_metrics["channels"].lower().endswith("a") and pmdo_metrics["opaque"] == "false" and pmdo_pixels["transparent_pixels"] > 0,
            "pmdo_scale_reference": PMDO_SCALE_REFERENCE,
        },
    }

    MANIFEST_OUT.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    build_contact_sheet()
    build_validation_sheet()
    cleanup_auxiliary_validation_files()
    build_report(manifest)
    return manifest


def _label_strip(text: str, width: int) -> Path:
    tmp = VALIDATION_DIR / (re.sub(r"[^A-Za-z0-9_-]+", "_", text).strip("_") + f"_{width}.png")
    subprocess.check_call([
        "convert",
        "-size",
        f"{width}x34",
        "xc:none",
        "-gravity",
        "center",
        "-font",
        "DejaVu-Sans",
        "-fill",
        "#202020",
        "-pointsize",
        "18",
        "-annotate",
        "+0+0",
        text,
        str(tmp),
    ])
    return tmp


def build_contact_sheet() -> None:
    left_label = _label_strip("PMDO cafe reference", 280)
    mid_label = _label_strip("Kingambit master trimmed", 280)
    right_label = _label_strip("Kingambit PMDO 40%", 280)
    subprocess.check_call([
        "convert",
        "-size", "920x420", "xc:#d8d8d8",
        str(left_label), "-gravity", "northwest", "-geometry", "+20+14", "-composite",
        str(REFERENCE_CAFE), "-gravity", "southwest", "-geometry", "+20+36", "-composite",
        str(mid_label), "-gravity", "north", "-geometry", "+0+14", "-composite",
        str(MASTER_OUT), "-gravity", "center", "-geometry", "+0+18", "-composite",
        str(right_label), "-gravity", "northeast", "-geometry", "+20+14", "-composite",
        str(PMDO_OUT), "-gravity", "southeast", "-geometry", "+20+36", "-composite",
        str(CONTACT_SHEET_OUT),
    ])


def build_validation_sheet() -> None:
    title = _label_strip("SOURCE MASTER → PMDO CAFE REFERENCE → SCALED OUTPUT", 880)
    subtitle = _label_strip("Metano calibration kept; external building converted with 40% nearest-neighbor", 880)
    left = _label_strip("Master source", 250)
    center = _label_strip("Metano PMDO cafe", 250)
    right = _label_strip("Scaled output", 250)
    subprocess.check_call([
        "convert",
        "-size", "920x520", "xc:#f1f1f1",
        str(title), "-gravity", "north", "-geometry", "+0+10", "-composite",
        str(subtitle), "-gravity", "north", "-geometry", "+0+46", "-composite",
        "-stroke", "#707070", "-strokewidth", "2", "-fill", "none",
        "-draw", "rectangle 18,86 300,498",
        "-draw", "rectangle 320,86 600,498",
        "-draw", "rectangle 620,86 902,498",
        str(left), "-gravity", "northwest", "-geometry", "+34+98", "-composite",
        str(center), "-gravity", "northwest", "-geometry", "+334+98", "-composite",
        str(right), "-gravity", "northwest", "-geometry", "+636+98", "-composite",
        str(MASTER_OUT), "-gravity", "west", "-geometry", "+24+40", "-composite",
        str(REFERENCE_CAFE), "-gravity", "southwest", "-geometry", "+340+42", "-composite",
        str(PMDO_OUT), "-gravity", "southeast", "-geometry", "+38+42", "-composite",
        str(VALIDATION_SHEET_OUT),
    ])


def cleanup_auxiliary_validation_files() -> None:
    keep = {CONTACT_SHEET_OUT.name, VALIDATION_SHEET_OUT.name}
    for candidate in VALIDATION_DIR.glob("*.png"):
        if candidate.name not in keep:
            candidate.unlink()


def build_report(manifest: dict) -> None:
    report = f"""# METANO KINGAMBIT BUILDING SCALE REPORT

## Scope

Single-building recovery task requested by the user: scale `QGKingambit-removebg-preview.png` to a Metano Town / PMDO-compatible size using the canonical café building as reference.

## Authoritative references

- `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png`
- `docs/metano_origins_structure_library/buildings/metano_cafe_day.png`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/references/QGKingambit-removebg-preview.png`

## Method

1. The external Kingambit source was preserved as RGBA and trimmed only on fully transparent margins.
2. The existing PMDO café extraction was used as the canonical Metano building-scale reference.
3. Opaque-pixel area was measured for both assets.
4. The café-derived target scale was computed as `sqrt(cafe_opaque / kingambit_opaque)`.
5. The practical deterministic scale chosen was **40% nearest-neighbor** (`-filter point -resize 40%`).
6. No recolor, no repaint, no smoothing, no interpolation, no alpha baking.

## Metrics

- Café reference size: {manifest['reference_cafe']['width']}×{manifest['reference_cafe']['height']}
- Café opaque pixels: {manifest['reference_cafe']['opaque_pixels']}
- Kingambit master trimmed size: {manifest['master']['width']}×{manifest['master']['height']}
- Kingambit master opaque pixels: {manifest['master']['opaque_pixels']}
- Café-derived target scale: {manifest['method']['cafe_derived_target_scale']:.9f}
- Chosen deterministic scale: {manifest['method']['chosen_scale']:.2%}
- Output size: {manifest['pmdo']['width']}×{manifest['pmdo']['height']}
- Output opaque pixels: {manifest['pmdo']['opaque_pixels']}

## Validation

- Output format: {manifest['pmdo']['format']}
- Output channels: {manifest['pmdo']['channels']}
- Output contains transparency: {manifest['pmdo']['opaque'] == 'false'}
- Output alpha isolation: {'PASS' if manifest['pmdo']['alpha_isolation'] else 'FAIL'}
- Interpolation used: {manifest['method']['interpolation_used']}
- Palette changed: {manifest['method']['palette_changed']}

## Deliverables

- Master trimmed asset: `{manifest['files']['master']}`
- PMDO scaled asset: `{manifest['files']['pmdo']}`
- Contact sheet: `{manifest['files']['contact_sheet']}`
- Validation sheet: `{manifest['files']['validation_sheet']}`
- Manifest: `{MANIFEST_OUT.relative_to(ROOT)}`

## SHA-256

- Master: `{manifest['master']['sha256']}`
- PMDO scaled output: `{manifest['pmdo']['sha256']}`
"""
    REPORT_OUT.write_text(report, encoding="utf-8")


if __name__ == "__main__":
    data = build_assets()
    print(
        "METANO_KINGAMBIT_PMDO_SCALE_BUILT",
        f"master={data['master']['width']}x{data['master']['height']}",
        f"pmdo={data['pmdo']['width']}x{data['pmdo']['height']}",
        f"scale={data['method']['chosen_scale']:.2%}",
        f"alpha={data['pmdo']['alpha_isolation']}",
    )
