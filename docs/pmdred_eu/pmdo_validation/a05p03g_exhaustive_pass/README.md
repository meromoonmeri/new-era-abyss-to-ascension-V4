# a05p03g exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a05p03g` is the authenticated EU tiny woods end ground (`MAP_TINY_WOODS_END`; map ID 179, map-file ID 188). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a05p03g.rsground` (`9fabeff6d18a014b63989a3044e4ff49cd7fa392a37fff48aa82163fe370d81e`) and `Content/Tile/a05p03g_Base.tile` (`70a48b8c21250e490e9ed4b7b38dcef016f67ec807f30e02eedd3aefe9d6cc89`). Zone integration one insertion after a05p03 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
