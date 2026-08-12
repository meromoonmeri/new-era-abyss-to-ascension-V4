# a05p03f exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a05p03f` is the authenticated EU thunderwave cave entry ground (`MAP_THUNDERWAVE_CAVE_ENTRY`; map ID 180, map-file ID 189). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a05p03f.rsground` (`cde4df3fc3f501d68a28048e5c539953c1e2185d3b72954f96fda3bee776f4dd`) and `Content/Tile/a05p03f_Base.tile` (`c09c12bb5cae283dea4e4a6edbf98e201be37986faedfb9f5abed7e93cd1b830`). Zone integration one insertion after a05p03g without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
