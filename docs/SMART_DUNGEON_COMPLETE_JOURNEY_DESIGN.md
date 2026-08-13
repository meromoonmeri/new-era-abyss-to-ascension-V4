# Smart Dungeon Designer — parcours complet et Grounds intelligents

## Audit préalable des modèles du projet

Cette conception précède l'implémentation. Elle interdit une seconde logique
parallèle lorsque le dépôt possède déjà un modèle PMDO fonctionnel.

### Parcours multi-segments et relais

Référence canonique :

- `Data/Zone/searing_tunnel.json` : deux `RangeDictSegment`, puis un
  `LayeredSegment` d'arène ;
- `Data/Ground/searing_tunnel_midpoint.rsground` : Ground médian avec
  `Kangaskhan_Rock`, `North_Exit`, `South_Exit` et entrée ;
- `Data/Script/halcyon/ground/searing_tunnel_midpoint/` : sauvegarde, reprise,
  continuité vers le segment suivant et retour ;
- `Data/Script/halcyon/zone/searing_tunnel/init.lua` : routage
  segment → relais → segment → Ground final → segment de combat ;
- `Data/Script/halcyon/MidpointTemplate.lua` : quatre états de checkpoint et
  séparation structure/habillage.

Contrat retenu : un relais ne consomme jamais un étage procédural. Il sépare deux
segments et reste un Ground reconnaissable mais habillé selon l'évolution du
biome.

### Tables de Pokémon et contenu par tranche

Les `TeamSpawnZoneStep` de `searing_tunnel`, `vast_steppe`, `crooked_cavern` et
`cloven_ruins` prouvent que PMDO sait déjà exprimer :

- espèces et poids ;
- plages `Range.Min/Max` ;
- niveaux `Min/Max` ;
- tailles d'équipes selon la tranche ;
- comportements et fonctions de spawn.

Le générateur doit donc produire un profil par segment/tranche puis configurer
ces étapes natives ; il ne doit pas remplacer ce mécanisme.

### Loot, argent et règles par section

Les références contiennent déjà :

- `ItemSpawnZoneStep` avec plages et poids ;
- `MoneySpawnZoneStep` ;
- quantités par générateur d'étage ;
- statuts, eau, obscurité, pièges et Monster Houses via leurs étapes PMDO.

Les identifiants autorisés proviennent de `Data/Item` et des tables réellement
référencées par les zones. Aucune table universelle n'est créée.

### Boutiques Kecleon

`Data/Zone/vast_steppe.json` est la référence principale :

- `ShopStep<MapGenContext>` ;
- assortiment pondéré et prix ;
- `ItemThemes` avec quantité ;
- Kecleon niveau 90, tactique `shopkeeper` ;
- `MobSpawnInteractable` avec `ShopkeeperInteract` ;
- rôle Lua `Shopkeeper` et état de sécurité `shop_security` ;
- distribution par plages au niveau `ZoneSteps`.

Le Smart Dungeon Designer doit cloner et restreindre ce prototype, jamais
simuler une boutique par de simples décorations.

### Pokémon inoffensifs et PNJ

Les références `desert_oublies`, `bois_ronces` et `carriere_cuivre` contiennent
déjà le modèle du Dungeon Pack :

- `PresetMultiTeamSpawner` ;
- `Explorer: true` / `Ally: true` ;
- tactiques `wait_only` ou assimilées ;
- `MobSpawnInteractable` ;
- `NpcDialogueBattleEvent`.

La catégorie neutre est donc différente des ennemis, des boutiques et des boss.
Un dialogue non disponible n'est jamais inventé silencieusement : il devient un
contrat de localisation explicite.

### Arènes et flow de boss

Références :

- `vast_steppe_guardian` : Ground d'approche, apparition avec
  `CharacterEssentials.MakeCharactersFromList`, caméra, dialogue,
  `COMMON.BossTransition`, `ContinueDungeon` vers un `LayeredSegment`, retour au
  Ground après victoire/défaite et cinématique de conclusion ;
- `searing_crucible` : même flow avec une mise en scène propre au biome ;
- `mount_windswept_guardian` : arène compacte 45×42 cellules, markers d'entrée,
  boss et cinématique ;
- `crooked_den` : pré-combat, combat, perte, victoire et destination narrative.

Contrats retenus :

