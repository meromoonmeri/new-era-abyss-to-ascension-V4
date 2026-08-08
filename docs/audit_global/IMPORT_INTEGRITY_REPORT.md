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
- problems: 28

## Findings by type
- SPAWNER_OUT_OF_BOUNDS: 12
- CROSS_DUNGEON_FLOOR_NAME: 10
- ORPHAN_GROUND: 3
- INVALID_TRANSITION_TARGET: 3

## Tornadus
`CRITICAL_RUNTIME_BLOCKER — INCONCLUSIVE`. Full interactive cutscene repetition tests have not run in this batch.

## PHASE 2 — REPAIR RESULTS (current batch)
See `PHASE2_REPAIR_RESULTS.md`. Cross-dungeon floor identities: **22 → 10**.
Tornadus remains `RUNTIME_FAIL`; no PASS claimed.
