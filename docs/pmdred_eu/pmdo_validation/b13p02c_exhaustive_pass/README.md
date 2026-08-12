# b13p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b13p02c` is the authenticated EU basic bulbasaur rescue team base exterior (`MAP_TEAM_BASE_BULBASAUR_BASIC`; map ID 87, map-file ID 88). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b13p02c.rsground` (`158b389fe3f8ef93e7bbae602812cb5bb97d3e0df4cd4289af3d48657d594a8c`) and `Content/Tile/b13p02c_Base.tile` (`c29d9fb9f2f081d216c0b49991b4e9a3287574ea7bcd9598294df20d17f4a372`), inserted one zone entry after `b13p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
