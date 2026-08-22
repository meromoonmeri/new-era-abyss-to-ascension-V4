# Rapport de génération — Sky Tower

- **ID** : `sky_tower`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Sky Tower (25F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SkyTower) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Sky Tower »).  
- **Étages** : 25 — direction `sommet`  
- **Zone écrite** : `Data/Zone/sky_tower.json`  
- **Seed d'auteur (debug)** : `2720242641609116647` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| sky_ascent | 1-25 | sky_ascent | `sky_tower_floor` | crossroads, branching, mixed | 16 | oui | oui | — |

## Scènes fixes

- entrée : `arc_parvis_celeste`
- midpoint : `—`
- Ground de fin : `arc_tour_ciel_sommet`
- boss : mode `canonical_ground` → Ground `arc_tour_ciel_sommet`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'arc_tour_ciel_sommet' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | sky_ascent | procedural | crossroads+branching+mixed | 7x4 | 11x7 | 5 | 0 | 6/9.8/16 | 9.8 | 2.8 | 4.0 | 0.6 | 34.0 | 5 | oui |
| 2 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 9x9 | 5 | 0 | 7/9.6/12 | 9.0 | 2.2 | 3.8 | 0.4 | 45.4 | 5 | oui |
| 3 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 9x8 | 5 | 0 | 7/10.8/14 | 11.0 | 2.6 | 3.8 | 0.8 | 29.2 | 5 | oui |
| 4 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 10x10 | 5 | 0 | 8/9.2/10 | 9.0 | 2.4 | 3.4 | 0.8 | 31.2 | 5 | oui |
| 5 | sky_ascent | procedural | crossroads+branching+mixed | 5x5 | 9x9 | 5 | 0 | 8/11.8/16 | 11.6 | 2.8 | 4.0 | 0.6 | 37.8 | 5 | oui |
| 6 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 10x10 | 5 | 1 | 9/11.0/14 | 11.0 | 2.6 | 4.0 | 0.8 | 35.0 | 5 | oui |
| 7 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 13x8 | 5 | 0 | 6/10.8/17 | 10.8 | 2.2 | 4.0 | 0.6 | 41.0 | 5 | oui |
| 8 | sky_ascent | procedural | crossroads+branching+mixed | 5x3 | 13x12 | 5 | 1 | 9/11.4/14 | 11.0 | 2.4 | 3.6 | 0.6 | 54.8 | 5 | oui |
| 9 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 12x9 | 5 | 0 | 7/8.2/11 | 8.0 | 1.8 | 3.2 | 0.6 | 32.4 | 5 | oui |
| 10 | sky_ascent | procedural | crossroads+branching+mixed | 6x4 | 11x11 | 5 | 0 | 8/11.4/18 | 12.2 | 3.0 | 3.4 | 1.2 | 38.0 | 5 | oui |
| 11 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 9x10 | 5 | 0 | 9/11.4/15 | 11.2 | 2.6 | 3.6 | 0.8 | 35.2 | 5 | oui |
| 12 | sky_ascent | procedural | crossroads+branching+mixed | 4x3 | 11x10 | 5 | 0 | 8/10.8/13 | 10.6 | 2.4 | 3.4 | 0.8 | 36.4 | 5 | oui |
| 13 | sky_ascent | procedural | crossroads+branching+mixed | 6x4 | 11x10 | 5 | 1 | 8/12.4/20 | 13.0 | 3.4 | 4.4 | 1.0 | 35.2 | 5 | oui |
| 14 | sky_ascent | procedural | crossroads+branching+mixed | 6x3 | 9x10 | 5 | 0 | 8/10.0/14 | 9.8 | 2.4 | 3.6 | 0.6 | 41.6 | 5 | oui |
| 15 | sky_ascent | procedural | crossroads+branching+mixed | 4x5 | 8x7 | 5 | 0 | 9/12.6/19 | 13.4 | 2.8 | 3.4 | 1.0 | 41.2 | 5 | oui |
| 16 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 9x8 | 5 | 1 | 7/12.0/21 | 11.6 | 3.2 | 4.8 | 0.4 | 41.2 | 5 | oui |
| 17 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 12x9 | 5 | 0 | 9/10.8/13 | 10.6 | 2.6 | 3.8 | 0.6 | 31.8 | 5 | oui |
| 18 | sky_ascent | procedural | crossroads+branching+mixed | 5x4 | 12x8 | 5 | 0 | 8/10.0/13 | 9.8 | 2.4 | 3.2 | 0.8 | 34.2 | 5 | oui |
| 19 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 9x9 | 5 | 0 | 8/10.8/14 | 10.4 | 2.8 | 4.0 | 0.6 | 50.8 | 5 | oui |
| 20 | sky_ascent | procedural | crossroads+branching+mixed | 5x5 | 9x10 | 5 | 1 | 9/13.6/19 | 14.2 | 3.6 | 4.2 | 1.0 | 40.4 | 5 | oui |
| 21 | sky_ascent | procedural | crossroads+branching+mixed | 7x3 | 8x11 | 5 | 1 | 7/9.8/15 | 9.4 | 2.2 | 4.0 | 0.4 | 43.0 | 5 | oui |
| 22 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 9x9 | 5 | 0 | 9/11.6/16 | 11.6 | 2.6 | 3.6 | 0.8 | 45.6 | 5 | oui |
| 23 | sky_ascent | procedural | crossroads+branching+mixed | 7x5 | 9x11 | 5 | 0 | 7/14.0/26 | 14.6 | 4.6 | 4.6 | 1.4 | 37.8 | 5 | oui |
| 24 | sky_ascent | procedural | crossroads+branching+mixed | 4x3 | 12x11 | 5 | 0 | 7/9.0/11 | 8.8 | 2.0 | 3.6 | 0.6 | 40.6 | 5 | oui |
| 25 | sky_ascent | procedural | crossroads+branching+mixed | 6x5 | 11x9 | 5 | 0 | 9/10.6/12 | 10.8 | 3.0 | 3.8 | 0.8 | 34.4 | 5 | oui |
