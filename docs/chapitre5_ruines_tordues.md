# Chapitre 5 — rattachement des Ruines Tordues

> Rien de ce document n'est validé manette en main. Tout repose sur de
> l'analyse statique et une simulation à plat des drapeaux.

## Pourquoi ce déplacement

Les Ruines Tordues étaient codées en **chapitre 7** (`SV.Chapter7`,
`*_ch_7.lua`) alors qu'elles sont l'intrigue du **chapitre 5**.

Le dialogue du jeu le dit lui-même. Au sommet du Mont Venteux, dernier
combat de l'expédition, Tornadus déclare :

| clé | réplique |
|---|---|
| `MWG_040` | « De là-haut, on cesse de voir des lieux. On commence à voir des formes. » |
| `MWG_041` | « Et il y a une forme sous votre monde, petits. Elle a des angles. » |
| `MWG_042` | « Rien de naturel n'a d'angles. » |
| `MWG_046` | « quand vous trouverez les angles — ne supposez pas qu'ils ont été bâtis pour vous garder DEHORS. » |

Une forme anguleuse et **bâtie**, sous le monde : ce sont les Ruines. Le
gardien du ciel les a vues d'en haut sans pouvoir y descendre, et passe
le relais. Deux chapitres d'écart cassaient le raccord que ce dialogue
construit lui-même.

Un commentaire du dépôt confirmait d'ailleurs que la victoire de Tornadus
renvoyait à l'origine vers `cloven_ruins`, avant que le lien soit coupé.

## Nouvelle structure du chapitre 5 — trois actes

```
ACTE I   expédition   Grande Steppe -> Tunnel Ardent -> Mont Venteux
                      boss Tornadus  ->  SV.Chapter5.FinishedExpedition
ACTE II  retour       nuit à la guilde, rêve « météore » (HadFirstDream)
ACTE III Ruines       briefing Phileas -> Cloven Ruins -> Regigigas
                      -> récit de la Genèse -> rêve « rouage »
                      -> HadRuinsDream  ->  chapitre 6
```

Simulation à plat des seize maillons (`/tmp/sim_ch5.py`) : **16 valides,
0 rompu**.

## Migration de l'état de sauvegarde

Les champs de `SV.Chapter7` sont rapatriés dans `SV.Chapter5`. Trois ont
dû être **renommés**, parce que `SV.Chapter5` portait déjà un champ du
même nom avec un autre sens :

| ancien (`SV.Chapter7`) | nouveau (`SV.Chapter5`) | pourquoi |
|---|---|---|
| `ShowedTitleCard` | `ShowedRuinsTitleCard` | le ch5 a son propre carton-titre |
| `MissionAccepted` | `RuinsMissionAccepted` | homonyme dans d'autres chapitres |
| `HadFirstDream` | `HadRuinsDream` | **deux rêves distincts** |

Le cas du rêve méritait vérification : `guild_heros_room_ch_5` déclenche
la vision `meteore`, `_ch_7` la vision `rouage`. Fusionner sous un seul
nom aurait fait disparaître l'un des deux selon l'ordre d'écriture.

80 références basculées dans 17 fichiers. Le bloc `SV.Chapter7` est
supprimé et remplacé par un commentaire qui documente la correspondance.

**Conséquence sur les sauvegardes existantes** : une partie d'avant ce
changement verra les champs des Ruines revenir à leur valeur par défaut.
La progression des Ruines est à refaire ; le reste du chapitre 5 est
intact.

## Le piège du dispatch par numéro de chapitre

`GeneralFunctions.ChapterDispatch(prefix, handler, ...)` résout le module
à appeler en concaténant le **numéro de chapitre** :
`_G["metano_town_ch_" .. chapter]`.

Renommer les fichiers `_ch_7` en `_ch_5` était donc impossible pour les
hubs : `metano_town_ch_5` et `metano_town_ch_7` définissent **24
fonctions homonymes** (`Audino_Action`, `Tropius_Action`,
`Noctowl_Action`…) avec des dialogues différents — ceux du départ en
expédition d'un côté, ceux de l'acte des Ruines de l'autre. Les fusionner
aurait supprimé une des deux versions.

Solution retenue : le dispatch résout désormais un **acte**, pas un
numéro.

```lua
function GeneralFunctions.ChapterActSuffix()
    -- chapitre 5 + expédition finie  ->  modules « _ch_7 »
end
```

Avec un **repli** : pendant l'acte des Ruines, un PNJ sans réplique
dédiée garde celle du chapitre 5 au lieu de devenir muet. Les 54 PNJ de
Metano Town continuent donc de parler, et leurs dialogues suivent l'acte
en cours.

Les neuf `Event_Trigger_N_Touch` de `metano_town/init.lua`, qui
contournaient `ChapterDispatch` via un `load()` dynamique, ont été
basculés sur la même fonction.

## Fichiers réellement renommés

Seuls les modules **propres au donjon** pouvaient l'être sans collision :

