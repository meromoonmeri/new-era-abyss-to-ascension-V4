# `a03p01` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a03p01.rsground` | `b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc` |
| `a03p01_Base.tile` | `4b8f2b3729a32685206ee5c37bc346e53b83685da4a9bdb6964bbb4d1f4642b0` |

The complete occupied Ground and historical tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically. The pre-existing canonical-identity tile was also reserved byte-exactly and then replaced atomically with the independently validated authenticated tile. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `b274410f90ad2ef7f0e9c2cbdbb4e68959db2dca25b94b3452f3d67a5a5280dc`. Historical reserve tile: `877fd56336e417ed7690db8baeeedf465657eaf37a345d2010fa356333bf8cf4`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_FUGITIVES_SNOW_FOREST` / map ID 169 / map-file ID 178.

Evidence: `docs/pmdred_eu/pmdo_validation/a03p01_exhaustive_pass/`.
