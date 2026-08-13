# Smart Dungeon Designer — level designer procédural PMDO/RogueElements

## Objectif

Le Smart Dungeon Designer construit un donjon comme un processus de level design
déterministe et explicable. Il ne maximise pas simplement un score et ne remplit
pas une carte avec des décorations. Son ordre de décision est :

1. analyse multi-source des ressources réellement disponibles ;
2. interprétation de l'intention naturelle ;
3. direction artistique procédurale du donjon ;
4. actes, courbe de spectacle et identité de chaque étage ;
5. stratégie spatiale et fonctions des salles ;
6. rythme, approches, régions et landmarks ;
7. composition décorative groupée ;
8. validation structurelle et artistique séparée ;
9. réparations et sélection explicable de variantes ;
10. compilation en `ZoneData` PMDO/RogueElements.

Point d'entrée :

```bash
python3 tools/smart_dungeon.py
```

Conceptions détaillées :

- `docs/SMART_DUNGEON_PHASE2_DESIGN.md` ;
- `docs/SMART_DUNGEON_COMPLETE_JOURNEY_DESIGN.md`.

## Parcours complet, pas collection de maps

La version 3 produit désormais `dungeon_profile.json`, profil data-driven qui
relie : biome global, états progressifs, segments, relais, règles par étage,
populations, loot, shops, approche finale, Ground de boss, segment de combat et
conclusion.

Chaque étage possède explicitement :

- table ennemie pondérée et niveaux ;
- table de loot au sol et enterré ;
- quantité d'objets et d'ennemis initiaux ;
- règles d'eau, obscurité, pièges et Monster House ;
- probabilité Kecleon et assortiment de sa tranche ;
- probabilité de Pokémon neutre/PNJ ;
- permissions de salles spéciales.

Les tables proviennent de zones PMDO proches et gardent leur provenance. Deux
segments voisins conservent environ la moitié de leur population afin de faire
évoluer le biome sans le remplacer brutalement.

`reference_knowledge.json` indexe les modèles réellement présents :
`TeamSpawnZoneStep`, `ItemSpawnZoneStep`, `ShopStep`, neutres du Dungeon Pack,
Grounds, maps, arènes, couches, collisions et  grammaires `Data/AutoTile`.
Bulbapedia/Aegis Cave sert uniquement de modèle conceptuel de sections et tables,
jamais de source d'assets ou de données copiées.

## Analyse multi-source de la bibliothèque

`analyze-assets` inspecte sans modifier les sources :

- atlas `.tile` et échantillons PNG réels ;
- dimensions, palette, luminosité, saturation et transparence ;
- contours, détail et symétrie ;
- utilisation observée dans les Grounds ;
- couches, fréquences et cooccurrences ;
- corrélation avec les collisions ;
- bundles `MapTextureStep` et zones PMDO qui les emploient ;
- vocabulaire des noms, lorsqu'il est informatif.

Chaque `AssetProfile` conserve ses sources de preuve, contextes d'utilisation,
confiance, ambiguïtés et raisons d'incertitude. Les matériaux sont décrits comme
*apparents* ou comme propriétés graphiques : l'analyse ne transforme pas une
palette sombre en fait narratif.

Lorsqu'un asset est ambigu, il n'est jamais choisi comme élément exceptionnel
sans preuve forte ou override. Il peut seulement servir de fond ou de support
conservateur, ou être écarté. La commande suivante expose ce raisonnement :

```bash
python3 tools/smart_dungeon.py explain-assets \
  --project WORK/DONJON --query crystal
```

Les corrections humaines restent persistantes :

```bash
python3 tools/smart_dungeon.py override-asset \
  --project WORK/DONJON --asset Ma_Feuille --role wall \
  --tags pierre ancien --rarity 0.25
```

## Direction artistique procédurale

`art_direction.json` est construit depuis l'intention et les métriques réelles,
sans table fixe de biomes. Il contient :

- axes de luminosité, saturation, détail, symétrie et contraste ;
- palette observée ;
- vocabulaire **principal**, **secondaire**, **de transition** et
  **exceptionnel** ;
- rôle de composition et raison d'emploi de chaque asset ;
- confiance et preuves ;
- budgets globaux, particulièrement stricts pour l'exceptionnel ;
- assets ambigus ou rejetés ;
- quatre actes artistiques ;
- stratégies spatiales préférées ;
- décisions expliquant le choix.

La compatibilité n'est qu'un filtre. Un élément n'est retenu que s'il soutient la
base visuelle, une variation locale, une transition ou un moment exceptionnel.
Les assets compatibles non nécessaires restent inutilisés.

## Intentions naturelles

