# Comparatif — Mont Venteux : Halcyon d'origine vs notre fork

Document d'étude. **Aucun code du Mont Venteux n'a été modifié ni supprimé.**
Seule la transition du Creuset a été alignée sur l'amont (voir §6).

Source amont : `https://github.com/Palikadude/Halcyon`
Branche de référence : **`working-copy`** (commit `1522c7a`).

> Le Mont Venteux **n'existe pas** sur `master`, ni sur `v0.6`, ni sur
> `Chapter-3-Demo`. Vérifié : `git ls-tree -r --name-only origin/<branche> |
> grep mount_windswept` renvoie 0 sur ces branches. Il n'est présent que sur
> `working-copy`, `common_talk_fix` (3 fichiers) et `trial-of-strength`
> (15 fichiers, version antérieure sans le `_ch_5.lua`).

---

## 1. Volume de code

| Fichier | Halcyon | Notre fork | Écart |
|---|---:|---:|---:|
| `mount_windswept_entrance_ch_5.lua` | **185** | 4 743 | ×25,6 |
| `mount_windswept_entrance/init.lua` | **96** | 360 | ×3,8 |
| `searing_crucible_ch_5.lua` | **1 305** | 1 413 | ×1,1 |

---

## 2. Ce que contient réellement le fichier Halcyon du Mont

185 lignes, trois fonctions :

| Fonction | Lignes | État |
|---|---|---|
| `SetupGround()` | 8-10 | **corps entièrement vide** |
| `SetParty()` | 13-75 | complète — crée Ganlon (Cranidos) et Shuca (Mareep) |
| `ArrivalCutscene()` | 78-185 | **inachevée** |

`ArrivalCutscene` s'interrompt après quatre déplacements. Le fichier se
termine sur une note de travail, ligne 186 :

> `--Ganlon hasn't been getting to act like a jerk much this expedition; give
> him some opportunies for his jerkiness to shine through here`

**Point décisif** : `PlotScripting` (init.lua:72-74) ne contient que
`GAME:FadeIn(20)`. `ArrivalCutscene` **n'est jamais appelée**. En jeu, la
carte s'ouvre donc sur un fondu, sans aucune cinématique.

### Contenu joué, dans l'ordre

1. `CutsceneMode(true)`, IA du partenaire coupée, `StopBGM()`
2. `MoveCamera(276, 248, 1, false)` — **un seul cadrage, fixe**
3. `AddMapStatus("darkness")` — la nuit
4. `FadeOut(false, 1)` — commenté `--for debug purposes`
5. Placement du duo + Hyko + Almotz, création de 10 PNJ
6. Pose des 12 paillasses
7. `WaitFrames(40)`, **réplique 1** (partenaire), `WaitFrames(20)`,
   **réplique 2** (Hyko), `WaitFrames(20)`
8. `FadeIn(40)`
9. Quatre `MoveToPosition` en parallèle, puis `JoinCoroutines`
10. Fin.

**Deux boîtes de dialogue en tout.**

---

## 3. Positionnement des entités — Halcyon

### Départs (`TeleportTo`)

| Personnage | Position | Direction |
|---|---|---|
| héros | (252, 396) | Up |
| partenaire | (284, 396) | **Right** |
| Growlithe (Hyko) | (292, 428) | Up |
| Zigzagoon (Almotz) | (244, 428) | Up |

Les **huit autres** — Audino, Snubbull, Girafarig, Breloom, Tropius,
Noctowl, Mareep, Cranidos — sont créés par
`CharacterEssentials.MakeCharactersFromList` **sans aucune coordonnée** :

```lua
{'Audino'},
{'Snubbull'},
{'Girafarig'},
{'Breloom'},
{'Growlithe', 292, 428, Direction.Up},
{'Zigzagoon', 244, 428, Direction.Up},
{'Tropius'},
{'Noctowl'},
{'Mareep'},
{'Cranidos'}
```

Ils tombent donc à leur position par défaut. C'est cohérent avec une scène
en cours d'écriture : ils sont déclarés pour la suite, pas encore placés.

### Destinations (`MoveToPosition`, vitesse 1)

| Personnage | Destination | Délai de départ |
|---|---|---|
| partenaire | (92, 176) | 0 frame |
| héros | (92, 144) | 10 frames |
| Growlithe | (60, 184) | 2 frames |
| Zigzagoon | (60, 136) | 6 frames |

