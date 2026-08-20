#!/usr/bin/env python3
"""Build the exact PMD Red EU efob108 animation-2 PMDO particle.

The content authority is the authenticated EU ROM.  The pinned pret source is
used only to decode the ROM-derived efob108 OAM poses, animation cadence, tile
sheet, and palette.  Output is create-only by default.
"""
from __future__ import annotations

import argparse
import binascii
import hashlib
import json
import re
import struct
import zlib
from pathlib import Path

TOOL_VERSION = "1.0.0"
SOURCE_C_SHA256 = "a17085e185a6ac3930d06e9160bb44f25ac65d2e85d10cc2df4b38c0d71be2fe"
SOURCE_PNG_SHA256 = "c3eab405ea3c819e49161272cfbd2ba5593cd2965985c69ab360d8af992ce282"
PREVIEW_SHA256 = "1a385ca7390717a3338f127426afd948cadcd60d3630417bf0c558fe67a9406b"
POSES = [138, 139, 140, 141, 142, 143, 144, 145, 141, 142, 146, 147, 148]
UNIQUE_POSES = list(range(138, 149))
FRAME_TICKS = [2] * len(POSES)
CANVAS = 128
ANCHOR = 64


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def png_chunks(data: bytes):
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("not a PNG")
    pos = 8
    while pos < len(data):
        length = struct.unpack(">I", data[pos:pos + 4])[0]
        kind = data[pos + 4:pos + 8]
        payload = data[pos + 8:pos + 8 + length]
        crc = struct.unpack(">I", data[pos + 8 + length:pos + 12 + length])[0]
        if (binascii.crc32(kind + payload) & 0xFFFFFFFF) != crc:
            raise ValueError(f"bad PNG CRC for {kind!r}")
        yield kind, payload
        pos += 12 + length


def read_indexed_png(data: bytes):
    width = height = bit_depth = color_type = None
    palette = None
    packed = bytearray()
    for kind, payload in png_chunks(data):
        if kind == b"IHDR":
            width, height, bit_depth, color_type, comp, filt, interlace = struct.unpack(">IIBBBBB", payload)
            if color_type != 3 or bit_depth not in (4, 8) or (comp, filt, interlace) != (0, 0, 0):
                raise ValueError("source PNG must be non-interlaced 4/8-bit indexed")
        elif kind == b"PLTE":
            palette = [tuple(payload[i:i + 3]) for i in range(0, len(payload), 3)]
        elif kind == b"IDAT":
            packed.extend(payload)
    if width is None or palette is None:
        raise ValueError("incomplete indexed PNG")
    raw = zlib.decompress(bytes(packed))
    packed_stride = (width * bit_depth + 7) // 8
    rows = []
    prior = bytearray(packed_stride)
    pos = 0
    for _ in range(height):
        filter_type = raw[pos]
        scan = bytearray(raw[pos + 1:pos + 1 + packed_stride])
        pos += packed_stride + 1
        for x in range(packed_stride):
            left = scan[x - 1] if x else 0
            up = prior[x]
            up_left = prior[x - 1] if x else 0
            if filter_type == 1:
                scan[x] = (scan[x] + left) & 255
            elif filter_type == 2:
                scan[x] = (scan[x] + up) & 255
            elif filter_type == 3:
                scan[x] = (scan[x] + ((left + up) // 2)) & 255
            elif filter_type == 4:
                p = left + up - up_left
                pa, pb, pc = abs(p - left), abs(p - up), abs(p - up_left)
                pred = left if pa <= pb and pa <= pc else up if pb <= pc else up_left
                scan[x] = (scan[x] + pred) & 255
            elif filter_type != 0:
                raise ValueError(f"unsupported PNG filter {filter_type}")
        if bit_depth == 8:
            rows.append(bytes(scan))
        else:
            rows.append(bytes(value for packed_byte in scan for value in (packed_byte >> 4, packed_byte & 15))[:width])
        prior = scan
    return width, height, palette, rows


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", binascii.crc32(kind + payload) & 0xFFFFFFFF)


def write_rgba_png(width: int, height: int, pixels: bytes) -> bytes:
    if len(pixels) != width * height * 4:
        raise ValueError("invalid RGBA buffer")
    rows = b"".join(b"\0" + pixels[y * width * 4:(y + 1) * width * 4] for y in range(height))
    return (b"\x89PNG\r\n\x1a\n" +
            png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)) +
            png_chunk(b"IDAT", zlib.compress(rows, 9)) + png_chunk(b"IEND", b""))


