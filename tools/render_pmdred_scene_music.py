#!/usr/bin/env python3
"""Render the authenticated EU-ROM music needed by the Tiny Woods scenes.

Each track is rendered three times with the pinned M4plAy/Vorbis stack: a first
fresh process discovers synchronized loop boundaries, then two fresh gated
processes must produce byte-identical Ogg files.  The historical Tiny Woods C
frontend and its already promoted bytes remain untouched.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
ROM_SHA256 = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
LOOPING_TRACKS = (
    (1, "Rescue Team Base", "PMD Red - Rescue Team Base.ogg"),
    (10, "There's Trouble", "PMD Red - There's Trouble.ogg"),
    (101, "Heartwarming", "PMD Red - Heartwarming.ogg"),
    (103, "A Successful Rescue", "PMD Red - A Successful Rescue.ogg"),
    (114, "In the Depths of the Pit", "PMD Red - In the Depths of the Pit.ogg"),
)
TERMINATING_TRACKS = (
    (46, "Aftermath", "PMD Red - Aftermath.ogg"),
)
LOOP_RE = re.compile(r"tracks=(\d+) samples=(\d+) loop_start=(\d+) loop_length=(\d+)")
TERMINATING_RE = re.compile(r"tracks=(\d+) samples=(\d+) completion=TRACK_CLEAR")


def load_renderer():
    path = ROOT / "tools/render_pmdred_tiny_woods_music.py"
    spec = importlib.util.spec_from_file_location("render_pmdred_tiny_woods_music", path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def invoke(
    executable: Path,
    rom: Path,
    song: int,
    output: Path,
    title: str,
    loop_start: int,
    loop_length: int,
) -> tuple[int, int, int, int, str]:
    result = subprocess.run(
        [
            str(executable), str(rom), str(song), str(output), ROM_SHA256,
            title, str(loop_start), str(loop_length),
        ],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"renderer failed for song {song} ({result.returncode}): "
            f"stdout={result.stdout!r} stderr={result.stderr!r}"
        )
    match = LOOP_RE.search(result.stdout)
    if match is None:
        raise RuntimeError(f"renderer omitted loop evidence for song {song}: {result.stdout!r}")
    tracks, samples, detected_start, detected_length = map(int, match.groups())
    return tracks, samples, detected_start, detected_length, result.stdout.strip()


def invoke_terminating(
    executable: Path, rom: Path, song: int, output: Path, title: str,
    expected_samples: int,
) -> tuple[int, int, str]:
    result = subprocess.run(
        [str(executable), str(rom), str(song), str(output), ROM_SHA256,
         title, str(expected_samples), "TERMINATING_BGM"],
        check=False, text=True, capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"terminating renderer failed for song {song} ({result.returncode}): "
            f"stdout={result.stdout!r} stderr={result.stderr!r}"
        )
    match = TERMINATING_RE.search(result.stdout)
    if match is None:
        raise RuntimeError(f"renderer omitted TRACK-clear evidence for song {song}: {result.stdout!r}")
    tracks, samples = map(int, match.groups())
    return tracks, samples, result.stdout.strip()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--m4play-source", type=Path, default=ROOT / ".runtime-cache/M4plAy-source")
    parser.add_argument("--ogg-source", type=Path, default=ROOT / ".runtime-cache/libogg-source")
    parser.add_argument("--vorbis-source", type=Path, default=ROOT / ".runtime-cache/libvorbis-source")
    parser.add_argument("--compiler", default="gcc")
    args = parser.parse_args()

    rom = args.rom.resolve()
    output = args.output_dir.resolve()
    if output.exists():
        raise FileExistsError(f"refusing to overwrite scene-music evidence: {output}")
    if sha256(rom) != ROM_SHA256:
        raise RuntimeError("authoritative EU ROM SHA-256 mismatch")
    frozen = load_renderer()
    m4play = args.m4play_source.resolve()
    ogg = args.ogg_source.resolve()
    vorbis = args.vorbis_source.resolve()
    frozen.require_identity(m4play, frozen.EXPECTED_M4PLAY_COMMIT, "M4plAy")
    frozen.require_identity(ogg, frozen.EXPECTED_OGG_COMMIT, "libogg")
    frozen.require_identity(vorbis, frozen.EXPECTED_VORBIS_COMMIT, "libvorbis")
    compiler = shutil.which(args.compiler)
    if compiler is None:
        raise RuntimeError(f"compiler not found: {args.compiler}")

    output.mkdir(parents=True)
    records: list[dict[str, Any]] = []
    with tempfile.TemporaryDirectory(prefix="pmdred-scene-music-") as temporary:
        build = Path(temporary)
        executable = frozen.build_renderer(
            compiler, ROOT / "tools/pmdred_m4a_to_ogg_general.c",
            m4play, ogg, vorbis, build / "looping",
        )
        terminating_executable = frozen.build_renderer(
            compiler, ROOT / "tools/pmdred_m4a_fanfare_to_ogg.c",
            m4play, ogg, vorbis, build / "terminating",
        )
        for song, title, filename in LOOPING_TRACKS:
            probe = build / f"{song}-probe.ogg"
            tracks, samples, loop_start, loop_length, discovery = invoke(
                executable, rom, song, probe, title, 0, 0
            )
            if samples != loop_start + loop_length:
                raise RuntimeError(f"song {song}: intro-plus-loop sample count differs")
            first = build / f"{song}-first.ogg"
            second = build / f"{song}-second.ogg"
            first_run = invoke(executable, rom, song, first, title, loop_start, loop_length)
            second_run = invoke(executable, rom, song, second, title, loop_start, loop_length)
            if first_run[:4] != second_run[:4] or first.read_bytes() != second.read_bytes():
                raise RuntimeError(f"song {song}: independent gated renders differ")
            granule, comments = frozen.parse_ogg(first)
            expected_comments = {
                "TITLE": title,
                "SOURCE": "Pokemon Mystery Dungeon Red Rescue Team EU ROM",
                "SOURCE_ROM_SHA256": ROM_SHA256,
                "M4A_SONG_TABLE_INDEX": str(song),
                "LOOPSTART": str(loop_start),
                "LOOPLENGTH": str(loop_length),
            }
            if granule != samples or any(comments.get(k) != v for k, v in expected_comments.items()):
                raise RuntimeError(f"song {song}: Ogg metadata/granule differs")
            destination = output / filename
            shutil.copyfile(first, destination)
            records.append({
                "song_index": song,
                "playback_kind": "looping_bgm",
                "title": title,
                "filename": filename,
                "bytes": destination.stat().st_size,
                "sha256": sha256(destination),
                "sample_rate": frozen.SAMPLE_RATE,
                "samples": samples,
                "loop_start": loop_start,
                "loop_length": loop_length,
                "tracks": tracks,
                "discovery_run": discovery,
                "deterministic_runs": 2,
            })
        for song, title, filename in TERMINATING_TRACKS:
            probe = build / f"{song}-probe.ogg"
            tracks, samples, discovery = invoke_terminating(
                terminating_executable, rom, song, probe, title, 0
            )
            if samples <= 0 or samples % (frozen.SAMPLE_RATE // 60) != 0:
                raise RuntimeError(f"song {song}: invalid frame-aligned completion count {samples}")
            first = build / f"{song}-first.ogg"
            second = build / f"{song}-second.ogg"
            first_run = invoke_terminating(terminating_executable, rom, song, first, title, samples)
            second_run = invoke_terminating(terminating_executable, rom, song, second, title, samples)
            if first_run[:2] != second_run[:2] or first.read_bytes() != second.read_bytes():
                raise RuntimeError(f"song {song}: independent gated renders differ")
            granule, comments = frozen.parse_ogg(first)
            expected_comments = {
                "TITLE": title, "SOURCE": "Pokemon Mystery Dungeon Red Rescue Team EU ROM",
                "SOURCE_ROM_SHA256": ROM_SHA256, "PMDRED_M4A_KIND": "TERMINATING_BGM",
                "M4A_SONG_TABLE_INDEX": str(song),
            }
            if granule != samples or any(comments.get(k) != v for k, v in expected_comments.items()):
                raise RuntimeError(f"song {song}: Ogg metadata/granule differs")
            destination = output / filename
            shutil.copyfile(first, destination)
            records.append({
                "song_index": song, "playback_kind": "terminating_bgm",
                "title": title, "filename": filename,
                "bytes": destination.stat().st_size, "sha256": sha256(destination),
                "sample_rate": frozen.SAMPLE_RATE, "samples": samples, "tracks": tracks,
                "completion_condition": "(gMPlayInfo_BGM.status & MUSICPLAYER_STATUS_TRACK) == 0",
                "discovery_run": discovery, "deterministic_runs": 2,
            })
        records.sort(key=lambda row: row["song_index"])

    manifest = {
        "schema": "new-era.pmdred-eu-scene-music.v1",
        "authority": {"region": "EU", "rom_sha256": ROM_SHA256},
        "renderers": {
            "looping_bgm": {
                "source": "tools/pmdred_m4a_to_ogg_general.c",
                "source_sha256": sha256(ROOT / "tools/pmdred_m4a_to_ogg_general.c"),
                "sample_rate": frozen.SAMPLE_RATE,
                "method": "fresh synchronized-loop discovery plus two byte-identical gated renders",
            },
            "terminating_bgm": {
                "source": "tools/pmdred_m4a_fanfare_to_ogg.c",
                "source_sha256": sha256(ROOT / "tools/pmdred_m4a_fanfare_to_ogg.c"),
                "sample_rate": frozen.SAMPLE_RATE,
                "method": "fresh TRACK-clear discovery plus two byte-identical gated renders",
            },
        },
        "dependencies": {
            "m4play": frozen.EXPECTED_M4PLAY_COMMIT,
            "libogg": frozen.EXPECTED_OGG_COMMIT,
            "libvorbis": frozen.EXPECTED_VORBIS_COMMIT,
        },
        "tracks": records,
        "validation": {"status": "pass", "track_count": len(records)},
    }
    (output / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"PMDRED_SCENE_MUSIC_PASS tracks={len(records)} output={output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
