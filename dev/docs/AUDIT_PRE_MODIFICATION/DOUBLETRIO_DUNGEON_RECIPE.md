# DOUBLETRIO — RECETTE TECHNIQUE DE CRÉATION D'UN DONJON

Reconstruite depuis `wishmaker_cave.json` (27 étages + segment final), `emberfrost_depths.json`, `adventurers_peak.json`, les 47 Lua et le changelog. Ce n'est pas une impression : chaque point est vérifié dans les JSON.

## PIPELINE EXACT
```
ASSET (Content/Tile dtef via scripts/tiledtef, Music, Particle)
  ↓
DATA (Data/Tile pièges custom, Data/Status effets, Data/Item 163 objets, Data/MapStatus météo/lumière)
  ↓
DEFINITION (Data/Zone/<dungeon>.json : Zone → Segments → ZoneSteps + Floors)
  ↓
TEMPLATE (Data/Map/*.rsmap : 24 prefabs — boss rooms, wish rooms, spawn rooms
          → injectés par RoomGenLoadMap/RoomGenLoadBoss/SetGridSpecialRoomStep)
  ↓
FLOOR (GridFloorGen OU RoomFloorGen ; GenSteps priorisés -6 → +7)
  ↓
DUNGEON (LayeredSegment = plage d'étages ; SingularSegment = étage unique)
  ↓
GENERATION (RogueElements, seedée ReRandom)
  ↓
PMDO RUNTIME (Lua beholder pour événements, services pour menus)
```

## RECETTE PAR ÉTAGE (GridFloorGen type, priorités relevées)
| Priorité | Step | Rôle |
|---|---|---|
| -6 | `MapDataStep` | musique, TimeLimit 1500, TileSight/CharSight, ClampCamera |
| -6 | `MapEffectStep` | effets d'étage (MapStatus, événements OnActions...) |
| -5 | `InitGridPlanStep` 10×10 cell, 5×5 grid | grille |
| -4 | `GridPathCross` / `GridPathBranch` / `GridPathCircle` | topologie (variété par étage !) |
| -4 | `ConnectGridBranchStep` ConnectPercent=75 | **boucles** (reconnexion des impasses) |
| -4 | `SetGridSpecialRoomStep` + PresetPicker | injection salle spéciale (prefab) |
| -3 | `DrawGridToFloorStep` | grille → plan |
| -1 | `DrawFloorToTileStep` Padding 1 | plan → tuiles |
| 0.1 | `UnbreakableBorderStep` | bordure |
| 1.2 | `MobSpawnSettingsStep` + RespawnFromEligibleEvent | respawn continu (MaxFoes) |
| 2 | `FloorStairsStep` | escaliers |
| 3 | `PerlinWaterStep` 35 %, Bowl | eau/lave organique |
| 3.1 | `DropDiagonalBlockStep` / 3.2 `EraseIsolatedStep` | nettoyage terrain |
| 4 | `MapTextureStep` (crystal_cave_1_floor/wall/secondary) | textures |
| 5 | `SpacedRoomSpawnStep<EffectTile>` + `RandomRoomSpawnStep<EffectTile>` | tuiles spéciales espacées |
| 6 | `TerminalSpawnStep<MoneySpawn>` | argent dans les impasses (récompense d'exploration) |
| 6.1 | `DueSpawnStep<InvItem>` (loin de l'entrée) + `TerrainSpawnStep<MapItem>` (items DANS l'eau) + `NearSpawnableSpawnStep` (item garanti près du spawn — « Plain Apricorn à côté du joueur F1 ») | placements d'items INTENTIONNELS |
| 6.2 | `PlaceRandomMobsStep` (+RoomFilterConnectivity Main) | mobs |
| 7 | `DetectIsolatedStairsStep` | validation connectivité |

## LES 9 TECHNIQUES-CLÉS À RETENIR (généralisables)
1. **Variété topologique par étage** : le path (Cross/Branch/Circle) change d'un étage à l'autre dans le même segment ; les RoomGen alternent (Diamond 10, Round 10, Cave 27, Oasis 10, Blocked 7, Square 5, LoadMap 5, Evo 2 sur Wishmaker seul).
2. **Boucles garanties** : `ConnectGridBranchStep` 75 % — pas de dungeon-arbre pur.
3. **RoomFloorGen intercalé** : étages 5–14 de Wishmaker en freeform (`AddConnectedRoomsStep`) → rythme exploration/événement.
4. **Récompense spatiale** : `TerminalSpawnStep` (impasses = argent), `DueSpawnStep` (plus c'est loin de l'entrée, plus il y a d'items), `TerrainSpawnStep` (items visibles dans l'eau/lave = risque/récompense).
5. **1 piège = 1 SpreadStepZoneStep** : 18 zone steps distincts, chacun avec sa probabilité et sa plage → courbe de danger par étage réglée finement.
6. **Prefabs ciblés** : 24 rsmap pour TOUS les moments forts (17 boss, wish rooms) injectés par RoomGenLoadMap — le reste 100 % procédural.
7. **Monster Houses par plage** : `SpreadHouseZoneStep` Amount 7–13, items thématiques dédiés, plage 0–30.
8. **Respawn calibré** : `MobSpawnSettingsStep` + `RespawnFromEligibleEvent(MaxFoes)` par étage.
9. **Événements rares par plage** : `SpreadRoomZoneStep` (RoomGenEvo « tous les 3-4 étages »), `SpreadStepRangeZoneStep` (`ShopStep` Kecleon sur plages, `AddConnectedRoomsStep` en plage -2.2 = topologie qui se densifie en profondeur).

## CLASSIFICATION DES ÉLÉMENTS (par donjon audité)
Voir DOUBLETRIO_GENERATION_ANALYSIS.md pour le détail par étage.
- FIXE : boss rooms (rsmap), wish rooms, grounds checkpoints.
- PROCÉDURAL : layout, eau Perlin, mobs, items, argent, pièges, escaliers.
- SEMI-PROCÉDURAL : salles spéciales injectées dans layout procédural (SetGridSpecialRoomStep/PresetPicker), étages RoomFloorGen avec prefab + salles aléatoires.
- SCRIPTÉ : wish crystals (menus Lua), PNJ story (`SpawnStoryNpc`), effets shimmering (ScriptZoneStep).
- PARAMÉTRÉ : densités, plages, probabilités (tout le JSON).
