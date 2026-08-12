# h09p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h09p02` is the authenticated EU mystic lake friend area (`MAP_FRIEND_AREA_MYSTIC_LAKE`; map ID 133, map-file ID 139). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2721/2721** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 2720 primary boundary ticks (0–8159) cover every applicable animation schedule through two complete local cycles (maximum 4080 ticks); 40 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h09p02.rsground` (`0b76a050c28d5c9046de2931c9ab5d3a88a0a6b9aefe3e048f2d3cbb56ae9685`) and `Content/Tile/h09p02_Base.tile` (`521054dc3d97216193decc898d899952c15375c8ea8c199955f5eb7b29af076e`), inserted one zone entry after `h09p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
