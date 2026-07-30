# Directive de méthode — New Era : Abyss to Ascension

## 0. Compréhension globale avant tout développement

Ne développe jamais une fonctionnalité ou une cinématique de manière isolée. Avant de coder ou d'écrire quoi que ce soit :

- Acquiers une vision globale de la trame scénaristique, de l'architecture du projet et du fonctionnement du moteur PMDO, pour que chaque modification s'intègre naturellement à l'ensemble.
- Lis et analyse la documentation disponible, les scripts existants, les Grounds, les Entrances, les Donjons et les cinématiques déjà validées.
- Comprends les capacités et contraintes du moteur : scripting, gestion des événements, caméra, animations, déplacements, dialogues, transitions, GroundMaps, Donjons, objets interactifs.
- Maîtrise la chronologie narrative complète : relations entre personnages, personnalité, rôle dans la Guilde, motivations, connaissances à chaque instant de l'histoire, évolution au fil des chapitres. Un personnage ne doit jamais agir ou parler d'une façon qui contredit ce qu'il sait, ce qu'il a vécu ou son caractère.

### Connaissance exhaustive du projet

Cette compréhension globale n'est pas une lecture rapide ou un survol : elle implique de **connaître le projet par cœur**, au même titre qu'un scénariste connaît par cœur la série sur laquelle il travaille.

