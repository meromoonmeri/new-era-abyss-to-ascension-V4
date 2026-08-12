# h03p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h03p01` is the authenticated EU mt deepgreen friend area (`MAP_FRIEND_AREA_MT_DEEPGREEN`; map ID 112, map-file ID 117). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **257/257** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 256 primary boundary ticks (0–767) cover every applicable animation schedule through two complete local cycles (maximum 384 ticks); 109 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h03p01.rsground` (`a087193b5ebde6b33a779a83c3321736624c7fb4f83f628365d68fc441b2d141`) and `Content/Tile/h03p01_Base.tile` (`20056a610fa0699ffa9dd4d5c63ca2b368fdd272f96b51f543948d65454ee39e`), inserted one zone entry after `h02p03` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
