# b06p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01b` is the authenticated EU final totodile rescue team base exterior (`MAP_TEAM_BASE_TOTODILE_FINAL`; map ID 41, map-file ID 42). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **51/51** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 50 primary boundary ticks (0–127) cover every applicable animation schedule through two complete local cycles (maximum 64 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b06p01b.rsground` (`fe503070fcb328563aa1275c9a617a4ab55360e2438e97073be91c189d3fda4d`) and `Content/Tile/b06p01b_Base.tile` (`0920e12315134ad5827e5e147746f2d413e79eaf112eafd90fd98910d12a1042`), inserted one zone entry after `b06p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
