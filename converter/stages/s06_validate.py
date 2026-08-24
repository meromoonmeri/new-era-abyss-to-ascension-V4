"""Stage 6 — static validation of emitted artefacts.

Runs a battery of cheap-but-strict checks on whatever s05 wrote:

  * Every emitted file has an adjacent provenance manifest, and the
    manifest's rom_sha256 matches ROM_EXPECTED_HASH.
  * Lua files parse (via a Lua parser lib, or via `luac -p` if
    available; failing that, a syntax pre-check that at least catches
    unbalanced blocks).
  * Cross-refs resolve:
      - Ground referenced by Zone exists
      - Tile referenced by Ground exists in Content/Tile
      - String key referenced by dialogue exists in Strings/*.resx
      - Music track referenced by cutscene exists in Content/Music
  * Collision layer sanity: no ground with 100% solid or 100% empty
    cells (would mean a decode bug), warp destinations resolve.

Static validation is not a substitute for runtime (stage 7). A PASS at
s06 means the emitted artefacts are internally consistent; it does NOT
say the scene plays correctly.
"""
from __future__ import annotations

from converter.stages.context import Context, StageResult, StageStatus


STAGE = "s06_validate"


def run(ctx: Context) -> StageResult:
    result = StageResult(stage=STAGE, status=StageStatus.SKIPPED)
    result.reason = (
        "No artefact emitted by s05 to validate yet. Validator will "
        "activate as soon as s05 produces its first ground/scene."
    )
    out = ctx.stage_output_dir(STAGE)
    ctx.write_json(out / "_checks.json", {
        "checks_planned": [
            "provenance_present_and_matching_rom_hash",
            "lua_files_parse",
            "ground_zone_xref",
            "ground_tile_xref",
            "dialogue_string_xref",
            "cutscene_music_xref",
            "collision_layer_sanity",
            "warp_destination_resolves",
        ],
    })
    result.artefacts.append(str(out / "_checks.json"))
    return result
