# Rapport de génération — Sinister Woods

- **ID** : `gloomy_forest`  
- **Chapitre** : 6 (main)  
- **Source canonique** : Pokémon Mystery Dungeon: Rescue Team (Red/Blue Rescue Team & Rescue Team DX) — Sinister Woods, B1F-B12F. Species/items adapted to PMDO spawn tables and rescaled to New Era chapter 6 (30 years later).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/gloomy_forest.json`  
- **Seed d'auteur (debug)** : `4979729452555454513` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| Lisière hantée | 1-5 | forest_edge | `sinister_woods_b41` | branching, dense, mixed, crossroads | 9 | oui | oui | fog, light_rain |
| Bois profonds | 6-10 | deep_forest | `sinister_woods_b41` | looping, branching, large_rooms, mixed, ring | 9 | oui | oui | fog, light_rain |
| Clairière du Filou | 11-14 | forest_clearing | `sinister_woods_b41` | mixed, large_rooms, looping, branching | 9 | oui | oui | fog, light_rain |

## Scènes fixes

- entrée : `—`
- midpoint : `gloomy_forest_midpoint`
- Ground de fin : `sinister_woods_clearing`
- boss : mode `canonical_ground` → Ground `sinister_woods_clearing`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - final battle stays on the canonical end Ground 'sinister_woods_clearing' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 4x5 | 10x11 | 10 | 1 | 7/14.3/26 | 16.2 | 4.2 | 3.9 | 1.4 | 43.7 | 10 | oui |
| 2 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x4 | 10x9 | 10 | 1 | 8/14.9/25 | 17.6 | 4.9 | 4.3 | 1.9 | 42.5 | 10 | oui |
| 3 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x4 | 9x11 | 10 | 1 | 8/13.3/21 | 15.3 | 4.1 | 3.8 | 1.6 | 42.6 | 10 | oui |
| 4 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x3 | 12x10 | 10 | 2 | 7/15.4/26 | 18.9 | 5.9 | 3.8 | 2.3 | 40.8 | 10 | oui |
| 5 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x4 | 12x8 | 10 | 0 | 8/14.9/27 | 17.5 | 5.2 | 4.8 | 1.7 | 35.6 | 10 | oui |
| 6 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x4 | 8x9 | 10 | 1 | 4/9.2/19 | 11.8 | 3.0 | 2.4 | 1.4 | 32.6 | 10 | oui |
| 7 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 5x4 | 11x9 | 10 | 2 | 6/10.6/17 | 13.8 | 3.5 | 1.8 | 2.1 | 43.2 | 10 | oui |
| 8 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x4 | 11x8 | 10 | 0 | 5/10.6/19 | 12.9 | 3.3 | 2.9 | 1.4 | 39.4 | 10 | oui |
| 9 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 5x4 | 11x10 | 10 | 1 | 4/9.6/14 | 12.8 | 2.8 | 1.7 | 1.6 | 35.7 | 10 | oui |
| 10 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x3 | 10x10 | 10 | 0 | 4/10.6/20 | 14.3 | 4.1 | 2.1 | 2.3 | 40.8 | 10 | oui |
| 11 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 6x3 | 10x8 | 10 | 0 | 4/11.5/17 | 12.8 | 3.6 | 3.1 | 1.4 | 38.3 | 10 | oui |
| 12 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 3x2 | 12x10 | 10 | 0 | 4/10.6/16 | 11.9 | 2.9 | 2.6 | 1.3 | 39.7 | 10 | oui |
| 13 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 6x3 | 9x10 | 10 | 0 | 5/11.8/24 | 13.0 | 3.3 | 2.9 | 1.3 | 40.5 | 10 | oui |
| 14 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x4 | 10x9 | 10 | 0 | 5/11.5/21 | 12.4 | 3.4 | 3.0 | 1.5 | 37.2 | 10 | oui |
