# b06p02c exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b06p02c` is the authenticated EU basic mudkip rescue team base exterior (`MAP_TEAM_BASE_MUDKIP_BASIC`; map ID 45, map-file ID 46). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **1921/1921** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1920 primary boundary ticks (0–5759) cover every applicable animation schedule through two complete local cycles (maximum 2880 ticks); 180 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b06p02c.rsground` (`b2f6041b4ba3b97f8a89286cdddfc9e36326862cf6a4915339cfc3c44f4718c8`) and `Content/Tile/b06p02c_Base.tile` (`11eb7a8724b4dd0a971e69161d62e7f47ac6eac57e8d246bfecb9f1fee46f2e1`), inserted one zone entry after `b06p02b` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
