# ROM_BRIDGE_ARCHITECTURE_AUDIT.md — Phase 0 (audit obligatoire avant tout code)

Sources auditées : RogueEssence (RogueCollab/RogueEssence), PMDC
(PMDCollab/PMDC), RogueElements (audinowho/RogueElements) — clones HEAD —
plus le bundle headless réellement exécuté par ce dépôt
(`.runtime-cache/pmdo-headless-bundle`, PMDO 0.8.12) et le pipeline d'outils
du dépôt (`dev/tools/`). Chaque emplacement ci-dessous a été vérifié par
lecture directe du fichier cité.

## 1. Où sont chargés les GROUNDS
- `RogueEssence/Data/DataManager.cs` : `GROUND_EXT = ".rsground"` (l.129),
  `GetGround(string name)` (l.1138) → `LoadEntryData<GroundMap>(name,
  GROUND_FOLDER, ".rsground")` (l.1145).
- Modèle : `RogueEssence/Ground/Maps/GroundMap.cs` (`class GroundMap :
  IWorld, IEntryData`, l.19) — Layers/obstacles (GroundWall Tags)/Entities
  (Markers `GetEntryPoint`, l.918)/TexSize (l.43-44 : `TileSize = TexSize *
  GraphicsManager.TEX_SIZE`).
- Entrée en jeu : `RogueEssence/Scene/GameManager.cs` (l.774
  `GroundScene.Instance.EnterGround(entryPoint)`).

## 2. Où sont chargés les DUNGEON MAPS
- `DataManager.cs` : `MAP_EXT = ".rsmap"` (l.128), `GetMap(string)` (l.1116)
  → `LoadNamespacedData<Map>(name, MAP_FOLDER, ".rsmap")`.
- Étages fixes : `RogueEssence.LevelGen.LoadGen` (Floors des zones) charge le
  `.rsmap` par ID ; étages procéduraux : GridFloorGen + GenSteps.

## 3. Où sont chargés les TILESETS (feuilles de tuiles)
- `RogueEssence/Content/GraphicsManager.cs` : `TILE_PATTERN =
  CONTENT_PATH + "Tile/{0}.tile"` (l.107) ; index binaire
  `TileGuide LoadTileIndices(string tileDir)` (l.1124-1142).
- Format `.tile` : header `<II>` (méta, count) + table `<QQ>`
  (clé = x | y<<32, offset) + blobs PNG préfixés `<Q>` taille — reproduit
  1:1 par nos outils (`render_ground_png.py::read_tile_sheet`,
  `audit_autotile_structural.py::sheet_keys`).

## 4. Où sont chargés les RAWASSETS
- « RawAsset » = dépôt source d'assets PMDCollab (github.com/PMDCollab/
  RawAsset) consommé HORS runtime par l'éditeur/importeurs ; au runtime seul
  le résultat compilé (.tile/.dir/AutoTile .json) est chargé. Référencé côté
  moteur dans `RogueEssence/PathMod.cs`, `GraphicsManager.cs`, et côté dépôt
  par `dev/tools/inventory_pmdcollab_rawasset_buildings.py` /
  `extract_pmd_shop_structures.py`.

## 5-6. Où sont chargés les DTEF / TileDtef
- `RogueEssence/Dev/DtefImportHelper.cs` : importeur du Dungeon Tile
  Exchange Format — `tileset_0/1/2.png` + frames
  `tileset_N_frameF_D.V.png` + `tileset.dtef.xml` ; mapping des 47 variantes
  via `FieldDtefMapping` (l.32-42 : 0x89,0x9B,0x13… — table des masques de
  voisinage). C'est un outil d'IMPORT (éditeur), pas un chargeur runtime :
  il produit des `AutoTileData` + sheets `.tile`. Nos tilesets ROM
  convergent vers la MÊME sortie (AutoTileData 47 variantes, vérifié
  203/203 par `audit_autotile_structural.py` contre la référence vanilla).

## 7. Où sont résolus les AUTOTILES
- `DataManager.cs` : `GetAutoTile(string index)` (l.1210) →
  `LoadNamespacedData<AutoTileData>(index, "AutoTile")` + LRU
  `autoTileCache` (l.167, taille AUTOTILE_CACHE_SIZE, l.356).
- Modèle : `RogueEssence/Data/AutoTileData.cs` (`class AutoTileData :
  IEntryData`, l.7) — `Tiles` = dictionnaire Tilex00..TilexFF de listes de
  variantes `{Frames:[{Sheet,TexLoc}],FrameLength}`.

## 8. Où sont définies les COLLISIONS
- Ground : `GroundMap.obstacles` (grille `GroundWall` 8px, `Tags`,
  `GetObstacle/SetObstacle` l.619-623, test l.726) —
  `RogueEssence/Ground/Maps/GroundWall.cs`.
- Dungeon : `Tile.Data.ID` (terrain floor/wall/unbreakable/water/pit/lava,
  `TerrainData`) + `EffectTile` ; walkability via TerrainData.BlockType.

## 9. Où fonctionne ROGUEELEMENTS
- Génération : `RogueElements/MapGen/*` (InitGridPlanStep, GridPathBranch,
  DrawGridToFloorStep, FloorStairsStep, DueSpawnStep, RandomRoomSpawnStep,
  ContextSpawner — `IContextSpawner.Amount`, MoneyDivSpawner.DivAmount).
