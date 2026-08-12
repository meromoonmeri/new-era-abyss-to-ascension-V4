# s05_spa exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s05_spa` is the authenticated EU logo warning screen (`MAP_LOGO_WARNING`; map ID 240, map-file ID 249). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s05_spa.rsground` (`2d7416d93cf59bfa5526a50c70738fbdad8d2ba6848662327e841c85c4df134a`) and `Content/Tile/s05_spa_Base.tile` (`87ccbab6933311ed55b3fbf7febce75c4e2e2d18fbe53dc1f007e5a2d5f09230`). Zone integration one insertion after s05_ita without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
