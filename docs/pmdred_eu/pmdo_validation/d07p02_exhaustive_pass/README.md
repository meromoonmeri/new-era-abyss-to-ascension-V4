# d07p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d07p02` is the authenticated EU mt blaze end ground (`MAP_MT_BLAZE_END`; map ID 197, map-file ID 206). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **136/136** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 135 primary boundary ticks (0–215) cover every applicable animation schedule through two complete local cycles (maximum 108 ticks); 62 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d07p02.rsground` (`dda3fc36ff3d9789d90f8cb6e4ae5ae9a15a37fd00c0fd276d667c74f554cc70`) and `Content/Tile/d07p02_Base.tile` (`b376149a921c935a8f803b36559627302fb0fb5f00832a602d5c83a54af28adf`). Zone integration one insertion after d07p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
