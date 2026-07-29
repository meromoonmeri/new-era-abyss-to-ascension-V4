# Rapport de session — Mont Venteux (entrée)

> Session du 2026-07-29 · branche `arena/019faad0-new-era-abyss-to-ascension-v4`
> Point de départ `b7afed9` · état final `9dd7bbe` · **5 commits**
> Tous les chiffres de ce rapport sont **relevés par les outils**, pas estimés.

---

## 1. En une phrase

La carte d'entrée du Mont Venteux était **injouable** (le joueur apparaissait
hors carte) et personne ne l'avait vu, parce que les seules mesures existantes
portaient sur le volume de contenu, jamais sur sa validité géométrique ni sur
sa mise en scène. Cinq lots ont corrigé la carte, refondu le rêve sur la
grammaire de *pmd-red*, rendu le camp vivant, et **livré trois outils** qui
rendent ces trois classes de défauts détectables à l'avenir.

---

## 2. Ce qui a été livré

| commit | objet |
|---|---|
| `b1b652b` | `docs/PASSATION_AGENT_ARENA.md` — passation reconstruite, état du dépôt re-mesuré |
| `c8167b3` | Carte hors-cadre, camp injouable, décor incohérent + `verify_ground_reachability.py` |
| `d432ff2` | Passation §14bis — pourquoi les métriques n'avaient rien vu |
| `1a986a7` | Le rêve refondu sur la grammaire de *pmd-red* + un camp qui écoute |
| `9dd7bbe` | Rocher rendu, Phileas sans lit, cordée qui attend, transition propre, camp déjà vivant |

**Diff global** : 12 fichiers, dont **3 créés**.

```
Data/Ground/mount_windswept_entrance.rsground        190307 ±
mount_windswept_entrance_ch_5.lua                      1503 ±
docs/PASSATION_AGENT_ARENA.md                           787 +   (créé)
tools/verify_ground_reachability.py                     220 +   (créé)
tools/audit_scene_liveliness.py                         163 +   (créé)
VoiceVisions.lua                                         96 ±
strings.fr.resx / strings.resx                       90 + 90 ±
searing_crucible_ch_5.lua                                29 ±
main.lua / scriptvars.lua / vast_steppe_midpoint          3 ±   (tag de build)
```

---

## 3. Les bugs trouvés et corrigés

### 3.1 Bloquants

**Le joueur apparaissait hors carte.** `Main_Entrance_Marker` était en
(256,592) = tuile (32,**74**) sur une grille de **63** rangées. Toute la
cinématique d'arrivée se jouait dans le vide : duo téléporté en y=540/556,
Hyko et Almotz en y=572/588, caméra en (256,524) — pour un maximum réel de 503.

**Cause racine unique.** Un lot antérieur a voulu ajouter un océan « au sud,
rows 78-80 » et a rallongé la table `obstacles`. Or elle est indexée
**`[x][y]`** : allonger la table du dessus agrandit la **largeur**. La carte
est passée de 552×504 à 648×504 — 12 colonnes à l'**est**, zéro rangée au sud —
et **2520 tuiles `DuskBeach`** (une plage au crépuscule) se sont retrouvées
plaquées sur le flanc d'une montagne.

**La transition Tunnel → Mont laissait revoir l'ancien décor.**
`EnterGroundMap` était appelé **sans son troisième argument**. Le patron du
dépôt est constant (`metano_cave:101`, `first_core_location_ch_3:34`) :
`FadeOut`, puis `EnterGroundMap(..., true)`, et c'est la carte d'arrivée qui
fait le `FadeIn`. Sans ce `true`, le moteur rétablit la luminosité au
chargement et annule le fondu.

### 3.2 Cohérence de scène

