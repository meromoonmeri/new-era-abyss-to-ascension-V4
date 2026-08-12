# h06p03 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`h06p03` is the authenticated EU safari friend area (`MAP_FRIEND_AREA_SAFARI`; map ID 119, map-file ID 124). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. BMA movement/blocking, two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/h06p03.rsground` (`2bb9374fa666f4b17d38fbfd69808b4983d18ba10e237d48f1ecc0c928db121e`) and `Content/Tile/h06p03_Base.tile` (`7d561a91c33890cc765d783a49711550aa86b28333d8b84245a295a5333271d7`), inserted one zone entry after `h06p02` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
