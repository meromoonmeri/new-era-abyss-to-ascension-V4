# Rapport de génération — Thunderwave Cave

- **ID** : `thunderwave_cave`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Thunderwave Cave (5F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/ThunderwaveCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Thunderwave Cave »).  
- **Étages** : 5 — direction `fond`  
- **Zone écrite** : `Data/Zone/thunderwave_cave.json`  
- **Seed d'auteur (debug)** : `2986267779560758377` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| static_cave | 1-5 | static_cave | `crystal_cave_2_floor` | branching, mixed, dense | 7 | oui | oui | — |

## Scènes fixes

- entrée : `grotte_statique_seuil`
- midpoint : `—`
- Ground de fin : `d02p02`
- boss : mode `canonical_ground` → Ground `d02p02`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd02p02' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | static_cave | procedural | branching+mixed+dense | 6x4 | 11x10 | 5 | 0 | 10/15.2/24 | 17.6 | 4.2 | 4.0 | 1.8 | 42.4 | 5 | oui |
| 2 | static_cave | procedural | branching+mixed+dense | 6x5 | 8x7 | 5 | 0 | 15/17.4/22 | 19.4 | 6.4 | 5.8 | 1.8 | 44.2 | 5 | oui |
| 3 | static_cave | procedural | branching+mixed+dense | 4x4 | 11x10 | 5 | 0 | 12/17.4/28 | 21.2 | 6.8 | 4.8 | 2.4 | 45.0 | 5 | oui |
| 4 | static_cave | procedural | branching+mixed+dense | 7x5 | 8x8 | 5 | 0 | 14/16.4/20 | 19.0 | 5.2 | 4.2 | 2.0 | 50.0 | 5 | oui |
| 5 | static_cave | procedural | branching+mixed+dense | 5x3 | 9x10 | 5 | 1 | 10/14.2/20 | 17.0 | 5.4 | 4.8 | 1.8 | 31.2 | 5 | oui |
