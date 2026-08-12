# b02p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p02a` is the authenticated EU construction meowth rescue team base interior (`MAP_TEAM_BASE_INSIDE_MEOWTH_CONSTRUCTION`; map ID 19, map-file ID 20). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b02p02a.rsground` (`eece83208006d53e7f05b09847631d9d621563936cb862a7bd0aab2fd2447aa2`) and `Content/Tile/b02p02a_Base.tile` (`7f260e40b2e42f19f5197bac1468fdf2a9eb39aee38e50470723a1391f913e94`), inserted one zone entry after `b02p01c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
