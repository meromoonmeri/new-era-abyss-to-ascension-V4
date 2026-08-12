# h11p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h11p01` is the authenticated EU poison swamp friend area (`MAP_FRIEND_AREA_POISON_SWAMP`; map ID 136, map-file ID 142). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **49/49** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 48 primary boundary ticks (0–215) cover every applicable animation schedule through two complete local cycles (maximum 108 ticks); 12 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h11p01.rsground` (`04ea01cb7c42d95b0297592fc1a748742494e663d615b1be52e4eb07acb23d07`) and `Content/Tile/h11p01_Base.tile` (`fc86684f7b08b2ff83b55f641117219cbb78f7079393933cdb4ecb9bbe0540a4`), inserted one zone entry after `h10p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
