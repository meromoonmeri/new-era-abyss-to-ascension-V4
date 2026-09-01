# Pack Complet d'Assets de Bourg-Trésor (Treasure Town) pour PMDO Editor

Ce pack regroupe l'intégralité des ressources graphiques de **Bourg-Trésor (Treasure Town / EoS)** détourées avec un **canal alpha transparent (RGBA 32-bit sans fond)**, prêtes à être importées et utilisées directement dans le **PMDO Editor (Ground Editor / Map Editor)**.

---

## 📁 Arborescence des Ressources

```text
data/treasure_town_editor_assets/
├── manifest.json                                  # Index complet géoréférencé
├── treasure_town_assets_showcase.png              # Planche de contact visuelle globale
│
├── objects/                                       # Objets et structures isolés (Alpha Isolate)
│   ├── signs/                                     # Panneaux, stèles et tableaux de missions
│   │   ├── sign_crossroads_classic.png            # Panneau indicateur du carrefour (4 directions)
│   │   ├── sign_wooden_simple.png                 # Panneau en bois simple
│   │   └── mission_board_guild.png                # Grand tableau d'affichage des missions
│   │
│   ├── shops_and_stands/                          # Échoppes, boutiques et stands de marché
│   │   ├── kecleon_shop_green_day.png             # Stand Kecleon Vert (Jour)
│   │   ├── kecleon_shop_purple_night.png          # Stand Kecleon Violet (Nuit)
│   │   ├── spinda_cafe_day.png                    # Grand comptoir du Café Spinda
│   │   ├── spinda_cafe_night.png                  # Café Spinda (Ambiance Nuit)
│   │   ├── merchant_stand_wood.png                # Éventaire de marché en bois
│   │   └── merchant_counter_low.png               # Comptoir bas de marchand
│   │
│   ├── tents_and_houses/                          # Tentes d'expédition et maisons de village
│   │   ├── tent_expedition_blue.png               # Tente d'expédition bleue avec ouverture
│   │   ├── tent_expedition_plain.png              # Grande tente de campement unie
│   │   ├── beach_tent_coastal.png                 # Tente de plage côtière
│   │   ├── house_town_normal.png                  # Maison standard de Bourg-Trésor
│   │   ├── house_leaf_hut_1.png / _2.png          # Chaumières à toit de feuilles
│   │   ├── metano_house_fire.png / _rock.png      # Variantes de maisons à thèmes
│   │   └── shop_grand_bazaar.png                  # Grand Bazar de Guilde
│   │
│   ├── furnishing_and_props/                      # Mobilier urbain et accessoires
│   │   ├── kangaskhan_storage_chest.png           # Coffre de réserve Kangourex
│   │   ├── kangaskhan_rock_statue.png             # Statue en pierre de Kangourex
│   │   ├── berry_basket_red.png / _blue.png       # Paniers de baies rouges et bleues
│   │   ├── terracotta_pot.png                     # Jarres en terre cuite
│   │   ├── wooden_fence.png                       # Palissades et clôtures en bois
│   │   ├── stump_table.png / stump_chair.png      # Tables et tabourets en souche d'arbre
│   │   ├── hay_bed.png                            # Couchette de paille
│   │   ├── river_stone_round.png / _diamond.png   # Pierres et rochers de gué
│   │   └── closed_guild_door.png                  # Grande porte de la Guilde fermée
│   │
│   └── vegetation_and_nature/                     # Arbres, massifs floraux et haies
│       ├── tree_town.png                          # Grand arbre urbain ombragé
│       ├── hedge_town.png                         # Haie végétale taillée
│       ├── flowerpot_pink.png / _white.png        # Pots de fleurs décoratifs
│       ├── flowers_town_1.png à _5.png            # 5 variantes de massifs de fleurs
│       ├── flowers_tropical_1.png à _5.png        # 5 variantes de fleurs exotiques
│       ├── logs_large.png / _small.png / _stacked # Rondins et tas de bois coupés
│       └── apricorn_big.png                       # Noigrume géant
│
├── animated_objects_frames/                       # Objets animés découpés Frame par Frame
│   ├── campfire/                                  # Feu de camp (4 frames + strip + .dir)
│   ├── yellow_box/                                # Boîte mystère scintillante (6 frames + strip)
│   ├── origins_well/                              # Puits de village avec manivelle animée (4 frames)
│   ├── origins_windmill/                          # Moulin à vent avec rotation des ailes (4 frames)
│   ├── diary_blue_opening/ & _closing/            # Journal de bord bleu (4 frames d'ouverture/fermeture)
│   └── diary_red_opening/ & _closing/             # Journal de bord rouge (4 frames d'ouverture/fermeture)
│
└── tilesets_pmdo_editor/                          # Tilesets complets compatibles PMDO Editor
    ├── treasure_town_west_atlas.png & .tile       # Grille 24x24 px : Zone Ouest (Kecleon)
    ├── treasure_town_east_atlas.png & .tile       # Grille 24x24 px : Zone Est (Kangourex, Élekable)
    ├── treasure_town_t00p01_atlas.png & .tile     # Grille 8x8 px : Base T00P01
    ├── treasure_town_t00p02_atlas.png & .tile     # Grille 8x8 px : Base T00P02
    ├── treasure_town_t00p03_atlas.png & .tile     # Grille 8x8 px : Base T00P03 (Falaise Nord)
    ├── treasure_town_crossroads_sign_atlas.png    # Grille 8x8 px : Atlas du Panneau de Carrefour
    └── treasure_town_spinda_cafe_props_atlas.png  # Grille 8x8 px : Mobilier du Café Spinda
```

---

## 🛠️ Guide d'Utilisation dans le PMDO Map Editor

### 1. Utilisation des Bâtiments et Objets Isolés (`objects/`)
- Tous les fichiers PNG sont en **couleur 32-bit avec fond transparent alpha parfait**.
- Vous pouvez directement les déposer en tant que **Sprites / Entités d'environnement / Overlays** ou les découper sur la grille $24\times24$ ou $8\times8$ de votre Ground.

### 2. Utilisation des Objets Animés (`animated_objects_frames/`)
- Chaque dossier contient :
  - Les frames isolées numérotées : `frame_0.png`, `frame_1.png`, etc.
  - La bande horizontale complète : `*_animation_strip.png`.
  - Le fichier natif PMDO : `*.dir` (avec les dimensions et métadonnées de bouclage intégrées).
- Pour configurer une entité animée dans le PMDO Editor, sélectionnez le fichier `.dir` correspondant dans `Content/Object/` ou importez la bande de frames.

### 3. Utilisation des Tilesets (`tilesets_pmdo_editor/`)
- Les fichiers `.tile` sont des binaires natifs PMDO qui peuvent être copiés dans votre dossier `Content/Tile/`.
- Les fichiers `.png` correspondants vous permettent d'éditer ou de prévisualiser l'ensemble des textures sur votre logiciel de dessin (Aseprite, Photoshop, PixelLab).
