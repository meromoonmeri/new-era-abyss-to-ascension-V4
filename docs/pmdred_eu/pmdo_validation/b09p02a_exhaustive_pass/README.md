# b09p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p02a` is the authenticated EU construction charmander rescue team base interior (`MAP_TEAM_BASE_INSIDE_CHARMANDER_CONSTRUCTION`; map ID 61, map-file ID 62). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **1561/1561** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1560 primary boundary ticks (0–3359) cover every applicable animation schedule through two complete local cycles (maximum 1680 ticks); 36 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b09p02a.rsground` (`199a1846af2b159cc4e701d41538784226a552f00ac36b891fdd2900e6e76c4f`) and `Content/Tile/b09p02a_Base.tile` (`9706a7b3404e05ba899ea5ff8282252c5c3e8a9569a8b8335676d72a4da4dbf0`), inserted one zone entry after `b09p01c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
