# h09p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h09p01` is the authenticated EU turtleshell pond friend area (`MAP_FRIEND_AREA_TURTLESHELL_POND`; map ID 132, map-file ID 138). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **98/98** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 97 primary boundary ticks (0–383) cover every applicable animation schedule through two complete local cycles (maximum 192 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h09p01.rsground` (`b9b1e3c83e02756de51c6d3914f80c4ee508264a650ece8db2f8736953acb3b5`) and `Content/Tile/h09p01_Base.tile` (`10bfce2e89ddfcad7a28c2aa4bcb8c8e40f575e9bc07dde7e71753795c1deff4`), inserted one zone entry after `h08p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
