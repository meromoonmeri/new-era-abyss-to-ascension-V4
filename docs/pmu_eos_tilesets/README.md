# PMU & PMD Explorers of Sky (EoS) - Alpha-Isolated Tileset Library

Cette bibliothèque rassemble l'ensemble des tilesets et éléments graphiques extraits de **Pokémon Mystery Universe (PMU)** et de **Pokémon Donjon Mystère : Explorateurs du Ciel (EoS / PMDO)**, **isolés sur fond transparent (canal alpha RGBA 32-bit)**.

---

## 1. Vue d'Ensemble & Statistiques Globales

- **Total de tiles traités** : 56 737 tiles
- **Total de tiles avec canal alpha isolé** : **25 189 tiles**
- **Résolutions de base** :
  - Tiles PMU : $32 \times 32\text{ px}$ (grille 14 colonnes)
  - Tiles EoS / PMDO : $24 \times 24\text{ px}$ & $8 \times 8\text{ px}$ (sub-tiles/overlays)
- **Format de stockage** : PNG 32-bit RGBA sans perte + Index JSON géoréférencé (`manifest.json`)
- **Showcase Visuel** : `docs/pmu_eos_tilesets/pmu_eos_tilesets_showcase.png`

---

## 2. Archives PMU Isolées en Alpha (`data/tilesets_alpha_isolated/sheets/`)

| Archive Source | Fichier Atlas Généré | Tiles Alpha Isolés | Dimensions Atlas | Description du Contenu |
| :--- | :--- | :---: | :---: | :--- |
| **Tiles0.tile** | `pmu_tiles0_alpha_atlas.png` | **739** | $1024 \times 768\text{ px}$ | Mobilier de village, clôtures, toitures, panneaux, ponts |
| **Tiles1.tile** | `pmu_tiles1_alpha_atlas.png` | **463** | $1024 \times 480\text{ px}$ | Éléments de donjon, autels, stèles, dalles de téléportation |
| **Tiles2.tile** | `pmu_tiles2_alpha_atlas.png` | **174** | $1024 \times 192\text{ px}$ | Falaises rocheuses, corniches, escarpements |
| **Tiles3.tile** | `pmu_tiles3_alpha_atlas.png` | **60** | $1024 \times 64\text{ px}$ | Éléments rares & dalles de transition spéciales |
| **Tiles4.tile** | `pmu_tiles4_alpha_atlas.png` | **2 219** | $1024 \times 2240\text{ px}$| Végétation dense, buissons, arbres, canopée, fleurs |
| **Tiles5.tile** | `pmu_tiles5_alpha_atlas.png` | **1 444** | $1024 \times 1472\text{ px}$| Cascades, vagues de rivières, reflets d'eau, écume |
| **Tiles6.tile** | `pmu_tiles6_alpha_atlas.png` | **1 505** | $1024 \times 1536\text{ px}$| Structures de bâtiments, tentes, toits de paille, arches |
| **Tiles7.tile** | `pmu_tiles7_alpha_atlas.png` | **5 748** | $1024 \times 5760\text{ px}$| Décors intérieurs, étals de marché, tonneaux, coffres |
| **Tiles8.tile** | `pmu_tiles8_alpha_atlas.png` | **5 909** | $1024 \times 5920\text{ px}$| Grand assortiment d'ornements urbains, enseignes, lampes |
| **Tiles9.tile** | `pmu_tiles9_alpha_atlas.png` | **2 191** | $1024 \times 2208\text{ px}$| Biomes spéciaux (Lave volcanique, cristaux, glace) |
| **Tiles10.tile**| `pmu_tiles10_alpha_atlas.png`| **439** | $1024 \times 448\text{ px}$ | Éléments de sol transparents et transitions de bordures |

---

## 3. Biomes & Donjons Explorers of Sky (EoS / PMDO)

| Biome / Lieu | Fichier Atlas Généré | Tiles Alpha Isolés | Type & Thématique |
| :--- | :--- | :---: | :--- |
| **Café Spinda** | `eos_spindacafe2_alpha_atlas.png` | **536** | Comptoir Spinda, tables à jus, mobilier de café |
| **Sources Chaudes** | `eos_hotspringdetail_alpha_atlas.png` | **1 776** | Bassins thermaux, vapeurs, rochers chauds, nénuphars |
| **Grotte Aegis** | `eos_aegis_cave_entrance_layer_1/2` | **206** | Runes Unown gravées, parois rocheuses, piliers |
| **Grotte Vapeur** | `eos_steam_cave_entrance_layer_1` | **41** | Fumerolles, fissures thermiques, stalagmites |
| **Grotte Cristal** | `eos_crystal_cave_entrance_layer_1` | **74** | Cristaux luminescents bleus et roses, parois de quartz |
| **Forêt du Crépuscule**| `eos_dusk_forest_entrance_layer_1` | **8** | Arbres déformés, brouillard violet, racines |
| **Étang Altere** | `eos_altere_pond_objects/fringe/cliffs` | **1 268** | Décors lacustres, îles herbeuses, pontons, roseaux |
| **Clairière Noigrume**| `eos_apricorn_glade_big_tree/objects` | **389** | Grand Arbre Noigrume, arbustes à baies, buissons |

---

## 4. Collections Maîtresses par Catégorie Thématique (`data/tilesets_alpha_isolated/categories/`)

| Catégorie Thématique | Fichier Atlas | Nombre de Tiles | Contenu Typique |
| :--- | :--- | :---: | :--- |
| **Végétation & Canopée** | `category_vegetation_and_foliage_atlas.png` | **5 264** | Arbres, buissons, fleurs, herbes hautes, nénuphars |
| **Feu & Décors Volcaniques** | `category_fire_and_red_decor_atlas.png` | **7 760** | Lave, brasiers, lanternes rouges, cristaux de feu |
| **Eau, Rivières & Glace** | `category_water_and_ice_atlas.png` | **5 070** | Écoulements d'eau, cascades, vagues, blocs de glace |
| **Petits Objets & Accessoires** | `category_small_props_and_decor_atlas.png` | **2 573** | Pots, baies, tasses, livres, parchemins, outils |
| **Architecture & Mobilier** | `category_architectural_and_furniture_atlas.png` | **2 102** | Tables, chaises, lits, étagères, piliers, fenêtres |
| **Bordures & Transitions** | `category_terrain_transition_edges_atlas.png` | **1 310** | Coins d'herbe, rives transparentes, ombrages |
| **Structures en Bois** | `category_wood_structures_and_earth_atlas.png` | **300** | Clôtures, passerelles en rondins, charpentes |

---

## 5. Structure du Manifeste (`manifest.json`)

Le fichier `data/tilesets_alpha_isolated/manifest.json` contient pour chaque tile :
- `source_archive` : L'archive PMU ou le fichier PMDO d'origine.
- `tile_index` : L'indice numérique exact du tile.
- `grid_col`, `grid_row` : La position sur la grille de l'atlas.
- `atlas_x`, `atlas_y` : Les coordonnées en pixels sur l'atlas PNG.
- `alpha_bbox` : La boîte englobante exacte des pixels non transparents `[x_min, y_min, x_max, y_max]`.
- `opaque_pixels` : Le compte exact de pixels solides.
- `density` : Le ratio de surface occupée par rapport à la taille totale du tile.
- `category` : La classification sémantique automatique.
