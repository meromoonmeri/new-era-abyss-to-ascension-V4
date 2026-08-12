# d09p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d09p01` is the authenticated EU frosty forest end ground (`MAP_FROSTY_FOREST_END`; map ID 200, map-file ID 209). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–71) cover every applicable animation schedule through two complete local cycles (maximum 36 ticks); 4 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d09p01.rsground` (`caab96b8bda330d0339ca5b905e195b5713dfad7addce37ccae2feee043e8a9b`) and `Content/Tile/d09p01_Base.tile` (`71fb57ca94187b2924419998c809c6588849ab53c376cc7dae7310c476e88aac`). Zone integration one insertion after d08p02 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
