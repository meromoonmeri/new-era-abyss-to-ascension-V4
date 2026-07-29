# PROMPT MAÎTRE — New Era : Abyss to Ascension (PMDO)

> **À lire intégralement avant de commencer quoi que ce soit.**
> Document unique de référence — fusionne toutes les directives méthode.
> Dernière mise à jour : 2026-07-29.
> Remplace `prompt_mise_en_scene_optimise.md` (contenu intégré ci-dessous).

---

## Dépôt du projet

<https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4>

---

## Documentation de référence

### Moteur et systèmes

| Ressource | Lien |
|---|---|
| RogueEssence (moteur) | <https://github.com/RogueCollab/RogueEssence> |
| Doc Lua | <https://github.com/RogueCollab/RogueEssence/tree/master/RogueEssence/Lua> |
| RogueElements (génération) | <https://github.com/audinowho/RogueElements> |
| PMDC (combat Pokémon) | <https://github.com/PMDCollab/PMDC> |

### Contenu et assets

| Ressource | Lien |
|---|---|
| PMDODump | <https://github.com/audinowho/PMDODump> |
| PMDODump releases | <https://github.com/audinowho/PMDODump/releases> |
| DumpAsset | <https://github.com/audinowho/DumpAsset> |

### PMDOTutorial — leçons

| Leçon | Lien | Tâche prioritaire |
|---|---|---|
| 1 — Hub Map | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.1> | Créer/modifier une ville |
| 2 — Ground Maps | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.2> | Créer/modifier une ground map |
| 3 — Dungeon Maps | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.3> | Créer/modifier un donjon |
| 4 — Vidéo | <https://youtu.be/RiG50ysQlRc> | Ground maps (complément) |
| 5 — Multi-Floor | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.5> | Génération multi-étages |
| 6 — Cutscenes | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.6> | Écrire une cinématique |
| 7 — Boss Battle | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.7> | Créer un combat de boss |
| 8 — Save Variables | <https://github.com/audinowho/PMDOTutorial/releases/tag/v0.8> | Variables de sauvegarde |
| Index complet | <https://github.com/audinowho/PMDOTutorial/releases> | — |

### Wiki PMDO

| Page | Lien |
|---|---|
| Floor Generation Overview | <https://wiki.pmdo.pmdcollab.org/Floor_Generation_Overview> |
| Text Guide | <https://wiki.pmdo.pmdcollab.org/Text_Guide> |
| Scripting Cheat Sheet | <https://wiki.pmdo.pmdcollab.org/Scripting_Cheat_Sheet> |
| Script Reference | <https://wiki.pmdo.pmdcollab.org/Script_Reference> |

### Sources interdites

Tout dépôt de décompilation, remake, ou extraction de jeu commercial
Nintendo/Chunsoft. Inspection visuelle ou structurelle uniquement, jamais
d'extraction de fichiers.

---

## SYSTÈME DE QUESTIONS

Avant de commencer, si l'une de ces situations se présente, poser la
question à l'utilisateur via le menu de questions plutôt que de supposer.

### Questions systématiques en début de session

1. Y a-t-il un `PROJECT_CONTEXT.md` à lire ? Si non, résumer l'état connu
   et demander confirmation.
2. La tâche concerne-t-elle un fichier non vu en session actuelle ? Si oui,
   le lire avant de proposer quoi que ce soit.

### Ambiguïté narrative

- Conflit de noms : **« Lockpin désigne-t-il le personnage des Trois Reines
  ou le surnom d'espèce de Lopunny dans Team Dazzling ? »**
- Légendaire : **« Est-ce un moment d'enjeu narratif fort, ou dois-je
  éviter les légendaires ici ? »**
- Tonalité : **« Quel registre émotionnel pour cette scène ? »**

### Ambiguïté technique

- Asset manquant : **« Dois-je créer un remplacement ou attendre ? »**
- Bug à double solution : **« Option A (impact) ou option B (impact) ? »**
- Fichier hors périmètre : **« Je touche Y pour corriger X, ou je signale ? »**
- Durée insuffisante : **« Chapitre X = ~N min, objectif Y — je continue ? »**

### Ce qu'on ne demande PAS

