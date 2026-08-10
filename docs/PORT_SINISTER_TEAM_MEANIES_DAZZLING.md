# Port narratif — Team Meanies (Rescue Team) → Team Dazzling (New Era) autour de Sinister Woods

## Source
- ROM : `POKEMON-ROM/...Blue...nds` 32 MiB, `dungeon.sbin` (256 entrées, `b10canm` 1088 o SIR0), `ground.sbin`, `message_e.bin` (5184 strings, Sinister Woods ID 10)
- `pmd-red` : `src/dungeon_cutscene_meanies.c`, `src/dungeon_boss_dialogue.c` (7+5 dialogues), `data/dungeon/SinisterWoods/floor_id.json` (13 étages F1-F13), `pokemon_found.json` (ex. F1 oddish/sudowoodo/swinub)

## Timeline Rescue Team — Team Meanies autour de Sinister Woods (reconstituée depuis `src/dungeon_cutscene_meanies.c` + `ground`)

### Grounds
- **Entrée** : `a01p02` (Sinister Woods Entrance) — 69×72, `Main_Entrance_Marker` 256,256 (ancien) / 208,192 (New Era 60×47)
- **Clairière** : `D04P02` (Sinister Woods Clearing) — Ground fixe 60×47 (New Era) / 69×72 (Blue), `Main_Entrance 256,256` → `224,208` recadré
- **Donjon** : 13 étages F1-F13, `mappa` b10, `cel` b10, `fon` b10

### Timeline
1. **Entrée — Arrivée** (`a01p02` Init) : joueur + partenaire à 208,192 / 240,192, caméra 224,176. Team Meanies *absente*.
2. **Entrée — Barrage** (`DazzlingEntranceBlockade` en New Era, original `TeamMeaniesEntranceBlockade`) : **Condition** `!DazzlingEntranceSeen` + `Chapter 6` (Rescue Team : flag `SinisterApproachSeen`). **Positions** : Gengar 224,136 / Ekans 192,160 / Medicham 256,160 (New Era : Adagio 224,136 / Aria 192,160 / Sonata 256,160 — transposition directe). **Dialogue** 7 boîtes (MEANIES_1..7) → Dazzling 7 boîtes (GF6E_A13..A19). **Déplacement** : Meanies avancent vers l'entrée du donjon (224,96 / 192,104 / 256,104) puis `RemoveTempChar`. **Flag** `DazzlingEntranceSeen=true`, `DazzlingPresenceStage=1`. **Transition** : fade out, caméra 0,0, `CutsceneMode false`.
3. **Donjon F1-F10** : exploration, pas de Meanies.
4. **Donjon F11-F13** : **Team Meanies boss** (triple) à F13 ? Dans Blue, le boss est **Team Meanies** (Gengar/Ekans/Medicham) avec `TeamMeaniesPreFightDialogue` (7) + `ReFightDialogue` (5), positions `GetEntityFromMonsterBehavior(BEHAVIOR_GENGAR/EKANS/MEDICHAM)` avec `unk15F` et `sub_8085B4C` (synchronisation des 3).
5. **Clairière D04P02** : après F13, `EnterGroundMap('sinister_woods_clearing')`. **Condition** `!FinishedGloomyForestIntro` (Rescue Team : `!SinisterWoodsClearingSeen`). **Positions** : Gengar 240,144 / Ekans 280,176 / Medicham 208,176 (New Era : Adagio 240,144 / Aria 280,176 / Sonata 208,176 — transposition directe, vérifiée 60×47 walkable). **Dialogue** 9 boîtes (MEANIES_4..12) → Dazzling 9 (GF6E_A04..A12) + 3 New Era (peur de Chenipent, concours arrêté). **Déplacement** : Meanies restent sur place (pas de sortie), `FinishedGloomyForestIntro=true`, `DazzlingPresenceStage=4`, puis `ContinueDungeon('gloomy_forest',4)` (boss).
6. **Boss** : `gloomy_forest_boss` (Zarude en New Era, mais **devrait être Team Meanies** en port fidèle). Actuellement New Era a Zarude, à corriger si on veut un port 1:1.

