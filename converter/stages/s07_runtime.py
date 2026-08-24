"""Stage 7 — runtime smoke test in PMDO 0.8.12 (headless).

Boots RogueEssence in a headless mode (--dev, no audio, no rendering
window) and asks it to:

  1. Load the mod (New-Era) from a scratch data directory.
  2. Load the target Zone.
  3. Load the target Ground.
  4. Tick the scene we care about (cutscene entry) for N frames.
  5. Capture: entities loaded, camera position, active BGM,
     last dialogue key emitted, warp destination reached.

Compares captured runtime state to what the Cinematic_IR promised.
Any divergence => FAIL with a specific reason. A missing runtime binary
=> SKIPPED (not FAIL), because absence of runtime does not mean the
emitted content is wrong.

This stage is where 'PASS' finally means something: the scene actually
plays end-to-end inside PMDO.
"""
from __future__ import annotations

import shutil

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s07_runtime"


def _has_dotnet() -> bool:
    return shutil.which("dotnet") is not None


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)

    if not _has_dotnet():
        result.reason = (
            "dotnet SDK not found in PATH. RogueEssence headless smoke "
            "test needs `dotnet run` against a RogueEssence checkout. "
            "Install .NET 6+ or provide a prebuilt PMDO.exe path via "
            "env PMDO_HEADLESS_BIN, then re-run."
        )
        return result

    # Placeholder: real implementation will wire subprocess + capture.
    result.status = StageStatus.UNIMPLEMENTED
    result.reason = (
        "dotnet available, but the headless harness "
        "(converter/runtime/pmdo_headless.py) is not wired to a "
        "RogueEssence build yet. Refusing to emit PASS from a fake test."
    )
    return result
