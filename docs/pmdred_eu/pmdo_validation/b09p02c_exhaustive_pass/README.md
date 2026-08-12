# b09p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b09p02c` is the authenticated EU basic torchic rescue team base exterior (`MAP_TEAM_BASE_TORCHIC_BASIC`; map ID 63, map-file ID 64). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **59/59** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 58 primary boundary ticks (0–159) cover every applicable animation schedule through two complete local cycles (maximum 80 ticks); 27 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b09p02c.rsground` (`c64ac06556de2c2550be06e198d4f429aa6f68493c874dd203cbb849a19aff43`) and `Content/Tile/b09p02c_Base.tile` (`a6aef8ccf4a4ababbfe2c698c453a5a922f939d5b3de69b2d421d13ae9f790df`), inserted one zone entry after `b09p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
