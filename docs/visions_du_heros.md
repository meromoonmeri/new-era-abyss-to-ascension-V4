# La Voix et les Visions du héros — build 2026-07-31-M

## La demande

> « Comme dans PMD Rescue Team, le héros parle à cette voix et **il est le seul
> à pouvoir l'entendre** depuis le début de l'aventure. À chaque fois que cette
> voix lui parle, il doit avoir une nausée (les mêmes animations que quand le
> héros a des visions du passé ou du futur dans Sky). Les scènes flashback des
> anciens jeux — Team Alakazam qui pourchasse l'ancien héros, la météorite
> détruite par Rayquaza, Dialga qui parle au héros avant leur duel à Temporal
> Tower — tout ça doit être des visions du passé du héros de New Era, pour
> qu'il comprenne les événements du lore. »

Deux choses distinctes, traitées séparément :

1. **La Voix** — elle existait déjà (37 occurrences dès le chapitre 1), mais
   elle parlait « à la cantonade », sans effet physique et sans que rien ne
   marque que le héros est le seul à l'entendre.
2. **Les visions** — elles n'existaient pas du tout.

---

## 1. La Voix : le héros seul, et ça lui coûte

### `Data/Script/halcyon/VoiceVisions.lua`

Nouveau module. `VoiceVisions.Speak{...}` orchestre la séquence en 4 temps :

1. **Le monde se fige** — la musique est coupée net.
2. **Le haut-le-cœur** — l'écran *tangue* (`ScreenMover`, amplitude faible mais
   longue : c'est un vertige, pas un séisme), le héros passe en animation
   `Hurt` avec l'emote `shock`, un voile sombre couvre l'écran.
3. **La Voix parle** — speaker anonyme `\uE040`, sans nom, sans portrait.
4. **Le monde revient** — et **le témoin n'a rien entendu**. Il a seulement vu
   son ami s'arrêter net et blêmir.

Le point 4 est le cœur du dispositif : le paramètre `witness` fait réagir le
partenaire à la **pâleur** du héros, jamais à ce qui a été dit.

Trois intensités de nausée (`level` 1 à 3), de la gêne passagère à
l'effondrement.

### Appliqué rétroactivement à tout l'existant

Plutôt que d'éditer 20 fichiers, la nausée a été ajoutée aux **deux points de
passage** par lesquels la Voix transite déjà :

| Point de passage | Portée |
|---|---|
| `BossFX.Voice()` | toutes les scènes de boss du mod |
| `SuaireArc.voice()` | les 5 actes de l'arc 2 |

Un patch dans chacun, et **toutes les prises de parole existantes** de la Voix
provoquent désormais le malaise — y compris celles écrites il y a des semaines.

---

## 2. Les visions du passé

### `Data/Script/halcyon/HeroVisions.lua`

Cinq visions, une par grand moment du lore des jeux officiels, rejouées comme
des **échos que le héros ne comprend pas**.

| # | Vision | Ch. | Écho de | Musique | Fonds |
|---|---|---|---|---|---|
| 1 | **La Chasse** | 3 | un héros accusé, traqué par une équipe d'élite | `Team Skull` | `Wanted_Poster`, `Chapter_3`, `Dream_Back` |
| 2 | **La Météore** | 5 | un dragon du ciel brise la pierre qui tombe | `Sky Tower` | `Chapter_2`, `Dream_Front`, `Genesis_Fade` |
| 3 | **Le Rouage** | 7 | les mécanismes du temps arrêtés, un monde figé | `Time Gear Remix` | `Genesis_Cores`, `Dusknoir` |
| 4 | **Le Sommet** | 9 | le duel au faîte d'une tour qui s'effondre | `Temporal Tower` | `Chapter_4`, `Dusknoir`, `Genesis_Void` |
| 5 | **L'Effacement** | 10 | celui qui a tout sauvé disparaît, oublié de tous | `Goodnight` | `Dream_Front`, `Genesis_Fade`, `Genesis_Void` |

