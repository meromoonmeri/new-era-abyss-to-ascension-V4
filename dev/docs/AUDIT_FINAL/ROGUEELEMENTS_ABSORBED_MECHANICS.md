# MÉCANIQUES ROM ABSORBÉES DANS ROGUEELEMENTS/PMDO (état final)

Classification §12 (NATIVE/PARTIAL/MISSING/INCOMPATIBLE) après implémentation des lots A–E. Référentiel : ROM_GENERATION_RULES.md (R1–R14).

| Règle ROM | Avant | Après | Voie d'absorption |
|---|---|---|---|
| R2 grilles dims | NATIVE | NATIVE | InitGridPlanStep |
| R3 densités signées | NATIVE (déjà fait) | NATIVE | Amount/DivAmount, preuves dprobe |
| R4.1 MH proba/étage | NATIVE (déjà fait) | NATIVE | SpreadHouseZoneStep SpreadPlanChance plages |
| R4.4 MH taille canonique | PARTIAL (7–13) | **PASS data** (Sky 21–33 cap 45, GBA 14–18 cap 18) | MobThemeNone.Amount recalibré sur distribution mesurée des salles ; primitive `MobThemeRoomScaled` = reste C# |
| R4.5 MH items+pièges 50/50 | PARTIAL | PARTIAL | données mappa items['monster_house'] prêtes, branchement restant |
| R5 Kecleon | PARTIAL (43 z. GBA) | **PASS** (65 z. Sky +171 plages, % ROM/étage) | ShopStep natif + SpreadStepRangeZoneStep |
| R6 layouts exotiques | PARTIAL | **PASS** (73 étages RING/CROSSROADS/CROSS/BETTLE/LINE) | GridPathCircle/Cross/Beetle + grilles EoS |
| R7 imperfections | PARTIAL | PARTIAL | RoomGenCave/Blocked/Bump approchent ; `RoomGenImperfect` = cycle moteur |
| R8 structures secondaires | PARTIAL | PARTIAL | PerlinWater/BlobWater en place ; PatternTerrainStep dispo (binaire headless le contient) pour DIVIDER/CHECKERBOARD au prochain lot data |
| R9 extra hallways/boucles | NATIVE-approx | NATIVE-approx | ConnectGridBranchStep |
| R10 maze rooms | MISSING | MISSING (workaround data *_maze) | `RoomGenMaze` = cycle moteur |
| R11 hidden stairs | MISSING | **PASS mécanique** (430 étages, tuile vanilla stairs_secret_down + segments trésor + index) | EffectTile natif + DestState + RandomRoomSpawnStep |
| R12 sticky items | NATIVE sous-utilisé | **PASS** (3813 entrées, taux exacts) | InvItem.Cursed dans SpawnRangeList |
| R13 RNG seedé | NATIVE | NATIVE | ReRandom, multi-seed prouvé |
| R14 éligibilité spawns | NATIVE | NATIVE | filtres natifs |
| R1 retry/bailout | PARTIAL | PARTIAL (divergence justifiée : PMDO garantit par construction via DetectIsolated*) | documenté |

INCOMPATIBLE : aucune. Aucun hack par-donjon introduit (tous les changements = data générée par des outils réutilisables + 0 classe C# custom).
