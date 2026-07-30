# Arènes de boss & Arc tournoi — New Era

## 1. Principe des arènes de boss et mini-boss

Chaque boss et mini-boss doit se trouver à l'étage sommital de son donjon — l'étage qui conclut la progression du segment (cf. `conception_donjons_segmentes.md`, logique "on doit ressentir qu'on est AU SOMMET").

Cette arène n'est **pas un étage généré procéduralement comme les autres** : c'est une zone entièrement construite à la main sous RogueEssence, propre, dédiée, pensée spécifiquement pour le combat et pour le légendaire qui l'occupe. L'outil de génération de map/tileset (`outil_generateur_map_tileset.md`) peut servir de base pour garantir la cohérence du tileset avec le biome du donjon, mais l'arène finale doit être finalisée manuellement — composition, lisibilité du terrain de combat, absence d'éléments génériques copiés d'un étage normal.

**Un légendaire = un donjon = une arène.** Chaque arène doit être conçue en fonction du légendaire qui l'habite : son type, sa personnalité, son rôle dans le lore, et le biome du donjon dans lequel il se trouve. Une arène de légendaire de type Glace dans un donjon de sommet enneigé n'a pas la même composition qu'une arène de légendaire Spectre dans un donjon en ruines.

## 2. Cohérence biome / arène

- Appliquer la logique de nuance de biome déjà établie : l'arène est le point culminant visuel de la progression du segment, elle doit résoudre visuellement tout ce que les segments précédents annonçaient.
- Utiliser l'outil de génération de tileset pour partir d'une base cohérente avec le biome du donjon, puis l'enrichir manuellement pour atteindre le niveau de finition attendu d'une zone de boss (cf. audit du fichier de méthode général : positionnement, collisions, lisibilité caméra).
- Aucune arène ne doit réutiliser un gabarit générique déjà vu ailleurs sans adaptation — chaque légendaire mérite une arène reconnaissable et mémorable.

## 3. Révision du chapitre 6

Le chapitre 6 doit être repris et amélioré, avec un focus particulier sur ses arènes de combat : les corriger pour qu'elles soient assorties au biome de leur donjon respectif, via l'outil de génération de tileset, puis finalisées manuellement selon les principes ci-dessus. Appliquer à l'ensemble du chapitre l'audit complet du fichier de méthode général (mise en scène, positionnement, transitions), pas seulement aux arènes.

## 4. Distribution narrative des donjons à boss

Répartir les donjons à boss/mini-boss sur une plage de **30 à 99 étages cumulés**, sur l'ensemble de l'histoire (chapitres 1 à 32) et du end-game, selon une logique narrative cohérente :

- La difficulté et la profondeur des donjons progressent en cohérence avec l'avancement du scénario, pas de façon arbitraire.
- Les donjons de fin de jeu (end-game) doivent representer une montée en puissance nette par rapport aux donjons d'introduction, aussi bien en profondeur qu'en mise en scène d'arène.
- Chaque légendaire rencontré doit avoir sa place justifiée dans cette progression : un légendaire rencontré tôt dans l'histoire doit avoir un rôle narratif cohérent avec le fait de le croiser à ce stade (force relative, enjeu de l'affrontement, connaissance qu'en a le héros à ce moment).

## 5. Exigences d'écriture — twists, foreshadowing, lore

- Construire l'histoire avec de véritables retournements (twists) préparés à l'avance, pas improvisés sur le moment : tout twist doit pouvoir être relu a posteriori comme ayant été annoncé.
- Semer du foreshadowing dès les premiers chapitres pour des événements qui ne se paieront que bien plus tard (y compris en end-game). Tenir une trace de ces éléments plantés pour s'assurer qu'ils sont bien exploités plus tard et non oubliés — ce suivi peut s'appuyer sur le contrôleur de continuité déjà prévu dans la suite d'outils internes du projet.
- Mobiliser une connaissance poussée de l'univers Pokémon (lore des jeux, des légendaires, des relations entre espèces) pour ancrer l'histoire dans une cohérence reconnaissable par un joueur connaisseur, sans pour autant contredire les règles déjà fixées pour New Era (namespace Halcyon, éléments narratifs propres au projet, légendaires réservés aux moments d'enjeu narratif fort — cf. Règle 12).
- Construire une trame principale claire, mais aussi des trames secondaires qui l'enrichissent (arcs personnels de PNJ, rivalités, quêtes annexes à portée narrative) sans jamais la diluer ni créer d'incohérence avec elle.

## 6. Arc tournoi

Concevoir un arc de tournoi inspiré de la campagne de Guilde de PMDO, réparti sur les 32 chapitres de l'histoire, articulé autour de plusieurs équipes :

**Équipes issues de l'histoire de New Era**
- Team Dazzling
- Team Style

**Équipes importées d'autres jeux de la saga** (à intégrer avec cohérence narrative — justifier leur présence dans le monde de New Era plutôt que de les insérer sans lien)

**Team Charm** — Gardevoir, Lockpin, Charmina

**Team Alakazam** — Alakazam, Dracaufeu, Tyranocif

Pour cet arc :
- Chaque équipe doit avoir une identité propre (style de combat, personnalité collective, rivalité ou alliance avec l'équipe du héros) cohérente avec ses membres.
- L'arc doit s'intégrer dans la progression générale de l'histoire sur les 32 chapitres, avec ses propres cinématiques dédiées (respectant l'ensemble des règles de mise en scène déjà établies) et ses zones dédiées, réutilisant intelligemment les zones et donjons déjà exploités du projet plutôt que d'en multiplier inutilement de nouvelles.
- Les légendaires et les enjeux du tournoi doivent rester cohérents avec la trame principale — le tournoi doit nourrir l'histoire globale, pas devenir un aparté déconnecté du reste du récit.

## 7. Documentation de référence

- PMDCollab (organisation regroupant les outils et projets PMDO) : https://github.com/PMDCollab
- PMDODump — Docs et DataAsset (référence de structure de données déjà utilisée pour ce projet) : https://github.com/audinowho/PMDODump/tree/master/DataAsset/Docs

Étudier en particulier comment la campagne de Guilde est structurée dans PMDO officiel/mods de référence (enchaînement des affrontements, montée en difficulté, mise en scène des équipes adverses) avant de concevoir l'arc tournoi de New Era — reproduire la logique de conception, pas le contenu à l'identique.

## 8. Auto-questionnement avant validation

- L'arène de ce boss est-elle cohérente avec le biome du donjon et la personnalité du légendaire qui l'occupe ?
- Le foreshadowing posé dans les chapitres précédents est-il payé de façon satisfaisante à ce stade de l'histoire ?
- Le placement de ce donjon à boss dans la plage 30-99 étages est-il cohérent avec la difficulté narrative attendue à ce moment du scénario ?
- L'arc tournoi reste-t-il connecté à la trame principale, ou devient-il un aparté déconnecté ?
- Chaque équipe du tournoi agit-elle selon une identité et une personnalité propre, reconnaissable d'un affrontement à l'autre ?

Si l'une de ces questions révèle une incohérence, le contenu n'est pas terminé.
