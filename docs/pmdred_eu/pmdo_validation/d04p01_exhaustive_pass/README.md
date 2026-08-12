# d04p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d04p01` is the authenticated EU mt thunder midpoint ground (`MAP_MT_THUNDER_MID`; map ID 189, map-file ID 198). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d04p01.rsground` (`c6938c3ebc82f3e3332553ecdcef9ef808283f41f1a78584bfb1e28eb675f4f0`) and `Content/Tile/d04p01_Base.tile` (`b879546cf2a0784f94905ec98836dac480bf009291c6a97f7d218884554ae00d`). Zone integration one insertion after d03p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
