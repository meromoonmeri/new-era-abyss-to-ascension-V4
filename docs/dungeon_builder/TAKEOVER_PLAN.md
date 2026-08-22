# Plan de reprise des donjons (takeover)

_Généré le 2026-08-22T22:32:35+00:00 — 50 donjons analysés._

`HARVEST` = donnée canonique réutilisée telle quelle · `TRANSFER` = contenu narratif/scène qui suit le donjon dans le nouveau pipeline · `REPLACE` = ancienne implémentation supprimée après reconstruction · `PROTECT` = hors périmètre, intouchable.

| Donjon | HARVEST | TRANSFER | REPLACE | PROTECT | Cinématiques | Notes |
|---|---|---|---|---|---|---|
| `buried_relic` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `darknight_relic` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `desert_region` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `fantasy_strait` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `far_off_sea` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `fiery_field` | 1 | 3 | 0 | 0 | 1 | — |
| `frosty_forest` | 3 | 9 | 1 | 0 | 3 | — |
| `frosty_grotto` | 3 | 7 | 0 | 0 | 3 | — |
| `grand_sea` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `great_canyon` | 1 | 4 | 0 | 0 | 2 | — |
| `howling_forest` | 1 | 2 | 0 | 0 | 1 | — |
| `joyous_tower` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `lapis_cave` | 2 | 7 | 1 | 0 | 2 | — |
| `lightning_field` | 0 | 4 | 0 | 0 | 1 | — |
| `magma_cavern` | 3 | 11 | 0 | 0 | 3 | — |
| `magma_cavern_pit` | 3 | 9 | 0 | 0 | 3 | — |
| `marvelous_sea` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `meteor_cave` | 0 | 1 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `mt_blaze` | 3 | 9 | 1 | 0 | 3 | — |
| `mt_blaze_peak` | 3 | 7 | 0 | 0 | 3 | — |
| `mt_faraway` | 1 | 3 | 0 | 0 | 1 | — |
| `mt_freeze` | 3 | 8 | 1 | 0 | 3 | — |
| `mt_freeze_peak` | 3 | 7 | 0 | 0 | 3 | — |
| `mt_steel` | 0 | 5 | 0 | 0 | 2 | — |
| `mt_thunder` | 0 | 8 | 0 | 0 | 3 | — |
| `mt_thunder_peak` | 0 | 7 | 0 | 0 | 3 | — |
| `murky_cave` | 0 | 6 | 0 | 0 | 2 | — |
| `northern_range` | 1 | 2 | 0 | 0 | 1 | — |
| `oddity_cave` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `pitfall_valley` | 1 | 2 | 0 | 0 | 1 | — |
| `purity_forest` | 0 | 1 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `remains_island` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `rock_path` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `silent_chasm` | 0 | 5 | 0 | 0 | 2 | — |
| `silver_trench` | 1 | 3 | 0 | 0 | 1 | — |
| `gloomy_forest` | 2 | 7 | 0 | 0 | 2 | — |
| `sky_tower` | 3 | 7 | 0 | 0 | 3 | — |
| `sky_tower_summit` | 3 | 6 | 0 | 0 | 3 | — |
| `snow_path` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `solar_cave` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `southern_cavern` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `stormy_sea` | 1 | 3 | 0 | 0 | 1 | — |
| `thunderwave_cave` | 0 | 5 | 0 | 0 | 2 | — |
| `tiny_woods` | 0 | 5 | 0 | 0 | 2 | — |
| `unown_relic` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `uproar_forest` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |
| `waterfall_pond` | 0 | 1 | 0 | 0 | 0 | — |
| `western_cave` | 1 | 3 | 0 | 0 | 1 | — |
| `wish_cave` | 2 | 4 | 1 | 0 | 1 | — |
| `wyvern_hill` | 0 | 0 | 0 | 0 | 0 | no narrative content found for this dungeon |

## `fiery_field` — Fiery Field

- **HARVEST** `Data/Ground/champ_braises.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/champ_braises` *(archivé)* — archived cutscene of scene 'champ_braises' to restore
- **TRANSFER** `RESERVE/scripts_zone/fiery_field` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d16p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D16: audio, camera, dialogue and battle trigger to replay on the same Ground

## `frosty_forest` — Frosty Forest

