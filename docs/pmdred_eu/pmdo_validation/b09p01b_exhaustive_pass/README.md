# b09p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p01b` is the authenticated EU final charmander rescue team base exterior (`MAP_TEAM_BASE_CHARMANDER_FINAL`; map ID 59, map-file ID 60). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b09p01b.rsground` (`575e7a7245f44197e2a8e2d82c32c93efcc70499c2eb93385993067ca9c95a64`) and `Content/Tile/b09p01b_Base.tile` (`ad3712dd43e2f934c89e818b77a278d6aea2cac7bcecdaf5f7a8be338591fc7b`), inserted one zone entry after `b09p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
