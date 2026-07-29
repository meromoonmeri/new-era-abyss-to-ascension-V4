# Conception des donjons à segments multiples — Progression de biome et cohérence

*Document de référence fourni par l'utilisateur (directive 2026-07-29). Il PRIME
sur les biomes inférés de `tools/mapgen/data/` : tout conflit se résout en
faveur de ce document.*

## Principe général

Un donjon à plusieurs segments (relais) n'est pas une succession de zones interchangeables reliées par des points de passage neutres. Chaque segment doit exprimer visuellement une étape de la progression à l'intérieur du donjon — altitude, distance parcourue, dangerosité croissante, changement d'environnement logique. Le joueur doit pouvoir dire à quel moment de sa progression il se trouve rien qu'en regardant le décor, sans avoir besoin d'un indicateur de texte.

Ne jamais traiter un segment comme une simple variation cosmétique du précédent (recolorisation de tileset sans logique). Chaque changement de décor doit être justifié par la géographie et la narration du lieu.

## Progression de biome par segment — exemple de référence : Mont Windsep

Le Mont Windsep sert de modèle pour cette logique et doit être audité selon ces critères (cf. directive de revue déjà établie) :

1. **Segment de départ** — terrain verdoyant, végétation dense, ambiance encore proche de la base de la montagne. C'est le début de l'ascension, le décor doit rester accueillant.
2. **Segment intermédiaire** — après le premier relais, transition vers un environnement plus escarpé : sentier de falaise, minéral plus présent, végétation qui se raréfie, terrain plus resserré. La difficulté visuelle du terrain doit suivre la difficulté réelle du gameplay.
3. **Segment final / Ground du boss** — au sommet. Le décor doit rendre l'altitude explicite : vue dégagée, éléments rocheux dominants, ciel plus présent dans la composition, absence progressive de la végétation basse, sensation de vent ou d'exposition. Le joueur doit ressentir "je suis au sommet" avant même le combat de boss.

Cette logique de dégradé de biome (du plus dense/accueillant au plus exposé/hostile) s'applique à tout futur donjon à segments, adaptée au thème propre de chaque lieu — un donjon aquatique suivra une logique différente (surface calme → profondeur → zone abyssale, par exemple), mais le principe de nuance progressive reste identique.

## Points de relais (checkpoints)

Chaque relais doit être cohérent avec le biome du segment dans lequel il se trouve, pas avec un modèle de relais générique réutilisé tel quel partout dans le jeu.

- Le décor immédiat autour d'un point médian reflète la transition en cours : un relais entre le segment verdoyant et le segment falaise doit déjà montrer les premiers signes du changement (rochers apparaissant, végétation qui s'éclaircit), pas un copier-coller neutre.
- Les éléments fonctionnels du relais (feu de camp, zone de repos, éventuels PNJ) restent cohérents avec l'altitude et l'exposition du lieu — pas de feu de camp en plein vent exposé sans justification, pas de végétation d'accueil dense en haute altitude.
- Se référer à l'auto-questionnement du fichier de méthode général sur le positionnement et les collisions pour chaque relais (feu de camp, sacs, décor solide).

**Fonction de gameplay des relais** : chaque point médian de donjon restaure les PP et l'estomac (faim) du joueur et de son équipe. C'est une fonction systématique de tout relais, quel que soit le donjon ou le segment — à implémenter de façon cohérente sur l'ensemble des donjons à segments du projet, pas au cas par cas.

