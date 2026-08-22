# Rapport de génération — Silent Chasm

- **ID** : `silent_chasm`  
- **Chapitre** : 8 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Silent Chasm (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SilentChasm) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 8. Recoupé avec Bulbapedia (page « Silent Chasm »).  
- **Étages** : 9 — direction `fond`  
- **Zone écrite** : `Data/Zone/silent_chasm.json`  
- **Seed d'auteur (debug)** : `7459549769193220355` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| silent_rim | 1-9 | silent_rim | `chasm_cave_floor` | branching, mixed, dense | 12 | oui | oui | — |

## Scènes fixes

- entrée : `gouffre_muet_bord`
- midpoint : `—`
- Ground de fin : `d05p02`
- boss : mode `canonical_ground` → Ground `d05p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd05p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | silent_rim | procedural | branching+mixed+dense | 5x3 | 11x10 | 5 | 0 | 11/13.8/19 | 15.2 | 4.0 | 4.6 | 1.0 | 37.4 | 5 | oui |
| 2 | silent_rim | procedural | branching+mixed+dense | 6x3 | 10x9 | 5 | 1 | 8/13.6/17 | 14.2 | 4.4 | 4.4 | 1.2 | 42.6 | 5 | oui |
| 3 | silent_rim | procedural | branching+mixed+dense | 5x3 | 11x10 | 5 | 0 | 7/14.8/24 | 16.6 | 3.6 | 4.0 | 1.4 | 54.6 | 5 | oui |
| 4 | silent_rim | procedural | branching+mixed+dense | 6x4 | 10x10 | 5 | 0 | 8/14.6/25 | 16.8 | 4.6 | 4.6 | 1.6 | 43.8 | 5 | oui |
| 5 | silent_rim | procedural | branching+mixed+dense | 7x3 | 14x10 | 5 | 0 | 8/15.0/22 | 16.6 | 4.8 | 5.4 | 1.4 | 41.2 | 5 | oui |
| 6 | silent_rim | procedural | branching+mixed+dense | 6x3 | 11x8 | 5 | 0 | 9/16.6/24 | 19.6 | 6.0 | 4.0 | 2.4 | 47.0 | 5 | oui |
| 7 | silent_rim | procedural | branching+mixed+dense | 4x3 | 12x8 | 5 | 0 | 10/14.0/22 | 17.0 | 4.8 | 3.2 | 2.4 | 39.4 | 5 | oui |
| 8 | silent_rim | procedural | branching+mixed+dense | 6x4 | 12x10 | 5 | 0 | 8/16.0/28 | 18.6 | 5.8 | 5.0 | 2.0 | 43.0 | 5 | oui |
| 9 | silent_rim | procedural | branching+mixed+dense | 8x4 | 8x7 | 5 | 1 | 7/11.4/17 | 12.4 | 3.4 | 3.8 | 1.2 | 37.6 | 5 | oui |
