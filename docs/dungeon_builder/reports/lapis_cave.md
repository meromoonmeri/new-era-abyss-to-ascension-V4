# Rapport de génération — Lapis Cave

- **ID** : `lapis_cave`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Lapis Cave (14F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/LapisCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Lapis Cave »).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/lapis_cave.json`  
- **Seed d'auteur (debug)** : `7037740570189890998` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| lapis_gallery | 1-7 | lapis_gallery | `lapis_cave_floor` | branching, mixed, dense | 5 | oui | oui | — |
| lapis_depths | 8-14 | lapis_depths | `lapis_cave_floor` | looping, lattice, mixed | 6 | oui | oui | — |

## Scènes fixes

- entrée : `grotte_lazuli_seuil`
- midpoint : `—`
- Ground de fin : `grotte_lazuli_fond`
- boss : mode `canonical_ground` → Ground `grotte_lazuli_fond`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'grotte_lazuli_fond' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | lapis_gallery | procedural | branching+mixed+dense | 8x5 | 9x7 | 5 | 0 | 13/17.2/26 | 18.6 | 5.4 | 6.0 | 1.2 | 41.8 | 5 | oui |
| 2 | lapis_gallery | procedural | branching+mixed+dense | 4x4 | 12x8 | 5 | 2 | 10/11.4/13 | 11.8 | 3.2 | 4.2 | 0.8 | 37.8 | 5 | oui |
| 3 | lapis_gallery | procedural | branching+mixed+dense | 4x3 | 14x11 | 5 | 1 | 10/16.0/28 | 16.4 | 4.8 | 5.2 | 1.0 | 36.8 | 5 | oui |
| 4 | lapis_gallery | procedural | branching+mixed+dense | 6x4 | 12x10 | 5 | 0 | 11/14.0/19 | 16.0 | 4.6 | 4.0 | 1.8 | 41.2 | 5 | oui |
| 5 | lapis_gallery | procedural | branching+mixed+dense | 4x3 | 12x8 | 5 | 0 | 10/15.8/30 | 17.8 | 5.6 | 4.8 | 1.6 | 49.0 | 5 | oui |
| 6 | lapis_gallery | procedural | branching+mixed+dense | 7x5 | 9x6 | 5 | 1 | 9/19.0/29 | 22.2 | 6.4 | 5.0 | 2.4 | 40.2 | 5 | oui |
| 7 | lapis_gallery | procedural | branching+mixed+dense | 5x4 | 11x8 | 5 | 0 | 8/15.4/29 | 17.4 | 5.0 | 4.4 | 1.6 | 50.6 | 5 | oui |
| 8 | lapis_depths | procedural | looping+lattice+mixed | 4x5 | 10x10 | 5 | 0 | 8/10.0/13 | 15.8 | 4.8 | 2.6 | 3.0 | 40.0 | 5 | oui |
| 9 | lapis_depths | procedural | looping+lattice+mixed | 5x4 | 9x10 | 5 | 0 | 6/11.4/20 | 16.0 | 4.4 | 2.4 | 2.4 | 39.2 | 5 | oui |
| 10 | lapis_depths | procedural | looping+lattice+mixed | 5x4 | 12x9 | 5 | 0 | 7/11.8/20 | 18.0 | 5.8 | 3.0 | 3.4 | 50.0 | 5 | oui |
| 11 | lapis_depths | procedural | looping+lattice+mixed | 4x4 | 12x10 | 5 | 0 | 9/11.6/16 | 18.2 | 5.8 | 4.0 | 3.0 | 50.2 | 5 | oui |
| 12 | lapis_depths | procedural | looping+lattice+mixed | 5x4 | 9x9 | 5 | 2 | 8/11.8/20 | 15.2 | 5.2 | 4.2 | 2.2 | 41.4 | 5 | oui |
| 13 | lapis_depths | procedural | looping+lattice+mixed | 7x4 | 13x9 | 5 | 0 | 8/11.0/17 | 18.4 | 6.4 | 2.0 | 4.2 | 44.4 | 5 | oui |
| 14 | lapis_depths | procedural | looping+lattice+mixed | 7x3 | 11x11 | 5 | 1 | 7/13.6/21 | 18.0 | 6.0 | 2.8 | 3.0 | 43.4 | 5 | oui |
