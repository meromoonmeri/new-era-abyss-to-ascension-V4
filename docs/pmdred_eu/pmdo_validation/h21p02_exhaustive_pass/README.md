# h21p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h21p02` is the authenticated EU ancient relic friend area (`MAP_FRIEND_AREA_ANCIENT_RELIC`; map ID 150, map-file ID 158). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **85/85** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 84 primary boundary ticks (0–419) cover every applicable animation schedule through two complete local cycles (maximum 210 ticks); 14 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h21p02.rsground` (`7d0a5fef8dcd26bb2d1d06d9ffdb2d4fd5f859c88fe20cce1feef54df442a17e`) and `Content/Tile/h21p02_Base.tile` (`9d935b5dc97260d47b4ff6a90bfd1e4e3532dcff8cd72379f80e53e5f0f20f8c`). Promotion inserted one zone entry after `h21p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