| bug | détail |
|---|---|
| Paillasse inatteignable | lit 12 en (344,132) : sol libre mais **poche isolée**. La carte a **3 composantes connexes**, il était dans la mauvaise. |
| 4 paires de lits en recouvrement | `Hay_Bed` fait 40×40 (en-tête `.dir` vérifié) ; lits 2/3, 4/5, 7/8, 9/10 se chevauchaient de 7×7 px. |
| Le dîner se tenait **sur** les paillasses | convives envoyés aux coordonnées de leur couche, à ~100 px du feu, sur des lits **pas encore déployés**. |
| Personne ne rejoignait sa couche | duo, Hyko et Almotz jouaient `Sleep` **debout à table** : 4 paillasses vides toute la nuit. |
| PNJ dans le décor | Shuca sur la couche 9, Reinier sur la 7, Coco dans le foyer, Penticus et Phileas sur la couche 1. |
| Ganlon et Shuca partaient **sans** le joueur | ils montaient puis `Hide` — alors que `SetParty` en fait les Teammate2/3 vingt lignes plus bas. |
| Phileas avait un lit qu'il n'occupait jamais | il monte la garde debout ; son couchage restait vide au milieu du cercle. |
| Le camp « apparaissait » | 6 PNJ créés **sans position** (donc en 0,0), cachés, puis révélés d'un bloc par une boucle `Unhide`. |
| 4 paires de Pokémon se traversaient | les 3 vagues de départ partaient sur la **même colonne** x=284 avec 8 px d'écart, pour des sprites de 16×16. |

### 3.3 Mise en scène

**40 % des répliques étaient jouées devant des statues** — mesuré, pas estimé :

| fonction | répliques | statiques |
|---|---|---|
| `ArrivalCutscene` | 18 | **17 (94 %)** |
| `CampNightfall` | 66 | 15 (22 %) |
| `WindSecretScene` | 8 | 4 (50 %) |
| `LegendOfTheSkyArbiter` | 2 | **2 (100 %)** |
| **total** | **99** | **40 (40 %)** |

Après : **89 répliques, 9 statiques (10 %)**, les 9 restants vérifiés
légitimes (écran noir, voix off, définitions de helpers).

---

## 4. Le travail de fond

### 4.1 Le rêve, refondu sur la source

`pret/pmd-red` cloné et lu : `src/data/ground/ground_data_a01p01_station.h`.
Huit temps, toujours dans le même ordre — **et cet ordre est l'effet** :
trois boîtes de points de plus en plus longues (le dormeur remonte) →
désorientation **avant** toute présence → `TEXTBOX_CLEAR` (la boîte se
**ferme**) → la présence est aperçue → *« I can't remember »* dès le premier
rêve → l'entité parle → **« Why do you appear in my dreams? »** → l'oubli.

L'ancienne version **ouvrait sur la Voix** : le joueur n'était jamais endormi,
il assistait à une annonce. Transposition New Era : l'entité reste **anonyme**
(`\uE040`), là où Gardevoir est nommée et portraiturée.

### 4.2 Le vertige, porté de pmd-sky

`pret/pmd-sky` cloné et lu : `include/main_0200BC54.h`, `struct screen_fade`.
Sky pilote ses fondus par une **luminosité signée**, pas un booléen. Deux
leçons portées : un fondu a une **amplitude**, et le vertige **s'éteint** au
lieu de s'arrêter. `Nausea` posait un `ScreenMover` fixe puis **coupait net** —
ça se lit comme un bug d'affichage, pas comme un malaise.

**Ce que j'ai refusé de porter** : Sky fade aussi vers le **blanc** (+256).
Vérification faite, PMDO n'expose pas ça — `FadeOut(true, n)` masque le décor
en gardant l'interface. J'aurais inventé une API.

Trouvé aussi dans la source (`H02P99C/m20a0205.ssb`), et documenté :
*« The Dimensional Scream requires the presence of a trusted Pokémon
partner »*. Une vision n'est jamais gratuite.

---

## 5. Les outils livrés

Aucun outil du dépôt ne pouvait attraper ces bugs. Deux ont été créés, tous
deux **avec leurs faux positifs triés avant livraison**.

### `tools/verify_ground_reachability.py` — référence **27**

Teste ce que rien ne testait : l'**accessibilité par parcours en largeur**
depuis l'entrée du joueur. *Marchable ≠ atteignable.*
Les 27 signalements sont une dette d'import préexistante (arènes pmd-red dont
l'entrée elle-même est sur mur), **aucun sur les cartes du ch5**.

### `tools/audit_scene_liveliness.py` — référence **987**

