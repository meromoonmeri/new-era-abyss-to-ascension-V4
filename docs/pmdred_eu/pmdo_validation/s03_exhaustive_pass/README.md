# s03 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s03` is the authenticated EU intro scene (`MAP_INTRO`; map ID 234, map-file ID 243). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **257/257** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 256 primary boundary ticks (0–767) cover every applicable animation schedule through two complete local cycles (maximum 384 ticks); 23 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s03.rsground` (`bdc56155688944d5861f33f72e8b76fc08b6c5c8d341c440cb1c181ed271aa82`) and `Content/Tile/s03_Base.tile` (`f83eec868021876d0e198d39c5c40ca1b9743a3fdd130e634e8905ad1f985c81`). Zone integration one insertion after s02_spa without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
