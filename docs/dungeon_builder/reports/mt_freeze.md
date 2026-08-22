# Rapport de génération — Mt. Freeze

- **ID** : `mt_freeze`  
- **Chapitre** : 11 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze (15F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreeze) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 11. Recoupé avec Bulbapedia (page « Mt. Freeze »).  
- **Étages** : 15 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze.json`  
- **Seed d'auteur (debug)** : `651753743441004428` (explicite : False)  

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
| 1 | freeze_slope | procedural | twosides+branching+mixed | 3x4 | 12x11 | 5 | 0 | 6/11.4/19 | 12.6 | 2.8 | 3.4 | 1.0 | 44.0 | 5 | oui |
| 2 | freeze_slope | procedural | twosides+branching+mixed | 5x4 | 14x10 | 5 | 2 | 7/10.6/15 | 11.6 | 3.2 | 4.0 | 0.8 | 34.2 | 5 | oui |
| 3 | freeze_slope | procedural | twosides+branching+mixed | 4x4 | 9x8 | 5 | 2 | 6/7.8/10 | 8.4 | 1.8 | 3.0 | 0.4 | 42.4 | 5 | oui |
| 4 | freeze_slope | procedural | twosides+branching+mixed | 4x4 | 12x8 | 5 | 3 | 10/13.6/19 | 14.6 | 4.6 | 3.8 | 1.8 | 38.2 | 5 | oui |
| 5 | freeze_slope | procedural | twosides+branching+mixed | 4x4 | 14x9 | 5 | 0 | 6/8.0/12 | 8.8 | 1.4 | 2.6 | 0.4 | 40.0 | 5 | oui |
| 6 | freeze_slope | procedural | twosides+branching+mixed | 5x3 | 14x8 | 5 | 0 | 6/8.8/14 | 10.6 | 2.2 | 2.0 | 1.2 | 40.0 | 5 | oui |
| 7 | freeze_slope | procedural | twosides+branching+mixed | 5x5 | 13x11 | 5 | 0 | 8/10.0/16 | 12.0 | 2.4 | 2.8 | 1.2 | 41.4 | 5 | oui |
| 8 | freeze_slope | procedural | twosides+branching+mixed | 4x3 | 9x9 | 5 | 2 | 6/8.6/12 | 9.6 | 2.0 | 3.0 | 0.6 | 27.0 | 5 | oui |
| 9 | freeze_ridge | procedural | branching+crossroads+mixed | 4x4 | 12x8 | 5 | 1 | 8/9.4/11 | 9.0 | 1.8 | 3.6 | 0.6 | 33.8 | 5 | oui |
| 10 | freeze_ridge | procedural | branching+crossroads+mixed | 5x3 | 12x11 | 5 | 0 | 7/8.6/11 | 8.2 | 2.4 | 3.4 | 0.6 | 39.2 | 5 | oui |
| 11 | freeze_ridge | procedural | branching+crossroads+mixed | 5x3 | 13x12 | 5 | 0 | 6/10.8/19 | 10.6 | 2.4 | 4.4 | 0.6 | 31.8 | 5 | oui |
| 12 | freeze_ridge | procedural | branching+crossroads+mixed | 4x4 | 10x9 | 5 | 0 | 6/10.0/14 | 9.4 | 2.4 | 4.4 | 0.4 | 41.2 | 5 | oui |
| 13 | freeze_ridge | procedural | branching+crossroads+mixed | 5x4 | 10x10 | 5 | 0 | 8/11.2/16 | 11.2 | 2.4 | 3.8 | 0.6 | 37.8 | 5 | oui |
| 14 | freeze_ridge | procedural | branching+crossroads+mixed | 5x3 | 13x9 | 5 | 1 | 7/10.4/16 | 10.6 | 3.0 | 3.8 | 1.0 | 45.6 | 5 | oui |
| 15 | freeze_ridge | procedural | branching+crossroads+mixed | 4x3 | 12x9 | 5 | 0 | 7/12.6/21 | 12.4 | 3.4 | 5.6 | 0.6 | 30.8 | 5 | oui |
