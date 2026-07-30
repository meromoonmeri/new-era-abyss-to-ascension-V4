# Uniformisation de l'architecture des donjons — 3 structures, pas une de plus

## Principe

Tout donjon de New Era doit être construit autour de **exactement trois types de structure**, ni plus ni moins :

1. **La Route** — l'ensemble des étages du donjon et de leurs segments internes, points médians et relais inclus.
2. **La zone du Boss** — l'arène finale, si le donjon comporte un boss.
3. **La zone du Mini-boss** — si le donjon en comporte un ; sinon, cette structure n'existe simplement pas pour ce donjon.

Aucune autre catégorie structurelle ne doit exister en parallèle. Tout élément qui ne rentre pas proprement dans l'une de ces trois catégories doit être supprimé, ou fusionné dans "La Route" s'il s'agit en réalité d'un segment ou d'un point médian mal isolé.

## Modèle de référence validé : Crooked Cavern

Crooked Cavern est déjà testé en jeu et validé comme référence technique du projet. Utiliser son architecture comme modèle concret de la façon dont ces trois structures doivent s'organiser sous RogueEssence — vérifier comment ses zones, segments et étages sont déclarés, et reproduire cette même logique d'organisation pour tout autre donjon du projet, existant ou à venir.

## Détail des trois structures

### 1. La Route

- Regroupe tous les étages du donjon, y compris leurs segments internes définis par la progression de biome (`conception_donjons_segmentes.md`) et les points médians/relais qui les ponctuent, uniques à chaque biome (`PROMPT_ULTIME_conception_donjons.md`).
- C'est la seule structure sur laquelle s'applique la génération procédurale (RogueElements) : la variété de layout et la courbe de difficulté se jouent entièrement à l'intérieur de la Route.
- Les relais, bien qu'intégrés à la Route, restent des points fixes construits à la main — ils ne sont jamais générés aléatoirement, mais ils font partie de cette même structure, pas d'une structure à part.

### 2. La zone du Boss

- L'étage final du donjon, entièrement construit à la main, dédié au combat contre le boss (cf. `arenes_boss_arc_tournoi.md` et `boss_miniboss_narration_voix.md` pour la justification narrative et la cohérence de l'arène avec le biome).
- Une seule zone de Boss par donjon qui en comporte un.

### 3. La zone du Mini-boss

- Structure optionnelle : uniquement présente si le donjon comporte effectivement un mini-boss, justifié narrativement (cf. `boss_miniboss_narration_voix.md`).
- Même logique de construction manuelle que la zone du Boss, généralement positionnée à un point intermédiaire de la Route plutôt qu'à la fin du donjon.
- Si un donjon n'a pas de mini-boss, cette structure est simplement absente — ne jamais en créer une par défaut ou par habitude si elle n'a pas de justification.

## Ce qui doit être supprimé ou simplifié

Pour tout donjon existant du projet, vérifier qu'aucune structure ne sort de ce cadre de trois catégories :
- Une zone de transition isolée qui ne sert à rien de plus qu'un couloir devrait être un segment de la Route, pas une structure séparée.
- Une zone technique héritée d'un ancien découpage qui ne correspond plus à un boss, un mini-boss ou à la route elle-même doit être retirée après vérification qu'elle ne casse rien en jeu.
- Ne pas conserver une structure "parce qu'elle existe déjà" : si elle ne rentre pas dans une des trois catégories et ne remplit aucune fonction claire, elle doit être supprimée.

## Respect des attentes RogueEssence/PMDO

Cette uniformisation doit rester strictement dans le cadre de ce que RogueEssence/RogueElements attend structurellement pour un donjon (organisation en Zone, Segment, Floor telle que documentée dans le moteur) — ne jamais inventer une organisation parallèle qui s'écarterait de ce que le moteur gère nativement. Se référer à la documentation déjà validée pour ce projet :
- RogueEssence : https://github.com/RogueCollab/RogueEssence
- RogueElements : https://github.com/audinowho/RogueElements
- PMDOTutorial, Lesson 3 — Dungeon Maps : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.3
- PMDOTutorial, Lesson 5 — Multi-Floor Generation : https://github.com/audinowho/PMDOTutorial/releases/tag/v0.5
- Floor Generation Overview : https://wiki.pmdo.pmdcollab.org/Floor_Generation_Overview

## Procédure de migration pour les donjons existants

1. Lister l'architecture actuelle du donjon audité (zones, segments, étages déclarés).
2. Comparer cette architecture à celle de Crooked Cavern comme référence de structure correcte.
3. Identifier tout élément qui ne correspond à aucune des trois catégories (Route, Boss, Mini-boss).
4. Décider pour chaque élément hors cadre : fusion dans la Route, ou suppression pure et simple.
5. Vérifier en jeu, après modification, que le donjon reste fonctionnel de bout en bout (cf. principe du fichier de méthode général : "le code compile" n'est jamais un critère suffisant).
6. Documenter la migration dans `PROJECT_CONTEXT.md` selon la procédure de fin de session déjà en vigueur pour le projet.

## Auto-questionnement avant de valider un donjon

- Ce donjon est-il entièrement décrit par les trois structures Route / Boss / Mini-boss, sans élément superflu ?
- Les points médians et relais sont-ils bien intégrés à la Route plutôt que traités comme une structure séparée ?
- Une zone de Mini-boss existe-t-elle uniquement si elle est réellement justifiée narrativement ?
- L'organisation technique respecte-t-elle le modèle Zone/Segment/Floor natif de RogueEssence, sans structure parallèle inventée ?
- La comparaison avec l'architecture de Crooked Cavern confirme-t-elle la cohérence de cette organisation ?

Si l'une de ces questions révèle une incohérence, le donjon n'est pas terminé.
