# Extraction pmd-red → New Era — Rapport de traçabilité (Étape 5)

Date : 2026-07-27
Source : [pret/pmd-red](https://github.com/pret/pmd-red) (décompilation PMD Red Rescue Team, GBA), clonée et analysée localement.
Outils produits : `tools/convert_pmdred_ground.py` (+ bibliothèque de décodage `/tmp/pmdred_extract/pmdred_lib.py`, transcrite du C de référence).

## Étape 1 — Extraction : décodeurs validés

| Format | Méthode | Statut |
|---|---|---|
| `.bpl` (palettes) | Décodeur maison d'après `src/ground_bg.c` : `numPalettes` en tête, 15 couleurs RGBA/palette, index 0 transparent | ✅ validé (D13P03 : 10 palettes) |
| `.bpc` (tuiles+chunks) | Décodeur maison : header 16 o, tuiles 4bpp 32 o, chunks 3×3 de u16 `tile|hflip|vflip|palette`. **Le format GBA n'est PAS lisible par skytemple-files** (compression BPC différente du NDS — vérifié : `BPC Image Decompressor` échoue) | ✅ validé (rendu T00P01 = Pokémon Square parfait, voir preview) |
| `.bma` (layout+collision) | Couches chunk-map : décompresseur NRL/XOR transcrit 1:1 de `BmaLayerNrlDecompressor` (stride 64, XOR ligne précédente). Collision : lue via skytemple-files (cette couche est au format commun GBA/NDS) | ✅ validé (les 2 implémentations concordent) |
| `.bpa` (animations) | Non traité (66 fichiers, tuiles animées — hors périmètre du pilote) | ⏳ |

Preuve visuelle : `T00P01_preview.png` (Pokémon Square rendu parfaitement — arbres, maisons, chemins, étangs).

## Étape 2 — Inventaire des zones (245 map file ids, 677 fichiers)

| Catégorie | Nombre | Exemples |
|---|---|---|
| Villes/spéciales (Square, bases, tests…) | 143 | T00P01 (Square), A0xx (intro) |
| Friend Areas | 57 | déjà couvert par le pack Friend Area du projet |
| **Cinématiques de donjon** (forte identité) | **32** | voir table ci-dessous |
| Donjons génériques (D14-D23…) | 13 | fonds d'entrée simples |

Les 32 zones de cinématique (ENTRY/MID/END), croisées avec `src/dungeon_cutscene_*.c` (26 scripts de boss : Rayquaza, Groudon, Kyogre, Ho-Oh, Lugia, Entei, Articuno, Moltres, Zapdos, Mewtwo, Latios, Celebi, Jirachi, Deoxys…) :

Tiny Woods, Thunderwave Cave, Mt. Steel, Sinister Woods, Silent Chasm, Mt. Thunder (3), Great Canyon, Lapis Cave (2), Mt. Blaze (3), Frosty Forest (3), Mt. Freeze (3), **Magma Cavern (3 — arène Groudon)**, **Sky Tower (3 — arène Rayquaza)**, The End.

## Étape 3-4 — Zone pilote convertie : D13P03 → Autel des Cieux

| Champ | Valeur |
|---|---|
| Nom d'origine | `MAP_SKY_TOWER_END` — Sky Tower Summit (arène Rayquaza, `dungeon_cutscene_rayquaza.c`, script `gs209`) |
| Nouveau nom | `autel_celeste` — **« Autel des Cieux »** (arène Lugia, ch10) |
| Fichiers sources | `D13P03.bpl` (10 palettes) / `D13P03c.bpc` (504 tuiles, 230 chunks) / `D13P03m.bma` (69×75 tuiles, collision 1 couche) |
| Fichiers produits | `Content/Tile/Autel_Celeste_Base.tile` (8 px, 5175 cellules) + `Data/Ground/autel_celeste.rsground` (552×600 px) |
| Géométrie | **1:1, aucune transformation** — grille identity-mapped (standard du projet), collision d'origine cellule par cellule (750 walkables = la plateforme ovale du sommet) |
| Positions d'entités | **EXACTES du `GroundLivesData s_gs209`** : héros (37,37), partenaire (32,37), alliés (34,42)/(38,41), boss (34,34), trigger de cutscene (34,35) — tuiles GBA × 8 px. Toutes vérifiées walkables sur la collision d'origine |
| Casting remplacé | Rayquaza → **Lugia** (le duo d'origine → héros+partenaire New Era, alliés → équipiers). Intro 3 couches New Era (Voix → DescendSky → titre), textes FR existants CPB_00x |
| Ajustements techniques | Palette : reprojection RGBA directe (les .bpl stockent déjà du 8 bits/canal). Résolution : **aucun changement de TileSize nécessaire** — le GBA et RogueEssence partagent la même unité de 8 px (`TEX_SIZE=8`) ; la carte est plus grande que l'écran d'origine 240×160 car le jeu scrollait — RogueEssence gère nativement le scroll, aucun XML à modifier |
| Branchement | `celestial_peak` segment 4 → `autel_celeste` (remplace `celestial_peak_boss` composé) ; master_zone idx 78 ; index.idx synchronisé |
| Statut | **Converti — à vérifier en jeu** (réserve ci-dessous) |

### ⚠ Réserve visuelle documentée (honnêteté technique)
La couche visuelle de D13P03 ne référence que le chunk n°1 (plateforme unie) — vérifié par DEUX décodeurs indépendants (le mien + skytemple-files, résultats identiques). Les 229 chunks de nuages du .bpc sont présents mais non référencés par le .bma : dans le jeu d'origine, le décor de nuages est rendu par les couches BG matérielles du GBA (ciel défilant) + animations de palette, pas par la tilemap. Compensation appliquée : fond `Sky` animé défilant de RogueEssence (`Background.BGAnim = Sky`) + fond bleu nuit de la palette d'origine. Le résultat en jeu = plateforme du sommet sur ciel mouvant, fidèle à l'esprit de la scène. Si le rendu est jugé trop nu, les chunks de nuages extraits peuvent servir de décorations (ils sont dans le .tile du catalogue → `D13P03_chunks.png`).

## Étape suivante (industrialisation — sur demande)
Le pipeline est prouvé. Candidats prioritaires (mêmes garanties 1:1) :
1. `D12P04` — Magma Cavern Pit (arène Groudon) → candidat arène pour un donjon volcanique futur (la légende de Dotra ch5 l'a déjà préparée).
2. `D01P01/D01P02` — Tiny Woods (entrée + fond) → biome doux, zones ch1.
3. `D10P01-03` — Frosty Forest → premier biome neige du projet.
4. `T00P01` — Pokémon Square (rendu parfait) → source de décor pour une future bourgade.
Chaque conversion suivra ce même rapport ligne par ligne.
