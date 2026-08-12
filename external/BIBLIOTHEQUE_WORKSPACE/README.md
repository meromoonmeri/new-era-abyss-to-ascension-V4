# BIBLIOTHEQUE — espace de travail versionné

Cet arbre est un overlay de travail suivi par la branche New Era actuelle, à la
demande du propriétaire. La source brute reste le sous-module en lecture seule
`../BIBLIOTHEQUE/`. L'arbre est conçu pour être transférable tel quel à la
racine du dépôt indépendant `meromoonmeri/BIBLIOTHEQUE`.

## Phase active

**Sprint 0–1 : schémas v1 et inventaire exhaustif de Relict.**

Aucune conversion PMDO, reconstruction, modification d'image ou intégration
New Era n'est autorisée pendant ce lot. Chaque Map conserve toutefois toutes
ses couches, ses tables de collision et chaque placement d'entité/page. Les
identités de casting sont remplacées par des placeholders stables afin de
permettre leur futur remplacement par le casting New Era.

## Arborescence

- `schemas/` : contrats JSON fermés et versionnés ;
- `policies/` : inclusion/exclusion environnementale ;
- `tools/` : parseur Ruby Marshal pur Python et inventaire lecture seule ;
- `tests/` : reproductibilité, couverture et absence d'assets exclus ;
- `games/relict/` : métadonnées et rapports générés, jamais les sources brutes.

## Reproduction

Depuis la racine New Era :

```bash
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/inventory_relict.py
python3 external/BIBLIOTHEQUE_WORKSPACE/tests/test_relict_inventory.py
```

Le pipeline ne charge pas `Scripts.rxdata`, ne lance pas Ruby et n'exécute
jamais `Game.exe`. Il parse uniquement le format Ruby Marshal avec un lecteur
pur Python borné.

## Autorité de source

- dépôt : `meromoonmeri/BIBLIOTHEQUE` ;
- commit initial : `6963878956ec4c53833c03f26aa6a9aafd17800f` ;
- jeu pilote : `Relict V1.2` ;
- source : `Relict/Relict V1.2/Relict/`.
