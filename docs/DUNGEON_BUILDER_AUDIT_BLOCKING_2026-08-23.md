# Audit bloquant — Dungeon Builder canonique

**Date :** 2026-08-23  
**Statut :** `BLOCKED_BEFORE_IMPLEMENTATION`  
**Portée :** audit des systèmes existants et de leurs contrats; aucune zone,
Ground ni génération de production n'a été modifiée.

## Résumé de décision

Le dépôt contient déjà trois familles de systèmes qui recouvrent partiellement
la mission. Créer immédiatement un nouveau « Dungeon Builder » serait une
duplication risquée et violerait la contrainte d'orchestrer RogueElements plutôt
que de le remplacer.

1. **Source de vérité PMD Red déjà extraite.**
   `docs/canonical/red/dungeon_floor_reference.json` et
   `docs/canonical/red/DUNGEON_RESTORATION_AUDIT.md` recensent **64 ensembles,
   1 767 floors**, pas « 51 donjons » : les chiffres du brief doivent donc être
   remplacés par cet inventaire vérifiable. Chaque floor conserve les index
   `MainData`, `Pokemon`, `Traps`, `Items`, `KecleonShop`,
   `MonsterRoomItems` et `BuriedItems`.
2. **Registre de scènes déjà présent, volontairement non routable.**
   `docs/canonical_journeys/CANONICAL_JOURNEY_REGISTRY.json` associe 219
   Grounds PMD Red EU, 133 scènes et 27 relations dungeon-backed;
   `PMD_RED_DUNGEON_SCENE_IR.json` représente les actions extraites. Son état
   est explicitement bloqué : aucun des 27 parcours ne doit être déclaré
   achevé/runtime-certifié sans lever ses gates.
3. **Sinister Woods a déjà une preuve partielle, mais sa cible de production a
   été retirée.** `tools/migrate_pmdred_sinister_woods_generator.py` et
   `docs/canonical/red/sinister_woods_generator_profile.json` sont une base de
   provenance précieuse. Toutefois `Data/Zone/gloomy_forest.json` est absent
   du checkout actuel : le test existant échoue avant toute assertion. Il est
   donc interdit de prétendre reconstruire ou certifier Sinister Woods avant
   d'abord restaurer/identifier la cible active de manière contrôlée.

## État Git et limites d'environnement

- Branche active : `arena/01a02f1c-new-era-abyss-to-ascension-v4`.
- `git fetch origin --prune` a été exécuté avant l'audit. La branche Arena n'a
  pas de branche distante de suivi dans ce clone; aucun `pull` non déterministe
  vers `main` n'a été effectué.
- Le sous-module `external/BIBLIOTHEQUE` est non initialisé.
- Les autorités ROM/runtimes que les scripts attendent sous `.runtime-cache/`
  sont absentes (répertoire ignoré), et `dotnet` n'est pas installé. La preuve
  expérimentale C# / PMDO runtime ne peut donc pas encore être exécutée ici.

## Scan du checkout réel

| Élément | Mesure constatée |
|---|---:|
| Zones actives `Data/Zone` | 44 fichiers |
| Grounds actifs `Data/Ground` | 419 fichiers |
| Maps actifs `Data/Map` | 60 fichiers |
| Tiles actifs `Content/Tile` | 969 fichiers |
| Fichiers en réserve | 2 860 |
| Zones PMD Red dans la matrice canonique | 64 ensembles / 1 767 floors |
| Grounds Red EU certifiés du registre | 219 |
| Relations dungeon-backed du registre | 27 |

Les 44 zones actives incluent entre autres `mt_blaze`, `mt_freeze`,
`frosty_forest`, `lapis_cave`, `wish_cave`, `chasm_cave`, `searing_tunnel` et
`cloven_ruins`. Les réserves contiennent des Grounds nommés et des imports
`RESERVE/pmdred_direct`, mais une réserve n'est pas un asset runtime : elle doit
être référencée par une définition et une zone déclarées avant utilisation.

## Contrats réellement disponibles

### RogueElements (génération native)

Le code source vérifié fournit des contextes et steps réutilisables :

- `IGenContext` = RNG, `InitSeed`, `FinishGen`; `GenStep<T>` vérifie/caste le
  contexte avant `Apply`.
- Plans/connexions : `InitGridPlanStep`, `GridPathBranch`, `GridPathCircle`,
  `GridPathCross`, `GridPathTwoSides`, `GridPathGrid`,
  `DrawGridToFloorStep`, `DrawFloorToTileStep`, `ConnectBranchStep`,
  `ConnectStep`, `AddConnectedRooms*`.
- Rooms/halls disponibles dans la version embarquée : `RoomGenSquare`,
  `RoomGenRound`, `RoomGenCross`, `RoomGenCave`, `RoomGenBump`,
  `RoomGenAngledHall`, plus les extensions PMDO `RoomGenTriangle`,
  `RoomGenPlus`, `RoomGenDiamond` et `RoomGenCoated`.
- Sécurité : `FloorStairsStep` (placement room-aware avec distance),
  `DetectIsolatedStairsStep`, `NoChokepoint*`, nettoyage d'îlots et diagonales.
