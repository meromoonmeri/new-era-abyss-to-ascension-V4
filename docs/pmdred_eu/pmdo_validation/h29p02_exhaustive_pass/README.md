# h29p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h29p02` is the authenticated EU enclosed island friend area (`MAP_FRIEND_AREA_ENCLOSED_ISLAND`; map ID 160, map-file ID 168). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **3277/3277** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 3276 primary boundary ticks (0–7055) cover every applicable animation schedule through two complete local cycles (maximum 3528 ticks); 1186 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h29p02.rsground` (`ebdd35834ca870c56efaa054149a2d9165b79028e3a1a45ee48f3252a81a93ed`) and `Content/Tile/h29p02_Base.tile` (`24f86c9b3ffbacee915bee76e0f3aacb3ad9f0b678e93d4050e484766b83b196`). Promotion inserted one zone entry after `h29p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
