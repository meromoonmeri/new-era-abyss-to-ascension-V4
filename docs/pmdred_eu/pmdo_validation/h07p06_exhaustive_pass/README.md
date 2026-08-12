# h07p06 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h07p06` is the authenticated EU transform forest friend area (`MAP_FRIEND_AREA_TRANSFORM_FOREST`; map ID 128, map-file ID 134). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **3969/3969** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 3968 primary boundary ticks (0–5951) cover every applicable animation schedule through two complete local cycles (maximum 2976 ticks); 884 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h07p06.rsground` (`b1a98703249f4b8e2c3a2ba4255974233d7b485154d6f46bdf87f57c73d8c716`) and `Content/Tile/h07p06_Base.tile` (`ead28eca3757aadc2786d669b0bfc9872ad5af13de66cb302de94d6e3113e81d`), inserted one zone entry after `h07p05` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
