# a05p03i exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a05p03i` is the authenticated EU thunderwave cave end ground (`MAP_THUNDERWAVE_CAVE_END`; map ID 181, map-file ID 190). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a05p03i.rsground` (`19d02839cb1626f472cd07c5531d24bd4d0a899d282f9cc55de75e521280b90c`) and `Content/Tile/a05p03i_Base.tile` (`175046fecc03e2d92a7d4b3c26704a1cc5070e4ea3daac676b9032d4c2319191`). Zone integration one insertion after a05p03f without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
