# a05p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a05p02` is the authenticated EU the end screen (`MAP_THE_END`; map ID 177, map-file ID 186). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **9/9** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 8 primary boundary ticks (0–15) cover every applicable animation schedule through two complete local cycles (maximum 8 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a05p02.rsground` (`17750d5ab3f6db0e0f5544ea93cda61358d0ce1d86f5a726d276529fad953335`) and `Content/Tile/a05p02_Base.tile` (`cd697ec328cb37d619c7d5d3e4cc795ba8f9f9c94a5dec050babd0f13f2f0a93`). Zone integration one insertion after a05p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
