# Rapport de génération — Mt. Freeze Peak

- **ID** : `mt_freeze_peak`  
- **Chapitre** : 12 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Freeze Peak (5F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtFreezePeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 12. Recoupé avec Bulbapedia (page « Mt. Freeze Peak »).  
- **Étages** : 5 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_freeze_peak.json`  
- **Seed d'auteur (debug)** : `3229771724714019628` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| freeze_peak | 1-5 | freeze_peak | `mt_freeze_floor` | large_rooms, crossroads, mixed | 1 | oui | oui | — |

## Scènes fixes

- entrée : `mont_gele_pied`
- midpoint : `—`
- Ground de fin : `d11p03`
- boss : mode `canonical_ground` → Ground `d11p03`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'd11p03' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | freeze_peak | procedural | large_rooms+crossroads+mixed | 3x2 | 14x13 | 5 | 1 | 4/9.4/18 | 9.4 | 2.4 | 3.4 | 0.8 | 31.4 | 5 | oui |
| 2 | freeze_peak | procedural | large_rooms+crossroads+mixed | 7x4 | 10x9 | 5 | 0 | 4/11.8/24 | 13.2 | 2.6 | 2.8 | 1.4 | 45.6 | 5 | oui |
| 3 | freeze_peak | procedural | large_rooms+crossroads+mixed | 3x2 | 16x13 | 5 | 0 | 6/8.2/13 | 8.2 | 1.6 | 2.8 | 0.6 | 34.2 | 5 | oui |
| 4 | freeze_peak | procedural | large_rooms+crossroads+mixed | 3x2 | 15x13 | 5 | 2 | 7/11.2/18 | 11.0 | 2.0 | 3.4 | 0.6 | 37.2 | 5 | oui |
| 5 | freeze_peak | procedural | large_rooms+crossroads+mixed | 3x2 | 16x11 | 5 | 0 | 4/9.4/13 | 10.4 | 2.4 | 2.0 | 1.6 | 44.8 | 5 | oui |
