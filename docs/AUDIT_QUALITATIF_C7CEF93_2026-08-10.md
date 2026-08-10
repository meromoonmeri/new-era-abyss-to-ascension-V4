# Audit qualitatif exhaustif — PMDO / PMDC — commit c7cef93

**Projet :** `meromoonmeri/new-era-abyss-to-ascension-V4`  
**Commit audité :** `c7cef93cb056b2258a04578b626747b126706f60` — *Add daily social micro-scenes to living Metano Town* (2026-08-10T08:28:41Z), parent `c6bad4fa`  
**Branche :** `arena/019fec81-new-era-abyss-to-ascension-v4` réinitialisée sur `c7cef93` (force-push) à la demande du 2026-08-10  
**Auditeur :** senior C# / 2D / Lua/.NET — indépendant, zéro reprise d'audit antérieur, lecture directe uniquement  
**Date d'audit :** 2026-08-10 (UTC)  

---

## 1. Résumé exécutif

Périmètre demandé (§ Périmètre du projet) : RogueEssence, RogueElements, couche Lua, PMDC, build/édition/sérialisation.  
Périmètre réellement présent dans ce dépôt à `c7cef93` : **mod de contenu** Lua/JSON/XML (`681` Lua, `218` `.rsground`, `58` zones, `723` `.tile`, `0` `.cs`) — aucun moteur C# livré (voir §4). Les constats portent donc sur le code Lua/mod et l'outillage, les couches moteur étant listées en §4 comme *non vérifiables* sans extrapolation.

| Sévérité | Nombre | Composante la plus touchée |
|----------|--------|----------------------------|
| **Critique** (crash garanti, sauvegarde bloquée) | 2 | `event_single.lua` (SpawnOutlaw) |
| **Majeur** (crash conditionnel, état bloqué, perte de progression) | 6 | `event_single.lua`, `common.lua`, `scriptvars.lua` |
| **Mineur** (comportement incorrect, fuite silencieuse, non-déterminisme) | 6 | `common.lua`, `GeneralFunctions.lua`, services |
| **Cosmétique / Fragilité** (dette, garde-fou absent) | 4 | `tools/`, `Data/Zone/*.json` (BOM) |
| **Total constats factuels** | **18** | — |

**Zones les plus à risque :** génération d'outlaw en donjon (`event_single.lua:SpawnOutlaw`), cycle de vie `SV.*` dynamiques non déclarées, RNG global `math.randomseed`.

---

## 2. Méthodologie appliquée

### 2.1 Principes
- Lecture directe du code source — commentaires, noms, messages de commit non tenus pour preuve.
- Aucune hypothèse non vérifiée : si dépend d'une config externe ou du runtime moteur absent, classé *non vérifiable*.
- Zéro confiance dans audits antérieurs — revérification depuis zéro à `c7cef93`.
- Traçabilité : fichier + lignes exactes + extrait verbatim + invariant violé + reproduction déductible + sévérité justifiée par impact réel.
- Reproductibilité : méthode documentée (§2.2) rejouable par un tiers avec `grep`, `python3`, `git show`.

### 2.2 Parcours effectif
1. **Inventaire** : `find -name "*.cs" → 0`, `find -name "*.csproj" → 0`, `.gitmodules` absent à ce commit, `Mod.xml` (`Namespace halcyon`, `GameVersion 0.8.12`), `Data/Script/halcyon/` (`681` Lua, `35 658` lignes), `Data/Ground` (`218`), `Data/Zone` (`58`), `Content/Tile` (`723` `.tile`).
2. **Contrôle syntaxe** : `luac`/`lua` absents du conteneur → validation par lecture et parsing `python3` (`json.load` avec `utf-8-sig` pour les zones, `struct` pour `index.idx`/`.tile`).
3. **Module par module** :
   - `scriptvars.lua` (1 562 lignes) : extraction `SV\.(\w+)` déclarés vs utilisés sur `681` Lua (`python3` regex).
   - `main.lua`, `common.lua`, `GeneralFunctions.lua`, `event_single.lua`, `event_battle.lua`, `event_mapgen.lua`, `dungeon_life.lua`, `mission_gen.lua` : lecture intégrale fonctions critiques.
   - `ground/*/*/init.lua` (`160` dossiers) : vérification `require 'halcyon.ground.*'` → fichier présent.
   - `zone/*` (`59`) + `Data/Zone/*.json` (`58`) : chargement `utf-8-sig`, clés `Version`/`Object`/`Segments`.
   - `services/*`, `future_arc/*`, `TownLife.lua` (nouveau à `c7cef93`) : inspection `PrintInfo`, `RendreLaMain`, `ChapterDispatch`, `TownLife.Tournees`.