1. le dernier étage procédural mène à un Ground final ;
2. le Ground joue introduction et dialogue ;
3. le joueur et le boss sont placés à distance Manhattan ≤ 6 ;
4. `BossTransition` mène à un `LayeredSegment` sans escalier ;
5. le résultat du segment revient au Ground ;
6. victoire et défaite ont des états distincts ;
7. la conclusion termine le donjon par script, jamais par escalier générique ;
8. les accompagnateurs de ligne d'évolution ne sont ajoutés que si une source
   d'évolution locale fiable le prouve ; sinon la composition reste conservatrice.

### Grounds, viewport et tiles

L'audit des Grounds montre :

- collisions en cellules de 8 px ;
- `TexSize` variable et non assimilable à une règle globale de zoom ;
- dimensions d'arènes validées de 45×42 à 63×63 cellules ;
- Grounds naturels multi-couches (`Base`, `River`, `Objects`, `Fringe`, etc.) ;
- cells de layers contenant références de sheets, frames et timings ;
- tiles animées distinctes, notamment les familles `*_River_Animations` ;
- le viewport doit rester local et suiveur pour les grandes cartes.

Le générateur de Grounds doit donc copier des cellules sérialisées et des frames
réellement observées, pas reconstruire une tile à partir d'un nom. La grammaire
locale est apprise sur les voisins, collisions et couches d'une référence
compatible.

## Apport documentaire externe

La page Bulbapedia d'Aegis Cave est utilisée uniquement comme modèle de données :

- 19 étages répartis en quatre sections ;
- listes de Pokémon, niveaux et plages différentes selon la section ;
- 1–4 objets au sol et 4–7 objets enterrés ;
- 2–4 ennemis de départ ;
- eau, obscurité, pièges et difficulté variables par section ;
- salles de boss et règles de progression séparées.

Source : <https://bulbapedia.bulbagarden.net/wiki/Aegis_Cave>, révision consultée
le 13 août 2026. Aucune table Bulbapedia n'est copiée dans les données du projet.
La source de vérité d'implémentation reste le dépôt et les formats PMDO.

## Architecture incrémentale

### 1. Base de connaissances du projet

`reference_knowledge.json` doit indexer :

- références de zones pour spawns, loot, shops, neutres, règles et boss ;
- Grounds, dimensions, couches, collisions, sheets, animations et entités ;
- grammaire de voisinage des cellules par classe fonctionnelle ;
- provenance, confiance et limites de chaque inférence.

### 2. Profil de parcours complet

`dungeon_profile.json` décrit sans modifier le code :

- biome global et états progressifs ;
- segments et frontières ;
- tables ennemies par tranche ;
- populations neutres/PNJ ;
- loot sol/enterré/rare ;
- argent, pièges, eau, obscurité et Monster Houses ;
- probabilité et assortiment Kecleon ;
- salles spéciales ;
- approche finale ;
- rencontre de boss et conclusion.

### 3. Réalisation procédurale par run

Le profil exprime les probabilités. Une réalisation déterministe de contrôle est
produite avec la seed du projet : shops, neutres, salles spéciales et règles par
étage. Le `ZoneData` conserve les probabilités natives pour permettre des runs
ultérieurs différents dans les limites du profil.

### 4. Grounds intelligents

Pipeline :

1. intention et fonction ;
2. géométrie abstraite ;
3. navigation et zones protégées ;
4. masses, eau et contours ;
5. sélection d'une référence compatible ;
6. résolution des cellules par grammaire de voisins ;
7. couches, animations et collisions ;
8. entités et scripts ;
9. validation topologique, technique et viewport ;
10. comparaison de variantes et explication.

La première stratégie livrée doit couvrir une clairière forestière avec petits
lacs et l'arène finale compacte. Le format reste extensible à d'autres concepts
sans table de recettes de biomes.

### 5. Validation

Un projet complet échoue si :

- une tranche n'a pas sa table propre ;
- un item ou une espèce n'a pas de provenance ;
- un shop est décoratif au lieu d'être un `ShopStep` ;
- une population neutre est compilée comme ennemi agressif ;
- un relais est un étage ;
- une arène de boss contient un escalier ;
- la distance joueur/boss dépasse 6 ;
- le flow intro → dialogue → combat → victoire → conclusion est incomplet ;
- une référence d'asset manque ;
- la navigation ou une transition de tile est invalide ;
- une grande map force un dézoom global ;
- un choix à faible confiance est présenté comme certain.

## Non-régression

Les seeds, verrous, régénérations locales, scores séparés, `ZoneData`, relays,
previews et commandes Phase 1/2 restent compatibles. Aucun Ground, tile, script
historique ou fichier `Data/Zone` certifié n'est modifié par la génération ; les
nouveaux fichiers restent des candidats dans le dossier projet.
