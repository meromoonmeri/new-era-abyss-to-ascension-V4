# ROGUEELEMENTS / ROGUEESSENCE / PMDC — MATRICE DE CAPACITÉS

Sources : `/tmp/RogueElements` (audinowho), `/tmp/RogueEssence` (RogueCollab), `/tmp/PMDC` (PMDCollab), inventaire exhaustif des fichiers MapGen/LevelGen.

## 1. RogueElements (socle procédural)
### Grille (MapGen/Grid + Paths)
`InitGridPlanStep, GridPathBranch*, GridPathCircle*, GridPathGrid*, GridPathCross, GridPathTwoSides, GridPathSpecific (layouts fixés !), SetGridDefaultsStep, SetGridSpecialRoomStep, SetGridPlanComponentStep, ConnectGridBranchStep (boucles), DrawGridToFloorStep`
(*interfaces IGridPathBranch/Circle/Grid : implémentations dans RogueElements + extensibles*)
### Freeform (MapGen/FloorPlan + Paths)
`InitFloorPlanStep, AddConnectedRoomsStep/Rand, AddDisconnectedRoomsStep/Rand, ConnectBranchStep, FloorPathBranch, SetSpecialRoomStep, FloorStairsStep, ResizeFloorStep, ClampFloorStep, DrawFloorToTileStep`
### Salles (Rooms + Halls)
`RoomGenSquare, RoomGenRound, RoomGenCave (organique), RoomGenCross (L/T/croix), RoomGenBlocked, RoomGenBump, RoomGenSpecific (littéral tuile/tuile), RoomGenAngledHall, brushes: Default/Square/Terrain hall`
### Tuiles/eau (Tiles + Water)
`PerlinWaterStep, BlobWaterStep, DropDiagonalBlockStep, EraseIsolatedStep, EraseIsolatedFromSpawnStep, DetectIsolatedStep, DetectIsolatedStairsStep, SpecificTilesStep, InitTilesStep, StairsStep`
### Spawning
`RandomSpawnStep, RandomRoomSpawnStep, TerminalSpawnStep (impasses), DueSpawnStep (distance entrée), TerrainSpawnStep (dans terrain), SpecificSpawnStep, RoomSpawnStep, PickerSpawner, ContextSpawner, MultiStepSpawner`
### RNG
`ReRandom (xoshiro 4×u64, FirstSeed), SplitMix64, RandRange, RandBinomial, RandBag, SpawnList/SpawnRangeList (pondérés), LoopedRand, PresetMultiRand, PresetPicker, Noise (Perlin)` → **déterminisme par seed natif**.

## 2. RogueEssence (moteur jeu)
`GridFloorGen/RoomFloorGen/StairsFloorGen ; LayeredSegment/SingularSegment/RangeDictSegment ; ZoneSteps: SpreadStepZoneStep, SpreadStepRangeZoneStep, SpreadRoomZoneStep, ScriptZoneStep, MoneySpawnZoneStep, ItemSpawnZoneStep, TileSpawnZoneStep, TeamSpawnZoneStep ; GenSteps: MapDataStep, MapEffectStep, MapTextureStep, MapNameIDStep, MobSpawnStep, ItemSpawnStep, MoneySpawnStep, TileSpawnStep, ScriptGenStep, DetourStep, MappedRoomStep, MapExtraStatusStep, UnbreakableBorderStep, PlaceRandomMobsStep, NearSpawnableSpawnStep ; Rooms: RoomGenDiamond, RoomGenTriangle, RoomGenPlus, RoomGenCoated, RoomGenLoadMap, ImmutableRoom, IndexRoom, ColumnHallBrush ; CreateActiveZone(seed)`.

