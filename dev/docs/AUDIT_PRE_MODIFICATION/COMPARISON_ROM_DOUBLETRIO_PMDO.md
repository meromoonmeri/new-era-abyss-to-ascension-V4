# MATRICE COMPARATIVE — ROM / DOUBLETRIO / PROJET / ROGUEELEMENTS / PMDO

Colonnes : ROM (GBA+Sky, réf. ROM_GENERATION_RULES.md Rn) · DT (DoubleTrio) · PROJET (nos 260 zones) · RE/PMDO (capacité moteur) · SOLUTION.

| Mécanique | ROM | DT | PROJET | RE/PMDO | SOLUTION |
|---|---|---|---|---|---|
| Rooms rectangulaires | ✔ | ✔ | ✔ (4333) | RoomGenSquare | garder |
| Rooms rondes/organiques | — (imperfections) | ✔ Round/Cave/Oasis | ✔ (3607/1735) | natif | garder |
| Rooms L/T/croix | via merge/imperfections | ✔ Cross | ✔ (1531) | RoomGenCross | garder |
| Rooms concaves (imperfections R7) | ✔ 60 % | ~Cave | ~Cave/Blocked | PARTIAL | primitive `RoomGenImperfect` générique (post-proc coins) |
| Maze rooms (R10) | ✔ | ✘ | 8 zones data-simulées | MISSING | primitive `RoomGenMaze` générique |
| Salles fusionnées/big rooms | ✔ (merge) | ✔ | ✔ CombineGridRoomStep (48 z.) | natif | étendre aux zones Sky où mappa l'indique |
| Diamond/Triangle/Plus | ✘ | ✔ Diamond | 18 occurrences | natif | levier variété gratuit |
| Topologie branch | ✔ | ✔ | ✔ (2988) | GridPathBranch | garder |
| Boucles | ✔ extra hallways | ✔ 75 % | ✔ (3492) | ConnectGridBranchStep | garder |
| RING/CROSSROADS (R6) | ✔ 37 ét. Sky | ✔ Circle/Cross | 36 zones | GridPathCircle/Cross | mapper `structure` mappa → path exact par étage |
| BEETLE (R6) | ✔ 18 ét. | ✘ | 2 | GridPathBeetle | idem mapping |
| LINE/CROSS/OUTER_ROOMS | ✔ 19+ ét. | ✘ | partiel | compositions | idem mapping + GridPathSpecific si besoin |
| ONE/TWO-ROOM MH floors | ✔ (+bailout R1.4) | ✘ | ✘ | composition | template d'étage dédié (data) |
| Retry+validation (R1) | ✔ 10×10 | n/a (moteur) | n/a | DetectIsolated* préventif | UNCHANGED : PMDO garantit par construction ; documenter divergence |
| RNG seed reproductible (R13) | ✔ LCG | ✔ | ✔ | ReRandom | PASS |
| Densités signées (R3) | ✔ | ✔ | ✔ (fix prouvé dprobe) | Amount/DivAmount | PASS |
| Spawn éligibilité tuiles (R14) | ✔ | ✔ | ✔ | filtres | PASS |
| MH proba/étage (R4.1) | ✔ | ✔ plage | ✔ (52 z. plages ROM) | SpreadHouseZoneStep | PASS |
| MH taille ∝ salle (R4.4 : 70-80 %, cap 18) | ✔ | ✘ (7-13) | ✘ (7-13) | PARTIAL | `MobThemeRoomScaled` (nouvelle primitive générique) OU relever Amount à 10-18 (approx data) |
| MH items+pièges 50/50 (R4.5) | ✔ | items only | items only | ItemTheme existe | enrichir HouseStep data avec pièges |
| Monster Mansion/Hall | ✘ ROM (PMDO bonus) | ✘ | 3 z. | natif | levier variété optionnel |
| Kecleon (R5) | ✔ 973 ét. Sky | ✔ plages | 43 z. | ShopStep | brancher kecleon_shop_chance mappa par étage |
| Shop « ne jamais » systématique | ✔ % | ✔ | ✔ | natif | PASS après extension couverture |
| Pièges placés (R3.3) | ✔ | ✔ 18 spread steps | ✔ 175/178 z. | natif | PASS ; vérifier stats (100 gén.) |
| Hidden stairs / Mystery floors (R11) | ✔ Sky 435 ét. | ✘ | ✘ | EffectTile framework | **nouvelle tile + SpreadStepZoneStep + segment trésor** |
| Sticky items (R12) | ✔ Sky 907 ét. | ✘ | 4 z. | InvItem.Cursed | brancher sticky_item_chance data |
| Buried items (murs) | ✔ | ✔ (walls) | ✔ (fix pop.) | natif | PASS |
| Items impasses/distance | ~ | ✔ Terminal/Due | ✔ (3561/3556) | natif | PASS |
| Vaults à clé/interrupteur | ✔ Sky fixed rooms | ✘ | 7 z. | Detours+Seals | étendre où fixed_floor_id ROM l'indique |
| Coffres | ✔ Sky | ✘ | 3 z. | ChestStep | idem |
| Structures secondaires (R8) | ✔ 5 motifs | Perlin only | Perlin/Blob | Pattern*Step PMDC | motifs DIVIDER/CHECKERBOARD par PatternTerrainStep ; composer ISLAND |
| Météo par étage | ✔ Sky | ✔ MapStatus | ✔ | natif | vérifier couverture data étage/étage |
| Darkness | ✔ Sky | ✔ | ✔ TileSight/CharSight | natif | PASS |
| Boss fixes | ✔ | ✔ 17 rsmap | ✔ 36 arènes ROM-exactes | natif | PASS |
| Prefabs dans procédural | ✔ fixed rooms | ✔ LoadMap | ✔ (26) | natif | étendre |
| Respawn continu | ✔ | ✔ MaxFoes | ✔ 3598 | natif | PASS |
| Variation topologique par plage | ~ (données par étage) | ✔ SpreadStepRange -2.2 | ✘ | natif | adopter le pattern DT |
| PNJ narratifs en donjon | ✔ (Sky) | ✔ SpawnStoryNpc | partiel | ScriptZoneStep | adopter au besoin |

