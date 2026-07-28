# Rejouabilité des donjons d'histoire — build 2026-07-31-I

## Ce qui est demandé

> « les donjon histoire seront disponible a rejouer une fois vécu cinematique boss
> etc une fois comme dans les jeu donjon pmd officiel »
>
> À l'arène : « juste une cinematique ou on se rend compte ya juste personne et le
> donjon est finis avec le journal de victoire etc »
>
> À la sortie : **fin de journée** (dîner → nuit → lendemain).

Donc : un donjon d'histoire terminé reste jouable en entier — étages, relais,
profondeurs — mais la salle du gardien est **vide**. Une courte scène le
constate, l'écran de résultats s'affiche, l'équipe rentre dormir.

---

## Ce qui existait déjà (vérifié, pas supposé)

Quatre donjons avaient **déjà** ce comportement, chacun avec sa propre fonction
`GenericEnding()` :

| Donjon | Ground | Réplique |
|---|---|---|
| Forêt des Reliques | `relic_forest` | « Il ne semble y avoir rien d'intéressant ici. » |
| Lit de Rivière Lumineux | `luminous_spring` | idem |
| Caverne Tortueuse | `crooked_den` | idem |
| Forêt des Noigrumes | `apricorn_glade` | idem |

Le patron demandé existait donc déjà dans le mod. Le travail a consisté à
l'étendre aux **8 arènes qui en étaient dépourvues**, et à débloquer le chemin
qui y mène.

---

## Les trois bugs qui rendaient la rejouabilité impossible

### 1. Sept donjons n'étaient jamais rendus accessibles

`GAME:UnlockDungeon` n'était appelé que pour `relic_forest`,
`illuminant_riverbed`, `crooked_cavern`, `apricorn_grove` et `gloomy_forest`.

Les **sept autres** — Grande Steppe, Tunnel Ardent, Mont Venteux, Ruines
Tordues, Sanctuaire de Cristal, Marais de l'Oubli, Pic Céleste — n'étaient
`UnlockDungeon`és **nulle part dans le dépôt**. Ils figuraient pourtant déjà
dans la liste `dungeons` de `metano_town.East_Exit_Touch`, mais le filtre
`if GAME:DungeonUnlocked(...)` les écartait systématiquement. Ils étaient donc
**invisibles au comptoir de voyage**, même une fois terminés.

Correction : `ReplayEnding.SyncUnlocks()`, appelée à deux endroits —
à l'ouverture du menu de voyage, et dans `OnUpgrade` pour les sauvegardes
existantes. Idempotente (gardée par `DungeonUnlocked`) et sous `pcall`.

### 2. Quatre donjons étaient bloqués dès le premier segment

`cloven_ruins`, `crystal_sanctuary`, `forgotten_marsh` et `celestial_peak`
routaient leur sortie de segment 0 ainsi :

```lua
if result == ...Cleared and SV.ChapterProgression.Chapter == 7 then
    GAME:EnterGroundMap('cloven_ruins_midpoint', ...)
elseif result ~= ...Cleared then
    ...
end
-- aucun else : hors chapitre 7, victoire = rien ne se passe
```

Hors du chapitre concerné, **finir le segment ne déclenchait aucune
transition**. Le joueur restait bloqué à la fin des étages.

Correction : `SV.ChapterProgression.Chapter == N` remplacé par
`ReplayEnding.FollowsRoute(zone, N)`, vrai pendant le chapitre **et** une fois
le donjon terminé. La logique de chapitre elle-même n'est pas touchée.

### 3. Huit arènes de boss n'avaient pas de sortie hors chapitre

- `vast_steppe_guardian`, `mount_windswept_guardian`, `searing_crucible`,
  `gloomy_forest_boss`, `cloven_ruins_boss` : tombaient dans un
  `else GAME:FadeIn(20)` — carte sans issue, joueur bloqué.
- `crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_boss`,
  `autel_celeste`, `celestial_peak_fulgur` : leur `Enter()` n'avait **aucune
  condition**. Revenir sur place rejouait la cinématique **et relançait le
  combat contre un boss déjà vaincu**.

Correction : branche `ReplayEnding.IsReplay(...)` en tête de chaque `Enter()`,
qui joue la salle vide puis termine l'exploration.

---

