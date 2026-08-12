# h25p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h25p01` is the authenticated EU volcanic pit friend area (`MAP_FRIEND_AREA_VOLCANIC_PIT`; map ID 154, map-file ID 162). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **129/129** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 128 primary boundary ticks (0–255) cover every applicable animation schedule through two complete local cycles (maximum 128 ticks); 49 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h25p01.rsground` (`976ce9e46aa537fdc99fbaf7c4af74cdeb00301a9a29a81077142a59aeae0aec`) and `Content/Tile/h25p01_Base.tile` (`a243627bbb4cefb94a867d0a7b54c5a18e8b58956e12cf840dbe4b99abeae9b8`). Promotion inserted one zone entry after `h24p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
