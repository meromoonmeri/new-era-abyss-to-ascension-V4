# h22p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h22p01` is the authenticated EU darkness ridge friend area (`MAP_FRIEND_AREA_DARKNESS_RIDGE`; map ID 151, map-file ID 159). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **73/73** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 72 primary boundary ticks (0–215) cover every applicable animation schedule through two complete local cycles (maximum 108 ticks); 18 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h22p01.rsground` (`851b9ba6bb9a41d966f363937c79aa0d028dd3ac113377332bd5ca12de84f8d9`) and `Content/Tile/h22p01_Base.tile` (`2a8b85c396ea7af1ed60f2bfb077e12381873e7d4d021a027a86ac77e1b2b5e5`). Promotion inserted one zone entry after `h21p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
