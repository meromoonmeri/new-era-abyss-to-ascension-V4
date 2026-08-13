# Smart Dungeon Designer — level designer procédural PMDO/RogueElements

## Objectif

L'outil construit un donjon comme un processus de level design et non comme une
simple suite de salles aléatoires. Il sépare explicitement :

1. analyse des ressources réellement disponibles ;
2. interprétation d'une intention en langage naturel ;
3. planification de la progression complète ;
4. architecture spatiale de chaque étage ;
5. composition visuelle et décoration hiérarchisée ;
6. évaluation multi-critères ;
7. réparations locales et comparaison de variantes ;
8. compilation en `ZoneData` PMDO/RogueElements.

Point d'entrée : `python3 tools/smart_dungeon.py`.

## Analyse de bibliothèque

`analyze-assets` inspecte :

- les atlas `.tile` disponibles ;
- des échantillons PNG réels ;
- la taille des tuiles ;
- palette dominante, luminosité, saturation et alpha ;
- densité de contours, détail et symétrie ;
- l'usage réel des feuilles dans les Grounds et leur corrélation aux collisions ;
- les bundles `MapTextureStep` déjà employés dans les zones PMDO.

L'outil infère des scores pour les rôles `floor`, `wall`, `border`,
`structure`, `decoration`, `hazard`, `water`, `transition` et `focal`. Il bâtit
ensuite un graphe de compatibilité combinant palette, style, transparence,
détail, dimensions et vocabulaire de nommage. Les clusters ne supposent jamais
qu'un biome possède une recette fixe.

Les corrections humaines sont persistantes :

```bash
python3 tools/smart_dungeon.py override-asset \
  --project WORK/DONJON --asset Ma_Feuille --role wall \
  --tags pierre ancien --rarity 0.25
```

## Intentions naturelles

Exemple :

```bash
python3 tools/smart_dungeon.py create \
  --project WORK/sanctuaire_echo \
  --name "Sanctuaire des Échos" \
  --intent "Un donjon ancien et majestueux de 25 étages, ouvert au début puis \
  progressivement labyrinthique et inquiétant, avec un boss final, deux \
  mini-boss, trois relais et une immense salle centrale avant le boss." \
  --boss --mini-bosses 2 --relays 3 --seed 424242
```

L'intention devient un `DesignBrief` explicite : thème, courbe émotionnelle,
transition topologique, danger, décoration, eau, contraintes et salles
spéciales. Les relais sont placés après des pics de tension ou avant le climax,
pas automatiquement tous les cinq étages.

## Architecture spatiale

Le planificateur produit notamment :

- salles rectangulaires, irrégulières, rondes et cruciformes ;
- petites et grandes salles ;
- salles centrales et arènes ;
- arbres de circulation complétés par des boucles et raccourcis ;
- couloirs à plusieurs coudes ;
- branches, alcôves et espaces respiratoires ;
- entrée, sortie, points focaux et salles spéciales protégés.

La progression fait évoluer subtilement la complexité, la densité, le danger,
la taille des pièces, les boucles et le rythme. Chaque étage possède un
sous-thème local mais conserve le cluster visuel du donjon.

## Qualité et réparation itérative

Chaque variante est notée sur 100 avec :

- accessibilité et connexité ;
- lisibilité ;
- distance entrée/escalier ;
- variété des tailles et formes ;
- nombre de boucles ;
- longueur maximale des couloirs droits ;
- densité marchable ;
- symétrie involontaire ;
- équilibre spatial de la décoration ;
- dégagement des entrées, sorties et points d'intérêt ;
- cohérence visuelle du cluster d'assets.

Les violations déclenchent des réparations locales : connexion de composantes,
création d'une boucle, alcôve asymétrique, remodelage d'une salle,
redistribution des décorations ou dégagement d'un point critique. Plusieurs
variantes sont comparées et la meilleure est conservée. Les plans, variantes,
notes et réparations sont enregistrés.

## Décoration

La décoration utilise quatre niveaux : commun, secondaire, rare et focal.

- les petits éléments vont près des murs et dans les coins ;
- les éléments focaux occupent un espace ouvert protégé ;
- les éléments détaillés/rares sont utilisés avec parcimonie ;
- une distance minimale évite les rythmes mécaniques ;
- les entrées, escaliers et points d'intérêt restent dégagés ;
- certaines zones restent volontairement vides.

## Verrous et régénération partielle

```bash
# Verrouiller l'étage final
python3 tools/smart_dungeon.py lock --project WORK/sanctuaire_echo --floor 25

# Verrouiller une salle
python3 tools/smart_dungeon.py lock --project WORK/sanctuaire_echo --floor 12 --room 3

# Régénérer une structure, une salle ou uniquement la décoration
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope floor:8
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope room:8:2
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope decor:8
```

Une seed identique, une bibliothèque identique et des overrides identiques
produisent le même résultat.

## Compilation RogueElements

Le compilateur choisit une zone PMDO procédurale compatible dans la bibliothèque
et produit un `RangeDictSegment` natif. Chaque étage reçoit son propre
`GridFloorGen` paramétré à partir du plan sélectionné : grille, taille de cellule,
ratio de salles, branches, tunnels, tailles de salles, tournants de couloir et
distance des escaliers.

Sont conservés :

- `FloorStairsStep` natif ;
- `MapTextureStep` compatible ;
- spawns d'objets, argent, Monster Houses et effets PMDO ;
- roster déduit des zones disponibles les plus proches du thème ;
- équipes et pression ennemie adaptées à la difficulté.

Boss, mini-boss et relais disposent d'un contrat de placement exporté. Leur
script narratif/combat reste une étape d'intégration volontairement séparée afin
de ne pas inventer un boss ou un routage historique.

## Sorties d'un projet

- `asset_catalog.json` : compréhension des ressources ;
- `asset_overrides.json` : corrections humaines ;
- `brief.json` : intention normalisée ;
- `progression.json` : rythme du donjon ;
- `plans/floor_NNN.json` : architecture complète ;
- `previews/floor_NNN.svg`, `contact_sheet.svg` et `special_rooms.svg` ;
- `quality_report.json` : scores, violations et variantes ;
- `locks.json` ;
- `zone/<nom>.json` : candidat PMDO ;
- `project.json` et `generation_manifest.json`.

## Validation

```bash
python3 tools/smart_dungeon.py validate --project WORK/sanctuaire_echo
```

Le validateur réévalue les plans et vérifie que le ZoneData compilé possède bien
un escalier RogueElements par étage. Si la fixture Agent A est disponible :

```bash
python3 tools/smart_dungeon.py runtime-index --project WORK/sanctuaire_echo
```

Cette commande exécute l'indexeur PMDO 0.8.12 exact dans un overlay ignoré et
n'écrit jamais dans `Data/Zone`.
