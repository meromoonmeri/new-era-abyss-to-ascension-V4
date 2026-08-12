# a01p02 exhaustive exact-PMDO pass

## Result

`PASS — PROMOTED ADDITIVELY`

`a01p02` is the authenticated EU fissure fugitive journey scene (`MAP_FUGITIVES_FISSURE`; map ID 164, map-file ID 173). Exact PMDO 0.8.12 loaded the authenticated v2.0.1-eu candidate in isolation; the independent raw-EU-ROM renderer matched all **2/2** full-RGBA samples with zero mismatched pixels and full opacity. The movement probe passed; a blocked probe is authentically not applicable because the raw-ROM BMA has no collision layer and zero solid cells, as independently confirmed by the plan, fixture manifest, and runtime event. Two entries/exits, same-Ground re-entry, unload/reload, cleanup, and state isolation all passed. PMDO then entered native `GameBase.LoadPhase.Unload`, published data and graphics unload callbacks, emitted terminal `end`, returned 0 as `NORMAL_EXIT`, and left no signal, watchdog, SIGSEGV, forced kill, or orphan.

Role flags are recorded independently as `cinematic=false`, `arena=false`, `boss=false`; this Ground-only record claims no dialogue, choreography, music, or narrative routing. 1 primary boundary ticks (0–0) cover every applicable animation schedule through two complete local cycles (maximum 1 ticks); 1 distinct primary RGBA frames were observed.

Promotion created previously absent `Data/Ground/a01p02.rsground` (`e5aaf9d09f98955a09f9c53ea0c7ce8663289c511edec0ae503f7b181100896c`) and `Content/Tile/a01p02_Base.tile` (`e501d4761b634b4f5103d484dff170fc1b9606438b67e6e69f8ee5aef144c06f`). The first pre-promotion attempt remains classified as FAIL at `docs/pmdred_eu/pmdo_validation/a01p02_failed_attempt_no_bma_collision_gate`; this PASS uses a complete fresh fixture, runtime, and exhaustive comparison after the narrow gate correction. Promotion inserted one zone entry after `a01p01` without reserializing the registry, preserved BOM/other routes, retained all reserve/history, and passed exact-PMDO post-promotion indexing (`3df47e3b…`). Complete metrics, events, logs, representative initial/final/reload PNGs, provenance, promotion details, reproduction commands, and hashes are in this directory.