- **REPLACE** `Data/Zone/frosty_forest.json` — legacy zone of a dungeon now owned by the Builder: regenerated from DungeonDefs/canonical/frosty_forest.json
- **HARVEST** `Data/Ground/d10p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d10p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/foret_givree_oree.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d10p02` — cutscene of scene 'd10p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d10p03` — cutscene of scene 'd10p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/foret_givree_oree` — cutscene of scene 'foret_givree_oree' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/foret_givree_oree` *(archivé)* — archived cutscene of scene 'foret_givree_oree' to restore
- **TRANSFER** `Data/Script/halcyon/zone/frosty_forest` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/scripts_zone/frosty_forest` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d10p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d10p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d10p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/creer_midpoints.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/full_audit_pmdred_imports.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/gen_addon_sky_network.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `frosty_grotto` — Frosty Grotto

- **HARVEST** `Data/Ground/d10p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d10p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/foret_givree_oree.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d10p02` — cutscene of scene 'd10p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d10p03` — cutscene of scene 'd10p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/foret_givree_oree` — cutscene of scene 'foret_givree_oree' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/foret_givree_oree` *(archivé)* — archived cutscene of scene 'foret_givree_oree' to restore
- **TRANSFER** `RESERVE/red_cinematics/d10p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d10p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d10p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D10: audio, camera, dialogue and battle trigger to replay on the same Ground

## `great_canyon` — Great Canyon

- **HARVEST** `Data/Ground/d07p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/grounds/grand_canyon_porte.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/grand_canyon_porte` *(archivé)* — archived cutscene of scene 'grand_canyon_porte' to restore
- **TRANSFER** `RESERVE/red_cinematics/d07p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D07: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d07p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D07: audio, camera, dialogue and battle trigger to replay on the same Ground

## `howling_forest` — Howling Forest

- **HARVEST** `Data/Ground/bois_des_plaintes.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/bois_des_plaintes` *(archivé)* — archived cutscene of scene 'bois_des_plaintes' to restore
- **TRANSFER** `RESERVE/red_cinematics/d25p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D25: audio, camera, dialogue and battle trigger to replay on the same Ground

## `lapis_cave` — Lapis Cave

- **REPLACE** `Data/Zone/lapis_cave.json` — legacy zone of a dungeon now owned by the Builder: regenerated from DungeonDefs/canonical/lapis_cave.json
- **HARVEST** `Data/Ground/grotte_lazuli_fond.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/grotte_lazuli_seuil.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/grotte_lazuli_fond` — cutscene of scene 'grotte_lazuli_fond' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/grotte_lazuli_fond` *(archivé)* — archived cutscene of scene 'grotte_lazuli_fond' to restore
- **TRANSFER** `Data/Script/halcyon/ground/grotte_lazuli_seuil` — cutscene of scene 'grotte_lazuli_seuil' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/grotte_lazuli_seuil` *(archivé)* — archived cutscene of scene 'grotte_lazuli_seuil' to restore
- **TRANSFER** `Data/Script/halcyon/zone/lapis_cave` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/red_cinematics/d08p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D08: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d08p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D08: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `lightning_field` — Lightning Field

- **TRANSFER** `RESERVE/grounds/champ_foudre.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/champ_foudre` *(archivé)* — archived cutscene of scene 'champ_foudre' to restore
- **TRANSFER** `RESERVE/scripts_zone/lightning_field` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d17p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D17: audio, camera, dialogue and battle trigger to replay on the same Ground

## `magma_cavern` — Magma Cavern

- **HARVEST** `Data/Ground/fosse_ardente.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/gorge_ardente_coeur.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/gorge_ardente_porte.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/fosse_ardente` — cutscene of scene 'fosse_ardente' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/fosse_ardente` *(archivé)* — archived cutscene of scene 'fosse_ardente' to restore
- **TRANSFER** `Data/Script/halcyon/ground/gorge_ardente_coeur` — cutscene of scene 'gorge_ardente_coeur' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/gorge_ardente_coeur` *(archivé)* — archived cutscene of scene 'gorge_ardente_coeur' to restore
- **TRANSFER** `Data/Script/halcyon/ground/gorge_ardente_porte` — cutscene of scene 'gorge_ardente_porte' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/gorge_ardente_porte` *(archivé)* — archived cutscene of scene 'gorge_ardente_porte' to restore
- **TRANSFER** `Data/Script/halcyon/zone/magma_cavern` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/scripts_zone/magma_cavern` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d12p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d12p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d12p04.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/purge_chapter6_32_dungeon_data.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `magma_cavern_pit` — Magma Cavern Pit

- **HARVEST** `Data/Ground/fosse_ardente.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/gorge_ardente_coeur.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/gorge_ardente_porte.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/fosse_ardente` — cutscene of scene 'fosse_ardente' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/fosse_ardente` *(archivé)* — archived cutscene of scene 'fosse_ardente' to restore
- **TRANSFER** `Data/Script/halcyon/ground/gorge_ardente_coeur` — cutscene of scene 'gorge_ardente_coeur' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/gorge_ardente_coeur` *(archivé)* — archived cutscene of scene 'gorge_ardente_coeur' to restore
- **TRANSFER** `Data/Script/halcyon/ground/gorge_ardente_porte` — cutscene of scene 'gorge_ardente_porte' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/gorge_ardente_porte` *(archivé)* — archived cutscene of scene 'gorge_ardente_porte' to restore
- **TRANSFER** `RESERVE/red_cinematics/d12p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d12p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d12p04.cif.json` *(archivé)* — canonical PMD Red cutscene of D12: audio, camera, dialogue and battle trigger to replay on the same Ground

