# Direction cinématographique — Sommet des Mille Vents (Windswept) complet

> Refonte complète. Référence : cinématiques validées de l'entrance ch5 (tunnel).
> Philosophie : chaque scène a une âme — les corps racontent l'histoire.

---

## VUE D'ENSEMBLE — 4 fichiers, 5870 lignes

| Fichier | Lignes | Dialogues | Mouvements | Émotes | Caméra | Statut |
|---|---|---|---|---|---|---|
| entrance_ch_5 | 3973 | 232 | 155 | 95 | 38 | ✅ Référence validée |
| midpoint_ch_5 | 651 | 72 | 26 | 13 | 5 | ⚠️ Caméra insuffisante |
| miniboss_ch_5 | 609 | 35 | 13 | 7 | 16 | ⚠️ Émotes insuffisantes |
| guardian_ch_5 | 637 | 34 | 14 | 5 | 15 | 🔴 Émotes critiques |

---

## SCÈNE 1 — ENTRANCE (ArrivalCutscene + CampNightfall)

### Statut : RÉFÉRENCE VALIDÉE
L'entrance est la cinématique de référence du projet. Ne pas modifier
sans raison impérative. Servir de modèle pour les autres scènes.

### Points forts existants
- Arrivée par le sud avec marche en file indienne
- Transition jour→soir (dusk→darkness) au déploiement des couchages
- Veillée complète en 16 sections (repas, conversations, silence, rêve)
- Rêve avec Gardevoir (hero_dream, parallaxe Dream_Back/Dream_Front)
- Réveil en sursaut + réaction de Phileas (veille de nuit)
- Matin avec rassemblement et cordées

---

## SCÈNE 2 — MIDPOINT (relais mi-parcours)

### Beat M1 — FirstArrival
**Intention** : le duo découvre le relais. Moment de répit mérité.

| Problème | Avant | Correction |
|---|---|---|
| Caméra | 1 seul MoveCamera | +1 panoramique vers le rocher Kangourex |
| Réactions | partner parle seul | +hero se tourne vers partner |
| Émotes | 0 | +notice (partner découvre le relais) |

### Beat M2 — FallenFragmentScene (Météno tombé du ciel)
**Intention** : rencontre poétique avec un être céleste. Moment de grâce.

| Problème | Avant | Correction |
|---|---|---|
| Caméra | Fixe | +recadrage sur le Météno quand il apparaît |
| Réactions t2/t3 | Aucune | +tours vers le Météno, émotes question |

### Beat M3 — SummitVigilScene (dernière veillée)
**Intention** : moment solennel avant le sommet. Chacun dit pourquoi il est venu.

| Problème | Avant | Correction |
|---|---|---|
| Caméra | Fixe | +recadrage sur chaque locuteur |
| Réactions | Aucune entre les 4 personnages | +tours vers le locuteur courant |
| Émotes | 0 | +happy (Shuca), +sweatdrop (Ganlon taquine) |

---

## SCÈNE 3 — MINIBOSS (Gligar + Skarmory, sentinelles)

### Beat MB1 — FirstPreBossScene
**Intention** : l'équipe atteint les crêtes. Le vent hurle. Quelque chose les attend.

| Problème | Avant | Correction |
|---|---|---|
| Arrêt avant dialogue | Personnages figés 20f | +LookAround (scan de l'environnement) |
| Voix de l'Abîme | 4 occurrences sans réaction équipe | +tours vers le ciel, émotes shock |
| Apparition boss | Pas de recul de l'équipe | +Recoil synchronisé |

### Beat MB2 — DefeatedBossBody
**Intention** : les sentinelles sont vaincues. La voie vers le sommet est ouverte.

| Problème | Avant | Correction |
|---|---|---|
| Émotes | 2 seulement | +notice (partner observe le ciel), +glowing (détermination) |
| Réactions t2/t3 | Aucune | +tours vers partner, émotes |

---

## SCÈNE 4 — GUARDIAN (Boréas (Tornadus), gardien final)

### Beat G1 — FirstPreBossScene
**Intention** : le sommet. L'orage. Le gardien ancestral descend des nuages.

| Problème | Avant | Correction |
|---|---|---|
| FadeIn | 40f, pas de stabilisation | +20f WaitFrames avant FadeIn, durée 60f |
| partner parle seul | 2 lignes sans réaction équipe | +CharTurnToCharAnimated(hero→partner) |
| Ciel menaçant | partner regarde le ciel seul | +toute l'équipe regarde le ciel |
| Voix de l'Abîme | Pas de réaction physique | +LookAround + émotes shock |
| Apparition Boréas (Tornadus) | Pas de recul | +Recoil synchronisé 4 personnages |
| Émotes totales | 5 | Cible : 15+ |

### Beat G2 — DefeatedBossBody
**Intention** : le gardien s'apaise. Il transmet son fardeau. Moment solennel.

| Problème | Avant | Correction |
|---|---|---|
| partner parle seul au début | 3 lignes sans réaction | +CharTurnToCharAnimated vers partner |
| Boréas (Tornadus) parle | 3 lignes, équipe passive | +tous regardent Boréas (Tornadus) |
| t2/t3 réactions | Aucune | +tours, émotes aux moments clés |
| Émotes totales | 5 (exclaim, sweatdrop, glowing) | Cible : 12+ |
| Départ Boréas (Tornadus) | Flash blanc simple | OK (déjà bon) |

---

## RÈGLES DE MISE EN SCÈNE (spécifiques au Mont)

### R1 — Le vent comme personnage
Le Sommet des Mille Vents a un personnage invisible : le vent. Il doit être
présent dans chaque scène :
- `CharAnimateTurnTo` légèrement décalé (le vent pousse les personnages)
- `MoveScreen` subtil pendant les moments de tension
- `Ominous_Wind` comme effet atmosphérique récurrent

### R2 — L'altitude comme émotion
Plus on monte, plus l'air est rare. Les personnages doivent montrer
la fatigue physique :
- Vitesses de déplacement plus lentes (2 au lieu de 1)
- `sweating` emote plus fréquent
- Pauses plus longues entre les répliques

### R3 — L'orage comme tension
Pendant le Guardian, l'orage est un acteur :
- `ScreenMover` pour les rafales
- `FlashEmitter` pour les éclairs
- Les personnages se rapprochent instinctivement (peur du vide)

### R4 — Distances au sommet
L'espace est rare au sommet. Les personnages sont plus proches qu'en plaine :
- Alliés : 24-32 px (plus serrés qu'au camp)
- Face au boss : 64-80 px (respect + danger)
- En cercle de discussion : rayon de 40 px max
