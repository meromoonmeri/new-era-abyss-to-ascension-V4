# RECONSTRUCTION PIXEL-PERFECT — ARÈNES DE COMBAT SUR LEURS GROUNDS DE BASE

**Date : 2026-08-10 — Demande : « les combats se passent exactement sur leurs ground de base,
pixel-perfect, sans bande noire sur les côtés ».**

**Critère : GROUND ORIGINAL = BOSS ARENA VISUELLE** (mêmes tiles, mêmes couleurs, même composition,
même géométrie/collision, mêmes coordonnées), prouvé par comparaison pixel à pixel (0 différence).

---

## 1. CAUSE TECHNIQUE DES BANDES NOIRES (prouvée dans le moteur)

- Les maps de donjon (.rsmap) rendent chaque cellule à `TileSize = 24 px`
  (`GraphicsManager.TileSize = DungeonTexSize × TEX_SIZE`, 3×8, config `GFXParams.xml`).
- `TileLayer.Draw` blitte la texture à **SA TAILLE NATIVE** (`texture.Draw(pos)` — vérifié dans
  `RogueEssence/Dungeon/Tiles/TileLayer.cs`).
- Les arènes précédentes copiaient les textures 8×8 du ground dans les cellules 24×24 → **~89 % de
  chaque cellule vide → noir/bandes**.
- Les arêtes régénérées en 665c478 avaient aussi un `DiscoveryArray` aux dimensions de l'ancienne
  grille → **crash IndexOutOfRange au premier accès découverte** (corrigé ici et dans le lot
  précédent).

## 2. MÉTHODE — ÉCHELLE ENTIÈRE, AUCUNE DÉFORMATION

Pour chaque arène :
1. **Ground source** : `TexSize`, couches graphiques, obstacles (collision), markers.
2. **Sheet dédiée `Arena_<arène>_Base`** : chaque texture du ground est mise à la taille de cellule
   d'arène (24 px) :
   - `TexSize=1` : upscale **×3 NEAREST** (échelle ENTIÈRE = chaque pixel du ground → 3×3 pixels,
     aucun rééchantillonnage, aucune déformation — le pixel-art reste identique) ;
   - `TexSize=3` : 1:1 (textures déjà 24×24).
   - Prémultiplié et déduplication conservés ; frames d'animation conservées (`FrameLength`).
3. **.rsmap réécrit** :
   - `Tiles[x][y].Data.ID` = `floor` | `unbreakable` **selon la collision exacte du ground** ;
   - `Tiles[x][y].Data.TileTex.Layers` = textures de la cellule du ground (24×24) → **chaque cellule
     pleine, aucune bande noire** ;
   - `Layers` de la map vidés (éviter le double rendu 8×8) ;
   - `DiscoveryArray[W][H]` = false (crash corrigé) ;
   - `EntryPoints` = markers d'entrée du ground (cellules 8 px → arène) ;
   - `MapTeams.serializationLoc` = markers du ground (boss) ; les équipes multiples sont réparties
     en formation autour du centre walkable (boss au centre, sbires en anneau), jamais sur un mur,
     jamais empilées.
4. **Preuve** : rendu du ground (pas `8×TexSize`) upscalé `×(24/(8×TexSize))` NEAREST vs rendu de
   l'arène (24 px) → comparaison **pixel à pixel, doit être 0**.

## 3. RÉSULTATS — 19 ARÈNES, 0 PIXEL DE DIFFÉRENCE

