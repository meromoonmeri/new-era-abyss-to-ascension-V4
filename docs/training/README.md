# Laboratoire technique non chargé

Ces fichiers sont des exercices de référence : ils ne sont pas sous `Data/Script`, ne figurent dans aucun `index.idx`, et aucun `require` du mod ne les charge. Ils ne modifient donc pas le contenu de production.

## Exercice A — NPC conditionnel SV

`sv_conditional_npc.lua` est la forme minimale à reproduire dans une map de test :

1. ajouter le défaut de flag dans `Data/Script/halcyon/scriptvars.lua` ;
2. placer le module dans `Data/Script/halcyon/ground/<test_map>/` ;
3. l'importer explicitement depuis `ground/<test_map>/init.lua` ;
4. affecter `training_npc.Action` au personnage dans l'éditeur ;
5. parler deux fois au NPC, sauvegarder/recharger, puis parler à nouveau.

Le dernier test doit rester dans la seconde branche. Il prouve que `SV` est persistant, contrairement à une variable locale de module.

## Exercice B — donjon généré minimal

`minimal_rogueelements_pipeline.cs` est un blueprint de pipeline à exécuter contre la même révision de RogueElements que le moteur : grille, rooms/halls, dessin terrain, escalier puis spawns. Son ordre n'est pas décoratif : déplacer les spawns avant le dessin ou les escaliers avant les rooms rend le contexte incomplet.

La sandbox Arena de ce relevé ne dispose pas du SDK `dotnet`; l'exécution doit être faite dans le checkout moteur/PMDC avec son SDK. Avant de l'ajouter à une zone test dans l'éditeur, vérifier au moins 20 seeds : entrée/sortie atteignables, pas d'escalier isolé, nombre de spawns plausible.

Pour une validation dans PMDO, le prototype se traduit en un segment à trois `GridFloorGen` et des Zone Steps de tables de spawn. Ne jamais placer le fichier JSON de test sous `Data/Zone` sans l'indexer intentionnellement : c'est précisément la frontière laboratoire/production.
