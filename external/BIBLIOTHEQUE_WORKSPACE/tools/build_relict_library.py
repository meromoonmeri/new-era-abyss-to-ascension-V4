#!/usr/bin/env python3
"""Rebuild the complete qualified Relict source library deterministically."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import extract_relict_autotile_animations as animations
import extract_relict_environmental_vfx as vfx
import inventory_relict as inventory
import render_relict_previews as previews


def finalize_hashes(output: Path) -> int:
    path = output / "manifests/generated_hashes.sha256"
    rows = []
    for item in sorted(output.rglob("*")):
        if item.is_file() and item != path:
            rows.append(f"{inventory.sha256_file(item)}  {inventory.relpath(item, output)}")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(rows) + "\n", encoding="utf-8")
    return len(rows)


def build(source: Path, output: Path) -> dict:
    source = source.resolve()
    output = output.resolve()
    source_summary = inventory.build(source, output)
    animation_summary = animations.build(source, output)
    vfx_summary = vfx.build(source, output)
    preview_summary = previews.build(source, output)
    result = {
        "schema_version": "1.0.0",
        "result": "RELICT_SOURCE_LIBRARY_PASS",
        "inventory": {
            key: value for key, value in source_summary.items() if key != "zone_ids"
        },
        "animations": {
            key: value for key, value in animation_summary.items() if key != "animations"
        },
        "vfx": {
            key: value for key, value in vfx_summary.items()
            if key not in ("timelines", "environment_assets", "excluded_assets", "review_queue")
        },
        "previews": {
            key: value for key, value in preview_summary.items()
            if key not in ("previews", "tileset_references")
        },
        "pmdo_conversion_started": False,
    }
    inventory.write_json(output / "reports/pipeline.json", result)
    result["hashed_output_count"] = finalize_hashes(output)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=inventory.DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=inventory.DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = build(args.source, args.output)
    print(json.dumps(result, ensure_ascii=False, sort_keys=True))
    success = (
        result["inventory"]["result"] == "SOURCE_INVENTORY_PASS"
        and result["animations"]["result"] == "AUTOTILE_FRAME_EXTRACTION_PASS"
        and result["vfx"]["result"] == "ENVIRONMENTAL_VFX_AUDIT_PASS"
        and result["previews"]["result"] == "PREVIEW_RENDER_PASS"
    )
    return 0 if success else 1


if __name__ == "__main__":
    raise SystemExit(main())