## 3. PMDC (couche Mystery Dungeon)
`MonsterHouseStep, MonsterMansionStep (toute la map !), MonsterHallStep, MonsterHouseTheme (Mob/Item themes), ShopStep (Kecleon complet avec sécurité), ChestStep (coffres), BossRoom/RoomGenLoadBoss/RoomGenSpecificBoss, AddBossRoomStep, Seals (Boss/Guard/Key/Switch/Terrain — salles verrouillées), Detours (Key/Switch — vaults), RoomGenEvo, RoomGenOasis, RoomGenGuardedCave, RoomGenWaterRing, GridPathBeetle, GridPathPyramid, PatternWaterStep/PatternTerrainStep/PatternPlacerStep (MOTIFS géométriques), FloorStairsDistanceStep, SpacedRoomSpawnStep, SpeciesItem*Spawner, MoneyTrailSpawnStep, SpreadHouseZoneStep, SpreadVaultZoneStep, SpreadBossZoneStep, DetourSpreadZoneStep, FloorNameDropZoneStep, SaveVarsZoneStep, MobSpawnSettingsStep/RespawnFromEligibleEvent, ConnectivityRoom/RoomFilterConnectivity, SetCompassStep`.

## 4. Matrice mécanique ROM → statut RogueElements/PMDO
| Mécanique ROM | Règle | Statut | Voie |
|---|---|---|---|
| Grille cellulaire + ancres | R2 | **NATIVE** | InitGridPlanStep + GridPath* (ancres ≈ halls de grille) |
| 11 layouts | R6 | **NATIVE/PARTIAL** | paths natifs ; OUTER_ROOMS approx ; ONE_ROOM_MH par composition |
| Couloirs en L + extra hallways | R9 | **NATIVE-approx** | AngledHall + ConnectGridBranchStep |
| Boucles | R9 | **NATIVE** | ConnectGridBranchStep |
| Imperfections de salles | R7 | **PARTIAL** | RoomGenCave/Blocked/Bump ≈ ; pas de post-proc « grignotage coins » |
| Maze rooms | R10 | **MISSING** | primitive `RoomGenMaze` à créer (générique) |
| Structures secondaires 5 motifs | R8 | **PARTIAL** | Pattern*Step (PMDC) couvrent DIVIDER/CHECKERBOARD/POOL ; ISLAND complet à composer |
| MH proba/étage | R4.1 | **NATIVE** (déjà posé, 52 zones) | SpreadHouseZoneStep |
| MH taille ∝ salle (70-80 %) | R4.4 | **PARTIAL** | MobTheme.Amount fixe → extension `MobThemeRoomScaled` à créer |
| MH >10 mobs | R4.4 | **NATIVE** (Amount le permet ; 7–13 actuel) | data + extension ci-dessus |
| Monster Mansion / Hall | — | **NATIVE** (bonus PMDC) | MonsterMansionStep/MonsterHallStep |
| Kecleon shop complet | R5 | **NATIVE** | ShopStep (43 zones ; couverture à étendre aux chances ROM) |
| Pièges placés | R3.3 | **NATIVE** (178 zones placent des EffectTile) | TileSpawnZoneStep/RandomSpawnStep |
| Items impasse/distance/terrain | DoubleTrio | **NATIVE** | Terminal/Due/TerrainSpawnStep |
| Hidden stairs (Sky) | R11 | **MISSING data+tile** | EffectTile nouvelle + SpreadStepZoneStep (natif) |
| Sticky items (Sky) | R12 | **NATIVE sous-utilisé** | InvItem.Cursed + data des 907 étages |
| Vaults/coffres/serrures | Sky fixed rooms | **NATIVE** | Detours+Seals+ChestStep (7 zones seulement) |
| Retry + bailout MH | R1 | **PARTIAL** | validation isolée native ; bailout à implémenter (ou accepter divergence justifiée) |
| Densités signées | R3 | **NATIVE** (déjà appliqué) | Amount/DivAmount |
| Météo par étage | Sky | **NATIVE** | MapEffectStep/MapStatus (déjà utilisé) |
| Seed reproductible | R13 | **NATIVE** | ReRandom/CreateActiveZone |
| Salles préfab dans procédural | — | **NATIVE** | RoomGenLoadMap/SetGridSpecialRoomStep |
| INCOMPATIBLE | — | **AUCUNE** | rien d'incompatible identifié : toutes les mécaniques ROM se projettent sur le pipeline GenStep |

## 5. Conclusion
RogueElements/PMDC couvrent nativement ~85 % des règles ROM. Manques réels : `RoomGenMaze` (R10), post-proc imperfections (R7), hidden stairs data+tile (R11), MobTheme proportionnel à la salle (R4.4), composition ISLAND (R8), bailout MH (R1.4). Tous réalisables comme PRIMITIVES GÉNÉRIQUES (aucun hack par donjon requis).
