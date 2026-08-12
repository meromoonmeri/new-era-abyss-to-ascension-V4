# s05_fre exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s05_fre` is the authenticated EU logo warning screen (`MAP_LOGO_WARNING`; map ID 238, map-file ID 247). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s05_fre.rsground` (`9ea10fe451726313d93c95fc1336b07558cb0123e59561434c1cee2c487af86d`) and `Content/Tile/s05_fre_Base.tile` (`7711a4b289d5923f6f5f4cd1f7d56aac79e0b0d35db2ece82bd5ca150f3d977f`). Zone integration one insertion after s05_ger without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
