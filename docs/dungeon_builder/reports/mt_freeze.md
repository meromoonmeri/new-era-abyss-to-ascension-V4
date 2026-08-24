# Rapport de génération — Mt. Freeze

- **ID** : `mt_freeze`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreeze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Mt. Freeze »).  
- **Étages** : 15 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| freeze_slope | 1-15 | freeze_slope | `mt_freeze_floor` | branching, lattice, looping | 49 | non | non | — |

## Scènes fixes

- entrée : `mont_gele_pied`
- midpoint : `—`
- Ground de fin : `d11p02`
- boss : mode `canonical_ground` → Ground `d11p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd11p02' (no separate arena created)
  - declared boss Ground 'd11p02' is not among the detected canonical end scenes ['d11p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | freeze_slope | procedural | branching|lattice|looping | 5x5 | 12x9 | 10 | 0 | 12/16.6/21 | 26.9 | 8.5 | 4.7 | 4.6 | 50.9 | 10 | oui |
| 2 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 10x10 | 10 | 1 | 10/14.3/19 | 22.7 | 5.7 | 3.1 | 3.1 | 42.4 | 10 | oui |
| 3 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 10x10 | 10 | 0 | 9/16.4/28 | 25.7 | 7.8 | 4.5 | 4.1 | 45.2 | 10 | oui |
| 4 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 9x10 | 10 | 3 | 10/15.8/28 | 24.5 | 6.9 | 4.6 | 3.4 | 48.6 | 10 | oui |
| 5 | freeze_slope | procedural | branching|lattice|looping | 7x5 | 12x8 | 10 | 0 | 12/16.8/25 | 25.5 | 7.7 | 4.5 | 3.7 | 50.9 | 10 | oui |
| 6 | freeze_slope | procedural | branching|lattice|looping | 6x4 | 10x10 | 10 | 1 | 10/14.5/26 | 22.8 | 6.0 | 3.2 | 3.4 | 41.1 | 10 | oui |
| 7 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 10x8 | 10 | 5 | 12/15.2/22 | 25.4 | 8.1 | 4.2 | 4.7 | 41.0 | 10 | oui |
| 8 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 11x8 | 10 | 2 | 12/15.7/22 | 25.9 | 7.9 | 3.4 | 4.5 | 49.4 | 10 | oui |
| 9 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 12x10 | 10 | 0 | 10/15.3/21 | 23.8 | 7.4 | 4.6 | 3.6 | 43.6 | 10 | oui |
| 10 | freeze_slope | procedural | branching|lattice|looping | 6x4 | 11x10 | 10 | 0 | 11/16.7/29 | 25.0 | 6.8 | 3.7 | 4.0 | 44.9 | 10 | oui |
| 11 | freeze_slope | procedural | branching|lattice|looping | 6x5 | 11x10 | 10 | 0 | 10/16.6/24 | 25.6 | 7.8 | 4.7 | 4.0 | 49.1 | 10 | oui |
| 12 | freeze_slope | procedural | branching|lattice|looping | 6x4 | 9x8 | 10 | 1 | 11/15.3/28 | 22.9 | 5.7 | 4.2 | 2.7 | 50.0 | 10 | oui |
| 13 | freeze_slope | procedural | branching|lattice|looping | 6x4 | 12x10 | 10 | 1 | 11/17.6/25 | 25.5 | 7.4 | 5.1 | 3.6 | 50.2 | 10 | oui |
| 14 | freeze_slope | procedural | branching|lattice|looping | 5x4 | 10x8 | 10 | 0 | 10/17.4/26 | 25.4 | 6.9 | 4.1 | 3.5 | 42.2 | 10 | oui |
| 15 | freeze_slope | procedural | branching|lattice|looping | 7x5 | 10x10 | 10 | 2 | 11/16.3/23 | 25.9 | 8.3 | 4.4 | 4.2 | 43.7 | 10 | oui |
