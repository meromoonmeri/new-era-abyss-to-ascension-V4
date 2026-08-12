# s01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s01` is the authenticated EU rescue team base wall map screen (`MAP_TEAM_BASE_WALL_MAP`; map ID 228, map-file ID 237). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **253/253** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 252 primary boundary ticks (0–1007) cover every applicable animation schedule through two complete local cycles (maximum 504 ticks); 63 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s01.rsground` (`1623ce2d7602906e7fd94936d3ec03f352bd44f1416583bbb5f10f48cd85cb96`) and `Content/Tile/s01_Base.tile` (`1cacb50450710fcd5f6c4156ce0c5a260bd1edec88b85089d411f3816b0c4dbe`). Zone integration one insertion after d24p02 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
