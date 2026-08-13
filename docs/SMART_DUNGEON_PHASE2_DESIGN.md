# Smart Dungeon Designer — conception incrémentale Phase 2

## Audit de la Phase 1

La Phase 1 fournit déjà les contrats qu'il faut préserver : catalogue d'assets,
`DesignBrief`, progression, plans spatiaux analysables, variantes, réparations,
verrous, régénérations locales, previews, compilation `ZoneData` et déterminisme
par seed.

L'audit du code et de la démonstration du Sanctuaire met toutefois en évidence
cinq limites précises :

1. `visual.select_visual_language` choisit un seul cluster puis les meilleurs
   éléments de quatre rôles. Dans la démonstration limitée à 40 feuilles, le
   cluster retenu ne contient qu'un asset, utilisé comme élément commun,
   secondaire, rare **et** focal. La compatibilité tient donc lieu à tort de
   direction artistique.
2. `layout.make_candidate` empile des salles puis construit un graphe. Le nom de
   l'archétype influence quelques paramètres, mais il n'existe ni fonction de
   salle, ni approche d'un événement, ni signature réalisée, ni rythme spatial
   explicite.
3. `_decorate` reste un placement aléatoire individuel sous contraintes. Il ne
   connaît ni groupes de composition, ni mémoire inter-étages, ni budget
   d'assets importants, ni raison de placement sérialisée.
4. `quality.evaluate` mélange structure et esthétique dans une note unique. La
   variété des tailles sature facilement, la compatibilité visuelle vaut
   toujours 1 et un étage banal peut dépasser 90/100.
5. La sélection des variantes maximise cette note étage par étage. Elle ignore
   l'identité du donjon, la diversité avec les étages précédents et la courbe de
   spectacle globale.

Aucun de ces constats ne nécessite une réécriture du compilateur ou des formats
PMDO : les nouvelles couches peuvent enrichir les décisions en amont et
continuer à fournir les mêmes `FloorPlan` au compilateur existant.

## Pipeline Phase 2

Le pipeline devient :

1. **intention du donjon** — brief explicite et axes de composition ;
2. **direction artistique procédurale** — vocabulaire principal, secondaire,
   exceptionnel et de transition, avec preuves, confiance et budgets ;
3. **actes et identités d'étages** — courbe de spectacle, signatures, mémoire et
   transitions ;
4. **stratégie spatiale** — famille de composition adaptable, éventuellement
   hybride ;
5. **fonctions de salles et approche des événements** — orientation, tension,
   respiration, récompense, préparation, scène ;
6. **landmarks et régions visuelles** — neutre, support et focal ;
7. **composition décorative** — motifs transformables avec ancre et éléments
   secondaires, puis détails ;
8. **double validation** — structure et qualité artistique séparées ;
9. **sélection explicable** — admissibilité, qualité minimale, identité et
   nouveauté avant la note globale ;
10. **compilation PMDO/RogueElements** — contrat existant inchangé.

## Composants à faire évoluer

- `model.py` : champs additifs compatibles avec les anciens JSON pour la preuve
  multi-source des assets, les fonctions de salles, l'identité, les régions,
  landmarks, groupes décoratifs, décisions et qualité visuelle.
- `assets.py` : contextes d'emploi dans les Grounds et zones, cooccurrences,
  sources de preuve, matériaux *apparents*, ambiguïté et ponts visuels.
- `intent.py` : préférences compositionnelles, budget de surprise et intensité
  de spectacle, sans vocabulaire de biomes codé en dur.
- `art_direction.py` (nouveau) : sélection parcimonieuse du vocabulaire,
  attribution de fonctions de composition, budgets et choix conservateurs.
- `layout.py` : stratégies adaptables, fonctions de salles, graphes guidés,
  approches et rythme spatial.
- `composition.py` (nouveau) : groupes décoratifs, landmarks, respiration,
  mémoire locale/globale et budgets.
- `quality.py` : deux évaluations indépendantes et qualité globale du donjon.
- `project.py` : mémoire séquentielle, sorties Phase 2, régénérations compatibles
  et journal des décisions.
- `visual.py` : previews montrant régions, groupes, signatures et courbe de
  spectacle plutôt qu'une simple topologie grise.
- `compiler.py` : traduction des nouvelles familles vers les paramètres natifs,
  sans modifier la structure du `ZoneData`.

## Structures de données nouvelles

### Direction artistique

`art_direction.json` conserve :

- axes visuels et palette déduits des métriques réelles ;
- vocabulaire `primary`, `secondary`, `exceptional`, `transition` ;
- fonction de composition, confiance, preuves et budget de chaque asset ;
- assets ambigus ou écartés et raisons ;
- actes visuels et stratégies spatiales préférées ;
- sélection runtime compatible avec le compilateur Phase 1.

### Identité d'étage

Chaque `FloorPlan` conserve :

- famille principale et stratégie secondaire ;
- signature géométrique et gradient de densité ;
- niveau de spectacle ;
- rythme spatial prévu et réalisé ;
- fonctions des salles ;
- régions neutres, support, transition et focales ;
- landmarks ;
- groupes décoratifs ;
- décisions et raisons sérialisées.

### Mémoire

La mémoire de conception suit, pendant une génération complète :

- fréquence globale et récente des assets ;
- dernier étage d'utilisation des éléments focaux ;
- familles et signatures récentes ;
- motifs décoratifs récents ;
- consommation des budgets rares/exceptionnels.

Elle est reconstruite de manière déterministe lors d'une régénération partielle,
afin de préserver les verrous et les plans non ciblés.

## Critères de validation Phase 2

### Structure — score séparé

- accessibilité et connexité ;
- sortie atteignable et distance utile ;
- lisibilité des couloirs ;
- boucles ;
- densité marchable ;
- variété géométrique ;
- protection des points critiques.

### Composition visuelle — score séparé

- hiérarchie neutre/support/focale ;
- espaces de respiration ;
- variation intentionnelle des densités ;
- couverture par des groupes composés ;
- répétition des assets et des motifs ;
- discipline des assets rares ;
- force et utilité d'orientation des landmarks ;
- réalisation de la signature annoncée ;
- rythme spatial ;
- cohérence des transitions internes ;
- surprise contrôlée ;
- relation entre fonction et géométrie des salles.

### Donjon — validation globale

- diversité des signatures et familles ;
- similarité excessive entre étages adjacents ;
- progression et rareté des pics de spectacle ;
- répétition des assets focaux ;
- respect des budgets globaux ;
- cohérence des transitions entre actes.

Un étage n'est accepté que si la structure **et** la composition visuelle
franchissent leurs seuils. La sélection ne maximise plus aveuglément une note :
elle privilégie d'abord les variantes admissibles, puis leur faiblesse la plus
basse, l'identité réalisée, la nouveauté et seulement enfin la note agrégée.

## Compatibilité et non-régression

Les ajouts sont additifs. Les anciens plans restent chargeables. `score` reste un
alias agrégé pour les consommateurs existants, mais `structural_score` et
`visual_score` deviennent les autorités. Les commandes, seeds, verrous, scopes
`all`, `floor`, `room`, `decor`, compilation et indexation runtime sont
conservés. Aucun fichier de `Data/Ground`, `Content/Tile` ou `Data/Zone` n'est
modifié par cette phase.
