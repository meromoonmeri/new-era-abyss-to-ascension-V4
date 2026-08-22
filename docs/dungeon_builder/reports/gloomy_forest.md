# Rapport de génération — Sinister Woods

- **ID** : `gloomy_forest`  
- **Chapitre** : 6 (main)  
- **Source canonique** : Pokémon Mystery Dungeon: Rescue Team (Red/Blue Rescue Team & Rescue Team DX) — Sinister Woods, B1F-B12F. Species/items adapted to PMDO spawn tables and rescaled to New Era chapter 6 (30 years later).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/gloomy_forest.json`  
- **Seed d'auteur (debug)** : `3764975691060337015` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| Lisière hantée | 1-5 | forest_edge | `sinister_woods_b41` | branching, dense, mixed, crossroads | 9 | oui | oui | fog, light_rain |
| Bois profonds | 6-10 | deep_forest | `sinister_woods_b41` | looping, branching, large_rooms, mixed, ring | 9 | oui | oui | fog, light_rain |
| Clairière du Filou | 11-14 | forest_clearing | `sinister_woods_b41` | mixed, large_rooms, looping, branching | 9 | oui | oui | fog, light_rain |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `sinister_woods_clearing`
- boss : mode `canonical_ground` → Ground `sinister_woods_clearing`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - midpoint Ground still to be produced: template 'searing_tunnel_midpoint' retextured with 'sinister_woods_b41' (floor 8) — never generated procedurally
  - final battle stays on the canonical end Ground 'sinister_woods_clearing' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x4 | 9x10 | 10 | 1 | 7/16.5/29 | 19.0 | 5.8 | 5.1 | 2.2 | 46.7 | 10 | oui |
| 2 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 7x4 | 10x7 | 10 | 1 | 7/14.6/29 | 15.9 | 4.4 | 4.7 | 1.2 | 39.7 | 10 | oui |
| 3 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x4 | 12x9 | 10 | 0 | 9/15.7/29 | 17.6 | 4.8 | 5.0 | 1.3 | 40.5 | 10 | oui |
| 4 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x4 | 8x9 | 10 | 5 | 8/16.2/27 | 18.3 | 5.6 | 4.9 | 1.9 | 32.3 | 10 | oui |
| 5 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x3 | 11x9 | 10 | 1 | 9/13.6/24 | 15.2 | 3.8 | 4.3 | 1.3 | 42.2 | 10 | oui |
| 6 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 5x4 | 12x9 | 10 | 0 | 5/10.1/18 | 12.5 | 3.4 | 2.4 | 1.7 | 40.7 | 10 | oui |
| 7 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x3 | 11x8 | 10 | 0 | 5/11.8/23 | 14.3 | 4.2 | 2.9 | 1.7 | 45.8 | 10 | oui |
| 8 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 5x3 | 14x7 | 10 | 0 | 5/12.5/25 | 15.2 | 3.6 | 2.7 | 1.7 | 39.0 | 10 | oui |
| 9 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x4 | 9x8 | 10 | 0 | 7/9.9/15 | 12.6 | 3.4 | 2.3 | 1.6 | 45.8 | 10 | oui |
| 10 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 6x3 | 13x7 | 10 | 0 | 4/10.7/23 | 13.8 | 3.3 | 1.5 | 2.2 | 38.0 | 10 | oui |
| 11 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 6x4 | 13x7 | 10 | 0 | 6/10.6/16 | 11.2 | 2.5 | 2.5 | 1.1 | 40.3 | 10 | oui |
| 12 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 5x4 | 11x10 | 10 | 1 | 5/11.3/20 | 12.3 | 3.2 | 2.1 | 1.6 | 44.7 | 10 | oui |
| 13 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 5x4 | 10x7 | 10 | 0 | 7/12.5/26 | 14.4 | 3.8 | 2.2 | 1.9 | 47.0 | 10 | oui |
| 14 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 5x3 | 11x8 | 10 | 0 | 7/11.4/20 | 13.0 | 4.2 | 3.1 | 1.7 | 41.5 | 10 | oui |
