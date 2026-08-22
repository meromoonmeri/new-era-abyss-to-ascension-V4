# Rapport de génération — Great Canyon

- **ID** : `great_canyon`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Great Canyon (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/GreatCanyon) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Great Canyon »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/great_canyon.json`  
- **Seed d'auteur (debug)** : `5735272182289411920` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| canyon_rim | 1-6 | canyon_rim | `mt_horn_floor` | twosides, branching, mixed | 9 | oui | oui | — |
| canyon_floor | 7-12 | canyon_floor | `mt_horn_floor` | branching, crossroads, mixed | 7 | oui | oui | — |

## Scènes fixes

- entrée : `grand_canyon_porte`
- midpoint : `—`
- Ground de fin : `d07p02`
- boss : mode `canonical_ground` → Ground `d07p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd07p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | canyon_rim | procedural | twosides+branching+mixed | 3x4 | 11x9 | 5 | 0 | 5/8.6/12 | 9.6 | 2.4 | 3.2 | 0.6 | 37.4 | 5 | oui |
| 2 | canyon_rim | procedural | twosides+branching+mixed | 4x4 | 10x8 | 5 | 0 | 6/8.4/10 | 9.8 | 2.0 | 2.0 | 1.0 | 31.8 | 5 | oui |
| 3 | canyon_rim | procedural | twosides+branching+mixed | 4x4 | 11x9 | 5 | 2 | 8/10.6/14 | 11.0 | 2.8 | 3.4 | 1.0 | 33.8 | 5 | oui |
| 4 | canyon_rim | procedural | twosides+branching+mixed | 3x4 | 11x10 | 5 | 1 | 8/11.0/14 | 12.2 | 2.8 | 3.4 | 1.0 | 36.8 | 5 | oui |
| 5 | canyon_rim | procedural | twosides+branching+mixed | 5x3 | 14x8 | 5 | 2 | 7/12.6/21 | 15.0 | 3.8 | 3.6 | 1.2 | 40.4 | 5 | oui |
| 6 | canyon_rim | procedural | twosides+branching+mixed | 3x3 | 10x11 | 5 | 0 | 6/12.0/24 | 14.6 | 3.6 | 3.0 | 1.6 | 38.2 | 5 | oui |
| 7 | canyon_floor | procedural | branching+crossroads+mixed | 6x5 | 11x7 | 5 | 0 | 7/11.8/17 | 11.6 | 3.0 | 4.4 | 0.8 | 47.8 | 5 | oui |
| 8 | canyon_floor | procedural | branching+crossroads+mixed | 4x3 | 9x9 | 5 | 1 | 8/11.4/17 | 12.6 | 3.8 | 3.4 | 1.4 | 35.4 | 5 | oui |
| 9 | canyon_floor | procedural | branching+crossroads+mixed | 7x3 | 10x9 | 5 | 0 | 8/12.0/17 | 12.2 | 3.0 | 4.2 | 0.6 | 41.6 | 5 | oui |
| 10 | canyon_floor | procedural | branching+crossroads+mixed | 6x3 | 11x9 | 5 | 0 | 7/9.6/13 | 9.2 | 2.2 | 3.6 | 0.6 | 39.6 | 5 | oui |
| 11 | canyon_floor | procedural | branching+crossroads+mixed | 5x4 | 12x8 | 5 | 0 | 9/12.6/16 | 12.4 | 3.2 | 5.2 | 0.6 | 38.8 | 5 | oui |
| 12 | canyon_floor | procedural | branching+crossroads+mixed | 5x3 | 10x10 | 5 | 2 | 7/11.6/18 | 11.2 | 3.2 | 5.0 | 0.6 | 42.0 | 5 | oui |
