# Strict phase boundary

## Phase 1 — partially certified

The public server SQL snapshot of 2,000 maps is `SOURCE_CERTIFIED` for canonical IR and raster. The global phase remains `PARTIAL` because 140 encrypted client caches are blocked (137 overlap the SQL IDs and `s3000` is cache-only) and six tile values have no public enum semantics. Their statuses remain explicit; no ciphertext or inferred meaning is promoted.

## Phase 2 — blocked

No PMDO scale adaptation, image interpolation, `.rsground` generation, PMDO collision conversion, or PMDO runtime test belongs in this directory or phase. The existing runtime/headless PMDO method is not replaced. A future phase 2 may consume only explicitly certified phase-1 structures and immutable PNG references and must never overwrite them.
