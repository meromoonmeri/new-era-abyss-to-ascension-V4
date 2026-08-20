#!/usr/bin/env python3
"""Render any PMD Red EU M4A song through a fresh exact-gated process.

The first renderer process is disposable and discovers synchronized loop
boundaries.  A second process starts from a clean M4A state and must reproduce
those exact boundaries before its output can be promoted.  The final Ogg is
then parsed directly; static file creation is never presented as PMDO-native
certification.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

EXPECTED_ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
EXPECTED_M4PLAY_COMMIT = "e16a7964acdd8ef5aff10a0e729c9618d3da0e75"
EXPECTED_OGG_COMMIT = "e1774cd77f471443541596e09078e78fdc342e4f"
EXPECTED_VORBIS_COMMIT = "0657aee69dec8508a0011f47f3b69d7538e9d262"
SAMPLE_RATE = 48_000
M4PLAY_SOURCES = (
    "src/cgb_audio.c", "src/m4a.c", "src/m4a_tables.c",
    "src/music_player.c", "src/sound_mixer.c",
)
VORBIS_SOURCES = (
    "mdct.c", "smallft.c", "block.c", "envelope.c", "window.c", "lsp.c",
    "lpc.c", "analysis.c", "synthesis.c", "psy.c", "info.c", "floor1.c",
    "floor0.c", "res0.c", "mapping0.c", "registry.c", "codebook.c",
    "sharedbook.c", "lookup.c", "bitrate.c", "vorbisenc.c",
)
LOOP_RE = re.compile(r"samples=(\d+) loop_start=(\d+) loop_length=(\d+)")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_head(path: Path) -> str:
    return subprocess.check_output(
        ["git", "-C", str(path), "rev-parse", "HEAD"], text=True
    ).strip()


def require_identity(path: Path, expected: str, label: str) -> None:
    actual = git_head(path)
    if actual != expected:
        raise RuntimeError(f"{label} checkout mismatch: expected {expected}, got {actual}")


def parse_ogg(path: Path) -> tuple[int, dict[str, str]]:
    data = path.read_bytes()
    offset = 0
    packets: list[bytes] = []
    partial = bytearray()
    final_granule = -1
    serial = None
    while offset < len(data):
        if data[offset:offset + 4] != b"OggS" or offset + 27 > len(data):
            raise RuntimeError(f"invalid Ogg page at byte {offset}")
        page_segments = data[offset + 26]
        header_end = offset + 27 + page_segments
        if header_end > len(data):
            raise RuntimeError("truncated Ogg segment table")
        lacing = data[offset + 27:header_end]
        body_end = header_end + sum(lacing)
        if body_end > len(data):
            raise RuntimeError("truncated Ogg page body")
        page_serial = struct.unpack_from("<I", data, offset + 14)[0]
        if serial is None:
            serial = page_serial
        elif serial != page_serial:
            raise RuntimeError("unexpected chained Ogg stream")
        granule = struct.unpack_from("<Q", data, offset + 6)[0]
        if granule != 0xFFFFFFFFFFFFFFFF:
            final_granule = granule
        cursor = header_end
        for size in lacing:
            partial.extend(data[cursor:cursor + size])
            cursor += size
            if size < 255:
                packets.append(bytes(partial))
                partial.clear()
        offset = body_end
    if offset != len(data) or partial:
        raise RuntimeError("incomplete Ogg stream")
    if len(packets) < 3 or not packets[1].startswith(b"\x03vorbis"):
        raise RuntimeError("missing Vorbis comment packet")

    packet = packets[1]
    cursor = 7
    vendor_len = struct.unpack_from("<I", packet, cursor)[0]
    cursor += 4 + vendor_len
    count = struct.unpack_from("<I", packet, cursor)[0]
    cursor += 4
    comments: dict[str, str] = {}
    for _ in range(count):
        size = struct.unpack_from("<I", packet, cursor)[0]
        cursor += 4
        entry = packet[cursor:cursor + size].decode("utf-8")
        cursor += size
        if "=" not in entry:
            raise RuntimeError("malformed Vorbis comment")
        key, value = entry.split("=", 1)
        comments[key] = value
    return final_granule, comments


def build_renderer(
    compiler: str,
    source: Path,
    m4play: Path,
    ogg: Path,
    vorbis: Path,
    build: Path,
) -> Path:
    include = build / "include" / "ogg"
    include.mkdir(parents=True)
    (include / "config_types.h").write_text(
        """#ifndef __CONFIG_TYPES_H__
