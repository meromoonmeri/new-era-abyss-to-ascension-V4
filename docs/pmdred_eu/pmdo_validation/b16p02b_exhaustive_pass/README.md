# b16p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b16p02b` is the authenticated EU final treecko rescue team base interior (`MAP_TEAM_BASE_INSIDE_TREECKO_FINAL`; map ID 104, map-file ID 105). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b16p02b.rsground` (`6e8364af902f8015a4a989025fe7fa3e7ad16fd3ae657b0ede7c6ec173c7784b`) and `Content/Tile/b16p02b_Base.tile` (`8d2e7705b4c019e93f0fbee409aefcb63ee099f164cb9be120c688e4adbb0350`), inserted one zone entry after `b16p02a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
