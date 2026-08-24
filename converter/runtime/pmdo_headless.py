"""PMDO headless harness — placeholder.

Real implementation will:
  1. Locate a RogueEssence build (env PMDO_HEADLESS_BIN, or a checked
     out RogueEssence sibling directory built with `dotnet publish`).
  2. Launch it with the New Era mod folder and a scenario script that
     loads a target zone, warps to a target ground, and ticks the
     scene for N frames while streaming diagnostic events to stdout.
  3. Parse the diagnostic stream (JSONL) into a RuntimeTrace.
  4. Return the trace to s07 which compares it against Cinematic_IR.

Refuses to return a fabricated trace when no RogueEssence build is
available — s07 will report SKIPPED in that case.
"""
from __future__ import annotations

import os
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional


@dataclass
class RuntimeTrace:
    zone_loaded: Optional[str] = None
    ground_loaded: Optional[str] = None
    entities_seen: list[str] = field(default_factory=list)
    dialogues_emitted: list[str] = field(default_factory=list)
    bgm_switches: list[str] = field(default_factory=list)
    camera_final_xy: Optional[tuple[int, int]] = None
    warp_reached: Optional[str] = None
    raw_log_lines: list[str] = field(default_factory=list)


def locate_pmdo_binary() -> Optional[Path]:
    env = os.environ.get("PMDO_HEADLESS_BIN")
    if env and Path(env).exists():
        return Path(env)
    if shutil.which("PMDO"):
        return Path(shutil.which("PMDO"))  # type: ignore[arg-type]
    return None


def run_scene(
    *, mod_dir: Path, zone: str, ground: str, ticks: int
) -> Optional[RuntimeTrace]:
    """Return a RuntimeTrace when we can honestly capture one, else None."""
    binary = locate_pmdo_binary()
    if binary is None:
        return None
    # Real launcher not implemented yet on purpose.
    return None
