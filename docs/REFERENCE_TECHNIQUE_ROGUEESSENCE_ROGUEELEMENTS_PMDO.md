# Référence technique — RogueEssence, RogueElements et PMDO

> Base de travail persistante pour les chantiers de donjons, scènes, VFX et combat.  
> Relevé effectué le 23 août 2026 à partir des dépôts RogueEssence, RogueElements,
> PMDOTutorial, PMDOWiki, RawAsset et de ce dépôt. Les sources externes ont été
> consultées dans un clone de travail temporaire : elles ne sont pas embarquées dans
> le mod.

## 1. Carte mentale de la chaîne

| Couche | Responsabilité | Où intervenir ici |
|---|---|---|
| **RogueElements** | Bibliothèque C# générique : plans, RNG, pipeline de `GenStep`, rooms, halls, eau, placement. Elle ne connaît ni Pokémon ni Lua. | Types sérialisés dans les JSON de `Data/Zone/*.json` ; extension C# seulement dans une build moteur/PMDC. |
| **RogueEssence** | Moteur : scènes, données, rendu, maps, transitions, Lua, sérialisation. Il consomme une zone et rend le `MapGenContext` produit. | `Data/Zone`, `Data/Ground`, `Data/Script`. |
| **PMDC** | Couche Pokémon sur RogueEssence : équipes, combats, statuts, spawners et steps PMDC (p. ex. `SaveVarsZoneStep`). | IDs de données et types `PMDC.*` sérialisés dans les zones. |
| **PMDODump / DumpAsset** | Données et assets réutilisables, pas du code de gameplay. | Chercher avant de créer un tileset, un portrait, un son ou une table. |
| **RawAsset TileDtef / swablu** | Sources et conversion des auto-tiles PMD. | À utiliser pour importer/transformer un tileset, jamais pour « peindre » les coins à la main. |

La direction de dépendance est donc : **données JSON/Lua du mod → PMDC/RogueEssence → RogueElements**. Une scène Lua n'appelle normalement pas `GenStep` directement : elle demande au moteur d'entrer dans une zone, qui lit son segment et exécute le pipeline.

---

## 2. RogueEssence : modèle d’exécution

### Ground, Zone, Segment et Dungeon

- Un **Ground** est une carte fixe `.rsground`, avec entités nommées, triggers et cycle Lua `Init → Enter → Update → Exit`. Ses scripts sont sous `Data/Script/halcyon/ground/<map>/`; le chargeur de map appelle les callbacks de `LuaEngine`.
- Une **Zone** est le conteneur de voyage déclaré dans `Data/Zone/<id>.json`; elle contient des **segments**. Un segment peut exposer une ground map ou un donjon.
- Un **Dungeon** est un étage runtime (`DungeonMap`) issu d'un `FloorGen` de segment ou d'un `LoadGen`. Chaque étage a ses callbacks de donjon et est rendu par `DungeonScene`.
- Une **ground map** ne devient accessible que si son fichier existe **et** si la zone le déclare. Inversement, un segment doit être déclaré avant d'être référencé par une transition.

### Boucle et transitions

Dans le moteur, `GameManager.ScreenMainCoroutine()` délègue l'entrée à `CurrentScene.ProcessInput()`, puis exécute `SceneOutcome`. `MoveToZone(ZoneLoc)` quitte la scène courante, initialise/déplace la zone lorsque nécessaire, entre le segment, puis initialise la scène destination. `MoveToGround(...)` est l'autre voie de déplacement, adaptée à la ground cible.

Conséquences pratiques :

1. `GAME:EnterGroundMap(map, entry)` ne traverse pas de zone : même zone seulement.
2. Une destination de zone/segment utilise `GAME:EnterZone(...)` ou le helper de fin de run.
3. Une transition narrative doit faire `FadeOut`, attendre les frames nécessaires, puis entrer dans la map. Le code postérieur à un appel Lua manquant ne s'exécute jamais.
4. Le moteur est coroutine-first : les API Lua qui attendent (`WaitShowDialogue`, `WaitFrames`, déplacements) doivent rester dans le flot de coroutine; les actions parallèles passent par `TASK:BranchCoroutine` puis `JoinCoroutines`.

### Lua, données et sauvegarde

