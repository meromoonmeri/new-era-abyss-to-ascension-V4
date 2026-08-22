# Rapport de génération — Tiny Woods

- **ID** : `tiny_woods`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Tiny Woods (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/TinyWoods) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Tiny Woods »).  
- **Étages** : 3 — direction `fond`  
- **Zone écrite** : `Data/Zone/tiny_woods.json`  
- **Seed d'auteur (debug)** : `8855158366534059952` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| young_woods | 1-3 | young_woods | `tiny_meadow_floor` | branching, dense, mixed | 4 | oui | oui | — |

## Scènes fixes

- entrée : `foret_tendre_oree`
- midpoint : `—`
- Ground de fin : `d01p02`
- boss : mode `canonical_ground` → Ground `d01p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd01p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | young_woods | procedural | branching+dense+mixed | 5x4 | 13x8 | 5 | 0 | 7/14.0/24 | 16.8 | 3.4 | 3.4 | 1.2 | 37.4 | 5 | oui |
| 2 | young_woods | procedural | branching+dense+mixed | 8x5 | 7x6 | 5 | 1 | 12/15.4/23 | 16.8 | 5.0 | 5.4 | 1.4 | 41.2 | 5 | oui |
| 3 | young_woods | procedural | branching+dense+mixed | 7x4 | 9x6 | 5 | 1 | 11/16.0/25 | 17.4 | 4.8 | 4.2 | 1.6 | 39.4 | 5 | oui |
