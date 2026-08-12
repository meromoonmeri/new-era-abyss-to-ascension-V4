# b15p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b15p01a` is the authenticated EU construction chikorita rescue team base exterior (`MAP_TEAM_BASE_CHIKORITA_CONSTRUCTION`; map ID 94, map-file ID 95). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b15p01a.rsground` (`c0b4378af21ea7abcd75b5864c7826c4e992dccaa5153bcbb3549806212f5b2a`) and `Content/Tile/b15p01a_Base.tile` (`2411e7b7eeb1cacb5cd8803e8b91ddf0df96fdd03de0f01a7e9e3172207b985b`), inserted one zone entry after `b14p02c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
