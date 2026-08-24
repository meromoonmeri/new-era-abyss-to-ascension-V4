"""Stage 5 — emit mapped artefacts into the real project tree.

Reads the staging area (converter/rom_output/05_emit/) and writes files
under Data/Ground/, Data/Script/halcyon/ground/, Content/Tile/,
Strings/*.resx.

Guard rails:
  1. Refuses to overwrite a file whose *existing* provenance manifest
     shows a higher confidence than what we would write. In particular,
     never downgrade a CANONICAL/PORTED file to a RECONSTRUCTED one.
  2. Refuses to write a file that has no accompanying provenance.
  3. Every write is journalled into converter/rom_output/05_emit/_write.log
     so a single rollback can undo the entire stage.
  4. Idempotent: rewriting the same IR twice produces bit-identical files.
"""
from __future__ import annotations

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s05_emit"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.UNIMPLEMENTED)
    result.reason = (
        "Nothing staged by s04 yet. When s04 produces PMDO artefacts, "
        "this stage will merge them into Data/ and Content/ with the "
        "downgrade-guard, no-provenance-refusal, and rollback journal. "
        "Until then, no file is touched under Data/ or Content/."
    )
    out = ctx.stage_output_dir(STAGE)
    ctx.write_json(out / "_intent.json", {
        "would_write_targets": [
            "Data/Ground/<ground>.rsground",
            "Data/Script/halcyon/ground/<ground>/init.lua",
            "Data/Script/halcyon/ground/<ground>/<scene>.lua",
            "Content/Tile/<ground>_Base.tile",
            "Strings/stringsEx.resx (append-only merge)",
        ],
    })
    result.artefacts.append(str(out / "_intent.json"))
    return result
