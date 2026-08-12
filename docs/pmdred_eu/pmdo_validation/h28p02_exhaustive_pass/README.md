# h28p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h28p02` is the authenticated EU legendary island friend area (`MAP_FRIEND_AREA_LEGENDARY_ISLAND`; map ID 158, map-file ID 166). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h28p02.rsground` (`0768871862cd19a8752191cbbacc8e4b8eb655fcfd5cab04427d11136598edda`) and `Content/Tile/h28p02_Base.tile` (`d5d108438713b76bc2b8e262c84f9d0692e89ec0597cbc92c5fa68d35cac54c5`). Promotion inserted one zone entry after `h28p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
