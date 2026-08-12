# b13p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b13p02b` is the authenticated EU final machop rescue team base interior (`MAP_TEAM_BASE_INSIDE_MACHOP_FINAL`; map ID 86, map-file ID 87). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b13p02b.rsground` (`28ebd8a9c6307d9db258c4c114969465cb00d1be731b3cf87f38f988b39a598b`) and `Content/Tile/b13p02b_Base.tile` (`47a9022017af4fa5b9b1dad3144488376961ca40c0d658a99dd0b3818d7f2081`), inserted one zone entry after `b13p02a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
