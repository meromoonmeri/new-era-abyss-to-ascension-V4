# Global PMDO Import Integrity Audit

Classification: **static exhaustive discovery**. No runtime PASS inferred.

## Coverage
- zones: 50
- dungeons: 50
- structures: 132
- segments: 132
- floors: 804
- grounds: 162
- tile_sheets: 635
- frames: 730378
- tile_references: 730378
- markers: 393
- spawners: 211
- entities: 448
- transitions: 295
- bosses: 181
- lua_files: 512
- cinematic_candidate_files: 329

## Verdict counts
- TOTAL_DISCOVERED: 1465090
- TOTAL_AUDITED: 1465090
- TOTAL_FIXED: 0
- TOTAL_RUNTIME_PASS: 0
- TOTAL_RUNTIME_FAIL: 0
- TOTAL_INCONCLUSIVE: 0
- TOTAL_NOT_TESTED: 343
- problems: 307

## Findings by type
- INVALID_TEXLOC: 189
- SPAWNER_OUT_OF_BOUNDS: 52
- MARKER_OUT_OF_BOUNDS: 38
- CROSS_DUNGEON_FLOOR_NAME: 22
- ORPHAN_GROUND: 3
- INVALID_TRANSITION_TARGET: 3

## Tornadus
`CRITICAL_RUNTIME_BLOCKER — INCONCLUSIVE`. Full interactive cutscene repetition tests have not run in this batch.

## Corrections applied in this batch
- `mt_freeze` segment labels no longer identify Searing Tunnel; Mt. Freeze and Mt. Freeze Peak are distinct.
- `mt_blaze` segment labels no longer identify Searing Tunnel/Depths/Verdant Oath.
- `annexe_toupie.rsmap Object.ID` repaired from string to integer `0`.

These six schema/identity corrections are certain. Mt. Freeze encounter tables still carry
a Searing Tunnel fire signature and remain `FAIL`; they were not guessed or silently
rewritten without the canonical Red encounter oracle.

## Runtime limitation / Tornadus
The direct automated first-execution probe did not reach `CUTSCENE_END`; it is recorded
as `RUNTIME_FAIL`, not PASS. Speculative timing/camera edits used to localize the stop
were reverted. The previously proven BattlePosition crash remains fixed, but that does
not validate the complete intro, victory, reload, or repetition scenarios.