Format repris des visions de *Ciel* : **voix off** (`WaitShowVoiceOver`), pas de
boîte de dialogue, pas de speaker — on ne peut pas attribuer la parole à des
personnages que le héros ne connaît pas.

### La règle d'or : reconnaître sans nommer

**Aucun nom propre des jeux d'origine n'est prononcé.** Ni Dialga, ni Rayquaza,
ni Alakazam, ni Grovyle. Le joueur *reconnaît*, le héros *non*. C'est ce qui
rend les visions troublantes plutôt qu'explicatives.

Exemples :

> « Ils sont quatre à le poursuivre. Des secouristes. Les meilleurs de leur
> temps. Ils ne le haïssent pas. Ils croient sincèrement bien faire.
> **C'est pire.** »

> « Au sommet, quelque chose les attend. Un gardien. Bleu. Énorme. Fou de
> douleur. « Vous êtes venus achever ce que vous avez commencé. » **Il se
> trompe. Il ne le saura jamais.** »

> « Il s'efface. Et avec lui s'efface le souvenir qu'il ait jamais existé.
> Le monde continue, heureux, sauvé, **et personne ne sait par qui.** »

Chaque vision se referme sur une pensée du héros qui la relie à *sa* situation :

> « (Il a tout donné. Et le monde ne se souvient même pas de son nom.
> ...Est-ce que ça m'attend, moi aussi ?) »

### Où elles se déclenchent

| Vision | Emplacement |
|---|---|
| Chasse | réveil du ch3 (`guild_heros_room_ch_3.FirstMorning`) |
| Météore | veillée post-expédition ch5 |
| Rouage | ch7, **juste après** le rêve existant — deux fragments la même nuit |
| Sommet | veillée ch9 |
| Effacement | veillée finale ch10 |

Sauf la première (au réveil, pour surprendre), toutes surviennent **pendant le
sommeil**, après que le partenaire s'est endormi : il ne peut rien voir.

---

## Choix technique : texte littéral

`HeroVisions` est appelé depuis **plusieurs grounds différents**. Or
`STRINGS.MapStrings` ne contient que les clés du ground courant : une clé
définie dans un seul `strings.resx` serait **introuvable** ailleurs.

Le module écrit donc son texte en clair, comme le fait déjà `SuaireArc.lua`
(module global lui aussi). `VoiceVisions` gère les deux modes via un
résolveur `resolve()` et le drapeau `literal`.

---

## Vérifications

- Lua **640/640** (+2 modules), `.resx` 576/576, zones 209/209
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- **10 fonds** et **5 musiques** référencés : tous présents dans `Content/`
- **35 chaînes affichables** analysées : **0 nom interdit**
  (`Dusknoir` n'apparaît que comme *nom de fichier image*, jamais à l'écran)
- Simulation : verrou de chapitre correct (ch1 → rien, ch3 → chasse, …),
  chaque vision jouée **une seule fois**, vision inconnue → `false` sans crash

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier :

- Les **fonds sont détournés** : `Wanted_Poster`, `Dusknoir`, `Chapter_2/3/4`
  et les `Genesis_*` n'ont pas été dessinés pour ces scènes. Le rendu peut
  être incohérent avec le texte. Ce sont les seuls fonds disponibles dans le
  dépôt — des planches dédiées seraient nettement mieux.
- `ScreenMover` et `MoveScreen` sont utilisés d'après `BossFX.ShakeScreen`
  (patron existant), mais l'effet « tangage » n'a pas été observé à l'écran.
- L'animation `Hurt` est supposée disponible pour toutes les espèces jouables
  en contexte *ground* — non vérifié. Tout est sous `pcall`, donc un échec
  dégrade la scène sans bloquer le joueur.

## Piste pour la suite

Les visions couvrent Rouge/Bleu et Ciel. Rien n'empêche d'en ajouter :
la table `HeroVisions.LIST` est déclarative — une entrée = une vision.
