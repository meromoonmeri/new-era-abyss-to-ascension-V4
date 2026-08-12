# b12p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b12p01a` is the authenticated EU construction cubone rescue team base exterior (`MAP_TEAM_BASE_CUBONE_CONSTRUCTION`; map ID 76, map-file ID 77). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b12p01a.rsground` (`e43e8d5b79ffb288c709c555f4c377bb46ca356876d5ae32b581df215e7dc9e5`) and `Content/Tile/b12p01a_Base.tile` (`9d93b72a9a99b3357136ba83f5d14dc6173e6aa72f1fb31ab96db677c970f096`), inserted one zone entry after `b11p02c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
