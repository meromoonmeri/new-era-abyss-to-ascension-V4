# Structure narrative des donjons par chapitre — À partir du chapitre 6

## Règle de structure

À partir du chapitre 6 inclus, chaque chapitre ("histoire") de New Era doit contenir **entre 3 et 5 donjons**. Ce n'est pas une contrainte arbitraire de contenu : c'est une règle de rythme narratif. Un chapitre avec moins de 3 donjons manque de matière pour développer un arc complet ; un chapitre avec plus de 5 dilue la tension narrative et retarde la progression de l'histoire principale sans justification suffisante. Cette fourchette doit être respectée sauf exception clairement justifiée par un besoin narratif explicite (à documenter si elle est dépassée).

Cette règle ne s'applique pas rétroactivement aux chapitres 1 à 5 : ne pas les modifier pour les faire rentrer dans ce cadre. Elle s'applique à la conception de tout chapitre à partir du 6.

## Pourquoi chaque donjon doit avoir une fonction narrative

Aucun des 3 à 5 donjons d'un chapitre ne doit être un simple donjon "de remplissage" gameplay sans rôle dans l'histoire. Avant de placer un donjon dans un chapitre, définir explicitement :
- ce que ce donjon apporte à l'intrigue principale ou à une intrigue secondaire du chapitre ;
- ce que les personnages apprennent, vivent ou perdent à l'intérieur ;
- en quoi son franchissement change la situation des personnages au moment d'en sortir (nouvelle information, nouvel allié, nouvel obstacle, révélation, objet clé).

Si un donjon ne peut répondre à aucune de ces questions, il doit soit être retravaillé pour justifier sa place, soit être retiré du chapitre.

## Répartition et progression à l'intérieur d'un chapitre

Les 3 à 5 donjons d'un même chapitre ne doivent pas se ressembler dans leur poids narratif. Construire une progression :

- **Donjon(s) d'ouverture du chapitre** — pose l'enjeu du chapitre, introduit un nouvel élément (lieu, personnage, menace) qui va structurer la suite.
- **Donjon(s) intermédiaire(s)** — développe l'enjeu, complique la situation, peut introduire un twist partiel ou une sous-intrigue, approfondit une relation entre personnages.
- **Donjon final du chapitre** — porte le point culminant du chapitre : c'est généralement là que se trouve le boss ou mini-boss du chapitre (cf. `arenes_boss_arc_tournoi.md`), et c'est ce donjon qui doit conclure ou faire basculer l'arc du chapitre, en même temps qu'il ouvre une tension vers le chapitre suivant.

Cette progression doit rester cohérente avec la difficulté de gameplay des donjons (cf. `conception_donjons_segmentes.md`) : le donjon final d'un chapitre doit représenter le point de difficulté le plus élevé de ce chapitre, pas un donjon anecdotique.

## Exigences narratives à l'intérieur de chaque chapitre

