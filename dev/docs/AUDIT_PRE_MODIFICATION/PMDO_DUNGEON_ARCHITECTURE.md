# ARCHITECTURE ACTUELLE DES DONJONS DU PROJET (PMDO)

## 1. Vue d'ensemble
- **260 zones** `Data/Zone/*.json`, toutes data-driven (zéro générateur C# custom, zéro fork moteur) — même modèle que DoubleTrio.
- Provenances (CONTENT_REGISTRY.json) : 53 zones GBA Red, 149 zones NDS Sky (mappa_s.bin réalignées EU exactes, poids /10000), 58 zones PMDO/custom (dont CH1–CH5 verrouillées).
- Runtime : RogueEssence unique (un renderer/caméra/collision/save/Lua), directive ROM NATIVE BRIDGE respectée.

## 2. Composition réelle des étages (mesures sur les 260 zones)
- Contexte : quasi-exclusivement `GridFloorGen` (3572 InitGridPlanStep) ; RoomFloorGen rare (boss/arènes via rsmap).
- Topologies : GridPathBranch 2988 (dominant), GridPathGrid 246, GridPathCircle 187, GridPathCross 85, GridPathTwoSides 56, GridPathTiered 8, GridPathBeetle 2, FloorPathBranch 24 ; boucles : ConnectGridBranchStep 3492 ; big rooms : CombineGridRoomStep 1036 (48 zones).
- Salles : AngledHall 5403, Square 4333, Round 3607, Cave 1735, Cross 1531, Blocked 1018, Bump 114, Triangle 16, LoadEvo/LoadBoss/LoadMap 26, Plus 2, WaterRing 1.
- Grilles : 425 configs distinctes (dominante 10×10 cell, 5×4 et 4×3).
- Eau/terrain : PerlinWaterStep 156 zones, BlobWaterStep 8 ; terrain secondaire ROM restauré dans les arènes (36/36 PASS).
- Contenu : Item 252 z., Money 248 z., Mobs 220 z., Pièges 175 z. (EffectTile placés : 178 z.), MH 156 z. (Amount 7–13 dominant), Shop Kecleon 43 z., Vaults 7 z., MonsterHall 3 z., Chest 3 z., Boss spread 1 z.
- Respawn : MobSpawnSettingsStep 3598 étages + RespawnFromEligibleEvent.
- Population ROM : densités mob/item/trap/money importées de FloorProperties GBA (38 zones Red) et mappa_s Sky (139 zones ConnectivityRoom fix) — preuves dprobe.

## 3. Frontière data / code
- Lua (halcyon) : orchestration (progression, cinématiques, services, validateur) ; `ScriptZoneStep` très rare (7 zones).
- Aucune classe `XxxDungeonGenerator` par donjon : conformité §13 déjà acquise.

## 4. Points forts vs DoubleTrio
- Échelle : 260 zones vs 4 ; fidélité ROM prouvée (audits 149/149 EXACT, dprobe, journeys).
- Systèmes déjà en place : MH par plages ROM, densités signées, formations boss ROM-exactes, noms d'étages B{n}F/{n}F par direction ROM.

## 5. Points faibles identifiés (repris dans COMPARISON + RECIPE)
1. **Monotopologie** : GridPathBranch domine (~84 % des étages à path connu) ; Sky réel = 12 structures. Les layouts exotiques ROM (RING/CROSSROADS/BEETLE/CROSS/LINE : 74 étages Sky) ne sont couverts que par 36 zones.
2. **MH taille fixe 7–13** vs ROM ∝ salle (12–18 GBA effectifs) ; pas de MonsterMansion/Hall (3 z.) ni maisons « pièges+items 50/50 » (R4.5 non modélisé partout).
3. **Hidden stairs Sky absentes** (435 étages ROM concernés) — mécanique canonique manquante.
4. **Sticky items** : 4 zones seulement vs 907 étages ROM avec chance>0.
5. **Imperfections/maze/structures secondaires** : approximées par le mix RoomGenCave/Perlin, pas de primitives dédiées.
6. **Vaults/coffres** sous-utilisés (7/3 zones) vs fixed rooms Sky nombreuses.
7. Variation topologique PAR PLAGE D'ÉTAGES (façon DoubleTrio SpreadStepRangeZoneStep -2.2) non exploitée.
