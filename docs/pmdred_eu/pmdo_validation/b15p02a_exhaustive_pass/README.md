# b15p02a exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b15p02a` is the authenticated EU construction chikorita rescue team base interior (`MAP_TEAM_BASE_INSIDE_CHIKORITA_CONSTRUCTION`; map ID 97, map-file ID 98). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b15p02a.rsground` (`d172ec7acc7e3552752d6495c1b6c0add41f4641ee081b2ca7cda078c22d3e3d`) and `Content/Tile/b15p02a_Base.tile` (`c0fc5ae65267d782b3ff1f8ee8db4ebe8832a80a1708a6c48ac10b1366818dc7`), inserted one zone entry after `b15p01c` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
