"""Stage 3 — normalise decoded data into IR structures.

Turns whatever s02 produced (per-decoder blobs + partial IR) into
canonical Ground_IR / Cinematic_IR / Asset_IR instances, ready for
mapping to PMDO. This stage is where we merge ROM data with pret
macro-level information (when needed to disambiguate an opcode).

Merge rule: ROM is authoritative on VALUES; pret is authoritative on
NAMES (opcode label, music constant name, flag name). A pret name is
only accepted if it can be matched to a ROM offset we actually
extracted; unmatched pret hints are downgraded to RECONSTRUCTED.
"""
from __future__ import annotations

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s03_normalise"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.UNIMPLEMENTED)
    result.reason = (
        "Normalisation depends on s02 output (currently stub). "
        "As soon as a decoder produces real IR fragments, this stage "
        "will assemble them into full Ground_IR / Cinematic_IR objects "
        "with strict provenance."
    )
    out = ctx.stage_output_dir(STAGE)
    ctx.write_json(out / "_intent.json", {
        "would_normalise_scope": ctx.scope_grounds or [],
    })
    result.artefacts.append(str(out / "_intent.json"))
    return result
