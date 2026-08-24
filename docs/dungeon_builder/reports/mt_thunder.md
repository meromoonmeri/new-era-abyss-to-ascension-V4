# Rapport de génération — Mt. Thunder

- **ID** : `mt_thunder`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder (10F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunder) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder »).  
- **Étages** : 10 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_slope | 1-10 | thunder_slope | `mt_thunder_floor` | branching, lattice | 47 | non | non | — |

## Scènes fixes

- entrée : `mont_grondant_pied`
- midpoint : `—`
- Ground de fin : `d06p02`
- boss : mode `` → Ground `—`, rsmap `—`
  - no fixed 'mid' Ground declared
  - no boss scene declared

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | thunder_slope | procedural | branching|lattice | 5x5 | 11x10 | 10 | 0 | 10/15.2/24 | 22.4 | 7.7 | 4.7 | 4.0 | 44.5 | 10 | oui |
| 2 | thunder_slope | procedural | branching|lattice | 5x5 | 11x8 | 10 | 2 | 10/14.5/21 | 22.3 | 7.9 | 4.9 | 4.3 | 43.8 | 10 | oui |
| 3 | thunder_slope | procedural | branching|lattice | 6x4 | 9x10 | 10 | 1 | 11/15.2/22 | 23.9 | 8.4 | 5.3 | 4.5 | 51.4 | 10 | oui |
| 4 | thunder_slope | procedural | branching|lattice | 5x5 | 12x10 | 10 | 4 | 11/16.5/22 | 24.5 | 8.3 | 5.3 | 4.4 | 42.1 | 10 | oui |
| 5 | thunder_slope | procedural | branching|lattice | 5x5 | 10x9 | 10 | 2 | 10/16.0/26 | 22.8 | 8.2 | 5.8 | 3.6 | 48.9 | 10 | oui |
| 6 | thunder_slope | procedural | branching|lattice | 5x4 | 12x10 | 10 | 0 | 10/14.8/20 | 22.3 | 8.0 | 5.0 | 4.2 | 46.1 | 10 | oui |
| 7 | thunder_slope | procedural | branching|lattice | 4x3 | 12x10 | 10 | 0 | 5/6.9/10 | 7.7 | 2.3 | 2.6 | 0.9 | 37.3 | 10 | oui |
| 8 | thunder_slope | procedural | branching|lattice | 6x4 | 10x9 | 10 | 5 | 13/18.4/25 | 25.7 | 8.1 | 6.0 | 3.8 | 48.1 | 10 | oui |
| 9 | thunder_slope | procedural | branching|lattice | 6x5 | 9x10 | 10 | 0 | 9/15.2/23 | 23.2 | 8.3 | 4.8 | 4.4 | 50.4 | 10 | oui |
| 10 | thunder_slope | procedural | branching|lattice | 5x5 | 9x9 | 10 | 1 | 12/15.7/22 | 21.7 | 7.4 | 5.1 | 3.6 | 42.0 | 10 | oui |
