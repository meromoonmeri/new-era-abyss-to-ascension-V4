#!/usr/bin/env python3
"""Import a RawAsset DTEF folder using RogueEssence's reference mapping.

This is a line-for-line semantic port of
``RogueEssence.Dev.DtefImportHelper`` (DTEF field order, sheet coordinates,
frame ordering and AutoTileAdjacent field names).  It exists because the PMDO
editor executable is not available in this workspace; it is deliberately not a
new, guessed tile converter.

It writes a private ``canon_<folder>`` namespace, avoiding accidental mutation
of PMDO base AutoTiles.

Usage:
    python3 tools/import_rawasset_dtef.py Content/TileDtef/sinister_woods/TreeshroudForest1 --id canon_treeshroud
"""
from __future__ import annotations

import argparse
import base64
import hashlib
import io
import json
import re
import struct
import subprocess
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

try:
    from PIL import Image
except ImportError as exc:  # pragma: no cover - user-facing dependency check
    raise SystemExit("Pillow is required. Install it in the project's DTEF tool environment.") from exc

ROOT = Path(__file__).resolve().parents[1]

# Exact order in RogueEssence.Dev.DtefImportHelper.FieldDtefMapping.
FIELD_DTEF_MAPPING = (
    0x89, 0x9B, 0x13, 0x09, 0x0A, 0x03,
    0xCD, 0xFF, 0x37, 0x05, 0x00, 0x06,
    0x4C, 0x6E, 0x26, 0x0C, 0x01, -1,
    0x3F, 0xCF, 0x0B, 0x08, 0x0F, 0x02,
    0x9F, 0x6F, 0x0E, 0x0D, 0x04, 0x07,
    0x7F, 0xEF, 0x4D, 0x27, 0x1B, 0x8B,
    0xBF, 0xDF, 0x8D, 0x17, 0x2E, 0x4E,
    0x8F, 0x1F, 0x4F, 0x2F, 0x5F, 0xAF,
)
CODES = tuple(dict.fromkeys(code for code in FIELD_DTEF_MAPPING if code >= 0))
TITLES = ("Wall", "Secondary", "Floor")
FRAME_RE = re.compile(r"tileset_(?P<variant>[012])_frame(?P<layer>\d+)_(?P<frame>\d+)\.(?P<duration>\d+)\.png$")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def image_blank(image: Image.Image) -> bool:
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    return image.getbbox() is None


def png_bytes(image: Image.Image) -> bytes:
    out = io.BytesIO()
    image.save(out, format="PNG", optimize=True)
    return out.getvalue()


def write_tile(path: Path, entries: dict[tuple[int, int], Image.Image], tile_size: int) -> None:
    """Write the native RogueEssence .tile format used by ImportHelper."""
    ordered = sorted(entries.items(), key=lambda pair: (pair[0][1], pair[0][0]))
    encoded = [(coord, png_bytes(image.convert("RGBA"))) for coord, image in ordered]
    offsets: dict[bytes, int] = {}
    blobs: list[bytes] = []
    cursor = 8 + len(encoded) * 16
    for _, payload in encoded:
        if payload not in offsets:
            offsets[payload] = cursor
            blobs.append(payload)
            cursor += 8 + len(payload)
    raw = bytearray(struct.pack("<II", tile_size, len(encoded)))
    for (x, y), payload in encoded:
        raw.extend(struct.pack("<QQ", x | (y << 32), offsets[payload]))
    for payload in blobs:
        raw.extend(struct.pack("<q", len(payload)))
        raw.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(raw)


def tile_layer(frames: list[dict[str, Any]], frame_length: int) -> dict[str, Any]:
    return {"Frames": frames, "FrameLength": frame_length}


def frame(sheet: str, x: int, y: int) -> dict[str, Any]:
    return {"Sheet": sheet, "TexLoc": {"X": x, "Y": y}}


