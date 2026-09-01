# PMD SPECIALTY POKÉMON STRUCTURES — PMDO MAPPING CONVERSION REPORT

## 1. Executive Summary & Conversion Overview

This document provides the authoritative mapping decomposition and conversion report for the **7 PMD Pokémon-themed Specialty Shop & House Structures** extracted, alpha-isolated, and scaled to the **Pokémon Mystery Dungeon Origins (PMDO) / Metano Town Standard** following Palika's mapping methodology.

### Converted Structures Inventory:
1. **Sentret House & Shop (`pmd_struct_01_sentret_house_shop`)**: Wood-carved dwelling featuring dual orb chests and red entrance rug ($130 \times 114\text{ px}$ native $\rightarrow 260 \times 228\text{ px}$ PMDO).
2. **Armaldo Head Shop (`pmd_struct_02_armaldo_head_shop`)**: Armaldo / Anorith fossil head boutique with jewel chests and blue/red striped mat ($204 \times 182\text{ px}$ native $\rightarrow 408 \times 364\text{ px}$ PMDO).
3. **Duskull Skull Bank (`pmd_struct_03_duskull_skull_bank`)**: Duskull skull bank with purple ruffled collar, gold accents, and yellow canopy ($212 \times 160\text{ px}$ native $\rightarrow 424 \times 320\text{ px}$ PMDO).
4. **Alakazam Head Shop (`pmd_struct_04_alakazam_head_shop`)**: Alakazam psychic academy/shop with yellow striped fence, large mustache crests, and entrance gate ($196 \times 198\text{ px}$ native $\rightarrow 392 \times 396\text{ px}$ PMDO).
5. **Wynaut Recycle Shop (`pmd_struct_05_wynaut_recycle_shop`)**: Wynaut recycling counter with item sorting boxes, tail display, and purple floor mat ($176 \times 194\text{ px}$ native $\rightarrow 352 \times 388\text{ px}$ PMDO).
6. **Metagross Pavilion Shop (`pmd_struct_06_metagross_pavilion_shop`)**: Metagross metallic fortress shop featuring silver face-cross over yellow pavilion entrance drape ($212 \times 198\text{ px}$ native $\rightarrow 424 \times 396\text{ px}$ PMDO).
7. **Zangoose & Seviper Dojo (`pmd_struct_07_zangoose_seviper_dojo`)**: Dual-element combat dojo featuring twin red/blue tile pagodas, Zangoose/Seviper crests, and purple tatami ($196 \times 230\text{ px}$ native $\rightarrow 392 \times 460\text{ px}$ PMDO).

---

## 2. Palika Mapping Methodology & Layer Architecture

In accordance with Palika's mapping principles and the Metano Town reference architecture, all structures are decomposed into modular PMDO layers:

| Layer Index | Engine Layer Name | Functional Purpose in PMDO | Player Depth Interaction |
|---|---|---|---|
| **Layer 0 / 1** | `Base Ground / Ground Secondary` | Ground collision boundaries, terrain underlays | Player walks on top |
| **Layer 6** | `Walls / Base Facades / Underlays` | Ground-level walls, counters, entrance rugs, chests | Player depth-sorted in front of walls / on rugs |
| **Layer 8** | `Roofs / Overhangs / Top Canopies` | Upper roof crests, canopy draping, mask domes | **Player walks UNDERNEATH** (render over player) |

---

## 3. Detailed Structure Specifications & Split Coordinates

