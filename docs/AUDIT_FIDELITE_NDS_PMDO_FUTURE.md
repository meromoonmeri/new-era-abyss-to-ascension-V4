# AUDIT DE FIDÉLITÉ NDS → PMDO — PARCOURS FUTUR (46 floors)

Date : 2026-08-09 — Source : mappa_s.bin + monster.md (données NDS) vs Data/Zone/*.json (PMDO).

## Récapitulatif

- Floors audités : **46** (8+15+8+6+1+8 = 46)
- Entrées Pokémon NDS : **224** · PMDO : **224**
- Floors sans différence (tileset+musique+dark+ennemis) : **46/46**

## Monster houses

| Zone | NDS (%) | PMDO (%) | Conforme |
|---|---|---|---|
| chasm_cave | 0 | 0 | ✅ |
| dark_hill | 0 | 0 | ✅ |
| sealed_ruin | 5 | 5 | ✅ |
| sealed_ruin_pit | 5 | 5 | ✅ |
| spiritomb_room | 5 | 5 | ✅ |
| dusk_forest | 0 | 0 | ✅ |

## Matrice par floor (46 lignes)

| Zone | F | NDS tset | PMDO tset | NDS mus | PMDO mus | NDS dark | PMDO sight | en | item | trap | MH | fixed | mobs NDS/PMDO | OK |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| chasm_cave | 1 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 4 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| chasm_cave | 2 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 4 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| chasm_cave | 3 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 4 | 3 | 6 | 0 | 0 | 6/6 | ✅ |
| chasm_cave | 4 | 26 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 4 | 3 | 6 | 0 | 0 | 6/6 | ✅ |
| chasm_cave | 5 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 5 | 3 | 6 | 0 | 0 | 6/6 | ✅ |
| chasm_cave | 6 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 5 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| chasm_cave | 7 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 5 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| chasm_cave | 8 | 27 | chasm_cave_floor | 19 | Chasm Cave.ogg | 2 | 0 | 5 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| dark_hill | 1 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 3 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 2 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 3 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 3 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 3 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 4 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 5 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| dark_hill | 6 | 28 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| dark_hill | 7 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| dark_hill | 8 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 5/5 | ✅ |
| dark_hill | 9 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 10 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 11 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 12 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 13 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 14 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dark_hill | 15 | 29 | dark_hill_floor | 20 | Dark Hill.ogg | 0 | 1 | 5 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| sealed_ruin | 1 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 4 | 3 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 2 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 4 | 3 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 3 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 4 | 3 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 4 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 4 | 3 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 5 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 4 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 6 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 7 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin | 8 | 30 | sealed_ruin_floor | 21 | Sealed Ruin.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 1 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 2 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 3 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 4 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 5 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| sealed_ruin_pit | 6 | 31 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 0 | 6/6 | ✅ |
| spiritomb_room | 1 | 176 | sealed_ruin_pit_floor | 22 | Sealed Ruin Pit.ogg | 0 | 1 | 5 | 4 | 6 | 5 | 7 | 1/1 | ✅ |
| dusk_forest | 1 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 2 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 3 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 4 | 3 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 4 | 33 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 4 | 4 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 5 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 0 | 1 | 4 | 4 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 6 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 4 | 4 | 6 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 7 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 4 | 4 | 8 | 0 | 0 | 4/4 | ✅ |
| dusk_forest | 8 | 34 | dusk_forest_floor | 23 | Dusk Forest.ogg | 2 | 0 | 4 | 5 | 8 | 0 | 0 | 4/4 | ✅ |
