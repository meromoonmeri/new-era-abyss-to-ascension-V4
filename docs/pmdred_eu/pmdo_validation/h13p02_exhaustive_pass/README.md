# h13p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h13p02` is the authenticated EU dragon cave friend area (`MAP_FRIEND_AREA_DRAGON_CAVE`; map ID 139, map-file ID 145). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h13p02.rsground` (`23e8e9bd249aaef292a365e42553b2945688c1a80cf8107bf5cb1bbe3fbf7c8b`) and `Content/Tile/h13p02_Base.tile` (`e095237f77710aa73f4f5959bb358da62e07e1ea077444188e1fcbb335cc3616`), inserted one zone entry after `h13p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
