# RÈGLES DE GÉNÉRATION ROM — RÉFÉRENTIEL NORMATIF (extraites du binaire/décompilation)

Chaque règle est traçable (fichier/ligne pret ou champ mappa_s). Ce référentiel est LA source pour valider notre implémentation PMDO — jamais « à l'œil ».

## R1. Retry & validation (GBA GenerateFloor l.159-420)
- R1.1 : 10 essais de layout × 10 essais de spawn.
- R1.2 : layout valide ssi ≥ 2 salles ET ≥ 30 tuiles de salle.
- R1.3 : spawn valide ssi playerSpawn placé ET escaliers atteignables (BFS `StairsAlwaysReachable`).
- R1.4 : bailout = One-Room Monster House forcée.
- Équivalents PMDO : MapGen réessaie via `DetectIsolatedStairsStep`/`EraseIsolated*` (préventif, pas répara-retry). ⚠ Pas de bailout MH natif.

## R2. Dimensions de grille (GBA l.223-250)
X=Rand[2,9), Y=Rand[2,8), contrainte X≤6,Y≤4 (32 essais, défaut 4×4) ; cellule ≥8 tuiles sinon dimension=1. SMALL/MEDIUM : X=4, Y=2-3.

## R3. Densités (GBA SpawnEnemies/SpawnNonEnemies + src/dungeon_generation.c pret ; Sky identique)
- R3.1 ennemis : d>0 → RandRange(d/2,d) min 1 ; d≤0 → |d| exact.
- R3.2 items : RandRange(d-2,d+2) min 1 (si d≠0) ; buried idem, dans les murs.
- R3.3 pièges : RandRange(d/2,d), max 56.
- R3.4 argent : max_coin_amount (Sky) / moneyUpperBound×40 (GBA FloorProperties offset 23).
- ✔ Déjà appliqué chez nous (fix « donjons vides », preuve dprobe 20 étages).