## `meteor_cave` — Meteor Cave

- **TRANSFER** `RESERVE/scripts_zone/meteor_cave` *(archivé)* — archived zone script to restore

## `mt_blaze` — Mt. Blaze

- **REPLACE** `Data/Zone/mt_blaze.json` — legacy zone of a dungeon now owned by the Builder: regenerated from DungeonDefs/canonical/mt_blaze.json
- **HARVEST** `Data/Ground/d09p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d09p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/mont_cendre_pied.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d09p02` — cutscene of scene 'd09p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d09p03` — cutscene of scene 'd09p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/mont_cendre_pied` — cutscene of scene 'mont_cendre_pied' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/mont_cendre_pied` *(archivé)* — archived cutscene of scene 'mont_cendre_pied' to restore
- **TRANSFER** `Data/Script/halcyon/zone/mt_blaze` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/scripts_zone/mt_blaze` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d09p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d09p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d09p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/creer_midpoints.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/full_audit_pmdred_imports.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `mt_blaze_peak` — Mt. Blaze Peak

- **HARVEST** `Data/Ground/d09p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d09p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/mont_cendre_pied.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d09p02` — cutscene of scene 'd09p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d09p03` — cutscene of scene 'd09p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/mont_cendre_pied` — cutscene of scene 'mont_cendre_pied' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/mont_cendre_pied` *(archivé)* — archived cutscene of scene 'mont_cendre_pied' to restore
- **TRANSFER** `RESERVE/red_cinematics/d09p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d09p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d09p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D09: audio, camera, dialogue and battle trigger to replay on the same Ground

## `mt_faraway` — Mt. Faraway

- **HARVEST** `Data/Ground/sommet_aurore.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/sommet_aurore` *(archivé)* — archived cutscene of scene 'sommet_aurore' to restore
- **TRANSFER** `RESERVE/scripts_zone/mt_faraway` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d19p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D19: audio, camera, dialogue and battle trigger to replay on the same Ground

## `mt_freeze` — Mt. Freeze

- **REPLACE** `Data/Zone/mt_freeze.json` — legacy zone of a dungeon now owned by the Builder: regenerated from DungeonDefs/canonical/mt_freeze.json
- **HARVEST** `Data/Ground/d11p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d11p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/mont_gele_pied.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d11p02` — cutscene of scene 'd11p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d11p03` — cutscene of scene 'd11p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/mont_gele_pied` — cutscene of scene 'mont_gele_pied' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/mont_gele_pied` *(archivé)* — archived cutscene of scene 'mont_gele_pied' to restore
- **TRANSFER** `Data/Script/halcyon/zone/mt_freeze` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/red_cinematics/d11p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d11p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d11p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/creer_midpoints.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/full_audit_pmdred_imports.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `mt_freeze_peak` — Mt. Freeze Peak

- **HARVEST** `Data/Ground/d11p02.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/d11p03.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/mont_gele_pied.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/d11p02` — cutscene of scene 'd11p02' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/d11p03` — cutscene of scene 'd11p03' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/mont_gele_pied` — cutscene of scene 'mont_gele_pied' must follow the dungeon
- **TRANSFER** `RESERVE/scripts_ground/mont_gele_pied` *(archivé)* — archived cutscene of scene 'mont_gele_pied' to restore
- **TRANSFER** `RESERVE/red_cinematics/d11p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d11p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d11p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D11: audio, camera, dialogue and battle trigger to replay on the same Ground

## `mt_steel` — Mt. Steel

- **TRANSFER** `RESERVE/red_grounds/d03p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/pic_ferreux_pied.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/pic_ferreux_pied` *(archivé)* — archived cutscene of scene 'pic_ferreux_pied' to restore
- **TRANSFER** `RESERVE/red_cinematics/d03p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D03: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d03p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D03: audio, camera, dialogue and battle trigger to replay on the same Ground

## `mt_thunder` — Mt. Thunder

