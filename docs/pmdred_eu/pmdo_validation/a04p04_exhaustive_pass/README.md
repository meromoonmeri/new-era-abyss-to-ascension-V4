# a04p04 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a04p04` is the authenticated EU night sky scene 1 (`MAP_NIGHT_SKY_1`; map ID 175, map-file ID 184). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a04p04.rsground` (`bd11eb579038a7edb165b3a3e3431207e8a7c049c29244f9891b559b1c07ef82`) and `Content/Tile/a04p04_Base.tile` (`73b12eb18692df73095cb580c78ba581da23e414c38493b99f040641f32abb75`). Zone integration one insertion after a04p03 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