- Pas de question sur des choses vérifiables dans le dépôt
- Pas de question rhétorique
- Pas plus de 2-3 questions en même temps

---

## RÈGLES FONDAMENTALES

### RÈGLE 1 — Vérification d'intégrité avant toute session

```bash
git status
find Data/Ground -name "*.rsground" | wc -l    # ~68+ attendus
find Content/Tile -name "*.tile" | wc -l        # ~248+ attendus
find Content/Music -name "*.ogg" | wc -l        # ~51+ attendus
ls -lh Data/Ground/metano_town.rsground          # ~37 Mo
```

Si un fichier attendu est absent : `git checkout HEAD -- <fichier>` AVANT
tout travail. Ne jamais `git add -A` si `git status` affiche `deleted:`
sur des binaires.

### RÈGLE 2 — Lire PROJECT_CONTEXT.md en premier

S'il existe à la racine : le lire intégralement. S'il n'existe pas : le
créer à la fin de la session. Le mettre à jour à chaque session productive.

### RÈGLE 3 — Identité technique (NE JAMAIS MODIFIER)

- `Mod.xml` > `<Namespace>` : **`halcyon`**
- `Mod.xml` > `<UUID>` : **`CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF`**

Modifier = toutes les sauvegardes invalides.

### RÈGLE 4 — Architecture Lua : tracer chaque require

```
main.lua (persistant)
 ├─ halcyon.services.debug_tools / menu_tools / upgrade_tools / config_tools
 ├─ halcyon.newera_common   (Say, Cutscene, IsChapterComplete...)
 └─ halcyon.newera_include  (CompleteChapter, GetCurrentChapter...)

event.lua
 └─ origin.common / halcyon.event_single / event_battle / event_misc

ground/<map>/init.lua
 └─ require explicite de CHAQUE _ch_N.lua dont il appelle les fonctions
```

**Règle absolue** : si une fonction est appelée, remonter jusqu'au require
qui la charge. Un require manquant = `attempt to call a nil value`.

### RÈGLE 5 — Preuve avant hypothèse

Chaque affirmation cite : **fichier + ligne + justification**.
Interdit : "probablement", "devrait être", "normalement".

### RÈGLE 6 — Zéro bug accepté

"Le code compile" n'est jamais suffisant. Seul critère : "le mod se lance
et se joue sans erreur". Si test impossible : le dire et lister ce qui
doit être testé manuellement.

### RÈGLE 7 — Assets : sources légitimes uniquement

