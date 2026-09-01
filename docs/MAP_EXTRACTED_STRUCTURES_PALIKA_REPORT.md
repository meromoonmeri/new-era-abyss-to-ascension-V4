# RAPPORT D'EXTRACTION DES STRUCTURES DE LA MAP — PMDO PALIKA

## 1. Vue d'Ensemble

Toutes les **10 structures** visibles sur votre carte source (**`map to scale pmdo and make tilset asset.png`**) ont été découpées directement depuis l'image de la map, détourées en **alpha pur 32-bit**, agrandies selon l'échelle exacte PMDO Metano ($2.0\times$ integer nearest-neighbor), découpées selon l'architecture en couches de Palika (Layer 6 Murs/Base vs Layer 8 Toits/Surplombs) et compilées en binaires natifs PMDO `.tile`.

---

## 2. Inventaire des 10 Structures Extraites de la Map

### #map_struct_01_nw_spinda_grand_cafe — Grand Café Spinda Nord-Ouest (Northwest Grand Spinda Café)
- **Zone sur la Map (Crop)** : Bounding Box `[114, 18, 260, 115]`
- **Résolution Native Découpée (1.0x)** : 146 × 97 px
- **Échelle PMDO Metano (2.0x)** : 292 × 194 px
- **Grille de Tuiles PMDO (32px)** : 320 × 224 px (10 × 7 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 146\text{ px}$
- **Catégorie** : `service_cafe`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_01_nw_spinda_grand_cafe/map_struct_01_nw_spinda_grand_cafe_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_01_nw_spinda_grand_cafe/map_struct_01_nw_spinda_grand_cafe_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_01_nw_spinda_grand_cafe/map_struct_01_nw_spinda_grand_cafe_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_01_nw_spinda_grand_cafe/map_struct_01_nw_spinda_grand_cafe_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_01_nw_spinda_grand_cafe/map_struct_01_nw_spinda_grand_cafe_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_01_nw_spinda_grand_cafe_Base.tile`

### #map_struct_02_nw_expedition_tent_blue — Tente d'Expédition Bleue Nord-Ouest (Northwest Blue Expedition Tent)
- **Zone sur la Map (Crop)** : Bounding Box `[216, 168, 272, 222]`
- **Résolution Native Découpée (1.0x)** : 56 × 54 px
- **Échelle PMDO Metano (2.0x)** : 112 × 108 px
- **Grille de Tuiles PMDO (32px)** : 128 × 128 px (4 × 4 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 76\text{ px}$
- **Catégorie** : `tent_dwelling`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_02_nw_expedition_tent_blue/map_struct_02_nw_expedition_tent_blue_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_02_nw_expedition_tent_blue/map_struct_02_nw_expedition_tent_blue_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_02_nw_expedition_tent_blue/map_struct_02_nw_expedition_tent_blue_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_02_nw_expedition_tent_blue/map_struct_02_nw_expedition_tent_blue_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_02_nw_expedition_tent_blue/map_struct_02_nw_expedition_tent_blue_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_02_nw_expedition_tent_blue_Base.tile`

### #map_struct_03_nw_plaza_podium_blue_emblem — Podium de Place & Emblème Bleu de Guilde (Plaza Podium & Blue Guild Emblem)
- **Zone sur la Map (Crop)** : Bounding Box `[182, 216, 254, 282]`
- **Résolution Native Découpée (1.0x)** : 72 × 66 px
- **Échelle PMDO Metano (2.0x)** : 144 × 132 px
- **Grille de Tuiles PMDO (32px)** : 160 × 160 px (5 × 5 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 92\text{ px}$
- **Catégorie** : `monument_plaza`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_03_nw_plaza_podium_blue_emblem/map_struct_03_nw_plaza_podium_blue_emblem_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_03_nw_plaza_podium_blue_emblem/map_struct_03_nw_plaza_podium_blue_emblem_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_03_nw_plaza_podium_blue_emblem/map_struct_03_nw_plaza_podium_blue_emblem_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_03_nw_plaza_podium_blue_emblem/map_struct_03_nw_plaza_podium_blue_emblem_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_03_nw_plaza_podium_blue_emblem/map_struct_03_nw_plaza_podium_blue_emblem_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_03_nw_plaza_podium_blue_emblem_Base.tile`

### #map_struct_04_w_bear_cave_dwelling — Habitation Grotte Tête d'Ours Ouest (West Bear-Head Cave Dwelling)
- **Zone sur la Map (Crop)** : Bounding Box `[92, 390, 170, 465]`
- **Résolution Native Découpée (1.0x)** : 78 × 75 px
- **Échelle PMDO Metano (2.0x)** : 156 × 150 px
- **Grille de Tuiles PMDO (32px)** : 160 × 160 px (5 × 5 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 90\text{ px}$
- **Catégorie** : `unique_dwelling`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_04_w_bear_cave_dwelling/map_struct_04_w_bear_cave_dwelling_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_04_w_bear_cave_dwelling/map_struct_04_w_bear_cave_dwelling_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_04_w_bear_cave_dwelling/map_struct_04_w_bear_cave_dwelling_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_04_w_bear_cave_dwelling/map_struct_04_w_bear_cave_dwelling_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_04_w_bear_cave_dwelling/map_struct_04_w_bear_cave_dwelling_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_04_w_bear_cave_dwelling_Base.tile`

### #map_struct_05_sw_round_fire_house — Maison Ronde Style Feu Sud-Ouest (Southwest Round Fire-Style House)
- **Zone sur la Map (Crop)** : Bounding Box `[142, 492, 206, 560]`
- **Résolution Native Découpée (1.0x)** : 64 × 68 px
- **Échelle PMDO Metano (2.0x)** : 128 × 136 px
- **Grille de Tuiles PMDO (32px)** : 128 × 160 px (4 × 5 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 96\text{ px}$
- **Catégorie** : `residential_house`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_05_sw_round_fire_house/map_struct_05_sw_round_fire_house_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_05_sw_round_fire_house/map_struct_05_sw_round_fire_house_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_05_sw_round_fire_house/map_struct_05_sw_round_fire_house_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_05_sw_round_fire_house/map_struct_05_sw_round_fire_house_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_05_sw_round_fire_house/map_struct_05_sw_round_fire_house_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_05_sw_round_fire_house_Base.tile`

### #map_struct_06_center_plaza_pavilion — Pavillon & Monument de Place Centrale (Central Plaza Pavilion & Landmark)
- **Zone sur la Map (Crop)** : Bounding Box `[262, 262, 342, 342]`
- **Résolution Native Découpée (1.0x)** : 80 × 80 px
- **Échelle PMDO Metano (2.0x)** : 160 × 160 px
- **Grille de Tuiles PMDO (32px)** : 160 × 160 px (5 × 5 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 84\text{ px}$
- **Catégorie** : `plaza_pavilion`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_06_center_plaza_pavilion/map_struct_06_center_plaza_pavilion_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_06_center_plaza_pavilion/map_struct_06_center_plaza_pavilion_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_06_center_plaza_pavilion/map_struct_06_center_plaza_pavilion_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_06_center_plaza_pavilion/map_struct_06_center_plaza_pavilion_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_06_center_plaza_pavilion/map_struct_06_center_plaza_pavilion_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_06_center_plaza_pavilion_Base.tile`

### #map_struct_07_center_treehouse_dwelling — Logis de Maison dans l'Arbre Centrale (Central Treehouse Living Quarters)
- **Zone sur la Map (Crop)** : Bounding Box `[380, 278, 482, 392]`
- **Résolution Native Découpée (1.0x)** : 102 × 114 px
- **Échelle PMDO Metano (2.0x)** : 204 × 228 px
- **Grille de Tuiles PMDO (32px)** : 224 × 256 px (7 × 8 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 148\text{ px}$
- **Catégorie** : `treehouse_dwelling`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_07_center_treehouse_dwelling/map_struct_07_center_treehouse_dwelling_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_07_center_treehouse_dwelling/map_struct_07_center_treehouse_dwelling_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_07_center_treehouse_dwelling/map_struct_07_center_treehouse_dwelling_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_07_center_treehouse_dwelling/map_struct_07_center_treehouse_dwelling_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_07_center_treehouse_dwelling/map_struct_07_center_treehouse_dwelling_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_07_center_treehouse_dwelling_Base.tile`

### #map_struct_08_east_terrace_house — Maison en Bois sur Terrasse Est (East Terrace Wooden House)
- **Zone sur la Map (Crop)** : Bounding Box `[552, 420, 680, 542]`
- **Résolution Native Découpée (1.0x)** : 128 × 122 px
- **Échelle PMDO Metano (2.0x)** : 256 × 244 px
- **Grille de Tuiles PMDO (32px)** : 256 × 256 px (8 × 8 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 140\text{ px}$
- **Catégorie** : `residential_house`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_08_east_terrace_house/map_struct_08_east_terrace_house_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_08_east_terrace_house/map_struct_08_east_terrace_house_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_08_east_terrace_house/map_struct_08_east_terrace_house_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_08_east_terrace_house/map_struct_08_east_terrace_house_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_08_east_terrace_house/map_struct_08_east_terrace_house_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_08_east_terrace_house_Base.tile`

### #map_struct_09_southeast_market_stall — Échoppe & Auvent de Marché Sud-Est (Southeast Bazaar & Market Canopy)
- **Zone sur la Map (Crop)** : Bounding Box `[680, 520, 802, 642]`
- **Résolution Native Découpée (1.0x)** : 122 × 122 px
- **Échelle PMDO Metano (2.0x)** : 244 × 244 px
- **Grille de Tuiles PMDO (32px)** : 256 × 256 px (8 × 8 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 136\text{ px}$
- **Catégorie** : `market_stall`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_09_southeast_market_stall/map_struct_09_southeast_market_stall_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_09_southeast_market_stall/map_struct_09_southeast_market_stall_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_09_southeast_market_stall/map_struct_09_southeast_market_stall_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_09_southeast_market_stall/map_struct_09_southeast_market_stall_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_09_southeast_market_stall/map_struct_09_southeast_market_stall_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_09_southeast_market_stall_Base.tile`

### #map_struct_10_south_fishery_dock — Cabane de Pêcheur & Ponton Sud (South Fishery & Lakeside Dock Hut)
- **Zone sur la Map (Crop)** : Bounding Box `[320, 600, 442, 722]`
- **Résolution Native Découpée (1.0x)** : 122 × 122 px
- **Échelle PMDO Metano (2.0x)** : 244 × 244 px
- **Grille de Tuiles PMDO (32px)** : 256 × 256 px (8 × 8 tuiles)
- **Plan de Coupe Couche (Layer 8 / Layer 6)** : $Y = 136\text{ px}$
- **Catégorie** : `fishery_dock`
- **Fichiers Générés** :
  - Crop Brut de la Map : `data/map_structures_alpha_isolated_pmdo/map_struct_10_south_fishery_dock/map_struct_10_south_fishery_dock_raw_crop.png`
  - Version Alpha Isolate 1x : `data/map_structures_alpha_isolated_pmdo/map_struct_10_south_fishery_dock/map_struct_10_south_fishery_dock_native_1x_alpha.png`
  - Version PMDO 2x Complète : `data/map_structures_alpha_isolated_pmdo/map_struct_10_south_fishery_dock/map_struct_10_south_fishery_dock_complete_pmdo_2x.png`
  - Couche 8 (Toits & Surplombs) : `data/map_structures_alpha_isolated_pmdo/map_struct_10_south_fishery_dock/map_struct_10_south_fishery_dock_roof_overhang_layer8.png`
  - Couche 6 (Murs & Bases) : `data/map_structures_alpha_isolated_pmdo/map_struct_10_south_fishery_dock/map_struct_10_south_fishery_dock_walls_base_layer6.png`
  - Binaire Moteur PMDO : `Content/Tile/map_struct_10_south_fishery_dock_Base.tile`

---

## 3. Planches Maîtres & Binaires Moteur PMDO

- **Planche Maître Complète** : `data/map_structures_alpha_isolated_pmdo/map_all_structures_master_tileset.png`
- **Planche Couche 8 (Toits & Surplombs)** : `data/map_structures_alpha_isolated_pmdo/map_all_structures_roofs_layer8.png`
- **Planche Couche 6 (Murs & Bases)** : `data/map_structures_alpha_isolated_pmdo/map_all_structures_walls_layer6.png`
- **Binaires Moteur dans `Content/Tile/`** :
  - `Content/Tile/Map_Extracted_Structures_All_Base.tile`
  - `Content/Tile/Map_Extracted_Structures_Roofs_Over.tile`
  - `Content/Tile/Map_Extracted_Structures_Walls_Under.tile`
  - 10 binaires individuels `Content/Tile/map_struct_*_Base.tile`