- **TRANSFER** `RESERVE/red_grounds/d06p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/red_grounds/d06p03.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/mont_grondant_pied.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/mont_grondant_pied` *(archivé)* — archived cutscene of scene 'mont_grondant_pied' to restore
- **TRANSFER** `RESERVE/scripts_zone/mt_thunder` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d06p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d06p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d06p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/creer_midpoints.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/full_audit_pmdred_imports.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `mt_thunder_peak` — Mt. Thunder Peak

- **TRANSFER** `RESERVE/red_grounds/d06p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/red_grounds/d06p03.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/mont_grondant_pied.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/mont_grondant_pied` *(archivé)* — archived cutscene of scene 'mont_grondant_pied' to restore
- **TRANSFER** `RESERVE/red_cinematics/d06p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d06p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d06p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D06: audio, camera, dialogue and battle trigger to replay on the same Ground

## `murky_cave` — Murky Cave

- **TRANSFER** `RESERVE/grounds/caverne_trouble_autel.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/caverne_trouble_fond.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/caverne_trouble_autel` *(archivé)* — archived cutscene of scene 'caverne_trouble_autel' to restore
- **TRANSFER** `RESERVE/scripts_ground/caverne_trouble_fond` *(archivé)* — archived cutscene of scene 'caverne_trouble_fond' to restore
- **TRANSFER** `RESERVE/red_cinematics/d24p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D24: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d24p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D24: audio, camera, dialogue and battle trigger to replay on the same Ground

## `northern_range` — Northern Range

- **HARVEST** `Data/Ground/cretes_boreales.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/cretes_boreales` *(archivé)* — archived cutscene of scene 'cretes_boreales' to restore
- **TRANSFER** `RESERVE/red_cinematics/d21p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D21: audio, camera, dialogue and battle trigger to replay on the same Ground

## `pitfall_valley` — Pitfall Valley

- **HARVEST** `Data/Ground/vallon_perdu.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/vallon_perdu` *(archivé)* — archived cutscene of scene 'vallon_perdu' to restore
- **TRANSFER** `RESERVE/red_cinematics/d22p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D22: audio, camera, dialogue and battle trigger to replay on the same Ground

## `purity_forest` — Purity Forest

- **TRANSFER** `RESERVE/scripts_zone/purity_forest` *(archivé)* — archived zone script to restore

## `silent_chasm` — Silent Chasm

- **TRANSFER** `RESERVE/red_grounds/d05p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/gouffre_muet_bord.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/gouffre_muet_bord` *(archivé)* — archived cutscene of scene 'gouffre_muet_bord' to restore
- **TRANSFER** `RESERVE/red_cinematics/d05p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D05: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d05p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D05: audio, camera, dialogue and battle trigger to replay on the same Ground

## `silver_trench` — Silver Trench

- **HARVEST** `Data/Ground/fosse_argentee.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/fosse_argentee` *(archivé)* — archived cutscene of scene 'fosse_argentee' to restore
- **TRANSFER** `RESERVE/scripts_zone/silver_trench` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d15p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D15: audio, camera, dialogue and battle trigger to replay on the same Ground

## `gloomy_forest` — Sinister Woods

- **CURRENT** `Data/Zone/gloomy_forest.json` — already produced by this Builder: it is the current canonical implementation
- **TRANSFER** `RESERVE/grounds/bois_sombres_oree.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **HARVEST** `Data/Ground/gloomy_forest_midpoint.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/sinister_woods_clearing.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/bois_sombres_oree` *(archivé)* — archived cutscene of scene 'bois_sombres_oree' to restore
- **TRANSFER** `Data/Script/halcyon/ground/gloomy_forest_midpoint` — cutscene of scene 'gloomy_forest_midpoint' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/sinister_woods_clearing` — cutscene of scene 'sinister_woods_clearing' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/zone/gloomy_forest` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/red_cinematics/d04p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D04: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d04p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D04: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/add_annexe_toupie.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_sinister_woods_relic_forest_separation.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/build_canonical_journey_registry.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/build_sinister_woods_chain_fixture.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/build_sinister_woods_procedural_fixture.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/insert_miniboss_segments.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/migrate_pmdred_sinister_woods_generator.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/purge_chapter6_32_dungeon_data.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/reduire_base.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/scale_boss_levels.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/validate_ch5.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/verify_zone_index.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `sky_tower` — Sky Tower

