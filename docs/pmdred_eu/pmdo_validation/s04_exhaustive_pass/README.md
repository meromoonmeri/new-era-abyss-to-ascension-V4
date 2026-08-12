# s04 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`s04` is the authenticated EU pokemon company logo screen (`MAP_LOGO_POKEMON_COMPANY`; map ID 235, map-file ID 244). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/s04.rsground` (`fe2706f208ae738a0d252e3199bf888d9ed86a52beed253902d651be2b3b633d`) and `Content/Tile/s04_Base.tile` (`a88590a282cfd116177d60e0dc828ea2e620e491a7838830c4fc708224b41bc4`). Zone integration one insertion after s03 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
