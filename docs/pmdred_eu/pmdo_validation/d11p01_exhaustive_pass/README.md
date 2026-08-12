# d11p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d11p01` is the authenticated EU magma cavern end ground (`MAP_MAGMA_CAVERN_END`; map ID 206, map-file ID 215). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **105/105** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 104 primary boundary ticks (0–311) cover every applicable animation schedule through two complete local cycles (maximum 156 ticks); 26 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d11p01.rsground` (`ccfb212c50200f3a7a8f35f34b0549697a170df86306574f05b0560acae95a0e`) and `Content/Tile/d11p01_Base.tile` (`7481e0fd69b1accfbee0fc04b164ad7368551d9b3f38cdd6e6b44c8e3375cf69`). Zone integration one insertion after d10p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
