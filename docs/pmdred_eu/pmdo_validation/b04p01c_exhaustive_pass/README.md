# b04p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b04p01c` is the authenticated EU basic skitty rescue team base interior (`MAP_TEAM_BASE_INSIDE_SKITTY_BASIC`; map ID 30, map-file ID 31). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **67/67** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, state isolation, and terminal `end` all passed.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 66 primary boundary ticks (0–191) cover every applicable animation schedule through two complete local cycles (maximum 96 ticks); 37 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b04p01c.rsground` (`301106a61d582b0406ca1117a11f5252c87ac78cc737797696156fad886c1aab`) and `Content/Tile/b04p01c_Base.tile` (`ab0fecd3745354fa2cef6cc3ac009023617549e62b7215be77599b554c121c25`), inserted one zone entry after `b04p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
