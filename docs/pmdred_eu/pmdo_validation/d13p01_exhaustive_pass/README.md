# d13p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`d13p01` is the authenticated EU fiery field endpoint ground (`MAP_D16`; map ID 212, map-file ID 221). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **33/33** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement and blocking probes passed. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 32 primary boundary ticks (0–127) cover every applicable animation schedule through two complete local cycles (maximum 64 ticks); 7 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/d13p01.rsground` (`b38c698355225a1218310029108798e023309bc9c1b1c27fdbde4f4cb664e5f4`) and `Content/Tile/d13p01_Base.tile` (`65d558e37ce64b04503878f9ab205c7dc0822ecefa39055ea796f7513bfc4c35`). Zone integration one insertion after d12p01 without reserialization, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
