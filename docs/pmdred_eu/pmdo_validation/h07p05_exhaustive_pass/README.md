# h07p05 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h07p05` is the authenticated EU healing forest friend area (`MAP_FRIEND_AREA_HEALING_FOREST`; map ID 127, map-file ID 133). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h07p05.rsground` (`05ee55e06556fffc38c25d4a091533cf5ac3d82a4f61e25a1bc2a8dcddf5879d`) and `Content/Tile/h07p05_Base.tile` (`6e750b15c15d541d9fdd56413a072df0898c48e8e1e98d29376ec4b7859beb9a`), inserted one zone entry after `h07p04` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
