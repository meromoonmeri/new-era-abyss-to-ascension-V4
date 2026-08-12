# h29p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h29p01` is the authenticated EU southern island friend area (`MAP_FRIEND_AREA_SOUTHERN_ISLAND`; map ID 159, map-file ID 167). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **3201/3201** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 3200 primary boundary ticks (0–8959) cover every applicable animation schedule through two complete local cycles (maximum 4480 ticks); 288 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h29p01.rsground` (`ba7075f2df85d49ce5e4b711a7e57917257481dd18c7d0e9baebbcd09b80bd67`) and `Content/Tile/h29p01_Base.tile` (`520662cab7438fe1f6b82d601806d3198f6f961479422e0bd2273f7f50e26b69`). Promotion inserted one zone entry after `h28p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
