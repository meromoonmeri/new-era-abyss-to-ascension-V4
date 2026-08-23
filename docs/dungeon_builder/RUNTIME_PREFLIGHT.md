# Pré-vol runtime des zones générées

_Généré le 2026-08-22T23:35:26+00:00 — 51 zones vérifiées : **51 sans référence manquante**, 0 avec anomalie._

Ce contrôle ne remplace pas l'exécution par le moteur : il vérifie que **toutes les références** d'une zone existent (tilesets, Grounds, salles fixes, musiques, objets, index), ce qui est la cause principale d'échec au chargement.

| Zone | Tilesets | Musiques | Contrôles | Anomalies |
|---|---|---|---|---|
| `buried_relic` | 3 | — | 44 | 0 |
| `darknight_relic` | 3 | — | 24 | 0 |
| `desert_region` | 3 | — | 19 | 0 |
| `fantasy_strait` | 3 | — | 30 | 0 |
| `far_off_sea` | 3 | — | 30 | 0 |
| `fiery_field` | 3 | — | 39 | 0 |
| `frosty_forest` | 3 | Frosty Forest.ogg | 34 | 0 |
| `frosty_grotto` | 3 | — | 20 | 0 |
| `gloomy_forest` | 3 | Sinister Woods.ogg | 24 | 0 |
| `grand_sea` | 3 | — | 30 | 0 |
| `great_canyon` | 3 | — | 32 | 0 |
| `howling_forest` | 3 | — | 32 | 0 |
| `joyous_tower` | 3 | — | 46 | 0 |
| `lapis_cave` | 3 | Lapis Cave.ogg | 34 | 0 |
| `lightning_field` | 3 | — | 39 | 0 |
| `magma_cavern` | 3 | — | 27 | 0 |
| `magma_cavern_pit` | 3 | — | 20 | 0 |
| `marvelous_sea` | 3 | — | 30 | 0 |
| `meteor_cave` | 3 | — | 17 | 0 |
| `mt_blaze` | 3 | Mt. Blaze.ogg | 30 | 0 |
| `mt_blaze_peak` | 3 | — | 19 | 0 |
| `mt_faraway` | 3 | — | 25 | 0 |
| `mt_freeze` | 3 | Mt. Freeze.ogg | 38 | 0 |
| `mt_freeze_peak` | 3 | — | 29 | 0 |
| `mt_steel` | 3 | — | 21 | 0 |
| `mt_thunder` | 3 | — | 33 | 0 |
| `mt_thunder_peak` | 3 | — | 29 | 0 |
| `murky_cave` | 3 | — | 19 | 0 |
| `northern_range` | 3 | — | 32 | 0 |
| `northwind_field` | 3 | — | 39 | 0 |
| `oddity_cave` | 3 | — | 39 | 0 |
| `pitfall_valley` | 3 | — | 33 | 0 |
| `purity_forest` | 3 | — | 47 | 0 |
| `remains_island` | 3 | — | 39 | 0 |
| `rock_path` | 3 | — | 23 | 0 |
| `silent_chasm` | 3 | — | 31 | 0 |
| `silver_trench` | 3 | — | 33 | 0 |
| `sky_tower` | 3 | — | 28 | 0 |
| `sky_tower_summit` | 3 | — | 24 | 0 |
| `snow_path` | 3 | — | 23 | 0 |
| `solar_cave` | 3 | — | 28 | 0 |
| `southern_cavern` | 3 | — | 26 | 0 |
| `stormy_sea` | 3 | — | 49 | 0 |
| `thunderwave_cave` | 3 | — | 19 | 0 |
| `tiny_woods` | 3 | — | 18 | 0 |
| `unown_relic` | 3 | — | 24 | 0 |
| `uproar_forest` | 3 | — | 22 | 0 |
| `waterfall_pond` | 3 | — | 17 | 0 |
| `western_cave` | 3 | — | 26 | 0 |
| `wish_cave` | 3 | Wish Cave.ogg | 46 | 0 |
| `wyvern_hill` | 3 | — | 34 | 0 |

## Exécution de MapGenTest : tentative et blocage exact (2026-08-23)

| Prérequis | État dans ce sandbox |
|---|---|
| Sources de MapGenTest | ✅ présentes (`PMDCollab/PMDC`, submodules inclus) |
| Données de base PMDO | ✅ récupérées (`audinowho/DumpAsset`) |
| Binaire PMDO | ✅ exécutable |
| **SDK .NET pour compiler MapGenTest** | ❌ `dot.net`, `builds.dotnet.microsoft.com`, `api.nuget.org`, `ci.dot.net` : tous injoignables (code 000). PyPI ne fournit qu'un *runtime* .NET Core 3.1 (`dotnetcore2`), pas de compilateur, et MapGenTest cible .NET 8. |
| Pilote graphique (pour le jeu complet) | ❌ aucun `libGL`/`libEGL`/`libvulkan` sur la machine |

MapGenTest est un projet C# : sans SDK, il ne peut pas être compilé, donc
**l'exécution réelle des `GenSteps` reste impossible ici**. Le script
`tools/runtime/run_mapgen_check.sh` fait exactement ce travail sur une machine
disposant du SDK (`dotnet build` + `-quest` + stress test), sans écran.

## Ce qui a été fait à la place : validation contre les sources du moteur

Puisque les sources C# sont désormais disponibles, `dungeon_builder verify-source`
indexe **2 144 classes** de RogueElements / RogueEssence / PMDC et vérifie nos
zones membre par membre :

