# `a04p01` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a04p01.rsground` | `c44840e6dca2e1462f98b63204f4d60f5b6a86304b04c81faa379ae416039a5b` |
| `a04p01_Base.tile` | `b376149a921c935a8f803b36559627302fb0fb5f00832a602d5c83a54af28adf` |

The complete occupied Ground and historical tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically. The pre-existing canonical-identity tile was also reserved byte-exactly and then replaced atomically with the independently validated authenticated tile. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `8ca6d9d60743b11b98c8d30fabd47c8108871187a2018f8f7df678ef7162f230`. Historical reserve tile: `98bfcfafcfde3d0abbff80861148c34699ba506de5f0aa0c10697a791166908d`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_SKY_TOWER` / map ID 172 / map-file ID 181.

Evidence: `docs/pmdred_eu/pmdo_validation/a04p01_exhaustive_pass/`.
