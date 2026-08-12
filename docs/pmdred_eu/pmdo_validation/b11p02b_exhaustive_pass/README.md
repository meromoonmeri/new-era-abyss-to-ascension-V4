# b11p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b11p02b` is the authenticated EU final cyndaquil rescue team base interior (`MAP_TEAM_BASE_INSIDE_CYNDAQUIL_FINAL`; map ID 74, map-file ID 75). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **1561/1561** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1560 primary boundary ticks (0–3359) cover every applicable animation schedule through two complete local cycles (maximum 1680 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b11p02b.rsground` (`917ec49d2f31225777b8d76a3497ddb12b614b246a762cec6210c7b6a4dd67b4`) and `Content/Tile/b11p02b_Base.tile` (`de77a991e96498b3f1d7a714107a8f74a226e395f71ced915adbb811c736dab7`), inserted one zone entry after `b11p02a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
