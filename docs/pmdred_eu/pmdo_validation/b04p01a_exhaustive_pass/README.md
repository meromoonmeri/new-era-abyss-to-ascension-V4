# b04p01a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01a` is the authenticated EU construction skitty rescue team base exterior (`MAP_TEAM_BASE_SKITTY_CONSTRUCTION`; map ID 28, map-file ID 29). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b04p01a.rsground` (`26ec7bf821c6c2dd997abc97e401f293ee50c45c73e144c054ccb4134104d6e9`) and `Content/Tile/b04p01a_Base.tile` (`d6a7088978d33196fab79b0285b505b84a6de86b01914033c8d0ac502fa7d4ba`), inserted one zone entry after `b03p02c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
