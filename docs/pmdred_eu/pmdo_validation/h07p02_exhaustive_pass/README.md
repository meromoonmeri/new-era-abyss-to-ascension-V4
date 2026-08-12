# h07p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h07p02` is the authenticated EU overgrown forest friend area (`MAP_FRIEND_AREA_OVERGROWN_FOREST`; map ID 124, map-file ID 129). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **33/33** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 32 primary boundary ticks (0–95) cover every applicable animation schedule through two complete local cycles (maximum 48 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h07p02.rsground` (`569848c346b09531a892d5672b0738d7a00bc23632ba712c87c4d573cac2348a`) and `Content/Tile/h07p02_Base.tile` (`d479ac29fa1dced7fb092eaa509156504f23714c8a5de1a76bef79c7debb8247`), inserted one zone entry after `h07p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