- **HARVEST** `Data/Ground/arc_palier_celeste.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/arc_parvis_celeste.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/arc_tour_ciel_sommet.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/arc_palier_celeste` — cutscene of scene 'arc_palier_celeste' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/arc_parvis_celeste` — cutscene of scene 'arc_parvis_celeste' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/arc_tour_ciel_sommet` — cutscene of scene 'arc_tour_ciel_sommet' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/zone/sky_tower` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/red_cinematics/d13p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d13p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d13p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/gen_addon_sky_network.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/purge_chapter6_32_dungeon_data.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/reduire_base.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `sky_tower_summit` — Sky Tower Summit

- **HARVEST** `Data/Ground/arc_palier_celeste.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/arc_parvis_celeste.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Ground/arc_tour_ciel_sommet.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `Data/Script/halcyon/ground/arc_palier_celeste` — cutscene of scene 'arc_palier_celeste' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/arc_parvis_celeste` — cutscene of scene 'arc_parvis_celeste' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/ground/arc_tour_ciel_sommet` — cutscene of scene 'arc_tour_ciel_sommet' must follow the dungeon
- **TRANSFER** `RESERVE/red_cinematics/d13p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d13p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d13p03.cif.json` *(archivé)* — canonical PMD Red cutscene of D13: audio, camera, dialogue and battle trigger to replay on the same Ground

## `stormy_sea` — Stormy Sea

- **HARVEST** `Data/Ground/abime_tempetes.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/abime_tempetes` *(archivé)* — archived cutscene of scene 'abime_tempetes' to restore
- **TRANSFER** `RESERVE/scripts_zone/stormy_sea` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d14p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D14: audio, camera, dialogue and battle trigger to replay on the same Ground

## `thunderwave_cave` — Thunderwave Cave

- **TRANSFER** `RESERVE/red_grounds/d02p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/grotte_statique_seuil.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/grotte_statique_seuil` *(archivé)* — archived cutscene of scene 'grotte_statique_seuil' to restore
- **TRANSFER** `RESERVE/red_cinematics/d02p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D02: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d02p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D02: audio, camera, dialogue and battle trigger to replay on the same Ground

## `tiny_woods` — Tiny Woods

- **TRANSFER** `RESERVE/red_grounds/d01p02.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/grounds/foret_tendre_oree.rsground` *(archivé)* — archived canonical scene to restore into the new implementation
- **TRANSFER** `RESERVE/scripts_ground/foret_tendre_oree` *(archivé)* — archived cutscene of scene 'foret_tendre_oree' to restore
- **TRANSFER** `RESERVE/red_cinematics/d01p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D01: audio, camera, dialogue and battle trigger to replay on the same Ground
- **TRANSFER** `RESERVE/red_cinematics/d01p02.cif.json` *(archivé)* — canonical PMD Red cutscene of D01: audio, camera, dialogue and battle trigger to replay on the same Ground

## `waterfall_pond` — Waterfall Pond

- **TRANSFER** `Data/Script/halcyon/zone/waterfall_pond` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_terapagos_20f.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/purge_chapter6_32_dungeon_data.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/reduire_base.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated

## `western_cave` — Western Cave

- **HARVEST** `Data/Ground/antre_occident.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **TRANSFER** `RESERVE/scripts_ground/antre_occident` *(archivé)* — archived cutscene of scene 'antre_occident' to restore
- **TRANSFER** `RESERVE/scripts_zone/western_cave` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d20p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D20: audio, camera, dialogue and battle trigger to replay on the same Ground

## `wish_cave` — Wish Cave

- **REPLACE** `Data/Zone/wish_cave.json` — legacy zone of a dungeon now owned by the Builder: regenerated from DungeonDefs/canonical/wish_cave.json
- **HARVEST** `Data/Ground/sanctuaire_voeu.rsground` — canonical scene kept as-is: geometry, collisions, markers and objects are the source of truth for cutscene + battle
- **HARVEST** `Data/Map/sanctuaire_voeu.rsmap` — canonical scene available as a map: becomes the Ground of this very scene
- **TRANSFER** `Data/Script/halcyon/ground/sanctuaire_voeu` — cutscene of scene 'sanctuaire_voeu' must follow the dungeon
- **TRANSFER** `Data/Script/halcyon/zone/wish_cave` — zone script (floor events, boss trigger) rebound to the regenerated zone
- **TRANSFER** `RESERVE/scripts_zone/wish_cave` *(archivé)* — archived zone script to restore
- **TRANSFER** `RESERVE/red_cinematics/d23p01.cif.json` *(archivé)* — canonical PMD Red cutscene of D23: audio, camera, dialogue and battle trigger to replay on the same Ground
- **REVIEW** `tools/audit_geometry_uniqueness.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
- **REVIEW** `tools/audit_red_narrative.py` — legacy generator that writes this dungeon's zone: superseded by the Builder, to retire manually once the rebuild is validated
