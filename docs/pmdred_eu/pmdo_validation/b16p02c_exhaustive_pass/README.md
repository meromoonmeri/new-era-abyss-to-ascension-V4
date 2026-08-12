# b16p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b16p02c` is the authenticated EU bountiful sea friend area (`MAP_FRIEND_AREA_BOUNTIFUL_SEA`; map ID 105, map-file ID 106). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b16p02c.rsground` (`e13c21ba5d13581a4ebed95a9b8169c3c5e5f3723b2d2adf7c4aa121df0d58f8`) and `Content/Tile/b16p02c_Base.tile` (`97281c94a0674c9a2b9d694b18382573eb21bc0ffa0372a8634d3201b8dbe164`), inserted one zone entry after `b16p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