### Sentret House & Shop (`pmd_struct_01_sentret_house_shop`)
- **French Name**: Maison & Boutique Fouinette
- **Category**: `residential_shop`
- **Native Resolution (1.0x)**: 130 × 114 px
- **PMDO Metano Scale (2.0x)**: 260 × 228 px
- **Padded Tile Grid Dimensions**: 288 × 256 px (9 × 8 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 152\text{ px}$
- **Collision Bounding Box (Native)**: (10, 50, 110, 54)
- **Doorway Center Offset (Native)**: (53, 90)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/01_sentret_house_shop/pmd_struct_01_sentret_house_shop_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/01_sentret_house_shop/pmd_struct_01_sentret_house_shop_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/01_sentret_house_shop/pmd_struct_01_sentret_house_shop_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/01_sentret_house_shop/pmd_struct_01_sentret_house_shop_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_01_sentret_house_shop_Base.tile`

### Armaldo Head Shop (`pmd_struct_02_armaldo_head_shop`)
- **French Name**: Échoppe Tête d'Armaldo & Trésors
- **Category**: `specialty_shop`
- **Native Resolution (1.0x)**: 204 × 182 px
- **PMDO Metano Scale (2.0x)**: 408 × 364 px
- **Padded Tile Grid Dimensions**: 416 × 384 px (13 × 12 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 212\text{ px}$
- **Collision Bounding Box (Native)**: (16, 70, 172, 95)
- **Doorway Center Offset (Native)**: (86, 150)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/02_armaldo_head_shop/pmd_struct_02_armaldo_head_shop_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/02_armaldo_head_shop/pmd_struct_02_armaldo_head_shop_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/02_armaldo_head_shop/pmd_struct_02_armaldo_head_shop_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/02_armaldo_head_shop/pmd_struct_02_armaldo_head_shop_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_02_armaldo_head_shop_Base.tile`

### Duskull Skull Bank (`pmd_struct_03_duskull_skull_bank`)
- **French Name**: Banque Crâne de Skélenox
- **Category**: `bank_service`
- **Native Resolution (1.0x)**: 212 × 160 px
- **PMDO Metano Scale (2.0x)**: 424 × 320 px
- **Padded Tile Grid Dimensions**: 448 × 320 px (14 × 10 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 168\text{ px}$
- **Collision Bounding Box (Native)**: (18, 65, 176, 80)
- **Doorway Center Offset (Native)**: (90, 130)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/03_duskull_skull_bank/pmd_struct_03_duskull_skull_bank_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/03_duskull_skull_bank/pmd_struct_03_duskull_skull_bank_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/03_duskull_skull_bank/pmd_struct_03_duskull_skull_bank_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/03_duskull_skull_bank/pmd_struct_03_duskull_skull_bank_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_03_duskull_skull_bank_Base.tile`

### Alakazam Head Shop (`pmd_struct_04_alakazam_head_shop`)
- **French Name**: Pavillon Tête d'Alakazam
- **Category**: `dojo_service`
- **Native Resolution (1.0x)**: 196 × 198 px
- **PMDO Metano Scale (2.0x)**: 392 × 396 px
- **Padded Tile Grid Dimensions**: 416 × 416 px (13 × 13 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 224\text{ px}$
- **Collision Bounding Box (Native)**: (15, 75, 166, 105)
- **Doorway Center Offset (Native)**: (82, 160)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/04_alakazam_head_shop/pmd_struct_04_alakazam_head_shop_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/04_alakazam_head_shop/pmd_struct_04_alakazam_head_shop_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/04_alakazam_head_shop/pmd_struct_04_alakazam_head_shop_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/04_alakazam_head_shop/pmd_struct_04_alakazam_head_shop_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_04_alakazam_head_shop_Base.tile`

### Wynaut Recycle Shop (`pmd_struct_05_wynaut_recycle_shop`)
- **French Name**: Stand de Recyclage Okéoké & Qulbutoké
- **Category**: `recycle_shop`
- **Native Resolution (1.0x)**: 176 × 194 px
- **PMDO Metano Scale (2.0x)**: 352 × 388 px
- **Padded Tile Grid Dimensions**: 352 × 416 px (11 × 13 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 224\text{ px}$
- **Collision Bounding Box (Native)**: (14, 70, 148, 105)
- **Doorway Center Offset (Native)**: (72, 156)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/05_wynaut_recycle_shop/pmd_struct_05_wynaut_recycle_shop_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/05_wynaut_recycle_shop/pmd_struct_05_wynaut_recycle_shop_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/05_wynaut_recycle_shop/pmd_struct_05_wynaut_recycle_shop_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/05_wynaut_recycle_shop/pmd_struct_05_wynaut_recycle_shop_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_05_wynaut_recycle_shop_Base.tile`

### Metagross Pavilion Shop (`pmd_struct_06_metagross_pavilion_shop`)
- **French Name**: Pavillon Forteresse Métalosse
- **Category**: `fortress_shop`
- **Native Resolution (1.0x)**: 212 × 198 px
- **PMDO Metano Scale (2.0x)**: 424 × 396 px
- **Padded Tile Grid Dimensions**: 448 × 416 px (14 × 13 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 232\text{ px}$
- **Collision Bounding Box (Native)**: (18, 80, 176, 102)
- **Doorway Center Offset (Native)**: (90, 160)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/06_metagross_pavilion_shop/pmd_struct_06_metagross_pavilion_shop_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/06_metagross_pavilion_shop/pmd_struct_06_metagross_pavilion_shop_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/06_metagross_pavilion_shop/pmd_struct_06_metagross_pavilion_shop_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/06_metagross_pavilion_shop/pmd_struct_06_metagross_pavilion_shop_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_06_metagross_pavilion_shop_Base.tile`

### Zangoose & Seviper Dojo (`pmd_struct_07_zangoose_seviper_dojo`)
- **French Name**: Dojo Rivalité Mangriff & Séviper
- **Category**: `dojo_landmark`
- **Native Resolution (1.0x)**: 196 × 230 px
- **PMDO Metano Scale (2.0x)**: 392 × 460 px
- **Padded Tile Grid Dimensions**: 416 × 480 px (13 × 15 standard 32px tiles)
- **Layer 8 / Layer 6 Cut Plane**: $Y = 256\text{ px}$
- **Collision Bounding Box (Native)**: (16, 95, 164, 120)
- **Doorway Center Offset (Native)**: (82, 185)
- **Asset Files**:
  - Native 1x: `data/pmdo_specialty_pokemon_structures/07_zangoose_seviper_dojo/pmd_struct_07_zangoose_seviper_dojo_native_1x.png`
  - PMDO 2x Assembled: `data/pmdo_specialty_pokemon_structures/07_zangoose_seviper_dojo/pmd_struct_07_zangoose_seviper_dojo_complete_metano_scale_2x.png`
  - Layer 8 Roofs Sheet: `data/pmdo_specialty_pokemon_structures/07_zangoose_seviper_dojo/pmd_struct_07_zangoose_seviper_dojo_roof_overhang_layer8.png`
  - Layer 6 Walls Sheet: `data/pmdo_specialty_pokemon_structures/07_zangoose_seviper_dojo/pmd_struct_07_zangoose_seviper_dojo_walls_base_layer6.png`
  - PMDO Binary: `Content/Tile/pmd_struct_07_zangoose_seviper_dojo_Base.tile`

---

## 4. Master Atlas & PMDO Binary Tilesets

The master tileset sheets organize all 7 structures into aligned, continuous tile grids for direct map-editor palette importation:

1. **Master Complete Structures Tileset**:
   - PNG: `data/pmdo_specialty_pokemon_structures/pmdo_specialty_structures_master_tileset.png`
   - Binary: `Content/Tile/PMD_Specialty_Structures_All_Base.tile`
   - Dimensions: 992 × 1856 px
2. **Master Layer 8 Roofs & Overhangs Tileset**:
   - PNG: `data/pmdo_specialty_pokemon_structures/pmdo_specialty_structures_roofs_overhang_layer8.png`
   - Binary: `Content/Tile/PMD_Specialty_Structures_Roofs_Over.tile`
   - Dimensions: 992 × 1856 px
3. **Master Layer 6 Walls & Base Facades Tileset**:
   - PNG: `data/pmdo_specialty_pokemon_structures/pmdo_specialty_structures_walls_base_layer6.png`
   - Binary: `Content/Tile/PMD_Specialty_Structures_Walls_Under.tile`
   - Dimensions: 992 × 1856 px

---

## 5. Quality Assurance & Validation Checks

- **Zero Denaturation Rule**: Checked and passed. Nearest-neighbor integer scaling preserves exact original color palettes and pixel edges.
- **100% Pure Alpha Isolation**: All non-structural background pixels (grass, dirt, rocks) have been fully eliminated with $0\%$ halo contamination.
- **Layer Split Consistency Check**: For all 7 structures, $\text{Layer 8} \cup \text{Layer 6} \equiv \text{Master 2.0x Complete}$ with $\Delta = 0$ pixel error.
- **PMDO Binary Integration**: 10 companion `.tile` binaries compiled into `Content/Tile/` matching engine byte structures.
