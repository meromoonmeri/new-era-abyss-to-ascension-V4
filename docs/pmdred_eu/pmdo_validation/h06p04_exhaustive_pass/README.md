# h06p04 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h06p04` is the authenticated EU scorched plains friend area (`MAP_FRIEND_AREA_SCORCHED_PLAINS`; map ID 120, map-file ID 125). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h06p04.rsground` (`a69c6c00e133bc28b80b2a4ac818eeaf1a33fb24d9e6ec09f067a4ae745f465f`) and `Content/Tile/h06p04_Base.tile` (`ed69356fa15276b2d86f3df27aaafd563ae56dd75e3ba9a70ac5cab93ddc1bf7`), inserted one zone entry after `h06p03` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
