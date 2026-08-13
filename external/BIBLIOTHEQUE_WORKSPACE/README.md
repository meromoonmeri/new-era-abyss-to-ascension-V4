# BIBLIOTHEQUE — espace de travail versionné

Cet arbre est un overlay de travail suivi par la branche New Era actuelle, à la
demande du propriétaire. La source brute reste le sous-module en lecture seule
`../BIBLIOTHEQUE/`. L'arbre est conçu pour être transférable tel quel à la
racine du dépôt indépendant `meromoonmeri/BIBLIOTHEQUE`.

## Phase active

**Relict qualifié ; pilote source → IR commun → Ground PMDO validé ; inventaire
Nova suivant.**

Les 28 Zones Relict sont `SOURCE_DOCUMENTED`. La conversion est désormais
autorisée uniquement dans `games/<game>/conversion/`, hors destinations runtime
New Era. Le pilote Map 012 atteint `PMDO_VALIDATED` après validation headless
PMDO 0.8.12, tout en restant `ADAPTATION_REQUIRED` pour les tags terrain et
l'intégration narrative. Chaque Map conserve toutes ses couches, collisions et
placements d'entité/page ; les identités de casting restent expurgées.

## Arborescence

- `schemas/` : contrats JSON fermés et versionnés ;
- `policies/` : inclusion/exclusion environnementale ;
- `tools/` : lecteurs source bornés, importeur IR, convertisseur PMDO et harness headless ;
- `tests/` : reproductibilité, couverture, fidélité et absence d'assets exclus ;
- `games/relict/` : métadonnées, IR, candidat pilote et rapports dérivés, jamais les sources brutes.

## Reproduction

Depuis la racine New Era :

```bash
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/build_relict_library.py
python3 external/BIBLIOTHEQUE_WORKSPACE/tests/test_relict_inventory.py
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/build_common_map_ir.py --game relict --map-id 12
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/convert_map_ir_to_pmdo.py \
  --ir external/BIBLIOTHEQUE_WORKSPACE/games/relict/conversion/ir/map_012.json
python3 external/BIBLIOTHEQUE_WORKSPACE/tests/test_pmdo_pilot.py
# Après restauration du runtime ignoré Agent A :
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/validate_pmdo_runtime.py
```

Le pipeline source ne charge pas `Scripts.rxdata`, ne lance pas Ruby et n'exécute
jamais `Game.exe`. Ruby Marshal et PNG sont traités par des lecteurs purs Python
bornés. Le seul outil externe est ImageMagick, version et hash verrouillés, pour
coalescer les frames GIF avant normalisation PNG déterministe. Un seul script
source ciblé est lu statiquement afin d'établir la durée exacte des autotiles ;
il n'est ni exécuté ni recopié.

## Autorité de source

- dépôt : `meromoonmeri/BIBLIOTHEQUE` ;
- commit initial : `6963878956ec4c53833c03f26aa6a9aafd17800f` ;
- jeu pilote : `Relict V1.2` ;
- source : `Relict/Relict V1.2/Relict/`.
