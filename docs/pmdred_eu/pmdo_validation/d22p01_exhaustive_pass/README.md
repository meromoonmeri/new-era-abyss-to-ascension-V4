# d22p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d22p01` is the authenticated EU multicolor personality test screen (`MAP_PERSONALITY_TEST_MULTICOLOR`; map ID 223, map-file ID 232). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d22p01.rsground` (`ac5e2cb3665a902d7058cc38f41e695b09715f61353f7a6c135900c9f8f69d05`) and `Content/Tile/d22p01_Base.tile` (`dff0f69cfcf41e6571d308a850099ec018a657253905b7f783d2c041da8c0c7d`). Zone integration one insertion after d13p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
