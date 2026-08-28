# MÉCANIQUES ROM ABSORBÉES DANS ROGUEELEMENTS/PMDO (état final)

Classification §12 (NATIVE/PARTIAL/MISSING/INCOMPATIBLE) après implémentation des lots A–E. Référentiel : ROM_GENERATION_RULES.md (R1–R14).

| Règle ROM | Avant | Après | Voie d'absorption |
|---|---|---|---|
| R2 grilles dims | NATIVE | NATIVE | InitGridPlanStep |
| R3 densités signées | NATIVE (déjà fait) | NATIVE | Amount/DivAmount, preuves dprobe |
| R4.1 MH proba/étage | NATIVE (déjà fait) | NATIVE | SpreadHouseZoneStep SpreadPlanChance plages |
| R4.4 MH taille canonique | PARTIAL (7–13) | **PASS data** (Sky 21–33 cap 45, GBA 14–18 cap 18) | MobThemeNone.Amount recalibré sur distribution mesurée des salles ; primitive `MobThemeRoomScaled` = reste C# |
| R4.5 MH items+pièges 50/50 | PARTIAL | **PASS data** (LOT F' items table ROM SpecialRatio 100 + LOT L ratio pièges : Amount 3-4 si dungeon_id>=28 MH_MIN_TRAP_DUNGEON) ; pose physique de pièges dans MH = MonsterHouseStep C# (seul reste) | data + loi EoS |
| R5 Kecleon | PARTIAL (43 z. GBA) | **PASS** (65 z. Sky +171 plages, % ROM/étage) | ShopStep natif + SpreadStepRangeZoneStep |
| R6 layouts exotiques | PARTIAL | **PASS** (73 étages RING/CROSSROADS/CROSS/BETTLE/LINE) | GridPathCircle/Cross/Beetle + grilles EoS |
| R7 imperfections | PARTIAL | **UNUSED canonique** — contre-épreuve : GBA roomFlags&0x4=0/1764 étages (main_data.inc) ; Sky generate_imperfect_rooms=false 1795/1795 (mappa_s). L'algorithme existe dans les 2 moteurs mais AUCUNE donnée ne l'active : rien à porter | données ROM |
| R8 structures secondaires | PARTIAL | **PASS approx** (LOT M : budget ROM exact -> PatternTerrainStep eau, motifs blob/checker/plus/slash, 134 étages/11 zones, preuve étage-exact) ; ISLAND warp+loot = seule composition restante | PatternTerrainStep natif |
| R9 extra hallways/boucles | NATIVE-approx | NATIVE-approx | ConnectGridBranchStep |
| R10 maze rooms | MISSING | **UNUSED canonique** — contre-épreuve : GBA GenerateMazeRoom inatteignable (guard unk3A16>=0, pret l.3385 « prevents maze rooms from ever being created ») ; Sky mazify jamais exécuté (PATCH_APPLIED=0 && maze_value=0, dungeon-eos l.1348). Mécanique morte dans les 2 ROMs : rien à porter | données ROM |
| R11 hidden stairs | MISSING | **PASS mécanique** (430 étages, tuile vanilla stairs_secret_down + segments trésor + index) | EffectTile natif + DestState + RandomRoomSpawnStep |
| R12 sticky items | NATIVE sous-utilisé | **PASS** (3813 entrées, taux exacts) | InvItem.Cursed dans SpawnRangeList |
| R13 RNG seedé | NATIVE | NATIVE | ReRandom, multi-seed prouvé |
| R14 éligibilité spawns | NATIVE | NATIVE | filtres natifs |
| R1 retry/bailout | PARTIAL | PARTIAL (divergence justifiée : PMDO garantit par construction via DetectIsolated*) | documenté |

INCOMPATIBLE : aucune. Aucun hack par-donjon introduit (tous les changements = data générée par des outils réutilisables + 0 classe C# custom).