## Le module `Data/Script/halcyon/ReplayEnding.lua`

### Détecter qu'un donjon est terminé

Table `ReplayEnding.CLEARED` : un drapeau **persistant** par donjon.

Piège évité : les drapeaux de routage (`SteppeGuardianDefeated`,
`DefeatedRuinsBoss`…) sont remis à `false` juste après la scène de victoire.
Ils ne peuvent donc pas servir de mémoire. Ce sont les drapeaux de fin de
chapitre qui font foi :

| Donjon | Drapeau retenu |
|---|---|
| relic_forest | `Chapter1.TeamCompletedForest` |
| illuminant_riverbed | `Chapter2.FinishedRiver` |
| crooked_cavern | `Chapter3.FinishedRootScene` |
| apricorn_grove | `Chapter4.FinishedGrove` |
| vast_steppe / searing_tunnel / mount_windswept | `Chapter5.FinishedExpedition` |
| gloomy_forest | `Chapter6.DefeatedGloomyBoss` |
| cloven_ruins | `Chapter7.SawAnimaCoreCorruption` |
| crystal_sanctuary | `Chapter8.CrystalSanctuaryComplete` |
| forgotten_marsh | `Chapter9.ForgottenMarshComplete` |
| celestial_peak | `Chapter10.CelestialPeakComplete` |

Les trois donjons de l'expédition partagent `FinishedExpedition` : l'expédition
se clôt au sommet du Mont Venteux, ce qui termine les trois d'un coup.

### Trois fonctions de décision

- `IsCleared(zone)` — le donjon a-t-il été bouclé ?
- `FollowsRoute(zone, ch)` — faut-il suivre le parcours complet ? Vrai pendant
  le chapitre, vrai à nouveau après. Remplace les gardes de chapitre.
