# a01p02 preserved failed orchestration attempt

This is **FAIL evidence, not an official Ground PASS**. On 2026-08-12, the first `a01p02` attempt completed the authenticated exact-PMDO runtime, native graceful unload, and both independent full-RGBA comparisons. The orchestrator then stopped before promotion because its final milestone gate required a blocked movement probe even when the authenticated raw-ROM BMA has no collision layer and zero solid cells.

The fixture and comparator had already represented that ROM-authenticated condition as `NOT_APPLICABLE_NO_BMA_SOLIDS`; the comparator's runtime-safety contract explicitly accepts that result. No canonical Ground/tile destination or zone/checkpoint state changed. Recovery requires a narrow gate/evidence correction that accepts non-applicability only when the plan, fixture, and runtime event all independently agree that no BMA collision layer or solid exists, followed by a complete fresh runtime/comparison rerun.
