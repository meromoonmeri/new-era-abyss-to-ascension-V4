# Système de raid & monde vivant — Metano Town et au-delà

## 1. Amélioration du système de raid

Reprendre l'ensemble du système de raid existant et l'auditer intégralement plutôt que de corriger des symptômes isolés :

- Identifier tout ce qui peut être amélioré dans le déroulement d'un raid (déclenchement, montée en difficulté, mise en scène d'entrée et de fin, récompenses, cohérence avec le reste des systèmes de combat du projet).
- Appliquer aux cinématiques de raid les mêmes exigences de mise en scène que le reste du projet (fichier de méthode général) : réactivité des personnages, cadrage caméra, positionnement.
- Corriger toute incohérence déjà identifiée dans le système actuel avant d'ajouter de nouvelles fonctionnalités — ne pas empiler du contenu sur une base buguée.
- S'assurer que la difficulté et la fréquence des raids restent cohérentes avec la progression narrative et de gameplay déjà définie pour le projet (cf. `conception_donjons_segmentes.md` et `structure_narrative_donjons_par_chapitre.md` pour la logique de progression).

## 2. Rondoudou dans le shop libre

- Rondoudou doit être positionné dans le shop libre, sans être rattaché à un PNJ figé qui monopolise cet espace — l'objectif est un shop accessible où Rondoudou est présent en tant qu'entité interactive à part entière.
- Rondoudou doit être **interactif** : le joueur doit pouvoir engager une interaction avec lui (dialogue, service, ou fonction propre au shop), pas un simple sprite décoratif posé dans le décor.
- Ce point recoupe un bug déjà identifié dans l'audit du projet ("présence et cinématique d'introduction de Rondoudou à vérifier") : traiter cette correction comme faisant partie de la même tâche, pas comme deux sujets séparés.
- Appliquer ici aussi les règles de positionnement déjà établies : Rondoudou ne doit ni bloquer la circulation dans le shop, ni se superposer à un autre PNJ ou élément de décor.

## 3. PNJ à position variable dans le temps

Chaque PNJ significatif doit pouvoir occuper une position différente d'un jour à l'autre dans le jeu, plutôt que de rester figé au même endroit en permanence. Cela signifie concrètement :

- Un PNJ n'est pas ancré définitivement à une coordonnée fixe sur le Ground : sa position peut varier selon le jour ou le moment simulé par le jeu (ex. un PNJ marchand devant son étal le matin, mais ailleurs en ville l'après-midi ou le lendemain).
- Cette variation doit rester cohérente avec le rôle du PNJ : un garde en faction ne se déplace pas de façon incohérente avec sa fonction, alors qu'un PNJ marchand ou habitant peut légitimement se déplacer selon une routine crédible.
- L'objectif n'est pas la variation pour la variation : chaque changement de position doit renforcer l'impression que ce PNJ a une vie propre, pas donner une impression de placement aléatoire.

## 4. Dialogues variables selon les événements récents

- Chaque PNJ doit pouvoir avoir un dialogue différent selon les événements récents de la trame narrative, pas une ligne de dialogue statique valable du début à la fin du jeu.
- Un événement marquant de l'histoire (arrivée d'un personnage, résolution d'un chapitre, changement dans la ville) doit se répercuter sur ce que les PNJ ont à dire, au moins pour les PNJ pour lesquels cela a du sens.
- Cette exigence rejoint la règle générale déjà établie sur la personnalité des personnages (fichier de méthode général) : un PNJ ne doit jamais parler d'une façon qui ignore ce qu'il devrait savoir à cet instant de l'histoire.

## 5. Metano Town comme ville vivante

Metano Town doit donner une impression de ville habitée en continu, pas de décor statique peuplé de PNJ figés :

- Les PNJ doivent occuper la ville de façon crédible selon le moment (cycle jour/nuit, cf. le point déjà identifié dans l'audit du projet sur le cycle nuit de Metano Town, à vérifier en jeu).
- Croiser des scènes de vie courante en arrière-plan (PNJ qui discutent entre eux, qui vaquent à une activité, qui réagissent à un événement récent de l'histoire) renforce cette impression de ville vivante — appliquer ici la même exigence de réactivité que pour les cinématiques (aucun PNJ ne doit rester un simple figurant immobile).
- La cohérence entre la position des PNJ, leurs dialogues, et les événements narratifs récents doit être vérifiée ensemble, pas séparément : un PNJ qui a un nouveau dialogue mais reste à une position qui ne correspond plus au contexte casse autant l'immersion qu'un dialogue périmé.

## 6. Principe général — corriger et améliorer sans se limiter à ces exemples

Cette liste (raid, Rondoudou, positions de PNJ, dialogues, Metano Town) est un point de départ, pas une limite. Appliquer la même exigence à tout ce qui, dans le projet, peut être amélioré pour renforcer l'impression d'un monde vivant :

- Identifier toute incohérence encore présente ailleurs dans le projet suivant la même logique (PNJ figés, dialogues obsolètes, lieux qui ne réagissent pas aux événements de l'histoire).
- Chaque personnage, PNJ mineur compris, doit avoir une personnalité perceptible à travers ses réactions, ses dialogues et son comportement — pas seulement les personnages principaux.
- Prioriser les corrections qui ont le plus d'impact sur la crédibilité générale du monde avant de traiter les détails cosmétiques mineurs.

## Auto-questionnement avant de valider une amélioration du monde vivant

- Ce PNJ a-t-il une raison logique d'occuper cette position à ce moment précis du jeu ?
- Son dialogue reflète-t-il les événements récents de l'histoire, ou est-il resté figé depuis un état narratif dépassé ?
- Rondoudou et les autres PNJ de shop sont-ils réellement interactifs, ou de simples éléments de décor ?
- Le raid concerné respecte-t-il les mêmes standards de mise en scène et de cohérence que le reste du projet ?
- Metano Town, prise dans son ensemble à un instant donné du jeu, donne-t-elle l'impression d'un lieu vivant et cohérent avec l'état actuel de l'histoire ?

Si l'une de ces questions révèle une incohérence, l'élément concerné n'est pas terminé.
