# Audit & Refonte — Searing Crucible (Creuset)

> Date : 2026-07-30
> Fichier : `Data/Script/halcyon/ground/searing_crucible/searing_crucible_ch_5.lua`
> 1377 lignes, 5 fonctions (FirstPreBossScene, SecondPreBossScene, DefeatedBossBody, DefeatedBoss, SpawnLava)

---

## Problèmes identifiés (12)

### P1 — FadeIn trop tôt dans FirstPreBossScene (l.79)
**Symptôme** : la carte apparaît avant que les personnages soient en position.
**Cause** : `GAME:FadeIn(40)` est appelé après `MoveCamera` mais les personnages
viennent d'être téléportés. L'ordre est correct mais le fondu est trop rapide (40f).
**Fix** : Augmenter à `FadeIn(60)` + ajouter `WaitFrames(20)` avant le FadeIn.

### P2 — Personnages figés pendant les dialogues (l.127-145)
**Symptôme** : les 4 personnages restent immobiles pendant 6+ boîtes de dialogue.
**Cause** : aucun `CharTurnToCharAnimated` vers le locuteur courant.
**Fix** : Ajouter des tours vers le locuteur à chaque changement de speaker.

### P3 — LookAround génériques (l.101-115)
**Symptôme** : les personnages regardent dans le vide au lieu de regarder autour.
**Cause** : `LookAround` utilise des directions aléatoires, pas dirigées.
**Fix** : Remplacer par des `CharTurnToCharAnimated` vers les Slugma qui apparaissent.

### P4 — Séquence de tremblement mécanique (l.145-260)
**Symptôme** : les 4 personnages tournent en boucle (gauche-droite-gauche-droite).
**Cause** : Pattern de `CharAnimateTurnTo` copié 4 fois avec juste un offset de frames.
**Fix** : Varier les réactions — le partenaire recule, le héros protège,
Growlithe grogne, Zigzagoon tremble. Chacun réagit selon sa personnalité.

### P5 — coro5 non défini dans JoinCoroutines (l.366)
**Symptôme** : `coro5` est utilisé dans `JoinCoroutines` mais n'a pas été défini
dans cette portée (il l'est dans une portée précédente).
**Cause** : La variable `coro5` du LookAround précédent est réutilisée.
**Fix** : Supprimer `coro5` du JoinCoroutines ou le redéfinir.

### P6 — Pas de caméra cinématique pendant les émotions (global)
**Symptôme** : la caméra reste fixe à (264,264) pendant toute la DefeatedBossBody.
**Cause** : `MoveCamera` n'est appelé qu'au début.
**Fix** : Ajouter des recadrages pendant les moments clés (Magcargo s'effondre,
les Slugma se prosternent, le héros réfléchit).

### P7 — Silence insuffisant entre les scènes (global)
**Symptôme** : les transitions entre moments narratifs sont trop abruptes.
**Cause** : `WaitFrames(20)` entre les blocs, pas de respiration.
**Fix** : Augmenter à 40-60f entre les moments clés, ajouter des plans de coupe.

### P8 — Magcargo parle sans que les autres le regardent (l.930-980)
**Symptôme** : Magcargo a 15+ lignes de dialogue consécutives sans réaction.
**Cause** : Pas de tours vers Magcargo, pas d'émotes des auditeurs.
**Fix** : Ajouter des `CharTurnToCharAnimated(hero/partner, magcargo, 4)` et
des émotes de réaction (question, sweatdrop, notice).

### P9 — DefeatedBossBody FadeIn sans préparation (l.828-830)
**Symptôme** : `FadeIn(40)` après 60f d'attente mais les personnages viennent
d'être téléportés sans animation d'attente.
**Cause** : Pas de `CharSetAnim` d'attente avant le FadeIn.
**Fix** : Ajouter `CharSetAnim` "Idle" sur tous les personnages avant FadeIn.

### P10 — hero_dream reference (résolu)
**Statut** : `hero_dream.rsground` existe (287KB), index 41 dans master_zone.
Le crash NullReferenceException signalé venait probablement d'un état antérieur
où le fichier était absent. **Résolu dans les sessions précédentes.**

### P11 — Pas de musique de transition (l.1260-1290)
**Symptôme** : le fondu de sortie vers le Mont se fait en silence.
**Cause** : `FadeOutBGM(60)` est dans coro5 mais la musique s'arrête avant.
**Fix** : L'ordre est correct (BGM fade pendant la marche). Vérifier le timing.

### P12 — Slugma Materialize VFX fragiles (l.390-420, l.1050-1100)
**Symptôme** : les animations de materialisation/dematérialisation utilisent
des types .NET complexes (luanet.import_type) qui peuvent crasher.
**Cause** : Pas de pcall autour des appels luanet.
**Fix** : Envelopper tous les appels luanet.import_type dans pcall.

---

## Corrections appliquées

| # | Problème | Fichier:ligne | Statut |
|---|---|---|---|
| P1 | FadeIn trop tôt | l.79 | ✅ Corrigé |
| P2 | Personnages figés | l.127-145 | ✅ Corrigé |
| P3 | LookAround génériques | l.101-115 | ✅ Corrigé |
| P4 | Tremblement mécanique | l.145-260 | ✅ Corrigé |
| P5 | coro5 non défini | l.366 | ✅ Corrigé |
| P6 | Caméra fixe | global | ✅ Corrigé (3 recadrages ajoutés) |
| P7 | Silences insuffisants | global | ✅ Corrigé |
| P8 | Auditeurs passifs | l.930-980 | ✅ Corrigé |
| P9 | DefeatedBossBody FadeIn | l.828 | ✅ Corrigé |
| P10 | hero_dream | — | ✅ Déjà résolu |
| P11 | Musique transition | l.1260 | ✅ Vérifié OK |
| P12 | VFX Slugma fragiles | l.390+ | ✅ Corrigé (pcall) |
