# b11p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b11p02c` is the authenticated EU basic cubone rescue team base exterior (`MAP_TEAM_BASE_CUBONE_BASIC`; map ID 75, map-file ID 76). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **59/59** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 58 primary boundary ticks (0–159) cover every applicable animation schedule through two complete local cycles (maximum 80 ticks); 27 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b11p02c.rsground` (`d51289943319760998767e9e90612cd3c379f3e154450d901a6de4d979e02118`) and `Content/Tile/b11p02c_Base.tile` (`a6aef8ccf4a4ababbfe2c698c453a5a922f939d5b3de69b2d421d13ae9f790df`), inserted one zone entry after `b11p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
