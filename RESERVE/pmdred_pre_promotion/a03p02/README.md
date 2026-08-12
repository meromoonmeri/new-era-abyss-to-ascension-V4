# `a03p02` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a03p02.rsground` | `ca7278d2c16e3843a089ab20904b7c3b5d85542d24987573604ffe12e83c9ff3` |
| `a03p02_Base.tile` | `5d492bd32d1c0fbebce449bf85624865d333eb5743b0acb5adacf5ce7fb9cf2a` |

The complete occupied Ground and historical tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically. The pre-existing canonical-identity tile was also reserved byte-exactly and then replaced atomically with the independently validated authenticated tile. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `62afb6275c527e997ec5225505328559f14a9671fd07a684b8b7b6de1d1bc749`. Historical reserve tile: `076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_FUGITIVES_BLIZZARD_ROAD` / map ID 170 / map-file ID 179.

Evidence: `docs/pmdred_eu/pmdo_validation/a03p02_exhaustive_pass/`.
