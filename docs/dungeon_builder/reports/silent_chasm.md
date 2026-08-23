# Rapport de génération — Silent Chasm

- **ID** : `silent_chasm`  
- **Chapitre** : 8 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Silent Chasm (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SilentChasm) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 8. Recoupé avec Bulbapedia (page « Silent Chasm »).  
- **Étages** : 9 — direction `fond`  
- **Zone écrite** : `Data/Zone/silent_chasm.json`  
- **Seed d'auteur (debug)** : `2805985487033810242` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| silent_rim | 1-9 | silent_rim | `silent_chasm_floor` | branching, mixed, dense | 12 | oui | oui | — |

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
| 1 | silent_rim | procedural | branching+mixed+dense | 5x5 | 13x8 | 10 | 2 | 8/14.0/26 | 15.8 | 4.6 | 4.6 | 1.4 | 35.0 | 10 | oui |
| 2 | silent_rim | procedural | branching+mixed+dense | 4x5 | 9x11 | 10 | 0 | 8/17.5/33 | 20.3 | 5.4 | 5.0 | 1.6 | 33.2 | 10 | oui |
| 3 | silent_rim | procedural | branching+mixed+dense | 4x3 | 12x11 | 10 | 2 | 8/12.0/16 | 12.9 | 3.5 | 3.7 | 1.2 | 35.0 | 10 | oui |
| 4 | silent_rim | procedural | branching+mixed+dense | 8x5 | 9x6 | 10 | 1 | 7/12.6/24 | 14.2 | 4.4 | 4.3 | 1.3 | 33.1 | 10 | oui |
| 5 | silent_rim | procedural | branching+mixed+dense | 5x4 | 11x7 | 10 | 0 | 6/15.6/23 | 18.3 | 5.6 | 5.0 | 1.6 | 42.9 | 10 | oui |
| 6 | silent_rim | procedural | branching+mixed+dense | 4x4 | 12x9 | 10 | 0 | 8/14.9/30 | 18.1 | 4.9 | 3.9 | 2.0 | 48.9 | 10 | oui |
| 7 | silent_rim | procedural | branching+mixed+dense | 7x5 | 7x8 | 10 | 1 | 8/16.9/29 | 19.3 | 5.4 | 5.1 | 1.8 | 43.3 | 10 | oui |
| 8 | silent_rim | procedural | branching+mixed+dense | 6x4 | 10x9 | 10 | 0 | 6/14.4/22 | 17.8 | 4.9 | 4.0 | 2.0 | 39.5 | 10 | oui |
| 9 | silent_rim | procedural | branching+mixed+dense | 7x5 | 7x8 | 10 | 2 | 7/15.9/27 | 18.0 | 4.9 | 4.2 | 1.6 | 39.0 | 10 | oui |
