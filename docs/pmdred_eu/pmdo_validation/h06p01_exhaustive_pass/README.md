# h06p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h06p01` is the authenticated EU beau plains friend area (`MAP_FRIEND_AREA_BEAU_PLAINS`; map ID 117, map-file ID 122). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **361/361** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 360 primary boundary ticks (0–719) cover every applicable animation schedule through two complete local cycles (maximum 360 ticks); 17 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h06p01.rsground` (`a641e05e4cb0cb646170929c8aa7f972683680591f7bb89e53af7fd91b352f80`) and `Content/Tile/h06p01_Base.tile` (`403de7d3c7d18b44edfec6df8db05119c2004d7bad1ba77e5a05ca8511898ada`), inserted one zone entry after `h05p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
