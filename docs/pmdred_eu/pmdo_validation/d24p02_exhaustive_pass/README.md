# d24p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d24p02` is the authenticated EU pokemon company logo screen (`MAP_LOGO_POKEMON_COMPANY`; map ID 226, map-file ID 235). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d24p02.rsground` (`a09fa1f774c0c3c22c10e012c7ea0ff69b4ca025158b4b9d324eb967e44d8dea`) and `Content/Tile/d24p02_Base.tile` (`23b276d9858db83bc1da4e17181233de867a8ce89e9436425293d8a92b727149`). Zone integration one insertion after d24p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
