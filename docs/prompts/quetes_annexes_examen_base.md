# Quêtes annexes — Examen d'Explorateur & Base personnelle

## Sources techniques obligatoires

Avant de concevoir en détail les scènes de ces deux quêtes, analyser intégralement les dépôts suivants :

- **ExplorersOfSkyOrigins** (remake d'Explorers of Sky sous le moteur PMDO) : https://github.com/slothplaysnecro/ExplorersOfSkyOrigins — analyse obligatoire de ses cinématiques et de ses assets avant d'écrire la scène du café. Récupérer l'ensemble des assets pertinents et s'assurer qu'ils sont réintégrés dans le bon format et au bon emplacement du projet (structure de dossiers déjà en usage pour les assets validés de New Era). Exemple concret donné : les portails de Dusknoir présents dans ce dépôt peuvent être mis de côté pour une réutilisation future dans la narration de New Era (utile si une mécanique de portail/téléportation trouve sa place plus tard dans l'histoire, notamment vu le thème de l'Abîme).
- **pret/pmd-red** (décompilation de Red Rescue Team) : https://github.com/pret/pmd-red — source obligatoire pour récupérer la structure exacte de la quête du Bois Brouhaha (Uproar Forest) et l'adapter à New Era, ainsi que pour les assets de base de secours qui y sont liés.

Ces deux dépôts ne sont pas des sources à copier telles quelles : en étudier la logique de conception (structure de quête, enchaînement des cinématiques, format des assets), puis l'adapter à New Era en respectant les règles déjà établies du projet.

## Quête 1 — Examen d'Explorateur (déblocage de donjon par badge)

**Principe** : la progression de badges de la Guilde/Fédération sert de condition de déblocage à une quête d'examen. Une fois l'examen validé, un nouveau donjon devient accessible au joueur.

**Structure de la quête**
1. Le joueur, après avoir obtenu le nombre de badges requis, reçoit une indication (dialogue, PNJ, notification narrative) l'orientant vers le café.
2. Au café, le joueur doit trouver et parler au représentant de la Fédération des Explorateurs.
3. Ce représentant fait passer l'examen (ou valide la candidature du joueur) et débloque en conséquence l'accès à un nouveau donjon.

**PNJ concernés — Spinda's Café**
- **Spinda**, tenancier du café, présent en fond de décor de la scène — son rôle reste celui d'hôte du lieu, pas nécessairement l'examinateur lui-même, selon la logique déjà établie dans Explorers of Sky.
- **Qulbutoké** (Wobbuffet), représentant de la Fédération des Explorateurs, chargé de faire passer ou de valider l'examen.
- **Okéoké** (Wynaut), pré-évolution de Qulbutoké, associé à ce dernier dans la scène — présent à ses côtés de façon cohérente avec leur duo canonique (dans Explorers of Sky comme dans Rescue Team, ce duo intervient toujours ensemble).

**Exigences de mise en scène**
- S'appuyer sur l'analyse d'ExplorersOfSkyOrigins pour la mise en scène du café (cadrage, animations disponibles, gabarit de la scène) avant de construire la version New Era.
- Appliquer les règles générales du fichier de méthode : Qulbutoké et Okéoké doivent réagir à l'arrivée du héros, se tourner vers lui, ne pas rester des figurants statiques.
- Le dialogue d'examen doit refléter la personnalité de Qulbutoké : dans le matériel officiel, ce Pokémon a un mode d'expression particulier (il ne parle généralement qu'en répétant son propre nom) — décider explicitement si New Era reprend cette convention ou lui donne un vrai dialogue articulé, et l'appliquer de façon cohérente partout où Qulbutoké apparaît dans le projet, pas au cas par cas.
- Le déblocage du donjon doit être mis en scène (annonce, réaction du héros, éventuellement un aperçu du nouveau donjon sur une carte), pas un simple changement silencieux d'état de variable de sauvegarde.

**Cohérence avec le reste du projet**
- Le badge requis pour débloquer cette quête doit correspondre à un jalon de progression déjà cohérent avec la structure narrative des chapitres (`structure_narrative_donjons_par_chapitre.md`).
- Le donjon débloqué doit lui-même respecter les règles déjà établies de conception par biome et de placement de boss/mini-boss si applicable (`conception_donjons_segmentes.md`, `arenes_boss_arc_tournoi.md`).

## Quête 2 — Construction de la base personnelle (adaptation du Bois Brouhaha)

**Principe** : reprendre la structure canonique de la quête du Bois Brouhaha (Uproar Forest) de Red/Blue Rescue Team, où le duo Okéoké/Qulbutoké est directement à l'origine de la construction de la base du joueur, et l'adapter à l'univers et à la progression de New Era.

**Structure canonique de référence (pmd-red), à adapter**
1. **Condition de déblocage** : dans le jeu d'origine, la quête se débloque après un jalon de progression précis (fin d'un donjon donné + un nombre de missions accomplies). Définir l'équivalent New Era de ce jalon, cohérent avec la structure narrative déjà posée (`structure_narrative_donjons_par_chapitre.md`).
2. **Déclenchement** : Okéoké et Qulbutoké abordent le héros pour lui proposer une mission liée au donjon du Bois Brouhaha (ou son équivalent adapté à New Era).
3. **Traversée du donjon** : le joueur parcourt le donjon, avec un combat de boss en fin de parcours contre un groupe de Pokémon adverses (trois Grahyèna/Mankey dans l'original — définir l'équivalent New Era cohérent avec le biome du donjon et les règles déjà établies pour les boss/mini-boss, `boss_miniboss_narration_voix.md`).
4. **Reconstruction de la base** : une fois le donjon complété, Okéoké, Qulbutoké, Chenipan (Caterpie) et les Pokémon vaincus participent ensemble à la reconstruction/amélioration de la base du héros — moment à mettre en scène comme une vraie séquence collective, pas un simple écran de transition.
5. **Complication narrative intermédiaire** : dans l'original, les Mankey se mettent en grève à mi-chantier tant qu'ils n'obtiennent pas des marrons. Ce type de complication légère et bienvenue peut être repris ou adapté avec un obstacle propre à New Era, pour garder un moment de respiration comique cohérent avec le ton déjà établi pour ce genre de scène (cf. l'exemple Galon/Shuca déjà écrit pour le projet).
6. **Reprise de la trame principale** : une fois la reconstruction terminée, l'histoire principale reprend son cours — s'assurer que cette reprise s'articule proprement avec le chapitre en cours plutôt que de laisser la quête comme un aparté isolé.

