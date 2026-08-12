# s02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s02` is the authenticated EU title screen (`MAP_TITLE_SCREEN`; map ID 229, map-file ID 238). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s02.rsground` (`ead4241fea20e55a895a6aa7293ca2d06dae256d3bf67f3cc063cad5036bb8e8`) and `Content/Tile/s02_Base.tile` (`265794b0515744a44988996915a2b29968cdeed640a74f801a4295f902f6cb55`). Zone integration one insertion after s01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