Mesure le statisme des cinématiques. Verdict sur **tout le mod** :
**1947 répliques, 987 statiques (50 %)**.

### Un échec assumé

J'ai **durci `verify_scene_positions.py`, puis je l'ai reverté.** Mesure faite,
le contenu d'origine jouable dépasse légitimement les bornes jusqu'à **+69 px**
(`relic_forest`, `apricorn_glade`, `metano_altere_transition`) : l'ampleur
seule ne discrimine pas le bug du contenu sain. Mon durcissement produisait
**42 faux positifs**. Un outil qui crie au loup ne sert à rien (§2.7).

---

## 6. Erreurs que j'ai commises

**J'ai écrasé 26 répliques du matin.** Mon premier passage sur le rêve a écrit
sur les clés `MWE5_080-107`, qui portaient déjà les dialogues de Ganlon, Kino
et des cordées. Détecté en relisant le diff, annulé par `git checkout`, refait
sur le bloc 130+ **vérifié libre avant écriture**. Le script d'ajout refuse
désormais d'écrire sur une clé existante.

**J'avais déplacé le rocher de Kangaskhan** en (288,330) parce que son emprise
32×32 n'était libre qu'à 4/16. C'était une erreur de priorité : la cohérence du
camp prime, et rien n'oblige un décor à être marchable. Remis en (160,144).

**J'ai déclaré la scène « terminée » sur la foi de métriques** (192 boîtes,
164 émotions, 90 coroutines — d'excellents chiffres) alors que la carte était
injouable. La leçon est inscrite dans la passation : *ne jamais déclarer une
scène terminée sans ouvrir la géométrie.*

---

## 7. État final, mesuré

```
compilation Lua                 0 KO
audit_bugs.py                  12  (référence, inchangé)
audit_integrite.py            925  (référence, inchangé)
verify_legend.py              vert
verify_scene_positions.py     vert
verify_ground_reachability     27  (dette d'import, aucun sur ch5)
audit_scene_liveliness        987  (dette mod entier ; Mont sorti du top 25)
clés .resx      0 manquante, 0 orpheline (145 clés)
ch5             1480 → 1582 boîtes de dialogue
.rsground       identique à l'octet à origin/main
tag de build    2026-08-01-U → 2026-08-01-Z
```

**RIEN N'A ÉTÉ TESTÉ EN JEU.** Tout est validé statiquement.

---

## 8. Ce qu'il reste à faire

**Priorité 1 — le statisme du reste du mod.** 987 répliques concernées.
Les pires : `mount_windswept_midpoint_ch_5` (**96 %**),
`vast_steppe_midpoint_ch_5` (84 %), `vast_steppe_guardian_ch_5` (82 %),
`searing_tunnel_entrance_ch_5` (41 % sur 98 répliques). Le patron de
correction est établi (helpers `Listen` / `Says`) et se transpose tel quel.

**Priorité 2 — le bureau du maître de guilde aux ch7-10.** Aucun fichier de
chapitre au-delà du ch6, qui ne contient lui-même que **2 boîtes**. Phileas n'a
de dialogue qu'au ch5 alors qu'il dit y travailler.

**Priorité 3 — la densité.** ch6-10 à 457 / 397 / 324 / 307 / 256 boîtes contre
7000 visés.

**À surveiller au premier test en jeu :**
- la transition Crucible → Mont (seul comportement moteur modifié) ;
- les 11 dormeurs, chacun sur sa paillasse au fondu de nuit ;
- les trois boîtes de points du rêve, qui doivent s'enchaîner sans locuteur ;
- `Genesis_Void` visible pendant tout le dialogue du rêve.

---

## 9. Dettes préexistantes signalées, non traitées

- `GeneralFunctions.EmoteAndPause` est **défini deux fois** (lignes 398 et 455
  de `GeneralFunctions.lua`) — la seconde écrase la première. Sans effet
  visible aujourd'hui, mais c'est un piège.
- `count_dialogue.py` **plante** si on lui passe `.` (`int('.')`, ligne 80).
  L'usage correct est sans argument.
- 27 ancres inatteignables (imports pmd-red).
- 925 anomalies d'intégrité (clés orphelines).
