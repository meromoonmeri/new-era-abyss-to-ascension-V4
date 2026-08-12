# b13p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b13p01c` is the authenticated EU basic machop rescue team base interior (`MAP_TEAM_BASE_INSIDE_MACHOP_BASIC`; map ID 84, map-file ID 85). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b13p01c.rsground` (`a9ac7d252ee9d9034006f278363e8c9de8aff213c28c28f3313456d711a4c78a`) and `Content/Tile/b13p01c_Base.tile` (`2da9141d73b058e9f54976d7c9925e0e90a4ed33ef82c5c9aa5cbf6c313de757`), inserted one zone entry after `b13p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