- Terrain : `PerlinWaterStep`, `BlobWaterStep`, stencils, `DropDiagonalBlockStep`
  et `EraseIsolatedStep`.
- Spawn : `RandomSpawnStep`, `RandomRoomSpawnStep`, `TerminalSpawnStep`,
  `DueSpawnStep`, `TerrainSpawnStep`.

**Conclusion :** ces fonctionnalités doivent être assemblées dans des JSON PMDO
par profil. Un algorithme Python qui dessine son propre graphe de rooms ne doit
pas être utilisé pour les floors procéduraux de production.

### RogueEssence / PMDC (adaptation de jeu)

Le moteur apporte `GridFloorGen<MapGenContext>`,
`RoomFloorGen<ListMapGenContext>` et `LoadGen<MapLoadContext>`. Les types
réellement sérialisés dans les zones de ce dépôt montrent que PMDC apporte déjà
les features demandées : `ShopStep`, `MonsterHouseStep`, `MonsterHallStep`,
`ChestStep`, `SpreadVaultZoneStep`, `SpreadHouseZoneStep`, `SpreadBossZoneStep`,
`KeySealStep`, `SwitchSealStep`, `TerrainSealStep`, `BossRoom`,
`MapDataStep`, états de météo, et les spawners d'équipes/objets.

Les tables globales sont des Zone Steps (`TeamSpawnZoneStep`,
`ItemSpawnZoneStep`, `MoneySpawnZoneStep`, `TileSpawnZoneStep`); les placements
par floor les consomment. Les policies inter-floor sont des Spread/Range Zone
Steps. Les scènes fixes doivent passer par `LoadGen` / Ground et non être
transformées en GridFloorGen.

### DTEF / assets

Le dépôt contient déjà une filière de tiles : `tools/dungeon_pack/tiledtef/`,
`tools/mapgen/extract_tileset_db.py`, `Data/AutoTile/`, `Content/Tile/` et les
réserves Raw/PMD Red. Le namespace isolé Sinister Woods existe (`SinisterWoodsB41`
et les trois AutoTiles `sinister_woods_b41_{floor,wall,secondary}`). Un Builder
ne doit pas convertir ni peindre lui-même les 256 cas DTEF : il doit résoudre
un binding source/tileset/AutoTile et valider que les trois couches existent.

## Systèmes existants : réemploi vs interdiction

| Système | Valeur | Décision |
|---|---|---|
| `tools/migrate_pmdred_sinister_woods_generator.py` | Lecture des 28 octets `FloorProperties`, provenance, adaptation explicite GridFloorGen, distinction floor fixe | **Réemployer/refactorer** comme premier adaptateur source, après restauration de cible. |
| `docs/canonical/red/dungeon_floor_reference.json` | Inventaire et index de tables Red | **Réemployer** comme registre de données primaire. |
| `docs/canonical_journeys/*` | Registry Ground/scène/provenance et gates | **Réemployer sans contourner**; compléter seulement ses liens prouvés. |
| `tools/gen_future_dungeons.py` | Émet des JSON PMDO natifs et steps existants | **Réemployer les serializers/patterns**, pas ses valeurs hard-codées comme canon. |
| `tools/smart_dungeon/` | Designer de plans/grounds Python, previews, scoring | **Ne pas employer pour les floors procéduraux canoniques** : il compose son propre layout, donc c'est un moteur parallèle au regard de la mission. Peut rester un outil de concept Ground isolé. |
| `tools/mapgen/` | Générateurs/cartes et base tileset existants | **Ne pas employer comme générateur de dungeon runtime**; uniquement inventaire/visualisation si son output est vérifié. |

## Blocages à lever avant la phase prototype

1. **Rétablir une autorité de runtime isolée :** checkout PMDO/RogueEssence
   compatible, SDK .NET et les sources ROM déjà prévues par les scripts, hors
   du contenu du mod.
2. **Résoudre la régression de cible Sinister :** le profil et les tests ciblent
   `gloomy_forest`, absent de `Data/Zone`. Il faut soit restaurer cette zone
   depuis l'autorité archivistique, soit modifier les métadonnées/probes via une
   migration documentée. Ne jamais créer une zone vide homonyme pour faire
   passer un test.
3. **Distinguer l'inventaire de production :** les 64 ensembles Red sont une
   matrice de source, pas 64 zones déjà prêtes. Les 27 journeys ont des gates
   `BLOCKED`; leur état interdit un batch massif.
4. **Faire passer un prototype isolé PMDO réel :** 20–50 floors, minimum deux
   profils natifs, 10 seeds chacun, métriques de graphes et screenshots/runtime
   afin de vérifier ce que la version exacte de RogueElements fait réellement.

## Suite approuvée

La prochaine modification doit être **uniquement l'Étape 2** : un harness
isolé, sous un chemin non chargé, qui génère/observe des JSON `GridFloorGen`
avec les types natifs ci-dessus et produit signatures topologiques + rapports.
Il ne doit écrire ni `Data/Zone`, ni `Data/Ground`, ni index. Après preuve
runtime, l'Étape 3 peut encapsuler les sources déjà existantes dans un registre
de définitions; le Builder final sera un orchestrateur de données et de
serialisation PMDO, pas un générateur de géométrie Python.
