# b12p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b12p01c` is the authenticated EU basic cubone rescue team base interior (`MAP_TEAM_BASE_INSIDE_CUBONE_BASIC`; map ID 78, map-file ID 79). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b12p01c.rsground` (`0c8dadff5ef13798abbd8825d0b5701fe70933a42ce896c692a9a842e5835aad`) and `Content/Tile/b12p01c_Base.tile` (`ce807381860336ed36eec49d4c11f3d42709a3a7e521589cef4e3cb6445a9751`), inserted one zone entry after `b12p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
