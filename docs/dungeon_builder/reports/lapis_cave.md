# Rapport de génération — Lapis Cave

- **ID** : `lapis_cave`  
- **Chapitre** : 10 (secondary)  
- **Source canonique** : Pokémon Mystery Dungeon: Red Rescue Team — Lapis Cave (14F). Espèces, niveaux, probabilités, tables d'objets, pièges et boutiques extraits de pret/pmd-red (data/dungeon/LapisCave) via tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre 10. Recoupé avec Bulbapedia (page « Lapis Cave »).  
- **Étages** : 14 — direction `fond`  
- **Zone écrite** : `Data/Zone/lapis_cave.json`  
- **Gate canonique** : configuration `validated`, runtime `missing`  
- **Seed runtime** : fournie et journalisée par PMDO lors du test moteur ; aucune seed de production n'est écrite dans la zone.  

## Segments

| Segment | Étages | Biome | DTEF | Profils | Pokémon | Shop | M.House | Météo |
|---|---|---|---|---|---|---|---|---|
| lapis_gallery | 1-14 | lapis_gallery | `lapis_cave_floor` | branching, lattice, looping | 34 | non | non | — |

## Scènes fixes

- entrée : `grotte_lazuli_seuil`
- midpoint : `—`
- Ground de fin : `grotte_lazuli_fond`
- boss : mode `canonical_ground` → Ground `grotte_lazuli_fond`, rsmap `—`
  - no fixed 'mid' Ground declared
  - final battle stays on the canonical end Ground 'grotte_lazuli_fond' (no separate arena created)

## Étages

| Ét. | Segment | Type | Profil | Grille | Cellule | Variantes OK | Rejets | Rooms (min/moy/max) | Halls | Branches | Culs-de-sac | Boucles | Dist. escaliers | Signatures | Traversable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 12x10 | 10 | 0 | 8/14.5/22 | 24.8 | 7.7 | 3.8 | 4.6 | 44.3 | 10 | oui |
| 2 | lapis_gallery | procedural | branching|lattice|looping | 7x5 | 11x8 | 10 | 1 | 9/15.0/24 | 26.1 | 8.0 | 4.1 | 4.6 | 41.1 | 10 | oui |
| 3 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 12x8 | 10 | 1 | 9/15.4/21 | 23.1 | 7.1 | 4.6 | 3.3 | 50.2 | 10 | oui |
| 4 | lapis_gallery | procedural | branching|lattice|looping | 7x4 | 9x10 | 10 | 3 | 12/16.3/22 | 27.3 | 8.3 | 4.4 | 4.5 | 46.6 | 10 | oui |
| 5 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 10x10 | 10 | 1 | 9/16.2/30 | 24.0 | 6.8 | 4.0 | 3.2 | 46.5 | 10 | oui |
| 6 | lapis_gallery | procedural | branching|lattice|looping | 7x5 | 11x10 | 10 | 2 | 13/16.8/24 | 22.3 | 7.1 | 5.5 | 2.9 | 41.3 | 10 | oui |
| 7 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 12x8 | 10 | 2 | 12/14.6/18 | 24.9 | 6.7 | 3.4 | 3.9 | 51.2 | 10 | oui |
| 8 | lapis_gallery | procedural | branching|lattice|looping | 6x4 | 11x8 | 10 | 2 | 9/15.7/28 | 22.3 | 6.4 | 3.9 | 3.0 | 46.6 | 10 | oui |
| 9 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 10x10 | 10 | 0 | 12/16.0/24 | 24.2 | 6.8 | 4.1 | 3.3 | 51.8 | 10 | oui |
| 10 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 11x8 | 10 | 0 | 11/16.5/26 | 24.5 | 6.8 | 4.8 | 3.2 | 58.6 | 10 | oui |
| 11 | lapis_gallery | procedural | branching|lattice|looping | 5x4 | 12x9 | 10 | 3 | 12/15.1/19 | 22.3 | 7.4 | 5.0 | 3.5 | 53.2 | 10 | oui |
| 12 | lapis_gallery | procedural | branching|lattice|looping | 7x4 | 12x8 | 10 | 0 | 11/16.4/24 | 25.6 | 7.4 | 4.8 | 3.6 | 49.1 | 10 | oui |
| 13 | lapis_gallery | procedural | branching|lattice|looping | 7x4 | 9x10 | 10 | 1 | 10/15.1/23 | 25.3 | 8.4 | 4.5 | 4.6 | 51.5 | 10 | oui |
| 14 | lapis_gallery | procedural | branching|lattice|looping | 5x5 | 11x8 | 10 | 0 | 9/14.7/21 | 22.1 | 6.4 | 4.0 | 3.3 | 47.9 | 10 | oui |