## Dusk Forest — investigation demandée (§34)
- `Data/Zone/dusk_forest.json` : zone **RÉELLE Sky** (NDS d16 « Dusk Forest »), Released=true, 8 étages LayeredSegment, commentaire de provenance : « data-driven mappa_s.bin — Tables realignées ROM EU exact (poids /10000) ».
- Atteignable via **runtime normal** : progression CH15 (`skyscenes/progression.lua` l.27 : `{main=15, zones={'dusk_forest','deep_dusk_forest','treeshroud_forest'}}`) + validateur (`sceneground d16p11a`).
- Apparaît dans le Dev Mode simplement parce que TOUTES les zones y sont listées (éditeur standard RogueEssence) — **ce n'est ni un test, ni un prototype, ni DEV_ONLY**. Aucun donjon joueur ne dépend du Dev Mode : les journeys (`GLOBAL_JOURNEY_PASS` 313 étages) passent par `EnterSegment` runtime normal.
- Verdict : **INTÉGRÉ, runtime normal, preuve jsonl** (dev/docs/canonical/sky/hybrid_test_journey_proof.jsonl).

## Synthèse des écarts à traiter (par priorité canonique)
1. R11 Hidden stairs (MISSING, 435 ét. ROM) — mécanique canonique Sky.
2. R4.4 MH ∝ salle (PARTIAL, cap ROM 18 > notre max 13).
3. R12 Sticky items (data non branchée, 907 ét.).
4. R6 mapping structure mappa→path exact (74 ét. exotiques).
5. R5 couverture Kecleon (43 z. vs 973 ét.).
6. R7/R8/R10 primitives formes (Imperfect/Maze/Island).
7. Vaults/coffres (fixed rooms Sky).
