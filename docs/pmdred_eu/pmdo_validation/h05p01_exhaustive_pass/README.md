# h05p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h05p01` is the authenticated EU rainbow peak friend area (`MAP_FRIEND_AREA_RAINBOW_PEAK`; map ID 115, map-file ID 120). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **81/81** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 80 primary boundary ticks (0–399) cover every applicable animation schedule through two complete local cycles (maximum 200 ticks); 12 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h05p01.rsground` (`c7361ba85bd167ea696feea158c1f2526f0876e4196a99a481653d456f6abbfe`) and `Content/Tile/h05p01_Base.tile` (`2ce7c74ffac5022643165ec5beb6176704de29b563218bac2fc909848d899c90`), inserted one zone entry after `h04p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
