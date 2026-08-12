# b08p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p02b` is the authenticated EU final psyduck rescue team base interior (`MAP_TEAM_BASE_INSIDE_PSYDUCK_FINAL`; map ID 56, map-file ID 57). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **481/481** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 480 primary boundary ticks (0–1919) cover every applicable animation schedule through two complete local cycles (maximum 960 ticks); 233 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b08p02b.rsground` (`c3b06a21afd3d3a87e7e752d006838e6bd611e80c147a60f65f514d07e1c741d`) and `Content/Tile/b08p02b_Base.tile` (`dea8e4f2bb697348525eee8629b920d7a7f0cee45c607704099c99761f0256a4`), inserted one zone entry after `b08p02a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
