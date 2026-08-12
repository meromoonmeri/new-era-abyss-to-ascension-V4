# h06p06 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h06p06` is the authenticated EU mist rise forest friend area (`MAP_FRIEND_AREA_MIST_RISE_FOREST`; map ID 122, map-file ID 127). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h06p06.rsground` (`3ee8c2b92943513ecaf0c1ae7f7aa1db1f23df640c17fec320e91f16a2e9b2b7`) and `Content/Tile/h06p06_Base.tile` (`800957191d3128e99be84a2597f396c19ddbd34a9b811fd82b9d089a59c62a66`), inserted one zone entry after `h06p05` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
