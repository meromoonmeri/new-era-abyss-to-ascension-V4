# a05p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a05p01` is the authenticated EU night sky scene 2 (`MAP_NIGHT_SKY_2`; map ID 176, map-file ID 185). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **9121/9121** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 9120 primary boundary ticks (0–15959) cover every applicable animation schedule through two complete local cycles (maximum 7980 ticks); 228 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a05p01.rsground` (`a42bde3b9b871577c24dc78fd266a46c13747b44f9692b0ce2821795be0db5ab`) and `Content/Tile/a05p01_Base.tile` (`650f8c1b67fad28c0f0059a45c57a2969ec0761ddf1e6f709e618c359a02944e`). Zone integration one insertion after a04p04 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
