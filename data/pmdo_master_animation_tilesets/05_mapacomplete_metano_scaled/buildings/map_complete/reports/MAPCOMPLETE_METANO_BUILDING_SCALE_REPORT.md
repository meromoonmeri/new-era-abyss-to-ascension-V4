# MAPCOMPLETE METANO BUILDING SCALE REPORT

## Scope

User-requested building-only PMDO scaling pass for the complete PixelLab map authority:
- `MAPACOMPLETEVIAPIXELLAB_COMPLETED.webp`
- `metano_scale_verification.png`
- plus the separately requested external `QGKingambit` building already prepared in this repository.

This pack is conservative on purpose.  It only reuses exact canonical alpha-isolated PMDO assets already present in the repository for the buildings visibly represented on the complete map, and it does not duplicate those assets into a second pixel copy.

## PMDO scale used

Metano Town PMDO building scale verified from metano_scale_verification.png: 2.0x integer nearest-neighbor relative to native MAPACOMPLETE building footprints. Canonical Metano map buildings referenced here are already at that PMDO scale; Kingambit HQ uses the prebuilt 40% nearest-neighbor café-matched normalization stored in the repository.

## Building inventory recovered for direct PMDO reuse

- **metano_cafe_spinda** — type `cafe` — path `data/pmdo_assets_alpha_entiers/02_boutiques_et_marche/grand_cafe_spinda_terrasse_jour.png` — 259×109 px — alpha isolated: PASS
- **metano_fire_home_round** — type `house` — path `data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/maison_style_feu.png` — 110×99 px — alpha isolated: PASS
- **metano_leaf_red_tent** — type `tent_house` — path `data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/grande_tente_campement_unie.png` — 96×96 px — alpha isolated: PASS
- **kingambit_hq** — type `hq` — path `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/kingambit/pmdo/QGKingambit_metano_cafe_reference_pmdo_40pct.png` — 211×138 px — alpha isolated: PASS


## Excluded visible non-buildings

- `blue_roof_memorial` — visible on the source map but functions visually as a monument/pedestal rather than a building
- `pokemon_statue_podiums` — visible on the source map but are statues/monuments, not buildings
- `bunny_face_special_entrance` — visible as a landmark/special entrance; excluded from this building-only pack


## Validation summary

- Total assets in pack: 4
- Visible MAPACOMPLETE building types: 3
- External requested buildings: 1
- PNG format: PASS
- RGBA/alpha channel: PASS
- Transparent background present: PASS
- Duplicate audit inside selected pack: PASS
- Canonical café anchor present: PASS
- Kingambit HQ present: PASS

## Deliverables

- Inventory: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete/manifests/MAPCOMPLETE_METANO_BUILDINGS_INVENTORY.json`
- Contact sheet: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete/validation/MAPCOMPLETE_METANO_BUILDING_CONTACT_SHEET.png`
- Scale validation: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete/validation/MAPCOMPLETE_METANO_BUILDING_SCALE_VALIDATION.png`
- Map audit: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_complete/validation/MAPCOMPLETE_METANO_BUILDING_AUDIT.png`

## Notes

- No pixels were redrawn.
- No colors were changed.
- No interpolation other than declared nearest-neighbor scaling for the prebuilt Kingambit asset is used.
- The complete map file itself was not modified.
