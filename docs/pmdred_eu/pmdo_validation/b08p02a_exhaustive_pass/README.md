# b08p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b08p02a` is the authenticated EU construction psyduck rescue team base interior (`MAP_TEAM_BASE_INSIDE_PSYDUCK_CONSTRUCTION`; map ID 55, map-file ID 56). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **481/481** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 480 primary boundary ticks (0–1919) cover every applicable animation schedule through two complete local cycles (maximum 960 ticks); 233 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b08p02a.rsground` (`8fcc0e9bfea0139fc9fee6b76cb9d37dedfee84d8ae1fef26d5bc89cafadd42b`) and `Content/Tile/b08p02a_Base.tile` (`1387a0495a57cc1f7e07baf995632054b4a0e71329ef099ce5e65fb0def38e46`), inserted one zone entry after `b08p01c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
