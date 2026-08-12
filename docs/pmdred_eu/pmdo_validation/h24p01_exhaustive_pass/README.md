# h24p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h24p01` is the authenticated EU ice floe beach friend area (`MAP_FRIEND_AREA_ICE_FLOE_BEACH`; map ID 153, map-file ID 161). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h24p01.rsground` (`fbf53ddd35a0f25115fe11b4e357369b4c7fc77afab42c92ee85b444e4e7d9ad`) and `Content/Tile/h24p01_Base.tile` (`6866326a3933bdc01fc8177918b3c5ab11a7241de0290f1b4efd342e83bcf7c4`). Promotion inserted one zone entry after `h23p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
