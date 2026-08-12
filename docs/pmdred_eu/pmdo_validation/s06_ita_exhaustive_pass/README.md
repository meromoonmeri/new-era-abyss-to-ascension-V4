# s06_ita exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s06_ita` is the authenticated EU rescue team base wall map screen (`MAP_TEAM_BASE_WALL_MAP`; map ID 244, map-file ID 253). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s06_ita.rsground` (`d126ff2acca3b01f8b4d0e2861957638f35edf33adaf12af0ca1a0b42d9c7b89`) and `Content/Tile/s06_ita_Base.tile` (`0aa929ba4e8bd668f76b4ec1050f949e56d4ccea5ff6f5e96d86e079593e0e71`). Zone integration one insertion after s06_fre without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
