# h01p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h01p02` is the authenticated EU serene sea friend area (`MAP_FRIEND_AREA_SERENE_SEA`; map ID 107, map-file ID 109). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h01p02.rsground` (`0f9a816363eff20e529f9e19b3abad72e8cd3cdc20d47af352c824fc3ac49808`) and `Content/Tile/h01p02_Base.tile` (`d19b1fa8d9149f1d19ecb9707967ef2129d931b46d8fa81ad6c78bd9859c7c31`), inserted one zone entry after `h01p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