def load_variants(folder: Path) -> tuple[int, int, list[dict[str, Any]], dict[tuple[int, int], Image.Image]]:
    variants: list[dict[str, Any]] = []
    entries: dict[tuple[int, int], Image.Image] = {}
    tile_size = -1
    tile_types = -1
    for variant in range(3):
        base_path = folder / f"tileset_{variant}.png"
        if not base_path.is_file():
            if variant == 0:
                raise ValueError(f"{folder}: tileset_0.png is required")
            continue
        base = Image.open(base_path).convert("RGBA")
        current_tile_size = base.height // 8
        if base.height % 8:
            raise ValueError(f"{base_path}: height must be divisible by 8")
        current_types = base.width // current_tile_size // 6
        if base.width % (current_tile_size * 6):
            raise ValueError(f"{base_path}: invalid DTEF width")
        if tile_size > 0 and current_tile_size != tile_size:
            raise ValueError(f"{folder}: inconsistent tile sizes")
        if tile_types > 0 and current_types != tile_types:
            raise ValueError(f"{folder}: inconsistent tile type count")
        tile_size, tile_types = current_tile_size, current_types

        layers: dict[int, list[tuple[int, int, Path]]] = defaultdict(list)
        for path in folder.glob(f"tileset_{variant}_frame*_*.png"):
            match = FRAME_RE.match(path.name)
            if not match:
                continue
            layers[int(match.group("layer"))].append((int(match.group("frame")), int(match.group("duration")), path))
        ordered_layers = []
        for layer_index in sorted(layers):
            frames = sorted(layers[layer_index])
            expected = list(range(len(frames)))
            if [row[0] for row in frames] != expected:
                raise ValueError(f"{folder}: DTEF frame indexes must be contiguous for layer {layer_index}")
            duration = frames[0][1]
            if any(row[1] != duration for row in frames):
                raise ValueError(f"{folder}: mixed durations in layer {layer_index}")
            ordered_layers.append((duration, [Image.open(row[2]).convert("RGBA") for row in frames]))

        images = [base] + [image for _, frames in ordered_layers for image in frames]
        # ImportHelper.SaveTileSheet stores each variant in a horizontal block;
        # animation images are stacked in 8-row bands, exactly as the C# frame
        # references below expect.
        for image_index, image in enumerate(images):
            if image.size != base.size:
                raise ValueError(f"{folder}: animation image dimensions differ from base")
            for y in range(base.height // tile_size):
                for x in range(base.width // tile_size):
                    output_x = x + len(variants) * (6 * tile_types)
                    output_y = y if image_index == 0 else y + image_index * 8
                    entries[(output_x, output_y)] = image.crop((x * tile_size, y * tile_size, (x + 1) * tile_size, (y + 1) * tile_size))
        variants.append({"base": base, "layers": ordered_layers})
    return tile_size, tile_types, variants, entries


def make_autotile(sheet: str, title: str, tile_type: int, tile_types: int, variants: list[dict[str, Any]], tile_size: int, identifier: str) -> dict[str, Any]:
    tiles: dict[str, Any] = {f"Tilex{code:02X}": [] for code in CODES}
    for dtef_index, code in enumerate(FIELD_DTEF_MAPPING):
        if code < 0:
            continue
        target = tiles[f"Tilex{code:02X}"]
        for variant_index, info in enumerate(variants):
            tile_x = 6 * tile_type + dtef_index % 6
            tile_y = dtef_index // 6
            layers: list[dict[str, Any]] = []
            base_crop = info["base"].crop((tile_x * tile_size, tile_y * tile_size, (tile_x + 1) * tile_size, (tile_y + 1) * tile_size))
            if not image_blank(base_crop):
                layers.append(tile_layer([frame(sheet, tile_x + variant_index * 6 * tile_types, tile_y)], 999))
            image_offset = 1
            for duration, layer_frames in info["layers"]:
                anim_frames: list[dict[str, Any]] = []
                for _frame_index, image in enumerate(layer_frames):
                    crop = image.crop((tile_x * tile_size, tile_y * tile_size, (tile_x + 1) * tile_size, (tile_y + 1) * tile_size))
                    if not image_blank(crop):
                        anim_frames.append(frame(sheet, tile_x + variant_index * 6 * tile_types, tile_y + image_offset * 8))
                    image_offset += 1
                if anim_frames:
                    layers.append(tile_layer(anim_frames, duration))
            if layers:
                target.append(layers)
    return {
        "$type": "RogueEssence.Data.AutoTileData, RogueEssence",
        "Name": {"DefaultText": f"{sheet} {title}", "LocalTexts": {}},
        "Comment": "Imported from RawAsset DTEF through the RogueEssence DtefImportHelper reference mapping.",
        "Tiles": {"$type": "RogueEssence.Dungeon.AutoTileAdjacent, RogueEssence", **tiles},
    }


def update_auto_index(identifier: str, payload: dict[str, Any]) -> None:
    path = ROOT / "Data/AutoTile/index.idx"
    data = read_json(path)
    data["Object"][identifier] = {
        "Name": payload["Name"],
        "Released": True,
        "Comment": payload["Comment"],
        "SortOrder": 0,
    }
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def rebuild_tile_index() -> None:
    subprocess.run([sys.executable, str(ROOT / "tools/rebuild_tile_index.py")], cwd=ROOT, check=True)


def import_folder(folder: Path, identifier: str, *, rebuild_index: bool = True) -> list[str]:
    tile_size, tile_types, variants, entries = load_variants(folder)
    sheet_id = identifier.removeprefix("canon_")
    sheet = "Canon" + "".join(part.capitalize() for part in re.split(r"[^A-Za-z0-9]+", sheet_id) if part)
    write_tile(ROOT / "Content/Tile" / f"{sheet}.tile", entries, tile_size)
    created = []
    for tile_type, title in enumerate(TITLES[:tile_types]):
        suffix = title.lower()
        auto_id = f"{identifier}_{suffix}"
        payload = make_autotile(sheet, title, tile_type, tile_types, variants, tile_size, auto_id)
        (ROOT / "Data/AutoTile" / f"{auto_id}.json").write_text("\ufeff" + json.dumps({"Version": "0.8.12.0", "Object": payload}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        update_auto_index(auto_id, payload)
        created.append(auto_id)
    if rebuild_index:
        rebuild_tile_index()
    return created


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("folder", type=Path)
    parser.add_argument("--id", required=True, help="private AutoTile id prefix, e.g. canon_treeshroud")
    parser.add_argument("--no-rebuild-index", action="store_true", help="batch mode: rebuild Content/Tile/index.idx once after several imports")
    args = parser.parse_args()
    folder = args.folder if args.folder.is_absolute() else ROOT / args.folder
    if not folder.is_dir():
        parser.error(f"DTEF folder missing: {folder}")
    created = import_folder(folder, args.id, rebuild_index=not args.no_rebuild_index)
    print(json.dumps({"folder": str(folder.relative_to(ROOT)), "autotiles": created}, ensure_ascii=False))


if __name__ == "__main__":
    main()
