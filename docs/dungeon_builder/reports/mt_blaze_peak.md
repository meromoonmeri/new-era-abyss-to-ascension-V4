# Rapport de génération — Mt. Blaze Peak

- **ID** : `mt_blaze_peak`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Blaze Peak (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtBlazePeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Mt. Blaze Peak »).  
- **Étages** : 3 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_blaze_peak.json`  
- **Seed d'auteur (debug)** : `1092414373703114457` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| blaze_peak | 1-3 | blaze_peak | `magma_cavern_2_floor` | large_rooms, crossroads, mixed | 3 | oui | oui | — |

## Scènes fixes

- entrée : `mont_cendre_pied`
- midpoint : `—`
- Ground de fin : `d09p03`
- boss : mode `canonical_ground` → Ground `d09p03`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd09p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | blaze_peak | procedural | large_rooms+crossroads+mixed | 4x4 | 12x7 | 5 | 0 | 4/9.2/16 | 9.0 | 1.6 | 3.2 | 0.4 | 45.4 | 5 | oui |
| 2 | blaze_peak | procedural | large_rooms+crossroads+mixed | 7x4 | 12x10 | 5 | 0 | 6/8.6/15 | 8.6 | 2.0 | 3.0 | 0.6 | 47.2 | 5 | oui |
| 3 | blaze_peak | procedural | large_rooms+crossroads+mixed | 7x5 | 10x8 | 5 | 1 | 5/8.6/13 | 8.8 | 1.6 | 2.0 | 1.0 | 35.2 | 5 | oui |
