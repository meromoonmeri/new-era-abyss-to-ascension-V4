# h29p03 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h29p03` is the authenticated EU final island friend area (`MAP_FRIEND_AREA_FINAL_ISLAND`; map ID 161, map-file ID 169). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **1009/1009** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1008 primary boundary ticks (0–2015) cover every applicable animation schedule through two complete local cycles (maximum 1008 ticks); 44 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h29p03.rsground` (`b583321d1d543d8921d0dc0b969e653b245fb9d08ca4b02c62350ee4b0510d5b`) and `Content/Tile/h29p03_Base.tile` (`f81d9c6fdc54f2b877b00144d9605b7b7cf95ba5124890c1f602ebda8c3a3962`). Promotion inserted one zone entry after `h29p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
