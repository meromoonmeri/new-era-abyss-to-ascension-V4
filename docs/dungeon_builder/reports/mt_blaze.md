# Rapport de génération — Mt. Blaze

- **ID** : `mt_blaze`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlaze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| blaze_slope | 1-12 | blaze_slope | `mt_blaze_floor` | branching, lattice, looping | 42 | non | non | — |

## Scènes fixes

- entrée : `mont_cendre_pied`
- midpoint : `—`
- Ground de fin : `d09p02`
- boss : mode `canonical_ground` → Ground `d09p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd09p02' (no separate arena created)
  - declared boss Ground 'd09p02' is not among the detected canonical end scenes ['d09p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 12x8 | 10 | 0 | 12/15.8/22 | 22.1 | 6.7 | 5.2 | 2.6 | 46.7 | 10 | oui |
| 2 | blaze_slope | procedural | branching|lattice|looping | 6x4 | 11x10 | 10 | 2 | 9/14.0/19 | 24.5 | 7.4 | 4.1 | 4.0 | 54.9 | 10 | oui |
| 3 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 12x10 | 10 | 3 | 10/14.8/29 | 21.3 | 7.2 | 4.3 | 3.5 | 46.4 | 10 | oui |
| 4 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 12x9 | 10 | 0 | 12/15.3/24 | 25.1 | 7.1 | 3.2 | 4.0 | 47.3 | 10 | oui |
| 5 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 9x8 | 10 | 1 | 11/14.6/22 | 21.9 | 6.5 | 4.5 | 2.9 | 44.8 | 10 | oui |
| 6 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 9x9 | 10 | 0 | 12/16.9/29 | 25.4 | 7.9 | 4.7 | 3.9 | 44.7 | 10 | oui |
| 7 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 10x10 | 10 | 0 | 11/15.8/28 | 22.9 | 6.0 | 4.1 | 2.9 | 42.6 | 10 | oui |
| 8 | blaze_slope | procedural | branching|lattice|looping | 6x4 | 10x9 | 10 | 2 | 9/13.7/22 | 23.1 | 6.6 | 3.2 | 3.8 | 45.3 | 10 | oui |
| 9 | blaze_slope | procedural | branching|lattice|looping | 7x4 | 9x8 | 10 | 0 | 11/16.4/24 | 22.8 | 6.3 | 5.1 | 2.4 | 46.2 | 10 | oui |
| 10 | blaze_slope | procedural | branching|lattice|looping | 5x5 | 10x10 | 10 | 1 | 12/16.3/22 | 24.1 | 8.0 | 5.2 | 3.6 | 47.7 | 10 | oui |
| 11 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 12x9 | 10 | 0 | 11/17.3/29 | 25.3 | 8.1 | 5.2 | 3.6 | 48.3 | 10 | oui |
| 12 | blaze_slope | procedural | branching|lattice|looping | 7x5 | 10x10 | 10 | 0 | 11/15.9/25 | 23.7 | 6.9 | 4.3 | 3.3 | 53.0 | 10 | oui |
