# PASSATION — New Era : Abyss to Ascension

> Document de reprise pour le prochain agent Arena.
> Révision : **2026-07-28**, sur la branche `arena/019faad0-new-era-abyss-to-ascension-v4`.
> Les chiffres de ce document ont été **re-mesurés** à cette date, pas recopiés.

---

## 0. ÉTAT RÉEL DU CHECKOUT (vérifié le 2026-07-28)

| point | valeur mesurée |
|---|---|
| branche de travail | `arena/019faad0-new-era-abyss-to-ascension-v4` |
| HEAD | `b7afed9` — *fix(mount-windswept) : équipe du donjon cohérente…* |
| `origin/main` | `e6f9e8d` — merge de la PR #3 |
| relation | **HEAD et `main` divergent** : ce sont deux commits frères, chacun a 1 commit que l'autre n'a pas |
| clone | **superficiel** (`.git/shallow` contient `b7afed9` et `e6f9e8d`) : `git log` ne remonte pas au-delà |
| arbre de travail | propre (`git status --porcelain` vide) |
| tag de build | **`2026-08-01-W`** (posé le 2026-07-29) — le prochain lot doit passer à `2026-08-01-X` |

**Attention — écart avec l'ancienne passation.** Elle annonçait « tout est mergé dans
`main`, dernier tag `-U`, prochain `-V` ». C'est **faux sur ce checkout** :
`b7afed9` n'est pas dans `main`, et il a déjà consommé le tag `-V`.
Le diff `origin/main..HEAD` porte sur 15 fichiers (126 664 insertions), dont
`mount_windswept_entrance_ch_5.lua` (+1755 lignes) et le `.rsground` du Mont.

**Conséquence pratique :** ne pas rebaser ni fusionner à l'aveugle sur `main`.
Le travail Mont Venteux vit **uniquement ici**. Il doit partir en PR depuis cette
branche.

### Amorçage d'une nouvelle session

```bash
git log --oneline -3
git status --porcelain                       # doit être vide
pip install --break-system-packages lupa Pillow numpy   # jamais préinstallés
ls Data/Script/halcyon/TownNight.lua tools/audit_bugs.py
grep -rn "2026-08-01" Data/Script/halcyon/main.lua \
  Data/Script/halcyon/scriptvars.lua \
  Data/Script/halcyon/ground/vast_steppe_midpoint/init.lua
```

Le dernier `grep` donne le tag courant : **c'est lui qui fait foi**, pas ce document.

---

## 1. LE PROJET

Mod PMDO (moteur RogueEssence, C# + Lua) — fork narratif de Halcyon.
Namespace Lua : **`halcyon`**. Jeu en **français**.
Dépôt : `meromoonmeri/new-era-abyss-to-ascension-V4`.
`Mod.xml` : version `0.5.1`, `GameVersion` `0.8.12`, `ModType` `Quest`,
UUID `CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF` — **ne jamais toucher au namespace
ni à l'UUID** sans validation explicite : les sauvegardes en dépendent.

L'utilisateur écrit en français, style direct, souvent sans ponctuation.
**Répondre en français.** Il teste lui-même en jeu et signale ce qui casse.
Il a validé la direction : « tu as compris l'essence de New Era, le jeu doit
avoir cette âme unique qui fait vibrer le joueur ».

**Objectif de contenu :** porter les chapitres 5 à 10 à ~7000 boîtes de dialogue
chacun, pour 23-30 h de jeu. Mesure actuelle ≈ 15 h.

---

## 2. MÉTHODOLOGIE — LE CŒUR DE LA PASSATION

Ce qui a fonctionné n'est pas un style, c'est une discipline. Elle est
reproductible et **doit être reprise telle quelle**.

### 2.1 Preuve avant hypothèse

Ne jamais affirmer sans avoir ouvert le fichier.

| supposé | réalité vérifiée |
|---|---|
| `SV.storyProgression.Chapter` | **n'existe pas** → `SV.ChapterProgression.Chapter` |
| `Guildmaster.ogg` | le fichier est `Guildmaster Wigglytuff.ogg` |
| `DUN_Tumble` | SE inexistant → `DUN_Rollout` (attesté) |

### 2.2 Ne jamais inventer une API

Avant d'utiliser un appel moteur, compter ses occurrences **hors du fichier
courant**. Zéro occurrence = invention.

```bash
grep -rl "MonAPI" --include=*.lua Data/Script | grep -v mon_fichier | wc -l
```

Deux inventions attrapées ainsi :

- `Anims:Clear()` → la vraie méthode est `Anims:RemoveAt(i)` en boucle
  descendante (patron dans `event_single.lua:724`)
- `CharAnimateTurnToChar` → la vraie est `CharTurnToCharAnimated` (547 fichiers)

Un script d'audit d'API réutilisable est décrit en §9 (`api_check`), il liste
tous les appels d'un fichier triés par nombre d'occurrences ailleurs : **toute
ligne à `0` est une invention à corriger avant commit**.

### 2.3 Prouver le format d'un JSON avant de l'écrire

**La leçon la plus coûteuse : 153 905 lignes réécrites en devinant.**

```python
d = json.loads(s)
assert json.dumps(d, ensure_ascii=False, indent=0) == s   # ou indent=2, ou compact
```

Formats rencontrés dans le dépôt :

- `indent=0` — grounds de la guilde (`guild_guildmasters_room.rsground`)
- compact `separators=(', ', ': ')` — `metano_town.rsground`, `.rsmap`
- `indent=2` — `MapStatus/*.json`

**Tous les JSON ont un BOM UTF-8** : lire en `utf-8-sig`, réécrire avec
`f.write('\ufeff')`. Sauf exceptions mesurées : 5 MapStatus sur 7 n'en ont pas.

Après écriture, **comparer structurellement** ancien/nouveau champ par champ.
Un patch propre modifie 4 champs, pas 4000.
Cas vécu : `metano_town.rsground` réécrit en `indent=2` a fait passer le clone
de 38 Mo à **94 Mo** (alerte GitHub).

### 2.4 Toute table `SV` neuve : déclarer ET rattraper

Bug qui a coûté une partie neuve : `GloomyPlayedMidpointIntro` lu mais déclaré
nulle part → `nil`.

1. Déclarer dans `Data/Script/halcyon/scriptvars.lua`
2. Rattraper dans `OnUpgrade` de `services/debug_tools/init.lua`, **en déduisant**
   l'état pour ne pas régresser un joueur en cours :

```lua
if SV.Chapter8.CrystalSanctuaryComplete == nil then
    SV.Chapter8.CrystalSanctuaryComplete = (SV.Chapter8.DefeatedDiancie == true)
end
```

**Preuve utile** : lire un champ absent d'une table *existante* rend `nil` (pas
de crash). Lire un champ sur une table *absente* **crashe**.

