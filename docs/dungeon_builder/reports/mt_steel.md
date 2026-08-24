# Rapport de génération — Mt. Steel

- **ID** : `mt_steel`  
- **Chapitre** : 7 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Steel (9F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtSteel) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 7. Recoupé avec Bulbapedia (page « Mt. Steel »).  
- **Étages** : 8 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_steel.json`  
- **Gate canonique** : configuration `validated`, runtime `validated`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| steel_slope | 1-8 | steel_slope | `mt_steel_1_floor` | branching, lattice | 40 | non | non | — |

## Scènes fixes

- entrée : `pic_ferreux_pied`
- midpoint : `—`
- Ground de fin : `d03p02`
- boss : mode `canonical_ground` → Ground `d03p02`, rsmap `mt_steel_boss`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd03p02' (no separate arena created)
  - scene source of truth: mt_steel_boss.rsmap matches the end Ground

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | steel_slope | procedural | branching|lattice | 5x4 | 9x10 | 10 | 0 | 10/14.5/19 | 23.2 | 8.4 | 4.8 | 4.5 | 47.2 | 10 | oui |
| 2 | steel_slope | procedural | branching|lattice | 5x5 | 11x8 | 10 | 2 | 13/16.1/23 | 20.9 | 6.8 | 4.8 | 3.1 | 45.7 | 10 | oui |
| 3 | steel_slope | procedural | branching|lattice | 5x4 | 10x10 | 10 | 1 | 12/17.2/24 | 23.1 | 7.5 | 5.6 | 3.3 | 47.3 | 10 | oui |
| 4 | steel_slope | procedural | branching|lattice | 6x5 | 10x10 | 10 | 3 | 10/15.0/20 | 21.8 | 7.2 | 5.1 | 3.7 | 54.4 | 10 | oui |
| 5 | steel_slope | procedural | branching|lattice | 6x5 | 12x10 | 10 | 0 | 9/14.5/20 | 21.8 | 7.7 | 4.4 | 4.1 | 53.3 | 10 | oui |
| 6 | steel_slope | procedural | branching|lattice | 6x4 | 11x10 | 10 | 0 | 10/15.3/20 | 22.5 | 7.7 | 5.2 | 3.9 | 46.5 | 10 | oui |
| 7 | steel_slope | procedural | branching|lattice | 5x4 | 9x10 | 10 | 0 | 12/15.8/22 | 24.9 | 9.5 | 5.4 | 4.9 | 50.6 | 10 | oui |
| 8 | steel_slope | procedural | branching|lattice | 6x4 | 12x8 | 10 | 2 | 10/15.2/21 | 18.7 | 5.8 | 4.3 | 2.4 | 39.0 | 10 | oui |
