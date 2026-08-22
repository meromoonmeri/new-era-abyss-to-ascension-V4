# Rapport de génération — Frosty Forest

- **ID** : `frosty_forest`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Frosty Forest (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/FrostyForest) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Frosty Forest »).  
- **Étages** : 9 — direction `sommet`  
- **Zone écrite** : `Data/Zone/frosty_forest.json`  
- **Seed d'auteur (debug)** : `3595495509213498325` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| frosty_edge | 1-9 | frosty_edge | `frosty_forest_floor` | branching, dense, mixed | 8 | oui | oui | — |

## Scènes fixes

- entrée : `foret_givree_oree`
- midpoint : `frosty_forest_midpoint`
- Ground de fin : `d10p03`
- boss : mode `canonical_ground` → Ground `d10p03`, rsmap `—`
  - final battle stays on the canonical end Ground 'd10p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | frosty_edge | procedural | branching+dense+mixed | 7x4 | 8x8 | 5 | 3 | 7/13.2/23 | 14.4 | 3.8 | 3.2 | 1.4 | 40.4 | 5 | oui |
| 2 | frosty_edge | procedural | branching+dense+mixed | 4x3 | 10x10 | 5 | 1 | 16/22.0/27 | 25.6 | 6.6 | 6.4 | 2.2 | 45.2 | 5 | oui |
| 3 | frosty_edge | procedural | branching+dense+mixed | 7x4 | 9x7 | 5 | 1 | 9/14.8/21 | 17.6 | 5.6 | 3.8 | 2.4 | 35.4 | 5 | oui |
| 4 | frosty_edge | procedural | branching+dense+mixed | 6x4 | 10x10 | 5 | 0 | 6/21.0/31 | 26.0 | 8.4 | 4.0 | 3.8 | 44.8 | 5 | oui |
| 5 | frosty_edge | procedural | branching+dense+mixed | 4x5 | 12x12 | 5 | 1 | 7/13.8/29 | 15.6 | 4.2 | 5.0 | 0.8 | 44.4 | 5 | oui |
| 6 | frosty_edge | procedural | branching+dense+mixed | 8x5 | 9x6 | 5 | 0 | 8/18.0/30 | 21.0 | 5.6 | 4.6 | 2.4 | 44.2 | 5 | oui |
| 7 | frosty_edge | procedural | branching+dense+mixed | 5x3 | 12x10 | 5 | 0 | 7/14.8/24 | 18.4 | 5.4 | 3.6 | 2.2 | 38.4 | 5 | oui |
| 8 | frosty_edge | procedural | branching+dense+mixed | 7x5 | 10x12 | 5 | 0 | 7/17.0/23 | 21.0 | 6.0 | 3.8 | 2.6 | 46.6 | 5 | oui |
| 9 | frosty_edge | procedural | branching+dense+mixed | 7x5 | 8x8 | 5 | 0 | 10/16.4/26 | 20.4 | 6.6 | 4.6 | 2.6 | 51.6 | 5 | oui |