- **Twists** : au moins un retournement doit être prévu par chapitre à partir du chapitre 6, préparé en amont (foreshadowing) plutôt qu'introduit sans base. Un twist ne doit jamais contredire une information déjà établie dans un chapitre précédent sans justification narrative explicite (retournement volontaire d'une fausse piste, révélation qui recontextualise un fait déjà connu — pas une incohérence non maîtrisée).
- **Foreshadowing** : chaque chapitre doit à la fois payer du foreshadowing posé dans des chapitres antérieurs (si applicable) et en semer pour des chapitres futurs ou pour l'end-game. Tenir cette trace via le contrôleur de continuité déjà prévu dans la suite d'outils internes du projet.
- **Trame principale et trames secondaires** : chaque chapitre fait avancer la trame principale de façon lisible, tout en pouvant faire progresser une ou plusieurs trames secondaires (relations entre personnages, arcs de PNJ récurrents, éléments de lore) sans jamais la reléguer au second plan ni la contredire.
- **Connaissance du monde Pokémon** : les éléments de lore introduits (légendaires, régions, mythologie propre à la saga) doivent être exploités avec la même rigueur que dans les chapitres précédents, en cohérence avec les règles narratives permanentes du projet (légendaires réservés aux moments d'enjeu narratif fort, namespace et continuité des sauvegardes non affectés).

## Exigences cinématiques par donjon

Pour chaque donjon d'un chapitre, prévoir une mise en scène cinématique cohérente avec son rôle narratif, en appliquant intégralement les règles déjà établies du fichier de méthode général (mise en scène, positionnement, transitions) :

- **Cinématique d'entrée** : justifie pourquoi les personnages pénètrent ce donjon à ce moment précis de l'histoire — jamais un enchaînement silencieux sans mise en scène pour un donjon qui a un poids narratif.
- **Événement(s) intermédiaire(s)** : si le donjon porte une révélation, une rencontre ou un développement narratif à mi-parcours, le matérialiser par une cinématique dédiée plutôt qu'un simple message texte, en respectant les règles de réactivité des personnages déjà établies.
- **Cinématique de fin / boss** : pour les donjons qui se terminent sur un boss ou un moment fort, appliquer les exigences des arènes définies dans `arenes_boss_arc_tournoi.md` (arène cohérente avec le biome et le légendaire, mise en scène soignée de l'affrontement).
- **Transitions** : chaque passage d'un donjon à l'autre à l'intérieur du chapitre, et chaque passage entre un donjon et une scène de Ground, doit respecter les règles de transitions déjà établies (timing du fondu, cohérence son/image, absence de flottement injustifié).

## Cohérence globale du chapitre

Avant de considérer un chapitre terminé, vérifier que l'enchaînement de ses 3 à 5 donjons forme un arc narratif lisible de bout en bout : un lecteur qui ne connaîtrait que ce chapitre doit pouvoir identifier son enjeu de départ, sa complication, son point culminant, et sa conclusion ou son ouverture vers la suite.

## Qualité de la langue française

Tout texte produit pour New Era — dialogues, textes de chapitre, interfaces, titres — doit être rédigé dans un français idiomatique, jamais calqué sur une syntaxe anglaise. Reformuler entièrement la structure de phrase si besoin plutôt que de traduire mot à mot. Le registre doit rester adapté à chaque personnage et cohérent avec l'ambiance Pokémon Mystery Dungeon : un vocabulaire et des tournures qui sonnent comme un vrai jeu Pokémon localisé en français, pas comme une traduction automatique.

**Résidus de texte en anglais** : tout texte encore en anglais rencontré dans le projet (dialogues, textes d'interface, noms d'écrans, textes de chargement, descriptions) doit être identifié et traduit en français idiomatique — aucun résidu anglais ne doit subsister dans le contenu final destiné au joueur francophone.

Rappel des règles déjà en vigueur sur ce point (Règle 8 du fichier de méthode général) : clés anglaises dans `strings.resx`, clés françaises dans `strings.fr.resx`, ne jamais inverser les deux, ne jamais coder du texte en dur dans le Lua — toujours passer par le système de Strings/TextData, y compris pour les traductions correctives de résidus anglais.

## Écran d'ouverture de chapitre

Chaque chapitre, à son commencement, doit s'ouvrir sur un écran de présentation dédié, suivant un schéma cohérent sur l'ensemble du jeu :

- **Fond plein écran** : une image occupant l'intégralité de l'écran, représentative du chapitre à venir (lieu clé, ambiance, thème narratif du chapitre).
- **Filtre assombrissant** : un filtre sombre appliqué sur l'image de fond, pour garantir la lisibilité du titre et donner une tonalité cinématographique à l'ouverture, cohérente avec les écrans de chapitre des jeux Pokémon Mystery Dungeon officiels.
- **Titre du chapitre en français** : affiché par-dessus l'image assombrie, dans une traduction française idiomatique et soignée — jamais un titre laissé en anglais ou traduit littéralement sans travail de style.

Chaque chapitre doit avoir sa propre image de fond, distincte des autres, cohérente avec son contenu (lieu principal, enjeu, ambiance) — pas de réutilisation d'un même visuel générique d'un chapitre à l'autre. Le choix de l'image doit être pensé comme une promesse visuelle de ce que le chapitre va raconter, à la manière d'un écran-titre de saison dans une série.

## Auto-questionnement avant de valider un chapitre (à partir du chapitre 6)

- Le chapitre contient-il entre 3 et 5 donjons ? Si ce nombre est dépassé ou non atteint, la raison est-elle explicitement justifiée ?
- Chaque donjon a-t-il une fonction narrative claire et identifiable ?
- La progression de poids narratif et de difficulté entre les donjons du chapitre est-elle cohérente (montée progressive vers le donjon final) ?
- Le chapitre pose-t-il ou paie-t-il du foreshadowing de façon vérifiable ?
- Le twist du chapitre (s'il y en a un) est-il préparé en amont plutôt qu'arbitraire ?
- Chaque donjon à enjeu narratif possède-t-il sa mise en scène cinématique dédiée (entrée, événement intermédiaire si pertinent, fin) ?
- Le donjon final du chapitre porte-t-il bien le point culminant, avec une arène cohérente si un boss y est présent ?
- L'ensemble du chapitre reste-t-il cohérent avec la trame principale et les règles narratives permanentes du projet ?
- Le texte du chapitre est-il rédigé dans un français idiomatique et fidèle à l'ambiance Pokémon, sans résidu de texte en anglais ?
- Le chapitre dispose-t-il de son écran d'ouverture avec image de fond dédiée, filtre assombrissant et titre en français correctement traduit et stylisé ?

Si l'une de ces questions révèle une incohérence, le chapitre n'est pas terminé.
