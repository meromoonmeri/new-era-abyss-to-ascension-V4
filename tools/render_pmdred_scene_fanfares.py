#!/usr/bin/env python3
"""Render every authenticated EU-ROM cue used by Tiny Woods scenes.

Ten one-shot cues use a fresh native M4A TRACK-clear discovery followed by two
sample-gated byte-identical renders. Cue 450 is authentically non-terminating
and paired with explicit Red stop opcodes, so it uses the unchanged looping
renderer's synchronized-state gate and is installed as a PMDO loop sound.
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
LOOP_CUES = (450,)
ONE_SHOT_CUES = (455, 457, 463, 465, 466, 468, 469, 470, 473, 482)
CUES = LOOP_CUES + ONE_SHOT_CUES
RESULT_RE = re.compile(r"tracks=(\d+) samples=(\d+) completion=TRACK_CLEAR")


def load_renderer():
    path = ROOT / "tools/render_pmdred_tiny_woods_music.py"
    spec = importlib.util.spec_from_file_location("render_pmdred_tiny_woods_music", path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_scene_music():
    path = ROOT / "tools/render_pmdred_scene_music.py"
    spec = importlib.util.spec_from_file_location("render_pmdred_scene_music", path)
    if spec is None or spec.loader is None:
        raise ImportError(path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def invoke(executable: Path, rom: Path, cue: int, output: Path, expected: int) -> tuple[int, int, str]:
    title = f"PMD Red EU scene cue {cue}"
    result = subprocess.run(
        [str(executable), str(rom), str(cue), str(output), ROM_SHA256, title, str(expected)],
        check=False, text=True, capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"fanfare renderer failed for cue {cue} ({result.returncode}): "
            f"stdout={result.stdout!r} stderr={result.stderr!r}"
        )
    match = RESULT_RE.search(result.stdout)
    if match is None:
        raise RuntimeError(f"renderer omitted TRACK-clear evidence for cue {cue}: {result.stdout!r}")
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
        raise FileExistsError(f"refusing to overwrite fanfare evidence: {output}")
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
    with tempfile.TemporaryDirectory(prefix="pmdred-fanfares-") as temporary:
        build = Path(temporary)
        one_shot_executable = frozen.build_renderer(
            compiler, ROOT / "tools/pmdred_m4a_fanfare_to_ogg.c",
            m4play, ogg, vorbis, build / "one-shot",
        )
        loop_executable = frozen.build_renderer(
            compiler, ROOT / "tools/pmdred_m4a_to_ogg_general.c",
            m4play, ogg, vorbis, build / "loop",
        )
        for cue in ONE_SHOT_CUES:
            probe = build / f"{cue}-probe.ogg"
            tracks, samples, discovery = invoke(one_shot_executable, rom, cue, probe, 0)
            if samples <= 0 or samples % (frozen.SAMPLE_RATE // 60) != 0:
                raise RuntimeError(f"cue {cue}: invalid frame-aligned completion count {samples}")
            first = build / f"{cue}-first.ogg"
            second = build / f"{cue}-second.ogg"
            first_run = invoke(one_shot_executable, rom, cue, first, samples)
            second_run = invoke(one_shot_executable, rom, cue, second, samples)
            if first_run[:2] != second_run[:2] or first.read_bytes() != second.read_bytes():
                raise RuntimeError(f"cue {cue}: independent gated renders differ")
            granule, comments = frozen.parse_ogg(first)
            expected_comments = {
                "TITLE": f"PMD Red EU scene cue {cue}",
                "SOURCE": "Pokemon Mystery Dungeon Red Rescue Team EU ROM",
                "SOURCE_ROM_SHA256": ROM_SHA256,
                "PMDRED_M4A_KIND": "FANFARE",
                "M4A_SONG_TABLE_INDEX": str(cue),
            }
            if granule != samples or any(comments.get(k) != v for k, v in expected_comments.items()):
                raise RuntimeError(f"cue {cue}: Ogg metadata/granule differs")
            destination = output / f"Cue {cue}.ogg"
            shutil.copyfile(first, destination)
            records.append({
                "cue_id": cue, "playback_kind": "one_shot_fanfare",
                "filename": destination.name,
                "bytes": destination.stat().st_size, "sha256": sha256(destination),
                "sample_rate": frozen.SAMPLE_RATE, "samples": samples,
                "duration_seconds": samples / frozen.SAMPLE_RATE, "tracks": tracks,
                "completion_condition": "(gMPlayInfo_BGM.status & MUSICPLAYER_STATUS_TRACK) == 0",
                "discovery_run": discovery, "deterministic_gated_runs": 2,
            })
        scene_music = load_scene_music()
        for cue in LOOP_CUES:
            title = f"PMD Red EU scene cue {cue}"
            probe = build / f"{cue}-loop-probe.ogg"
            tracks, samples, loop_start, loop_length, discovery = scene_music.invoke(
                loop_executable, rom, cue, probe, title, 0, 0
            )
            first = build / f"{cue}-loop-first.ogg"
            second = build / f"{cue}-loop-second.ogg"
            first_run = scene_music.invoke(loop_executable, rom, cue, first, title, loop_start, loop_length)
            second_run = scene_music.invoke(loop_executable, rom, cue, second, title, loop_start, loop_length)
            if first_run[:4] != second_run[:4] or first.read_bytes() != second.read_bytes():
                raise RuntimeError(f"loop cue {cue}: independent gated renders differ")
            granule, comments = frozen.parse_ogg(first)
            expected_comments = {
                "TITLE": title, "SOURCE": "Pokemon Mystery Dungeon Red Rescue Team EU ROM",
                "SOURCE_ROM_SHA256": ROM_SHA256, "M4A_SONG_TABLE_INDEX": str(cue),
                "LOOPSTART": str(loop_start), "LOOPLENGTH": str(loop_length),
            }
            if granule != samples or any(comments.get(k) != v for k, v in expected_comments.items()):
                raise RuntimeError(f"loop cue {cue}: Ogg metadata/granule differs")
            destination = output / f"Cue {cue}.ogg"
            shutil.copyfile(first, destination)
            records.append({
                "cue_id": cue, "playback_kind": "loop_until_explicit_stop",
                "filename": destination.name,
                "bytes": destination.stat().st_size, "sha256": sha256(destination),
                "sample_rate": frozen.SAMPLE_RATE, "samples": samples,
                "duration_seconds": samples / frozen.SAMPLE_RATE, "tracks": tracks,
                "loop_start": loop_start, "loop_length": loop_length,
                "completion_condition": "explicit EU opcode 0x4D FANFARE_STOP2",
                "discovery_run": discovery, "deterministic_gated_runs": 2,
            })
        records.sort(key=lambda row: row["cue_id"])

    manifest = {
        "schema": "new-era.pmdred-eu-scene-fanfares.v1",
        "authority": {"region": "EU", "rom_sha256": ROM_SHA256},
        "renderers": {
            "one_shot": {
                "source": "tools/pmdred_m4a_fanfare_to_ogg.c",
                "source_sha256": sha256(ROOT / "tools/pmdred_m4a_fanfare_to_ogg.c"),
                "sample_rate": frozen.SAMPLE_RATE,
                "completion_condition": "(gMPlayInfo_BGM.status & MUSICPLAYER_STATUS_TRACK) == 0",
                "method": "fresh TRACK-clear discovery plus two byte-identical sample-gated renders",
            },
            "explicit_stop_loop": {
                "source": "tools/pmdred_m4a_to_ogg_general.c",
                "source_sha256": sha256(ROOT / "tools/pmdred_m4a_to_ogg_general.c"),
                "sample_rate": frozen.SAMPLE_RATE,
                "method": "unchanged synchronized complete-sequence loop gate plus two byte-identical renders",
            },
        },
        "dependencies": {
            "m4play": frozen.EXPECTED_M4PLAY_COMMIT,
            "libogg": frozen.EXPECTED_OGG_COMMIT,
            "libvorbis": frozen.EXPECTED_VORBIS_COMMIT,
        },
        "cues": records,
        "validation": {"status": "pass", "cue_count": len(records)},
    }
    (output / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"PMDRED_SCENE_FANFARES_PASS cues={len(records)} output={output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
