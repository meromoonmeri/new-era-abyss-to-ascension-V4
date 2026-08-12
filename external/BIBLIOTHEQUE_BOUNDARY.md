# BIBLIOTHEQUE — frontière d’intégration

`external/BIBLIOTHEQUE/` est un sous-module Git en lecture de travail, épinglé au
dépôt indépendant `meromoonmeri/BIBLIOTHEQUE`.

## Rôle

- fournir une source externe consultable pour les futurs inventaires de zones ;
- conserver l’historique et la provenance dans le dépôt BIBLIOTHEQUE ;
- empêcher l’import massif des fangames dans l’historique New Era ;
- permettre de construire ultérieurement des manifests et rapports filtrés.

## Interdictions

Le sous-module n’est pas une dépendance runtime de New Era. Aucun fichier brut ne
doit être copié automatiquement vers `Data/`, `Content/` ou les scripts PMDO.
Les exécutables, moteurs, systèmes de jeu, dialogues, castings, sprites humains
et sprites de personnages/Pokémon restent exclus du pipeline environnemental.

Seuls les maps, layouts, tilesets, couches, animations de décor, VFX
strictement environnementaux et leurs métadonnées pourront être sélectionnés,
après inventaire, provenance, filtrage et validation. Une conversion ne doit
jamais modifier les Grounds, tiles, chapitres ou validations PMD Red existants.

## Initialisation

```bash
git submodule update --init --depth 1 external/BIBLIOTHEQUE
```

Toute évolution du contenu doit être réalisée et commitée dans le dépôt
BIBLIOTHEQUE, puis le pointeur du sous-module peut être mis à jour séparément
sur cette branche après audit.
