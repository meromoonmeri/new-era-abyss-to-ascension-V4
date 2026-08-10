# INVENTAIRE EXHAUSTIF SOURCE — Sinister Woods (Blue APHP)

**MODE: AUDIT SOURCE ONLY — AUCUNE MODIFICATION NEW ERA / gloomy_forest.json**

## Couverture (calculée)

| Catégorie | TOTAL | DECODED | PARTIAL | NOT_DECODED | autres |
|---|---:|---:|---:|---:|---:|
| buried_items_payload | 13 | 0 | 0 | 13 | 0 |
| dungeon_name_string | 1 | 1 | 0 | 0 | 0 |
| events | 13 | 0 | 0 | 13 | 0 |
| floor_id | 13 | 13 | 0 | 0 | 0 |
| floor_properties | 13 | 13 | 0 | 0 | 0 |
| generation_algorithm | 13 | 0 | 0 | 13 | 0 |
| generation_fields | 13 | 13 | 0 | 0 | 0 |
| graphics_b10_canm | 1 | 0 | 0 | 0 | 1 |
| graphics_b10_cel | 1 | 0 | 0 | 0 | 1 |
| graphics_b10_cex | 1 | 0 | 0 | 0 | 1 |
| graphics_b10_fon | 1 | 0 | 0 | 0 | 1 |
| graphics_b10_pal | 1 | 0 | 0 | 0 | 1 |
| graphics_b41_canm | 1 | 0 | 0 | 0 | 1 |
| graphics_b41_cel | 1 | 0 | 0 | 0 | 1 |
| graphics_b41_cex | 1 | 0 | 0 | 0 | 1 |
| graphics_b41_fon | 1 | 0 | 0 | 0 | 1 |
| graphics_b41_pal | 1 | 0 | 0 | 0 | 1 |
| grounds_packages | 10 | 0 | 0 | 0 | 10 |
| items | 13 | 0 | 13 | 0 | 0 |
| kecleon_shop_payload | 13 | 0 | 0 | 13 | 0 |
| mh_items_payload | 13 | 0 | 0 | 13 | 0 |
| music_id | 13 | 13 | 0 | 0 | 0 |
| music_sdat_chain | 13 | 0 | 13 | 0 | 0 |
| narrative_grounds | 1 | 0 | 1 | 0 | 0 |
| narrative_meanies | 1 | 0 | 0 | 1 | 0 |
| pokemon_spawns | 13 | 13 | 0 | 0 | 0 |
| stairs | 13 | 0 | 0 | 13 | 0 |
| tileset_graphics | 13 | 0 | 13 | 0 | 0 |
| tileset_id | 13 | 13 | 0 | 0 | 0 |
| traps | 13 | 13 | 0 | 0 | 0 |

## Musique — chaîne
- FloorProperties.bgMusic = **4** (`SOURCE_NDS`)
- CROSS_REFERENCE_RED MusicID[4] = `MUS_DREAM`
- CROSS_REFERENCE_RED DungeonMusicID[4] = `DUNGEON_MUS_SINISTER_WOODS`
- SOURCE_NDS SDAT SEQ[4] = `SND_BGM_M_EVENT_DREAM_01`
- SOURCE_NDS SDAT SEQ[15] = `SND_BGM_M_DUNGEON_AYASHIIMORI_01` (candidat étymologique 怪しい森)
- **Chaîne résolue:** PARTIAL / status=NOT_FULLY_DECODED

## Tileset
- Procedural floors tileset id **41** → `b41*` (`SOURCE_NDS` + `DERIVED_MAPPING`)
- `b10*` = autre jeu de graphismes dungeon.sbin; grounds `B10P01/P02` = packages cutscene (`SOURCE_NDS`)
- Ne pas confondre b10 (grounds/cutscenes) et b41 (tileset procédural des floors)

## Grounds B10 / D04
- `B10P01A` size=664 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/PALETTE_OR_LAYER_A_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01B` size=724 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/PALETTE_OR_LAYER_B_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01B3` size=200 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/SMALL_AUX_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01C` size=664 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/PALETTE_OR_LAYER_C_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01C1` size=5020 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/TILEMAP_OR_BG_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01Cc` size=23096 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/COMPRESSED_BG_OR_CELL_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P01Cm` size=1036 role=CUTSCENE_OR_GROUND_PACKAGE_ENTRY_VARIANT/META_OR_MAP_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P02A` size=1972 role=CUTSCENE_OR_GROUND_PACKAGE_END_VARIANT/PALETTE_OR_LAYER_A_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P02B` size=1972 role=CUTSCENE_OR_GROUND_PACKAGE_END_VARIANT/PALETTE_OR_LAYER_B_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED
- `B10P02C` size=1372 role=CUTSCENE_OR_GROUND_PACKAGE_END_VARIANT/PALETTE_OR_LAYER_C_CANDIDATE status=SOURCE_NDS_EXTRACTED_NOT_DECODED

## Items
- Tables indices utilisés par F1–F13: [11, 12]
- Statut: **PARTIAL** — flux u16 brut SOURCE_NDS; cumuls de catégories 3077/5385/9615/10000 concordent Red pour tables 11/12
- Décodage ID objet par entrée: **NOT_DECODED**

## Traps
- Table index 2 pour tous les floors Sinister (SOURCE_NDS floor_id)
- Format u16[20] poids (SOURCE_NDS); noms CROSS_REFERENCE_RED
- Valeurs observées: presque tout à 0, poids 10000 sur un index — vérifier sémantique (table « no traps » vs wonder tile)

## Narrative / Meanies
- **NOT_DECODED** — packages B10/D04 extraits mais scripts/SSB non décodés
- Interdiction de transposition Team Dazzling tant que timeline source absente

## Conversion
- `gloomy_forest.json`: **FROZEN**
- RogueElements / New Era scripts: **FORBIDDEN**
- Prochain jalon: compléter NOT_DECODED listés dans MANIFEST_SOURCE_CANONIQUE.json