- `LuaEngine` fabrique les noms de callbacks pour zones, maps ground, étages et événements d'entité. Il charge les modules Lua et les appelle sous protection : une erreur peut interrompre le callback sans rendre le diagnostic visuel évident.
- `DataManager` indexe/charge les assets et données (notamment les index et JSON). L'ID d'un asset n'est donc pas une garantie d'existence : vérifier son entrée et le fichier correspondant.
- `SV` est une table Lua sauvegardée. `scriptvars.lua` fournit le schéma par défaut de nouvelle partie; une valeur ajoutée sans défaut est fragile pour une sauvegarde ancienne. Les lectures doivent donc tolérer `nil` (`SV.ChapterX.Flag or false`).
- Le rendu de dialogue combine `MenuManager`, `DialogueBox` et `SpeakerPortrait`. `UI:SetSpeaker(ch)` suppose que le portrait de l'espèce est disponible; sinon utiliser `UI:ResetSpeaker()` ou fournir l'asset.

### Convention Lua réelle de ce dépôt

`Data/Script/halcyon/main.lua` est persistant et charge les services globaux. Chaque `ground/<map>/init.lua` doit explicitement `require` les modules de chapitre qu'il appelle; les init de zone font de même pour la logique de segment. La preuve locale est `ground/altere_pond/init.lua`, qui importe `altere_pond_ch_1` à `_ch_5` puis route `PlotScripting()` selon `SV.ChapterProgression.Chapter`.

**Règle de débogage :** partir de l'appel fautif → fichier qui définit la fonction → `require` qui le rend visible → module persistant si nécessaire. Ne jamais corriger uniquement la ligne de l'appel avant d'avoir vérifié cette chaîne.

---

## 3. RogueElements : le pipeline réellement consommé

### Contrat central

`IGenContext` fournit le RNG (`Rand`), `InitSeed(ulong)` et `FinishGen()`. Les contextes spécialisés ajoutent les capacités nécessaires : tuiles (`ITiledGenContext`), plans de rooms (`IFloorPlanGenContext`), placements (`IPlaceableGenContext<T>`), etc.

Un `GenStep<T>` possède `Apply(T map)`. Son adaptation non générique vérifie le type réel du contexte (`CanApply`) puis appelle cet `Apply`; un contexte incompatible lève une exception. Cela explique pourquoi le type générique sérialisé d'un step est important : un step de `MapGenContext` ne se branche pas arbitrairement sur un `ListMapGenContext`.

Un `MapGen<T>` est une collection ordonnée `priority → GenStep`. Les priorités basses sont exécutées avant les hautes; à priorité égale, ne pas dépendre d'un ordre implicite sans l'avoir vérifié dans le moteur. Chaque step **mutile le même contexte**, qui porte successivement plan de grille, plan de rooms, tuiles, entrées/sorties et objets.

### Étage vide → étage jouable (grille classique)

1. **Métadonnées** : `MapDataStep` prépare musique, tileset, états et paramètres de map.
2. **Grille** : `InitGridPlanStep` crée les cellules; un `GridPathBranch`/autre path décide cellules actives, connexions, probabilités de rooms et halls.
3. **Plans** : `DrawGridToFloorStep` matérialise le graphe en `FloorPlan` de rooms/halls; les `RoomGen` choisissent dimensions/forme et les halls les relient.
4. **Tuiles** : `DrawFloorToTileStep` dessine le plan en terrain sol/mur dans le contexte tiled.
5. **Post-traitement** : eau/lave avec `PerlinWaterStep`, nettoyage des diagonales/îlots, décor et états de terrain. Il faut le faire avant les placements qui exigent des cases libres.
6. **Navigation** : `FloorStairsStep<TContext,TEntrance,TExit>` place entrée et sortie. C'est **le step des escaliers**. Il est room-aware : il prélève des tuiles libres dans des rooms et écarte les rooms adjacentes jusqu'à `MinDistance`. Dans ce projet, il est suivi de `DetectIsolatedStairsStep` pour détecter une sortie isolée/non viable.
7. **Spawns** : les tables ont déjà été injectées par les Zone Steps; les Gen Steps de spawn les répartissent sur des cases libres. `RandomSpawnStep` tire une case de `GetAllFreeTiles()`, place puis retire la case de la liste : deux objets ne se superposent pas par accident.
8. **Validation** : relancer plusieurs seeds, inspecter connectivité, escalier atteignable, nombre de spawn et l'absence de salles répétitives/non jouables.

### Étude de l’exemple SkyTemple

`rogueelements-pmd-asp` démontre un adaptateur minimal : son `MapGenContext` implémente `ITiledGenContext` et `IRoomGridGenContext`, porte `Map`, `FloorPlan`, `GridPlan` et le RNG. Son pipeline est : `InitGridPlanStep(-4)` → `GridPathBranch(-4)` → `DrawGridToFloorStep(-2)` → `DrawFloorToTileStep(0)` → `PerlinWaterStep(3)` → nettoyage `(4)`.