**Exigences techniques**
- Les assets de base (structure, décor, éléments à débloquer/améliorer) sont à extraire de `pret/pmd-red` et, si pertinent, d'`ExplorersOfSkyOrigins` pour la version déjà adaptée au moteur PMDO — privilégier cette seconde source quand un équivalent existe déjà en format PMDO, pour limiter le travail de conversion (cf. `outil_conversion_assets_pmdsky.md` si une conversion reste nécessaire malgré tout).
- La progression de construction/amélioration de la base doit rester cohérente avec le rythme de progression du joueur plutôt que débloquée en un seul bloc.
- La base doit s'intégrer au monde vivant déjà défini pour le projet (`systeme_raid_ville_vivante.md`) une fois construite.

## Auto-questionnement avant de valider ces quêtes

- L'analyse d'ExplorersOfSkyOrigins et de pmd-red a-t-elle bien été faite avant l'écriture des scènes, plutôt que devinée ?
- Le duo Qulbutoké/Okéoké réagit-il et se met-il en scène conformément aux règles générales, plutôt que de rester figé pendant les dialogues ?
- Le mode d'expression de Qulbutoké est-il traité de façon cohérente partout où il apparaît dans le projet ?
- L'équivalent New Era du combat de boss du Bois Brouhaha respecte-t-il les règles de justification narrative déjà établies pour les boss/mini-boss ?
- La reconstruction de la base est-elle mise en scène comme un moment collectif marquant, et non comme une simple transition silencieuse ?
- La reprise de la trame principale après cette quête est-elle fluide, ou la quête reste-t-elle un aparté déconnecté du chapitre en cours ?
