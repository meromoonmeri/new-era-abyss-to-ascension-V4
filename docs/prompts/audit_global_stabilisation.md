# Audit global & Fix — Préparation d'une version stable pour les joueurs

## Objectif

Réaliser un audit complet et systématique de l'ensemble du projet New Era, identifier chaque incohérence, chaque bug, chaque élément sous le niveau de qualité attendu, et les corriger, dans le but de produire une version stable, jouable de bout en bout, sans régression, prête à être mise entre les mains des joueurs. Ce n'est pas un audit ciblé sur un point précis : c'est une revue de **tout ce qui existe déjà** dans le projet, chapitre par chapitre, zone par zone, système par système.

## Méthodologie d'audit

Ne jamais valider un élément sur la seule base qu'il "compile" ou qu'il "semble correct" à la lecture du script. Reprendre ici le principe déjà établi (Règle 6 du fichier de méthode général) : **seul un test réel en jeu constitue une validation**. Pour chaque élément audité :

1. Identifier précisément ce qui doit être vérifié.
2. Tester ou inspecter l'élément réellement (en jeu si possible, sinon par lecture rigoureuse du script avec preuve fichier + ligne, jamais par supposition).
3. Si un problème est trouvé, le documenter précisément (fichier, ligne, nature du problème) avant de le corriger.
4. Corriger uniquement ce qui est confirmé comme problématique — ne pas retoucher un élément qui passe déjà l'audit, pour éviter toute régression sur du contenu déjà validé.
5. Si un test en jeu est impossible dans l'environnement de travail actuel, le dire explicitement et lister précisément ce que l'utilisateur devra vérifier manuellement.

## Domaine 1 — Cartographie : Grounds, Donjons, zones

- Chaque Ground et chaque zone de Donjon doit être fonctionnelle : pas de blocage de passage involontaire, pas de zone inaccessible, pas de collision manquante ou mal posée (cf. le cas déjà identifié du feu de camp traversable).
- Chaque map doit être **unique** : vérifier qu'aucune zone ne réutilise un gabarit ou une combinaison biome/tileset déjà utilisée ailleurs sans variation suffisante (cf. exigence de diversité de `outil_generateur_entrance_donjon.md` et de `conception_donjons_segmentes.md`).
- Vérifier la progression de biome au sein de chaque donjon à segments : cohérence du dégradé visuel entre le début, les relais et le sommet (cf. audit déjà défini pour le Mont Windsep, à généraliser à tous les donjons à segments du projet).
- Vérifier que les points de relais restaurent bien PP et estomac, et que les rencontres de Pokémon inoffensifs sont présentes là où prévu.
- Vérifier l'absence d'objets ou d'éléments visuels résiduels laissés par erreur (sacs, marqueurs de quête, effets non nettoyés en fin de cinématique).

## Domaine 2 — Positionnement et mise en scène des entités

- Aucun personnage ne doit se retrouver hors champ caméra à un moment où il devrait être visible.
- Le placement de chaque entité (PNJ, personnage principal, Pokémon sauvage inoffensif) doit être esthétiquement composé, jamais posé au hasard — arrivée, formation de groupe, distances entre personnages.
- Vérifier l'absence de superpositions, de blocages mutuels entre PNJ, de sorties de champ pendant une scène importante.
- Revérifier spécifiquement les points déjà signalés comme problématiques (espacement des groupes de Pokémon trop serré au Mont Windsep, positionnement des PNJ en général) pour confirmer qu'ils sont bien résolus partout, pas uniquement à l'endroit initialement signalé.

## Domaine 3 — Dynamisme du monde (rien de mécanique)

- Aucun personnage ou PNJ ne doit se comporter de façon purement mécanique : chaque entité présente dans une scène doit réagir, regarder, se déplacer avec une justification.
- Vérifier que les PNJ significatifs ont une position qui peut varier selon le contexte temporel du jeu, et un dialogue cohérent avec les événements récents de l'histoire (cf. `systeme_raid_ville_vivante.md`).
- Vérifier que Metano Town et les autres lieux de vie donnent une impression de continuité vivante (cycle jour/nuit cohérent, scènes de vie en arrière-plan), pas de décor figé peuplé de statues.
- Vérifier que chaque boss et mini-boss dispose bien de sa justification narrative propre, et que la Voix n'apparaît que dans les cas rares et justifiés définis (`boss_miniboss_narration_voix.md`).

## Domaine 4 — Qualité de la langue française