*Exemple en vigueur* : `SV.Chapter5.MountLastExitReason` et
`SV.Chapter5.PlayTempMountScene`, ajoutés pour le retour raté du Mont Venteux,
sont bien déclarés dans `scriptvars.lua` (~ligne 795).

### 2.5 Vérifier la marchabilité ET l'accessibilité

```python
libre = ob[x//8][y//8]['Tags'] == 0        # marchable
```

Mais marchable ≠ atteignable. Faire un **parcours en largeur** depuis l'entrée
du joueur : une zone peut être libre et isolée par un mur. C'est ainsi qu'une
porte inatteignable a été évitée dans le bureau de Penticus.

### 2.6 Vérifier que chaque objet a son handler

- `triggerType 0` = **décoratif**, jamais activable (preuve : les 13 `Food_*`
  du réfectoire n'ont aucun handler et la salle fonctionne)
- `1` → handler `<Nom>_Action`
- `2` / `3` → handler `<Nom>_Touch`

Un objet `trig=1` sans handler est **muet en jeu**.
**Piège** : le nom du module Lua ne suit pas toujours le dossier —
`ground/guild_top_left_bedroom/` déclare `guild_Top_Left_bedroom`.

### 2.7 Corriger ses propres outils

`audit_bugs.py` a d'abord sorti **68 signalements** ; après tri, **56 étaient des
faux positifs de l'outil lui-même**. Résultat stabilisé : **12**, tous documentés
inoffensifs (§11).

Faux positifs corrigés (à ne pas réintroduire) :

- code dans un bloc `--[[ ]]` compté comme vivant
- `local` successifs pris pour des champs de table sans virgule
- namespaces multiples (`megastones/scriptvars.lua`) ignorés
- plusieurs champs sur une ligne (`Map = 1, Entry = 0`)
- `triggerType 0` compté comme interactif

De même, `count_dialogue.py` comptait `TownVoicesLate` pour **3 boîtes au lieu de
668** : les répliques y sont des valeurs de table, pas des appels.

**Bug ouvert dans `count_dialogue.py`** (mesuré le 2026-07-28) : appelé **sans
argument** il fonctionne, mais `python3 tools/count_dialogue.py .` **plante** —
il prend `.` pour un numéro de chapitre (`int('.')` → `ValueError`, ligne 80).
L'usage correct est `python3 tools/count_dialogue.py` (tableau global) ou
`python3 tools/count_dialogue.py 5` (détail d'un chapitre). À rendre tolérant
un jour, sans urgence.

### 2.8 Mesurer avant / après

```bash
python3 tools/audit_integrite.py .
git stash && python3 tools/audit_integrite.py . && git stash pop
```

Référence **re-mesurée le 2026-07-28 : 925 anomalies** — inchangée, c'est bien
la dette préexistante de clés orphelines et non une régression.

### 2.9 Honnêteté

Signaler ses erreurs, les faux positifs de ses propres outils, et **répéter que
rien n'est testé en jeu**. Tout est validé statiquement.

---

## 3. RÈGLES PROJET NON NÉGOCIABLES

- Jamais **« Necrozma »**, **« Eternatus »**, **« l'Abîme »**, **« prison »**
  dans un texte affiché (le twist des Cœurs-prison est réservé à l'arc 6).
  Ces mots existent légitimement dans les **identifiants d'espèces**
  (`CharacterEssentials.lua`, `LegendZones.lua`) et dans les **commentaires de
  rappel de la règle** : c'est le texte *affiché* qui est visé, pas le code.
- **Ne jamais nommer les personnages des jeux d'origine** — le joueur reconnaît,
  le héros non
- La Voix reste **anonyme** : speaker `\uE040`, jamais de nom ni de portrait
- La Voix **ne parle pas en ville de jour** (exception motivée : la nuit, au
  puits, quand le héros est seul)
- `strings.resx` = **anglais** · `strings.fr.resx` = **français**
- Répliques : **1-2 phrases, < 150 caractères** hors `[pause=N]`
- Modules globaux → **texte littéral**, jamais `STRINGS.MapStrings`
- Aucun légendaire / fabuleux en boss ou spawn d'add-on
- Tout sous `pcall`, **sortie garantie** : une scène qui casse ne doit jamais
  figer le joueur
- Piège Lua : insérer un champ en collant un commentaire avale la virgule →
  **virgule avant le commentaire**
- Toute zone `.json` modifiée → resynchroniser `Data/Zone/index.idx`
- `GAME:EnterGroundMap(nom, marker)` ne marche que si `nom` est dans les
  `GroundMaps` de la zone courante
- Incrémenter le tag de build dans **3 fichiers** : `main.lua`, `scriptvars.lua`,
  `ground/vast_steppe_midpoint/init.lua`
- Imports pmd-red / EoSO : géométrie **1:1**, seuls dialogues et casting changent

---

## 4. GRAMMAIRE DES CINÉMATIQUES

Relevée dans EoSO (`beach/init.lua`, `storm_cutscene_a`, `chapter_card`) et
appliquée partout depuis :

1. **Le lieu avant les personnages** — le son monte, puis l'image, puis le mot
2. **Constat sensoriel → réaction affective → décision**, jamais l'inverse
3. La caméra cadre le **décor**, puis redescend sur le duo au moment de décider
4. Les départs sont des **coroutines jointes** : marche, fondu et musique se
   terminent ensemble
5. **Chacun parle de son métier** — personne ne résume l'intrigue ; la ville ne
   *sait* pas, elle *perçoit les effets*
6. **Le corps parle avant la bouche** — montrer l'état physique avant de le
   commenter (un évanouissement : jambes qui lâchent, écran qui tangue, chute,
   puis le noir)

---

## 5. CASTING (vérifié — une erreur a déjà été commise ici)

| instance | espèce | surnom | rôle |
|---|---|---|---|
| `Tropius` | tropius | **Penticus** | **maître de guilde** |
| `Noctowl` | noctowl | **Phileas** | le savant / archiviste |
| `Audino` | audino | **Rin** | tient l'assemblée (2ᵉ étage) |
| `Snubbull` | snubbull | **Coco** | cuisinière |
| `Mareep` | mareep | **Shuca** | recrue |
| `Cranidos` | cranidos | **Ganlon** | recrue (râleur) |
| `Breloom` | breloom | **Kino** | équipe |
| `Girafarig` | girafarig | **Reinier** | équipe |
| `Growlithe` | growlithe | **Hyko** | garde |
| `Zigzagoon` | zigzagoon | **Almotz** | garde |
| `Chatot` | chatot | **Falo** | **musicien de Metano — PAS un membre de la guilde** |

**Erreur commise et corrigée** : une scène convoquait « Phileas, maître de guilde »
et « Chatot, son second ». Les deux étaient faux. Preuve dans
`guild_third_floor_lobby_ch_7.lua` : Penticus ouvre l'adresse du matin et donne
la parole — « …les Ruines Tordues. Phileas ? » — et Phileas répond
« Merci, Penticus ».

---

## 6. FORMATS DE FICHIERS DÉCODÉS

### `.tile` (Content/Tile)

```
[0..3]   uint32  tileSize = 8
[4..7]   uint32  nbEntrées
[8..]    table   x(u32) y(u32) offset(u64) × nbEntrées
[offset] uint32 taillePNG + uint32 padding + PNG 8×8 RGBA
```

Plusieurs entrées peuvent pointer le même offset (tuiles mutualisées).
Round-trip prouvé : MD5 identique sur 1 231 857 octets.

### `.dir` (Content/BG, Content/Particle)

```
[uint32 taillePNG][uint32 0][PNG][frameW][frameH][LocHeight][frameCount]
```

Les 4 derniers champs sont des uint32 LE. Viewport PMDO = **320×240** : un fond
plein écran (`WaitShowBG`) doit avoir des frames 320×240.
Exemple vérifié — `Ash_Fall.dir` : PNG 192×16, frameW/H 16, 12 frames
(0-7 = chute, 8-11 = impact).

### `.rsground`

La taille est dans **`obstacles`**, indexé **`[x][y]`** :
`largeur = len(ob)*8`, `hauteur = len(ob[0])*8`. Case libre si `Tags == 0`.
Entités dans `d['Object']['Entities'][0]` → `MapChars`, `GroundObjects`,
`Spawners`, `Markers` (position dans `Collider` X/Y).

### `.rsmap` (arènes)

`MapTeams[0].Players[]` = les combattants. Champs utiles : `CurrentForm`,
`BaseForm`, `Level`, `HP`, **`MaxHPBonus`**, `Skills`, `serializationLoc`,
`Tactic`, `Unrecruitable`.
**`HP` et `MaxHPBonus` décrivent le même réservoir** : PV totaux = somme des deux.

---

## 7. API PMDO — CE QUI EST ATTESTÉ

Référence complète : `PMDODump/DataAsset/Docs/Script.txt` (3275 lignes, 255
fonctions). New Era en exploite 202/255.

**Attestées et sûres** (nombre d'occurrences hors fichier courant, re-mesuré) :

`UI:WaitShowDialogue` (5640) · `GAME:WaitFrames` (5564) · `STRINGS:Format` (5140) ·
`UI:SetSpeaker` (4170) · `TASK:BranchCoroutine` (1844) ·
`GROUND:CharAnimateTurnTo` (1041) · `GROUND:CharSetEmote` (736) ·
`GROUND:CharSetAnim` (830) · `GAME:FadeIn` (609) · `GROUND:TeleportTo` (598) ·
`GROUND:CharTurnToCharAnimated` (547) · `GAME:CutsceneMode` (544) ·
`TASK:JoinCoroutines` (521) · `GROUND:MoveToPosition` (376) ·
`GAME:MoveCamera` (352) · `GAME:FadeOut` (329) · `SOUND:PlayBattleSE` (291) ·
`UI:WaitShowTimedDialogue` (59) · `UI:WaitShowVoiceOver` (24) ·
`GROUND:AddMapStatus` (27) / `RemoveMapStatus` (11) · `GROUND:MoveScreen` (21) ·
`UI:WaitShowBG` / `UI:WaitHideBG` (14) · `SOUND:FadeInSE` (2, rare mais attesté :
`first_core_location_ch_3.lua:48`, `searing_tunnel_entrance_ch_5.lua:824`)

**À NE PAS UTILISER — n'existent pas :**

- `Anims:Clear()`
- `CharAnimateTurnToChar`
- `STRINGS.Format` (le point) → toujours **`STRINGS:Format`** (deux-points)

**SE attestés** : `EVT_Battle_Flash` · `DUN_Money` · `EVT_Emote_Exclaim_2` ·
`EVT_Emote_Startled` · `DUN_Shadow_Force` · `DUN_Rollout` · `DUN_Heal_Bell` ·
`_UNK_DUN_Water_Drop`

**Patron de rêve / vision** (vérifié `guild_heros_room_ch_5.lua:142-165`, et
appliqué au Mont Venteux) :

```lua
SOUND:PlayBGM('I Saw Something Again....ogg', true)
pcall(function() VoiceVisions.DreamSky(560) end)      -- Dream_Back + Dream_Front
pcall(function() UI:WaitShowBG('Genesis_Void', 180, 30) end)
UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
```

**Leçon issue d'un test en jeu** : un rêve joué sur `FadeOut` seul ne montre
**rien** — l'écran noir mange les effets. Il faut une planche de fond
(`WaitShowBG`) posée par-dessus, plus `VoiceVisions.DreamSky` pour la parallaxe.

---

## 8. MODULES GLOBAUX (Data/Script/halcyon/)

| module | rôle |
|---|---|
| `VoiceVisions` | la Voix parle au héros seul (`Speak`) + visions en planches (`Play`) + `DreamSky`, `Nausea`, `Recover` |
| `HeroVisions` | visions spécifiques du héros |
| `ChapterScenes` | scènes d'arrivée devant les donjons ch8-10 |
| `ChapterAftermath` | scènes d'après-boss |
| `ReplayEnding` | rejouabilité des donjons d'histoire (`FollowsRoute`) |
| `DazzlingArc` | Team Dazzling (ch6) |
| `VeilleurArc` / `LegendArc` | les 10 Veilleurs, les 42 gardiens |
| `BossFX` | signatures d'apparition (`EmergeShadow`, `StrikeThunder`…) |
| `BossMusic` | 12 thèmes distincts pour 49 arènes |
| `EngineKit` | 5 API PMDO inexploitées |
| `SideQuests` | requêtes de Metano (ch6, verrou de progression) |
| `TownVoices` | 26 PNJ réactifs, **ch6** |
| `TownVoicesLate` | 420 répliques, **ch7-10** (26 PNJ × 4 chapitres × 4 paliers) |
| `TownVoicesNight` | 59 habitants réagissent aux raids (361 lignes) |
| `TownNight` | choix de fin de journée + Metano de nuit |
| `TownNightScenes` | cinématiques de nuit par chapitre + Voix au puits |
| `TownRaid` | pillards nocturnes (3 vagues) |
| `TownPlunder` | conséquences d'un raid perdu |
| `TownReward` | récompenses d'un raid gagné |
| `RaidScenes` | écroulement / chevet de la guilde / fuite des ombres |
| `NightWatch` | le tour de guet (raison narrative de la nuit) |
| `Seasons` | saisons de Metano pilotées par le chapitre |

---

## 9. OUTILS (tools/ — 42 scripts)

| outil | usage | état mesuré 2026-07-28 |
|---|---|---|
| `audit_bugs.py .` | 12 contrôles d'exécution | **12 signalements** (conforme) |
| `verify_legend.py .` | mots interdits + stand des légendes | **tout vert** |
| `verify_scene_positions.py .` | entités hors carte | **388 scènes, aucune hors carte** |
| `verify_bg_format.py` | format des `.dir` | tout vert |
| `validate_all.py` | géométrie des arènes | tout vert |
| `audit_integrite.py .` | intégrité globale | **925** (dette connue) |
| `verify_ground_reachability.py .` | ancres atteignables (BFS) | **27** (dette d'import) |
| `count_dialogue.py` | densité par chapitre | ⚠ **sans argument** (voir §2.7) |
| `audit_boss_cinematics.py` | qualité des scènes de boss | — |
| `gen_season_particles.py` | génère les `.dir` de particules | — |
| `tile_night.py` | conversion nuit des tilesets | — |

### Validation complète avant chaque commit

```bash
python3 -c "import lupa,glob; L=lupa.LuaRuntime(); \
[L.compile(open(f,encoding='utf-8').read()) for f in glob.glob('Data/Script/**/*.lua',recursive=True)]"
python3 tools/audit_bugs.py .
python3 tools/verify_legend.py .
python3 tools/verify_scene_positions.py .
python3 tools/audit_integrite.py .
python3 tools/verify_ground_reachability.py .
python3 tools/count_dialogue.py          # SANS le point
```

### Audit d'API d'un fichier (à recréer si besoin, §2.2)

Script jetable qui liste chaque appel moteur d'un fichier avec son nombre
d'occurrences **ailleurs** dans `Data/Script`. Toute ligne à `0` = invention.

```python
import re, glob, sys
target = sys.argv[1]
src = re.sub(r'--\[\[.*?\]\]', '', open(target, encoding='utf-8').read(), flags=re.S)
src = re.sub(r'--[^\n]*', '', src)
calls = set(re.findall(r'\b((?:GROUND|GAME|UI|SOUND|TASK|AI|DUNGEON|_DATA|GeneralFunctions'
                       r'|VoiceVisions|CharacterEssentials|PartnerEssentials|STRINGS)[:.]\w+)', src))
blob = ''.join(open(f, encoding='utf-8', errors='replace').read()
               for f in glob.glob('Data/Script/**/*.lua', recursive=True) if f != target)
for c in sorted(calls, key=lambda c: blob.count(c)):
    print(f'{blob.count(c):6d}  {c}' + ('   *** ZERO AILLEURS ***' if blob.count(c) == 0 else ''))
```

### Cohérence clés `.resx` ↔ script

```python
used = set(re.findall(r"MapStrings\['([^']+)'\]", lua))
keys = set(re.findall(r'<data name="([^"]+)"', open(resx, encoding='utf-8-sig').read()))
print('manquantes:', used - keys, '| orphelines:', len(keys - used))
```

Sur `mount_windswept_entrance` : 119 clés utilisées, 119 présentes dans
`strings.resx` **et** `strings.fr.resx`, **0 manquante, 0 orpheline**.

---

## 10. DENSITÉ MESURÉE (`count_dialogue.py`, 2026-07-28)

| ch | boîtes | objectif |
|---|---|---|
| 1 | 642 | — |
| 2 | 656 | — |
| 3 | 659 | — |
| 4 | 524 | — |
| 5 | **1571** | 7000 |
| 6 | 457 | 7000 |
| 7 | 397 | 7000 |
| 8 | 324 | 7000 |
| 9 | 307 | 7000 |
| 10 | 256 | 7000 |
| multi-chapitres | 169 | — |
| commun (init, helpers) | 1845 | — |

Le ch5 est passé de 1480 à **1571** grâce au lot Mont Venteux (+91).
Repères : 1 étage ≈ 2 min, 1 boîte ≈ 6 s. Total actuel ≈ 15 h, cible 23-30 h.

---

## 11. LES 12 SIGNALEMENTS RESTANTS (tous inoffensifs, documentés)

- **5× `SV.guildmaster_summit.GameComplete`** — résidu d'add-on non installé,
  jamais écrit ni déclaré. Sans effet : rend `nil` → `false`.
  (`megastones/ground/cliff_camp`, `source_duns_imbi/ground/{base,canyon,cliff,forest}_camp`)
- **4× objets sans handler** — `testmap` (carte d'atelier jamais référencée),
  `grotte_plage_fond`, `guilde_parvis_soir`, `plage_crepuscule` (absentes de
  `master_zone`, donc inatteignables)
- **3× zones `Released=false`** — `imbion_coven_cave`, `imbion_haunted_bazar`,
  `imbion_sentient_workshop` : zones en réserve

**Ne pas les « corriger » sans raison** : ce sont des faux positifs assumés.
Le total doit rester à **12**. S'il monte, c'est une régression du lot en cours.

---

## 12. DETTES PRÉEXISTANTES CONNUES

- 727 clés `.resx` orphelines (dette d'écriture, pas un bug d'exécution)
- 74 clés `Connect_*` du bureau de poste (menu réseau hors périmètre)
- 36 clés `megastones` sans traduction FR
- `machine_recall_box.json` sans BOM
- IA `escortee` (EoN) documentée mais non importée — manque avéré pour les
  missions d'escorte
- Cartes `guilde_parvis_soir` / `_nuit` / `guilde_sous_sol_nuit` : coquilles
  vides (19 lignes, « RÉSERVE »), absentes de `master_zone`
- 31 grounds pmd-red « en réserve » non traités
- Chapitres 11-32 : donjons et 42 cinématiques d'Ancrage prêts, scénario non écrit

---

## 13. FAUX POSITIFS À NE PAS REFAIRE

- Doublons `.resx` non consécutifs = branches `if/else` exclusives (choix
  d'écriture, pas un bug)
- `Food_*` du réfectoire : `triggerType 0`, décoratifs
- `Teammate1` est natif ; `Slugma_*` créés par `GroundChar` direct
- `Fog_2`, `Black`, `Heat_Wave`, `Silver_Wind`, `Cosmic_Power`,
  `clouds_overhead` : assets **moteur**, absents du mod par conception
- Les « Chambres des Âges » (`chambre_agee_an` / `_o`) ne sont **pas** des
  chambres à coucher : ce sont des cavernes (imports pmd-red, `Boss_Marker`,
  musique de carrière)
- `Hay_Bed.dir` n'est **pas** du mobilier d'intérieur : il est rangé à côté de
  `Campfire.dir` dans `Content/Object/`, et `mount_windswept_midpoint` porte
  déjà 3 tentes + 4 feux. Un bivouac **est** le vocabulaire visuel de ce donjon.
- « Necrozma » / « Eternatus » dans `CharacterEssentials.lua`, `LegendZones.lua`,
  `LegendArc.lua` : ce sont des **identifiants d'espèces**, pas du texte affiché

---

## 14bis. MONT VENTEUX — LA CARTE ÉTAIT CASSÉE (corrigé le 2026-07-29)

Le §14 ci-dessous décrivait la scène comme « terminée » sur la foi de
**métriques** (nombre de boîtes, d'émotions, de coroutines). Elles étaient
bonnes. La carte, elle, était **injouable** — et aucune métrique ne le disait.

**Leçon de méthode :** compter des appels ne prouve pas qu'une scène
fonctionne. Il faut ouvrir la géométrie et vérifier chaque coordonnée contre
la grille d'obstacles.

### Cause racine — `obstacles` est indexé `[x][y]`

Un lot antérieur a voulu ajouter un océan « au sud, rows 78-80 » et a rallongé
la table `obstacles`. Comme elle est indexée `[x][y]`, **allonger la table du
dessus agrandit la LARGEUR** :

- carte passée de 552×504 à 648×504 (12 colonnes à l'**est**, zéro rangée au sud) ;
- **2520 tuiles `DuskBeach`** — une plage au crépuscule — plaquées sur le flanc
  d'une montagne ;
- `Main_Entrance_Marker` déplacé en (256,592) = tuile (32,**74**) sur une grille
  de 63 rangées : **le joueur apparaissait hors carte**.

### Les 7 bugs corrigés

1. **Arrivée hors carte** — duo téléporté en y=540/556, Hyko et Almotz en
   y=572/588, caméra en (256,524). Maximum réel : 503.
2. **Paillasse inatteignable** — lit 12 en (344,132) : sol libre, mais dans une
   poche isolée. La carte a **3 composantes connexes** ; il était dans la mauvaise.
3. **4 paires de paillasses en recouvrement** — `Hay_Bed` fait 40×40 (en-tête
   `.dir` vérifié), lits 2/3, 4/5, 7/8, 9/10 se chevauchaient de 7×7 px.
4. **Le dîner se tenait sur les paillasses** — chaque convive envoyé aux
   coordonnées de sa couche, à ~100 px du feu, sur des lits pas encore déployés.
5. **Personne ne rejoignait sa couche** — duo, Hyko et Almotz jouaient `Sleep`
   debout à table ; 4 paillasses vides toute la nuit.
6. **PNJ dans le décor** — Shuca sur la couche 9, Reinier sur la 7, Coco dans
   le foyer, Penticus et Phileas sur la couche 1.
7. **Rocher de Kangaskhan à 4/16 dans la roche**.

### Nouvelle disposition : fer à cheval, pas cercle

Ouverture plein sud (on arrive et repart par là). 12 positions validées sur
4 critères : sprite 40×40 sur sol libre · connexe depuis l'entrée · sans
recouvrement · assise (+13,+10) libre. `sleepOrder` **lit** `seats` via un
index `bedOf` — les deux listes ne peuvent plus diverger.

```lua
BEDS = { {248,116},{298,168},{342,168},{330,210},
         {372,216},{348,258},{320,300},{220,314},
         {178,286},{156,244},{154,202},{170,160} }
```

Cercle de **repas** distinct (rayon ~44 px autour du feu en 256,220) : les
convives mangent ensemble et tiennent dans un viewport 320×240.

### Nouvel outil — `tools/verify_ground_reachability.py`

`verify_scene_positions.py` tolère **un écran entier** de dépassement : le bug
était à +36/+84 px, sous le seuil. **J'ai tenté de durcir ce seuil et je l'ai
reverté** — mesure faite, le contenu d'origine jouable dépasse légitimement
jusqu'à +69 px (`relic_forest`, `apricorn_glade`, `metano_altere_transition`).
L'ampleur seule ne discrimine pas.

Le nouvel outil teste ce que rien ne testait : **l'accessibilité par parcours
en largeur** depuis l'entrée du joueur. Faux positifs triés avant livraison
(`Boss_Marker`, `Food_*`, convives attablés sur le mobilier).
**Référence : 27** — dette d'import préexistante, aucun sur les cartes du ch5.

---

## 14. MONT VENTEUX — CONTENU NARRATIF (ne pas réécrire)

L'ancienne passation présentait ce chantier comme prioritaire, avec 6 actes à
écrire. **Il a été réalisé** dans le commit `b7afed9` de cette branche.
Mesures comparatives du 2026-07-28 :

| métrique | Mont Venteux | Tunnel Incandescent | ancienne cible |
|---|---|---|---|
| lignes | **2336** | 2427 | — |
| boîtes de dialogue | **192** | 240 | ~230 |
| émotions (`CharSetEmote` + `SetSpeakerEmotion`) | **164** | 161 | ~55 |
| mouvements de caméra | **32** | 11 | ~10 |
| coroutines (`BranchCoroutine`) | **90** | 214 | ~90 |
| `JoinCoroutines` | 31 | 42 | — |

Le Mont **dépasse** le Tunnel en émotions et en caméra, l'égale en lignes, et
atteint la cible de coroutines. Il reste en retrait sur le nombre brut de boîtes
(192 contre 240) — c'est le seul écart résiduel, et il est mineur.

### La scène livrée : `CampNightfall`, 16 sections

`Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua:51`

1. Kino et Reinier rejoignent le camp
2. Le dîner — installation autour du feu
3. La tablée — la cuisinière, le ronchon, la première fois
4. **Les conversations parallèles** — trois groupes, coroutines simultanées avec
   verrou `stopTalking` et animations de fond
5. Le silence — le héros et la montagne
6. L'ordre du soir — Penticus envoie tout le monde dormir
7. Le déploiement des couchages, puis la nuit
8. Le coucher — un par un, respiration désynchronisée
9. La scène intime — le duo face au sommet
10. **LE RÊVE** — `DreamSky` + `Genesis_Void` + Voix `\uE040` + tangage
    `ScreenMover`, réveil en sursaut
11. **LE MATIN** — `RemoveMapStatus("darkness")`, réveil progressif, héros
    déboussolé (`LookAround`), le rêve « colle » (`DizzyVeil`)
12. Le rassemblement — rangs par deux face à Penticus
13. **Les cordées** — la répartition propre au Mont Venteux
14. Les départs — cordée par cordée, par le sentier nord
15. Le chemin du nord — la remarque du partenaire
16. La scène finale — Penticus, Phileas et la porte du donjon

Appelée depuis `ArrivalCutscene` (ligne 1896). `CutsceneMode(true/false)`
apparié 4 fois sur 4 : **aucune sortie sans reprise de contrôle**. 10 `pcall`.

### Corrections structurelles déjà faites (ne pas les défaire)

- **Décor dédoublé** : `SetupGround` et la cinématique posaient chacun les mêmes
  12 paillasses et le même feu (256,220) → constructeurs uniques `BuildCampDay`,
  `BuildCampMorning`, `DeployBeds`, purge par `PurgeDecor` / `RemoveAt`
- **Paillasse dans la roche** : le lit 11 en (312,108) tombait sur `Tags ≠ 0` →
  déplacé en (384,196). Les 12 sont sur sol libre.
- **2 PNJ assis sur un lit** : Rin (lit 7) et Coco (lit 5) remontés de 16 px
- **Retour raté du donjon** : `zone/mount_windswept/init.lua` renvoyait le joueur
  silencieusement au bourg après un KO ou une fuite dans la première moitié. Il
  ramène désormais **devant l'entrée du Mont** (carte 50), avec
  `SV.Chapter5.MountLastExitReason` / `PlayTempMountScene` — miroir exact du
  patron du Tunnel. Aucun flag de progression touché.

### Points d'appui (toujours valides)

**Carte** `mount_windswept_entrance` : 552×504, musique `Canyon Camp.ogg`,
2 objets seulement (`Kangaskhan_Rock`, `Dungeon_Entrance`).

**Positions au camp** : feu `(256,220)` · Penticus `(212,244)` ·
Phileas `(300,244)` · Rin `(220,260)` · Coco `(292,260)` · Shuca `(204,312)` ·
Ganlon `(308,312)` · Kino `(160,300)` · Reinier `(360,300)` · Hyko `(292,428)` ·
Almotz `(244,428)`

**Table `BEDS`** (12 couchages, tous sur sol libre) : `(256,164) (301,175)
(334,208) (334,248) (301,281) (256,292) (211,281) (178,248) (178,208)
(211,175) (384,196) (344,132)`
Assise = `BEDS[i] + (13, 10)`.
Attribution : 1 Penticus · 2 Phileas · 3 Reinier · 4 Ganlon · 5 Shuca ·
6 partenaire · 7 héros · 8 Hyko · 9 Almotz · 10 Rin · 11 Kino · 12 Coco

---

## 15. CHANTIERS RÉELLEMENT OUVERTS (par priorité, chiffrés)

### A. Le bureau du maître de guilde aux chapitres 7-10 — **le plus gros trou**

Mesuré : `Data/Script/halcyon/ground/guild_guildmasters_room/` ne contient que
`_ch_1` à `_ch_6`.

| chapitre | lignes | boîtes | `Noctowl_Action` |
|---|---|---|---|
| 1 | 526 | 94 | non |
| 2 | 204 | 35 | non |
| 3 | 54 | 11 | non |
| 4 | 371 | 49 | non |
| 5 | 149 | 22 | **oui** |
| 6 | 255 | **2** | non |
| **7-10** | **absents** | **0** | — |

Un routeur tolérant existe (`init.lua`, `DERNIER_CHAPITRE_ECRIT = 6`) : au-delà
du ch6 il retombe sur le ch6, et si le handler manque il sert une réplique de
secours (« Il est absorbé par ses cartes… »). **Rien ne crashe, mais rien ne
vit** : c'est la pièce la plus solennelle de la guilde et elle est muette sur
4 chapitres.

**Deux sous-tâches distinctes :**
1. Créer `guild_guildmasters_room_ch_7` … `_ch_10` et monter
   `DERNIER_CHAPITRE_ECRIT` au fur et à mesure
2. **Phileas n'a de dialogue qu'au ch5** alors qu'il dit travailler dans ce
   bureau — incohérence de continuité à combler sur tous les chapitres

### B. Densité des chapitres 6 à 10

457 / 397 / 324 / 307 / 256 boîtes contre 7000 visés. C'est le poste le plus
lourd du projet, à traiter par lots thématiques plutôt que d'un bloc.

### C. `TownVoicesNight` étendu aux ch7-10

Fait pour le ch6 (361 lignes). Le patron de fiches par palier existe déjà dans
`TownVoicesLate.lua` (787 lignes, blocs `FICHES[N]`) : le réutiliser tel quel.

### D. Écart résiduel du Mont Venteux

192 boîtes contre 240 au Tunnel. Petit lot d'enrichissement possible sur les
sections 3, 8 et 13, mais **la structure est complète** — ne pas la réécrire.

### E. Points à ne PAS traiter

- Les 6 zones exclues du choix de fin de journée (Sanctum, Luminous Spring,
  Apricorn Glade, crooked_den, Crucible) : elles mènent à un ground dédié ou à
  une veillée imposée — **ne pas les brancher**
- Les 12 signalements de `audit_bugs.py` (§11)
- Les tuiles `_Night` : la conversion est colorimétrique, pas du pixel-art.
  Remplaçables un jour, sans urgence.

---

## 16. RÉSERVE PERMANENTE

**RIEN N'A JAMAIS ÉTÉ TESTÉ EN JEU.** Une trentaine de lots validés
statiquement seulement : compilation Lua, cohérence JSON, positions,
marchabilité, absence de mots interdits, cohérence des clés `.resx`.

Points les plus sensibles à surveiller au premier test :

- le collider de `Bedroom_Door` (posé sur une case de mur, bureau du maître)
- `PoseGroundAction("Faint")` fige une pose — si elle n'est pas levée, le duo
  reste couché
- `ContinueDungeon("gloomy_forest", 6..8)` pour les raids : segments ajoutés,
  jamais chargés en jeu
- le rendu des tuiles de nuit et des particules saisonnières
- **la veillée du Mont Venteux** : 16 sections enchaînées, 90 coroutines,
  4 `CutsceneMode`. C'est la scène la plus longue jamais écrite pour ce mod ;
  c'est aussi celle qui a le plus à perdre d'un `JoinCoroutines` mal apparié.
- le retour raté du Mont (`MountLastExitReason`) : jamais déclenché en jeu

---

## 17. PROMPT À COLLER EN DÉBUT DE NOUVELLE SESSION

> Reprise du mod PMDO **New Era : Abyss to Ascension** (namespace `halcyon`,
> jeu en **français**). Réponds en français.
>
> **Lis d'abord `docs/PASSATION_AGENT_ARENA.md`** — méthodologie, formats de
> fichiers décodés, casting vérifié, API attestées, pièges, chantiers ouverts.
> **Puis vérifie son §0** : l'état du dépôt y est daté, et le tag de build réel
> se lit par `grep`, pas dans le document.
>
> **Méthode exigée** : preuve avant hypothèse — vérifier dans les fichiers avant
> d'affirmer, ne jamais inventer une API (compter ses occurrences hors du fichier
> courant), prouver le format d'un JSON par round-trip avant de l'écrire, patchs
> chirurgicaux uniquement. Signaler honnêtement ses erreurs, les faux positifs de
> ses propres outils, et rappeler que rien n'est testé en jeu.
>
> **Règles non négociables** : jamais « Necrozma », « Eternatus », « l'Abîme »,
> « prison » dans un texte affiché. Ne jamais nommer les personnages des jeux
> d'origine. Répliques de 1-2 phrases, < 150 caractères hors `[pause=N]`. Toute
> table `SV` neuve déclarée dans `scriptvars.lua` **et** rattrapée dans
> `OnUpgrade`. Incrémenter le tag de build dans les 3 fichiers.
>
> **Validation avant chaque commit** : compilation Lua de tous les fichiers,
> `audit_bugs.py .` (doit rester à 12), `verify_legend.py .`,
> `verify_scene_positions.py .`, `audit_integrite.py .` (référence 925),
> `verify_ground_reachability.py .` (référence 27), `count_dialogue.py`.
>
> **Avant de déclarer une scène terminée** : ne pas se fier aux métriques
> (nombre de boîtes, d'émotions, de coroutines). Ouvrir la géométrie de la
> carte et vérifier CHAQUE coordonnée contre la grille d'obstacles — bornes,
> marchabilité **et** accessibilité par parcours en largeur. Le Mont Venteux
> avait d'excellentes métriques et une carte injouable (§14bis).
>
> **Chantier prioritaire** : le bureau du maître de guilde aux chapitres 7 à 10
> — voir §15.A.

---

*Fin de la passation. Bon travail — et exige les preuves.*
