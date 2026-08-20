# Out-of-order pilot zone-integration correction

`h26p01` and `a01p01` were already authenticated, exact-PMDO-validated, promoted pilots, but their earlier promotion method did not register them in `Data/Zone/master_zone.json`. This caused the first subsequent contiguous attempt (`h27p01`) to stop rather than guess a predecessor.

This correction inserted both pilot IDs byte-additively after `h25p01`, without reserializing the BOM-prefixed registry. That placement preserves eventual canonical plan order: each new `h27`–`h29` entry is inserted immediately after its predecessor and therefore before the already registered `a01p01`. Existing promoted Ground/tile bytes and historical proof were not modified or revalidated. An isolated fixture containing both hash-matched authenticated pilot assets passed exact PMDO 0.8.12 zone indexing with the pinned log hash.

The failed `h27p01` attempt remains explicitly classified as FAIL and preserved separately; a complete fresh rerun is still required.
