# Rapport de génération — Mt. Freeze

- **ID** : `mt_freeze`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreeze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Mt. Freeze »).  
- **Étages** : 15 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze.json`  
- **Seed d'auteur (debug)** : `5423744189238460590` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| freeze_slope | 1-8 | freeze_slope | `mt_freeze_floor` | twosides, branching, mixed | 8 | oui | oui | — |
| freeze_ridge | 9-15 | freeze_ridge | `mt_freeze_floor` | branching, crossroads, mixed | 5 | oui | oui | — |

## Scènes fixes

- entrée : `mont_gele_pied`
- midpoint : `mt_freeze_midpoint`
- Ground de fin : `d11p03`
- boss : mode `canonical_ground` → Ground `d11p03`, rsmap `—`
  - final battle stays on the canonical end Ground 'd11p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | freeze_slope | procedural | twosides+branching+mixed | 3x3 | 12x10 | 5 | 2 | 9/12.2/17 | 12.2 | 4.0 | 4.6 | 0.8 | 38.6 | 5 | oui |
| 2 | freeze_slope | procedural | twosides+branching+mixed | 7x5 | 8x9 | 5 | 0 | 8/10.6/15 | 12.0 | 2.2 | 3.6 | 0.6 | 32.0 | 5 | oui |
| 3 | freeze_slope | procedural | twosides+branching+mixed | 4x3 | 12x11 | 5 | 1 | 6/11.0/17 | 11.8 | 3.0 | 3.6 | 1.0 | 43.4 | 5 | oui |
| 4 | freeze_slope | procedural | twosides+branching+mixed | 4x4 | 8x7 | 5 | 0 | 6/8.4/11 | 9.8 | 1.4 | 1.8 | 0.8 | 36.0 | 5 | oui |
| 5 | freeze_slope | procedural | twosides+branching+mixed | 4x4 | 10x12 | 5 | 0 | 6/10.0/15 | 11.8 | 3.4 | 3.2 | 1.2 | 41.8 | 5 | oui |
| 6 | freeze_slope | procedural | twosides+branching+mixed | 6x3 | 11x8 | 5 | 1 | 7/11.4/22 | 12.8 | 3.0 | 3.2 | 1.0 | 46.4 | 5 | oui |
| 7 | freeze_slope | procedural | twosides+branching+mixed | 3x4 | 11x10 | 5 | 0 | 6/10.6/15 | 12.4 | 3.0 | 2.6 | 1.4 | 36.8 | 5 | oui |
| 8 | freeze_slope | procedural | twosides+branching+mixed | 5x3 | 11x9 | 5 | 1 | 7/9.8/15 | 10.0 | 2.2 | 3.4 | 0.4 | 35.0 | 5 | oui |
| 9 | freeze_ridge | procedural | branching+crossroads+mixed | 6x5 | 12x11 | 5 | 0 | 8/11.6/21 | 11.0 | 2.8 | 5.0 | 0.4 | 42.6 | 5 | oui |
| 10 | freeze_ridge | procedural | branching+crossroads+mixed | 5x3 | 11x10 | 5 | 0 | 9/12.2/21 | 12.8 | 3.4 | 4.6 | 0.8 | 49.6 | 5 | oui |
| 11 | freeze_ridge | procedural | branching+crossroads+mixed | 5x3 | 11x10 | 5 | 0 | 7/12.2/25 | 12.4 | 3.2 | 4.0 | 1.0 | 36.2 | 5 | oui |
| 12 | freeze_ridge | procedural | branching+crossroads+mixed | 6x5 | 12x8 | 5 | 1 | 8/11.8/20 | 13.0 | 3.6 | 4.0 | 1.4 | 31.0 | 5 | oui |
| 13 | freeze_ridge | procedural | branching+crossroads+mixed | 5x5 | 9x11 | 5 | 1 | 8/10.6/13 | 11.8 | 3.4 | 3.6 | 1.4 | 35.6 | 5 | oui |
| 14 | freeze_ridge | procedural | branching+crossroads+mixed | 7x5 | 8x11 | 5 | 1 | 7/13.8/21 | 14.6 | 4.0 | 4.4 | 1.2 | 47.2 | 5 | oui |
| 15 | freeze_ridge | procedural | branching+crossroads+mixed | 4x4 | 10x10 | 5 | 2 | 7/10.4/16 | 10.6 | 3.2 | 4.0 | 0.8 | 39.6 | 5 | oui |