## R4. Monster House (GBA GenerateMonsterHouse + SpawnEnemies fin)
- R4.1 : proba par étage = monsterHouseChance % (par étage, PAS par donjon). ✔ déjà corrigé (52 zones, SpreadPlanChance par plages).
- R4.2 : exclusif avec Kecleon shop (shop tiré d'abord... ordre GBA : shop AVANT MH dans StandardFloor ; MH refuse si `sHasKecleonShop`).
- R4.3 : salle choisie équiprobablement parmi éligibles (pas la salle de départ chez PMDO via NoMonsterHouseEntrances).
- R4.4 : nombre de monstres = RandRange(70 %, 80 % des tuiles de la salle), min 1, plafonné à 12×3/2=**18** (empty MH : 3×3/2=4).
- R4.5 : items+pièges = RandRange(50 %, 80 % tuiles), min 6, max 7 ; 50/50 item/piège.
- ⚠ Notre réglage actuel : Amount fixe 7–13 (indépendant de la taille de salle) → PARTIAL vs R4.4. PMDO `MobThemeNone.Amount` ne dépend pas de la salle ; extension nécessaire (voir MODERN_DUNGEON_RECIPE §MH).

## R5. Kecleon shop (GBA GenerateKecleonShop)
- R5.1 : proba par étage = kecleonShopChance %, exclu si MH déjà tirée / floor RESCUE.
- R5.2 : salle ≥5×4 ; shop = intérieur (bordure 1 tuile) ; pas de spawn monstre/escalier dans le shop ; marchand au centre.
- PMDO `ShopStep` : place aussi marchand+marchandise+garde sécurité (mécanique thief native). Couverture : 43 zones chez nous — à comparer aux 973/1795 étages Sky (54 %) et chances GBA par étage.

## R6. Layouts spéciaux (GBA l.263-310, Sky `structure`)
11 layouts actifs. Correspondance PMDO :
| ROM | PMDO natif | Statut |
|---|---|---|
| LARGE/MEDIUM/SMALL | InitGridPlanStep dims + GridPathBranch/Grid | NATIVE |
| OUTER_RING | GridPathCircle | NATIVE |
| CROSSROADS | GridPathCross | NATIVE (sémantique proche : salles bords/couloirs centre) |
| LINE | InitGridPlanStep 1 ligne + GridPathGrid | NATIVE (composition) |
| CROSS | GridPathCross variant | NATIVE approchée |
| BEETLE | GridPathBeetle (PMDC, écrit exprès) | NATIVE |
| OUTER_ROOMS | GridPathTwoSides/Circle inversé | PARTIAL (approx) |
| ONE_ROOM_MONSTER_HOUSE | RoomFloorGen 1 salle + MonsterHouse forcée | composition (pas de step dédié) |
| TWO_ROOMS_WITH_MH | idem 2 salles | composition |
- Sky EU réel : 87 % des étages = MEDIUM/MEDIUM_LARGE (grille standard) ; layouts exotiques = 74 étages/1795 (4 %) mais SIGNATURE visuelle forte.

## R7. Imperfections de salles (GBA GenerateRoomImperfections)
60 % des salles flaggées ; grignotage des coins sur (w+h)/4 itérations, direction horaire/anti-horaire alternée. → salles concaves. PMDO : pas d'équivalent post-process ; RoomGenCave/Blocked/Bump donnent des silhouettes voisines à la GÉNÉRATION. Statut : PARTIAL (voir recette : proposer `RoomGenImperfectRect` OU post-proc générique).

## R8. Structures secondaires (GBA GenerateSecondaryStructure)
DIVIDER / ISLAND (douve+île+warp+items+piège) / POOL / CHECKERBOARD / MAZE+DOT, budget par étage. PMDO : PerlinWaterStep/BlobWaterStep (organique) + RoomGenWaterRing (~ISLAND) + RoomGenOasis + PatternWaterStep/PatternTerrainStep (PMDC : motifs !). Statut : PARTIAL — motifs exacts DIVIDER/CHECKERBOARD réalisables par PatternTerrainStep ; ISLAND complet (avec loot+warp) = composition à créer.

## R9. Extra hallways (GBA GenerateExtraHallways ; Sky extra_hallway_density>0 sur 90 % des étages !)
Couloirs supplémentaires partant de salles dans directions aléatoires, créant boucles et impasses. PMDO : ConnectGridBranchStep (boucles ✔) ; impasses natives via dead_ends. Statut : NATIVE-approx (les boucles oui ; les couloirs « qui partent dans le vide » = caractère Sky, partiellement rendu par AngledHall+dead ends).

## R10. Maze rooms (GBA GenerateMazeRoom/GenerateMaze)
Salle transformée en labyrinthe de murs/eau (GenerateMazeLine). PMDO : RoomGenBlocked ≠ maze ; pas de RoomGenMaze natif. Nos zones : 8 *_maze CH1-5 (verrouillées) le simulent par grilles serrées. Statut : MISSING en primitive, WORKAROUND data existant.

## R11. Hidden stairs / Mystery floors (Sky uniquement, 435 étages)
hidden_stairs_spawn_chance % → escalier caché → étage Trésor/Mystère. Chez nous : `Data/Tile/stairs_*.json` n'inclut PAS de hidden stairs ; aucune zone ne les référence. Statut : **MISSING (mécanique canonique Sky)** — à implémenter nativement (EffectTile + SpreadStepZoneStep, cf. recette).

## R12. Sticky items (Sky, 907 étages)
sticky_item_chance % par étage. PMDO natif : `InvItem.Cursed` ✔ (4 zones l'utilisent seulement). Statut : PARTIAL data (mécanique native présente, données non branchées sur les 907 étages ROM).

## R13. RNG
- ROM : LCG dédié, séquence d'appels = pipeline. PMDO : ReRandom (xoshiro), FirstSeed sauvegardé, `CreateActiveZone(ulong seed)` → chaque étage dérive du seed de zone. Rejouabilité PASS (même seed ⇒ même donjon). L'ÉGALITÉ de séquence ROM↔PMDO n'est PAS un objectif (moteurs différents) ; l'objectif est l'égalité DISTRIBUTIONNELLE (statistiques, §36).

## R14. Éligibilité des tuiles de spawn (GBA SpawnEnemies l.4400+)
Salle uniquement (pas couloir), hors shop, hors item/escalier/jonction/unbreakable/joueur. PMDO PlaceRandomMobsStep : équivalent via filtres (TerrainStencil/RoomFilter). NATIVE.
