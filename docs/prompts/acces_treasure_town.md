# Accès à Treasure Town & parité de vie avec Metano Town

## Terme à clarifier

"En loacklass comme dans EoN project" — le terme n'est pas clair tel quel. Interprétation retenue par défaut pour ce document : Treasure Town est accessible à un moment précis et délimité de l'histoire, comme une parenthèse narrative ponctuelle (flashback, souvenir, ou séquence spéciale déclenchée par un événement de scénario), plutôt qu'une ville ouverte en permanence dès son introduction. Si l'intention réelle est différente (DLC séparé, mode bonus, zone débloquée définitivement après un certain chapitre, etc.), le signaler pour ajuster ce document en conséquence.

## Objectif

Permettre au joueur de se rendre à Treasure Town à un moment précis de l'histoire de New Era, en récupérant les maps de Treasure Town depuis ProjectEoN et en les adaptant au format PMDO. Une fois cette ville intégrée, elle doit atteindre le même niveau de vie et de fonctionnalité que Metano Town, et réciproquement — les deux villes doivent être traitées comme des standards équivalents, pas l'une comme un décor secondaire moins soigné que l'autre.

## Source de référence

- **ProjectEoN** : https://github.com/Logical321/ProjectEoN — projet de référence déjà identifié dans la bibliothèque du projet, à étudier pour comprendre comment Treasure Town y est implémentée (structure de maps, agencement des zones, PNJ, job board) avant de l'adapter à New Era. Ne pas copier le contenu à l'identique : comprendre la logique de conception, puis l'adapter à l'univers et aux règles déjà établies pour New Era.

## Récupération et adaptation des maps

- Extraire les maps de Treasure Town depuis ProjectEoN.
- Les adapter au format PMDO en s'appuyant sur les outils déjà spécifiés pour ce type de tâche : `outil_generateur_map_tileset.md` pour la cohérence de tileset, et `outil_conversion_assets_pmdsky.md` si les assets sources nécessitent une conversion de format avant intégration.
- Respecter les mêmes exigences d'intégrité déjà posées pour toute conversion d'assets externes : aucune perte de détail, aucun élément de la map d'origine tronqué sans raison.
- Vérifier que l'intégration de Treasure Town dans New Era reste cohérente avec le reste du monde (échelle, style visuel, cohérence de biome si un lien géographique est établi avec le reste de la carte).

## Justification narrative de l'accès

- Définir clairement à quel moment de l'histoire et pour quelle raison le héros se rend à Treasure Town — un accès à une ville aussi identifiable ne doit jamais être un simple ajout de contenu sans justification (cf. principe déjà établi : chaque élément doit avoir une fonction narrative, `structure_narrative_donjons_par_chapitre.md`).
- Si l'accès est ponctuel (flashback, séquence spéciale), la mise en scène d'entrée et de sortie de cette séquence doit suivre les règles de transitions déjà établies (fichier de méthode général) : un passage clair et cohérent, jamais un changement de ville qui apparaît sans explication.

## Parité de vie entre Metano Town et Treasure Town

Les deux villes doivent respecter exactement les mêmes standards, définis dans `systeme_raid_ville_vivante.md` :

- Les PNJ de Treasure Town doivent être aussi vivants que ceux de Metano Town : réactivité, position qui peut varier selon le contexte temporel du jeu, dialogues cohérents avec les événements récents de l'histoire.
- Réciproquement, si Metano Town a des éléments de vie qui ne sont pas encore au niveau attendu, cette tâche est l'occasion de les auditer et de les corriger en parallèle plutôt que de laisser un écart de qualité entre les deux villes.
- Aucune des deux villes ne doit donner l'impression d'être un décor secondaire moins travaillé que l'autre — le joueur doit ressentir la même qualité de mise en scène, qu'il se trouve dans l'une ou dans l'autre.

## Job board fonctionnel dans les deux villes

- Le job board (tableau de missions) doit être pleinement fonctionnel à la fois à Metano Town et à Treasure Town : génération de missions, affichage correct, prise en charge et validation des missions, récompenses distribuées correctement.
- Vérifier qu'aucune régression n'existe sur le job board de Metano Town au moment d'implémenter celui de Treasure Town — auditer les deux en même temps plutôt que de supposer que l'un fonctionne déjà parfaitement.
- Le contenu des missions proposées dans chaque ville peut refléter le contexte local (biome environnant, PNJ propres à la ville) pour renforcer la différenciation entre les deux lieux, tout en gardant un fonctionnement technique identique et fiable.

## Auto-questionnement avant de valider cette intégration

- Le moment et la raison narrative de l'accès à Treasure Town sont-ils clairement définis et mis en scène ?
- Les maps récupérées de ProjectEoN ont-elles été adaptées sans perte de détail au format PMDO ?
- Treasure Town donne-t-elle une impression de ville aussi vivante que Metano Town, PNJ par PNJ ?
- Le job board des deux villes fonctionne-t-il réellement en jeu (pas seulement "semble correct" à la lecture du script) ?
- L'intégration de Treasure Town crée-t-elle une incohérence géographique, visuelle ou narrative avec le reste du monde de New Era ?

Si l'une de ces questions révèle une incohérence, l'intégration n'est pas terminée.
