# s06_fre exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s06_fre` is the authenticated EU rescue team base wall map screen (`MAP_TEAM_BASE_WALL_MAP`; map ID 243, map-file ID 252). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s06_fre.rsground` (`7210462119760c239d9f027f6c3e7f83268992324fcb77b5634f898fe0fd9a97`) and `Content/Tile/s06_fre_Base.tile` (`564ee97d34708047f05e97d93811192885b5872797ab984b7273ad175f657e93`). Zone integration one insertion after s06_ger without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
