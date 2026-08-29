# PMDO `.tile` sheet format — decoded and round-trip proven

Reconstructed in New Era by analyzing `Metano_Town_Base.tile`; re-reading and
re-writing produced a byte-identical file (MD5 match) across all 14 Metano
tilesets, so this layout is exact, not estimated.

```
[0..3]   uint32  tileSize metadata (8 in converter output, often 24 from the editor)
[4..7]   uint32  N   number of index entries
[8..]    index   N × ( uint64 key, uint64 offset )
                 key   = x | (y << 32)     tile coordinate in the sheet, in 8px tiles
                 offset absolute byte position of the record
record   uint32  PNG size
         uint32  padding
         bytes   raw 8×8 RGBA PNG
```

Notes for tooling:

- Identical tiles are **shared**: many index entries point to the same offset
  (e.g. 35 646 references vs 3 929 distinct tiles for Metano_Town_Base).
- `TexLoc` in ground JSON is `(x, y)` — the same key the index uses.
- A `.png` sibling is often shipped next to the `.tile` (the raw stitched
  atlas) — use it as the working canvas; repack via `tools/png2tileset.py`
  logic when adding tiles: 8px grid, RGBA PNG per tile, dedupe identical tiles.
- Never rescale a sheet. New content must be authored at 8×8 with the same
  palette discipline as its neighbors; 16px sources (PMUniverse) are placed as
  2×2 tile compositions or kept as entity/object sprites at native size.
