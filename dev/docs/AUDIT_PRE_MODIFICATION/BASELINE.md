# BASELINE — ÉTAT INITIAL AVANT MODERNISATION DU SYSTÈME DE DONJONS

Date : 2026-08-28 · Branche : `arena/01a0357e-new-era-abyss-to-ascension-v4` · HEAD : `15edd49c2f96797d505f115e6288d065a3f00c81` · Dépôt : propre (0 fichier modifié).

## 1. Git

| Élément | Valeur |
|---|---|
| HEAD local | `15edd49c` |
| HEAD remote | `15edd49c` (identique, vérifié par fetch) |
| Base de branche | `0f691fa3` |
| Changements locaux | Aucun (symlinks dev/* exclus via `.git/info/exclude`, non versionnés) |
| Lockfile CH1–CH5 | `dev/tools/ch1_5_lockfile.py check` obligatoire avant chaque commit (31 zones verrouillées) |

## 2. Inventaire du contenu (comptes exacts)

| Catégorie | Compte | Emplacement |
|---|---|---|
| Zones (donjons) | **260** `.json` | `Data/Zone/` |
| Grounds | **604** `.rsground` | `Data/Ground/` |
| RS Maps (cartes fixes) | **109** `.rsmap` | `Data/Map/` |
| AutoTiles | **204** fichiers (203 `.json` + index) | `Data/AutoTile/` |
| Tilesets binaires | **1180** `.tile` | `Content/Tile/` |
| Musiques | **213** | `Content/Music/` |
| Sons | **14** dossiers/fichiers | `Content/Sound/` |
| Particules/VFX | **10** entrées | `Content/Particle/` |
| Scripts Lua | **4524** `.lua` | `Data/Script/` |
| Outils Python dev | **404** `.py` | `dev/tools/` |

## 3. Inventaire des générateurs utilisés (extraction exhaustive des 260 zones)

### RoomGen (formes de salles) — occurrences
```
5403 RoomGenAngledHall     (couloirs coudés)
4333 RoomGenSquare          (rectangles)
3607 RoomGenRound           (salles arrondies)
1735 RoomGenCave            (salles organiques cellular-automata)
1531 RoomGenCross           (2 rectangles croisés = L/T/croix)
1018 RoomGenBlocked         (rectangle avec bloc de mur interne)
 114 RoomGenBump            (rectangle à bosse)
  16 RoomGenTriangle
  10 RoomGenLoadEvo / 9 RoomGenLoadBoss / 7 RoomGenLoadMap (salles préfabriquées)
   2 RoomGenPlus / 1 RoomGenWaterRing
```
Formes NON utilisées par le projet mais disponibles moteur : `RoomGenDiamond` (RogueEssence), `RoomGenOasis`, `RoomGenGuardedCave`, `RoomGenEvo` en spread (PMDC), `RoomGenCoated`.

### Chemins/topologies — occurrences
```
2988 GridPathBranch   (topologie arborescente à % branchement)
 246 GridPathGrid     (grille avec % de connexion)
 187 GridPathCircle   (anneau + salles internes)
  85 GridPathCross    (croix)
  56 GridPathTwoSides
  24 FloorPathBranch  (freeform, non-grille)
   8 GridPathTiered / 2 GridPathBeetle
```
+ `ConnectGridBranchStep` (boucles : reconnexion des impasses à %), `CombineGridRoomStep` (48 zones : fusion de cellules → salles 2x1/2x2 « big rooms »).

### Grilles : 425 configurations distinctes de `InitGridPlanStep`. Top : CellW=10,CellH=10,CellX=5,CellY=4 (983) ; 10/10/4/3 (633) ; 10/10/3/3 (126).

### Steps de contenu (zones qui les utilisent, sur 260)
```
252 ItemSpawnZoneStep     248 MoneySpawnZoneStep    220 PlaceRandomMobsStep
175 TileSpawnZoneStep (pièges)   178 zones placent des EffectTile
156 SpreadHouseZoneStep / 154 MonsterHouseStep      (Monster Houses)
156 PerlinWaterStep / 8 BlobWaterStep               (terrain secondaire)
 79 TeamSpawnZoneStep     43 ShopStep (Kecleon)      12 RandomSpawnStep
  7 SpreadVaultZoneStep    3 MonsterHallStep          3 ChestStep
  1 SpreadBossZoneStep     7 ScriptZoneStep          11 SpreadStepZoneStep
```
Monster House « Amount » dominant : **Min 7 / Max 13** (233 occurrences) ; minorité 2–4 (8 occ).

## 4. Systèmes RogueElements/RogueEssence/PMDC disponibles (sources clonées)
- `/tmp/RogueElements` (audinowho/RogueElements), `/tmp/RogueEssence` (RogueCollab), `/tmp/PMDC` (PMDCollab), `/tmp/pmd-red` (pret), `/tmp/dungeon-pack` (DoubleTrio).
- RNG : `RogueElements.ReRandom` (xoshiro-like 4×u64, `FirstSeed` conservé pour rejouabilité) + `SplitMix64`. `ZoneData.CreateActiveZone(ulong seed, zoneIndex)` → génération 100 % seedée par zone/étage.

## 5. Tests existants (à ne pas casser — non-régression)
- Journeys runtime : `GLOBAL_JOURNEY_PASS` Sky (14 ch/313 étages/908 mobs) + `RED_GLOBAL_JOURNEY_PASS` (13 ch/182 étages) — preuves `dev/docs/canonical/{sky,red}/*.jsonl`.
- `dprobe:<zones>` : peuplement réel par étage (mobs/items/traps + formations).
- Audits maintenus : autotiles 203/203, TexLoc 3 955 120/0 FAIL, arènes 36/36, zones ROM 149/149 EXACT, matrice donjons 260/260, GBA grounds 246/246, musiques 2775 réfs/0 manquante.
- ~90 outils `dev/tools/audit_*.py` + validateur Lua `ground_gameplay_validator`.

## 6. Zones STRICTEMENT IMMUTABLES (CH1–CH5)
31 zones + scripts verrouillés par `ch1_5_lockfile.py` (relic_forest, illuminant_riverbed, crooked_cavern, apricorn_grove, vast_steppe, searing_tunnel, mount_windswept, cloven_ruins, beginner_lesson, petit_tunnel, bosquet_voile, grotte_mystere, vallee_fertile, grotte_repos, bois_ronces, antre_enigme, carriere_cuivre, grotte_echoue, halles_royales, jardin_secret, foret_embuscade, bois_filou, 8 *_maze, water_maze, master_zone, main.lua/common.lua/mission_gen.lua/metano_town). **Toute modernisation doit les exclure.**

## 7. Constat initial (avant audit) — points à instruire
1. Monster Houses : Amount 7–13 très uniforme → comparer aux règles ROM (voir ROM_GENERATION_RULES.md : GBA = jusqu'à 18 effectifs, 70–80 % des tuiles de la salle).
2. Layouts spéciaux ROM (OUTER_RING, CROSSROADS, LINE, CROSS, BEETLE, OUTER_ROOMS, ONE_ROOM_MONSTER_HOUSE) : couverture PMDO à vérifier zone par zone.
3. Imperfections de salles ROM (60 % de chance, grignotage des coins) : équivalent PMDO = RoomGenCave/Blocked/Bump mais pas de post-process générique.
4. Structures secondaires ROM (divider/island/pool/checkerboard/maze+dot) : partiellement couvertes (PerlinWaterStep ≠ mêmes motifs).
5. Dusk Forest : zone RÉELLE data-driven mappa_s.bin (voir §Dusk Forest de COMPARISON), atteignable via progression CH15 — pas DEV_ONLY.