- Lire l'intégralité des dialogues de tous les chapitres déjà écrits, pas seulement ceux de la scène en cours ou du chapitre le plus récent.
- Lire l'intégralité des cinématiques déjà produites (chapitre par chapitre), y compris celles qui semblent sans lien direct avec la tâche en cours — une réplique ou un détail posé au chapitre 1 peut conditionner une scène du chapitre 20.
- Retenir, pour chaque personnage : ce qu'il sait à un instant T, ce qu'il ignore encore, ce qu'il a vécu, comment son caractère et sa façon de parler ont évolué au fil des chapitres.
- Retenir la chronologie exacte des événements et les liens de cause à conséquence entre les chapitres, pour ne jamais écrire une scène qui présuppose une information que le personnage ne devrait pas encore avoir, ou qui contredit un événement déjà posé ailleurs.
- Avant toute nouvelle tâche, si un doute existe sur un fait narratif (ce qu'un personnage sait, un événement passé, une relation entre deux personnages), relire les chapitres et cinématiques concernés plutôt que de supposer ou d'improviser. Une hypothèse non vérifiée sur la continuité est une source directe d'incohérence.
- Cette exigence s'applique en continu : à chaque nouveau chapitre ou cinématique ajouté au projet, l'intégrer à cette connaissance d'ensemble avant de travailler sur la suite.

Avant de travailler sur une scène, pose-toi systématiquement :
- Qu'est-ce qui s'est passé avant ?
- Pourquoi cette scène existe-t-elle ?
- Quelles informations les personnages possèdent-ils à cet instant ?
- Quelles seront les conséquences de cette scène sur la suite de l'histoire ?
- Cette scène est-elle cohérente avec les chapitres précédents et prépare-t-elle correctement les suivants ?
- Le moteur permet-il une meilleure mise en scène que celle actuellement proposée ?

Le moteur n'est pas une simple contrainte technique : cherche systématiquement l'usage le plus intelligent de ses capacités. Avant d'implémenter une solution, demande-toi s'il n'existe pas une approche plus propre, plus élégante, plus immersive ou plus fidèle à Pokémon Mystery Dungeon.

Raisonne simultanément comme développeur, game designer, narrative designer, level designer, cinematic designer et testeur qualité. L'objectif n'est pas seulement que le contenu fonctionne, mais qu'il soit cohérent avec le reste du projet, exploite correctement le moteur, et atteigne un niveau de finition digne d'un jeu officiel. Chaque modification suit deux phases : analyse/réflexion, puis audit/validation.

## Principe général (cinématiques)

N'exécute jamais une liste d'événements de façon mécanique. Avant d'écrire ou de modifier une cinématique, pense en scénariste-réalisateur : pour chaque personnage présent, demande-toi *« Que ferait-il à cet instant précis, compte tenu de son rôle, de son caractère, de ce qu'il voit, entend et sait ? »*. Chaque action doit avoir une raison d'être et découler logiquement de la situation.

**Exemple de référence (Mont Windsep)** : si le héros se réveille brusquement d'un cauchemar alors que Philéas assure la veille nocturne, celui-ci ne peut pas rester passif. Son rôle de mentor et de vétéran implique qu'il réagisse aussitôt : lever la tête, se tourner vers le héros, s'approcher, s'arrêter à une distance crédible, engager le dialogue, chercher à le rassurer, puis reprendre son poste. Un personnage important qui reste inactif alors qu'il devrait intervenir casse la crédibilité de la scène.

## Règles de mise en scène

**Personnages toujours actifs**
- Aucun personnage ne doit rester figé en attendant son tour de parole.
- Chaque dialogue s'accompagne de mise en scène : déplacements, changements de direction, regards, animations d'émotion, pauses, réactions, mouvements de caméra.

**Orientation et regard**
- Un personnage qui parle doit tourner la tête ou le sprite vers son interlocuteur.
- Quand un nouveau personnage intervient, les autres se tournent vers lui.
- Tout bruit, événement ou explosion doit déclencher un regard vers la source avant toute réaction.

**Déplacements crédibles**
- Un personnage ne se téléporte jamais mentalement d'un état à un autre.
- Il marche jusqu'à son interlocuteur, s'arrête à une distance naturelle, se retourne si besoin, puis parle.
- Une fois la conversation terminée, il reprend son activité ou quitte la scène de façon logique.
- Pas de changement de direction aléatoire, de rotation gratuite ou de déplacement sans justification.

**Positionnement**
- Les PNJ ne se superposent jamais, ne se bloquent pas mutuellement et ne sortent pas du champ de caméra pendant une scène importante.
- Les formations doivent paraître naturelles et rendre la scène lisible.
- Les protagonistes principaux restent visibles quand c'est nécessaire ; la caméra suit intelligemment les déplacements.
- Dans les déplacements de groupe (ex. Mont Windsep), garder un espacement crédible entre les Pokémon : éviter les groupes trop compacts qui donnent une impression de blocage ou de collage.

## Dosage des réactions, orientation relative et mouvements superflus

Cette section précise et durcit les règles d'orientation et de réactivité déjà posées plus haut : être "vivant" ne veut pas dire s'agiter, et réagir ne veut pas dire copier la même rotation pour tout le monde.

**Retournement selon la position relative réelle**
Quand un personnage parle ou qu'un événement attire l'attention, chaque autre Pokémon présent dans la scène doit se réorienter en fonction de **sa propre position géométrique** par rapport à la source — pas d'une rotation uniforme identique appliquée à tout le groupe :
- Un personnage placé **derrière** celui qui parle pivote pour regarder par-dessus son épaule ou se décale légèrement pour avoir un angle de vue dégagé.
- Un personnage placé **sur le côté** pivote latéralement, d'un angle cohérent avec la distance et l'angle réels qui le séparent du locuteur.
- Un personnage déjà **devant ou face à lui** peut se contenter d'un mouvement plus discret (inclinaison de tête, léger recentrage du regard) puisqu'il est déjà globalement tourné dans la bonne direction.

Ne jamais traiter l'orientation comme un simple interrupteur "tourné vers / pas tourné vers" appliqué identiquement à tous les personnages de la scène : chaque position dans l'espace appelle un ajustement différent.

**Interdiction du figement directionnel**
Aucun personnage ne doit rester tourné dans une direction qui ne correspond plus au foyer d'attention réel de la scène pendant qu'un autre personnage parle ou agit. Si le focus narratif change (un nouveau personnage prend la parole, un événement se produit ailleurs dans le cadre), l'orientation de chaque personnage présent doit se mettre à jour en conséquence, pas seulement celle du personnage principal de la scène.

**Absence de mouvement inutile (idle parasite)**
Être vivant ne signifie pas bouger en permanence. Un personnage qui n'a aucune raison narrative de bouger à un instant donné doit rester dans une pose d'attente crédible (idle discret, respiration, clignement) plutôt que de produire une animation ou un déplacement sans fonction. Tout mouvement doit être justifiable : réaction à un événement, réorientation vers un nouveau locuteur, déplacement logique vers un point de la scène. Un tic ou une agitation ajoutée uniquement pour "remplir" visuellement la scène a l'effet inverse de celui recherché : elle distrait du foyer d'attention réel et casse la lisibilité plutôt que de renforcer l'immersion.

**Dosage des émotions et réactions**
Les réactions doivent être présentes et perceptibles, mais dosées : ne pas sur-jouer systématiquement chaque ligne de dialogue avec une réaction marquée. Réserver les réactions les plus visibles (surprise appuyée, grande émotion, gag comique) aux moments qui le méritent réellement, et garder les échanges ordinaires sur un registre plus sobre. C'est ce contraste — entre les moments calmes et les moments où la réaction est marquée — qui donne au joueur l'impression de suivre un monde véritablement vivant et attachant, plutôt qu'une succession de réactions uniformément exagérées qui finit par lasser.

**Mouvement de caméra justifié**
Un mouvement de caméra n'est légitime que s'il sert un besoin réel de la scène : suivre un déplacement de personnage, révéler une direction ou un élément important, souligner une composition ou une émotion. Si la scène reste lisible et efficace avec un cadrage fixe, ne pas ajouter de mouvement de caméra superflu pour "dynamiser" artificiellement une scène qui n'en a pas besoin.

**Disposition et positionnement au service de la lisibilité**
La disposition des Pokémon dans la scène doit être pensée pour que chaque réorientation reste visible et lisible à l'écran : éviter les positions qui masqueraient un personnage derrière un autre au point de rendre sa réaction invisible pour le joueur, ou qui rendraient un retournement incohérent avec l'espace réel de la scène (un personnage qui se retourne vers un point hors-champ, par exemple).

**Référence de dosage** : s'appuyer sur les cinématiques déjà validées du projet (chapitres 1 à 5, jusqu'à l'entrance du Mont Windsep) comme repère concret de ce niveau de dosage — ni sous-jouées, ni excessives.

## Audit final (obligatoire avant de considérer une scène terminée)

Vérifier systématiquement :
1. Réactions de chaque personnage aux événements
2. Positionnement et déplacements
3. Orientation (regardent-ils leur interlocuteur / la source d'un événement ?)
4. Animations et expressions
5. Cohérence dialogues / émotions
6. Mouvements de caméra — mouvement doux, sans exclure d'entités actives hors champ
7. Distances entre personnages — espacement naturel, notamment dans les déplacements de groupe (cf. retour Mont Windsep)
8. Entrées et sorties de scène
9. Collisions et superpositions
10. Continuité entre cinématiques et Grounds
11. Orientation de chaque personnage réajustée selon sa position réelle (derrière / côté / devant) par rapport au foyer d'attention actuel
12. Absence de mouvement ou d'idle superflu sans justification narrative
13. Dosage des réactions : les moments marquants ressortent-ils par contraste avec des échanges plus sobres, ou tout est-il joué au même niveau d'intensité ?

**Test de crédibilité** : si un joueur peut se demander *« Pourquoi ce personnage ne réagit-il pas ? »*, *« Pourquoi personne ne regarde celui qui parle ? »*, *« Pourquoi ce PNJ reste immobile ? »*, *« Pourquoi ce personnage ne s'approche-t-il pas ? »* ou *« Pourquoi cette réaction paraît-elle artificielle ? »* — la scène n'est pas terminée. Corrige-la jusqu'à ce que chaque personnage donne l'impression de vivre réellement la scène.

**Objectif final** : chaque cinématique doit pouvoir être confondue avec une cinématique officielle de Pokémon Mystery Dungeon, tant par l'écriture que par la mise en scène, le langage corporel, le comportement des personnages et le niveau de finition.

**Repère qualité déjà validé** : les cinématiques des chapitres 1 à 5 de New Era, jusqu'à l'entrance du Mont Windsep incluse (polish & fix effectués), correspondent au niveau attendu. S'en servir comme référence de comparaison pour tout nouveau contenu.

## Auto-questionnement : esthétique et positionnement sur le Ground

Avant de valider une scène ou une transition sur un Ground, se poser systématiquement :

**Positionnement des personnages**
- Le placement de chaque PNJ sur le Ground est-il justifié par son rôle et son emploi du temps (garde en faction, marchand à son étal, PNJ en veille, PNJ endormi) ?
- Le nombre de Pokémon présents sur le Ground après une cinématique est-il cohérent avec la narration ? (ex : un lieu ne doit pas se vider intégralement sans raison scénarisée)
- Les personnages qui doivent logiquement rester (parce qu'ils vivent là, montent la garde, etc.) sont-ils toujours présents, ou ont-ils disparu par erreur technique ?

**Collisions et décor**
- Les éléments de décor solides (feu de camp, rochers, meubles, tentes) bloquent-ils réellement le passage, ou le joueur/PNJ peut-il traverser un objet censé être un obstacle ?
- Reste-t-il des objets visuels temporaires (sacs, effets de quête, marqueurs) que la scène aurait dû faire disparaître une fois leur rôle narratif terminé ?

**Cohérence sonore et élémentaire**
- Le bruitage associé à une action (objet utilisé, capacité, soin) correspond-il au personnage qui l'exécute (son type, sa personnalité, sa cohérence interne) ?
- Dans une séquence de rêve, de vision ou de flashback, seuls les sons justifiés narrativement doivent être audibles — un bruitage du monde réel qui n'a aucune raison de s'y trouver casse l'immersion.

**Ton et rythme**
- Une rupture de ton (moment comique après une scène tendue, OST qui détend l'ambiance) est-elle amenée de façon crédible, avec une transition qui justifie le changement plutôt qu'un contraste brutal et gratuit ?
- Chaque personnage réagit-il à l'écart de ton avec sa propre personnalité (l'un lance la blague, l'autre s'agace, un troisième reste sérieux) plutôt que tous réagissant de façon uniforme ?

Si l'une de ces questions révèle une incohérence, la scène n'est pas terminée : elle doit être corrigée avant validation.

## Transitions entre scènes et entre lieux

Une transition n'est jamais un simple effet technique posé entre deux blocs de contenu : elle fait partie de la mise en scène et doit être pensée comme telle. Un fondu mal calé casse l'immersion aussi sûrement qu'un personnage qui ne réagit pas.

**Avant d'implémenter une transition, se demander :**
- Quel type de transition sert le mieux ce changement de lieu ou de temps (fondu au noir, fondu enchaîné, coupe directe, transition avec chargement) ? Le choix doit être justifié par la nature du changement (ellipse temporelle, changement de zone, réveil, mort/évanouissement, retour en arrière), pas posé par défaut.
- Le timing du fondu est-il calé sur la fin réelle de l'action en cours, ou coupe-t-il un mouvement, une réplique ou une animation avant qu'elle soit terminée ?
- À l'entrée dans le nouveau lieu, le fondu se lève-t-il une fois que tout est en place (caméra positionnée, personnages à leur point de départ, décor chargé), ou le joueur voit-il une image incomplète, un personnage encore en train de se placer, ou un pop-in de décor ?
- Y a-t-il un flottement injustifié (silence ou écran noir trop long) entre la fin d'une scène et le début de la suivante, ou à l'inverse un enchaînement trop brusque qui ne laisse pas respirer le changement de lieu ?
- Le son (OST, ambiance, bruitages) suit-il la logique de la transition, ou coupe-t-il/reprend-il de façon incohérente avec l'image (musique de l'ancienne zone qui continue après le fondu, silence soudain, coupure sèche d'un morceau) ?
- Si la transition marque un changement d'état du personnage (sortie de rêve, perte de conscience, téléportation), l'effet visuel choisi correspond-il à ce changement d'état, ou est-ce un fondu générique réutilisé sans distinction ?

**Test de crédibilité spécifique aux transitions** : si un joueur peut se demander *« Pourquoi ce fondu tombe-t-il à ce moment précis ? »*, *« Pourquoi je vois encore le lieu précédent alors que le nouveau a déjà commencé ? »*, *« Pourquoi ce silence / cette coupure de musique ? »* ou *« Pourquoi ça met du temps à charger devant moi ? »*, la transition n'est pas terminée.

**Exemple identifié à corriger — Tunnel du Mont Windsep** : un fondu mal exécuté a été relevé sur cette transition (timing incorrect). C'est un cas concret à utiliser comme référence négative : avant de considérer une transition comme validée, la comparer à ce défaut connu pour vérifier qu'il n'a pas été reproduit ailleurs.

## Directive de revue — Mont Windsep

Le Mont Windsep dans son intégralité (Grounds, Entrance, Donjon, cinématiques, transitions) doit être repassé au crible de l'ensemble des règles de ce document — mise en scène, positionnement, audit final, esthétique du Ground, et transitions — et pas uniquement sur le point du fondu du tunnel déjà identifié.

Procéder scène par scène et transition par transition :
1. Lister chaque cinématique et chaque transition de zone du Mont Windsep.
2. Pour chacune, appliquer l'audit final (10 points) et le test de crédibilité.
3. Pour chaque transition, appliquer spécifiquement la checklist de la section précédente.
4. Consigner les incohérences trouvées avec leur localisation précise (fichier + scène), sans se limiter au fondu du tunnel déjà signalé.
5. Ne corriger que ce qui est confirmé comme incohérent après audit — ne pas modifier une scène qui passe déjà le test de crédibilité, pour éviter toute régression sur du contenu déjà validé.

## Outils internes à concevoir (pipeline de production)

Ne te contente pas de produire du contenu : conçois aussi tes propres outils de travail. Si une tâche est répétitive, complexe ou soumise à de nombreux critères de qualité, crée un outil, un générateur, une checklist ou un workflow qui garantit le respect systématique des exigences du projet.

Construis progressivement une suite d'outils internes dédiée à New Era, par exemple :
- un **générateur de cinématiques** construisant une scène selon les standards PMD et les critères de ce projet ;
- un **analyseur de cohérence scénaristique** vérifiant personnages, réactions, connaissances, motivations et causalité des événements ;
- un **vérificateur de mise en scène** contrôlant caméra, déplacements, animations, rotations de sprites, regards, pauses, émotions, effets visuels et rythme ;
- un **audit de Ground** détectant les incohérences de mapping, collisions, positionnement des PNJ, décor, objets interactifs et continuité inter-maps ;
- un **analyseur de dialogues** détectant conversations artificielles, transitions brusques, répétitions, ruptures de sujet incohérentes, personnages hors-caractère ;
- un **contrôleur de continuité** comparant chapitres, cinématiques et Grounds pour éviter les contradictions.

Ces outils doivent être spécifiques à New Era et intégrer tous les critères de qualité de ce projet — pas génériques. À chaque nouvelle exigence, fais-les évoluer pour qu'ils la contrôlent automatiquement lors des générations suivantes.

Une cinématique générée doit couvrir : découpage cinématographique, storyboard des événements, placements initiaux, déplacements, orientations, regards, animations et émotions, mouvements de caméra, effets visuels et sonores, temps de pause, rythme narratif, transitions, conditions de déclenchement, conséquences sur les scènes suivantes. Chaque scène générée doit ensuite être confrontée automatiquement aux outils d'analyse avant d'être considérée comme terminée.

Objectif : un véritable pipeline de production digne d'un studio de développement, où chaque nouvel outil améliore la qualité des générations suivantes, réduit les erreurs, empêche la réapparition d'anciens bugs, et fait progresser le niveau de finition en continu. Face à une erreur récurrente, ne te contente pas de la corriger : améliore l'outil ou le processus pour qu'elle ne puisse plus se reproduire.
