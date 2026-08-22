# Rapport de génération — Sinister Woods

- **ID** : `gloomy_forest`  
- **Chapitre** : 6 (main)  
- **Source canonique** : Pokémon Mystery Dungeon: Rescue Team (Red/Blue Rescue Team & Rescue Team DX) — Sinister Woods, B1F-B12F. Species/items adapted to PMDO spawn tables and rescaled to New Era chapter 6 (30 years later).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/gloomy_forest.json`  
- **Seed d'auteur (debug)** : `7841272822671575005` (explicite : False)  

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
| 1 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 5x3 | 12x10 | 10 | 0 | 7/12.6/23 | 14.1 | 4.2 | 4.3 | 1.2 | 37.3 | 10 | oui |
| 2 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 7x3 | 9x10 | 10 | 2 | 10/14.3/25 | 16.4 | 4.7 | 3.8 | 1.9 | 48.4 | 10 | oui |
| 3 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 6x4 | 7x7 | 10 | 1 | 6/15.6/27 | 17.9 | 5.3 | 4.9 | 1.6 | 36.9 | 10 | oui |
| 4 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 8x5 | 9x7 | 10 | 0 | 8/14.4/28 | 16.4 | 4.5 | 4.2 | 1.6 | 42.9 | 10 | oui |
| 5 | Lisière hantée | procedural | branching+dense+mixed+crossroads | 4x5 | 10x9 | 10 | 4 | 7/11.7/23 | 12.6 | 3.7 | 3.6 | 1.3 | 44.0 | 10 | oui |
| 6 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 6x5 | 8x9 | 10 | 1 | 6/10.5/20 | 12.9 | 3.0 | 2.2 | 1.5 | 38.0 | 10 | oui |
| 7 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x4 | 12x11 | 10 | 0 | 4/9.3/17 | 11.7 | 3.1 | 2.3 | 1.5 | 40.9 | 10 | oui |
| 8 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 4x3 | 16x10 | 10 | 0 | 4/9.6/16 | 11.8 | 2.8 | 2.4 | 1.4 | 40.5 | 10 | oui |
| 9 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 7x4 | 10x11 | 10 | 0 | 5/10.7/19 | 13.4 | 3.5 | 2.3 | 1.8 | 44.7 | 10 | oui |
| 10 | Bois profonds | procedural | looping+branching+large_rooms+mixed+ring | 6x4 | 12x10 | 10 | 1 | 5/10.0/26 | 13.7 | 3.3 | 2.1 | 1.8 | 39.7 | 10 | oui |
| 11 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x3 | 14x10 | 10 | 0 | 4/9.7/17 | 10.8 | 2.9 | 2.8 | 1.2 | 31.8 | 10 | oui |
| 12 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x3 | 10x9 | 10 | 0 | 5/10.1/17 | 11.0 | 2.8 | 2.4 | 1.4 | 38.5 | 10 | oui |
| 13 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 4x4 | 11x9 | 10 | 0 | 4/8.6/14 | 9.1 | 2.4 | 2.5 | 1.0 | 40.0 | 10 | oui |
| 14 | Clairière du Filou | procedural | mixed+large_rooms+looping+branching | 5x4 | 9x10 | 10 | 1 | 5/10.2/16 | 11.8 | 3.3 | 2.3 | 1.7 | 44.5 | 10 | oui |
