# b03p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p02c` is the authenticated EU basic skitty rescue team base exterior (`MAP_TEAM_BASE_SKITTY_BASIC`; map ID 27, map-file ID 28). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b03p02c.rsground` (`a386e03bbbac02882c2a1fa109cb5b62cff896eddd68e3c3cc04c0e67e3c551a`) and `Content/Tile/b03p02c_Base.tile` (`ad1ffe29272457999ae976b16b5d447183fbf83b4d09bb4f508e1d097f37f142`), inserted one zone entry after `b03p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
