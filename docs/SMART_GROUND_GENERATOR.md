# Smart Ground Generator — composition topologique PMDO

## Principe

Le générateur ne dessine pas un Ground à partir d'une liste de tiles. Il produit
d'abord une représentation fonctionnelle, puis résout chaque cellule avec une
grammaire apprise sur les Grounds et AutoTiles existants.

Aucun asset graphique n'est créé. Les fichiers certifiés sont lus et les cellules
PMDO sérialisées sont copiées dans un candidat isolé.

## Bibliothèque inspectée

`analyze-references` parcourt par défaut l'intégralité de :

- `Data/Ground` ;
- `Data/Map` ;
- `Data/Zone` ;
- `Data/AutoTile` ;
- les sheets `Content/Tile` nécessaires aux références candidates.

L'index conserve dimensions, `TexSize`, couches, collisions, sheets, animations,
frames, objets, markers, spawners, viewport, grammaire de voisinage et SHA-256.
Le schéma `1.4.0` recense également les controllers Ground/Zone et les
bibliothèques environnementales matérialisées de `BIBLIOTHEQUE_WORKSPACE` ; les
imports PMDODump/Dungeon Pack déjà présents dans `Data/` restent prioritaires.

Metano et les Grounds de guilde peuvent enseigner des proportions, mais ne sont
jamais choisis silencieusement comme skin global d'un Ground naturel.

## Interprétation fonctionnelle

Les concepts actuellement réalisés sont :

- `clearing_lakes` : clairière, couronne végétale, chemin et petits lacs ;
- `crystal_cavern` : chambres cavernicoles, connexions et bassins ;
- `winding_canyon` : axe sinueux et poches latérales ;
- `ancient_courtyard` : cour construite, bras et piliers ;
- `boss_arena` : scène compacte, approche et confrontation ≤ 6 cases ;
- `organic_exploration` : chambres organiques reliées.

Ce sont des stratégies abstraites, pas des templates de tiles. Une intention
sans signal suffisant déclenche le repli conservateur mono-bibliothèque ; elle ne
sert jamais de prétexte à inventer une fonction d'asset.

## Sélection automatique des références

La référence structurelle est choisie selon :

1. fonction demandée, notamment présence obligatoire d'une couche d'eau ;
2. `TexSize=1` et couches alignées à la grille de collision ;
3. richesse de la grammaire topologique observée ;
4. proportions jouables ;
5. contexte d'utilisation et vocabulaire ;
6. métriques réelles des PNG contenus dans les `.tile` : luminosité,
   saturation, détail et densité de contours ;
7. confiance de l'analyse.

Une seconde bibliothèque peut fournir des motifs décoratifs seulement si :

- la taille native des tiles est compatible ;
- la distance visuelle mesurée reste sous le seuil ;
- le contexte sémantique apporte une preuve ;
- les motifs peuvent être copiés sans rotation, miroir ou découpe.

Sinon, le système reste volontairement sur une seule bibliothèque.

## Grammaire locale

Chaque cellule source reçoit :

- classe fonctionnelle `open`, `wall` ou `water` ;
- masque de huit voisins de même classe ;
- signature N/E/S/O des transitions de classes ;
- rôle topologique : intérieur, bord orienté, coin, ligne droite, extrémité ou
  cellule isolée ;
- collision et cellules visuelles de toutes les couches structurelles ;
- sheets, frames et timings natifs.

La résolution préfère une correspondance exacte classe + masque + transition.
Les sols dominants, chemins minoritaires cohérents et bassins larges sont
séparés par signatures réelles de frames. La résolution privilégie ensuite la
continuité des coordonnées sources voisines : elle réemploie de petits motifs
locaux validés sans recopier le layout d'origine ni tirer une mini-scène au
hasard pour chaque cellule.

Les fallbacks sont classés par distance et enregistrés avec position, classe,
rôle, masque, cellule source et cause. Un fallback sévère invalide le candidat.

## Composition macro, méso et micro

### Macro

- régions fonctionnelles ;
- masses fermées et espaces ouverts ;
- entrée, sortie et point d'intérêt ;
- chemin principal ;
- lacs, chambres, cour ou scène de combat.

### Méso

- transitions entre régions ;
- variations de largeur ;
- poches latérales ;
- piliers et obstacles structurants ;
- contours d'eau.

### Micro

Les couches `Objects`, `Objects Under`, `Fringe` et assimilées sont analysées en
composantes multicellules. Seuls les motifs natifs complets de 2 à 24 cellules
sont réutilisés. Chaque groupe conserve son origine, sa signature, sa couche,
son nombre de cellules et sa raison de placement.

Aucun motif n'est retourné ou pivoté. Les routes et anchors ont une zone de
protection absolue. Un motif n'est pas répété plus de deux fois.

## Réparations locales

Avant le rendu final :

- suppression des pics d'une seule cellule ;
- dégagement de la route principale ;
- connexion des anchors ;
- fermeture des petits vides ouverts inaccessibles ;
- connexion locale des grandes régions ouvertes isolées.

Toutes les réparations sont sérialisées dans `geometry.repair_log`.

## Comparaison des candidats

La validité technique, la qualité structurelle et la qualité artistique restent
séparées. La sélection privilégie successivement les candidats valides, leur
minimum structure/art équilibré, puis leur qualité combinée : elle n'optimise
pas un score scalaire unique. Chaque comparaison et chaque métrique restent dans
`candidate_comparison` et `quality_scores`.

## Validation

Le validateur contrôle :

- dimensions de toutes les couches ;
- `TexSize` ;
- ordre base/eau ;
- frames, timings et sheets ;
- collisions et entités hors limites ;
- accessibilité de tout espace praticable ;
- anchors et route principale ;
- nombre de masses d'eau ;
- cellules d'eau orphelines ;
- animation réelle de l'eau ;
- largeur et variation du chemin ;
- étranglements, carrefours, impasses, boucles, directivité et lignes de vue ;
- couverture exacte de la grammaire ;
- fallbacks sévères ;
- diversité et intégrité des motifs ;
- absence de transformation non prouvée ;
- viewport local sans dézoom forcé ;
- distance du boss pour une arène.

## Sorties

Pour chaque Ground :

- `<id>.rsground` ;
- `<id>.metadata.json` ;
- `<id>.svg` : audit interactif avec frames natives incorporées ;
- `<id>.init.lua`.

Le renderer PNG expérimental a été retiré : il ne doit pas servir de preuve
visuelle tant que sa composition n'est pas strictement équivalente au runtime
PMDO.

Le controller peut recevoir une destination explicite avec `--exit-ground` et
`--exit-marker`. Sans destination, il reste volontairement un candidat et ne
prétend pas connaître la route scénaristique du donjon parent.

## Commande

```bash
python3 tools/smart_dungeon.py generate-ground \
  --output-dir WORK/ground \
  --id clairiere_sombre \
  --intent "Une clairière de forêt sombre avec trois petits lacs animés" \
  --seed 20260813 --variants 6 \
  --exit-ground altere_pond
```

La même bibliothèque, l'intention et la seed produisent les mêmes octets.
