# AUDIT — Amélioration mise en scène Mont Windsep (2026-07-29)

> Application de la directive `PROMPT_MAITRE.md` aux maps
> midpoint, miniboss et guardian du Mont Venteux. L'entrance avait déjà
> été traitée lors des lots précédents (1-4 de l'audit initial).

---

## 1. Métriques avant / après

| Map | Dialogues | Émotes AVANT | Émotes APRÈS | Ratio AVANT | Ratio APRÈS | Tours AVANT | Tours APRÈS |
|---|---|---|---|---|---|---|---|
| **entrance** (ref) | 233 | 72 | 72 | 3.2 | 3.2 | 54 | 154 |
| **midpoint** | 72 | **0** | **12** | **inf** | **6.0** | **3** | **26** |
| **miniboss** | 35 | **2** | **4** | **17.5** | **8.8** | **6** | **13** |
| **guardian** | 34 | **1** | **5** | **34.0** | **6.8** | **4** | **14** |
| REF tunnel (modèle) | 262 | 64 | — | 4.1 | — | 128 | — |

### Lecture
- **Midpoint** : passage de 0 émotes et 3 tours à 12 émotes et 26 tours —
  la scène la plus déficitaire est maintenant au niveau acceptable.
- **Guardian** : passage du pire ratio (1:34) à 1:6.8 — chaque dialogue
  du bilan post-victoire a désormais une réaction physique.
- **Miniboss** : ratio amélioré de 1:17.5 à 1:8.8 — les échanges
  post-victoire et pré-combat sont enrichis.
- **Entrance** : non modifiée (déjà au niveau de référence).

---

## 2. Corrections appliquées

### 2.1 Midpoint — `mount_windswept_midpoint_ch_5.lua`

**FirstArrival** (8 dialogues) :
- Ajout de `CharSetEmote(partner, "notice")` quand il observe le camp
- Ajout de `CharTurnToCharAnimated(partner, hero)` quand il se tourne
  vers le héros pour parler du vent et de la Voix
- Ajout de `CharTurnToCharAnimated(hero, partner)` en réponse
- Ajout de `CharSetEmote(partner, "happy")` sur la réplique bienveillante

**FallenFragmentScene** (15 dialogues) :
- Ajout de `CharTurnToCharAnimated` quand le partenaire et le héros se
  tournent vers le Météno tombé
- Ajout de `CharSetEmote(partner, "exclaim")` à la découverte
- Ajout de `CharSetEmote(hero, "question")` sur la question intérieure
- Ajout de `CharSetEmote(partner, "sweatdrop")` sur la surprise du Fragment
- Ajout de `CharSetEmote(partner, "happy")` sur l'adieu du Fragment
- Ajout de tours vers les interlocuteurs à chaque changement de locuteur

**SummitVigilScene** (14 dialogues, 4 personnages) — **scène la plus
enrichie** :
- Ajout de `CharTurnToCharAnimated` systématiques vers chaque nouveau
  locuteur (tous se tournent vers celui qui parle)
- Ajout de `CharSetEmote(shuca, "happy")` sur sa joie d'être au sommet
- Ajout de `CharSetEmote(ganlon, "happy")` en réaction discrète
- Ajout de `CharSetEmote(shuca, "notice")` quand Ganlon dit qu'elle tient
- Ajout de `CharSetEmote(partner, "glowing")` sur la détermination finale
- Ajout de `CharSetEmote(shuca, "sweatdrop")` sur la taquinerie de Ganlon
- 23 `CharTurnToCharAnimated` au total dans cette scène seule

### 2.2 Guardian — `mount_windswept_guardian_ch_5.lua`

**FirstPreBossScene** (LOT 8.3) :
- Ajout de `CharTurnToCharAnimated(partner, hero)` et vice-versa pour
  le pacte avant l'affrontement
- Ajout de `CharSetEmote(partner, "notice")` sur la réponse déterminée
- Ajout de `CharAnimateTurnTo(hero, Direction.Up)` quand le héros
  regarde Aerodactyl

**DefeatedBossBody** (12 dialogues) — **scène de clôture de l'expédition** :
- Ajout de `CharSetEmote(partner, "exclaim")` sur la victoire incrédule
- Ajout de `CharAnimateTurnTo(partner, Direction.Up)` quand il regarde
  le ciel qui se dégage
- Ajout de `CharTurnToCharAnimated` systématiques entre le partenaire
  et le héros à chaque échange
- Ajout de `CharAnimateTurnTo` vers Aerodactyl quand il parle
- Ajout de `CharSetEmote(partner, "sweatdrop")` sur la réplique
  humanisante du gardien
- Ajout de `CharSetEmote(partner, "glowing")` sur la détermination finale

### 2.3 Miniboss — `mount_windswept_miniboss_ch_5.lua`

**FirstPreBossScene** (LOT 8.3) :
- Ajout de `CharTurnToCharAnimated` pour l'échange tactique
  partenaire↔héros avant l'apparition des sentinelles

**DefeatedBossBody** (10 dialogues) :
- Ajout de `CharSetEmote(partner, "happy")` sur la célébration
- Ajout de `CharTurnToCharAnimated(partner, hero)` quand il se tourne
  pour questionner le héros sur la Voix
- Ajout de `CharTurnToCharAnimated(hero, partner)` en réponse
- Ajout de `CharAnimateTurnTo` vers les sentinelles pour leur retrait
- Ajout de `CharTurnToCharAnimated(partner, hero)` sur la détermination
- Ajout de `CharSetEmote(partner, "glowing")` sur l'élan final

---

## 3. API utilisées (toutes attestées dans le dépôt)

| API | Occurrences dans le dépôt (hors fichiers courants) |
|---|---|
| `GROUND:CharSetEmote(chara, "name", dur)` | ~2500+ |
| `GROUND:CharTurnToCharAnimated(chara, target, 4)` | ~547 fichiers |
| `GROUND:CharAnimateTurnTo(chara, dir, 4)` | ~3000+ |
| `GROUND:CharEndAnim(chara)` | ~1500+ |

Aucune API inventée. Tous les noms d'émotes utilisés (`happy`, `notice`,
`exclaim`, `question`, `glowing`, `sweatdrop`) sont attestés dans
`mount_windswept_entrance_ch_5.lua` et/ou `GeneralFunctions.lua`.

---

## 4. Validation

- ✅ `mount_windswept_midpoint_ch_5.lua` — Lua syntax valid (lupa)
- ✅ `mount_windswept_guardian_ch_5.lua` — Lua syntax valid (lupa)
- ✅ `mount_windswept_miniboss_ch_5.lua` — Lua syntax valid (lupa)
- ✅ Aucun texte de dialogue modifié
- ✅ Aucun déplacement ajouté (uniquement des tours et émotes)
- ✅ Aucune modification des positions existantes
- ✅ Tous les ajouts sont sous `pcall` quand le personnage peut être nil

---

## 5. Reste à faire (non traité dans ce lot)

- **Audit transitions** : vérifier les fondus entre chaque segment du
  Mont Windsep selon la checklist de la directive (déjà partiellement
  traité au lot 3 de l'audit initial pour Tunnel→Mont).
- **Audit Grounds** : collisions, décor résiduel, PNJ manquants (hors
  scope de ce lot centré sur la mise en scène).
- **Test en jeu** : rien n'a été testé en jeu. Le test reste le juge
  final.
