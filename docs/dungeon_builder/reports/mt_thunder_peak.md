# Rapport de génération — Mt. Thunder Peak

- **ID** : `mt_thunder_peak`  
- **Chapitre** : 9 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Mt. Thunder Peak (3F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/MtThunderPeak) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 9. Recoupé avec Bulbapedia (page « Mt. Thunder Peak »).  
- **Étages** : 3 — direction `sommet`  
- **Zone écrite** : `Data/Zone/mt_thunder_peak.json`  
- **Seed d'auteur (debug)** : `8490819363021106161` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| thunder_peak | 1-3 | thunder_peak | `far_amp_plains_floor` | large_rooms, crossroads, mixed | 6 | oui | oui | — |

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
| 1 | thunder_peak | procedural | large_rooms+crossroads+mixed | 3x3 | 15x10 | 5 | 0 | 4/9.6/18 | 10.0 | 1.8 | 3.0 | 0.8 | 27.8 | 5 | oui |
| 2 | thunder_peak | procedural | large_rooms+crossroads+mixed | 5x4 | 10x10 | 5 | 0 | 4/7.0/9 | 6.4 | 0.6 | 2.2 | 0.4 | 36.8 | 5 | oui |
| 3 | thunder_peak | procedural | large_rooms+crossroads+mixed | 7x3 | 11x7 | 5 | 0 | 4/7.0/9 | 6.6 | 1.4 | 2.6 | 0.6 | 35.8 | 5 | oui |
