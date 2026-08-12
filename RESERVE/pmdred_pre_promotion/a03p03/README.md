# `a03p03` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a03p03.rsground` | `056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae` |
| `a03p03_Base.tile` | `314207f03b49c0908a801ee10ee0cbcb29c700d8500539444625e56da05489f9` |

The complete occupied Ground and historical tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically. The pre-existing canonical-identity tile was also reserved byte-exactly and then replaced atomically with the independently validated authenticated tile. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `056e711e49f8f9ae7b5067458d66ba2c758e42ca3b96fb60e0e58946c9bb52ae`. Historical reserve tile: `fa9b2e916bf28714e4614964f7589d6ef83e81754ee358c147c09c975a7a5281`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_SUMMIT_SUNSET` / map ID 171 / map-file ID 180.

Evidence: `docs/pmdred_eu/pmdo_validation/a03p03_exhaustive_pass/`.
