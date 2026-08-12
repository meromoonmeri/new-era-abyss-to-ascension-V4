# h27p01 preserved failed orchestration attempt

This is **FAIL evidence, not an official Ground PASS**. On 2026-08-12, the first `h27p01` attempt completed authenticated exact-PMDO runtime, native graceful unload, and all 609 independent full-RGBA comparisons, then stopped during canonical zone registration because the earlier out-of-order validated `h26p01` pilot was not registered in `master_zone.json`.

The attempt had already atomically created the previously absent destination Ground and tile from the exact authenticated v2.0.1 candidate. Those exact untracked bytes were preserved in place; they were not deleted, renamed, overwritten, or reclassified as a PASS. Recovery requires a transparent pilot-zone integration correction and a complete fresh runtime/comparison rerun before official evidence and promotion may complete.
