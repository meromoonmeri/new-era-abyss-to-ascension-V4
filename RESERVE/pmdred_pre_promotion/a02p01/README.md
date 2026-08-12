# `a02p01` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `a02p01.rsground` | `2b6d651a9fd7d25f159f50fc9d1cd6fa7006899988822eda217f4bf60923aad7` |
| `A02p01_Base.tile` | `7f80a67d0d6823541dbed67e77b68d1d005eb09b53d79a0d3a66e7a1bae027e3` |

The complete occupied Ground and legacy-case tile were copied byte-exactly into this directory and hash-verified. Only the exact historical Markers and Spawners were added to the authenticated canonical visual/collision Ground before that integrated artifact was validated. The active Ground was then replaced atomically, the canonical lowercase tile identity was created additively, and the legacy-case tile remained unchanged. No historical bytes were discarded, no preserved entity was silently deactivated, and related scripts were not modified. Pre-promotion `master_zone.json` SHA-256: `66671e4c5f81d167e221f3f9bd845090145f1e39bd6169472fe76a88d3adcf5b`.

Historical reserve Ground: `51e08f36ecc2975ba6ca9b0ae4fc2590400eb559608bf7f38246a7168e8aa9fb`. Historical reserve tile: `7f80a67d0d6823541dbed67e77b68d1d005eb09b53d79a0d3a66e7a1bae027e3`. Those reserves and both v2.0.0/v2.0.1 report generations remain unmodified. Authenticated identity: `MAP_FUGITIVES_FIRE` / map ID 165 / map-file ID 174.

Evidence: `docs/pmdred_eu/pmdo_validation/a02p01_exhaustive_pass/`.
