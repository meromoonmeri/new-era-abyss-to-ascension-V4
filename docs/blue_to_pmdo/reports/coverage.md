# Rapport de couverture final — retransposition Blue → PMDO

**Date :** 2026-08-10 — **Convertisseur :** nds2pmdo v0.1.0
**Source :** ROM APHP `2540966e1e9cd722bf2ae401069df10b81875af03f0618d413b9d32511c14b05`
(seule référence : https://github.com/meromoonmeri/POKEMON-ROM)
**Règle :** `gloomy_forest.json` et les contenus New Era ne sont PAS modifiés.

## Compteurs par catégorie

| Ressource | Total | Prouvé (PROVEN) | Adapté+validé PMDO | Partiel (PARTIAL) | Inconnu (UNKNOWN) | Bloqué (BLOCKED) |
|---|---|---|---|---|---|---|
| Grounds (packages ground.sbin) | 724 | 0 (inventaire) | 0 | 0 | 0 | 724 (format non décodé) |
| Dont cinématiques Sinister Woods (B10P01*/B10P02*) | 6 | 0 | 0 | 6 (structure de blocs) | 0 | 6 |
| Tilesets (blobs bNN) | 130 × 5 | 2 (b10/b41 fon/cel/cex/pal) | 0 | 2 (canm : forme) | 128 (non décodés) | 0 |
| Animations de tileset (canm) | 130 | 0 | 0 | 2 (forme SIR0) | 128 | 0 |
| Étages Sinister Woods (paramètres) | 13 | 13 | 0 | 0 | 0 | 0 |
| Tables de spawns Pokémon | 13 | 13 (noms CROSS_REFERENCE) | 0 | 0 | formule poids | 0 |
| Tables d'items | 2 (SW) | 0 | 0 | 2 (poids PROVEN, IDs UNKNOWN) | 2 | 2 (conversion items) |
| Tables de pièges | 1 (SW) | 0 | 0 | 1 (poids PROVEN, nom UNKNOWN) | 1 | 1 |
| Musiques SEQ (SDAT) | 220 index | 98 (chaîne → SSEQ) | 0 | 0 | 122 trous = données, pas inconnues | 0 |
| Dont mapping bgMusic → SEQ | 1 | 0 | 0 | 0 | 1 | 0 |
| Banques SBNK | 301 index | 83 (chaîne → SBNK) | 0 | 0 | 218 trous | 0 |
| Dialogues (message_*.bin/.str) | 5 langues | 0 | 0 | 5 (offsets u32 identifiés) | 5 | 0 |
| Sprites Pokémon (monster.sbin) | 1 fichier | 0 | 0 | 0 | 1 | 0 |
| VFX/particules (effect.sbin) | 1 fichier | 0 | 0 | 0 | 1 | 0 |
| Marqueurs / entrances / exits | — | 0 | 0 | 0 | 0 | dépend des Grounds |
| Collisions (Grounds/étages) | — | 0 | 0 | 0 | paramètres d'étage PROVEN | Grounds bloqués |
| Conversion PMDO (Phase 1) | — | — | **0 élément généré** | — | — | **BLOQUÉE (gates)** |

## Synthèse honnête

- **Entièrement prouvé (SOURCE_NDS)** : extraction ROM/FNT/FAT/packs, SIR0, AT4PX,
  mapparam Sinister Woods (13 étages), spawns (13 tables), palettes/cells/tiles
  b10+b41, chaîne SDAT complète (98 SSEQ → fichiers, trous préservés), inventaires
  globaux (dungeon 804, ground 724, monster, effect, messages).
- **Adapté et validé dans PMDO** : **aucun** — la conversion est bloquée par les
  gates (c'est le résultat attendu de l'auto-audit, pas un échec masqué).
- **Partiellement décodé** : items/poids, pièges/poids, canm (forme), packages
  B10P01 (structure de blocs), messages, records STRM/WAVE/GRP/PLAYER.
- **Encore inconnu** : IDs items, nom piège 17, sémantique canm, flags cel/cex,
  mapping bgMusic→SEQ (code ARM9), boucles SSEQ, formats ground.sbin/monster.sbin/
  effect.sbin, table de noms d'espèces ROM.
- **Bloqué par une différence architecturale** : géométrie procédurale des donjons
  (NDS = algorithme ARM9, PMDO = GenSteps) ; cinématiques (packages non décodés) ;
  conversion audio SSEQ→OGG (pas de démonstration des boucles).

## Preuves visuelles disponibles

`docs/blue_to_pmdo/` — tilesets (b41/b10, feuilles + 12 sous-palettes), palettes
(nuanciers 192 couleurs), cellules (atlas 2250 cells), comparaison b10 vs b41,
graphique des FloorProperties par étage. Provenance : `manifests/provenance_manifest.json`.
Les dossiers collision/, markers/, animations/, cinematics/ sont volontairement
vides de rendus : rien n'y est produit tant que la source n'est pas décodée
(interdiction des placeholders silencieux).

## Où aller ensuite (priorités de décodage)

1. Format des packages `ground.sbin` (A01P01, B10P01) → débloque Grounds,
   marqueurs, collisions, cinématiques.
2. Code ARM9 : table `bgMusic → SEQ` ; table `MonsterID → nom` (message/monster.sbin).
3. Sémantique `canm` (croisement visuel eau/lave) et flags `cel`.
4. IDs d'items par catégorie (références depuis le code ou tables annexes de
   mapparam/zmappat).
5. Boucles SSEQ (headers SSEQ) → conversion OGG.
