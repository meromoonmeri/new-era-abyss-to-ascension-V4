# Analyse Technique Complète de PMU-Server (Pokémon Mystery Universe)

## 1. Introduction et Architecture Globale

**Pokémon Mystery Universe (PMU)** est un MMORPG PMD développé en C# .NET (framework SdlDotNet / XNA / WinForms / MySQL). Le serveur gère la persistance du monde dans une base de données relationnelle MySQL (`pmu_data.sql`), tandis que le client met en cache certaines cartes sous forme de fichiers binaires chiffrés (`Map-*.dat`) et stocke les planches graphiques dans des conteneurs `.tile`.

### Chaîne de Traitement et Flux de Données

```text
[ Base MySQL pmu_data.sql / Content_Data.zip ]
        │
        ├──> Tables SQL : map_general, map_data, map_tiles, map_npcs, npc, item, story
        │         │
        │         ▼ (Désérialisation / Ingestion)
        ├──> [ PMUExtractor / SQLite Standard ]
        │         │
        │         ├──> Structured Documents : pmu_map.json, collision.json, semantics.json, entities.json, tileset.json
        │         │
        │         ▼ (Compositing Multi-Couches & Animations)
        ├──> [ PMURenderer + Tiles*.tile Archives ]
        │         │
        │         ├──> Golden PMU Renders : original.png, preview.png, collision.png
        │         │
        │         ▼ (Transformation Spatiale & Discrétisation 1:1)
        ├──> [ PMDOConverter ]
        │         │
        │         ├──> PMDO Native Assets : .rsground, .tile (premul RGBA), init.lua
        │         │
        │         ▼ (Validation Round-Trip Pixel-Perfect & Collision)
        └──> [ PMDOValidator ]
                  │
                  └──> Certification : Diff 0.00%, Collision 100%, Git Promotion
```

---

## 2. Structure et Désérialisation des Cartes

### 2.1 Schéma des Données SQL
Dans `PMU-Server/DataManager/DataManager/Maps/MapDataManager.cs`, les données d'une map standard (`s1` à `s2000`) sont réparties sur plusieurs tables :

1. **`map_general`** :
   - `map_id` (TEXT) : Identifiant canonique (ex. `s95`, `s737`, `s1810`).
   - `version` (INT) : Numéro de version du format.
   - `revision` (INT) : Compteur incrémental de modification.
   - `max_x`, `max_y` (INT) : Coordonnées maximales inclusives. Dimensions réelles : `(max_x + 1) × (max_y + 1)`.

2. **`map_data`** :
   - `name` (TEXT) : Nom textuel de la map.
   - `moral` (INT) : Statut moral (0: None, 1: Safe, 2: NoPenalty, 3: House).
   - `music` (TEXT) : Fichier audio d'ambiance (BGM).
   - `indoors` (TEXT) : Flag intérieur ('1' ou '0').
   - `weather` (INT) : Météo active (0: Ambiguous, 1: None, 2: Raining, 3: Snowing, 4: Thunder, 5: Hail, 6: DiamondDust, 7: Cloudy, 8: Fog, 9: Sunny, 10: Sandstorm, 11: Snowstorm, 12: Ashfall).
   - `darkness` (INT) : Rayon de pénombre (-1 = lumière normale, > -1 = champ de vision restreint en donjon).
   - `hunger_enabled`, `recruitment_enabled`, `exp_enabled`, `time_limit` : Paramètres de gameplay.
   - `min_npcs`, `max_npcs`, `npc_spawn_time` : Paramètres d'apparition d'ennemis sauvages.

3. **`map_switchovers`** :
   - `up_map`, `down_map`, `left_map`, `right_map` (INT) : Identifiants des maps adjacentes pour la transition de bord de carte (Seamless World).

4. **`map_tiles`** (28 colonnes de données par tuile) :
   - `x`, `y` (INT) : Coordonnées logiques de la tuile.
   - `ground`, `ground_anim`, `ground_tileset`, `ground_anim_tileset`
   - `mask`, `mask_anim`, `mask_tileset`, `mask_anim_tileset`
   - `mask2`, `mask2_anim`, `mask2_tileset`, `mask2_anim_tileset`
   - `fringe`, `fringe_anim`, `fringe_tileset`, `fringe_anim_tileset`
   - `fringe2`, `fringe2_anim`, `fringe2_tileset`, `fringe2_anim_tileset`
   - `type` (INT) : Code `TileType`.
   - `data1`, `data2`, `data3` (INT) : Paramètres numériques sémantiques.
   - `string1`, `string2`, `string3` (TEXT) : Données textuelles (messages, scripts).
   - `light` (INT) : Intensité lumineuse locale.

