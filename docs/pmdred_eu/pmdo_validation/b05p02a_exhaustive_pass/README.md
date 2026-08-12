# b05p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b05p02a` is the authenticated EU construction squirtle rescue team base interior (`MAP_TEAM_BASE_INSIDE_SQUIRTLE_CONSTRUCTION`; map ID 37, map-file ID 38). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **481/481** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 480 primary boundary ticks (0–1919) cover every applicable animation schedule through two complete local cycles (maximum 960 ticks); 233 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b05p02a.rsground` (`5f76d3decc993635843a55cdc50fed1986db45c146d9612c453a7f57c36e0832`) and `Content/Tile/b05p02a_Base.tile` (`1387a0495a57cc1f7e07baf995632054b4a0e71329ef099ce5e65fb0def38e46`), inserted one zone entry after `b05p01c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