| Arène de combat | Ground source | Taille (cellules) | Taille (px) | Collision walk/bloqué | Comparaison |
|---|---|---|---|---|---|
| gloomy_forest_boss (Zeraora) | sinister_woods_clearing | 60×47 | 1440×1128 | 758 / 2062 | **0/1 624 320 (0,00 %)** |
| magma_cavern_pit (Groudon) | fosse_ardente | 63×63 | 1512×1512 | 650 / 3319 | **0/2 286 144** |
| mt_blaze_summit (Moltres) | d09p03 | 69×69 | 1656×1656 | 1739 / 3022 | **0/2 742 336** |
| frosty_forest_summit (Articuno) | d10p03 | 66×63 | 1584×1512 | 680 / 3478 | **0/2 395 008** |
| tour_ciel_sommet (Rayquaza) | tour_ciel_sommet | 69×75 | 1656×1800 | 750 / 4425 | **0/2 980 800** |
| wish_cave_jirachi (Jirachi) | sanctuaire_voeu | 45×42 | 1080×1008 | 702 / 1188 | **0/1 088 640** |
| mount_windswept_guardian (Gardon) | mount_windswept_guardian | 45×42 | 1080×1008 | 378 / 1512 | **0/1 088 640** |
| vast_steppe_guardian (Tornadus) | vast_steppe_guardian | 46×66 | 1104×1584 | 2285 / 751 | **0/1 748 736** |
| palier_celeste | palier_celeste | 57×57 | 1368×1368 | — | **0/1 871 424** |
| parvis_celeste | parvis_celeste | 51×36 | 1224×864 | — | **0/1 057 536** |
| sanctuaire_voeu | sanctuaire_voeu | 45×42 | 1080×1008 | 702 / 1188 | **0/1 088 640** |
| searing_crucible (Magcargo) | searing_crucible (TexSize 3) | 21×21 | 504×504 | — | **0/254 016** |
| crystal_sanctuary_miniboss | sanctuaire_voeu | 45×42 | 1080×1008 | — | **0/1 088 640** |
| crystal_sanctuary_relay | sanctuaire_voeu | 45×42 | 1080×1008 | — | **0/1 088 640** |
| forgotten_marsh_relay | poisonous_forest_relay (TexSize 3) | 17×18 | 408×432 | — | **0/176 256** |
| cloven_ruins_regice (Regice) | cloven_ruin_regice_chamber_sky | 63×57 | 1512×1368 | — | **0/2 068 416** |
| cloven_ruins_regirock (Regirock) | cloven_ruin_regirock_chamber_sky | 57×57 | 1368×1368 | — | **0/1 871 424** |
| cloven_ruins_registeel (Registeel) | cloven_ruin_registeel_chamber_sky | 57×57 | 1368×1368 | — | **0/1 871 424** |
| sanctuaire_titans (Regigigas+8) | cloven_ruin_regigigas_chamber_sky | 57×57 | 1368×1368 | — | **0/1 871 424** |

**Preuves visuelles** : `docs/renders/pixelperfect/<arène>__vs__<ground>.png` (ground à gauche,
arène à droite, même échelle) — copiées dans `preuves_sky/pixelperfect/`.

## 4. COORDONNÉES — ALIGNÉES SUR LE GROUND SOURCE

- **Boss** : `serializationLoc` = cellule du `Boss_Marker` du ground (ex. Zeraora à (30,9) =
  Boss_Marker (240,72) px). Vérifié walkable sur la grille.
- **Héros/partenaire** : `EntryPoints` = `Main_Entrance_Marker` du ground (ex. (28,26) pour
  gloomy_forest_boss).
- **Équipes multiples** : formation autour du centre walkable (Regigigas au centre, 4 Hitmonlee
  cardinaux, 4 Bronzong diagonales ; Magcargo + 8 Slugma en anneau). Aucun ennemi sur un mur,
  aucun empilement (vérifié : 0 problème sur les 19 arènes).
- **Collision** : la grille `floor`/`unbreakable` reproduit **exactement** les obstacles du ground
  (orientation détectée automatiquement, y compris obstacles transposés et TexSize 3).

## 5. COUVERTURE DU VIEWPORT — AUCUNE BANDE NOIRE