- `cloven_ruins_boss_ch_7.lua` → `_ch_5.lua`
- `cloven_ruins_miniboss_ch_7.lua` → `_ch_5.lua`
- `genesis_vision_ch_7.lua` → `_ch_5.lua`

`guild_third_floor_lobby_ch_7.lua` a été **supprimé** après transplantation
de ses deux fonctions (`RuinsExpeditionAddress`, `Noctowl_Action`) dans le
module `_ch_5` : tant qu'elles vivaient dans `_ch_7`, le dispatch ne les
appelait plus et Phileas restait muet pendant tout l'acte.

## Bugs trouvés et corrigés en chemin

### 1. `master_zone.json` supprimé par erreur (purge précédente)

C'est le hub central : **86 GroundMaps**, toutes les sorties de donjon y
renvoient. Sans lui, `EndDungeonRun(..., "master_zone", -1, N, 0)`
n'aboutissait nulle part. Restauré depuis `530bc0b~1`.

### 2. Routage de sortie des Ruines — deux erreurs

Indices de `master_zone` : `65` entrée des Ruines, `66` genesis_vision,
`67` relais, `68` arène du boss, `46` entrée de la Grande Steppe.

| cas | avant | après |
|---|---|---|
| échec segment 0 | `46` → **entrée de la Grande Steppe**, un autre donjon deux étapes plus tôt | `65` entrée des Ruines |
| échec segments 2 et 4 | `66` → **cinématique de la Genèse**, scène de résolution d'après-victoire | `67` relais |

Le second était le plus visible en jeu : un joueur vaincu dans les
profondeurs tombait dans la scène qui résout le chapitre.

### 3. Le chapitre 5 sautait par-dessus son propre dernier acte

`guild_heros_room/init.lua` basculait `Chapter = 6` dès
`FinishedExpedition`. Le joueur passait du sommet du Mont Venteux au
chapitre suivant **sans jamais voir les Ruines**, alors que Tornadus
venait de les lui annoncer. Le bloc ouvre désormais `cloven_ruins` au
voyage et laisse le chapitre 5 en cours ; la clôture se fait sur
`HadRuinsDream`.

### 4. Scènes de chambre devenues injouables

Le carton-titre des Ruines et le second rêve étaient gardés par
`Chapter == 7`, condition désormais jamais vraie. Replacés dans la
branche du chapitre 5, testés **du plus spécifique au plus général** pour
que la nuit de l'expédition ne masque pas celle des Ruines.

### 5. Table des paliers de chapitre

`chapter_gates` ouvrait `crystal_sanctuary`, `forgotten_marsh` et
`celestial_peak` — trois zones purgées. `UnlockDungeon` aurait été appelé
sur des zones absentes. Table réduite au seul palier vivant :

```lua
[5] = { function() return SV.Chapter5.HadRuinsDream end, 6, nil, {} },
```

`gate[3]` pouvant valoir `nil`, l'appel `UnlockDungeon` est maintenant
conditionnel — sinon le passage de chapitre plantait.

### 6. Listes de donjons pointant vers du vide

- sortie Est de Metano : **19 donjons listés, 11 supprimés**. Liste
  ramenée aux 8 réels, Cloven Ruins compris.
- 23 `UnlockDungeon` visant des zones absentes, neutralisés en commentaire
  dans trois fichiers.
- `gloomy_forest_entrance` (ground + scripts) supprimé : sa zone n'existe
  plus.
- `DazzlingPlaza.ActeII` et `TownRaid` appellent encore `gloomy_forest`.
  Ils sont déjà sous `pcall` — échec silencieux, pas de plantage — et
  annotés en attendant la reconstruction du chapitre 6.

## État de la validation

```
264 fichiers Lua compilent, 0 erreur
audit_bugs               11 signalements
verify_lua_globals       aucune fonction fantôme
verify_cutscene_guard    aucune scène à risque
verify_emotions          aucun risque de crash de portrait
résidus SV.Chapter7      0
résidus Chapter == 7     0
simulation chaîne ch5    16 maillons, 0 rompu
```

## Ce qui reste ouvert

1. **Validation en jeu.** Priorité : la bascule d'acte de Metano Town
   (les 54 PNJ doivent changer de dialogue après le Mont Venteux, sans
   redevenir muets) et le nouveau routage d'échec dans les Ruines.
2. **Chapitre 6.** Son donjon (`gloomy_forest`) est purgé ; le palier
   `[6]` de `chapter_gates` reste à rebrancher quand il sera reconstruit.
   En l'état, le jeu s'arrête narrativement à la fin du chapitre 5.
3. **`first_core_location`** : ground conservé, plus déclaré par aucune
   zone. À rattacher ou à retirer.
4. **63 grilles de collision vides**, dont les arènes de boss — chantier
   documenté dans `docs/audit_logique_spatiale.md`, à traiter via les
   sources pmd-sky.
