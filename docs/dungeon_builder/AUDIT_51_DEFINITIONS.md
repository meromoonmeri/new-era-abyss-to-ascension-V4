# Audit global des définitions canoniques Ch.6–32

_Généré le 2026-08-22T22:01:43+00:00 — 51 définitions : **26 PASS**, **25 FAIL**._

Aucun étage procédural n'a été généré à cette étape, et `generate-all` n'a pas été lancé.

## Tableau de bord

| Statut | Donjon | Ch. | Ét. | Seg. | Dir. | DTEF | Profils | Espèces | Objets | Fin | Blocage principal |
|---|---|---|---|---|---|---|---|---|---|---|---|
| ✅ PASS | `gloomy_forest` | 6 | 14 | 3 | fond | `sinister_woods_b41` | branching, dense, mixed, crossroads, looping, large_rooms, ring | 27 | 45 | canonical_ground | — |
| ✅ PASS | `mt_steel` | 7 | 9 | 1 | sommet | `steel_aegis_cave` | twosides, branching, mixed | 9 | 9 | — | — |
| ✅ PASS | `thunderwave_cave` | 7 | 5 | 1 | fond | `chasm_cave` | branching, mixed, dense | 7 | 6 | — | — |
| ✅ PASS | `tiny_woods` | 7 | 3 | 1 | fond | `mystifying_forest` | branching, dense, mixed | 4 | 2 | — | — |
| ✅ PASS | `silent_chasm` | 8 | 9 | 1 | fond | `chasm_cave` | branching, mixed, dense | 12 | 21 | — | — |
| ✅ PASS | `great_canyon` | 9 | 12 | 2 | sommet | `mt_horn` | twosides, branching, mixed, crossroads | 16 | 44 | — | — |
| ✅ PASS | `mt_thunder` | 9 | 10 | 2 | sommet | `craggy_peak` | twosides, branching, mixed, crossroads | 15 | 44 | — | — |
| ✅ PASS | `magma_cavern` | 12 | 23 | 3 | fond | `magma_cavern_2` | branching, mixed, dense, looping, lattice, large_rooms | 22 | 45 | canonical_ground | — |
| ✅ PASS | `magma_cavern_pit` | 12 | 3 | 1 | fond | `world_abyss_2` | branching, mixed, dense | 5 | 0 | canonical_ground | — |
| ✅ PASS | `mt_freeze_peak` | 12 | 5 | 1 | sommet | `sky_peak_4th_pass` | large_rooms, crossroads, mixed | 1 | 14 | — | — |
| ✅ PASS | `pitfall_valley` | 16 | 25 | 2 | fond | `pitfall_valley_1` | twosides, branching, mixed, crossroads | 17 | 53 | — | — |
| ✅ PASS | `desert_region` | 17 | 20 | 2 | sommet | `quicksand_pit` | large_rooms, twosides, mixed, looping, dense | 13 | 28 | — | — |
| ✅ PASS | `southern_cavern` | 17 | 50 | 3 | fond | `western_cave_2` | branching, mixed, dense, looping, lattice, large_rooms | 31 | 55 | — | — |
| ✅ PASS | `solar_cave` | 19 | 20 | 2 | fond | `golden_chamber` | branching, mixed, dense, looping, lattice | 25 | 36 | — | — |
| ✅ PASS | `darknight_relic` | 20 | 15 | 2 | fond | `the_nightmare` | crossroads, lattice, mixed, looping, dense | 14 | 42 | — | — |
| ✅ PASS | `murky_cave` | 21 | 19 | 2 | fond | `dark_hill` | branching, mixed, dense, looping, lattice | 17 | 0 | — | — |
| ✅ PASS | `oddity_cave` | 22 | 15 | 2 | fond | `spacial_rift_2` | branching, mixed, dense, looping, lattice | 24 | 58 | — | — |
| ✅ PASS | `uproar_forest` | 22 | 10 | 2 | fond | `treeshroud_forest_2` | branching, dense, mixed, looping | 10 | 15 | — | — |
| ✅ PASS | `marvelous_sea` | 23 | 20 | 2 | fond | `miracle_sea` | looping, ring, mixed, lattice | 15 | 36 | — | — |
| ✅ PASS | `remains_island` | 23 | 20 | 2 | fond | `concealed_ruins` | crossroads, lattice, mixed, looping, dense | 27 | 58 | — | — |
| ✅ PASS | `rock_path` | 24 | 4 | 1 | fond | `rock_path_rb` | branching, mixed, dense | 5 | 15 | — | — |
| ✅ PASS | `howling_forest` | 25 | 15 | 2 | sommet | `howling_forest_2` | branching, dense, mixed, looping | 16 | 54 | — | — |
| ✅ PASS | `unown_relic` | 26 | 11 | 2 | fond | `sealed_ruin_pit` | crossroads, lattice, mixed, looping, dense | 52 | 28 | — | — |
| ✅ PASS | `waterfall_pond` | 26 | 19 | 2 | fond | `unused_waterfall_pond` | looping, ring, mixed, lattice | 23 | 12 | — | — |
| ✅ PASS | `far_off_sea` | 27 | 75 | 3 | fond | `zero_isle_east_4` | looping, ring, mixed, lattice, large_rooms | 36 | 60 | — | — |
| ✅ PASS | `joyous_tower` | 27 | 99 | 3 | sommet | `lush_prairie` | crossroads, branching, mixed, lattice, looping, large_rooms | 125 | 132 | — | — |
| ❌ FAIL | `mt_thunder_peak` | 9 | 3 | 1 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `lapis_cave` | 10 | 14 | 2 | fond | `lapis_cave` | branching, mixed, dense, looping, lattice | 11 | 44 | canonical_ground | BLOCKED/OUT_OF_SCOPE |
| ❌ FAIL | `mt_blaze` | 10 | 12 | 2 | sommet | `mt_blaze` | twosides, branching, mixed, crossroads | 9 | 24 | — | BLOCKED/OUT_OF_SCOPE |
| ❌ FAIL | `mt_blaze_peak` | 10 | 3 | 1 | sommet | `magma_cavern_2` | large_rooms, crossroads, mixed | 3 | 1 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `sky_tower` | 10 | 25 | 1 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `sky_tower_summit` | 10 | 9 | 1 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `frosty_forest` | 11 | 9 | 1 | sommet | `frosty_forest` | branching, dense, mixed | 8 | 22 | — | BLOCKED/OUT_OF_SCOPE |
| ❌ FAIL | `frosty_grotto` | 11 | 5 | 1 | sommet | `mt_freeze` | branching, mixed, dense | 3 | 5 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `mt_freeze` | 11 | 15 | 2 | sommet | `mt_freeze` | twosides, branching, mixed, crossroads | 13 | 56 | — | BLOCKED/OUT_OF_SCOPE |
| ❌ FAIL | `silver_trench` | 13 | 99 | 3 | fond | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `stormy_sea` | 13 | 40 | 3 | fond | `stormy_sea_1` | looping, ring, mixed, lattice, large_rooms | 24 | 116 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `meteor_cave` | 14 | 20 | 2 | fond | `spacial_rift_1` | branching, mixed, dense, looping, lattice | 7 | 0 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `western_cave` | 14 | 99 | 3 | fond | `western_cave_1` | branching, mixed, dense, looping, lattice, large_rooms | 55 | 36 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `buried_relic` | 15 | 99 | 3 | fond | `sealed_ruin` | crossroads, lattice, mixed, looping, dense, large_rooms | 50 | 120 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `wish_cave` | 15 | 99 | 2 | fond | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `northern_range` | 16 | 25 | 2 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `fiery_field` | 18 | 30 | 2 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `wyvern_hill` | 18 | 30 | 2 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `northwind_field` | 19 | 30 | 2 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `lightning_field` | 20 | 30 | 2 | sommet | `far_amp_plains` | twosides, large_rooms, mixed, looping | 22 | 66 | arena_rsmap | BLOCKED/MISSING_ASSET |
| ❌ FAIL | `grand_sea` | 21 | 30 | 2 | fond | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `fantasy_strait` | 24 | 30 | 2 | fond | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `snow_path` | 25 | 4 | 1 | fond | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `mt_faraway` | 28 | 40 | 3 | sommet | `—` | — | 0 | 0 | — | BLOCKED/INVALID_DEFINITION |
| ❌ FAIL | `purity_forest` | 29 | 99 | 4 | sommet | `purity_forest_4` | branching, dense, mixed, looping, large_rooms | 154 | 171 | arena_rsmap | BLOCKED/MISSING_ASSET |

