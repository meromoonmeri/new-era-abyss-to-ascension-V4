# Rapport de génération — Sky Tower Summit

- **ID** : `sky_tower_summit`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Sky Tower Summit (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/SkyTowerSummit) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Sky Tower Summit »).  
- **Étages** : 9 — direction `sommet`  
- **Zone écrite** : `Data/Zone/sky_tower_summit.json`  
- **Seed d'auteur (debug)** : `2019856193680578044` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| sky_summit | 1-9 | sky_summit | `sky_tower_floor` | large_rooms, crossroads, mixed | 7 | oui | oui | — |

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
| 1 | sky_summit | procedural | large_rooms+crossroads+mixed | 4x2 | 15x13 | 5 | 1 | 8/10.6/15 | 10.8 | 2.0 | 2.6 | 0.8 | 49.2 | 5 | oui |
| 2 | sky_summit | procedural | large_rooms+crossroads+mixed | 3x2 | 13x12 | 5 | 0 | 6/10.6/23 | 10.2 | 2.2 | 3.8 | 0.4 | 40.2 | 5 | oui |
| 3 | sky_summit | procedural | large_rooms+crossroads+mixed | 7x3 | 13x10 | 5 | 0 | 6/7.8/9 | 7.2 | 1.6 | 3.2 | 0.4 | 41.6 | 5 | oui |
| 4 | sky_summit | procedural | large_rooms+crossroads+mixed | 4x5 | 13x8 | 5 | 0 | 4/9.6/14 | 9.2 | 2.0 | 3.4 | 0.6 | 40.8 | 5 | oui |
| 5 | sky_summit | procedural | large_rooms+crossroads+mixed | 3x2 | 13x13 | 5 | 0 | 7/10.4/22 | 10.4 | 2.2 | 3.2 | 0.8 | 36.2 | 5 | oui |
| 6 | sky_summit | procedural | large_rooms+crossroads+mixed | 4x3 | 14x10 | 5 | 0 | 5/9.0/14 | 9.0 | 1.6 | 3.0 | 0.6 | 38.4 | 5 | oui |
| 7 | sky_summit | procedural | large_rooms+crossroads+mixed | 5x3 | 9x9 | 5 | 0 | 6/9.8/19 | 10.4 | 2.4 | 3.0 | 1.0 | 49.8 | 5 | oui |
| 8 | sky_summit | procedural | large_rooms+crossroads+mixed | 4x2 | 16x10 | 5 | 0 | 6/7.0/10 | 6.0 | 0.8 | 3.0 | 0.0 | 40.2 | 5 | oui |
| 9 | sky_summit | procedural | large_rooms+crossroads+mixed | 6x4 | 8x8 | 5 | 0 | 5/8.6/15 | 8.6 | 1.6 | 3.0 | 0.6 | 36.6 | 5 | oui |
