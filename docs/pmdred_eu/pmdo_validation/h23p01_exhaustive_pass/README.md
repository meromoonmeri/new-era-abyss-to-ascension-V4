# h23p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h23p01` is the authenticated EU frigid cavern friend area (`MAP_FRIEND_AREA_FRIGID_CAVERN`; map ID 152, map-file ID 160). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **117/117** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 116 primary boundary ticks (0–405) cover every applicable animation schedule through two complete local cycles (maximum 203 ticks); 29 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h23p01.rsground` (`e612364a18cdbf0c3b75ddb6fd6b0d6f1223a21a0aae02e06188ce47ded274fc`) and `Content/Tile/h23p01_Base.tile` (`7f8fe39ceb8f48658e7d195f2552d898837592ac70377e980bc3a90630ac17ae`). Promotion inserted one zone entry after `h22p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
