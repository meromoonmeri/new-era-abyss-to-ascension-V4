# b02p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p01c` is the authenticated EU basic meowth rescue team base interior (`MAP_TEAM_BASE_INSIDE_MEOWTH_BASIC`; map ID 18, map-file ID 19). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **67/67** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 66 primary boundary ticks (0–191) cover every applicable animation schedule through two complete local cycles (maximum 96 ticks); 37 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b02p01c.rsground` (`dd04e5f2a37629c087d709209965204b2164c40276d9aedc8a33d45bebb8a744`) and `Content/Tile/b02p01c_Base.tile` (`0cb36c93b111d3def5fb46bd355a6ac9fedda9482725d6b82fcb9de3b342bbe8`), inserted one zone entry after `b02p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