## Mapping New Era (conservé)

| Rescue Team | New Era | Ground New Era | Position Rescue Team → New Era | Condition | Dialogue | Transition |
|-------------|---------|----------------|--------------------------------|-----------|----------|------------|
| Team Meanies (Gengar 224,136) | Adagio (Tsareena 224,136) | gloomy_forest_entrance (60×47) | 224,136 `Down` | `!DazzlingEntranceSeen` | GF6E_A13-19 (7) | MoveTo 224,96 + Remove |
| Ekans 192,160 | Aria 192,160 | même | 192,160 `DownRight` | même | même | 192,104 |
| Medicham 256,160 | Sonata 256,160 | même | 256,160 `DownLeft` | même | même | 256,104 |
| Gengar 240,144 (clairière) | Adagio 240,144 | sinister_woods_clearing 60×47 | 240,144 `Down` | `!FinishedGloomyForestIntro` | 9+3 | reste |
| Ekans 280,176 | Aria 280,176 | même | 280,176 `Left` | même | même | reste |
| Medicham 208,176 | Sonata 208,176 | même | 208,176 `Right` | même | même | reste |
| Boss Team Meanies (triple, F13) | **Actuellement Zarude** (à corriger en Dazzling si port 1:1) | gloomy_forest_boss 19×19 | `GetEntityFromMonsterBehavior` → `MakeCharactersFromList` | `FindBoss` | 7+5 | `SetCutsceneFlag` |

**Vérifications** : toutes les positions sont `Tags 0` (walkable) sur les Grounds New Era (60×47 et 57×48), `Markers`/`Spawners` existent, `ViewCenter`/`EdgeView` conservés, `Direction` identique, `Order` préservé.

## Intégration PMDO/Lua

- **Ground actors** : `CharacterEssentials.MakeCharactersFromList` (New Era) ← `GetEntityFromMonsterBehavior` (Rescue Team), `GROUND:TeleportTo`/`MoveToPosition`/`CharTurnToCharAnimated`/`RemoveTempChar` conservés.
- **SSB/events** : Rescue Team `SSB TeamMeaniesPreFightDialogue` → New Era `DazzlingEntranceBlockade` / `DazzlingClearingCutscene` (même `BattleScriptEvent` si boss).
- **Flags** : Rescue Team `CUTSCENE_FLAG_SINISTER_WOODS_COMPLETE` → New Era `SV.Chapter6.FinishedGloomyForestIntro` / `DazzlingEntranceSeen` / `DazzlingPresenceStage`.
- **Conditions** : avant/après vérifiées (pas de double apparition, pas de blocage, `pcall` + `CutsceneMode(false)` + `FadeIn` sur erreur).
- **Transitions** : `Ground A → déplacement → dialogue → Ground B` conservé (Entrée → Donjon → Clairère → Boss).

## Correctifs appliqués à c7cef93

- `event_mapgen.lua` : `venipede` → `caterpie`, `Segment 0/ID17` → `Segment 1/ID 4` (F20) + déplacement du `ScriptGenStep` vers `Segments[1]`.
- `gloomy_forest.json` / `index.idx` : `Maps[0] 18→15`, `Maps[1] 3→5`, `CountedFloors 26→25` (IsRelevant).
- `sinister_woods_clearing.rsground` : 60×47 conservé (pas de refonte), `Main_Entrance 224,208` walkable, `Markers` corrects.

## Preuves restantes

- **Entrée du donjon** : `gloomy_forest_entrance` `Main_Entrance_Marker 208,192` walkable (vérifié `Tags 0`).
- **Clairière** : `sinister_woods_clearing` 60×47 accessible (transition `seg3 Cleared → sinister`), `DazzlingClearingCutscene` 9+3 dialogues.
- **Rayquaza** : hors périmètre Sinister Woods (boss est Zarude/Meanies), `sinister_woods_clearing` → `ContinueDungeon 4` (Zarude) fonctionnel, pas de `try/catch` masqué.

