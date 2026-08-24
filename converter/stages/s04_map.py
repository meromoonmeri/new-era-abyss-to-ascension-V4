"""Stage 4 — map IR to PMDO representations.

Takes normalised IR from s03 and translates it to the concrete PMDO
0.8.12 shapes:

  Ground_IR      -> RogueEssence GroundMap (.rsground)
  Cinematic_IR   -> Lua ground cutscene (Data/Script/halcyon/ground/<id>/*.lua)
  Asset_IR tile  -> Content/Tile atlas + index entry

Mapping decisions live in converter/mappers/. Each mapper documents on
what basis it chose a target mechanism (native PMDO hook vs approximation)
and downgrades provenance status accordingly (PORTED -> PARTIAL when a
mechanism doesn't exist natively).

Every mapper output is written to converter/rom_output/05_emit/ staging,
NOT directly under Data/. Emission to the real tree happens in s05.
"""
from __future__ import annotations

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s04_map"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.UNIMPLEMENTED)
    result.reason = (
        "Mappers under converter/mappers/ are stubs. Nothing to map "
        "until s03 produces IR objects. Emitting UNIMPLEMENTED rather "
        "than a fake PASS is deliberate."
    )
    out = ctx.stage_output_dir(STAGE)
    ctx.write_json(out / "_intent.json", {
        "mappers_status": {
            "ground_to_rsground": "stub",
            "cinematic_to_lua": "stub",
            "tile_to_atlas": "stub",
            "strings_to_resx": "stub",
        },
    })
    result.artefacts.append(str(out / "_intent.json"))
    return result