Les délais décalés (0 / 2 / 6 / 10) évitent le départ en bloc — c'est le
procédé de base de leur mise en scène, et il est systématique.

### Les 12 paillasses

Calculées depuis deux constantes, `bedRelativeX = 178`, `bedRelativeY = 164`.
Commentaire d'origine : *« This is done like this so I can copy and paste
this code into other scenes […] and only change one value »*.

Disposition : **cercle**, en partant du haut au centre, dans le sens horaire.

| Lit | Position | | Lit | Position |
|---:|---|---|---:|---|
| 1 | (256, 164) | | 7 | (211, 281) |
| 2 | (301, 175) | | 8 | (178, 248) |
| 3 | (334, 208) | | 9 | (178, 208) |
| 4 | (334, 248) | | 10 | (211, 175) |
| 5 | (301, 281) | | 11 | (312, 108) |
| 6 | (256, 292) | | 12 | (344, 132) |

Les lits 11 et 12 sont posés à la main, *« a bit more free form »*.

---

## 4. Grammaire de mise en scène — les chiffres

Relevé sur `searing_crucible_ch_5.lua`, la scène **achevée** d'Halcyon
(1 305 lignes), comparé à notre Mont Venteux (4 743 lignes).

| API | Halcyon (Creuset) | Nous (Mont) |
|---|---:|---:|
| `WaitFrames` | 246 | 398 |
| `BranchCoroutine` | 127 | 212 |
| `CharAnimateTurnTo` | **77** | 51 |
| `SetSpeakerEmotion` | 47 | 134 |
| `CharSetAnim` | 25 | 23 |
| `JoinCoroutines` | 25 | 90 |
| `MoveInDirection` | **23** | **0** |
| `CharSetEmote` | 22 | 72 |
| `EmoteAndPause` | 21 | 23 |
| `PoseAndWait` | **20** | **0** |
| `CharTurnToCharAnimated` | **5** | **104** |
| `MoveToPosition` | **0** | 25 |
| `MoveCamera` | **4** | 39 |

### Ce que révèlent ces écarts

**Déplacements.** Halcyon utilise `MoveInDirection` (23 fois, 0 chez nous) ;
nous utilisons `MoveToPosition` (25 fois, 0 chez eux). Leur approche est
relative — « avance de 110 px vers le haut » — donc robuste au décor. La
nôtre est absolue, donc dépendante de coordonnées exactes. Le Mont fait
exception chez eux : les 4 déplacements y sont en `MoveToPosition`.

**Orientation.** Ils tournent la tête avec `CharAnimateTurnTo` (77, vers une
direction fixe) et n'emploient `CharTurnToCharAnimated` que 5 fois. Nous
faisons l'inverse : 104 `CharTurnToCharAnimated`. Nous suivons donc les
personnages du regard bien plus systématiquement — c'était une demande
explicite, mais cela s'écarte franchement de leur style.

**Caméra.** 4 mouvements chez eux sur toute une scène de boss, 39 chez nous.
Sur le Mont, Halcyon n'a **qu'un seul cadrage fixe** (276, 248).

**Poses.** `PoseAndWait` : 20 chez eux, 0 chez nous. C'est un procédé qu'on
n'a jamais repris.

---

## 5. Dialogues

### Les deux répliques du Mont, en version française

Texte d'origine, en dur dans le Lua :

```lua
UI:SetSpeaker(partner)
UI:WaitShowDialogue("Finally![pause=0] We're out of " .. tunnel:GetColoredName() .. "!")
GAME:WaitFrames(20)
UI:SetSpeaker(growlithe)
UI:WaitShowDialogue("Oh,[pause=10] it's already dark![pause=0] I hope we're not too late...")
```

Traduction proposée, balises de pause conservées à l'identique :

| Locuteur | Français |
|---|---|
| partenaire | `Enfin ![pause=0] Nous voilà sortis du <nom du Tunnel> !` |
| Hyko (Growlithe) | `Oh,[pause=10] il fait déjà nuit ![pause=0] J'espère que nous ne sommes pas trop en retard...` |

Soit, sous forme de code :

