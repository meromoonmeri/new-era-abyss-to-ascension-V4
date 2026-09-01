# METANO KINGAMBIT BUILDING SCALE REPORT

## Scope

Single-building recovery task requested by the user: scale `QGKingambit-removebg-preview.png` to a Metano Town / PMDO-compatible size using the canonical café building as reference.

## Authoritative references

- `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png`
- `docs/metano_origins_structure_library/buildings/metano_cafe_day.png`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/references/QGKingambit-removebg-preview.png`

## Method

1. The external Kingambit source was preserved as RGBA and trimmed only on fully transparent margins.
2. The existing PMDO café extraction was used as the canonical Metano building-scale reference.
3. Opaque-pixel area was measured for both assets.
4. The café-derived target scale was computed as `sqrt(cafe_opaque / kingambit_opaque)`.
5. The practical deterministic scale chosen was **40% nearest-neighbor** (`-filter point -resize 40%`).
6. No recolor, no repaint, no smoothing, no interpolation, no alpha baking.

## Metrics

- Café reference size: 259×109
- Café opaque pixels: 16109
- Kingambit master trimmed size: 528×346
- Kingambit master opaque pixels: 102672
- Café-derived target scale: 0.396103135
- Chosen deterministic scale: 40.00%
- Output size: 211×138
- Output opaque pixels: 16328

## Validation

- Output format: PNG
- Output channels: srgba
- Output contains transparency: True
- Output alpha isolation: PASS
- Interpolation used: False
- Palette changed: False

## Deliverables

- Master trimmed asset: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/master/QGKingambit-removebg-preview_trimmed.png`
- PMDO scaled asset: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/pmdo/QGKingambit_metano_cafe_reference_pmdo_40pct.png`
- Contact sheet: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/validation/METANO_KINGAMBIT_PMDO_CONTACT_SHEET.png`
- Validation sheet: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/validation/METANO_KINGAMBIT_PMDO_SCALE_VALIDATION.png`
- Manifest: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/manifests/metano_kingambit_pmdo_scale_manifest.json`

## SHA-256

- Master: `8c5979227f9cba020ceb203d48e8a284cf3f7e28c523536afb45cbbb453bb707`
- PMDO scaled output: `1521af4a2bcb25674e38411f3c0b3f80cd95fc46e3711a5a5bbc26af5d61af68`