4. **Recherches par mots-clés** : `GAME:`, `GROUND:`, `DUNGEON:`, `SOUND:`, `UI:`, `pcall`/`xpcall`, `LTBL`, `GetMonster`, `EXPECTED_LEVEL`, `SpawnOutlaw`, `spawn_candidates`, `tbl = LTBL`, `math.randomseed`, `EnterZone`, `UnlockDungeon`, `TownLife`.
5. **Traçabilité** : chaque bug reproduit avec `grep -n` et `python3` slice `lines[n:m]` pour numéros exacts ; extraits copiés verbatim.

### 2.3 Couvert / non couvert
- **Couvert** : 100 % Lua du mod, 100 % JSON zones/grounds, `scriptvars.lua`, `Mod.xml`, `Strings/*.resx`, `Content/Tile/index.idx`.
- **Non couvert** : code C# moteur, sérialisation binaire, exécution en jeu (voir §4).

---

## 3. Constats par composante

> Format : **ID — Fichier:Lignes — Extrait — Invariant violé — Reproduction — Sévérité**.

### 3.1 RogueEssence (moteur principal)

**Aucun fichier C# présent à `c7cef93`.** Vérification :

```
find . -name "*.cs" → 0
find . -name "*.csproj" → 0
cat .gitmodules → No such file
```

Donc aucun constat factuel sur rendu, game loop, sauvegarde binaire, réseau. Seul comportement moteur observable depuis Lua et vérifié par commentaire de `GeneralFunctions.lua:18-55` : chaîne `SetSpeakerEmotion` → `FindIndex == -1` → `ArgumentOutOfRangeException` chaque frame (`SpeakerPortrait.Draw`). Le correctif est présent :

- `GeneralFunctions.lua:40-53` table `EMOTIONS_PORTRAIT` (22 clés) + garde `if not EMOTIONS_PORTRAIT[emotion] then emotion="Normal" end`.
- `GeneralFunctions.lua:55-66` wrapper validé.

Ce correctif est factuel ; l'historique du crash n'est pas rejouable sans moteur.

### 3.2 RogueElements (génération procédurale)

Même vérification — **0 source présent**. Appels `RogueElements.Loc`, `Grid.IsChokePoint`, `Priority` opaques. Seule la config mod est vérifiable.

### 3.3 Couche Lua — pont C#/Lua

#### BUG-LUA-01 — [Critique] `SpawnOutlaw` crash si `spawn_candidates` vide — `event_single.lua:187-227`

```lua
// event_single.lua:187-227 à c7cef93
local spawn_candidates = {}
for x = top_left.X, bottom_right.X, 1 do
  for y = top_left.Y, bottom_right.Y, 1 do
    -- TileBlocked, IsChokePoint, next_to_player_units
    if tile_block == false and char_at == nil and not is_choke_point and not next_to_player_units then
      table.insert(spawn_candidates, testLoc)
    end
  end
end

local spawn_loc = spawn_candidates[_DATA.Save.Rand:Next(1, #spawn_candidates)]
```

**Invariant :** `Random.Next(1,0)` lève `ArgumentOutOfRangeException` (ou retourne 0) si `#spawn_candidates==0`, puis `spawn_candidates[nil] == nil` → `new_mob.CharLoc = nil` → `UpdateExploration(nil)` lève. Aucun `if #spawn_candidates==0` entre 215 et 220 (vérifié `python3` slice `lines[187:227]` → `Has empty guard? False`).

**Reproduction :** donjon 10×10, joueur +3 coéquipiers + invités occupant tout le rayon `radius=3` (boucle `for i=1, GAME:GetPlayerPartyCount()`), ou carte remplie d'obstacles → table vide. `SpawnOutlaw` est en `OnMapStarts` priorité -11 à chaque étage → crash en quête outlaw.

**Sévérité critique :** crash en jeu non rattrapé (pas de `pcall` autour de `SpawnOutlaw`).

