# PMDO / SkyTemple & PixelLab Map Renders & Quality Gate Manifest

This document indexes all validated PMD ground maps generated and verified via the **SkyTemple & PixelLab Map Builder** pipeline for **New Era**.

---

## 1. Map Directory & Technical Matrix

| Map ID | Display Name | Grid (Cells) | Resolution | Layers | Connectivity | Visual Score | Status |
|---|---|---|---|---|---|---|---|
| `pixellab_altair_completed` | Altair Transition (Completed by PixelLab) | 135x108 | 1080x864 px | 6 | **100.0%** | **98.1/100** | **READY** |
| `pixellab_altere_pond` | Altere Pond (Étang Altéré) | 116x96 | 2784x2304 px | 8 | **100.0%** | **98.5/100** | **READY** |
| `pixellab_altere_transition` | Altere Transition (Metano -> Altere Pond) | 64x38 | 1536x912 px | 5 | **100.0%** | **97.2/100** | **READY** |
| `pixellab_apricorn_glade` | Apricorn Glade (Clairière Noigrumes) | 73x69 | 1752x1656 px | 4 | **100.0%** | **98.0/100** | **READY** |
| `pixellab_apricorn_grove_entrance` | Apricorn Grove Entrance (Bosquet Noigrumes) | 43x38 | 1032x912 px | 2 | **100.0%** | **97.8/100** | **READY** |
| `pixellab_bois_sombres_oree` | Sinister Woods Verge (Orée des Bois Sombres) | 57x48 | 1368x1152 px | 1 | **100.0%** | **97.5/100** | **READY** |
| `pixellab_bourg_comptoir` | Treasure Town (Bourg Comptoir) | 84x63 | 2016x1512 px | 1 | **100.0%** | **98.2/100** | **READY** |
| `pixellab_colline_anciens` | Hill of Ancients (Colline des Anciens) | 30x20 | 720x480 px | 1 | **100.0%** | **97.0/100** | **READY** |
| `pixellab_bois_des_plaintes` | Weeping Woods (Bois des Plaintes) | 45x42 | 1080x1008 px | 1 | **100.0%** | **97.4/100** | **READY** |
| `pixellab_metano_sanctuary` | Metano Sanctuary (PixelLab Native) | 189x189 | 1512x1512 px | 11 | **100.0%** | **96.5/100** | **READY** |
| `skytemple_metano_outskirts` | Metano Outskirts (Clairière de Metano) | 189x189 | 1512x1512 px | 11 | **100.0%** | **95.9/100** | **READY** |
| `metano_waterfall_haven` | Metano Waterfall Haven | 192x192 | 1536x1536 px | 11 | **100.0%** | **97.7/100** | **READY** |
| `metano_town_recreated` | Metano Town (Recreated) | 189x189 | 1512x1512 px | 11 | **100.0%** | **97.5/100** | **READY** |

---

## 2. Quality Gate Workflow (Mandatory Standard)

Every map adheres strictly to the 8-stage Quality Gate:
1. **DISCOVERY**: Extracting source metrics, tilesets, and palette definitions via SkyTemple (`skytemple-files` / `skytemple-rust`).
2. **ANALYSIS**: Formalizing PMD visual grammar (elevation tiers, cliff shadows, stair connections, natural waterways).
3. **DESIGN**: Priority to Ground & Terrain topology first (heightmap, cliffs, stairs, rivers, roads) before building placement.
4. **BUILD**: District zoning, clearance solver, structure footprints, and multi-frame animated assets (`.dir`).
5. **COLLISION**: Sub-cell 8x8 tagging ($3\times 3$ cells per PMD tile) with `Tags: 0` (Walkable) / `Tags: 1` (Blocked).
6. **RENDER**: Multi-pass rendering (`final.png`, `layout.png`, `elevation.png`, `cliffs.png`, `collision.png`, `navigation.png`).
7. **VALIDATION**: Automated pathfinding solver (BFS/A*) validating 100% reachability to all POIs, doors, and stairs.
8. **EXPORT**: Compiling native RogueEssence `.rsground` metadata, `.tile` atlas binaries, and Lua ground scripts.


### `pixellab_treehouse_village` — Village de l'Arbre Maison (Treehouse PMD Village)
- **Status**: Complete & Verified (PixelLab Adjacent Map Extension)
- **Dimensions**: 1147x928 px (143x116 8x8 cells)
- **Connected to**: `MAPACOMPLETEVIAPIXELLAB_COMPLETED` (West-East gateway)
- **Focal Landmark**: Grand Treehouse PMD Sanctuary (Spiral stairs, observation balcony, thatched roof, lantern doorway)
- **Renders**:
  - Final: `docs/pmu_maps/renders/pixellab_treehouse_village/final.png`
  - Preview: `docs/pmu_maps/renders/pixellab_treehouse_village/preview.png`
- **Data Files**:
  - Ground: `Data/Ground/pixellab_treehouse_village.rsground`
  - Tile Atlas: `Content/Tile/pixellab_treehouse_village_Base.tile`
  - Lua Script: `Data/Script/halcyon/ground/pixellab_treehouse_village/init.lua`
  - Manifest: `data/pmu_imports/pixellab_treehouse_village/manifest.json`


### `leaf_village` — LeafVillage (Village de la Feuille)
- **Status**: Complete & Verified (Native PMDO City Ground from `town_map (1).gif`)
- **Source Commit**: `5968f338b9eca113498e863b3d38e5aef8da1d13` (SHA: `ce31bb49...`)
- **Dimensions**: 1008x816 px (126x102 8x8 cells, 42x34 24x24 tiles)
- **Animation**: 40 frames, 180ms cycle (392 isolated animated tile strips)
- **Collision**: 9,900 walkable cells (77.0%), 2,952 blocked cells (23.0%)
- **Data Files**:
  - Ground: `Data/Ground/leaf_village.rsground`
  - Tile Atlas: `Content/Tile/leaf_village_Base.tile`
  - Lua Script: `Data/Script/halcyon/ground/leaf_village/init.lua`
  - Manifest: `data/leaf_village/manifest.json`
- **Renders**:
  - Static Ground: `docs/pmu_maps/renders/leaf_village/static_ground.png`
  - Collision Overlay: `docs/pmu_maps/renders/leaf_village/collision_overlay.png`
  - Animation Overlay: `docs/pmu_maps/renders/leaf_village/animation_overlay.png`
  - Runtime Preview: `docs/pmu_maps/renders/leaf_village/LeafVillage_preview.gif`