```lua
UI:SetSpeaker(partner)
UI:WaitShowDialogue("Enfin ![pause=0] Nous voilà sortis de " .. tunnel:GetColoredName() .. " !")
GAME:WaitFrames(20)
UI:SetSpeaker(growlithe)
UI:WaitShowDialogue("Oh,[pause=10] il fait déjà nuit ![pause=0] J'espère que nous ne sommes pas trop en retard...")
```

### Observations sur leur écriture

- Texte **en dur dans le Lua**, pas de clé `.resx` — les `strings.resx` du
  Mont sur `trial-of-strength` ne contiennent **aucune clé** (`grep -c
  "<data name=" → 0`). Notre règle « jamais de texte en dur » est une règle
  du fork, pas d'Halcyon.
- `[pause=0]` sépare deux phrases d'une même réplique ; `[pause=10]` marque
  une hésitation en milieu de phrase. Usage constant.
- Les noms de lieux passent par `:GetColoredName()`, jamais écrits en clair.
- Répliques courtes, une à deux phrases.
- La Voix anonyme utilise `UI:SetSpeaker(STRINGS:Format("\\uE040"), true, ...)`
  — même procédé que le nôtre (relevé `searing_crucible_ch_5.lua:603`).

---

## 6. Transition Creuset → Mont

### Halcyon (`searing_crucible_ch_5.lua`, working-copy, l.1235-1238)

```lua
TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
GAME:WaitFrames(90)
GAME:CutsceneMode(false)
GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')
```

Quatre lignes. Le fondu vient **uniquement** de `coro5`, à l'intérieur du
corps de la scène :

```lua
coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(50)
                                        SOUND:FadeOutBGM(60)
                                        GAME:FadeOut(false, 60)
                                        end)
```

Ni `pcall`, ni fondu de rattrapage, ni `PrintInfo` — **zéro occurrence de
`PrintInfo` dans les 5 fichiers Halcyon examinés**.

### État appliqué

La transition a été **restaurée à l'identique** (commit de cette session).
Seule différence assumée : le corps reste appelé via `DefeatedBossBody()`,
découpage propre au fork puisque la scène y a été étoffée. L'ordre des
instructions finales est celui d'Halcyon.

Le `pcall` et son fondu de rattrapage ont été retirés : c'étaient eux, et
surtout le `PrintInfo` de la première ligne, qui avortaient la fonction.

---

## 7. Carte `.rsground` — comparaison

| | Halcyon | Nous |
|---|---|---|
| Dimensions | 552 × 504 px (69 × 63) | **identiques** |
| `Main_Entrance_Marker` | (256, 472) | **identique** |
| `MapChars` | 0 | 0 |
| `GroundObjects` | 1 | 2 (+ bloqueur de foyer) |
| Spawners | `Teammate1` | `Teammate1`, `Teammate2`, `Teammate3` |
| Musique | *(vide)* | *(vide)* |

La géométrie de la carte est intacte. Les seuls ajouts du fork sont le
bloqueur de collision du feu de camp et deux spawners d'équipiers.

---

## 8. Synthèse

**Ce qu'Halcyon fournit sur le Mont Venteux** : un socle de 185 lignes, avec
une scène d'arrivée inachevée de 2 répliques et 4 déplacements, jamais
appelée par `PlotScripting`. Les positions y sont limitées à 4 personnages
sur 12, plus 12 paillasses en cercle.

**Ce qui est propre au fork** : le repas, le coucher, le rêve, le matin, la
vie de camp, les réactions croisées. Rien de tout cela n'existe en amont —
il n'y a donc rien à « récupérer » sur ces séquences.

**Ce qui vaut d'être repris de leur méthode**, indépendamment du volume :

1. **Positions relatives à une constante** (`bedRelativeX/Y`) plutôt qu'en
   dur — un décor déplaçable en changeant une valeur.
2. **`MoveInDirection`** plutôt que `MoveToPosition` — robuste au décor.
3. **Délais de départ décalés** (0 / 2 / 6 / 10 frames) — systématique.
4. **Sobriété de la caméra** — 4 mouvements sur une scène de boss entière.
5. **`PoseAndWait`** pour les temps forts — procédé absent de notre fork.
6. **Aucun `pcall` autour d'un corps de cinématique** — les erreurs
   remontent au lieu d'être masquées.
