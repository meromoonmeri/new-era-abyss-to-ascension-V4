# Rapport de génération — Mt. Thunder

- **ID** : `mt_thunder`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder (10F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunder) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder »).  
- **Étages** : 10 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder.json`  
- **Seed d'auteur (debug)** : `1727581109347871366` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_slope | 1-5 | thunder_slope | `mt_thunder_floor` | twosides, branching, mixed | 8 | oui | oui | — |
| thunder_ridge | 6-10 | thunder_ridge | `mt_thunder_floor` | branching, crossroads, mixed | 7 | oui | oui | — |

## Scènes fixes

- entrée : `mont_grondant_pied`
- midpoint : `—`
- Ground de fin : `d06p03`
- boss : mode `canonical_ground` → Ground `d06p03`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd06p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | thunder_slope | procedural | twosides+branching+mixed | 4x5 | 10x9 | 5 | 1 | 6/12.4/28 | 13.2 | 3.4 | 4.0 | 1.0 | 45.2 | 5 | oui |
| 2 | thunder_slope | procedural | twosides+branching+mixed | 3x3 | 13x8 | 5 | 0 | 6/10.6/19 | 12.6 | 3.0 | 3.2 | 1.0 | 36.0 | 5 | oui |
| 3 | thunder_slope | procedural | twosides+branching+mixed | 5x4 | 13x9 | 5 | 1 | 6/9.4/14 | 10.0 | 3.2 | 3.4 | 1.0 | 31.2 | 5 | oui |
| 4 | thunder_slope | procedural | twosides+branching+mixed | 3x3 | 12x8 | 5 | 0 | 6/10.0/17 | 11.6 | 3.2 | 3.4 | 1.0 | 35.8 | 5 | oui |
| 5 | thunder_slope | procedural | twosides+branching+mixed | 3x4 | 13x8 | 5 | 0 | 6/10.0/15 | 11.6 | 2.6 | 3.2 | 0.8 | 38.6 | 5 | oui |
| 6 | thunder_ridge | procedural | branching+crossroads+mixed | 5x4 | 12x8 | 5 | 1 | 8/9.4/12 | 9.6 | 2.4 | 3.2 | 1.0 | 44.2 | 5 | oui |
| 7 | thunder_ridge | procedural | branching+crossroads+mixed | 4x4 | 14x12 | 5 | 0 | 8/10.2/13 | 9.8 | 2.4 | 3.8 | 0.6 | 38.6 | 5 | oui |
| 8 | thunder_ridge | procedural | branching+crossroads+mixed | 5x4 | 9x7 | 5 | 1 | 10/11.6/17 | 10.8 | 2.6 | 4.8 | 0.2 | 33.4 | 5 | oui |
| 9 | thunder_ridge | procedural | branching+crossroads+mixed | 5x4 | 11x9 | 5 | 1 | 9/13.8/29 | 15.0 | 3.4 | 2.4 | 1.8 | 43.6 | 5 | oui |
| 10 | thunder_ridge | procedural | branching+crossroads+mixed | 6x4 | 13x9 | 5 | 0 | 7/9.8/13 | 9.4 | 2.0 | 3.2 | 0.6 | 33.2 | 5 | oui |
