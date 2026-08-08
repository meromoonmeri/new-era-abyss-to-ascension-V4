# Global PMDO Import Integrity Audit

Classification: **static exhaustive discovery**. No runtime PASS inferred.

## Coverage
- zones: 50
- dungeons: 50
- structures: 132
- segments: 132
- floors: 804
- grounds: 166
- tile_sheets: 639
- frames: 748953
- tile_references: 748953
- markers: 397
- spawners: 223
- entities: 448
- transitions: 295
- bosses: 181
- lua_files: 517
- cinematic_candidate_files: 330

## Verdict counts
- TOTAL_DISCOVERED: 1502270
- TOTAL_AUDITED: 1502270
- TOTAL_FIXED: 0
- TOTAL_RUNTIME_PASS: 0
- TOTAL_RUNTIME_FAIL: 0
- TOTAL_INCONCLUSIVE: 0
- TOTAL_NOT_TESTED: 347
- problems: 28

## Findings by type
- SPAWNER_OUT_OF_BOUNDS: 12
- CROSS_DUNGEON_FLOOR_NAME: 10
- ORPHAN_GROUND: 3
- INVALID_TRANSITION_TARGET: 3

## Tornadus
`CRITICAL_RUNTIME_BLOCKER — INCONCLUSIVE`. Full interactive cutscene repetition tests have not run in this batch.
