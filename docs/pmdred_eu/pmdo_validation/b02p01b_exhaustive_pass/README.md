# b02p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b02p01b` is the authenticated EU final meowth rescue team base exterior (`MAP_TEAM_BASE_MEOWTH_FINAL`; map ID 17, map-file ID 18). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b02p01b.rsground` (`56ff8d17e40fda1739530a95a453a3aeb21aba4f70ef6d05f4854fdecb9f2cd7`) and `Content/Tile/b02p01b_Base.tile` (`7355317e5fb617763b1f28ef578cb175ba7b9b95bdf49ce63708e3b2f7c26530`), inserted one zone entry after `b02p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
