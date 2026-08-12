# b03p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p01c` is the authenticated EU basic eevee rescue team base interior (`MAP_TEAM_BASE_INSIDE_EEVEE_BASIC`; map ID 24, map-file ID 25). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **67/67** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 66 primary boundary ticks (0–191) cover every applicable animation schedule through two complete local cycles (maximum 96 ticks); 37 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b03p01c.rsground` (`b478905d1321cdc3f01c49c04dc99cb6f79f26c3518a874ea6be6103395a9426`) and `Content/Tile/b03p01c_Base.tile` (`1441dd9d579b9778c2d98e8e43e20272537399152d66db1fc0ad38bdb90f0e56`), inserted one zone entry after `b03p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
