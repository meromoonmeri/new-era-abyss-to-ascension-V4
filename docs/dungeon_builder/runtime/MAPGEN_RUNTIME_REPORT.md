# Validation runtime de la génération — moteur RogueEssence

Généré par `tools/runtime/run_engine_mapgen.sh` : chaque ligne provient d'un appel
réel à `ZoneSegmentBase.GetMap(ZoneGenContext)` dans le moteur (même chemin que
MapGenTest), binaire PMDO officiel en headless ANGLE/SwiftShader.

- zones testées : **51**
- itérations : **3**
- générations tentées : **4287**
- réussies : **4287**
- échecs : **0**

## Échecs

Aucun. Tous les étages demandés ont été construits par le moteur.

## Par donjon

| Donjon | Étages générés | Salles min/moy/max | Largeur moy | Hauteur moy | ms moy |
|---|---|---|---|---|---|
| `buried_relic` | 297 | 1/9.2/33 | 62 | 40 | 21.3 |
| `darknight_relic` | 45 | 4/8.9/18 | 58 | 41 | 21.2 |
| `desert_region` | 60 | 3/9.9/26 | 61 | 39 | 15.6 |
| `fantasy_strait` | 90 | 4/9.6/26 | 51 | 40 | 10.9 |
| `far_off_sea` | 225 | 2/8.9/24 | 57 | 39 | 12.0 |
| `fiery_field` | 90 | 2/8.2/18 | 57 | 37 | 11.5 |
| `frosty_forest` | 27 | 6/10.1/26 | 53 | 37 | 7.7 |
| `frosty_grotto` | 15 | 7/13.7/23 | 64 | 35 | 8.9 |
| `gloomy_forest` | 42 | 5/11.2/22 | 61 | 41 | 11.8 |
| `grand_sea` | 90 | 3/9.3/17 | 58 | 39 | 11.7 |
| `great_canyon` | 36 | 5/9.1/17 | 55 | 36 | 7.8 |
| `howling_forest` | 45 | 7/14.9/32 | 59 | 38 | 12.0 |
| `joyous_tower` | 297 | 1/8.9/25 | 62 | 40 | 10.7 |
| `lapis_cave` | 42 | 5/13.0/31 | 65 | 40 | 19.4 |
| `lightning_field` | 90 | 2/8.8/23 | 54 | 37 | 7.5 |
| `magma_cavern` | 69 | 2/11.2/23 | 60 | 37 | 10.5 |
| `magma_cavern_pit` | 9 | 9/14.9/22 | 67 | 45 | 11.2 |
| `marvelous_sea` | 60 | 3/9.3/23 | 54 | 41 | 10.4 |
| `meteor_cave` | 60 | 4/12.6/29 | 60 | 39 | 12.7 |
| `mt_blaze` | 36 | 3/9.8/20 | 58 | 35 | 7.9 |
| `mt_blaze_peak` | 9 | 8/11.7/20 | 74 | 41 | 10.1 |
| `mt_faraway` | 120 | 2/8.2/27 | 57 | 36 | 9.7 |
| `mt_freeze` | 45 | 4/10.3/23 | 57 | 44 | 13.2 |
| `mt_freeze_peak` | 15 | 1/3.5/9 | 55 | 31 | 4.8 |
| `mt_steel` | 27 | 5/9.9/27 | 54 | 39 | 8.6 |
| `mt_thunder` | 30 | 5/8.2/14 | 57 | 39 | 7.0 |
| `mt_thunder_peak` | 9 | 3/8.1/13 | 63 | 35 | 10.8 |
| `murky_cave` | 57 | 4/11.5/27 | 61 | 39 | 11.8 |
| `northern_range` | 75 | 5/9.2/22 | 59 | 38 | 10.7 |
| `northwind_field` | 90 | 1/7.5/14 | 55 | 33 | 8.6 |
| `oddity_cave` | 45 | 6/13.6/30 | 62 | 41 | 9.3 |
| `pitfall_valley` | 75 | 5/9.7/26 | 61 | 39 | 11.1 |
| `purity_forest` | 297 | 1/10.5/31 | 60 | 37 | 10.3 |
| `remains_island` | 60 | 4/8.8/24 | 61 | 40 | 13.1 |
| `rock_path` | 12 | 7/13.5/23 | 68 | 36 | 11.9 |
| `silent_chasm` | 27 | 4/15.9/31 | 60 | 43 | 9.6 |
| `silver_trench` | 297 | 1/7.8/25 | 56 | 35 | 8.7 |
| `sky_tower` | 75 | 4/9.6/17 | 61 | 40 | 11.7 |
| `sky_tower_summit` | 27 | 3/10.6/26 | 61 | 45 | 17.2 |
| `snow_path` | 12 | 2/4.9/8 | 43 | 40 | 5.8 |
| `solar_cave` | 60 | 5/11.3/26 | 60 | 37 | 7.6 |
| `southern_cavern` | 150 | 2/10.9/29 | 57 | 39 | 11.1 |
| `stormy_sea` | 120 | 2/8.5/25 | 58 | 36 | 9.5 |
| `thunderwave_cave` | 15 | 6/14.4/23 | 58 | 42 | 7.7 |
| `tiny_woods` | 9 | 10/19.6/31 | 69 | 34 | 9.8 |
| `unown_relic` | 33 | 5/7.4/11 | 63 | 38 | 7.5 |
| `uproar_forest` | 30 | 8/13.3/27 | 60 | 35 | 8.4 |
| `waterfall_pond` | 57 | 4/8.4/14 | 55 | 35 | 10.9 |
| `western_cave` | 297 | 1/11.0/33 | 61 | 39 | 11.1 |
| `wish_cave` | 297 | 3/11.4/30 | 58 | 38 | 9.9 |
| `wyvern_hill` | 90 | 4/9.3/25 | 59 | 39 | 10.2 |

Ligne terminale du moteur : `{"event": "end", "attempted": 4287, "generated": 4287, "failures": 0}`

