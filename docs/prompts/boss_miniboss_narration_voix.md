# Boss & mini-boss — Justification narrative et usage de la Voix

Ce document complète `arenes_boss_arc_tournoi.md` : celui-ci traite de l'implantation physique des arènes, celui-ci traite de **pourquoi chaque affrontement existe** et de la place de la Voix dans la narration.

## Principe : aucun boss ni mini-boss gratuit

Un boss ou un mini-boss n'est jamais un simple mur de statistiques placé en fin de donjon pour marquer une difficulté. Chaque affrontement de ce type doit avoir **une histoire**, une raison d'exister à cet endroit précis, à ce moment précis de l'aventure du héros.

Avant de placer un boss ou un mini-boss, définir explicitement :
- **Qui est-il** ? Personnalité, origine, éventuel lien avec d'autres éléments déjà posés dans l'histoire.
- **Pourquoi se trouve-t-il ici** ? Garde un lieu, protège quelque chose, poursuit un but personnel, a été placé là par un événement antérieur du scénario.
- **Que veut-il** ? Un boss agit selon une motivation, pas selon un simple script "attaquer le joueur".
- **Quel est l'enjeu du combat pour le héros** ? Ce que le joueur gagne, apprend, ou risque en l'affrontant.
- **Que devient-il après le combat** ? Vaincu et allié, vaincu et disparu, épargné, fuite, mort — chaque issue doit être choisie consciemment et avoir une conséquence narrative, pas un simple écran de victoire suivi d'un silence.

**Exemple de référence donné : Chartor au Soaring Tunnel.** Ce mini-boss doit avoir une raison logique d'être présent à cet endroit précis du donjon (garde d'un passage, créature liée au lieu, obstacle posé par un événement antérieur) — utiliser ce type de justification comme modèle pour tout futur mini-boss du projet : jamais un mini-boss "parce qu'il fallait un point de difficulté à cet étage", toujours un mini-boss parce que sa présence à cet endroit raconte quelque chose.

Cette exigence s'applique aussi bien aux boss majeurs (légendaires en fin de donjon, cf. `arenes_boss_arc_tournoi.md`) qu'aux mini-boss intermédiaires rencontrés en cours de progression.

## La Voix : un élément rare, pas un outil de narration par défaut

La Voix (speaker anonyme `\uE040`, déjà encadrée par la Règle 9 du fichier de méthode général) doit redevenir ce qu'elle est censée être : **un élément narratif rare**, réservé à des moments d'exception clairement justifiés — pas un procédé de narration récurrent utilisé par facilité pour introduire ou commenter un boss.

- Retirer la Voix de toute scène de boss ou mini-boss où sa présence n'est pas indispensable à la compréhension ou à la tension de la scène.
- Une apparition de la Voix doit se justifier par une raison logique forte : un lien direct avec la trame de l'Abîme ou l'enjeu central de l'histoire, un moment où aucune autre source d'information ou de tension ne pourrait produire le même effet.
- Si un boss ou mini-boss peut être présenté, mis en scène et vaincu sans intervention de la Voix, elle ne doit pas apparaître. La rareté de la Voix est ce qui lui donne son poids : plus elle est utilisée, moins chaque apparition compte pour le joueur.
- Faire un audit des scènes de boss/mini-boss déjà écrites pour identifier les usages non essentiels de la Voix et les retirer ou les remplacer par une mise en scène portée par les personnages eux-mêmes (dialogue du boss, réaction de l'équipe du héros, environnement).

## Critères qualitatifs de scène pour chaque affrontement de boss/mini-boss

**Introduction du combat**
- La rencontre est amenée par une mise en scène cohérente avec le lieu et la raison d'être du boss (pas une apparition brute sans contexte).
- Le joueur comprend, avant le début du combat, pourquoi cet affrontement a lieu.

**Personnalité en jeu**
- Les dialogues du boss avant, pendant (si le moteur le permet) et après le combat reflètent sa personnalité définie, pas des répliques génériques interchangeables avec un autre boss.
- Le langage corporel et les animations (cf. règles de mise en scène du fichier de méthode général) traduisent son état d'esprit : provocation, défense d'un territoire, désespoir, devoir, etc. selon ce que sa motivation implique.

**Mise en scène du combat lui-même**
- L'arène sert le combat visuellement (cf. `arenes_boss_arc_tournoi.md`) : composition, cohérence avec le biome et avec l'identité du boss.
- Si le moteur permet des phases scriptées ou des transitions en cours de combat (changement de comportement, réplique déclenchée à un seuil de vie), les utiliser pour renforcer la narration plutôt que pour la seule difficulté technique.

**Conclusion et conséquences**
- L'issue du combat (victoire, fuite du boss, capture, alliance) est mise en scène avec autant de soin que son introduction — jamais un simple écran de fin sans suite narrative.
- Les conséquences de cette issue sont répercutées sur la suite du chapitre ou de l'histoire (cf. `structure_narrative_donjons_par_chapitre.md` sur la fonction narrative de chaque donjon) : un boss vaincu doit changer quelque chose à la situation du héros, pas simplement débloquer la suite du donjon.

**Cohérence avec le reste du projet**
- Le boss ou mini-boss ne doit pas contredire une information déjà établie sur lui ailleurs dans le projet (s'il est mentionné, aperçu ou évoqué avant sa rencontre).
- Si ce boss/mini-boss est lié à du foreshadowing posé dans un chapitre antérieur, vérifier que la scène le paie correctement.

## Auto-questionnement avant de valider une scène de boss ou mini-boss

- Ce boss/mini-boss a-t-il une histoire et une raison d'être clairement définies, sur le modèle de Chartor au Soaring Tunnel ?
- Sa présence à cet endroit précis du donjon est-elle justifiée narrativement, ou est-ce un placement arbitraire de difficulté ?
- La Voix intervient-elle dans cette scène ? Si oui, son intervention est-elle réellement indispensable, ou pourrait-elle être retirée sans perte de sens ?
- Les dialogues et le comportement du boss reflètent-ils sa personnalité propre, ou sont-ils interchangeables avec un autre boss du projet ?
- L'issue du combat a-t-elle une conséquence visible sur la suite de l'histoire ?

Si l'une de ces questions révèle une incohérence, la scène n'est pas terminée.
