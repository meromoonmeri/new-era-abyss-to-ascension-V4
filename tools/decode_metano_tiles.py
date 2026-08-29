#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""decode_metano_tiles.py — décode les fichiers .tile PMDO en PNG visualisable.

Format .tile PMDO 0.8.12:
  - uint32 tileSize           (8 pour ground)
  - uint32 tileCount          (nb de cellules dans la table d'indirection)
  - tileCount x (uint64 key, uint64 offset)
        key = x | (y << 32)
        offset = index dans la table de blobs uniques
  - N_unique x (int64 length, PNG bytes)

Usage:
    python3 tools/decode_metano_tiles.py --sheet Content/Tile/Metano_Town_Base.tile
    python3 tools/decode_metano_tiles.py --all  # décode tous les Metano_*.tile
"""
import argparse
import struct
from pathlib import Path
from PIL import Image
import io

ROOT = Path(__file__).resolve().parents[1]
TILEDIR = ROOT / "Content" / "Tile"
OUTDIR = ROOT / ".runtime-cache" / "metano_atlases"


def decode_tile_sheet(path: Path) -> dict:
    """Décode un fichier .tile et retourne un dict {sheet_w, sheet_h, atlas, unique_count}.

    Format: uint32 tileSize, uint32 tileCount,
    puis tileCount x (uint64 key, uint64 byte_offset),
    puis N_blobs uniques à des byte_offsets distincts : int64 length + PNG bytes.

    Note: l'offset est un BYTE OFFSET dans le fichier, pas un index.
    """
    file_size = path.stat().st_size
    with open(path, "rb") as f:
        tileSize, tileCount = struct.unpack("<II", f.read(8))
        if tileSize != 8:
            print(f"  WARN: {path.name} tileSize={tileSize} (expected 8)")

        # Read indirection table
        indirection = []
        max_x = 0
        max_y = 0
        for _ in range(tileCount):
            key, byte_offset = struct.unpack("<QQ", f.read(16))
            cx = key & 0xFFFFFFFF
            cy = (key >> 32) & 0xFFFFFFFF
            indirection.append((cx, cy, byte_offset))
            if cx > max_x:
                max_x = cx
            if cy > max_y:
                max_y = cy

    return {
        "tileSize": tileSize,
        "tileCount": tileCount,
        "sheet_w_tiles": max_x + 1,
        "sheet_h_tiles": max_y + 1,
        "sheet_w_px": (max_x + 1) * tileSize,
        "sheet_h_px": (max_y + 1) * tileSize,
        "indirection": indirection,
        "file_size": file_size,
    }


def read_blob_at(f, byte_offset: int) -> bytes:
    """Lit un blob (int64 length + PNG bytes) à un byte_offset."""
    f.seek(byte_offset)
    length_bytes = f.read(8)
    if len(length_bytes) < 8:
        return b""
    length = struct.unpack("<q", length_bytes)[0]
    if length < 0 or length > 1_000_000:
        return b""
    return f.read(length)


def render_atlas(decoded: dict, source_path: Path) -> Image.Image:
    """Reconstruit l'image atlas (sheet) à partir des blobs uniques + indirection.

    Les PNG du .tile sont en alpha-premultiplied (format PMDO), on les décode tels quels.
    Les tuiles vides (alpha=0) sont stockées comme un PNG minimal 1x1 — on les saute.
    """
    tileSize = decoded["tileSize"]
    W = decoded["sheet_w_px"]
    H = decoded["sheet_h_px"]
    indirection = decoded["indirection"]

    atlas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    print(f"  Atlas: {W}x{H} px ({W//tileSize}x{H//tileSize} tiles)")
    print(f"  Indirection entries: {len(indirection)}")

    # Cache blobs by byte_offset to avoid re-reading the same tile
    blob_cache = {}

    with open(source_path, "rb") as f:
        empty_count = 0
        for cx, cy, byte_offset in indirection:
            if byte_offset in blob_cache:
                data = blob_cache[byte_offset]
            else:
                data = read_blob_at(f, byte_offset)
                blob_cache[byte_offset] = data
            if not data:
                empty_count += 1
                continue
            try:
                tile_img = Image.open(io.BytesIO(data))
                if tile_img.size != (tileSize, tileSize):
                    empty_count += 1
                    continue
                atlas.paste(tile_img, (cx * tileSize, cy * tileSize))
            except Exception as e:
                empty_count += 1
    if empty_count:
        print(f"  Skipped {empty_count} empty/short tiles")
    print(f"  Unique blobs (cached): {len(blob_cache)}")
    return atlas


def decode_all(prefix: str = "Metano_"):
    """Décode tous les fichiers Metano_*.tile et sauvegarde en PNG."""
    OUTDIR.mkdir(parents=True, exist_ok=True)
    tiles = sorted(TILEDIR.glob(f"{prefix}*.tile"))
    print(f"Found {len(tiles)} {prefix}*.tile files\n")
    results = []
    for path in tiles:
        print(f"[{path.name}]")
        try:
            decoded = decode_tile_sheet(path)
        except Exception as e:
            print(f"  ERROR: {e}\n")
            continue
        atlas = render_atlas(decoded, path)
        out_path = OUTDIR / f"{path.stem}.png"
        atlas.save(out_path)
        sz = out_path.stat().st_size
        print(f"  -> {out_path.relative_to(ROOT)} ({sz/1024:.0f} KB)\n")
        results.append({
            "name": path.stem,
            "px": f"{decoded['sheet_w_px']}x{decoded['sheet_h_px']}",
            "tiles": f"{decoded['sheet_w_tiles']}x{decoded['sheet_h_tiles']}",
            "indir": decoded["tileCount"],
            "out_size_kb": sz // 1024,
        })
    return results


def main():
    parser = argparse.ArgumentParser(description="Decode PMDO .tile files to PNG atlases")
    parser.add_argument("--all", action="store_true", help="Decode all Metano_*.tile files")
    parser.add_argument("--sheet", type=Path, help="Decode a single .tile file")
    parser.add_argument("--prefix", default="Metano_", help="Filter prefix (default: Metano_)")
    args = parser.parse_args()

    if args.sheet:
        OUTDIR.mkdir(parents=True, exist_ok=True)
        decoded = decode_tile_sheet(args.sheet)
        atlas = render_atlas(decoded, args.sheet)
        out = OUTDIR / f"{args.sheet.stem}.png"
        atlas.save(out)
        print(f"-> {out}")
    elif args.all:
        results = decode_all(args.prefix)
        print("=" * 80)
        print(f"{'Tile sheet':<48} {'Sheet (tiles)':<14} {'Indir':<8} {'PNG size':<10}")
        print("=" * 80)
        for r in results:
            print(f"{r['name']:<48} {r['tiles']:<14} {r['indir']:<8} {r['out_size_kb']:<5} KB")
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
