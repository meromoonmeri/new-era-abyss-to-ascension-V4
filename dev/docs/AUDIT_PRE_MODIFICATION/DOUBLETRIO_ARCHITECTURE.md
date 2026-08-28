# DOUBLETRIO/dungeon-pack — AUDIT D'ARCHITECTURE

Source étudiée : clone complet `github.com/DoubleTrio/dungeon-pack` (`/tmp/dungeon-pack`), Mod.xml v0.2.8, namespace `trios_dungeon_pack`, PMDO GameVersion 0.8.11.

## 1. Structure du mod
```
Mod.xml                    → Header (Name/Namespace/UUID/Version/ModType=Mod)
ContentParams.xml          → sons système (Hunger/Pickup/Money…), TitleBG, MonsterBGM
unlock_requirements.txt    → conditions d'accès (Wishmaker = ferry Lapras ; Terrasphere = PNJ Oshawott)
Content/                   → 85 fichiers assets SEULEMENT (BG 1, Chara 3, Icon 21, Item 4,
                             Music 19, Object 23, Particle 3, Portrait 2, Sound 1, Tile 5, UI 2)
Data/
  Zone/       4 zones (wishmaker_cave 1.1 Mo, emberfrost_depths 3.7 Mo,
              adventurers_peak 708 Ko, zzzroad)
  Ground/     7 rsground (base_camp + 6 checkpoints)
  Map/        24 rsmap (TOUS des salles préfabriquées : 17 *_boss, wish rooms,
              forest_prelude/spawn, concept_room)
  AutoTile/   3 (ice_maze_with_lava_*)     Tile/ 22 (pièges/crystaux custom)
  MapStatus/ 11   Status/ 45   Item/ 163   AI/ 9   Skill/ 3   Monster/ 6
Strings/
scripts/tiledtef/          → outillage de conversion Tiled→DTEF (pipeline assets)
Data/Script/trios_dungeon_pack/  47 lua :
  main.lua, common.lua, scriptvars.lua
  event.lua / event_battle.lua / event_mapgen.lua / event_single.lua / event_misc.lua
  beholder.lua (lib d'observation événementielle), helpers.lua, GeneralFunctions.lua
  zone/{wishmaker_cave,emberfrost_depths,adventurers_peak}/init.lua
  ground/, menu/, services/{custom_upgrade,enchant_tools,melody_box_tools,menu_tools}
  wish_table/wish_table_tier1..5.lua
```

## 2. Principe architectural central
**Les donjons DoubleTrio sont à 95 % de la DATA sérialisée** (`Data/Zone/*.json`), pas du code :
- 1 zone = `Zone` JSON avec `Segments[]` (LayeredSegment pour l'ascension, SingularSegment pour les étages uniques type boss).
- Chaque segment porte des `ZoneSteps` (règles trans-étages) + `Floors[]` (1 entrée = 1 étage = liste de `GenSteps` priorisés).
- Le Lua n'intervient QUE pour : (a) `ScriptZoneStep`/`ScriptGenStep` ponctuels (effets spéciaux, PNJ narratifs), (b) menus/services custom, (c) événements runtime via `beholder` (pub/sub).
- **Aucun générateur C# custom.** Tout est composé à partir des primitives RogueElements/RogueEssence/PMDC existantes. Notre projet suit déjà exactement ce modèle.

## 3. Les deux niveaux de règles
1. **ZoneSteps (portée segment)** — probabilisent le contenu PAR PLAGE D'ÉTAGES :
   - `SpreadHouseZoneStep` (2×) : Monster Houses distribuées sur la plage 0–30 avec items thématisés (ex. gummi_wonder Rate 4).
   - `SpreadStepZoneStep` (18×, priorité 6.1) : chacun injecte un `RandomSpawnStep<EffectTile>` = **1 type de piège = 1 zone step** avec sa propre probabilité/plage → distribution des pièges par étage sans dupliquer la donnée dans chaque étage.
   - `SpreadRoomZoneStep` (4×) : salles spéciales rares — `RoomGenEvo` (chambre d'évolution « tous les 3-4 étages », changelog), `RoomGenLoadMap` (rooms préfabriquées wish/crystal chargées depuis .rsmap).
   - `SpreadStepRangeZoneStep` : `ShopStep` (Kecleon) sur plages précises ; `AddConnectedRoomsStep` supplémentaires sur plage -2.2 (variation topologique par plage d'étages !).
   - `ScriptZoneStep` → `ZONE_GEN_SCRIPT.*` Lua (MelodyBox, Enchantments, PNJ story).
2. **GenSteps (portée étage)** — pipeline standard priorisé (voir DOUBLETRIO_GENERATION_ANALYSIS.md).

## 4. Mélange de deux contextes de génération
- **GridFloorGen** (17/27 étages Wishmaker seg0) : grille de cellules → `InitGridPlanStep(10×10, 5×5)` → GridPath → rooms.
- **RoomFloorGen** (10/27) : freeform `ListMapGenContext` (AddConnectedRoomsStep etc.) pour les étages spéciaux (évolution, wish rooms, arènes).
→ Alternance PROCÉDURAL/SEMI-PROCÉDURAL/FIXE **dans le même segment**, sans hack : uniquement le choix du FloorGen par étage.

## 5. Événementiel Lua : beholder.lua
Pub/sub (`beholder.observe/trigger`) pour découpler triggers gameplay et effets (menus, wish crystals, statuses). Les événements de combat custom sont des `Status`/`MapStatus` JSON + handlers `event_battle.lua`. C'est le modèle « effets natifs d'abord, Lua pour l'orchestration ».

## 6. Ce que le mod n'a PAS
- Pas de générateurs par-donjon (`WishmakerGenerator` n'existe pas).
- Pas de modification moteur ; pas de fork PMDO.
- Pas d'ASCII custom : le layout est exclusivement le pipeline RogueElements.
- Contenu visuel minimal (85 assets) : réutilise le vanilla au maximum (règle « natif avant custom »).

## 7. Verdict architecture
| Critère | DoubleTrio | Notre projet |
|---|---|---|
| Donjons = data JSON | ✔ | ✔ (260 zones) |
| Primitives natives only | ✔ | ✔ |
| Lua limité à l'orchestration | ✔ | ✔ (halcyon services) |
| Variation par plage d'étages (SpreadStepRange) | ✔ ++ | partiel (SpreadHouse par plages oui ; AddConnectedRooms par plage NON) |
| Étages spéciaux mêlés au segment (RoomFloorGen intercalés) | ✔ ++ | rare (nos étages sont ~tous GridFloorGen) |
| Prefabs .rsmap comme salles injectées (RoomGenLoadMap) | ✔ ++ | ponctuel (evo/boss) |
| 1 piège = 1 SpreadStepZoneStep probabilisé | ✔ ++ | pièges via TileSpawnZoneStep global (175 zones) |
