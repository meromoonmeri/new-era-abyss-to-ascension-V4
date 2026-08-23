# Rapport de génération — Mt. Blaze

- **ID** : `mt_blaze`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlaze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze.json`  
- **Seed d'auteur (debug)** : `430756256229848820` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| blaze_slope | 1-6 | blaze_slope | `mt_blaze_floor` | twosides, branching, mixed | 5 | oui | oui | — |
| blaze_ridge | 7-12 | blaze_ridge | `mt_blaze_floor` | branching, crossroads, mixed | 4 | oui | oui | — |

## Scènes fixes

- entrée : `mont_cendre_pied`
- midpoint : `mt_blaze_midpoint`
- Ground de fin : `d09p03`
- boss : mode `canonical_ground` → Ground `d09p03`, rsmap `—`
  - final battle stays on the canonical end Ground 'd09p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | blaze_slope | procedural | twosides+branching+mixed | 4x3 | 13x9 | 5 | 1 | 6/10.0/14 | 11.2 | 2.6 | 3.2 | 1.0 | 44.2 | 5 | oui |
| 2 | blaze_slope | procedural | twosides+branching+mixed | 6x3 | 8x8 | 5 | 1 | 6/12.4/17 | 13.6 | 4.2 | 4.4 | 1.0 | 35.0 | 5 | oui |
| 3 | blaze_slope | procedural | twosides+branching+mixed | 4x3 | 12x10 | 5 | 1 | 6/9.6/13 | 10.4 | 2.4 | 2.6 | 1.0 | 38.8 | 5 | oui |
| 4 | blaze_slope | procedural | twosides+branching+mixed | 3x3 | 12x8 | 5 | 1 | 7/11.6/19 | 12.8 | 3.4 | 4.4 | 0.8 | 39.2 | 5 | oui |
| 5 | blaze_slope | procedural | twosides+branching+mixed | 4x3 | 12x9 | 5 | 1 | 6/9.6/11 | 10.2 | 3.2 | 3.6 | 0.8 | 39.4 | 5 | oui |
| 6 | blaze_slope | procedural | twosides+branching+mixed | 4x4 | 13x11 | 5 | 3 | 7/12.2/22 | 12.4 | 4.0 | 5.2 | 0.8 | 39.2 | 5 | oui |
| 7 | blaze_ridge | procedural | branching+crossroads+mixed | 6x3 | 9x9 | 5 | 0 | 6/10.8/16 | 11.4 | 2.8 | 3.6 | 1.2 | 35.8 | 5 | oui |
| 8 | blaze_ridge | procedural | branching+crossroads+mixed | 6x4 | 11x9 | 5 | 0 | 8/9.4/12 | 9.6 | 2.4 | 3.4 | 1.0 | 41.6 | 5 | oui |
| 9 | blaze_ridge | procedural | branching+crossroads+mixed | 5x4 | 10x8 | 5 | 0 | 8/10.4/15 | 10.2 | 2.2 | 3.6 | 0.4 | 53.8 | 5 | oui |
| 10 | blaze_ridge | procedural | branching+crossroads+mixed | 6x3 | 10x8 | 5 | 1 | 8/14.4/24 | 15.8 | 4.0 | 4.8 | 1.6 | 33.2 | 5 | oui |
| 11 | blaze_ridge | procedural | branching+crossroads+mixed | 7x4 | 9x11 | 5 | 1 | 8/11.2/17 | 10.8 | 3.0 | 4.2 | 0.6 | 34.2 | 5 | oui |
| 12 | blaze_ridge | procedural | branching+crossroads+mixed | 5x4 | 10x8 | 5 | 0 | 7/11.6/17 | 12.0 | 3.4 | 4.2 | 0.8 | 40.0 | 5 | oui |
