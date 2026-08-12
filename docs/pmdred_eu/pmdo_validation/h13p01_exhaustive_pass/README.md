# h13p01 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h13p01` is the authenticated EU cryptic cave friend area (`MAP_FRIEND_AREA_CRYPTIC_CAVE`; map ID 138, map-file ID 144). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **17/17** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 16 primary boundary ticks (0–55) cover every applicable animation schedule through two complete local cycles (maximum 28 ticks); 4 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h13p01.rsground` (`26aa27ed7b672be74a2295b4232a343ae9010df2eb795c9dd6811f60232bd717`) and `Content/Tile/h13p01_Base.tile` (`b04de3ec4470fd865d4344bc714ca9171f3ecbd8189fdbd911ee3ff461328ef1`), inserted one zone entry after `h12p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