- Relire l'intégralité des dialogues et textes d'interface pour s'assurer d'un français idiomatique, fidèle au registre de chaque personnage et à l'ambiance Pokémon Mystery Dungeon.
- Traquer systématiquement tout résidu de texte en anglais dans le projet (dialogues, textes d'interface, titres de chapitre, textes de chargement) et le traduire — aucun résidu ne doit subsister dans la version livrée aux joueurs.
- Vérifier que les clés de traduction respectent la séparation déjà établie (EN dans `strings.resx`, FR dans `strings.fr.resx`), et qu'aucun texte n'est resté codé en dur dans le Lua.
- Vérifier les écrans d'ouverture de chapitre : titre en français correctement traduit et stylisé, image de fond dédiée et distincte pour chaque chapitre, filtre assombrissant appliqué correctement.

## Domaine 5 — Systèmes de jeu

- Système de raid : revalider son bon fonctionnement de bout en bout, en cohérence avec les corrections déjà demandées (`systeme_raid_ville_vivante.md`).
- Shops et PNJ interactifs (dont Rondoudou) : vérifier qu'ils sont bien interactifs et correctement positionnés, sans blocage de circulation.
- Vérifier la génération procédurale des étages de donjon : variété suffisante, courbe de difficulté cohérente, biome constant au sein d'un même segment malgré la variation de layout.
- Vérifier les entrances de donjon générées : diversité effective, transition de tileset cohérente, absence de doublon avec une entrance déjà existante — sans toucher aux entrances déjà validées des chapitres 1 à 5.

## Domaine 6 — Boss, mini-boss et arènes

- Chaque arène de boss/mini-boss est cohérente avec le biome de son donjon et l'identité du légendaire ou du Pokémon concerné.
- Chaque boss et mini-boss dispose d'une histoire, d'une motivation, et d'une conséquence narrative à l'issue du combat.
- Vérifier la distribution des donjons à boss sur l'ensemble de l'histoire (30 à 99 étages cumulés) reste cohérente avec la progression narrative en l'état actuel du contenu produit.
- Vérifier l'arc tournoi : cohérence des équipes, intégration à la trame principale, absence de rupture narrative.

## Domaine 7 — Narration et continuité

- Vérifier chapitre par chapitre le respect de la structure de 3 à 5 donjons à partir du chapitre 6, avec une fonction narrative claire pour chaque donjon.
- Vérifier que le foreshadowing posé est effectivement payé au bon moment, et qu'aucun élément planté n'est resté sans suite.
- Vérifier l'absence de contradiction entre chapitres (fait narratif, connaissance d'un personnage, événement déjà posé ailleurs).
- Vérifier que la trajectoire actuelle du scénario reste cohérente avec une conclusion au chapitre 32 sur le boss final, en l'état d'avancement réel du contenu.

## Domaine 8 — Stabilité technique

Reprendre les règles déjà établies du fichier projet pour la validation technique :
- Vérification d'intégrité du dépôt avant et après l'audit (fichiers attendus présents, pas de suppression accidentelle de binaires).
- Traçage des `require` Lua pour toute fonction appelée, afin d'éliminer les erreurs de type `attempt to call a nil value`.
- Reprise et clôture des bugs déjà connus et listés dans l'état du projet (crash `vast_steppe`, doublons de sacs et blocage de Penticus à `searing_tunnel_entrance`, coffre bugué, effets de vertige/rêve non chargés, branche défaite Zarude au chapitre 6, cycle nuit de Metano Town).
- Commits séparés par domaine corrigé, jamais un commit fourre-tout, avec mise à jour de `PROJECT_CONTEXT.md` en fin de session (ce qui a été fait, ce qui reste, bugs connus non résolus).

## Critère de sortie d'une version stable

Une version n'est considérée stable et prête pour les joueurs que si :
- le jeu se lance et se joue sans erreur bloquante en jeu, du chapitre 1 au dernier chapitre produit ;
- aucun des domaines ci-dessus ne présente d'incohérence connue et non documentée ;
- tout bug non corrigé est explicitement listé avec sa localisation et son impact, pour que rien ne soit livré silencieusement en l'état.

"Le code compile" n'est jamais un critère suffisant. Le seul critère valide reste : le jeu se lance et se joue sans erreur en jeu.

## Checklist de clôture d'audit

- Toutes les maps sont-elles uniques et fonctionnelles, sans collision incohérente ?
- Le positionnement de chaque entité est-il esthétiquement composé, sans hors-champ ni superposition ?
- Chaque personnage et PNJ se comporte-t-il de façon dynamique et réactive, sans figuration mécanique ?
- Le français est-il impeccable partout, sans résidu d'anglais ?
- Les systèmes de jeu (raid, shops, génération procédurale, entrances) fonctionnent-ils tous correctement ?
- Chaque boss/mini-boss a-t-il sa justification narrative et son arène cohérente ?
- La narration reste-t-elle cohérente de bout en bout, foreshadowing payés et contradictions éliminées ?
- Le dépôt est-il technique­ment sain (intégrité des fichiers, requires tracés, bugs connus traités ou documentés) ?

Si l'une de ces questions révèle une incohérence non documentée, la version n'est pas prête à être livrée.
