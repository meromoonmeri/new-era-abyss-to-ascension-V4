# b06p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p01c` is the authenticated EU basic totodile rescue team base interior (`MAP_TEAM_BASE_INSIDE_TOTODILE_BASIC`; map ID 42, map-file ID 43). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **51/51** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 50 primary boundary ticks (0–127) cover every applicable animation schedule through two complete local cycles (maximum 64 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b06p01c.rsground` (`3825ed3f36959a7ef70a2ca84dc410536d8dd3543d458172cdf7daaaae60f23b`) and `Content/Tile/b06p01c_Base.tile` (`2398db32660589463a0b9212e4ffe7ada44e80f2d9481488a50679c98c81935a`), inserted one zone entry after `b06p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
