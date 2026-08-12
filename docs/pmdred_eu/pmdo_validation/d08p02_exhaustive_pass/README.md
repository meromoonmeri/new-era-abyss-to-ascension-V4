# d08p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d08p02` is the authenticated EU frosty forest midpoint ground (`MAP_FROSTY_FOREST_MID`; map ID 199, map-file ID 208). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d08p02.rsground` (`dac79313e5c4ec08f8e63e947cd90e24d828a073202639e510aecd71bb961b01`) and `Content/Tile/d08p02_Base.tile` (`94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b`). Zone integration one insertion after d08p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