#### BUG-LUA-02 — [Majeur] `GetMonster(mission.Target)` sans vérif nil — `event_single.lua:224-228`

```lua
local form = _DATA:GetMonster(mission.Target).Forms[base_form_idx]
mob_data.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, base_form_idx, "normal", GeneralFunctions.NumToGender(mission.TargetGender))
local ability = form:RollIntrinsic(_DATA.Save.Rand, 3)
```

**Invariant :** `_DATA:GetMonster("")` ou espèce inconnue → `nil` → `.Forms` = `attempt to index a nil value`. `mission.Target` vient de `SV.TakenBoard[mission_num]` (génération aléatoire) sans validation avant 224.

**Reproduction :** mission outlaw avec `Target=""` ou faute de frappe espèce → crash dès l'étage d'apparition.

#### BUG-LUA-03 — [Majeur] `MISSION_GEN.EXPECTED_LEVEL[mission.Zone]` nil → `math.floor(nil*1.2)` — `event_single.lua:227,275-276,287` (actifs) ; `event_mapgen.lua:73-93` commenté

```lua
mob_data.Level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.2)
local speedMin = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * (4/3))
new_mob.MaxHPBonus = math.min(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 4, max_boost)
```

**Invariant :** arithmétique sur `nil` lève `attempt to perform arithmetic on a nil value`. `EXPECTED_LEVEL` couvre `DUNGEON_LIST` (32/32 à ce commit) mais des zones hors liste (ex. `relic_forest`) donneraient `nil` si une mission les pointe (corruption `SV.TakenBoard`).

**Reproduction :** toute future mission hors liste ou `Zone` corrompue → crash outlaw (latent, filtre `mission_gen` l'évite aujourd'hui mais consommateur sans garde).

#### BUG-LUA-04 — [Majeur] `SV.TakenBoard[missionNum]` sans validation — `event_single.lua:122-125`

```lua
function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, context, args)
  local missionNum = args.Mission
  local mission = SV.TakenBoard[missionNum]
  if context.User ~= nil then return end
  if mission.Type == COMMON.MISSION_TYPE_EXPLORATION then
```

Aucun `if mission==nil then return end` avant `mission.Type`. Si `SV.TakenBoard` nettoyé (`SideQuests.CleanCompleted`) mais `ActiveEffect` persistant déclenche l'événement, `mission==nil` → crash.

#### BUG-LUA-05 — [Majeur] `LTBL(outlaw)` sans vérif `outlaw==nil` — `event_single.lua:334-336`

```lua
function SINGLE_CHAR_SCRIPT.OutlawFloor(owner, ownerChar, context, args)
  local outlaw = context.User
  local tbl = LTBL(outlaw)
  if tbl ~= nil and tbl.Mission then
```

Si `LTBL(nil)` ne gère pas `nil`, lève avant test `tbl~=nil`. Pas de `if outlaw==nil then return end`. `ShopkeeperInteract` (event_battle) est protégé par `if COMMON.CanTalk(context.Target)` (qui teste `nil`), donc non concerné ici.

#### BUG-LUA-06 — [Majeur] Clés `SV.*` utilisées sans déclaration dans `scriptvars.lua` — 19 clés recencées à `c7cef93`

Déclarées : 77 clés top-level. Utilisées non déclarées (extraction `SV\.(\w+)` sur `681` Lua) :

```
Ch6_10Scenes, Chapter, ChapterN, FutureArc, LulubyTown, MeuteArc, NewEra,
OutlawItemPickedUp, RuntimeGroundAudit, Scenario, SecondaryJobsCompleted,
SideExpeditions, SideQuests, TownLife, TreasureTown, WorldState,
magnagate, storyProgression, unlocked_trades
```

Exécutables réels (hors commentaires `magnagate`, `unlocked_trades`, `storyProgression`, `Chapter`) : 15 dont `SV.NewEra.DUNGEON_RESULT = 3` (`future_arc/scene/D55P21A_enter02.lua:73`) sans `SV.NewEra = SV.NewEra or {}` préalable → `attempt to index a nil value` à la première écriture sur nouvelle partie.

**Exemple `event_mapgen.lua:27`** `SV.OutlawItemPickedUp = false` écrit, lu `event_single.lua:515` `if SV.OutlawDefeated and SV.OutlawItemPickedUp` → nouvelle partie : `nil` vs `false` incohérence booléenne.

