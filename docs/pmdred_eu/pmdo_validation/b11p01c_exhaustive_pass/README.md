# b11p01c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b11p01c` is the authenticated EU basic cyndaquil rescue team base interior (`MAP_TEAM_BASE_INSIDE_CYNDAQUIL_BASIC`; map ID 72, map-file ID 73). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **25/25** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 24 primary boundary ticks (0–83) cover every applicable animation schedule through two complete local cycles (maximum 42 ticks); 6 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b11p01c.rsground` (`aa141d62abb713a588a5cb2e54a298d5c1d781ee693ded99a251dfc8017abfbf`) and `Content/Tile/b11p01c_Base.tile` (`151b4962b6cb0a2b3443406dcdde5e67707e6fb216cc860a03615d0892fa2c94`), inserted one zone entry after `b11p01b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
