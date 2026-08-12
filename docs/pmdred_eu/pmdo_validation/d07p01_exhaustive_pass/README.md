# d07p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d07p01` is the authenticated EU mt blaze midpoint ground (`MAP_MT_BLAZE_MID`; map ID 196, map-file ID 205). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d07p01.rsground` (`5dfbaac562d870a81e4df4523b336e2c45d0573d128b921d833de7a4995a304f`) and `Content/Tile/d07p01_Base.tile` (`aad06c8cebb4c28b22c8954111a6d26e266601d8d1c0c1a2cc797f0079b09fed`). Zone integration one insertion after d06p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
