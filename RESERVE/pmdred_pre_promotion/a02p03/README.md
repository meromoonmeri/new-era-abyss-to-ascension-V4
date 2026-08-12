# `a02p03` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a02p03.rsground` | `7f91bdf9d4ff3574ee00ffe8fcacd30aae83bc9bdec8fb2c18b0135c06ba456e` |
| `A02p03_Base.tile` | `94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b` |

The complete occupied Ground and legacy-case tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically, the canonical lowercase tile identity was created additively, and the legacy-case tile remained unchanged. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `3904f90e0454b5863c74aab0d6455e09253e7bafdb747bbc816cefa1f2b20191`. Historical reserve tile: `94b275262765e0b7ea1fd209bc9f1d1dac89452d3f3e36228ed46d2f30c12e7b`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_FUGITIVES_VOLCANO` / map ID 167 / map-file ID 176.

Evidence: `docs/pmdred_eu/pmdo_validation/a02p03_exhaustive_pass/`.
