# s05_ita exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s05_ita` is the authenticated EU logo warning screen (`MAP_LOGO_WARNING`; map ID 239, map-file ID 248). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s05_ita.rsground` (`4be05b21fa7fa7aff1888ef3d3bf702cc50fee4ccc430f5cab6247ed29ff6230`) and `Content/Tile/s05_ita_Base.tile` (`e29dce413b0fb52bc3f6cfb33dbe4de0142ef3ad68b2ebb69ddad2b313d93b0b`). Zone integration one insertion after s05_fre without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
