# h07p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h07p01` is the authenticated EU flyaway forest friend area (`MAP_FRIEND_AREA_FLYAWAY_FOREST`; map ID 123, map-file ID 128). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **121/121** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 120 primary boundary ticks (0–239) cover every applicable animation schedule through two complete local cycles (maximum 120 ticks); 19 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h07p01.rsground` (`a1452f4b6dd0a78adb6344e79460e20b1066bc3beaaa188d3c2a53494a822fa5`) and `Content/Tile/h07p01_Base.tile` (`420413fcafc49a434058dba0cd6021c9e3c6ac82687695e9f5de3fa5c0f3b15d`), inserted one zone entry after `h06p06` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
