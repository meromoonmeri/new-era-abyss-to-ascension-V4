# h06p05 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h06p05` is the authenticated EU sacred field friend area (`MAP_FRIEND_AREA_SACRED_FIELD`; map ID 121, map-file ID 126). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **57/57** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 56 primary boundary ticks (0–71) cover every applicable animation schedule through two complete local cycles (maximum 36 ticks); 36 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h06p05.rsground` (`df9ce45e1c55f251d023a2e933b7c217b21e6c8993ed43d7db32f94c74a0265e`) and `Content/Tile/h06p05_Base.tile` (`1a799257fa4442a99e963037dc46d65c8a0cd50f4b619847da3cf873f5881210`), inserted one zone entry after `h06p04` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