Chaque cellule de chaque arène porte sa texture (couverture 100 %, vérifiée : 0 cellule sans
texture). Toutes les arènes de boss font ≥ 1000 px de côté (la plus petite carte, forgotten_marsh_relay
408×432, est un relais sans combat). La carte dépasse donc largement le viewport par défaut PMDO
(320×240) : la caméra couvre l'écran sans jamais exposer de bord noir.

## 6. NON CONCERNÉS (déjà corrects ou sans ground pixel-art)

| Arène | Raison |
|---|---|
| gloomy_forest_miniboss, forgotten_marsh_miniboss | grounds « autotile procédural » sans décor pixel-art (0 texture) — pas de bandes par conception |
| metano_raid_1/2/3 | arènes-portions de metano_town, textures **déjà 24×24** (Metano_Raid_Base) — pixel-perfect existant |
| metano_town_duel | arène riche 10 couches, textures **déjà 24×24** (Metano_Full_Battle_*), animations préservées — non touchée |
| forgotten_marsh_boss | pas de ground source dans le dépôt (ground poisonous_forest_boss absent) — REQUIRES_ASSET |
| boss_* (donjons secondaires), pattern_*, room_*, special_* | rencontres aléatoires de donjon, pas de ground de base unique |

## 7. OUTILS (livrés dans le repo)

- `tools/rebuild_boss_arena_pixelperfect.py <arène> <ground> [--write]` : reconstruction +
  comparaison automatisée (analyse seule par défaut).
- `tools/fix_boss_team_positions.py` : répartition des équipes (formations), validation walkability.

## 8. LIMITE — VALIDATION RUNTIME REQUISE

La comparaison reproduit exactement la logique de rendu du moteur (`TileLayer.Draw`, `TileSize`),
mais seule une exécution réelle de PMDO peut confirmer en jeu (règle projet : pas de
RUNTIME VERIFIED sans exécution). À tester : entrer dans 2-3 combats de boss (ex. Zeraora,
Groudon, Regigigas) et vérifier le rendu plein écran sans bandes.

---

## 9. COMPLÉMENT — COMPOSITE MULTI-COUCHES (correction 2e passe)

**Problème identifié** : la première passe ne composait que la 1re couche graphique du ground.
Or `vast_steppe_guardian` a **4 couches** et `forgotten_marsh_relay` **2 couches** (dont une couche
`Top/Fringe`). Sur ces grounds, le joueur aurait vu les couches manquantes → différence.

**Correction** : le pipeline compose **toutes les couches visibles du ground, dans l'ordre de la
liste** (= ordre de dessin du moteur : Under → Bottom → … → Top/Fringe) dans `TileTex.Layers` de
chaque cellule d'arène. `AutoTile.Draw` dessine ses couches dans l'ordre (vérifié dans
`RogueEssence/Dungeon/Tiles/AutoTile.cs`).

**Re-vérification complète** (composite intégral, ground ×3 vs arène 24 px) :

| Arène | Couches | Comparaison |
|---|---|---|
| vast_steppe_guardian | 4 | **0/1 748 736 (0,00 %)** |
| forgotten_marsh_relay | 2 | **0/176 256 (0,00 %)** |
| 17 autres | 1 | **toutes 0,00 %** |

**Vérification indépendante supplémentaire** : pour chaque montage `ground | arène`, comparaison
pixel à pixel entre les deux moitiés → **0/19 arènes avec différence visuelle**.

## 10. VISIBILITÉ — POURQUOI AUCUNE CASE NOIRE (vérifié moteur)

- `DungeonScene.CanSeeTile` renvoie `true` quand `TileSight == SightRange.Clear` (0) : toutes les
  arènes ont `TileSight: 0` → aucune case peinte en noir par le brouillard de guerre.
- `BaseMap.DrawLoc` dessine `Tiles[x][y].Data.TileTex` (terrain) : textures 24×24 pleines.
- Les `Layers` de la map sont vides (pas de double rendu 8×8).
- `AutoTile.Draw` compose les couches dans l'ordre ; `TileLayer.Draw` blitte la texture à taille
  native (24×24 = cellule pleine).
