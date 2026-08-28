# REVERSE ENGINEERING DES MOTEURS DE DONJON DES DEUX ROMS

Sources primaires : décompilation pret/pmd-red (`/tmp/pmd-red/src/dungeon_generation.c`, 6127 lignes, matché byte-exact) pour le JEU 1 (GBA Red Rescue Team EU) ; tables mappa_s.bin extraites de la ROM EU Sky (`dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/dungeons/*.json.gz`, 180 donjons / **1795 étages**) + connaissance skytemple pour le JEU 2 (NDS Explorers of Sky EU). Les deux moteurs sont de la même famille (Chunsoft) mais PAS identiques.

## 1. GBA — GenerateFloor() (pret, fichier/lignes exacts)

### 1.1 Boucle de retry (l.159–420)
```
pour spawnAttempts 0..9 :                 # retry « spawn »
  pour genAttempts 0..9 :                 # retry « layout »
    si genAttempts>0 : budget structures secondaires = 0
    si fixedRoomNumber≠0 et full-floor → ProcessFixedRoom, fini
    sinon:
      grid aléatoire: X=RandRange(2,9), Y=RandRange(2,8) (LARGE_0x8: 2-5/2-4),
        max 32 essais pour X≤6 et Y≤4, sinon 4×4 ; si 56/X<8 → X=1 ; idem Y
      switch layout % 16 → 11 générateurs (voir 1.2)
    ResetInnerBoundaryTileRows ; EnsureImpassableTilesAreWalls
    VALIDATION: ≥30 tuiles de salle ET ≥2 salles → break
  si 10 échecs layout → GenerateOneRoomMonsterHouseFloor + forceMonsterHouse
  FinalizeJunctions ; GenerateSecondaryTerrainFormations (si secondaryGen)
  isEmptyMonsterHouse = Rand(100) < itemlessMonsterHouseChance
  SpawnNonEnemies ; SpawnEnemies ; ResolveInvalidSpawns
  VALIDATION: playerSpawn ok ET escaliers atteignables (StairsAlwaysReachable) → break
si 10 échecs spawn → bailout One-Room Monster House (sans validation)
enfin : spawn Kecleon (espèce) au centre du shop si présent
```
**ENGINE RULES** : retry 10×10, validation ≥2 salles/≥30 tuiles, bailout MH une-salle, atteignabilité escaliers obligatoire.

### 1.2 Les 16 layouts (dungeon_generation.h l.13–29)
`LARGE(0), SMALL(1), ONE_ROOM_MONSTER_HOUSE(2), OUTER_RING(3), CROSSROADS(4), TWO_ROOMS_WITH_MONSTER_HOUSE(5), LINE(6), CROSS(7), LARGE_0x8(8), BEETLE(9), OUTER_ROOMS(10), MEDIUM(11), UNUSED 12–15`.
- SMALL : grid 4×(2-3) ; MEDIUM : 4×(2-3) taille médium ; LARGE : grid libre.
- OUTER_RING : anneau de couloirs, salles au centre 4×2 ; CROSSROADS : salles en bord, couloirs croisés au centre ; LINE : 1 ligne horizontale ; CROSS : 4 salles en croix ; BEETLE : 3 colonnes dont centrale fusionnée (MergeRoomsVertically) ; OUTER_ROOMS : salles en périphérie, centre couloirs.
- ONE_ROOM_MH / TWO_ROOMS_MH : étages « pièges » entièrement Monster House, aussi utilisés comme bailout.

### 1.3 GenerateStandardFloor (l.462–489) — pipeline cellulaire
```
GetGridPositions → InitDungeonGrid → AssignRooms(roomDensity)
→ CreateRoomsAndAnchors(roomFlags)          # salles OU ancres 1×1 (jonctions couloir)
→ AssignRandomGridCellConnections(floorConnectivity)
→ CreateGridCellConnections                  # couloirs en L (CreateHallway avec turn)
→ EnsureConnectedGrid                        # répare la connexité
→ GenerateMazeRoom(mazeRoomChance)           # salle-labyrinthe
→ GenerateKecleonShop(kecleonShopChance)     # voir 1.5
→ GenerateMonsterHouse(monsterHouseChance)   # voir 1.4
→ GenerateExtraHallways(numExtraHallways)    # couloirs supplémentaires → BOUCLES
→ GenerateRoomImperfections                  # voir 1.6
→ GenerateSecondaryStructures                # voir 1.7
```
`roomDensity` : >0 = valeur+variance, ≤0 = |valeur| exact (même convention que densités). Cellules non-salle = ancres → apparence de « couloirs qui se croisent ».

