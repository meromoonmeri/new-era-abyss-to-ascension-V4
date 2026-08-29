# Halcyon ORIGINAL — ground renders + structure extraction

Source: https://github.com/Palikadude/Halcyon cloned at HEAD (shallow) on
2026-08-29. Everything here comes from the **original Halcyon data**, not the
New Era fork — this is the ground-truth reference for "how Metano Town looked
in Halcyon".

- `renders/` — 34 of 37 grounds rendered with the project renderer
  (`render_ground_png.py` + Halcyon's own `Content/Tile`), incl. `contact_sheet.png`.
  **Not renderable from Halcyon data alone**: `post_office` (`PostOffice` sheet),
  `luminous_spring`, `testmap` (`TownBase` sheet) — those sheets do not exist in
  the upstream repo; New Era fixed them, use `../renders/` for those three.
- `structures/` — 5 building sprites composited from Halcyon's
  `metano_town.rsground` object layers only (indices 4–10, transparent
  background), cropped with the New Era extraction specs (same ROI geometry):
  cafe, kecleon shop, house_normal, house_rock, house_fire — plus
  `metano_town_ALL_objects_layer.png` (full 1512x1512 object composite) so any
  other structure (inn, dojo, well, market...) can be cropped directly.
- Comparison tip: `pmu_assets`+`buildings/metano_origins_structure_library`
  show the New Era state; `halcyon_original/structures` shows the original —
  the diff between them is exactly what New Era restyled.
