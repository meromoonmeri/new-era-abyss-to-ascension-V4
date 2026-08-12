# b03p02b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b03p02b` is the authenticated EU final eevee rescue team base interior (`MAP_TEAM_BASE_INSIDE_EEVEE_FINAL`; map ID 26, map-file ID 27). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b03p02b.rsground` (`68f7dada9c4e95b8622a56aad99f2e8721088895fb055f43f1043768be6c1775`) and `Content/Tile/b03p02b_Base.tile` (`ec8f5ab4cfea9b73de418a74b4c104b3eb564386ad556a9e391e0e4f70aa6cbe`), inserted one zone entry after `b03p02a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