- `IsReplay(zone, ch)` — sommes-nous en visite de rejouabilité ? Faux pendant
  le chapitre (l'histoire prime), vrai après.

### Deux fonctions de mise en scène

- `PlayEmptyScene(cfg)` — l'équipe entre, avance, balaie la salle du regard,
  constate. Ne décide pas de la suite.
- `EmptyArena(cfg)` — `PlayEmptyScene` **+** fin d'exploration.

Le corps de `PlayEmptyScene` est intégralement sous `pcall`. La sortie
(`EndDay`) est **en dehors** : si une position ou une piste audio pose problème,
la scène est écourtée mais le joueur n'est jamais coincé sur une carte sans
issue. Même précaution que sur les 7 `DefeatedBoss()`.

### Fin de journée

`EndDay()` pose `Dinnertime` / `Bedtime` / `MorningWakeup` / `MorningAddress`,
puis `EndDungeonRun(..., display=true, fanfare=true)` vers le réfectoire
(carte 6), ou le 2ᵉ étage (22) s'il reste une mission à rendre.

`display=true` est ce qui déclenche le **journal de fin d'exploration**.

---

## Textes ajoutés

4 clés par arène (`_R01` à `_R04`), en **EN dans `strings.resx`** et **FR dans
`strings.fr.resx`**. Structure constante : le partenaire remarque le vide, le
héros pense une ligne intérieure, le partenaire conclut, puis la narration
ferme sur « Il n'y a plus rien à trouver ici. Il est temps de rentrer. » —
reprise exacte de la formule de `crooked_den.GenericEnding()`.

| Arène | Préfixe | Ce qui a changé sur place |
|---|---|---|
| Gardien de la Steppe | `VSG_R01..R04` | l'herbe a repoussé, plus une empreinte |
| Gardien du Mont | `MWG_R01..R04` | le ciel est vide, il niche plus haut |
| Creuset Ardent | `SC5_R01..R04` | la lave a repris ses canaux, les Limagma somnolent |
| Sanctuaire des Titans | `CRB_R01..R04` | trois alcôves vides, veines dorées virées au gris |
| Cœur de la Forêt | `GF6B_R01..R04` | les racines se sont desserrées, la lumière passe |
| Chambre de Diancie | `CSB_R01..R04` | les gemmes ont cessé de chanter |
| Abysses du Marais | `FMB_R01..R04` | la vase s'est refermée, pas un remous |
| Autel des Cieux | `CPB_R01..R04` | l'autel est nu, il est reparti vers la mer |
| Corniche Fulgur | `CPF_R01..R04` | trois empreintes aux trois quarts effacées |

### Bug de traduction corrigé au passage

Cinq grounds n'avaient **que** `strings.resx` — rempli en **français**. Le
fichier anglais contenait donc du FR, et il n'existait aucun fichier FR :
`crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_boss`,
`autel_celeste`, `celestial_peak_fulgur` (16 clés `CSB_/FMB_/CPB_/CPF_`).

Le FR a été déplacé vers `strings.fr.resx` et une vraie traduction EN écrite
dans `strings.resx`. Même classe de bug que les 244 + 16 clés inversées déjà
traitées.

---

## Cas particulier : le Pic Céleste

Le relais choisissait sa destination ainsi :

```lua
local nextSegment = 2
if SV.Chapter10.OutranEscouadeFulgur then nextSegment = 4 end
```

`OutranEscouadeFulgur` reste vrai **pour toujours**. En rejouabilité, le relais
aurait donc sauté directement au segment 4, rendant la **Mer de Nuages
(segment 2) injouable**.

Correction : un jalon `SV.Chapter10.ReplayPastFulgur`, propre au parcours en
cours, remis à `false` à chaque entrée dans le donjon (`celestial_peak.Init`)
et posé à `true` au passage de la corniche Fulgur. Déclaré dans `scriptvars.lua`
et rattrapé dans `OnUpgrade`.

La corniche Fulgur est le seul ground à utiliser `PlayEmptyScene` plutôt que
`EmptyArena` : ce n'est pas une fin de donjon, on enchaîne vers le relais.

## Cas particulier : la Forêt Lugubre

La sortie du segment 1 exigeait `SV.Chapter6.ChenipentFound` pour ouvrir le
cœur de la forêt. En rejouabilité, la mission de sauvetage est déjà accomplie
et la chenille ne réapparaît pas — la condition ne pouvait plus être remplie.
Elle accepte désormais aussi `ReplayEnding.IsCleared('gloomy_forest')`.

---

## Ce qui n'est PAS touché

- **Les revanches Grodoudou.** Zarude (`verdant_oath`, segment 3) et Regigigas
  (`colossus_quarry`, segment 3) restent le seul moyen de réaffronter ces deux
  boss. La rejouabilité n'y touche pas et ne les court-circuite pas :
  `zone/cloven_ruins/init.lua` intercepte le cas revanche **avant** d'atteindre
  le ground d'arène.
- **Les mini-boss ch5.** Ils sont hors du chemin en rejouabilité : le relais
  saute au segment 2 dès que `<X>MiniBossCleared` est vrai, ce qui est
  définitif. Aucune scène de salle vide n'est nécessaire.
- **La progression de chapitre.** `FollowsRoute` ajoute une condition, elle n'en
  retire aucune. Une partie en cours se comporte exactement comme avant.
- **Les 202 autres donjons** (Ancrages, Réseau des Anciens Chemins, Réseau du
  Ciel, secondaires) : ils étaient déjà rejouables, ils rentrent à Metano.

---

## Vérifications effectuées

- Lua : **635/635** fichiers OK
- `.resx` : **573/573** OK
- Zones JSON + `index.idx` : **209/209** OK, 0 zone manquante
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- Toutes les clés `_R0x` appelées existent en EN **et** en FR (contrôle croisé
  script ↔ resx)
- Simulation Lua du module sur 7 scénarios : histoire finie, déverrouillage +
  idempotence, chapitre 5 en cours, chapitre 6 après expédition, chapitre 7
  avant/après victoire, donjon non terminé, zone inconnue

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier :

- Les **coordonnées de spawn et de caméra** des 9 scènes de salle vide sont
  déduites de la taille des cartes et des scènes de boss existantes, pas
  observées. Deux arènes sont petites (`mount_windswept_guardian` 208×176,
  `searing_crucible` 168×168) — les positions y ont été resserrées, mais le
  cadrage reste à confirmer à l'œil.
- Le **nom de piste musicale** de chaque scène reprend celui de la carte ou de
  la scène de boss correspondante ; non vérifié à l'écoute.
- Le parcours complet **entrée → relais → profondeurs → salle vide → journal →
  guilde** n'a jamais été joué de bout en bout.