Il sert à générer et formater une carte web de fond. Divergences essentielles avec PMDO : pas de `ZoneData`, pas de segments/Zone Steps, pas de `MapGenEntrance/Exit` ni `FloorStairsStep`, pas de spawners Pokémon/objets, pas de Lua, ni rendu auto-tile RogueEssence. C'est un bon exemple de contrat `IGenContext`, **pas** un JSON PMDO à recopier.

---

## 4. Floor Gen vs Zone Step : décision rapide

| Règle demandée | Brique correcte | Pourquoi |
|---|---|---|
| Taille/forme des rooms, halls, eau, décor d'un étage | **Floor Gen / GenStep** | Modifie un contexte d'étage concret. |
| Escalier, sortie, contrôle d'isolement | **Floor Gen** (`FloorStairsStep`, puis vérification) | La position dépend de la géométrie de cet étage. |
| Biome/tileset/musique variant sur une tranche précise | **Floor Gen** (ou floors distincts) | Paramètre visuel/map propre aux étages visés. |
| Table d'espèces niveaux 10–60 | **`TeamSpawnZoneStep`** | Table partagée avec plages de floors; les steps d'étage la consomment. |
| Table objets, pièges, argent | **Zone Steps** de spawn | Même logique de table globale/plages; les Gen Steps répartissent les occurrences. |
| Nom « B{0}F », sauvetages | **Zone Step** | Convention appliquée à tout le segment. |
| Ressource garantie tous les 3–4 floors, midpoint tous les 5 | **`SpreadStepZoneStep` / SpreadPlan** | Le choix doit connaître la série d'étages entière pour espacer et éviter les collisions. |
| Segments de 10 étages / progression de difficulté | **Segment + Zone Steps + ranges** | C'est une politique inter-étages; les floors reçoivent le résultat. |
| Boss fixe / salle-arène | **`LoadGen` ou GenStep d'étage**, éventuellement spread par Zone Step | Layout fixe et placements sont locaux; le choix de l'étage peut être global. |

Les Zone Steps ne « dessinent » pas une map : ils injectent/configurent des steps dans le pipeline normal des floors, pour tous les étages ou une plage. Préférer un Zone Step quand la règle doit être cohérente à l'échelle du segment.

---

## 5. Validation sur le dépôt New Era

### Exemple de Floor Generation Step

`Data/Zone/chasm_cave.json` contient des `GridFloorGen` et, dans leurs `GenSteps`, notamment :

- `RogueElements.GridPathBranch<RogueEssence.LevelGen.MapGenContext>` ;
- `RogueElements.FloorStairsStep<MapGenContext, MapGenEntrance, MapGenExit>` ;
- `RogueElements.DetectIsolatedStairsStep<...>`.

C'est donc un exemple local concret du pipeline par étage et de la réponse à « quel step place les escaliers ? » : `FloorStairsStep`, pas une table de spawn.

### Exemple de Zone Step

Le même fichier déclare au niveau de `LayeredSegment.ZoneSteps` : `PMDC.LevelGen.SaveVarsZoneStep`, `FloorNameDropZoneStep`, `MoneySpawnZoneStep`, `ItemSpawnZoneStep` et `TileSpawnZoneStep`. Ils décrivent données/politiques disponibles aux floors.

`Data/Zone/cloven_ruins.json` montre aussi un `SpreadStepRangeZoneStep` avec `SpreadPlanSpaced` (espacement 2–4 sur un range 0–6) qui injecte un `ScriptGenStep<ListMapGenContext>`. C'est un exemple local de politique inter-étages, distincte des `ScriptGenStep<MapGenContext>` contenus dans les floors de la même zone.

### Exemple SV + événement

- Schéma : `Data/Script/halcyon/scriptvars.lua` initialise `SV`, les sous-tables communes (`General`, `checkpoint`, `adventure`, etc.) puis les tables de chapitre `SV.Chapter1` à `SV.Chapter11`.
- Chargement : `Data/Script/halcyon/ground/altere_pond/init.lua` requiert explicitement le script du chapitre 4.
- Événement : `ground/altere_pond/altere_pond_ch_4.lua:Relicanth_Action` utilise `SV.Chapter4.SpokeToRelicanthDayOne`, affiche le premier dialogue, puis met le flag à `true`; les interactions suivantes passent dans la branche alternative.

La signification opérationnelle des familles SV est : `ChapterProgression` = chapitre courant; `ChapterN` = jalons narratifs durables de N; `adventure` = état du run courant; `checkpoint` = retour/position; `partner` = état de spawn/dialogue allié; `Services` = état appartenant à un service. Une nouvelle variable doit rejoindre la sous-table qui correspond à sa durée de vie.

---

## 6. DTEF, DumpAsset et recherche d’assets

### Auto-tile DTEF