def parse_poses(source: str):
    pose_re = re.compile(r"const ax_pose\s+(\w+)\[\]\s*=\s*\{(.*?)\n\};", re.S)
    item_re = re.compile(r"\{\s*-1,\s*\{\s*0,\s*0\s*\},\s*(\d+),\s*(\d+),\s*(\d+)\s*\}")
    poses = []
    for _, body in pose_re.findall(source):
        poses.append([tuple(map(int, match)) for match in item_re.findall(body)])
    if len(poses) <= max(UNIQUE_POSES):
        raise ValueError(f"only {len(poses)} OAM poses parsed")
    return poses


def dimensions(attr0: int, attr1: int):
    shape = (attr0 >> 14) & 3
    size = (attr1 >> 14) & 3
    table = {
        0: [(8, 8), (16, 16), (32, 32), (64, 64)],
        1: [(16, 8), (32, 8), (32, 16), (64, 32)],
        2: [(8, 16), (8, 32), (16, 32), (32, 64)],
    }
    if shape not in table:
        raise ValueError("prohibited GBA OBJ shape")
    return table[shape][size]


def render_pose(items, palette, tile_rows):
    canvas = bytearray(CANVAS * CANVAS * 4)
    # Lower OAM indices have display priority, so composite the source list back-to-front.
    for attr0, attr1, attr2 in reversed(items):
        width, height = dimensions(attr0, attr1)
        x0 = ANCHOR + ((attr1 & 0x1FF) - 256)
        y0 = ANCHOR + ((attr0 & 0xFF) - 256)
        hflip = bool(attr1 & 0x1000)
        vflip = bool(attr1 & 0x2000)
        tile0 = attr2 & 0x3FF
        for py in range(height):
            src_y = height - 1 - py if vflip else py
            for px in range(width):
                src_x = width - 1 - px if hflip else px
                tile = tile0 + (src_y // 8) * (width // 8) + src_x // 8
                if tile * 8 + src_y % 8 >= len(tile_rows):
                    raise ValueError(f"tile {tile} outside efob108 sheet")
                index = tile_rows[tile * 8 + src_y % 8][src_x % 8]
                if index == 0:
                    continue
                dx, dy = x0 + px, y0 + py
                if 0 <= dx < CANVAS and 0 <= dy < CANVAS:
                    r, g, b = palette[index]
                    out = (dy * CANVAS + dx) * 4
                    canvas[out:out + 4] = bytes((r, g, b, 255))
    return bytes(canvas)


def read_rgba_png(data: bytes):
    width = height = None
    packed = bytearray()
    for kind, payload in png_chunks(data):
        if kind == b"IHDR":
            width, height, depth, color, comp, filt, interlace = struct.unpack(">IIBBBBB", payload)
            if (depth, color, comp, filt, interlace) != (8, 6, 0, 0, 0):
                raise ValueError("preview PNG format mismatch")
        elif kind == b"IDAT":
            packed.extend(payload)
    raw = zlib.decompress(bytes(packed)); stride = width * 4; rows = []; prior = bytearray(stride); pos = 0
    for _ in range(height):
        ft = raw[pos]; scan = bytearray(raw[pos + 1:pos + 1 + stride]); pos += stride + 1
        for x in range(stride):
            left = scan[x - 4] if x >= 4 else 0; up = prior[x]; ul = prior[x - 4] if x >= 4 else 0
            if ft == 1: scan[x] = (scan[x] + left) & 255
            elif ft == 2: scan[x] = (scan[x] + up) & 255
            elif ft == 3: scan[x] = (scan[x] + ((left + up) // 2)) & 255
            elif ft == 4:
                p = left + up - ul; pa, pb, pc = abs(p-left), abs(p-up), abs(p-ul)
                scan[x] = (scan[x] + (left if pa <= pb and pa <= pc else up if pb <= pc else ul)) & 255
            elif ft != 0: raise ValueError(f"unsupported preview filter {ft}")
        rows.append(bytes(scan)); prior = scan
    return width, height, b"".join(rows)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--reference-root", type=Path, default=Path(".runtime-cache/pmd-red-reference"))
    ap.add_argument("--preview", type=Path, default=Path(".runtime-cache/efob108_anim2.png"))
    ap.add_argument("--output", type=Path, default=Path("Content/Particle/PMDRed_Efob108.dir"))
    ap.add_argument("--manifest", type=Path, default=Path("docs/pmdred_eu/playable/tiny_woods/efob108_particle_manifest.json"))
    ap.add_argument("--verify-existing", action="store_true")
    args = ap.parse_args()
    c_path = args.reference_root / "src/data/effects/efob108.c"
    png_path = args.reference_root / "data/effects/efob108.png"
    c_data, source_png = c_path.read_bytes(), png_path.read_bytes()
    if sha256(c_data) != SOURCE_C_SHA256 or sha256(source_png) != SOURCE_PNG_SHA256:
        raise SystemExit("authenticated efob108 technical-source pin mismatch")
    width, height, palette, tile_rows = read_indexed_png(source_png)
    if (width, height) != (8, 968) or len(tile_rows) != 121 * 8:
        raise SystemExit("efob108 source tile-sheet geometry mismatch")
    poses = parse_poses(c_data.decode("utf-8"))
    unique = [render_pose(poses[index], palette, tile_rows) for index in UNIQUE_POSES]
    # Independently compare all 11 decoded poses against the authenticated-ROM preview render.
    preview_data = args.preview.read_bytes()
    if sha256(preview_data) != PREVIEW_SHA256:
        raise SystemExit("authenticated efob108 preview pin mismatch")
    pw, ph, preview = read_rgba_png(preview_data)
    if (pw, ph) != (CANVAS * len(UNIQUE_POSES), CANVAS):
        raise SystemExit("efob108 preview geometry mismatch")
    differences = 0
    background = preview[:4]
    for frame, rendered in enumerate(unique):
        for y in range(CANVAS):
            for x in range(CANVAS):
                got = rendered[(y * CANVAS + x) * 4:(y * CANVAS + x + 1) * 4]
                off = (y * pw + frame * CANVAS + x) * 4
                expected = preview[off:off + 4]
                if expected == background:
                    expected = b"\0\0\0\0"
                if got != expected:
                    differences += 1
    if differences:
        raise SystemExit(f"efob108 authenticated pose comparison failed: {differences} differing pixels")
    strip = bytearray(CANVAS * len(POSES) * CANVAS * 4)
    pose_to_frame = {pose: unique[pose - UNIQUE_POSES[0]] for pose in UNIQUE_POSES}
    strip_width = CANVAS * len(POSES)
    for frame_no, pose in enumerate(POSES):
        frame = pose_to_frame[pose]
        for y in range(CANVAS):
            src = y * CANVAS * 4
            dst = (y * strip_width + frame_no * CANVAS) * 4
            strip[dst:dst + CANVAS * 4] = frame[src:src + CANVAS * 4]
    output_png = write_rgba_png(strip_width, CANVAS, bytes(strip))
    dirs = struct.pack("<q", len(output_png)) + output_png + struct.pack("<iiii", CANVAS, CANVAS, 0, len(POSES))
    if args.output.exists():
        if not args.verify_existing:
            raise SystemExit(f"create-only output already exists: {args.output}")
        if args.output.read_bytes() != dirs:
            raise SystemExit("existing PMDRed_Efob108.dir differs from deterministic build")
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_bytes(dirs)
    manifest = {
        "schema": "pmdred-eu-efob108-particle-v1",
        "tool": {"path": "tools/build_pmdred_efob108_particle.py", "version": TOOL_VERSION},
        "authority": {"game": "Pokemon Mystery Dungeon Red Rescue Team EU", "rule": "EU ROM bytes are content authority"},
        "technical_source": {
            "repository": "pret/pmd-red", "commit": "bf0092d0e34fd8e49b859a0b5f96f00740faa42d",
            "c_path": str(c_path), "c_sha256": SOURCE_C_SHA256,
            "tile_sheet_path": str(png_path), "tile_sheet_sha256": SOURCE_PNG_SHA256,
            "authenticated_preview_path": str(args.preview), "authenticated_preview_sha256": PREVIEW_SHA256,
        },
        "animation": {"red_animation": 2, "poses": POSES, "frame_ticks": FRAME_TICKS, "duration_frames": sum(FRAME_TICKS), "cycles": 1},
        "render": {"canvas": [CANVAS, CANVAS], "anchor": [ANCHOR, ANCHOR], "transparent_palette_index": 0, "authenticated_pixel_differences": differences},
        "dir_sheet": {"path": str(args.output), "png_size": len(output_png), "tile_width": CANVAS, "tile_height": CANVAS, "rotate_type": 0, "total_frames": len(POSES), "sha256": sha256(dirs), "size": len(dirs)},
        "validation": "PASS",
    }
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    if args.manifest.exists() and not args.verify_existing:
        raise SystemExit(f"create-only manifest already exists: {args.manifest}")
    encoded = json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n"
    if args.manifest.exists() and args.manifest.read_text("utf-8") != encoded:
        raise SystemExit("existing efob108 manifest differs from deterministic build")
    args.manifest.write_text(encoded, encoding="utf-8")
    print(f"PMDRED_EFOB108_PARTICLE_PASS frames={len(POSES)} duration={sum(FRAME_TICKS)} sha256={sha256(dirs)}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