---

## 3. Système de Couches et Moteur de Rendu

### 3.1 Ordre de Dessin des Couches
Le moteur de rendu original PMU (`Client/Graphics/Renderers/Maps/MapRenderer.cs`) dessine les 5 couches dans l'ordre strict :
1. **Ground** : Sol de base opaque ou semi-transparent.
2. **Mask** : Première couche de décoration au sol (chemins, débris, bordures).
3. **Mask2** : Deuxième couche de décoration au sol (pierres, fleurs, objets fixes).
4. **Fringe** : Couche de superposition au-dessus des sprites joueurs/PNJ (hauts d'arbres, toitures basses).
5. **Fringe2** : Couche de superposition haute (arches, falaises supérieures, éléments volants).

### 3.2 Règles d'Animation et Fallbacks
- **Index 0 = Do Nothing** : Si `tile_id == 0`, la couche est transparente et rien n'est dessiné.
- **Remplacement Animé** : Lorsque l'état d'animation est actif (bascule toutes les 250 ms, période de 500 ms) :
  - Si le champ animé (`*_anim`) est non-nul (`!= 0`), il **remplace intégralement** la tuile de base pour cette couche.
  - Si le champ animé est égal à 0, la tuile de base est conservée.
- **Fallback Hors Limites** : Si un `tile_id` dépasse la capacité de l'archive tileset, le renderer PMU se replie sur la tuile 0 (`Tileset.GetTileGraphic`).
- **Fond de Scène** : Le fond est initialisé en blanc pur opaque `(255, 255, 255, 255)` conformément à `MapViewer.CaptureMapImage`.

---

## 4. Système de Collision et Sémantique (`TileType`)

Dans `Server/Core/Enums.cs` et `MovementProcessor.cs`, PMU gère 40 types de tuiles :

| Code | Nom | Comportement de Collision | Données Associées |
| :--- | :--- | :--- | :--- |
| **0** | `Walkable` | Marchable sans restriction | — |
| **1** | `Blocked` | Bloqué (obstacle infranchissable, mur) | — |
| **2** | `Warp` | Téléporteur / Sortie | `Data1`: Map cible, `Data2`: X cible, `Data3`: Y cible |
| **3** | `Item` | Objet au sol | `Data1`: Item ID, `Data2`: Quantité, `Data3`: Statut |
| **4** | `NPCAvoid` | Marchable pour joueur, évité par IA PNJ | — |
| **5** | `Key` | Porte verrouillée par clé | `Data1`: Clé Item ID, `Data2`: Retirer clé |
| **6** | `KeyOpen` | Porte déverrouillée | — |
| **7** | `Heal` | Soin total | — |
| **8** | `Kill` | Piège mortel / Gouffre | — |
| **9** | `Shop` | Emplacement de vente marchand | `Data1`: Item ID, `Data2`: Prix |
| **10** | `MobileBlock` | Bloqué sauf capacités de mobilité (Eau, Lave, Spectre) | `Data1`: Bitmask de mobilité |
| **11** | `Arena` | Zone de combat PvP actif | — |
| **12** | `Sound` | Déclenchement d'effet sonore | `Data1`: Sound ID |
| **13** | `SpriteChange`| Métamorphose temporaire du sprite | `Data1`: Sprite ID cible |
| **14** | `Sign` | Panneau lisible (bloque le passage) | `String1`, `String2`, `String3`: Lignes de texte |
| **15** | `Door` | Porte de bâtiment / transition | `Data1`: Map cible, `Data2`: X, `Data3`: Y |
| **16** | `Notice` | Message automatique au passage | `String1`, `String2`, `String3` |
| **17** | `Chest` | Coffre au trésor interactif | `Data1`: Item ID, `Data2`: Quantité |
| **18** | `LinkShop` | Stand du Maître des Capacités | — |
| **19** | `Scripted` | Déclencheur de script Lua/C# | `Data1`: Script ID, `Data2-3`, `String1-3` |
| **20** | `NpcSpawn` | Point d'apparition de PNJ | `Data1`: NPC Num |
| **21** | `House` | Entrée de maison de joueur | — |
| **22** | `Bank` | Banque Skelénox | — |
| **23** | `Guild` | Rassemblement de guilde / Éodile | — |
| **24** | `SpriteBlock`| Bloqué selon l'espèce Pokémon | `Data1`: Mode (1: Autorisé, 2: Refusé), `Data2-3`: Sprite IDs |
| **25** | `LevelBlock` | Bloqué si Niveau ≤ `Data1` | `Data1`: Niveau requis |
| **26** | `Assembly` | Réserve Pokémon (Éoko) | — |
| **27** | `Evolution` | Source d'évolution (Source Lumineuse) | — |
| **28** | `Story` | Déclencheur cinématique d'histoire | `Data1`: Story ID |
| **29** | `MissionBoard`| Tableau des missions | — |
| **30** | `RDungeonGoal`| Escalier / Sortie de donjon aléatoire | — |
| **31** | `ScriptedSign`| Panneau interactif scripté (bloque) | `Data1`: Script ID, `String1-3` |
| **32** | `SpeciesChange`| Changement de forme d'espèce | `Data1`: Espèce ID |
| **33** | `Hallway` | Couloir de donjon | — |
| **34** | `HouseRoomWarp`| Téléportation intérieure maison | — |
| **35** | `HouseOwnerBlock`| Bloqué pour non-propriétaires | — |
| **36** | `Ambiguous` | Historique / Indéfini | — |
| **37** | `Slippery` | Sol glissant (glace) | — |
| **38** | `Slow` | Sol ralentissant (toile, boue) | `Data1`: Mobilité, `Data2`: Vitesse |
| **39** | `DropShop` | Zone de dépôt de vente | — |

---

## 5. Entités, PNJ et Spawners

Les apparitions de créatures et PNJ sont modélisées par la table `map_npcs` :
- `slot` : Emplacement d'entité (0 à 255).
- `number` : Numéro de définition de PNJ (`npc_defs.num`).
- `spawn_x`, `spawn_y` : Coordonnées de placement initial (-1 si aléatoire).
- `min_level`, `max_level` : Plage de niveaux de la créature générée.
- `appearance_rate` : Probabilité d'apparition en pourcentage.
- `npc_defs` associe chaque créature à :
  - `name` : Nom d'espèce (ex. "Grimer", "Geodude", "Kecleon").
  - `sprite` : Index de sprite du Pokémon.
  - `behavior` : Comportement IA (AttackOnSight, Friendly, Shopkeeper, Guard, Scripted).
  - `script` : Script de dialogue ou d'action associé.

---

## 6. Correspondance PMU → PMDO / New Era

| Aspect | PMU-Server | RogueEssence / PMDO | Correspondance / Conversion |
| :--- | :--- | :--- | :--- |
| **Taille Tuile** | 32 × 32 pixels | Variable (`TexSize`: 1=8px, 2=16px, 4=32px) | Découpage exact en sous-tuiles 8×8 (TexSize 1) |
| **Collision** | Grille 32×32 px (TileType 0..39) | Grille d'obstacles 8×8 px (`Tags`: 0/1) | 1 tuile PMU = bloc 4×4 sous-cellules PMDO (16 obstacles 8px) |
| **Couches** | 5 couches nommées fixes | Liste dynamique ordonnée de GroundLayers | 5 couches PMDO : `PMU Ground`, `PMU Mask`, `PMU Mask2`, `PMU Fringe`, `PMU Fringe2` |
| **Atlas Tuiles** | Fichiers `.tile` (format PMU binaire) | Fichiers `.tile` (format RogueEssence premul RGBA) | Déduplication par hash et réencodage premultiplied alpha |
| **Animations** | Toggle 250ms (500ms période) | Multi-frames avec `FrameLength` en ticks (60Hz) | 2 frames (`Base` + `Anim`), `FrameLength = 15` (15/60s = 250ms) |
| **Warps** | `TileType.Warp` (Data1, Data2, Data3) | Markers + Triggers Lua (`init.lua`) | Marker `Warp_N` + fonction Lua `Warp_N_Touch` |
| **Panneaux** | `TileType.Sign` (String1, String2, String3) | GroundObjects + Triggers Lua | GroundObject `Sign_N` + fonction Lua `Sign_N_Action` |
| **PNJ** | `map_npcs` + `npc_defs` | `MapChars` dans la couche `PMU Entities` | `MapChar` avec position exacte `(x*32+16, y*32+16)` |
