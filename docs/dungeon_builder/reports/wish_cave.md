# Rapport de génération — Wish Cave

- **ID** : `wish_cave`  
- **Chapitre** : 15 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Wish Cave (99F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/WishCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 15. Recoupé avec Bulbapedia (page « Wish Cave »).  
- **Étages** : 99 — direction `fond`  
- **Zone écrite** : `Data/Zone/wish_cave.json`  
- **Seed d'auteur (debug)** : `7044975162114743349` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| wish_gallery | 1-50 | wish_gallery | `wish_cave_1_floor` | branching, mixed, dense | 43 | oui | oui | — |
| wish_sanctum | 51-99 | wish_sanctum | `wish_cave_1_floor` | looping, lattice, mixed | 40 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `sanctuaire_voeu`
- boss : mode `canonical_ground` → Ground `sanctuaire_voeu`, rsmap `sanctuaire_voeu`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'sanctuaire_voeu' (no separate arena created)
  - scene source of truth: sanctuaire_voeu.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 7x8 | 5 | 1 | 8/17.0/24 | 20.4 | 6.4 | 5.6 | 2.0 | 33.6 | 5 | oui |
| 2 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 14x7 | 5 | 0 | 11/15.2/22 | 18.0 | 5.6 | 3.0 | 2.4 | 38.6 | 5 | oui |
| 3 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 14x12 | 5 | 0 | 10/14.0/22 | 16.2 | 4.6 | 3.4 | 2.0 | 34.2 | 5 | oui |
| 4 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 9x8 | 5 | 0 | 7/12.0/19 | 12.2 | 3.6 | 4.6 | 0.6 | 36.6 | 5 | oui |
| 5 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 9x8 | 5 | 0 | 9/17.8/26 | 21.0 | 6.6 | 4.6 | 2.4 | 48.0 | 5 | oui |
| 6 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 9x8 | 5 | 1 | 6/8.6/16 | 8.4 | 2.0 | 2.8 | 0.6 | 32.8 | 5 | oui |
| 7 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 7x7 | 5 | 2 | 11/14.8/21 | 18.2 | 4.6 | 2.6 | 2.8 | 45.0 | 5 | oui |
| 8 | wish_gallery | procedural | branching+mixed+dense | 5x5 | 12x7 | 5 | 0 | 6/12.2/20 | 14.8 | 4.4 | 2.8 | 2.0 | 34.8 | 5 | oui |
| 9 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 8x6 | 5 | 0 | 8/16.0/25 | 18.2 | 5.0 | 4.2 | 1.8 | 43.0 | 5 | oui |
| 10 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 10x9 | 5 | 1 | 9/14.0/25 | 15.4 | 4.2 | 4.4 | 1.4 | 34.8 | 5 | oui |
| 11 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 11x10 | 5 | 1 | 9/13.0/20 | 15.2 | 4.4 | 4.0 | 1.6 | 42.6 | 5 | oui |
| 12 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 8x6 | 5 | 1 | 9/18.0/30 | 21.6 | 5.8 | 4.8 | 2.0 | 51.0 | 5 | oui |
| 13 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x9 | 5 | 1 | 8/11.6/15 | 11.8 | 3.2 | 3.8 | 0.8 | 48.4 | 5 | oui |
| 14 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 8x7 | 5 | 2 | 8/12.8/17 | 14.6 | 4.2 | 3.8 | 1.6 | 37.8 | 5 | oui |
| 15 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 9x10 | 5 | 0 | 8/14.4/22 | 16.8 | 5.6 | 4.4 | 2.0 | 33.4 | 5 | oui |
| 16 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 7x6 | 5 | 1 | 8/11.2/15 | 11.4 | 2.8 | 3.6 | 0.8 | 32.0 | 5 | oui |
| 17 | wish_gallery | procedural | branching+mixed+dense | 7x3 | 13x11 | 5 | 1 | 8/11.6/19 | 12.2 | 3.6 | 3.4 | 1.2 | 47.4 | 5 | oui |
| 18 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 10x8 | 5 | 1 | 14/20.2/27 | 24.2 | 7.2 | 6.0 | 2.2 | 39.0 | 5 | oui |
| 19 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 7x6 | 5 | 0 | 6/13.2/30 | 15.2 | 4.2 | 3.6 | 1.6 | 33.8 | 5 | oui |
| 20 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 11x9 | 5 | 0 | 9/13.0/20 | 16.4 | 4.6 | 3.0 | 2.4 | 47.4 | 5 | oui |
| 21 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 7x6 | 5 | 1 | 7/12.8/24 | 13.2 | 3.0 | 4.0 | 0.6 | 44.0 | 5 | oui |
| 22 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 9x8 | 5 | 0 | 11/18.4/27 | 21.0 | 6.0 | 4.6 | 2.2 | 42.4 | 5 | oui |
| 23 | wish_gallery | procedural | branching+mixed+dense | 8x4 | 9x6 | 5 | 0 | 8/13.0/19 | 15.4 | 4.6 | 3.6 | 1.8 | 37.8 | 5 | oui |
| 24 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 11x9 | 5 | 0 | 8/17.0/30 | 19.8 | 5.0 | 5.0 | 1.8 | 38.8 | 5 | oui |
| 25 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 10x7 | 5 | 0 | 8/15.8/28 | 20.2 | 6.0 | 3.0 | 3.0 | 41.0 | 5 | oui |
| 26 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 9x7 | 5 | 0 | 10/16.2/27 | 20.4 | 6.0 | 3.2 | 2.8 | 41.2 | 5 | oui |
| 27 | wish_gallery | procedural | branching+mixed+dense | 5x5 | 13x7 | 5 | 0 | 7/14.0/20 | 16.4 | 5.4 | 3.4 | 2.2 | 36.8 | 5 | oui |
| 28 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 11x10 | 5 | 0 | 13/16.4/20 | 19.0 | 5.4 | 4.6 | 2.4 | 37.6 | 5 | oui |
| 29 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 11x8 | 5 | 2 | 10/17.0/33 | 18.0 | 5.0 | 6.0 | 1.0 | 43.6 | 5 | oui |
| 30 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 9x8 | 5 | 1 | 8/14.0/20 | 15.6 | 4.4 | 4.4 | 1.6 | 40.2 | 5 | oui |
| 31 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x9 | 5 | 0 | 14/16.8/20 | 20.8 | 6.8 | 4.4 | 3.0 | 38.8 | 5 | oui |
| 32 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 12x8 | 5 | 1 | 9/11.4/16 | 12.4 | 4.2 | 3.4 | 1.6 | 46.6 | 5 | oui |
| 33 | wish_gallery | procedural | branching+mixed+dense | 4x3 | 11x12 | 5 | 0 | 10/15.4/24 | 16.6 | 4.8 | 4.8 | 1.4 | 49.2 | 5 | oui |
| 34 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 10x9 | 5 | 0 | 7/13.0/19 | 13.8 | 4.4 | 5.2 | 0.8 | 38.6 | 5 | oui |
| 35 | wish_gallery | procedural | branching+mixed+dense | 4x4 | 11x9 | 5 | 2 | 10/14.4/24 | 16.2 | 5.6 | 4.0 | 2.0 | 37.6 | 5 | oui |
| 36 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 10x10 | 5 | 0 | 12/14.6/19 | 17.6 | 5.4 | 3.4 | 2.2 | 44.4 | 5 | oui |
| 37 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x8 | 5 | 1 | 8/11.2/16 | 12.0 | 3.6 | 3.4 | 1.4 | 39.6 | 5 | oui |
| 38 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 11x9 | 5 | 0 | 9/14.4/23 | 16.4 | 4.8 | 4.6 | 1.4 | 40.6 | 5 | oui |
| 39 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 7x7 | 5 | 1 | 8/13.4/24 | 16.4 | 5.2 | 4.0 | 1.8 | 44.8 | 5 | oui |
| 40 | wish_gallery | procedural | branching+mixed+dense | 6x3 | 9x12 | 5 | 0 | 8/13.4/21 | 16.8 | 5.2 | 3.2 | 2.4 | 41.0 | 5 | oui |
| 41 | wish_gallery | procedural | branching+mixed+dense | 5x4 | 10x10 | 5 | 0 | 12/16.2/24 | 17.4 | 4.0 | 4.6 | 1.2 | 43.4 | 5 | oui |
| 42 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x8 | 5 | 1 | 7/13.4/18 | 13.6 | 4.0 | 4.6 | 1.0 | 38.8 | 5 | oui |
| 43 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 8x8 | 5 | 0 | 9/13.4/23 | 15.0 | 3.8 | 3.0 | 1.6 | 26.6 | 5 | oui |
| 44 | wish_gallery | procedural | branching+mixed+dense | 7x4 | 7x7 | 5 | 0 | 9/16.0/27 | 18.2 | 5.0 | 4.0 | 1.8 | 39.4 | 5 | oui |
| 45 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x9 | 5 | 0 | 8/17.2/28 | 19.2 | 5.6 | 4.4 | 2.0 | 38.2 | 5 | oui |
| 46 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 9x7 | 5 | 0 | 7/14.6/23 | 17.0 | 6.0 | 4.6 | 1.8 | 48.6 | 5 | oui |
| 47 | wish_gallery | procedural | branching+mixed+dense | 5x3 | 12x11 | 5 | 0 | 6/11.6/21 | 13.6 | 3.6 | 3.6 | 1.2 | 32.8 | 5 | oui |
| 48 | wish_gallery | procedural | branching+mixed+dense | 6x4 | 9x7 | 5 | 0 | 10/16.2/26 | 18.8 | 4.8 | 3.8 | 2.2 | 33.4 | 5 | oui |
| 49 | wish_gallery | procedural | branching+mixed+dense | 7x5 | 7x6 | 5 | 1 | 10/11.4/13 | 11.2 | 3.4 | 4.2 | 0.6 | 32.8 | 5 | oui |
| 50 | wish_gallery | procedural | branching+mixed+dense | 6x5 | 8x11 | 5 | 0 | 9/16.2/24 | 19.2 | 5.2 | 4.2 | 2.0 | 49.6 | 5 | oui |
| 51 | wish_sanctum | procedural | looping+lattice+mixed | 7x3 | 13x12 | 5 | 0 | 7/13.0/23 | 17.6 | 5.4 | 2.6 | 2.8 | 36.0 | 5 | oui |
| 52 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 13x9 | 5 | 0 | 9/12.2/15 | 19.2 | 5.6 | 2.4 | 3.8 | 35.4 | 5 | oui |
| 53 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 12x10 | 5 | 1 | 8/8.8/11 | 14.2 | 4.4 | 2.4 | 2.8 | 39.4 | 5 | oui |
| 54 | wish_sanctum | procedural | looping+lattice+mixed | 7x4 | 9x9 | 5 | 2 | 8/13.4/21 | 22.4 | 7.0 | 3.6 | 4.4 | 41.0 | 5 | oui |
| 55 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 10x9 | 5 | 0 | 7/12.2/21 | 20.0 | 6.8 | 2.4 | 4.6 | 39.6 | 5 | oui |
| 56 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x8 | 5 | 0 | 5/11.8/17 | 18.8 | 5.4 | 2.8 | 3.6 | 32.6 | 5 | oui |
| 57 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x10 | 5 | 0 | 7/9.6/13 | 13.4 | 4.0 | 2.8 | 2.0 | 45.2 | 5 | oui |
| 58 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 12x8 | 5 | 0 | 8/8.8/12 | 11.4 | 2.8 | 2.2 | 1.6 | 36.8 | 5 | oui |
| 59 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x9 | 5 | 2 | 7/11.6/17 | 17.6 | 6.4 | 2.0 | 4.0 | 37.2 | 5 | oui |
| 60 | wish_sanctum | procedural | looping+lattice+mixed | 7x3 | 14x10 | 5 | 0 | 10/11.8/15 | 19.6 | 5.8 | 2.0 | 4.4 | 49.4 | 5 | oui |
| 61 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 12x8 | 5 | 0 | 8/10.6/14 | 16.8 | 5.8 | 2.6 | 3.2 | 45.4 | 5 | oui |
| 62 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 8x8 | 5 | 1 | 10/13.4/21 | 18.6 | 5.4 | 2.6 | 3.0 | 43.2 | 5 | oui |
| 63 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 12x9 | 5 | 4 | 10/13.4/21 | 18.0 | 5.2 | 3.0 | 2.8 | 38.8 | 5 | oui |
| 64 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x10 | 5 | 1 | 8/8.6/10 | 13.4 | 4.2 | 1.4 | 2.8 | 43.8 | 5 | oui |
| 65 | wish_sanctum | procedural | looping+lattice+mixed | 7x5 | 11x8 | 5 | 0 | 4/9.2/16 | 12.2 | 3.2 | 1.4 | 2.0 | 37.8 | 5 | oui |
| 66 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 10x10 | 5 | 0 | 6/10.4/15 | 15.2 | 4.6 | 2.6 | 2.8 | 41.8 | 5 | oui |
| 67 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 12x11 | 5 | 1 | 8/11.4/16 | 13.8 | 4.0 | 3.4 | 1.8 | 38.8 | 5 | oui |
| 68 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 12x10 | 5 | 0 | 8/9.6/12 | 12.6 | 3.8 | 2.6 | 2.0 | 44.4 | 5 | oui |
| 69 | wish_sanctum | procedural | looping+lattice+mixed | 7x5 | 12x10 | 5 | 0 | 7/10.4/16 | 13.0 | 3.2 | 2.6 | 1.6 | 29.0 | 5 | oui |
| 70 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 10x10 | 5 | 0 | 5/10.8/14 | 15.4 | 4.4 | 2.4 | 2.6 | 46.4 | 5 | oui |
| 71 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 11x11 | 5 | 0 | 7/10.0/13 | 15.2 | 4.8 | 2.4 | 2.8 | 46.8 | 5 | oui |
| 72 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 10x8 | 5 | 1 | 7/12.8/21 | 16.4 | 4.2 | 2.2 | 2.4 | 45.2 | 5 | oui |
| 73 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 8x7 | 5 | 0 | 8/9.8/13 | 15.8 | 5.0 | 2.0 | 3.4 | 48.2 | 5 | oui |
| 74 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 14x9 | 5 | 0 | 9/12.2/16 | 17.6 | 4.4 | 2.6 | 2.4 | 39.6 | 5 | oui |
| 75 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 9x8 | 5 | 0 | 9/11.2/16 | 16.2 | 4.6 | 2.8 | 2.6 | 49.6 | 5 | oui |
| 76 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x10 | 5 | 0 | 8/10.0/12 | 17.6 | 6.0 | 2.2 | 4.2 | 45.6 | 5 | oui |
| 77 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x8 | 5 | 1 | 5/9.4/13 | 11.0 | 2.2 | 1.4 | 1.4 | 38.0 | 5 | oui |
| 78 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 9x8 | 5 | 1 | 9/12.8/20 | 17.4 | 5.4 | 3.6 | 2.6 | 37.2 | 5 | oui |
| 79 | wish_sanctum | procedural | looping+lattice+mixed | 7x3 | 8x10 | 5 | 0 | 7/13.4/20 | 21.0 | 7.6 | 3.2 | 4.0 | 49.4 | 5 | oui |
| 80 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 9x8 | 5 | 0 | 7/8.8/12 | 13.0 | 4.4 | 2.0 | 2.6 | 31.4 | 5 | oui |
| 81 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 9x8 | 5 | 0 | 7/8.8/12 | 11.8 | 3.2 | 2.2 | 1.8 | 31.6 | 5 | oui |
| 82 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 11x9 | 5 | 0 | 5/12.2/25 | 15.6 | 5.2 | 2.8 | 2.4 | 44.4 | 5 | oui |
| 83 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 10x10 | 5 | 0 | 10/12.0/15 | 20.4 | 6.6 | 2.4 | 4.4 | 33.4 | 5 | oui |
| 84 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 8x8 | 5 | 1 | 7/11.4/22 | 15.2 | 4.2 | 2.4 | 2.2 | 45.4 | 5 | oui |
| 85 | wish_sanctum | procedural | looping+lattice+mixed | 4x4 | 11x9 | 5 | 0 | 10/12.4/14 | 19.2 | 6.8 | 3.8 | 3.4 | 45.6 | 5 | oui |
| 86 | wish_sanctum | procedural | looping+lattice+mixed | 4x5 | 11x8 | 5 | 2 | 5/12.0/25 | 16.6 | 4.8 | 3.0 | 2.6 | 53.6 | 5 | oui |
| 87 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 9x10 | 5 | 0 | 8/10.8/15 | 17.2 | 4.8 | 2.4 | 3.0 | 45.8 | 5 | oui |
| 88 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 8x9 | 5 | 0 | 5/11.6/21 | 16.8 | 4.8 | 2.4 | 2.6 | 46.0 | 5 | oui |
| 89 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 11x8 | 5 | 0 | 7/10.0/13 | 16.6 | 5.6 | 3.2 | 3.2 | 44.0 | 5 | oui |
| 90 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 9x8 | 5 | 0 | 9/11.6/17 | 19.4 | 6.4 | 2.2 | 4.2 | 51.0 | 5 | oui |
| 91 | wish_sanctum | procedural | looping+lattice+mixed | 5x4 | 12x10 | 5 | 0 | 5/9.4/12 | 12.8 | 4.2 | 2.2 | 2.4 | 43.8 | 5 | oui |
| 92 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 11x9 | 5 | 1 | 8/10.2/13 | 14.8 | 5.0 | 3.0 | 2.6 | 35.2 | 5 | oui |
| 93 | wish_sanctum | procedural | looping+lattice+mixed | 6x3 | 9x9 | 5 | 2 | 5/11.4/23 | 17.0 | 5.6 | 2.6 | 3.0 | 40.8 | 5 | oui |
| 94 | wish_sanctum | procedural | looping+lattice+mixed | 6x4 | 13x10 | 5 | 0 | 4/10.4/15 | 15.6 | 4.4 | 1.8 | 3.0 | 38.4 | 5 | oui |
| 95 | wish_sanctum | procedural | looping+lattice+mixed | 7x4 | 11x10 | 5 | 0 | 7/10.8/14 | 15.2 | 4.0 | 3.0 | 2.2 | 41.2 | 5 | oui |
| 96 | wish_sanctum | procedural | looping+lattice+mixed | 4x3 | 13x11 | 5 | 1 | 8/12.4/18 | 15.2 | 5.2 | 4.0 | 2.0 | 39.6 | 5 | oui |
| 97 | wish_sanctum | procedural | looping+lattice+mixed | 4x5 | 12x8 | 5 | 1 | 4/7.6/12 | 10.4 | 2.8 | 2.0 | 1.6 | 36.0 | 5 | oui |
| 98 | wish_sanctum | procedural | looping+lattice+mixed | 5x5 | 9x10 | 5 | 0 | 11/14.2/20 | 23.0 | 7.4 | 2.2 | 4.8 | 40.2 | 5 | oui |
| 99 | wish_sanctum | procedural | looping+lattice+mixed | 5x3 | 9x9 | 5 | 0 | 5/11.8/24 | 16.0 | 5.4 | 2.2 | 2.8 | 36.6 | 5 | oui |