Un DTEF encode les variantes nécessaires à une tuile selon son voisinage (les 256 combinaisons d'adjacence mentionnées par le pipeline). Le générateur choisit la variante à partir des voisins sol/mur/eau/lave/vide : on peint donc le **terrain logique**, pas les coins et bordures finaux à la main. Peindre une transition isolée casse l'auto-tiling dès que le voisinage change.

RawAsset fournit des dossiers par biome. Exemple vérifié : `RawAsset/TileDtef/AmpPlains/` contient `tileset_0.png`, `tileset_1.png`, `tileset_2.png`, `tileset_more.png` et des images nommées `tileset_0_frame{animation}_{index}.{palette}`. Les frames sont les variantes/animations extraites : elles sont des sources de conversion, pas des tuiles à poser une par une.

`swablu` est l'outil de conversion/import-export autour de ces sources et du format de tileset; le DTEF brut est le catalogue/encodage des variantes. Dans une chaîne saine : source DTEF → conversion/outillage swablu → asset de tileset du moteur → terrain logique dessiné par la génération/éditeur.

### Procédure de réutilisation

1. Chercher d'abord le **nom de biome** dans DumpAsset (`Tile`, `Tileset` suivant la version) puis RawAsset `TileDtef/<Biome>/`.
2. Vérifier les animations/palettes et les IDs attendus avant import.
3. Pour sprites/portraits : inspecter le catalogue DumpAsset et confirmer la présence dans `Content/Portrait` avant `UI:SetSpeaker`.
4. Pour audio : vérifier l'ID/fichier OGG dans le catalogue contenu avant de le référencer.
5. Pour une zone canonique : chercher les données PMDODump/Docs et les release notes, puis adapter les IDs à la version PMDC réellement embarquée; ne pas copier un type JSON d'une version incompatible.

---

## 7. Laboratoire de validation (hors production)

Les exercices sont consignés dans `docs/training/` et ne sont ni chargés par `main.lua`, ni indexés comme contenu de jeu.

1. **Donjon minimal 3 floors** : le fichier C# de laboratoire construit le pipeline rooms/halls → tiles → escaliers → spawns, avec seeds reproductibles. Il documente les interfaces attendues et l'ordre sûr de priorité. Il est destiné à être compilé avec une référence vers la même révision de RogueElements que le moteur.
2. **Événement SV** : le Lua de laboratoire est un NPC conditionnel minimal et sa procédure d'intégration explicite prouve la chaîne `scriptvars → require init → callback`.
3. **Distinction validée sur code réel** : les deux exemples de la section 5 identifient un `FloorStairsStep` local et un `SpreadStepRangeZoneStep` local.
4. **DTEF localisé** : `RawAsset/TileDtef/AmpPlains/`, structure de dossier et rôle des frames détaillés en section 6.

La sandbox ne fournit pas `dotnet` (commande absente au relevé). Le laboratoire C# n'a donc pas été compilé ici; son exécution doit être faite dans une installation de développement RogueEssence/PMDC avec le SDK .NET correspondant. Ce n'est pas une raison pour intégrer le test dans le contenu du mod.

---

## 8. Réponses flash de diagnostic

- **« Quel step place les escaliers ? »** — `RogueElements.FloorStairsStep<TContext,TEntrance,TExit>`; il est room-aware et `MinDistance` écarte entrée/sortie. Ajouter/vérifier `DetectIsolatedStairsStep` pour la jouabilité.
- **« Où sont les spawn tables ? »** — au niveau `Segments[n].ZoneSteps`, dans `TeamSpawnZoneStep`, `ItemSpawnZoneStep`, `MoneySpawnZoneStep`, `TileSpawnZoneStep`; les steps de floor les consomment/répartissent.
- **« Comment `IGenContext` est consommé ? »** — le générateur initialise son seed, exécute les `GenStep` triés; chaque `GenStep<T>.Apply(IGenContext)` vérifie/caste vers `T`, puis mute le même contexte. Les interfaces supplémentaires garantissent les capacités (tuiles, rooms, placement).
- **« Quelle SV employer ? »** — flag narratif durable : `SV.ChapterN`; progression générale : `SV.ChapterProgression`; temporaire du run : `SV.adventure`; retour : `SV.checkpoint`; partenaire : `SV.partner`; service : `SV.Services`. Toujours initialiser dans `scriptvars.lua` et lire avec fallback si la sauvegarde peut être ancienne.
- **« Écran noir / nil value après une scène ? »** — vérifier d'abord callback Lua, `require` explicite, existence d'ID/map/segment, puis l'ordre FadeOut → attente → transition; ne pas supposer que la ligne après l'erreur a tourné.