1. Assets déjà présents dans le projet
2. DumpAsset (<https://github.com/audinowho/DumpAsset>)

Jamais de sources à légitimité incertaine. Confirmer l'existence réelle
sur disque, pas seulement dans un JSON.

### RÈGLE 8 — Français idiomatique

Texte rédigé en français naturel, pas calqué sur l'anglais. Registre
adapté à chaque personnage. Clés EN dans `strings.resx`, FR dans
`strings.fr.resx`. Jamais de texte en dur dans le Lua.

### RÈGLE 9 — Cinématiques : caméra, portraits, densité

- Caméra dynamique — aucun personnage actif hors champ.
- Vérifier disponibilité portrait/emote avant d'écrire.
- Objectif densité : ~10 min de dialogue par grande scène.
- Respecter le ton des chapitres 1-3 (esprit Halcyon).
- Modèle technique : boss de Crooked Cavern (testé en jeu).
- Jamais "Necrozma", "Eternatus", "l'Abîme" nommés au ch5.

### RÈGLE 10 — Commit et push : méthode stricte

Avant commit : `git status` (aucun `deleted:` sur binaires) + `git diff --stat`.
Messages séparés par domaine. Pousser sur la branche de session.

### RÈGLE 11 — Périmètre de fichiers strict

Chaque tâche définit la liste des fichiers autorisés. Si un fichier hors
liste apparaît : `git checkout -- <fichier>`.

### RÈGLE 12 — Règles narratives permanentes

- Légendaires = enjeux narratifs forts uniquement.
- Namespace `halcyon` à vie.
- Progression par paliers de 5-6 chapitres.
- Chaque donjon = identité visuelle propre.
- Chaque étage diffère visuellement du précédent.

### RÈGLE 13 — Fin de session obligatoire

1. `git status` propre
2. Commit + push avec messages clairs
3. Mise à jour de `PROJECT_CONTEXT.md`
4. Liste des tests manuels si test en jeu impossible

---

## COMPRÉHENSION GLOBALE AVANT TOUT DÉVELOPPEMENT

Ne développe jamais une fonctionnalité de manière isolée. Avant de coder :

- Acquiers une vision globale de la trame, de l'architecture et du moteur.
- Lis la documentation, les scripts, les Grounds, les cinématiques validées.
- Comprends les capacités et contraintes du moteur.
- Maîtrise la chronologie narrative complète.

### Connaissance exhaustive du projet

- Lire l'intégralité des dialogues de tous les chapitres déjà écrits.
- Lire l'intégralité des cinématiques déjà produites.
- Retenir pour chaque personnage : ce qu'il sait, ignore, a vécu.
- Retenir la chronologie exacte des événements.
- Avant toute tâche, relire les chapitres concernés en cas de doute.

### Avant de travailler sur une scène

1. Qu'est-ce qui s'est passé avant ?
2. Pourquoi cette scène existe-t-elle ?
3. Quelles informations les personnages possèdent-ils ?
4. Quelles conséquences sur la suite ?
5. Cohérence avec les chapitres précédents ?
6. Le moteur permet-il une meilleure mise en scène ?

---

## RÈGLES DE MISE EN SCÈNE

### Personnages toujours actifs

- Aucun personnage figé en attendant son tour.
- Chaque dialogue = déplacements, regards, animations, pauses, réactions.

### Orientation et regard

- Un personnage qui parle se tourne vers son interlocuteur.
- Quand un nouveau personnage intervient, les autres se tournent vers lui.
- Tout événement déclenche un regard vers la source.

### Déplacements crédibles

- Pas de téléportation d'état. Marche, arrêt, parole, sortie logique.
- Pas de changement de direction aléatoire.

### Positionnement

- Pas de superposition ni de blocage mutuel.
- Formations naturelles, scène lisible.
- Espacement crédible dans les déplacements de groupe.

### Audit final (10 points)

1. Réactions de chaque personnage aux événements
2. Positionnement et déplacements
3. Orientation (interlocuteur / source d'événement)
4. Animations et expressions
5. Cohérence dialogues / émotions
6. Mouvements de caméra (doux, entités actives cadrées)
7. Distances entre personnages
8. Entrées et sorties de scène
9. Collisions et superpositions
10. Continuité entre cinématiques et Grounds

### Test de crédibilité

Si un joueur peut se demander *« Pourquoi ce personnage ne réagit-il pas ? »*
— la scène n'est pas terminée.

### Repère qualité validé

Cinématiques ch1-5 jusqu'à l'entrance du Mont Windsep incluse = niveau
attendu. Référence de comparaison pour tout nouveau contenu.

---

## AUTO-QUESTIONNEMENT : ESTHÉTIQUE DU GROUND

- Placement des PNJ justifié par leur rôle ?
- Nombre de Pokémon présents cohérent avec la narration ?
- Éléments de décor solides bloquent-ils le passage ?
- Objets temporaires purgés après usage narratif ?
- Bruitages cohérents avec le personnage et le contexte ?
- Transitions de ton amenées de façon crédible ?

---

## TRANSITIONS ENTRE SCÈNES

- Type de transition justifié par le changement (ellipse, zone, réveil…)
- Timing calé sur la fin de l'action
- Fondu levé une fois tout en place
- Son cohérent avec l'image
- Effet visuel adapté au changement d'état

### Référence négative

Fondu du Tunnel du Mont Windsep : timing incorrect. Comparer à ce défaut
pour vérifier qu'il n'est pas reproduit.

---

## DIRECTIVE DE REVUE — MONT WINDSEP

Le Mont Windsep (Grounds, Entrance, Donjon, cinématiques, transitions)
doit être repassé au crible de toutes les règles ci-dessus.

---

## OUTILS INTERNES — PIPELINE DE PRODUCTION

| Outil | Rôle |
|---|---|
| Générateur de cinématiques | Scène selon les standards PMD |
| Analyseur de cohérence scénaristique | Personnages, motivations, causalité |
| Vérificateur de mise en scène | Caméra, déplacements, animations, regards |
| Audit de Ground | Mapping, collisions, PNJ, décor |
| Analyseur de dialogues | Conversations artificielles, répétitions |
| Contrôleur de continuité | Flags SV inter-chapitres |

Inventaire complet : [`INVENTAIRE_OUTILS_PIPELINE.md`](INVENTAIRE_OUTILS_PIPELINE.md)

---

## LEÇONS APPRISES (16 bugs réels)

### L1 — Le sandbox efface silencieusement les gros fichiers
`git add -A` avec des `.rsground` supprimés = perte irréversible.
**Règle** : toujours `git status` avant `git add`.

### L2 — `newera_common.lua` et `newera_include.lua` jamais chargés
`main.lua` ne les requérait pas → nil value sur ch5-20.
**Règle** : tracer chaque fonction jusqu'à son require.

### L3 — `GetCurrentChapter()` renvoyait nil en début de partie
**Correction** : `return SV.CurrentChapter or 0`
**Règle** : sécuriser les accès à `SV` avec valeur par défaut.

### L4 — `GAME:EnterGroundMap` inter-zone crashe
**Règle** : `EnterGroundMap` = même zone. Sinon `EndDungeonRun` ou `EnterZone`.

### L5 — Référence à une zone inexistante
**Règle** : vérifier que la cible existe dans `Data/Zone/` avant tout appel.

### L6 — `dungeon_entrance_mapping` incomplet
**Règle** : tout donjon au menu doit avoir son entrée dans la table ET la liste.

### L7 — Segments manquants dans les JSON de zone
**Règle** : chaque `EnterGroundMap` vers un boss nécessite un segment déclaré.

### L8 — `init.lua` de boss ne requireaient pas leurs `_ch_5.lua`
**Règle** : toute fonction appelée doit être tracée jusqu'à son require.

### L9 — `DefeatedBoss()`/`DiedToBoss()` jamais appelées
**Règle** : brancher immédiatement les fonctions de retour de combat.

### L10 — `PoseGroundAction("Faint")` = écrans noirs
**Règle** : flash blanc + `GROUND:Hide` à la place.

### L11 — Namespace changé = sauvegardes perdues
**Règle** : `halcyon` et UUID intouchables à vie.

### L12 — Sauvegardes perdues : `.rsground` absents du disque
**Règle** : vérifier la présence des fichiers avant test en jeu.

### L13 — Séquence dîner/nuit/lendemain absente
**Règle** : toute sortie de donjon d'histoire pose les 4 drapeaux.

### L14 — Variables SV non déclarées dans scriptvars.lua
**Règle** : déclarer toute variable `SV.*` avant usage.

### L15 — Format `.tile` : structure binaire
**Règle** : roundtrip MD5 pour valider toute modification.

### L16 — `EnterGroundMap` vs `EnterZone` vs `EndDungeonRun`
Trois fonctions différentes. Choisir selon le contexte.

---

## FORMAT DU RAPPORT DE FIN DE SESSION

```
## Session du [DATE] — Build [TAG]

### Fait
- [fichier:ligne] description

### Bugs corrigés
- [BUG] cause → correction → test: oui/non/impossible

### Reste à faire
- item 1

### Tests à effectuer manuellement
- scénario (pourquoi impossible en environnement)

### Fichiers modifiés
- liste exhaustive
```

---

## Annexes liées

- [`CARTE_BLANCHE_CUTSCENES.md`](CARTE_BLANCHE_CUTSCENES.md) — Liberté créative encadrée
- [`BRIEF_REVE_GARDEVOIR.md`](BRIEF_REVE_GARDEVOIR.md) — Direction artistique du rêve
- [`grammaire_cinematiques.md`](grammaire_cinematiques.md) — Grammaire cinématographique
- [`bible_continuite.md`](bible_continuite.md) — Bible de continuité narrative
- [`INVENTAIRE_OUTILS_PIPELINE.md`](INVENTAIRE_OUTILS_PIPELINE.md) — État des outils
- [`directive_arenes_boss_tournoi.md`](directive_arenes_boss_tournoi.md) — Arènes & tournoi
- [`conception_donjons_segmentes.md`](conception_donjons_segmentes.md) — Donjons segmentés