```bash
python3 tools/smart_dungeon.py create \
  --project WORK/sanctuaire_echo \
  --name "Sanctuaire des Échos" \
  --intent "Un donjon ancien et majestueux de 25 étages, ouvert au début puis \
  progressivement labyrinthique et inquiétant, avec un boss final, deux \
  mini-boss, trois relais et une immense salle centrale avant le boss." \
  --boss --mini-bosses 2 --relays 3 --seed 424242
```

Le `DesignBrief` explicite désormais aussi :

- préférences de composition ;
- mots-clés visuels ;
- intensité du spectacle ;
- budget de surprise contrôlée ;
- progression topologique et émotionnelle.

Deux intentions employant le même catalogue peuvent donc produire des directions
et séquences de familles différentes.

## Identité et rythme du donjon

Avant de générer les salles, le planificateur fixe pour chaque étage :

- acte et phase ;
- famille principale et stratégie secondaire ;
- signature géométrique ;
- gradient de densité ;
- rôle du landmark ;
- niveau de spectacle ;
- rythme spatial prévu ;
- approche vers le prochain événement ;
- priorité du vocabulaire visuel.

La courbe de spectacle réserve ses pics aux moments importants. Les frontières
de relais préparent une baisse de tension sans consommer un étage procédural. Les
étages précédant un boss simplifient leur circulation et réduisent les
distractions. Le boss final constitue le maximum de la courbe.

## Familles de composition adaptables

Les familles ne sont pas des templates rigides. Elles orientent le placement,
la fonction des salles, le graphe et les paramètres RogueElements :

- grande salle centrale ;
- centre protégé ;
- progression circulaire ;
- boucle dominante ;
- colonne de couloirs ;
- succession de chambres ;
- îlots de salles ;
- branches et poches secondaires ;
- gradient asymétrique ;
- grande zone ouverte ;
- scènes dédiées de boss/mini-boss.

Les relais ne font pas partie de cette liste de familles : ce ne sont pas des
salles procédurales mais des Grounds de frontière entre segments.

Une stratégie secondaire compatible introduit des transitions naturelles. Les
régions partagent d'abord un vocabulaire principal, puis font varier la densité
et les accents au lieu de remplacer brutalement tous les assets.

## Fonctions de salles et contexte spatial

Chaque salle explique désormais sa géométrie par une fonction :

- orientation ;
- exploration ;
- découverte ;
- tension ;
- respiration ;
- récompense ;
- préparation ;
- transition ;
- récupération ;
- climax.

Une arène n'est plus une salle ronde isolée : elle possède une porte d'approche,
un espace de préparation, une scène focale et un chemin principal.

## Relais : Grounds médians entre segments

Un relais n'est **jamais** une salle de repos placée dans un étage. Pour `N`
relais, les étages demandés sont répartis entre `N+1` `RangeDictSegment` natifs.
Chaque frontière produit un Ground candidat dédié, dérivé en lecture seule d'un
relais PMDO existant et contenant obligatoirement :

- `Kangaskhan_Rock` : soin, stockage et sauvegarde ;
- `Main_Entrance_Marker` : arrivée au palier ;
- `North_Exit` : chemin vers le segment suivant ;
- `South_Exit` : chemin vers le segment précédent ;
- aucune troupe, aucun PNJ hérité et aucun `MissingNo` ;
- collisions et placements fiables du Ground source conservés.

Les relais ne consomment pas le nombre d'étages demandé. Douze étages et deux
relais donnent par exemple trois segments de quatre étages, avec un relais après
les étages 4 et 8. Le compilateur produit également les scripts Ground des deux
chemins et un routeur Zone candidat. Leur promotion vers `Data/Ground`, les
scripts runtime et l'index `master_zone` reste explicite : l'outil ne modifie
jamais ces fichiers certifiés de lui-même.

Lorsque les feuilles graphiques du Ground source n'ont pas été analysées, le
choix est marqué comme fallback structurel à faible confiance au lieu de
revendiquer une compatibilité visuelle inventée.

## Arène et flow de boss

Le boss ne fait plus partie des `FloorPlan`. Le dernier étage est une approche
finale et possède encore ses escaliers normaux. Sa réussite route vers un Ground
d'arène séparé, puis vers un `LayeredSegment` chargé par `MappedRoomStep`.

Le flow reprend `vast_steppe_guardian` et `searing_crucible` :

1. arrivée au Ground ;
2. placement et caméra locale ;
3. apparition et dialogue ;
4. `COMMON.BossTransition` ;
5. segment de combat sans `FloorStairsStep` ;
6. retour au Ground sur victoire ou défaite ;
7. dialogue/conclusion ;
8. fin scriptée du donjon.

