# Validation runtime de la génération — moteur RogueEssence

Généré par `tools/runtime/run_engine_mapgen.sh` : chaque ligne provient d'un appel
réel à `ZoneSegmentBase.GetMap(ZoneGenContext)` dans le moteur (même chemin que
MapGenTest), binaire PMDO officiel en headless ANGLE/SwiftShader.

- zones testées : **51**
- itérations : **1**
- générations tentées : **1429**
- réussies : **1429**
- échecs : **0**

## Traversabilité (données du moteur, `Map:TileBlocked`)

- étages analysés : **1429**
- étages dont tous les escaliers sont atteignables depuis le point d'entrée : **1427**
- étages avec une poche de terrain praticable non atteinte : **0**

| Zone | Segment | Étage | Escaliers | Atteignables | Praticables | Atteints |
|---|---|---|---|---|---|---|
| `buried_relic` | 2 | 32 | 0 | 0 | 345 | 345 |
| `meteor_cave` | 1 | 9 | 0 | 0 | 345 | 345 |

Un étage sans escalier est un **étage terminal** (salle fixe de boss chargée en `fixed_floors`) : le donjon s'y achève, il n'y a rien à rejoindre.

## Grounds de scène chargés par le moteur

- liaisons zone → Ground vérifiées : **54**
- problèmes : **0**

Chaque Ground est réellement désérialisé par `DataManager.GetGround`, son mode d'entrée est celui qu'appelle le script de zone (marqueur nommé ou index), et sa présence dans les `GroundMaps` de la zone est vérifiée : sans elle, `MoveToGround` refuse la transition.

## Échecs

Aucun. Tous les étages demandés ont été construits par le moteur.

## Par donjon

| Donjon | Étages générés | Salles min/moy/max | Largeur moy | Hauteur moy | ms moy |
|---|---|---|---|---|---|
| `buried_relic` | 99 | 2/9.2/30 | 62 | 40 | 15.8 |
| `darknight_relic` | 15 | 5/9.4/19 | 58 | 41 | 7.9 |
| `desert_region` | 20 | 3/10.3/26 | 61 | 39 | 6.8 |
| `fantasy_strait` | 30 | 5/9.4/20 | 51 | 40 | 5.5 |
| `far_off_sea` | 75 | 2/8.9/25 | 57 | 39 | 5.7 |
| `fiery_field` | 30 | 2/8.3/19 | 57 | 37 | 6.3 |
| `frosty_forest` | 9 | 6/10.9/26 | 53 | 37 | 7.2 |
| `frosty_grotto` | 5 | 7/14.4/23 | 64 | 35 | 5.4 |
| `gloomy_forest` | 14 | 7/11.1/20 | 61 | 41 | 8.9 |
| `grand_sea` | 30 | 5/9.9/19 | 58 | 39 | 6.4 |
| `great_canyon` | 12 | 4/9.3/20 | 55 | 36 | 5.0 |
| `howling_forest` | 15 | 5/14.1/29 | 59 | 38 | 8.7 |
| `joyous_tower` | 99 | 2/9.2/23 | 62 | 40 | 8.7 |
| `lapis_cave` | 14 | 5/13.3/28 | 65 | 40 | 5.9 |
| `lightning_field` | 30 | 3/8.8/16 | 54 | 37 | 6.0 |
| `magma_cavern` | 23 | 3/11.2/24 | 60 | 37 | 5.1 |
| `magma_cavern_pit` | 3 | 12/16.7/23 | 67 | 45 | 4.7 |
| `marvelous_sea` | 20 | 5/9.6/22 | 54 | 41 | 7.0 |
| `meteor_cave` | 20 | 3/12.6/23 | 60 | 39 | 7.0 |
| `mt_blaze` | 12 | 5/10.2/18 | 58 | 35 | 5.9 |
| `mt_blaze_peak` | 3 | 8/9.7/12 | 74 | 41 | 7.0 |
| `mt_faraway` | 40 | 3/8.1/18 | 57 | 36 | 4.4 |
| `mt_freeze` | 15 | 4/11.0/28 | 57 | 44 | 8.5 |
| `mt_freeze_peak` | 5 | 1/3.0/8 | 55 | 31 | 7.8 |
| `mt_steel` | 9 | 5/10.0/24 | 54 | 39 | 7.2 |
| `mt_thunder` | 10 | 5/8.3/14 | 57 | 39 | 7.7 |
| `mt_thunder_peak` | 3 | 4/7.3/10 | 63 | 35 | 5.3 |
| `murky_cave` | 19 | 4/11.4/20 | 61 | 39 | 6.8 |
| `northern_range` | 25 | 5/8.9/15 | 59 | 38 | 4.5 |
| `northwind_field` | 30 | 2/7.8/15 | 55 | 33 | 5.4 |
| `oddity_cave` | 15 | 8/14.6/30 | 62 | 41 | 7.0 |
| `pitfall_valley` | 25 | 5/9.6/18 | 61 | 39 | 9.1 |
| `purity_forest` | 99 | 1/10.3/31 | 60 | 37 | 6.9 |
| `remains_island` | 20 | 4/8.6/18 | 61 | 40 | 8.4 |
| `rock_path` | 4 | 7/11.8/17 | 68 | 36 | 3.0 |
| `silent_chasm` | 9 | 5/16.0/32 | 60 | 43 | 6.3 |
| `silver_trench` | 99 | 2/7.8/23 | 56 | 35 | 5.1 |
| `sky_tower` | 25 | 5/9.4/16 | 61 | 40 | 5.5 |
| `sky_tower_summit` | 9 | 3/8.9/15 | 61 | 45 | 12.9 |
| `snow_path` | 4 | 2/4.5/6 | 43 | 40 | 2.0 |
| `solar_cave` | 20 | 5/11.6/22 | 60 | 37 | 6.1 |
| `southern_cavern` | 50 | 3/10.8/27 | 57 | 39 | 8.6 |
| `stormy_sea` | 40 | 2/8.1/22 | 58 | 36 | 7.8 |
| `thunderwave_cave` | 5 | 8/13.8/19 | 58 | 42 | 12.0 |
| `tiny_woods` | 3 | 11/19.7/27 | 69 | 34 | 13.3 |
| `unown_relic` | 11 | 5/7.5/11 | 63 | 38 | 7.9 |
| `uproar_forest` | 10 | 9/12.7/22 | 60 | 35 | 7.1 |
| `waterfall_pond` | 19 | 4/8.4/15 | 55 | 35 | 7.9 |
| `western_cave` | 99 | 2/11.2/27 | 61 | 39 | 7.8 |
| `wish_cave` | 99 | 3/11.8/29 | 58 | 38 | 7.0 |
| `wyvern_hill` | 30 | 4/9.5/25 | 59 | 39 | 7.4 |

Ligne terminale du moteur : `{"event": "end", "attempted": 1429, "generated": 1429, "failures": 0, "non_traversable": 2}`