#define __CONFIG_TYPES_H__
#include <stdint.h>
typedef int16_t ogg_int16_t;
typedef uint16_t ogg_uint16_t;
typedef int32_t ogg_int32_t;
typedef uint32_t ogg_uint32_t;
typedef int64_t ogg_int64_t;
typedef uint64_t ogg_uint64_t;
#endif
""",
        encoding="ascii",
    )
    executable = build / "pmdred_m4a_to_ogg_general"
    command = [
        compiler, "-O2", "-w", "-include", "stdlib.h",
        "-I", str(build / "include"), "-I", str(ogg / "include"),
        "-I", str(vorbis / "include"), "-I", str(vorbis / "lib"),
        "-I", str(m4play), "-I", str(m4play / "src"), str(source),
        str(ogg / "src/bitwise.c"), str(ogg / "src/framing.c"),
        *(str(vorbis / "lib" / item) for item in VORBIS_SOURCES),
        *(str(m4play / item) for item in M4PLAY_SOURCES),
        "-lm", "-o", str(executable),
    ]
    subprocess.run(command, check=True)
    return executable


def run_renderer(
    executable: Path,
    rom: Path,
    song_index: int,
    output: Path,
    title: str,
    loop_start: int,
    loop_length: int,
) -> tuple[int, int, int, str]:
    completed = subprocess.run(
        [
            executable, rom, str(song_index), output, EXPECTED_ROM_SHA256,
            title, str(loop_start), str(loop_length),
        ],
        check=True, text=True, capture_output=True,
    )
    match = LOOP_RE.search(completed.stdout)
    if not match:
        raise RuntimeError("renderer did not report samples and synchronized loop")
    samples, detected_start, detected_length = map(int, match.groups())
    return samples, detected_start, detected_length, completed.stdout.strip()


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom", type=Path, required=True)
    parser.add_argument("--song-index", type=int, required=True)
    parser.add_argument("--title", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--m4play-source", type=Path, default=root / ".runtime-cache/M4plAy-source")
    parser.add_argument("--ogg-source", type=Path, default=root / ".runtime-cache/libogg-source")
    parser.add_argument("--vorbis-source", type=Path, default=root / ".runtime-cache/libvorbis-source")
    parser.add_argument("--compiler", default="gcc")
    args = parser.parse_args()

    rom = args.rom.resolve()
    m4play = args.m4play_source.resolve()
    ogg = args.ogg_source.resolve()
    vorbis = args.vorbis_source.resolve()
    output = args.output.resolve()
    report = args.report.resolve() if args.report else None
    if output.exists() or (report is not None and report.exists()):
        raise FileExistsError("music promotion and report destinations are create-only")
    if sha256(rom) != EXPECTED_ROM_SHA256:
        raise RuntimeError("authoritative EU ROM SHA-256 mismatch")
    if not 0 <= args.song_index <= 65535:
        raise ValueError("song index is outside the M4A table range")
    require_identity(m4play, EXPECTED_M4PLAY_COMMIT, "M4plAy")
    require_identity(ogg, EXPECTED_OGG_COMMIT, "libogg")
    require_identity(vorbis, EXPECTED_VORBIS_COMMIT, "libvorbis")
    compiler = shutil.which(args.compiler)
    if compiler is None:
        raise RuntimeError(f"compiler not found: {args.compiler}")

    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f"pmdred-song-{args.song_index}-") as temporary:
        build = Path(temporary)
        executable = build_renderer(
            compiler, root / "tools/pmdred_m4a_to_ogg_general.c",
            m4play, ogg, vorbis, build,
        )
        discovery = build / "discovery.ogg"
        _, loop_start, loop_length, discovery_log = run_renderer(
            executable, rom, args.song_index, discovery, args.title, 0, 0
        )
        if loop_length <= 0:
            raise RuntimeError("disposable process did not discover a positive loop")

        # This is a separate operating-system process with fresh M4A state.
        candidate = build / "exact-gated.ogg"
        samples, exact_start, exact_length, exact_log = run_renderer(
            executable, rom, args.song_index, candidate, args.title,
            loop_start, loop_length,
        )
        if (exact_start, exact_length) != (loop_start, loop_length):
            raise RuntimeError("fresh exact-gated process did not reproduce discovery")
        granule, comments = parse_ogg(candidate)
        expected_comments = {
            "TITLE": args.title,
            "SOURCE": "Pokemon Mystery Dungeon Red Rescue Team EU ROM",
            "SOURCE_ROM_SHA256": EXPECTED_ROM_SHA256,
            "M4A_SONG_TABLE_INDEX": str(args.song_index),
            "LOOPSTART": str(loop_start),
            "LOOPLENGTH": str(loop_length),
        }
        if granule != samples or samples != loop_start + loop_length:
            raise RuntimeError(
                f"PCM gate failed: granule={granule}, samples={samples}, "
                f"loop sum={loop_start + loop_length}"
            )
        for key, expected in expected_comments.items():
            if comments.get(key) != expected:
                raise RuntimeError(f"Vorbis comment mismatch for {key}")
        candidate.replace(output)

    result = {
        "status": "PASS",
        "scope": "authenticated source/dependency/loop/Vorbis gates; not PMDO-native playback",
        "output": str(output.relative_to(root)),
        "sha256": sha256(output),
        "bytes": output.stat().st_size,
        "sample_rate": SAMPLE_RATE,
        "samples": samples,
        "loop_start": loop_start,
        "loop_length": loop_length,
        "song_index": args.song_index,
        "title": args.title,
        "discovery_process": discovery_log,
        "exact_gated_process": exact_log,
        "dependencies": {
            "m4play": EXPECTED_M4PLAY_COMMIT,
            "libogg": EXPECTED_OGG_COMMIT,
            "libvorbis": EXPECTED_VORBIS_COMMIT,
        },
    }
    if report is not None:
        report.parent.mkdir(parents=True, exist_ok=True)
        report.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