| Contrôle | Résultat sur les 51 zones du Builder |
|---|---|
| objets JSON inspectés | **65 894** |
| `$type` inconnus du moteur | **0** |
| membres émis absents de la classe (ou de ses bases) | **0** |
| namespace/assembly incohérents avec la source | **0** |

C'est précisément la famille d'erreurs que MapGenTest signalerait au
chargement (`$type` introuvable, champ inexistant, mauvais assembly).

À noter : le même contrôle appliqué aux **anciennes zones hors périmètre**
(`bois_filou`, `chasm_cave`, …, produites par d'autres agents) remonte
**38 membres inconnus** (`RoomGenSquare.Size`, `RoomGenSquare.Resizable`,
`PickerSpawner.Spawns`, `DueSpawnStep.MaxToSpawn`, …). Ces zones ne sont pas
dans notre périmètre et n'ont pas été touchées, mais le signal est consigné ici.


## Exécution moteur réalisée (2026-08-23) — sans SDK .NET

Le blocage « pas de SDK .NET » a été contourné : au lieu de compiler MapGenTest,
on fait tourner le **binaire PMDO officiel** en headless et on rejoue sa boucle
depuis un service Lua du mod.

Pile utilisée, entièrement reconstructible avec les seuls hôtes joignables
(`github.com`, `codeload.github.com`, `registry.npmjs.org`) :

| Élément | Origine |
|---|---|
| binaire PMDO 0.8.12 self-contained | `meromoonmeri/RUNTIMEPMDO` (`pmdc-linux-x64.zip`) |
| ANGLE + SwiftShader (`libEGL.so`, `libGLESv2.so`, `libvk_swiftshader.so`) | paquet npm `@sparticuz/chromium` (`bin/swiftshader.tar.br`) |
| SDL 2.30.3 corrigé | `libsdl-org/SDL`, correctif : le pilote `offscreen` exige `eglQueryDevicesEXT` (EXT_device_enumeration) qu'ANGLE n'expose pas ; ajout d'un repli `eglGetDisplay(EGL_DEFAULT_DISPLAY)` sous `PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY=1` |
| assets du jeu de base | `audinowho/DumpAsset` (`Base Data Strings Controls CONFIG Content`) |
| boucle de génération | `Data/Script/halcyon/services/mapgen_validator/init.lua`, copie fidèle de `MapGenTest.Example.StressTestAll` |

Renderer effectivement obtenu :
`ANGLE (Google, Vulkan 1.3.0 (SwiftShader Device (Subzero)), SwiftShader driver-5.0.0)`.

Script : `tools/runtime/run_engine_mapgen.sh <dossier-de-travail> [itérations]`.

### Résultat

| Passe | Générations | Échecs |
|---|---|---|
| 1 itération (51 donjons × 1 429 étages) | 1 429 | 0 |
| 3 itérations (stress) | 4 287 | **0** |

Rapport : `docs/dungeon_builder/runtime/MAPGEN_RUNTIME_REPORT.md`,
données brutes : `docs/dungeon_builder/runtime/mapgen_runtime_stress.jsonl`
(une ligne par étage : dimensions, nombre de salles, durée, seed).

### Erreur réelle trouvée et corrigée par cette exécution

`silent_chasm` et `unown_relic` pointaient vers des AutoTiles inexistants
(`chasm_cave_*`, `sealed_ruin_pit_*`) : le moteur levait
`KeyNotFoundException` dans `MapTextureStep.ToString()`. Le contrôle statique ne
pouvait pas le voir : il ne connaissait que les AutoTiles du mod et ceux déjà
cités par une donnée du dépôt. Corrigé en `silent_chasm_*` et
`deep_sealed_ruin_*`, et la liste officielle des 473 AutoTiles du jeu de base est
désormais embarquée (`tools/dungeon_builder/data/base_autotiles.txt`) pour que la
vérification statique attrape ce cas à l'avenir.


### Deuxième passe : traversabilité et Grounds de scène (2026-08-23)

Le validateur moteur a été étendu à deux contrôles supplémentaires, faits sur les
objets que le moteur vient de construire :

1. **Traversabilité** — pour chaque étage généré : lecture case par case de
   `Map:TileBlocked`, parcours en largeur 8 directions depuis
   `Map.EntryPoints[0]`, position des escaliers relevée sur les `EffectTile`.
   Résultat sur 4 287 étages : **0 poche praticable non atteinte**,
   **4 281 étages avec tous les escaliers atteignables**, les 6 restants étant
   les deux salles fixes de boss sans escalier (étages terminaux).
2. **Grounds de scène** — les **54 liaisons zone → Ground** du câblage sont
   chargées par `DataManager.GetGround`, avec vérification du mode d'entrée
   réellement appelé par le script de zone et de la présence du Ground dans les
   `GroundMaps` de la zone. Résultat : **0 problème**.

#### Deuxième erreur réelle trouvée et corrigée

Neuf Grounds de scène (`champ_braises`, `abime_tempetes`, `antre_occident`,
`bois_des_plaintes`, `cretes_boreales`, `fosse_argentee`, `sommet_aurore`,
`vallon_perdu`, `d07p02`) ne portent **aucun marqueur** : leur scène téléporte
elle-même le joueur. Or les scripts de zone générés appelaient
`GAME:EnterGroundMap(nom, 'Main_Entrance_Marker')`, qui passe par
`GroundMap.GetEntryPointIdx` et lève `KeyNotFoundException` quand le marqueur
n'existe pas — plantage garanti à la fin de ces neuf donjons.

Le générateur lit désormais les marqueurs réellement présents dans le
`.rsground` (`wiring.ground_entry_marker`) : marqueur nommé quand il existe,
entrée par index (`GetEntryPoint(int)`, qui ne lève pas) sinon.