Le validateur impose une distance Manhattan joueur/boss ≤ 6, interdit escalier
et sortie physique dans l'arène et refuse les Grounds trop grands pour le
viewport retenu. Les sous-évolutions ne sont ajoutées qu'avec une preuve locale
d'évolution ; faute de données fiables, la liste reste vide.

## Générateur intelligent de Grounds

```bash
python3 tools/smart_dungeon.py analyze-references \
  --output WORK/reference_knowledge.json

python3 tools/smart_dungeon.py generate-ground \
  --output-dir WORK/clairiere \
  --id clairiere_aux_trois_lacs \
  --intent "Une clairière forestière avec trois petits lacs" \
  --seed 20260813 --variants 4 \
  --exit-ground altere_pond
```

Le générateur sépare géométrie et rendu. Il supporte clairières à lacs,
cavernes, canyons sinueux, cours anciennes, exploration organique et arènes. Les
régions, chemins, masses, eau, piliers et anchors sont construits avant les
tiles.

La référence structurelle est choisie automatiquement dans l'index complet par
fonction, alignement, richesse topologique, proportions et métriques visuelles
réelles des `.tile`. Une seconde bibliothèque décorative n'est admise qu'après
preuve de compatibilité graphique, dimensionnelle et sémantique. Metano n'est
jamais transformé en skin global implicite.

La grammaire combine classe fonctionnelle, masque de huit voisins, transition
N/E/S/O et rôle nommé : intérieur, bord orienté, coin, ligne ou extrémité. Chaque
cellule source conserve sheets, frames, timing et orientation native.

Les décorations sont réutilisées sous forme de motifs multicellules complets,
sans rotation ni découpe, groupés hors des routes critiques. Les réparations
locales ferment les vides inaccessibles, reconnectent les anchors et suppriment
les pics avant le rendu.

La validation couvre navigation intégrale, path width, étranglements, carrefours,
eau et animation, dimensions, collisions, layers, frames, sheets, entités,
raccords/fallbacks localisés, motifs, viewport et distance de boss.

Documentation : `docs/SMART_GROUND_GENERATOR.md`.
Exemple : `docs/smart_dungeon/example_ground_clairiere/`.

## Landmarks, régions et composition décorative

Chaque étage peut contenir des régions neutres, de transition, de support et
focales. Un landmark est attaché à une salle importante, possède une fonction
d'orientation et conserve la raison de son placement.

La décoration n'est plus une suite de tirages indépendants. Elle emploie des
groupes transformables :

- ancre et satellites ;
- paire d'encadrement ;
- groupe de coin ;
- rythme de bordure ;
- écho asymétrique ;
- marqueurs de seuil ;
- cour de landmark.

Chaque groupe conserve ancre, rotation, miroir, positions, motif et raison. La
mémoire locale empêche les répétitions immédiates. La mémoire globale suit les
assets, motifs, familles et landmarks déjà employés. Les budgets empêchent un
asset focal de réapparaître parce qu'il possède simplement un bon score.

Des salles restent volontairement sobres. Une surprise contrôlée peut utiliser
le vocabulaire de transition, mais jamais sortir arbitrairement de la direction
artistique.

## Double validation

### Qualité structurelle

- accessibilité et connexité ;
- distance entrée/escalier ;
- variété de tailles et formes ;
- boucles ;
- longueur des couloirs ;
- densité marchable ;
- symétrie voulue ou involontaire ;
- dégagement des points critiques.

### Qualité artistique

- hiérarchie des régions et points focaux ;
- espaces de respiration ;
- variation des densités ;
- répétition des assets ;
- diversité des motifs ;
- couverture par des groupes composés ;
- discipline des éléments rares ;
- qualité des landmarks ;
- force de l'identité ;
- rythme spatial ;
- transitions ;
- relation fonction/géométrie ;
- surprise contrôlée.

### Qualité globale du donjon

- diversité des familles et signatures ;
- différenciation des étages adjacents ;
- progression du spectacle ;
- répétition des landmarks ;
- respect des budgets globaux.

`structural_score` et `visual_score` restent séparés. `score` est un agrégat à
fort effet de goulot : une excellente structure ne masque pas une mauvaise
composition. Un étage structurellement valide mais visuellement faible est
rejeté.

La sélection des variantes suit cet ordre :

1. admissibilité structurelle **et** artistique ;
2. plus faible des deux notes ;
3. identité réalisée ;
4. nouveauté par rapport à la mémoire ;
5. agrégat final.

## Explication des décisions

```bash
python3 tools/smart_dungeon.py explain-design \
  --project WORK/sanctuaire_echo --floor 12
```

La réponse expose direction artistique, fonctions des salles, signature,
landmarks, groupes, réparations, notes séparées et raisons de sélection. Il n'y
a aucune génération opaque.

