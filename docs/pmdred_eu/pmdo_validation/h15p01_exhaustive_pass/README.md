# h15p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h15p01` is the authenticated EU mt discipline friend area (`MAP_FRIEND_AREA_MT_DISCIPLINE`; map ID 143, map-file ID 149). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **209/209** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 208 primary boundary ticks (0–511) cover every applicable animation schedule through two complete local cycles (maximum 256 ticks); 175 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h15p01.rsground` (`331e9f10dd2c3437fc4c6951ef5b8025736a9196c40bb57acd82883a26fb3ac3`) and `Content/Tile/h15p01_Base.tile` (`0fa47c5a9f48508e0ee14bd9b0b3c8da42387782a526c367171ced30ba255b79`), inserted one zone entry after `h14p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
