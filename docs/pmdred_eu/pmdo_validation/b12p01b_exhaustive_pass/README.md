# b12p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b12p01b` is the authenticated EU final cubone rescue team base exterior (`MAP_TEAM_BASE_CUBONE_FINAL`; map ID 77, map-file ID 78). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b12p01b.rsground` (`f19ed32128f515fba1e88c455d6d6fc108464a5e79febbb13e1866b51475ad3a`) and `Content/Tile/b12p01b_Base.tile` (`516511d98fedb769f141f7b21ba9149d559d485cd51f584adad2280a23fa954d`), inserted one zone entry after `b12p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