## Blocages détaillés

### `mt_thunder_peak` — Mt. Thunder Peak (ch.9)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'mt_thunder_peak_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `lapis_cave` — Lapis Cave (ch.10)
- BLOCKED/OUT_OF_SCOPE: Data/Zone/lapis_cave.json already exists and belongs to another agent

### `mt_blaze` — Mt. Blaze (ch.10)
- BLOCKED/OUT_OF_SCOPE: Data/Zone/mt_blaze.json already exists and belongs to another agent

### `mt_blaze_peak` — Mt. Blaze Peak (ch.10)
- BLOCKED/MISSING_ASSET: arena 'mt_blaze_peak_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'mt_blaze_peak_arena.rsmap' must exist in Data/Map before conversion

### `sky_tower` — Sky Tower (ch.10)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/OUT_OF_SCOPE: already imported by another agent (Sky Tower arc)

### `sky_tower_summit` — Sky Tower Summit (ch.10)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'sky_tower_summit_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/OUT_OF_SCOPE: already imported by another agent (Sky Tower arc)

### `frosty_forest` — Frosty Forest (ch.11)
- BLOCKED/OUT_OF_SCOPE: Data/Zone/frosty_forest.json already exists and belongs to another agent

### `frosty_grotto` — Frosty Grotto (ch.11)
- BLOCKED/MISSING_ASSET: arena 'frosty_grotto_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'frosty_grotto_arena.rsmap' must exist in Data/Map before conversion

