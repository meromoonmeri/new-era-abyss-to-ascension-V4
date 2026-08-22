# Inventaire canonique Ch.6–32 — vérification au 2026-08-22

Ce fichier remplace l'inventaire `docs/canonical_dungeons/INVENTORY_CH6_CH32.md`
mentionné dans la commande : **ce chemin n'existait pas dans le dépôt**. Les
chiffres annoncés ont donc été recomptés directement sur l'arbre de travail
(commit de base `230800fb`, « Clear chapter 6-32 dungeon substitute data »).

## Chiffres annoncés vs chiffres mesurés

| Élément annoncé | Mesure réelle | Verdict |
|---|---|---|
| 27 routes principales Ch.6–32 | 27 chapitres (6→32) référencés dans `docs/inventaire_donjons.md` ; **aucune** zone principale Ch.6+ n'existe encore dans `Data/Zone` (purge du commit de base) | ✅ compte des chapitres exact, ❌ « routes » **non implémentées** |
| 51 donjons PMD Red | `docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md` : « 51 donjons d'histoire importables (49 à créer + 2 faits) » | ✅ cohérent (planning, pas contenu) |
| 245 Grounds Red archivés | `RESERVE/red_grounds` = **245** fichiers, `RESERVE/red_tiles` = 245 | ✅ exact |
| 23 packages DTEF importés | `Data/AutoTile` = **11 AutoTileData** ; un seul **triplet complet** floor/wall/secondary : `sinister_woods_b41`. Les 8 `apricorn_grove_*` sont des variantes de couleur, pas des triplets DTEF | ❌ **corrigé : 1 package DTEF exploitable, pas 23** |

Autres mesures utiles :

| Ressource | Compte |
|---|---|
| `Data/Zone/*.json` | 44 (43 avant génération + `gloomy_forest`) |
| `Data/Ground/*.rsground` | 419 |
| `Data/Map/*.rsmap` | 60 |
| `Data/Item/*.json` | 239 |
| `RESERVE/zones` | 199 |
| `RESERVE/sky_grounds` | 467 |

## Conséquences pour le Dungeon Builder

1. **Le DTEF est le goulot d'étranglement réel**, pas la génération. Un donjon
   ne peut être généré avec son identité visuelle propre que si son triplet
   `<biome>_floor` / `_wall` / `_secondary` est importé dans `Data/AutoTile`.
   `tools/dungeon_builder.py audit` liste à tout moment les packages
   disponibles, et `generate` **refuse** d'écrire une zone dont le tileset
   n'est pas importé (aucun partage aveugle de tileset entre deux donjons).
2. Sinister Woods est le seul donjon Ch.6–32 immédiatement générable
   aujourd'hui (`sinister_woods_b41` importé, Ground de fin canonique
   `sinister_woods_clearing` présent).
3. Les donjons hors périmètre (Aegis Cave / `cloven_ruins`) ne sont pas
   touchés : aucun fichier de ces zones n'est modifié, et un test de
   non-régression le vérifie.

## Périmètre restant (à traiter donjon par donjon)

Pour chaque donjon Ch.6–32, l'ordre de travail imposé par cet inventaire est :

1. importer/retexturer le package DTEF du biome (pipeline existant) ;
2. écrire `DungeonDefs/canonical/<donjon>.json` (source Bulbapedia adaptée) ;
3. `dungeon_builder preview` puis `validate` ;
4. vérifier le Ground de fin : s'il existe, le combat final s'y déroule ; sinon
   créer le `.rsmap` d'arène dédié **puis** le convertir en Ground ;
5. `dungeon_builder generate` + rapport.
