# d12p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d12p01` is the authenticated EU sky tower end ground (`MAP_SKY_TOWER_END`; map ID 209, map-file ID 218). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **225/225** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 224 primary boundary ticks (0–1007) cover every applicable animation schedule through two complete local cycles (maximum 504 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d12p01.rsground` (`b9db0e2c99fcb3491e55bf4ea05378ad7820c228ae4a42e640ef8a05e0376d26`) and `Content/Tile/d12p01_Base.tile` (`5a51688f7f54d91488f8ee2d6d1f00ab2dfb1d30249cb6a83e2f0449e0aec76e`). Zone integration one insertion after d11p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
