# b07p01b exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`b07p01b` is the authenticated EU final mudkip rescue team base exterior (`MAP_TEAM_BASE_MUDKIP_FINAL`; map ID 47, map-file ID 48). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **51/51** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 50 primary boundary ticks (0–127) cover every applicable animation schedule through two complete local cycles (maximum 64 ticks); 32 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/b07p01b.rsground` (`391a22fbd5a609f8a9864d3bd4d22a8af75319aa9a89ec882edf949096dc543d`) and `Content/Tile/b07p01b_Base.tile` (`83f25ae821e8055af5bf31a714a07ee7dabf766f72036ed61e6d342a1e89c251`), inserted one zone entry after `b07p01a` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
