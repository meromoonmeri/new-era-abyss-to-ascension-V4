# d02p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d02p01` is the authenticated EU sinister woods end ground (`MAP_SINISTER_WOODS_END`; map ID 185, map-file ID 194). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d02p01.rsground` (`e9ce13b63db26790d4b6e3ef4e1f8fb48684aefdcc752ada1293bda80f35da70`) and `Content/Tile/d02p01_Base.tile` (`b3326c75641f4b9800e78911e7b512de431f708a335ba15a0df68b3849bd25b6`). Zone integration one insertion after d01p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