### `mt_freeze` — Mt. Freeze (ch.11)
- BLOCKED/OUT_OF_SCOPE: Data/Zone/mt_freeze.json already exists and belongs to another agent

### `silver_trench` — Silver Trench (ch.13)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'silver_trench_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `stormy_sea` — Stormy Sea (ch.13)
- BLOCKED/MISSING_ASSET: arena 'stormy_sea_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'stormy_sea_arena.rsmap' must exist in Data/Map before conversion

### `meteor_cave` — Meteor Cave (ch.14)
- BLOCKED/MISSING_ASSET: arena 'meteor_cave_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'meteor_cave_arena.rsmap' must exist in Data/Map before conversion

### `western_cave` — Western Cave (ch.14)
- BLOCKED/MISSING_ASSET: arena 'western_cave_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'western_cave_arena.rsmap' must exist in Data/Map before conversion

### `buried_relic` — Buried Relic (ch.15)
- BLOCKED/MISSING_ASSET: arena 'buried_relic_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'buried_relic_arena.rsmap' must exist in Data/Map before conversion

### `wish_cave` — Wish Cave (ch.15)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/OUT_OF_SCOPE: Data/Zone/wish_cave.json already exists and belongs to another agent

### `northern_range` — Northern Range (ch.16)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'northern_range_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `fiery_field` — Fiery Field (ch.18)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'fiery_field_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `wyvern_hill` — Wyvern Hill (ch.18)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome

### `northwind_field` — Northwind Field (ch.19)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'northwind_field_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `lightning_field` — Lightning Field (ch.20)
- BLOCKED/MISSING_ASSET: arena 'lightning_field_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'lightning_field_arena.rsmap' must exist in Data/Map before conversion

### `grand_sea` — Grand Sea (ch.21)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome

### `fantasy_strait` — Fantasy Strait (ch.24)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome

### `snow_path` — Snow Path (ch.25)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome

### `mt_faraway` — Mt. Faraway (ch.28)
- BLOCKED/INVALID_DEFINITION: no DTEF tileset declared (dungeon level or every segment)
- BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome
- BLOCKED/MISSING_ASSET: arena 'mt_faraway_arena.rsmap' must be authored before the boss scene can be converted to a Ground

### `purity_forest` — Purity Forest (ch.29)
- BLOCKED/MISSING_ASSET: arena 'purity_forest_arena.rsmap' must be authored before the boss scene can be converted to a Ground
- BLOCKED/SCENE: dedicated arena 'purity_forest_arena.rsmap' must exist in Data/Map before conversion

## Limites connues de l'environnement

- Pas de runtime .NET dans cet environnement : la validation runtime in-engine (chargement réel d'une zone par RogueEssence) reste impossible ici ; les rapports laissent le champ « runtime » non renseigné.
- `GridPathTiered` / `GridPathTreads` restent hors profils tant que leur comportement réel n'a pas été lu dans les sources RogueEssence (dépôt non accessible publiquement).
