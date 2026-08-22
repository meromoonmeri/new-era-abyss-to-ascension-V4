# Rapport de génération — Lapis Cave

- **ID** : `lapis_cave`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Lapis Cave (14F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/LapisCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Lapis Cave »).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/lapis_cave.json`  
- **Seed d'auteur (debug)** : `750928680325748604` (explicite : False)  

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
| 1 | lapis_gallery | procedural | branching+mixed+dense | 4x3 | 11x8 | 5 | 1 | 13/15.4/22 | 16.0 | 5.0 | 5.2 | 1.2 | 30.8 | 5 | oui |
| 2 | lapis_gallery | procedural | branching+mixed+dense | 5x3 | 11x10 | 5 | 0 | 8/13.6/23 | 14.8 | 4.0 | 3.4 | 1.4 | 42.6 | 5 | oui |
| 3 | lapis_gallery | procedural | branching+mixed+dense | 5x3 | 12x7 | 5 | 0 | 8/13.6/21 | 14.0 | 3.6 | 4.8 | 0.8 | 33.8 | 5 | oui |
| 4 | lapis_gallery | procedural | branching+mixed+dense | 6x3 | 9x9 | 5 | 0 | 10/13.8/17 | 16.8 | 5.4 | 4.2 | 2.2 | 49.6 | 5 | oui |
| 5 | lapis_gallery | procedural | branching+mixed+dense | 4x3 | 10x8 | 5 | 0 | 7/16.0/33 | 18.2 | 5.2 | 4.6 | 2.0 | 40.2 | 5 | oui |
| 6 | lapis_gallery | procedural | branching+mixed+dense | 6x5 | 9x8 | 5 | 1 | 9/11.0/14 | 11.8 | 3.2 | 3.4 | 1.0 | 48.4 | 5 | oui |
| 7 | lapis_gallery | procedural | branching+mixed+dense | 7x5 | 11x11 | 5 | 1 | 6/9.2/13 | 9.4 | 2.6 | 3.0 | 0.8 | 31.2 | 5 | oui |
| 8 | lapis_depths | procedural | looping+lattice+mixed | 4x4 | 12x10 | 5 | 0 | 9/12.4/18 | 21.0 | 7.4 | 2.2 | 4.6 | 43.8 | 5 | oui |
| 9 | lapis_depths | procedural | looping+lattice+mixed | 6x3 | 12x9 | 5 | 0 | 9/10.2/12 | 15.6 | 5.0 | 2.2 | 3.0 | 36.0 | 5 | oui |
| 10 | lapis_depths | procedural | looping+lattice+mixed | 4x4 | 11x10 | 5 | 0 | 7/9.0/14 | 13.2 | 3.8 | 2.0 | 2.6 | 29.8 | 5 | oui |
| 11 | lapis_depths | procedural | looping+lattice+mixed | 6x5 | 14x10 | 5 | 2 | 5/10.0/13 | 11.4 | 2.6 | 2.6 | 1.0 | 32.2 | 5 | oui |
| 12 | lapis_depths | procedural | looping+lattice+mixed | 4x3 | 9x10 | 5 | 1 | 8/9.6/12 | 11.6 | 3.4 | 2.2 | 1.8 | 39.2 | 5 | oui |
| 13 | lapis_depths | procedural | looping+lattice+mixed | 6x4 | 10x8 | 5 | 0 | 11/14.4/24 | 22.8 | 7.0 | 3.8 | 4.2 | 42.2 | 5 | oui |
| 14 | lapis_depths | procedural | looping+lattice+mixed | 6x3 | 13x7 | 5 | 2 | 9/14.0/23 | 18.4 | 5.2 | 2.2 | 3.0 | 39.8 | 5 | oui |
