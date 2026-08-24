# Rapport de génération — Mt. Thunder

- **ID** : `mt_thunder`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder (10F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunder) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder »).  
- **Étages** : 10 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder.json`  
- **Gate canonique** : configuration `validated`, runtime `missing`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_slope | 1-10 | thunder_slope | `mt_thunder_floor` | branching, lattice | 47 | non | non | — |

## Scènes fixes

- entrée : `mont_grondant_pied`
- midpoint : `—`
- Ground de fin : `d06p02`
- boss : mode `canonical_ground` → Ground `d06p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd06p02' (no separate arena created)
  - declared boss Ground 'd06p02' is not among the detected canonical end scenes ['d06p03']

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | thunder_slope | procedural | branching|lattice | 5x5 | 9x10 | 10 | 1 | 13/16.5/21 | 23.0 | 7.5 | 5.3 | 3.7 | 47.0 | 10 | oui |
| 2 | thunder_slope | procedural | branching|lattice | 5x5 | 9x10 | 10 | 1 | 10/15.7/22 | 20.6 | 6.4 | 5.2 | 2.7 | 44.5 | 10 | oui |
| 3 | thunder_slope | procedural | branching|lattice | 5x4 | 11x10 | 10 | 0 | 10/14.5/18 | 22.3 | 7.5 | 4.8 | 4.1 | 42.6 | 10 | oui |
| 4 | thunder_slope | procedural | branching|lattice | 5x5 | 10x8 | 10 | 1 | 9/15.6/21 | 21.6 | 7.7 | 5.2 | 3.4 | 40.9 | 10 | oui |
| 5 | thunder_slope | procedural | branching|lattice | 5x5 | 9x10 | 10 | 3 | 10/16.1/23 | 22.4 | 7.8 | 5.0 | 3.7 | 39.5 | 10 | oui |
| 6 | thunder_slope | procedural | branching|lattice | 6x5 | 9x10 | 10 | 3 | 11/15.9/24 | 22.5 | 7.5 | 5.2 | 3.6 | 50.6 | 10 | oui |
| 7 | thunder_slope | procedural | branching|lattice | 4x3 | 10x10 | 10 | 3 | 5/6.5/8 | 6.8 | 2.0 | 2.7 | 0.7 | 31.0 | 10 | oui |
| 8 | thunder_slope | procedural | branching|lattice | 5x5 | 10x9 | 10 | 0 | 11/14.7/24 | 20.0 | 6.5 | 5.0 | 3.0 | 43.6 | 10 | oui |
| 9 | thunder_slope | procedural | branching|lattice | 5x4 | 10x10 | 10 | 2 | 11/15.3/24 | 22.9 | 8.2 | 5.1 | 4.1 | 44.6 | 10 | oui |
| 10 | thunder_slope | procedural | branching|lattice | 6x5 | 12x9 | 10 | 0 | 11/14.9/20 | 21.2 | 6.9 | 5.7 | 3.2 | 44.2 | 10 | oui |
