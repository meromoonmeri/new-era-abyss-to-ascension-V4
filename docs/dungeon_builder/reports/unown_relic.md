# Rapport de génération — Unown Relic

- **ID** : `unown_relic`  
- **Chapitre** : 26 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Unown Relic (11F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/UnownRelic) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 26. Recoupé avec Bulbapedia (page « Unown Relic »).  
- **Étages** : 11 — direction `fond`  
- **Zone écrite** : `Data/Zone/unown_relic.json`  
- **Seed d'auteur (debug)** : `9075541454630742784` (explicite : False)  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| unown_halls | 1-6 | unown_halls | `sealed_ruin_pit_floor` | crossroads, lattice, mixed | 27 | oui | oui | — |
| unown_vault | 7-11 | unown_vault | `sealed_ruin_pit_floor` | lattice, looping, dense | 25 | oui | oui | — |

## Scènes fixes

- entrée : `—`
- midpoint : `—`
- Ground de fin : `—`
- boss : mode `` → Ground `—`, rsmap `—`
  - no fixed 'entrance' Ground declared
  - no fixed 'mid' Ground declared
  - no fixed 'end' Ground declared
  - no boss scene declared

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | unown_halls | procedural | crossroads+lattice+mixed | 5x3 | 13x8 | 5 | 0 | 9/9.8/12 | 12.4 | 3.4 | 3.6 | 1.4 | 39.0 | 5 | oui |
| 2 | unown_halls | procedural | crossroads+lattice+mixed | 6x4 | 11x10 | 5 | 1 | 7/11.8/19 | 17.0 | 5.0 | 3.6 | 3.0 | 42.2 | 5 | oui |
| 3 | unown_halls | procedural | crossroads+lattice+mixed | 6x4 | 13x8 | 5 | 0 | 5/8.6/10 | 11.6 | 3.4 | 3.2 | 1.8 | 44.0 | 5 | oui |
| 4 | unown_halls | procedural | crossroads+lattice+mixed | 5x4 | 10x9 | 5 | 1 | 8/10.4/13 | 12.6 | 3.0 | 3.2 | 1.4 | 39.0 | 5 | oui |
| 5 | unown_halls | procedural | crossroads+lattice+mixed | 5x5 | 10x10 | 5 | 0 | 5/10.6/21 | 13.2 | 3.4 | 3.2 | 1.8 | 34.6 | 5 | oui |
| 6 | unown_halls | procedural | crossroads+lattice+mixed | 6x4 | 11x8 | 5 | 1 | 9/11.8/18 | 14.8 | 4.4 | 4.4 | 1.8 | 35.6 | 5 | oui |
| 7 | unown_vault | procedural | lattice+looping+dense | 6x4 | 7x7 | 5 | 1 | 7/13.6/27 | 19.2 | 6.2 | 3.8 | 2.6 | 35.0 | 5 | oui |
| 8 | unown_vault | procedural | lattice+looping+dense | 4x3 | 10x8 | 5 | 2 | 7/9.4/12 | 14.4 | 4.6 | 3.0 | 2.4 | 34.2 | 5 | oui |
| 9 | unown_vault | procedural | lattice+looping+dense | 4x4 | 10x8 | 5 | 1 | 8/11.8/20 | 16.0 | 4.4 | 2.4 | 2.4 | 42.4 | 5 | oui |
| 10 | unown_vault | procedural | lattice+looping+dense | 4x3 | 11x8 | 5 | 0 | 8/10.6/15 | 17.6 | 6.2 | 3.0 | 3.6 | 36.4 | 5 | oui |
| 11 | unown_vault | procedural | lattice+looping+dense | 6x4 | 9x8 | 5 | 1 | 6/9.0/12 | 17.6 | 6.4 | 1.8 | 4.4 | 48.2 | 5 | oui |
