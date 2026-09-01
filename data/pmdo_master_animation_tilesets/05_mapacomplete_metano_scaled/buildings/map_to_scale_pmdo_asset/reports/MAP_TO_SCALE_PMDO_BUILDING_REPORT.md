# MAP TO SCALE PMDO BUILDING REPORT

## Source

- `map to scale pmdo and make tilset asset.png`
- `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/metano_scale_verification.png`

## PMDO scale used

Metano Town PMDO scale verified from metano_scale_verification.png: 2.0x integer nearest-neighbor from the small map presentation to the PMDO object library. The three exported visible building types already exist in repository-canonical PMDO size, so they are reused without any second scaling pass.

## Recovered visible buildings

- **metano_cafe_spinda** — type `cafe` — path `data/pmdo_assets_alpha_entiers/02_boutiques_et_marche/grand_cafe_spinda_terrasse_jour.png` — 259×109 px — alpha isolated: PASS
- **metano_fire_home_round** — type `house` — path `data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/maison_style_feu.png` — 110×99 px — alpha isolated: PASS
- **metano_expedition_tent** — type `tent_house` — path `data/pmdo_assets_alpha_entiers/03_batiments_et_tentes/tente_expedition_bleue.png` — 80×80 px — alpha isolated: PASS

## Unresolved / excluded visible structures

- `bear_head_cave_home_unique` — UNRESOLVED_FLATMAP_ONLY — visible on the flattened PNG, but no exact clean alpha-isolated canonical source was found in the repository and direct crop isolation would keep terrain contamination
- `blue_emblem_plaza_podium` — EXCLUDED_NON_BUILDING — visually reads as a podium or marker rather than a building entrance
- `pokemon_statue_podiums` — EXCLUDED_NON_BUILDING — statues and altars visible on the map are not buildings


## Atlas

- PNG: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/pmdo/MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.png`
- Manifest: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/manifests/MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.json`
- Canvas: 576×192 px
- Grid: 24 px
- Alpha isolation: PASS
- Overlap check: PASS

## Validation summary

- Recoverable exported buildings: 3
- PNG format: PASS
- RGBA or alpha channel: PASS
- Duplicate audit: PASS
- Pixel-perfect reuse: PASS

## Deliverables

- Inventory: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/manifests/MAP_TO_SCALE_PMDO_BUILDINGS_INVENTORY.json`
- Atlas: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/pmdo/MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.png`
- Atlas manifest: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/manifests/MAP_TO_SCALE_PMDO_BUILDINGS_ATLAS.json`
- Contact sheet: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/validation/MAP_TO_SCALE_PMDO_BUILDING_CONTACT_SHEET.png`
- Audit: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/validation/MAP_TO_SCALE_PMDO_BUILDING_AUDIT.png`
- Scale validation: `data/pmdo_master_animation_tilesets/05_mapacomplete_metano_scaled/buildings/map_to_scale_pmdo_asset/validation/MAP_TO_SCALE_PMDO_BUILDING_SCALE_VALIDATION.png`