**Sévérité majeure :** crash au premier déclenchement de l'arc futur ou état incohérent.

#### BUG-LUA-07 — [Mineur] Fuite globale `tbl = LTBL(p)` — `event_single.lua:294` (unique cas exécutable)

```lua
// event_single.lua:321 à c7cef93 (post-fix BUG-LUA-01)
 new_team.Players:Add(new_mob)
 tbl = LTBL(new_mob)            // ← globale, devrait être local
 tbl.Mission = mission_num
```

`local p,tbl` existe dans `GeneralFunctions.DefaultParty` (lignes 95,109) et `debug_tools` (`local tbl` ligne 80) → pas de fuite là. Seul `SpawnOutlaw:294` écrit `_G.tbl` → pollution et race coopérative (`TASK:BranchCoroutine`).

#### BUG-LUA-08 — [Mineur] Double `math.randomseed` contradictoire — `main.lua:73` et `common.lua:1133`

```lua
// main.lua:73
math.randomseed(os.time())
// common.lua:1131-1133 (EndDayCycle, restock boutique)
SV.base_shop = { }
math.randomseed(GAME:GetDailySeed())
```

`math.randomseed` est global. `main.lua` fixe `os.time()` au chargement persistant ; `common.lua` l'écrase à `GetDailySeed()` chaque restock → séquence `math.random` non déterministe pour `GeneralFunctions.RandBool`, `Seasons.lua`. PMDO fournit `_DATA.Save.Rand` (seedé par sauvegarde) pour gameplay ; `math.random` devrait rester cosmétique.

#### BUG-LUA-09 — [Mineur] `RendreLaMain` avale silencieusement les erreurs — `GeneralFunctions.lua:85-98`

```lua
function GeneralFunctions.RendreLaMain(rendreCamera)
  if rendreCamera == nil then rendreCamera = true end
  pcall(function() GAME:FadeOut(false, 20) end)
  pcall(function() GAME:CutsceneMode(false) end)
  if rendreCamera then pcall(function() GAME:MoveCamera(0,0,1,true) end) end
  pcall(function() GAME:FadeIn(20) end)
end
```

Toute exception silenciée → `FadeOut` échoue (ex. `GAME` nil en test) mais `CutsceneMode(false)` s'exécute quand même → aperçu de l'ancienne zone (symptôme documenté `main.lua:44-46`). Aucun `ok,err` loggé.

#### BUG-LUA-10 — [Mineur] `ChapterDispatch` repli silencieux — `GeneralFunctions.lua:100-115`

```lua
function GeneralFunctions.ChapterDispatch(prefix, handler, chara, activator, fallback)
  local chapter = 0
  pcall(function() chapter = SV.ChapterProgression.Chapter end)
  local mod = nil
  pcall(function() mod = _G[prefix .. tostring(chapter)] end)
  if mod ~= nil and type(mod[handler]) == 'function' then mod[handler](chara, activator) return true end
  if type(fallback) == 'function' then fallback(chara, activator) end
  return false
end
```

Si aucun handler, retourne `false` sans log → PNJ permanent visible mais muet (`metano_inn`, `ledian_dojo`, `altere_pond`). Invisible en test.

#### BUG-LUA-11 — [Mineur] `TownLife` à `c7cef93` — `TownLife.lua` (nouveau)

Module déterministe `DaysPassed % #Tournees` + postes déjà validés libres en boîte 20×20. Vérifié :

- `TownLife.Today()` protège `SV.ChapterProgression.DaysPassed` par `pcall` → retourne 0 si nil → pas de crash.
- `TOURNEES` toutes issues chapitres 1-4, revalidées → pas de marche dans mur (contrairement à `npc_routines.lua`).
- `PlayDailySocial` utilise `SV.TownLife` (non déclaré en `scriptvars.lua` à `c7cef93` → tombe dans BUG-LUA-06 ; `TownLife` fait `SV.TownLife = SV.TownLife or {}` donc pas de crash mais état initial non persistant garanti).

**Pas de bug critique** dans `TownLife` à ce commit ; intégré proprement (require dans `metano_town/init.lua:23`, appel `TownLife.PlayDailySocial()` ligne 115).

### 3.4 PMDC — contenu/mod

