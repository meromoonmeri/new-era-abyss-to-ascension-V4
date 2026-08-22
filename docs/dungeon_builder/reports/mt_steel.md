# Rapport de génération — Mt. Steel

- **ID** : `mt_steel`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Steel (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtSteel) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Mt. Steel »).  
- **Étages** : 9 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_steel.json`  
- **Seed d'auteur (debug)** : `3875972985926429040` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| steel_slope | 1-9 | steel_slope | `steel_aegis_cave_floor` | twosides, branching, mixed | 9 | oui | oui | — |

## Scènes fixes

- entrée : `pic_ferreux_pied`
- midpoint : `—`
- Ground de fin : `d03p02`
- boss : mode `canonical_ground` → Ground `d03p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd03p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | steel_slope | procedural | twosides+branching+mixed | 3x4 | 12x10 | 5 | 1 | 7/9.2/12 | 9.4 | 2.4 | 4.4 | 0.4 | 43.2 | 5 | oui |
| 2 | steel_slope | procedural | twosides+branching+mixed | 7x5 | 14x11 | 5 | 1 | 6/10.4/13 | 11.4 | 2.6 | 3.2 | 1.0 | 34.6 | 5 | oui |
| 3 | steel_slope | procedural | twosides+branching+mixed | 3x3 | 11x8 | 5 | 0 | 6/8.4/12 | 9.6 | 1.8 | 2.6 | 0.6 | 37.6 | 5 | oui |
| 4 | steel_slope | procedural | twosides+branching+mixed | 5x4 | 13x8 | 5 | 1 | 8/12.2/21 | 13.8 | 3.2 | 3.4 | 1.2 | 37.4 | 5 | oui |
| 5 | steel_slope | procedural | twosides+branching+mixed | 3x4 | 12x8 | 5 | 2 | 6/10.6/16 | 11.4 | 2.6 | 4.2 | 0.4 | 39.8 | 5 | oui |
| 6 | steel_slope | procedural | twosides+branching+mixed | 3x3 | 11x9 | 5 | 1 | 8/9.0/11 | 9.6 | 2.2 | 3.2 | 0.6 | 38.4 | 5 | oui |
| 7 | steel_slope | procedural | twosides+branching+mixed | 3x4 | 11x9 | 5 | 0 | 6/10.4/18 | 11.6 | 2.6 | 3.4 | 0.8 | 40.4 | 5 | oui |
| 8 | steel_slope | procedural | twosides+branching+mixed | 4x3 | 9x10 | 5 | 0 | 6/11.6/23 | 14.6 | 3.6 | 2.0 | 2.0 | 39.0 | 5 | oui |
| 9 | steel_slope | procedural | twosides+branching+mixed | 6x4 | 12x9 | 5 | 0 | 6/11.4/17 | 13.4 | 2.8 | 3.8 | 1.2 | 37.8 | 5 | oui |
