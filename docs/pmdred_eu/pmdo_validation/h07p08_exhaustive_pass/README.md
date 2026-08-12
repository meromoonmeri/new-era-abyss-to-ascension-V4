# h07p08 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h07p08` is the authenticated EU rub a dub river friend area (`MAP_FRIEND_AREA_RUB_A_DUB_RIVER`; map ID 130, map-file ID 136). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h07p08.rsground` (`794f244eb749a247123b620cf3d8c33fbfad17591b55b3d5b599fb0a237341b7`) and `Content/Tile/h07p08_Base.tile` (`1b39a124211a4014abbf7edfafdf7fcefc8292d0d624328ae08adee1e2bdb257`), inserted one zone entry after `h07p07` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