- Côté PMDO : `RogueEssence.LevelGen.*` (MapTextureStep → GroundTileset/
  BlockTileset/WaterTileset = IDs AutoTile ; MobSpawnStep ;
  PlaceRandomMobsStep) et `PMDC.LevelGen.*` (ConnectivityRoom Connection
  flags Main=1/BlockVault=32, RoomFilterConnectivity, MobSpawnSettingsStep,
  SpreadHouseZoneStep).

## 10. Où fonctionne la CAMÉRA
- Ground : `RogueEssence/Ground/BaseGroundScene.cs` `UpdateCam(ref Loc)`
  (l.120) — EdgeView==Clamp : clamp bords + centrage si carte < viewport
  (GraphicsManager.ScreenWidth/Height ÷ scale) ; ViewRect = focusedLoc −
  écran/2.
- Dungeon : `RogueEssence/Dungeon/BaseDungeonScene.cs` `UpdateCam(Loc)`
  (l.130), même sémantique.
- Notre outil d'audit `--camera-view` (render_rsmap_autotile.py) reproduit
  exactement cette transform (viewport 320×240, clamp, entiers).

## 11. Où fonctionne le RENDERER
- `BaseGroundScene.cs`/`BaseDungeonScene.cs` : DrawLoc par tuile
  (`loc*TileSize − ViewRect.Start`), layers triés, BlankBG hors carte
  (EdgeView=Blank), autotiles résolus par NeighborCode ; SpriteBatch
  PointClamp (nearest-neighbor, aucun filtrage).

## 12-13. Où sont chargés SPRITES / ANIMATIONS
- `GraphicsManager.GetChara(CharID)` (l.886) → CharSheet depuis
  `Content/Chara` ; objets décor : `ObjAnimData.AnimIndex` →
  `Content/Object/<name>.dir` (format `<Q>taille+PNG+<IIII>` reproduit par
  sky_build_subscreen_bgs.py::make_dir_file) ; particules `Content/Particle`.
- Animations de tuiles : frames multiples dans AutoTileData/cellules rsground
  (`FrameLength`) ; scheduler GBA CANM côté mod :
  `Data/Script/halcyon/RedDirectGroundAnimation.lua` (map-owned, ticks GBA
  16777216/280896 convertis en WaitFrames 60Hz).

## 14-15. Où sont chargés SKILLS / POKÉMON
- `RogueEssence/Data/SkillData.cs` (`IDescribedData`),
  `RogueEssence/Data/MonsterData.cs` (`IEntryData`) — chargés par
  DataManager (Data/Skill, Data/Monster), exécution combat 100% PMDC
  (BattleData/BattleFX).

## 16. Où fonctionne LUA
- `RogueEssence/Lua/LuaEngine.cs` — services (`BaseService`), callbacks
  carte (`OnGroundMapEnter`, `DungeonFloorEnter`…), scripts de ground
  `Data/Script/<ns>/ground/<AssetName>/init.lua` (AssetName du .rsground =
  clé de résolution, vérifié sur nos 27 grounds direct GBA).

## 17. Où fonctionne SAVE/LOAD
- `RogueEssence/Data/GameProgress.cs` (abstract, l.50) +
  `DataManager.SaveMainGameState/LoadProgress` (l.1581+) — replays/quicksave.
  Un seul système ; nos preuves RESUME_RUNTIME_PASS/RED_RESUME_RUNTIME_PASS
  passent par lui.

## Pipeline ROM existant du dépôt (à COMPLÉTER, pas remplacer — §63)
- Lecture/validation ROM : restore_pmdred_eu_validation_runtime.sh (SHA-256
  EU Red 0f9d125d…), sky-rom (SHA 1fa39d35…), audit_pmdred_eu_rom.py
  (BPL/BPC/BPA/BMA normalisés + manifest 246 entrées),
  red_extract_eu_only_station.py (scripts stations EU).
- Décodeurs (IR) : convert_red_all.py (parse_bpl/parse_bpc/parse_bpa/
  decode_bma = RomTilesetIR+RomGroundIR GBA),
  render_pmdred_eu_rom_reference.py (autorité indépendante, plans de cycles
  d'animation), skytemple-files/ndspy (NDS : BMA/BPC/BPL/BPA, fixed.bin,
  mappa_s.bin, monster.md, SSA/SSB, WAN).
- Adapters PMDO : convert_red_all.py --apply (rsground+sheets .tile),
  sky_port_dungeon_tileset.py (dungeon.bin → AutoTileData 47 variantes +
  DPLA animations), sky_build_zone_from_tables.py (mappa → Zones
  RogueElements natives), red_build_gba_fixed_arenas.py /
  sky_build_boss_arenas (fixed rooms → .rsmap), sky_compile_scenes.py
  (SSB → Lua), sky_music_mid_map.py (BGM → Content/Music).
- Tests anti-Sinister-Woods : audit_autotile_structural.py (203/203, 103 263
  frames vs index .tile), audit_texloc_references.py (713 cartes, 3 955 120
  références, 0 FAIL), audit_fixed_arenas_vs_rom.py (36/36 cellule/cellule),
  audit_red_grounds_vs_gba.py (246/246 dims/anims/palette),
  build_sinister_woods_procedural_fixture.py.

## Conclusion Phase 0
Le point d'entrée de TOUT contenu runtime est `DataManager.LoadEntryData/
LoadNamespacedData` + `GraphicsManager` (fichiers .rsground/.rsmap/.json/
.tile/.dir dans l'arborescence du mod). Le bridge ROM du dépôt injecte ses
données converties À CE NIVEAU (mêmes formats, mêmes chargeurs, zéro
modification moteur) : les deux chemins (vanilla et ROM) convergent avant
génération et rendu, comme exigé par §17. Aucun second runtime n'existe.
