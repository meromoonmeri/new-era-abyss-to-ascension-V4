# b01p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b01p01c` is the authenticated EU basic pikachu rescue team base interior (`MAP_TEAM_BASE_INSIDE_PIKACHU_BASIC`; map ID 12, map-file ID 13). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **67/67** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 66 primary boundary ticks (0–191) cover every applicable animation schedule through two complete local cycles (maximum 96 ticks); 37 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b01p01c.rsground` (`25ed1c8ec607c839f05e7d4702164ed44f5abef32ec0c2b094ee7c61812e0a9f`) and `Content/Tile/b01p01c_Base.tile` (`7b998782764c4c2f48eb2db9ab391ab63cb5dd5ffcaab38599ced5ea7f19a1c2`), inserted one zone entry after `b01p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
