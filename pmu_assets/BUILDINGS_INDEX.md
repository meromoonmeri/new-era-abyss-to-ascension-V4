# PMU building extraction index

Full isolated candidates already in `pmu_assets/isolated_candidates/` (1 189 byte-exact
32x32 PNG records extracted from `PMU-Client` .tile archives, commit
`c25c01f9879369647cd5a19731b2e4e5acd33e67`). Never cropped, never rescaled.
Status per record: `GEOMETRICALLY_ISOLATED_CANDIDATE` unless the qualified
manifest says otherwise — **nothing here is placement-approved**; the
per-archive `contact_sheet.png` is the fastest visual triage.

| archive | isolated candidates | content (per New Era review) | contact sheet |
|---|---:|---|---|
| Tiles7.tile | 467 | roofs, walls, full house bodies (largest building archive) | `isolated_candidates/Tiles7/contact_sheet.png` |
| Tiles8.tile | 285 | building facades, doors, windows, shop fronts | `isolated_candidates/Tiles8/contact_sheet.png` |
| Tiles9.tile | 174 | building annexes, tents, market stalls, structural parts | `isolated_candidates/Tiles9/contact_sheet.png` |
| Tiles5.tile | 89 | interior furniture + shop structures | `isolated_candidates/Tiles5/contact_sheet.png` |
| Tiles4.tile | 76 | furniture/tableware/props | `isolated_candidates/Tiles4/contact_sheet.png` |
| Tiles6.tile | 39 | misc structures + fences/gates | `isolated_candidates/Tiles6/contact_sheet.png` |
| Tiles0.tile | 35 | terrain edges + small structures | `isolated_candidates/Tiles0/contact_sheet.png` |
| Tiles1.tile | 6 | sparse extras | `isolated_candidates/Tiles1/contact_sheet.png` |
| Tiles3.tile | 8 | sparse extras | `isolated_candidates/Tiles3/contact_sheet.png` |
| Tiles10.tile | 10 | small structures/annexes | `isolated_candidates/Tiles10/contact_sheet.png` |

**Building-heavy archives: Tiles7 (467), Tiles8 (285), Tiles9 (174) — 926 records.**

## Canonical map table & connectivity (in `pmu_extraction/reports/`)

- `canonical-map-table.md` / `canonical-map-index.json` — the 2 001 maps parsed
  from the client `.dat` files, with per-map tileset usage (this is where house
  layouts in PMU village maps reference these building tiles).
- `connection-graph.json` / `.dot` — map-to-map adjacency (village circulation).
- `critical-maps/s737, s1810, s1991` — source + animated contact renders of
  three village-critical maps (furnished examples of the same assets in situ).
- `audit/tileset-audit-report.json` — exact archive geometry: Tiles7 =
  448x18304 px, 8 008 tiles; Tiles8 = 448x16736, 7 322; Tiles9 = 448x14114,
  6 174 (columns of 14 x 32 px).
- `audit/inventory-report.json` — totals: 2 001 maps, 52 486 tiles, 2 001 item
  definitions, 962 animation maps.
