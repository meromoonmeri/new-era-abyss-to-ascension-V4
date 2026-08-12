# b06p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01a` is the authenticated EU construction totodile rescue team base exterior (`MAP_TEAM_BASE_TOTODILE_CONSTRUCTION`; map ID 40, map-file ID 41). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **51/51** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 50 primary boundary ticks (0–127) cover every applicable animation schedule through two complete local cycles (maximum 64 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b06p01a.rsground` (`34dafd0f7abc393d2f38df7087b8d94264705d04d5c2cba2e28858c6177cfadd`) and `Content/Tile/b06p01a_Base.tile` (`ff7f4ddc12bc5c32551f77194c9cbf262a94d295a81d9cbb6275640aed0fd94c`), inserted one zone entry after `b05p02c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
