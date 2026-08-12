# b04p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01b` is the authenticated EU final skitty rescue team base exterior (`MAP_TEAM_BASE_SKITTY_FINAL`; map ID 29, map-file ID 30). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b04p01b.rsground` (`38fed8453dd3b4e958575dc595e1a5b117e62de85100abde62f94662584899e2`) and `Content/Tile/b04p01b_Base.tile` (`917e0ffa07eced179eda7e362ca75a3f6aa53a877752b728cc86009300d5e4a1`), inserted one zone entry after `b04p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
