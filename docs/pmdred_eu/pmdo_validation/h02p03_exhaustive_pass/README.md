# h02p03 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h02p03` is the authenticated EU shallow beach friend area (`MAP_FRIEND_AREA_SHALLOW_BEACH`; map ID 111, map-file ID 115). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **93/93** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 92 primary boundary ticks (0–275) cover every applicable animation schedule through two complete local cycles (maximum 138 ticks); 18 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h02p03.rsground` (`ecef9ea2d11dcc3bca211a1e5ae49c3ba1accd472baf6b1caa1682f5878d2042`) and `Content/Tile/h02p03_Base.tile` (`abd013c720d7f36034d134321211968b5f1da234c8ad63018a52b4588fb2ada9`), inserted one zone entry after `h02p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