**Rencontres inoffensives** : il doit être possible de croiser, aux abords des relais ou dans certaines zones du segment, des Pokémon sauvages inoffensifs (non hostiles, sans déclenchement de combat). Cela renforce la sensation d'un biome vivant plutôt qu'un couloir de rencontres uniquement hostiles, et doit rester cohérent avec la faune logique du biome traversé (ex : un segment verdoyant en base de montagne aura une faune différente d'un segment de sommet exposé).

## Sources d'assets

Pour la construction des tilesets et décors de chaque segment, utiliser exclusivement les sources déjà validées pour ce projet (cf. Règle 7) :

- Les assets déjà présents dans le projet.
- DumpAsset (PMDODump).
- Le Trio Dungeon Pack et les autres dépôts GitHub référencés dans la bibliothèque du projet.

Ne jamais improviser un asset hors de ces sources. Si un biome nécessite un élément visuel absent de ces bibliothèques, le signaler plutôt que d'utiliser une ressource non validée.

**Principe d'exploitation maximale des outils PMDO** : au-delà des seuls assets visuels, New Era doit utiliser de la façon la plus intelligente et la plus complète possible l'ensemble des outils, systèmes et dépôts GitHub de l'écosystème PMDO (RogueEssence, RogueElements, PMDC, PMDODump, DumpAsset, tutoriels et wiki officiels, mods de référence de la bibliothèque). Pour chaque système de donjon (génération procédurale, gestion de la faim/PP, rencontres, IA des Pokémon sauvages, effets de biome), vérifier systématiquement si le moteur ou l'écosystème propose déjà une solution native ou une référence dans un mod existant avant de développer une solution maison. L'objectif est de tirer le meilleur parti de ce que le moteur permet, plutôt que de le contourner ou de sous-exploiter ses capacités.

## Fluidité des déplacements

Les déplacements à l'intérieur du donjon doivent être aussi fluides que les références internes déjà jugées satisfaisantes du projet : Illuminant Riverbed et Relic Forest. Utiliser ces deux donjons comme benchmark de fluidité de navigation — largeur des passages, absence de blocages artificiels, lisibilité du chemin, rythme de déplacement du joueur.

Avant de considérer un segment terminé, comparer concrètement sa jouabilité à ces deux références : si la navigation est plus heurtée, plus confuse ou moins fluide, le segment n'est pas terminé.

## Génération procédurale des étages

Les étages de chaque segment doivent être variés dans leur conception plutôt que répétitifs, et générés aléatoirement dans la mesure permise par le moteur (RogueElements). Utiliser les capacités de génération procédurale du moteur pour éviter la sensation de niveaux copiés-collés d'un étage à l'autre, tout en gardant :

- une variété suffisante de layouts pour qu'un joueur ne reconnaisse pas un patron répété d'étage en étage ;
- une mesure de difficulté progressive et logique à l'intérieur de la génération aléatoire — la génération procédurale ne doit jamais produire un étage plus difficile avant un étage plus facile de façon incohérente avec la progression du donjon ;
- une cohérence visuelle avec le segment/biome en cours, même quand le layout change : la génération aléatoire porte sur la structure de l'étage, pas sur le biome, qui reste déterminé par le segment.

## Cohérence avec les cinématiques

La progression de biome doit rester synchronisée avec les cutscenes qui ponctuent le donjon. Une cinématique déclenchée à un point du donjon doit se dérouler dans un décor cohérent avec le segment atteint à ce moment (pas de cutscene avec un arrière-plan de sommet alors que le joueur vient d'entrer dans le segment de départ, et inversement). Appliquer ici les règles générales de mise en scène et de transitions déjà définies (fichier de méthode général) : orientation des personnages, cadrage caméra, transitions de fondu — rien de spécifique à ajouter, seulement s'assurer que le biome affiché dans la cutscene correspond exactement à celui du segment de donjon où elle se déclenche.

## Auto-questionnement avant de valider un segment de donjon

- Le biome de ce segment est-il visuellement distinct du segment précédent et du suivant, de façon logique avec la progression (altitude, distance, danger) ?
- Le joueur peut-il déduire sa position dans la progression du donjon rien qu'en observant le décor ?
- Le point de relais reflète-t-il la transition de biome en cours, ou est-ce un modèle générique recopié sans adaptation ?
- Les assets utilisés proviennent-ils exclusivement des sources validées du projet ?
- La navigation dans ce segment est-elle aussi fluide que dans Illuminant Riverbed ou Relic Forest ? Si non, qu'est-ce qui casse le rythme ?
- La génération procédurale des étages produit-elle une variété suffisante tout en respectant une courbe de difficulté cohérente ?
- Si une cutscene se déclenche dans ce segment, son décor correspond-il exactement au biome atteint à ce point du donjon ?

Si l'une de ces questions révèle une incohérence, le segment n'est pas terminé.