### 1.4 Monster House GBA (règles exactes)
- Éligibilité étage : `Rand(100) < monsterHouseChance` ET pas de Kecleon shop ET floor type NORMAL.
- Choix de salle : équiprobable parmi les salles valides (ni fusionnées, ni maze, ni structure secondaire).
- **Spawn** : base `gMonsterHouseMaxMons = 12` (dungeon_config.c l.22) ; si « empty MH » → 3 ; plafond effectif = base×3/2 = **18** ; nombre tiré = `RandRange(70 % , 80 % des tuiles valides de la salle)` puis plafonné. Une salle de 8×6 ≈ 48 tuiles → tirage 33–38 → **plafonné à 18 monstres**. Items+pièges MH : `RandRange(count/2, count*8/10)`, min 6, max `gMonsterHouseMaxItemsTraps = 7`; 50/50 item/piège.
- ⇒ **La règle canonique est : 12–18 Pokémon dans une vraie Monster House GBA** (>10, conforme à l'exigence §18).

### 1.5 Kecleon shop GBA
- `Rand(100) < kecleonShopChance`, exclusif avec MH (MH généré APRÈS, refuse si shop) ; type d'étage RESCUE exclu.
- Salle ≥5×4 choisie par double liste mélangée (200 swaps) ; shop = intérieur avec bordure 1 tuile ; interdit spawn monstres/escaliers dans le shop ; Kecleon (espèce fixe) placé au CENTRE.

### 1.6 Imperfections de salles (l.75, GenerateRoomImperfections)
- Conditions : salle normale connectée, sans structure secondaire/maze, flag `flagImperfect` (roomFlags de l'étage).
- 60 % de chance d'application (40 % `NO_IMPERFECTIONS_CHANCE`).
- Algorithme : `length=(w+h)/4` itérations ; à chaque itération, 2 passes (horaire/anti-horaire) depuis un coin aléatoire → remplit des murs en grignotant les coins ⇒ **salles concaves/asymétriques** (ni carrées ni rectangulaires).

### 1.7 Structures secondaires (GenerateSecondaryStructure, tirage Rand(6))
Budget par étage (`secondaryStructuresBudget`, annulé dès le 2e essai de layout) :
- `DIVIDER` : salle coupée en 2 par une ligne d'eau/lave (verticale ou horizontale).
- `ISLAND` (≥6×6) : douve d'eau + île centrale avec **items + Warp Tile + piège** (risque/récompense structuré).
- `POOL` (≥5×5) : rectangle d'eau aléatoire intérieur.
- `CHECKERBOARD` (dims impaires) : damier diagonal d'eau.
- `MAZE_PLUS_DOT` : croix d'eau centrale, point central, ou maze room selon parité.

### 1.8 Spawns GBA (SpawnEnemies/SpawnNonEnemies, sémantique des densités)
- Ennemis : `d>0 → RandRange(d/2,d) min 1 ; d≤0 → |d| exact`. BUG documenté pret : densité lue non signée (255 pour Deoxys).
- Items : `n = RandRange(d-2, d+2)`, min 1 si d≠0 ; buried items pareil (dans les murs).
- Pièges : `n = RandRange(d/2, d)`, **max 56**.
- Tuiles éligibles ennemis : salle, hors shop, hors item/escalier, hors jonction naturelle, hors spawn joueur. `ShuffleSpawnPositions` + index de départ aléatoire + parcours circulaire.
- Monster House forcée : voir 1.4 (70–80 % des tuiles).

### 1.9 RNG GBA
`DungeonRandInt/DungeonRandRange` : LCG dédié au donjon (état dans gDungeon), déterministe par seed. Ordre d'appels = celui du pipeline ci-dessus (les retries CONSOMMENT du RNG → la reproduction exacte exige la même séquence d'appels).

## 2. NDS Sky — données mappa_s.bin (1795 étages, extraction EU vérifiée)

### 2.1 FloorProperties Sky (par étage, champs supplémentaires vs GBA)
Relevé exhaustif sur nos tables (statistiques réelles) :
| Champ | Étages concernés | Statut |
|---|---|---|
| structure (12 valeurs : MEDIUM_LARGE 945, MEDIUM 614, SMALL 121, MEDIUM_LARGE_13/14/15 40, CROSSROADS 24, BETTLE 18, CROSS 16, RING 13, LINE 3, SMALL_MEDIUM 1) | 1795 | équiv. layouts GBA |
| floor_connectivity, room_density, extra_hallway_density (>0 sur **1623** étages), dead_ends (**726**) | 1795 | topologie |
| initial_enemy_density, item_density, trap_density, buried_item_density, water_density | 1795 | densités |
| monster_house_chance (>0 : **1223** ét.), empty_monster_house_chance (>0 : 18) | 1795 | MH |
| kecleon_shop_chance (>0 : **973** ét.), kecleon_shop_item_positions | 1795 | shop |
| **hidden_stairs_spawn_chance (>0 : 435 étages)** | 1795 | Mystery Floors ! |
| **sticky_item_chance (>0 : 907 étages)** | 1795 | items collants |
| darkness_level, weather, enemy_iq, iq_booster_boost, max_coin_amount, fixed_floor_id | 1795 | ambiance/règles |
| terrain_settings.generate_imperfect_rooms (0 étage EU n'active PAS ce flag ici : **0 relevé**) | — | voir note |

Note imperfections Sky : dans nos tables EU le flag `generate_imperfect_rooms` est partout FALSE — le moteur Sky possède l'algorithme (hérité GBA) mais les données ne l'activent pas ; les salles irrégulières viennent de water_density/terrain secondaire. À l'inverse, GBA l'active par roomFlags par étage.

### 2.2 Spécifique Sky (absent GBA)
- **Hidden Stairs** (435 étages) → Mystery/Treasure floors ; sticky items (907 étages) ; ambush/special floors via fixed_floor_id ; magasins d'items positionnés (`kecleon_shop_item_positions`) ; IQ ennemis ; météo par étage.
- Monsters/traps/items par étage = SpawnLists pondérées /10000 (déjà importées : nos zones « Tables realignées ROM EU mappa_s.bin exact », cf. Comment de dusk_forest.json).

### 2.3 Commun / Différent / Spécifique
| Mécanique | GBA | Sky |
|---|---|---|
| Grille cellulaire + layouts nommés | ✔ | ✔ (mêmes familles) |
| Retry + bailout MH | ✔ | ✔ (équivalent) |
| Densités signées (exact si ≤0) | ✔ | ✔ |
| MH 70–80 % tuiles, plafond | ✔ (18) | ✔ (plafond ~30 côté NDS) |
| Imperfections | activées par étage | présentes, non activées (EU data) |
| Hidden stairs / Mystery floors | ✘ | ✔ (435 ét.) |
| Sticky items | ✘ | ✔ (907 ét.) |
| Météo par étage | ✘ (météo par mécanique) | ✔ champ direct |
| Kecleon shop | ✔ centre unique | ✔ + positions d'items |

## 3. Séparation ENGINE RULE vs DUNGEON DATA (obligatoire, §8)
**ENGINE (à porter comme systèmes)** : retry/validation/bailout ; 11 layouts ; couloirs en L + extra hallways ; imperfections ; 5 structures secondaires ; règles MH (70–80 %/plafond/items+pièges) ; règles Kecleon (5×4/bordure/centre) ; sémantique densités signées ; éligibilité de tuiles de spawn ; hidden stairs.
**DATA (par étage, déjà extraite)** : layout id, room/enemy/item/trap/buried/water densités, connectivité, extra hallways, chances MH/shop/hidden/sticky, météo, darkness, IQ, argent, fixed rooms, spawn tables pondérées.
