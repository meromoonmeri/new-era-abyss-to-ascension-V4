"""Stage 2 — decode proprietary GBA formats into IR structures.

At this stage the ROM is no longer touched; we work on the blobs
extracted by s01 into converter/rom_output/01_extract/. Each decoder
lives in converter/decoders/ and is honest about what it understands:
what it cannot decode is preserved verbatim as UnknownOpcode / raw
byte blobs so a later run can lift it, and the pipeline reports it.

Decoders are called on a *scope* (a list of ground ids, default =
every ground id declared by the registry). This lets us prototype on
one dungeon (Tiny Woods = d01p01 + d01p02) before scaling out.
"""
from __future__ import annotations

import json
from pathlib import Path

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s02_decode"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.UNIMPLEMENTED)
    result.reason = (
        "Decoders under converter/decoders/ are stubs. Each format "
        "(BMA/BPC/BPA/Kao/SSB/text_bank) needs its own implementation, "
        "wired here in scope order. Pipeline honestly reports "
        "UNIMPLEMENTED rather than emit a fake PASS."
    )

    # Even in the unimplemented state we surface a small heartbeat so
    # callers can see the stage did run and inspected the extracted
    # blobs.
    extract_dir = ctx.rom_output_dir / "s01_extract"
    if extract_dir.exists():
        blobs = sorted(p for p in extract_dir.glob("*.bin"))
        result.metrics["blobs_available"] = len(blobs)
        result.metrics["blob_examples"] = [p.name for p in blobs[:5]]
    else:
        result.metrics["blobs_available"] = 0

    # Persist an intent record so s03+ have something to check against.
    out = ctx.stage_output_dir(STAGE)
    intent = {
        "scope_grounds": ctx.scope_grounds or [],
        "decoders_status": {
            "bma": "stub",
            "bpc": "stub",
            "bpa": "stub",
            "kao": "stub",
            "ssb": "stub",
            "text_bank": "stub",
        },
    }
    ctx.write_json(out / "_intent.json", intent)
    result.artefacts.append(str(out / "_intent.json"))
    return result
