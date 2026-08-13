#!/usr/bin/env python3
"""Export every used animated Relict autotile as separate source frames."""

from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path
from typing import Any

from inventory_relict import DEFAULT_OUTPUT, DEFAULT_SOURCE, sha256_file, slug, write_json
from png_rgba import RGBAImage, load_png, save_png


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def frame_layout(image: RGBAImage) -> tuple[int, int, int, str] | None:
    if image.height == 128 and image.width % 96 == 0:
        return image.width // 96, 96, 128, "RMXP_AUTOTILE_96x128_HORIZONTAL_FRAMES"
    if image.height == 32 and image.width % 32 == 0:
        return image.width // 32, 32, 32, "CUSTOM_SINGLE_TILE_32x32_HORIZONTAL_FRAMES"
    return None


def build(source: Path, inventory_root: Path) -> dict[str, Any]:
    source = source.resolve()
    inventory_root = inventory_root.resolve()
    output = inventory_root / "animations"
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    records = []
    static_count = unsupported_count = 0
    for asset_path in sorted((inventory_root / "metadata/assets").glob("*.json")):
        asset = load_json(asset_path)
        if asset["kind"] != "AUTOTILE":
            continue
        source_path = source / asset["provenance"]["source_path"].removeprefix(
            "Relict/Relict V1.2/Relict/"
        )
        image = load_png(source_path)
        layout = frame_layout(image)
        if layout is None:
            unsupported_count += 1
            continue
        count, frame_width, frame_height, layout_name = layout
        if count <= 1:
            static_count += 1
            continue
        animation_id = f"relict_autotile_{slug(source_path.stem)}_{asset['provenance']['sha256'][:12]}"
        destination = output / "autotiles" / animation_id
        frames = []
        contact = RGBAImage.empty(frame_width * count, frame_height)
        for index in range(count):
            frame = image.crop(index * frame_width, 0, frame_width, frame_height)
            frame_path = destination / "layers/layer_00" / f"frame_{index:03d}.png"
            save_png(frame, frame_path)
            contact.blit_replace(frame, index * frame_width, 0)
            frames.append({
                "index": index,
                "file": frame_path.relative_to(destination).as_posix(),
                "duration_ms": None,
                "sha256": sha256_file(frame_path),
            })
        contact_path = destination / "contact_sheet.png"
        save_png(contact, contact_path)
        metadata = {
            "schema_version": "1.0.0",
            "animation_id": animation_id,
            "game_id": "relict",
            "status": "ADAPTATION_REQUIRED",
            "frame_count": count,
            "loop": True,
            "loop_start": 0,
            "timing_authority": "RGSS1_DEFAULT_UNVALIDATED",
            "source_frame_layout": layout_name,
            "layers": [{
                "layer_id": "layer_00",
                "order": 0,
                "blend_mode": "SOURCE_ALPHA",
                "frames": frames,
            }],
            "contexts": [
                {"zone_id": zone_id, "usage": "AUTOTILE_SLOT"}
                for zone_id in asset.get("used_by_zones", [])
            ],
            "dependencies": [],
            "pmdo_dtef_candidate": layout_name.startswith("RMXP_AUTOTILE"),
            "provenance": asset["provenance"],
            "contact_sheet": {
                "file": contact_path.relative_to(destination).as_posix(),
                "sha256": sha256_file(contact_path),
                "width_px": contact.width,
                "height_px": contact.height,
            },
        }
        metadata_path = destination / "metadata.json"
        write_json(metadata_path, metadata)
        records.append({
            "animation_id": animation_id,
            "metadata": metadata_path.relative_to(inventory_root).as_posix(),
            "metadata_sha256": sha256_file(metadata_path),
            "frame_count": count,
            "layout": layout_name,
            "timing_status": "REQUIRES_SOURCE_AUDIT",
        })
    manifest = {
        "schema_version": "1.0.0",
        "result": "AUTOTILE_FRAME_EXTRACTION_PASS",
        "animated_autotile_count": len(records),
        "static_autotile_count": static_count,
        "unsupported_autotile_count": unsupported_count,
        "timing_exact_count": 0,
        "timing_audit_required_count": len(records),
        "animations": records,
    }
    write_json(output / "manifest.json", manifest)
    (output / "README.md").write_text(
        "# Animations autotile Relict\n\n"
        "Chaque frame source est exportée séparément, sans aplatir les couches. "
        "Le format image permet de déterminer l'ordre et la boucle, mais pas une "
        "durée exacte indépendante des scripts : les timings restent donc "
        "`ADAPTATION_REQUIRED` jusqu'à audit statique ciblé.\n",
        encoding="utf-8",
    )
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--inventory-root", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    result = build(args.source, args.inventory_root)
    print(json.dumps({key: value for key, value in result.items() if key != "animations"}, sort_keys=True))
    return 0 if result["unsupported_autotile_count"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