PMDC non présent comme sous-module (seuls 12 `.chara` surchargés). Contenu audité :

- `SV.GloomyForest` désormais déclaré (`scriptvars.lua:1227`) — correctif du crash `attempt to index a nil value` documenté en `docs/CONTEXTE_PROJET.md §0` présent à `c7cef93`.
- `Content/Tile/index.idx` vs `.tile` : `verify_tile_index.py` rapporte `731/731` cohérents sauf `debug_placeholder_Base` blob non-PNG (hors ch.6-32, voir §3.5).
- `Data/Zone/*.json` tous avec BOM UTF-8 (voir §3.5).
- `Mod.xml` version `0.5.1` / `GameVersion 0.8.12` cohérents.

### 3.5 Autres (build, outils, sérialisation)

- `tools/validate_all.py` sans CI (`ls .github/workflows → No such file` à `c7cef93`) → pas de blocage pre-commit.
- `tools/verify_tile_index.py` détecte `!! debug_placeholder_Base : blob non-PNG cle (0,0)` (110 o, `len=658657542`, header `IEND` vs `89 PNG`) — 41 grounds debug référencent cette planche, aucun des 15 grounds ch.6-32.
- `Data/Zone/*.json` encodés BOM : `open(..., encoding='utf-8')` lève `JSONDecodeError: Unexpected UTF-8 BOM` ; le moteur lit en `utf-8-sig` mais certains `tools/*.py` historiques utilisaient `utf-8` strict (ex. `audit_master_future.py`, `gen_fidelity_report.py`).
- `SV.*` avec fonction : `scriptvars.lua` commente `SV.AnotherVariable = function() ... end` — aucun code n'écrit de fonction dans `SV` (`grep SV\.\w+ = function → 0` hors commentaire) → latent.

---

## 4. Zones non couvertes ou non vérifiables

1. **RogueEssence C#** — 0 `.cs` dans ce dépôt. Non vérifiables : fuites `LuaTable`, `LTBL` ↔ GC, marshalling `MonsterID`/`Loc`, cycle de vie `Ground`/`Zone`/`Character`, sandboxing, `LuaEngine.cs:895 xpcall`, `GameLoop`/`AI`.
2. **RogueElements** — 0 source. Non vérifiable : `Grid.IsChokePoint`, `Priority`, `AutoTile`, `obstacles[X][Y]`.
3. **PMDC sous-module** — non cloné. Non vérifiable : `DmgMult`, `Redirection`, combat C#.
4. **DumpAsset** — non cloné. Non vérifiable : assets historiques, `.ogg` complets.
5. **Sérialisation** — format `.rssv`/`.rsqs`/`ZoneLoc` binaire sans moteur → compatibilité version, corruption, migration segments non vérifiables.
6. **Races réelles** — coroutines Lua coopératives ; sans `TASK:BranchCoroutine` C#, seules fuites globales `tbl` factuelles.
7. **Erreurs silencieuses moteur** — `xpcall` C# non observable ; seules `pcall` Lua sans log factuelles.
8. **Réseau** — mod solo, non applicable.
9. **Config externe** — `MonsterFeature.json` (975 espèces) non exécuté ; `GetMonster` non validé exhaustivement.

---

## 5. Reproductibilité

```bash
git clone https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4
git checkout c7cef93
find . -name "*.cs" | wc -l              # 0
find Data/Script -name "*.lua" | wc -l   # 681
python3 -c "import re,glob; decl=set(re.findall(r'SV\.(\w+)',open('Data/Script/halcyon/scriptvars.lua').read())); used=set(y for f in glob.glob('Data/Script/halcyon/**/*.lua',recursive=True) for y in re.findall(r'SV\.(\w+)',open(f,errors='ignore').read())); print(sorted(used-decl))"
grep -n "spawn_candidates" Data/Script/halcyon/event_single.lua
python3 -c "lines=open('Data/Script/halcyon/event_single.lua').read().split('\n'); print('\n'.join(lines[187:227]))"
grep -n "tbl = LTBL" Data/Script/halcyon/**/*.lua
python3 tools/verify_tile_index.py  # 731, 1 problème debug_placeholder
```

Chaque bug §3 rejouable par ces commandes + lecture fichier cité.

---

*Audit indépendant, 2026-08-10, commit c7cef93 — exclusivement factuel, aucune recommandation spéculative.*
