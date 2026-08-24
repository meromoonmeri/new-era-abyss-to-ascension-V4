"""Cinematic_IR -> Lua ground cutscene (staging only).

Placeholder. When implemented, this mapper will:
  1. Translate each Event_IR into the equivalent RogueEssence Lua call
     (GAME:PlayBGM, GROUND:CharSetAction, UI:WaitShowDialogue, etc.).
  2. Preserve waits and ordering (PMDO Lua is coroutine-based, so
     sequential IR events map naturally to sequential Lua calls).
  3. Wire preconditions to the ground init.lua as flag checks.
  4. For UnknownOpcode events, emit a Lua comment recording the ROM
     offset + raw bytes so nothing is silently dropped, and downgrade
     provenance to PARTIAL with an explicit status_reason.

Downgrade table (target PMDO 0.8.12):
  * CameraGoto / CameraFollow  -> GROUND:MoveCamera / GROUND:AttachCamera
    (PORTED). If a source uses sub-tile precision, downgrade PARTIAL.
  * ScreenShake                -> UI:ScreenShake if available;
    otherwise PARTIAL (approx via CharSetAction jitter).
  * ScreenFlash                -> UI:FadeScreenTint (short burst);
    exact duration below 1 frame downgraded to PARTIAL.
  * FadeToColor arbitrary RGB  -> UI:FadeScreen; non-black/white
    colours downgraded to PARTIAL if the runtime API is limited.
"""
from __future__ import annotations


def map_cinematic(cinematic_ir, *, staging_dir):
    raise NotImplementedError("cinematic_to_lua mapper not wired yet.")