## Verrous et régénérations

```bash
python3 tools/smart_dungeon.py lock --project WORK/sanctuaire_echo --floor 25
python3 tools/smart_dungeon.py lock --project WORK/sanctuaire_echo --floor 12 --room 3
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope floor:8
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope room:8:2
python3 tools/smart_dungeon.py regenerate --project WORK/sanctuaire_echo --scope decor:8
```

La mémoire est reconstruite dans l'ordre des étages lors d'une régénération. Les
étages et salles verrouillés restent inchangés. `decor:N` conserve tiles et
salles puis recompose uniquement la couche décorative.

## Compilation RogueElements

Le compilateur conserve des `RangeDictSegment` natifs, `FloorStairsStep`,
`MapTextureStep`, spawns, équipes, objets et Monster Houses PMDO. Les frontières
de relais découpent la liste d'étages en plusieurs segments et les Grounds de
relais sont déclarés dans `GroundMaps`. Les nouvelles familles règlent de manière
distincte :

- grille ;
- taille des cellules et salles ;
- ratios de salles et branches ;
- tournants ;
- tunnels, boucles et impasses ;
- distance d'escalier.

Le `floor_design_contracts` explique la traduction. Boss et mini-boss exportent
leur approche et leurs beats. `segment_contracts` et `relay_contracts` décrivent
les frontières, Grounds, statue, services et deux routes de chaque relais. Le
scripting narratif/combat et la destination finale restent des points
d'intégration explicites : l'outil ne les invente pas.

## Sorties d'un projet

- `asset_catalog.json` : observations et incertitudes visuelles ;
- `reference_knowledge.json` : zones, Grounds, maps, AutoTiles et modèles gameplay ;
- `asset_overrides.json` : corrections humaines ;
- `brief.json` : intention normalisée ;
- `dungeon_profile.json` : biome, tranches et contenu de chaque étage ;
- `art_direction.json` : direction artistique et budgets ;
- `progression.json` : actes, signatures, rythme et spectacle ;
- `plans/floor_NNN.json` : architecture et composition complètes ;
- `previews/floor_NNN.svg` : régions, groupes et landmarks ;
- `previews/contact_sheet.svg` : comparaison de tous les étages ;
- `previews/design_board.svg` : vocabulaire et courbe de spectacle ;
- `previews/special_rooms.svg` : scènes et approches de combat ;
- `previews/relays.svg` : Grounds médians, statue, arrivée et deux chemins ;
- `relays/grounds/*.rsground` : copies candidates, jamais les Grounds certifiés ;
- `relays/scripts/ground/*/init.lua` : interactions Kangourex et routes ;
- `relays/scripts/zone/*/init.lua` : routeur de frontières candidat ;
- `relays/manifest.json` : provenance, confiance, segments et validation ;
- `finale/ground/*.rsground` : arène compacte sans sortie générique ;
- `finale/scripts/ground/` : introduction, dialogue, combat et conclusion ;
- `finale/boss_encounter.json` : positions, distance, flow et validation ;
- `finale/previews/*.svg` : collision, caméra et distance joueur/boss ;
- `quality_report.json` : notes par couche et variantes ;
- `artistic_quality_report.json` : validation globale ;
- `decision_log.json` : raisons détaillées ;
- `locks.json` ;
- `zone/<nom>.json` : candidat PMDO ;
- `project.json` et `generation_manifest.json`.

## Démonstrations v3

`docs/smart_dungeon/example_sanctuaire/` :

- 12 étages procéduraux ;
- 3 segments d'exploration et 2 relais ;
- 1 segment final mappé sans escalier ;
- boss Absol à 6 cases du joueur ;
- profil complet par étage et shops Kecleon natifs ;
- structure moyenne 88,216 ; visuel moyen 84,770 ; artistique globale 89,419 ;
- 24 `FloorStairsStep`, tous limités aux étages d'exploration.

`docs/smart_dungeon/example_ground_clairiere/` : Ground 64×48 avec trois lacs,
93,49 % de raccords exacts, navigation valide, animations natives et caméra
locale.

## Validation

```bash
python3 tools/smart_dungeon.py validate --project WORK/sanctuaire_echo
```

Le validateur recalcule les deux couches et la qualité globale, vérifie un
`FloorStairsStep` natif par étage procédural, les tables de contenu, les Grounds
de relais, le Ground et le segment de boss, l'absence d'escalier dans l'arène et
la distance de confrontation. Si la fixture PMDO 0.8.12 Agent A est présente :

```bash
python3 tools/smart_dungeon.py runtime-index --project WORK/sanctuaire_echo
```

Cette commande utilise un overlay isolé et n'écrit jamais dans `Data/Zone`.
