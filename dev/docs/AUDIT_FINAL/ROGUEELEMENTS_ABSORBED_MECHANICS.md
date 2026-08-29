# MÉCANIQUES ROM ABSORBÉES DANS ROGUEELEMENTS/PMDO (état final)

Classification §12 (NATIVE/PARTIAL/MISSING/INCOMPATIBLE) après implémentation des lots A–E. Référentiel : ROM_GENERATION_RULES.md (R1–R14).

| Règle ROM | Avant | Après | Voie d'absorption |
|---|---|---|---|
| R2 grilles dims | NATIVE | NATIVE | InitGridPlanStep |
| R3 densités signées | NATIVE (déjà fait) | NATIVE | Amount/DivAmount, preuves dprobe |
| R4.1 MH proba/étage | NATIVE (déjà fait) | NATIVE | SpreadHouseZoneStep SpreadPlanChance plages |
| R4.4 MH taille canonique | PARTIAL (7–13) | **PASS EXACT C#** — MonsterHouseRomStep (NewEra.Engine) : mobs=RandRange(70-80% de LA salle), cap ROM 12/30×3/2 ; preuve wish_cave mh=18 (cap GBA exact), NDS 22-27, déclenchement réel 33-35 mobs | primitive C# in-process |
| R4.5 MH items+pièges 50/50 | PARTIAL | **PASS EXACT C#** — MonsterHouseRomStep POSE les pièges (50/50, cap 7, gate dungeon_id>=28, fallback trap table de l'étage comme la ROM) ; preuve traps avg 15.0 vs 11.8 | primitive C# |
| R5 Kecleon | PARTIAL (43 z. GBA) | **PASS** (65 z. Sky +171 plages, % ROM/étage) | ShopStep natif + SpreadStepRangeZoneStep |
| R6 layouts exotiques | PARTIAL | **PASS** (73 étages RING/CROSSROADS/CROSS/BETTLE/LINE) | GridPathCircle/Cross/Beetle + grilles EoS |
| R7 imperfections | PARTIAL | **UNUSED canonique** — contre-épreuve : GBA roomFlags&0x4=0/1764 étages (main_data.inc) ; Sky generate_imperfect_rooms=false 1795/1795 (mappa_s). L'algorithme existe dans les 2 moteurs mais AUCUNE donnée ne l'active : rien à porter | données ROM |
| R8 structures secondaires | PARTIAL | **PASS complet** — LOT M (PatternTerrainStep 4 motifs) + IslandRoomStep C# (douve+île+items+warp, 134 étages/11 zones, preuve île ASCII wish_cave fl2) | PatternTerrainStep + primitive C# |
| R9 extra hallways/boucles | NATIVE-approx | NATIVE-approx | ConnectGridBranchStep |
| R10 maze rooms | MISSING | **UNUSED canonique** — contre-épreuve : GBA GenerateMazeRoom inatteignable (guard unk3A16>=0, pret l.3385 « prevents maze rooms from ever being created ») ; Sky mazify jamais exécuté (PATCH_APPLIED=0 && maze_value=0, dungeon-eos l.1348). Mécanique morte dans les 2 ROMs : rien à porter | données ROM |
| R11 hidden stairs | MISSING | **PASS mécanique** (430 étages, tuile vanilla stairs_secret_down + segments trésor + index) | EffectTile natif + DestState + RandomRoomSpawnStep |
| R12 sticky items | NATIVE sous-utilisé | **PASS** (3813 entrées, taux exacts) | InvItem.Cursed dans SpawnRangeList |
| R13 RNG seedé | NATIVE | NATIVE | ReRandom, multi-seed prouvé |
| R14 éligibilité spawns | NATIVE | NATIVE | filtres natifs |
| R1 retry/bailout | PARTIAL | PARTIAL (divergence justifiée : PMDO garantit par construction via DetectIsolated*) | documenté |

INCOMPATIBLE : aucune. Aucun hack par-donjon introduit (tous les changements = data générée par des outils réutilisables + 0 classe C# custom).
