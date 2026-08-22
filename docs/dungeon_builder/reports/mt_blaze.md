# Rapport de génération — Mt. Blaze

- **ID** : `mt_blaze`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze (12F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlaze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze »).  
- **Étages** : 12 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze.json`  
- **Seed d'auteur (debug)** : `892879398162269134` (explicite : False)  

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
| 1 | blaze_slope | procedural | twosides+branching+mixed | 6x4 | 10x8 | 5 | 1 | 6/11.8/23 | 12.2 | 2.8 | 4.4 | 0.4 | 35.6 | 5 | oui |
| 2 | blaze_slope | procedural | twosides+branching+mixed | 4x3 | 12x9 | 5 | 1 | 6/9.6/13 | 10.2 | 2.6 | 3.2 | 0.8 | 37.6 | 5 | oui |
| 3 | blaze_slope | procedural | twosides+branching+mixed | 4x5 | 10x11 | 5 | 2 | 6/12.4/19 | 14.2 | 4.2 | 3.4 | 1.8 | 46.4 | 5 | oui |
| 4 | blaze_slope | procedural | twosides+branching+mixed | 3x3 | 13x8 | 5 | 2 | 8/13.8/21 | 14.8 | 4.0 | 4.4 | 1.0 | 43.2 | 5 | oui |
| 5 | blaze_slope | procedural | twosides+branching+mixed | 5x3 | 9x10 | 5 | 0 | 7/9.0/12 | 10.6 | 2.2 | 3.2 | 0.6 | 39.2 | 5 | oui |
| 6 | blaze_slope | procedural | twosides+branching+mixed | 3x3 | 10x10 | 5 | 0 | 6/8.6/12 | 9.6 | 1.8 | 2.8 | 0.6 | 30.0 | 5 | oui |
| 7 | blaze_ridge | procedural | branching+crossroads+mixed | 4x3 | 11x8 | 5 | 2 | 8/10.4/17 | 9.8 | 2.6 | 4.6 | 0.4 | 40.4 | 5 | oui |
| 8 | blaze_ridge | procedural | branching+crossroads+mixed | 6x4 | 13x10 | 5 | 1 | 7/11.6/17 | 12.4 | 3.4 | 3.6 | 1.2 | 34.8 | 5 | oui |
| 9 | blaze_ridge | procedural | branching+crossroads+mixed | 6x4 | 14x7 | 5 | 0 | 6/10.2/19 | 9.6 | 1.8 | 3.8 | 0.4 | 32.8 | 5 | oui |
| 10 | blaze_ridge | procedural | branching+crossroads+mixed | 7x4 | 11x11 | 5 | 0 | 7/9.8/14 | 10.4 | 2.0 | 3.0 | 1.0 | 48.6 | 5 | oui |
| 11 | blaze_ridge | procedural | branching+crossroads+mixed | 5x5 | 9x11 | 5 | 0 | 7/9.4/12 | 8.6 | 2.0 | 4.0 | 0.2 | 33.2 | 5 | oui |
| 12 | blaze_ridge | procedural | branching+crossroads+mixed | 4x5 | 12x11 | 5 | 0 | 6/10.8/17 | 11.2 | 3.4 | 4.4 | 0.8 | 31.4 | 5 | oui |
