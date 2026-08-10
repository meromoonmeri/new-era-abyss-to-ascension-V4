# Audit qualitatif exhaustif — Projet PMDO/PMDC « New Era: Abyss to Ascension »

**Auditeur** : Agent indépendant (lecture intégrale du code source, zéro confiance dans les audits antérieurs)
**Date** : 2026-08-10
**Version du dépôt** : commit `a0b8b8a7` (branche `arena/019fec7e-new-era-abyss-to-ascension-v4`)
**Version du mod** : 0.5.1 (GameVersion 0.8.12, namespace `halcyon`)

---

## 1. Résumé exécutif

| Sévérité  | Nombre | Description courte |
|-----------|--------|-------------------|
| Critique  | 2      | Filtrage de dialogues mort (code mort) ; dereférencement nil sans garde sur table de personnalité |
| Majeur    | 4      | Crash sur pool vide (math.random) ; RNG non-déterministe en contexte donjon ; fuite de variable globale ; mutation d'état global statique sans synchronisation |
| Mineur    | 3      | Paramètre mort ; définition de fonction redondante ; graine RNG non-reproductible au démarrage |
| **Total** | **9**  | |

**Composante la plus à risque** : `Data/Script/halcyon/common.lua` — concentre 4 des 9 bugs trouvés, dont les 2 critiques.

---

## 2. Méthodologie appliquée

### 2.1 Ce qui a été couvert

| Composante | Couverture | Méthode |
|---|---|---|
| `Data/Script/halcyon/` (scripts Lua du mod) | **Exhaustive** | Lecture intégrale des fichiers cœur : `main.lua`, `common.lua`, `scriptvars.lua`, `config.lua`, `GeneralFunctions.lua`, `event.lua`, `event_battle.lua`, `event_single.lua`, `event_misc.lua`, `event_mapgen.lua`, `dungeon_life.lua`, `mission_gen.lua`, `npc_routines.lua`, `Weather.lua`, `DonjonFX.lua`, `LegendZones.lua`, `BossFX.lua` |
| `Data/Script/halcyon/services/` | **Exhaustive** | Lecture des 6 services : `nre_probe`, `ground_gameplay_validator`, `debug_tools`, `menu_tools`, `config_tools`, `upgrade_tools` |
| `RESERVE/scripts_ground/` (189 scripts) | **Échantillonnée** | Inspection structurelle de tous les scripts ; lecture approfondie de 5 représentatifs (`abime_tempetes`, `antre_cascade_dehors`, `antre_cascade_porte`, `antre_dragon`, `antre_occident`) |
| `RESERVE/scripts_zone/` | **Échantillonnée** | Inspection structurelle ; lecture de 3 scripts représentatifs |
| `Data/Script/halcyon/zone/` (~60 zones) | **Échantillonnée** | Lecture de `searing_tunnel/init.lua`, vérification structurelle de tous les appels à `ExitDungeonMissionCheck` |
| `Data/Script/halcyon/ground/` (~150 grounds) | **Échantillonnée** | Inspection des fichiers `init.lua` et scripts par chapitre |
| `Data/Script/halcyon/ai/` | **Partielle** | Lecture de `ground_talking.lua` |
| Données JSON (`Data/AI/`, `Data/Zone/`) | **Non couverte** | Format de données, pas de logique exécutable |

### 2.2 Ce qui n'a PAS été couvert (explicite)

| Composante | Raison |
|---|---|
| **RogueEssence (moteur C#)** | Absent du dépôt. Zéro fichier .cs, .csproj ou .sln. |
| **RogueElement (bibliothèque C#)** | Absent du dépôt. |
| **Bindings Lua côté C#** (LuaEngine.cs, ScriptUI.cs, etc.) | Absents du dépôt. Les commentaires du code Lua y font référence (ex. « LuaEngine.cs:895 ») mais les sources ne sont pas auditable. |
| **PMDC.Dungeon (assembly C#)** | Absent du dépôt. Les imports `luanet.import_type('PMDC.Dungeon.Redirected')` montrent que PMDC est une dépendance externe. |
| **Build system / outils d'édition** | Non couvert : les outils `tools/` sont des scripts Python de génération de cartes, pas de la chaîne d'exécution. |

---

## 3. Constats par composante

### 3.1 Composante principale : `Data/Script/halcyon/common.lua`

---

#### Bug #1 — CRITIQUE : Filtrage de dialogues mort dans `COMMON.GroundInteract`

**Fichier** : `Data/Script/halcyon/common.lua`
**Lignes** : 912–948 (fonction entière)

**Extrait du code concerné** :
```lua
function COMMON.GroundInteract(chara, target)
  -- ...
  local running_pool = {table.unpack(pool)}
  local valid_quote = false
  local chosen_quote = ""

  while not valid_quote and #running_pool > 0 do
    valid_quote = true                                          -- ligne ~929
    local chosen_idx = math.random(1, #running_pool)
    local chosen_pool_idx = running_pool[chosen_idx]
    chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[hero%]", chara:GetDisplayName())

    if not valid_quote then                                     -- ligne ~937 : TOUJOURS FAUX
      table.remove(running_pool, chosen_idx)
      chosen_quote = ""
    end
  end

  UI:WaitShowDialogue(chosen_quote)
end
```

**Explication factuelle** : La variable `valid_quote` est mise à `true` à la ligne ~929, immédiatement avant le test `if not valid_quote` à la ligne ~937. Ce test est donc **toujours faux** : le code de rejet (suppression du quote invalide du pool) n'est jamais exécuté. La boucle `while` s'arrête à la première itération quelle que soit la validité du quote choisi.

**Conséquence** : Les PNJ en contexte ground (hors donjon) affichent des répliques contenant des placeholders non substitués (ex. `[kind]`, `[item]`, `[move]`) au lieu de les filtrer et de choisir une réplique alternative.

**Contraste avec la version donjon** : La fonction `COMMON.DungeonInteract` (même fichier, ligne 669) et `BATTLE_SCRIPT.DungeonInteract` dans `event_battle.lua` (ligne ~296) contiennent le même pattern de boucle `while not valid_quote` mais avec du code de filtrage **actif** (`valid_quote = false` dans les branches d'échec). Ces versions fonctionnent correctement.

**Conditions de reproduction** : Parler à un PNJ allié en contexte ground dont le pool de répliques WAIT contient des placeholders conditionnels (`[move]`, `[kind]`, `[item]`).

**Méthode de découverte** : Comparaison ligne-à-ligne entre les deux variantes de la fonction d'interaction (donjon vs ground).

---

#### Bug #2 — CRITIQUE : Déréférencement nil sans garde sur `personality_group`

**Fichier** : `Data/Script/halcyon/common.lua`
**Lignes** : 920–922

**Extrait du code concerné** :
```lua
  local personality = form:GetPersonalityType(target.Data.Discriminator)

  local personality_group = COMMON.PERSONALITY[personality]
  local pool = personality_group.WAIT          -- CRASH si personality_group == nil
```

**Explication factuelle** : `COMMON.PERSONALITY[personality]` retourne `nil` si l'identifiant de personnalité retourné par `GetPersonalityType` ne correspond à aucune clé du tableau `COMMON.PERSONALITY` (clés définies : 50–66, 300–322). L'accès `.WAIT` sur `nil` lève : `attempt to index a nil value (global 'personality_group')`.

**Contraste avec la version donjon** : `COMMON.DungeonInteract` (ligne 685) contient explicitement la garde :
```lua
    local personality_group = COMMON.PERSONALITY[personality]
    if personality_group ~= nil then           -- GARDE PRÉSENTE ICI
```
`COMMON.GroundInteract` omet cette garde.

**Conditions de reproduction** : Un PNJ allié en ground avec un `Discriminator` produisant un `personality` non listé dans `COMMON.PERSONALITY` (ex. un PNJ recruté dynamiquement, un NPC de mission avec une personnalité non couverte).

**Méthode de découverte** : Comparaison des gardes nil entre les deux variantes de la fonction d'interaction.

---

#### Bug #3 — MAJEUR : Crash `math.random(1, 0)` sur pool vide dans `COMMON.DungeonInteract`

**Fichier** : `Data/Script/halcyon/common.lua`
**Ligne** : ~796

**Extrait du code concerné** :
```lua
    -- Après le filtrage, running_pool peut être vide si tous les quotes ont été rejetés
    local chosen_idx = math.random(1, #running_pool)   -- CRASH si #running_pool == 0
    local chosen_quote = running_pool[chosen_idx]
```

**Explication factuelle** : Si tous les quotes du pool sont invalides (contenant des placeholders `[move]`, `[kind]`, `[item]` non résolus et aucune alternative valide n'existe), `running_pool` est vidé par la boucle de filtrage. L'appel `math.random(1, 0)` lève en Lua standard : `bad argument #2 to 'random' (interval is empty)`.

**Conditions de reproduction** : Un PNJ allié en donjon dont le pool de répliques (FULL/HALF/PINCH) contient exclusivement des quotes avec des placeholders non résolables (ex. `[move]` pour un Pokémon sans attaque, `[kind]` en contexte où `TeamSpawns.CanPick == false`).

**Méthode de découverte** : Analyse du chemin d'exécution après la boucle de filtrage.

---

### 3.2 Composante : `Data/Script/halcyon/event_battle.lua`

---

#### Bug #4 — MAJEUR : RNG non-déterministe (`math.random`) en contexte de combat donjon

**Fichier** : `Data/Script/halcyon/event_battle.lua`
**Lignes** : 342, 399, 411

**Extraits du code concerné** :
```lua
-- Ligne 342 (BATTLE_SCRIPT.DungeonInteract) :
local chosen_idx = math.random(1, #running_pool)

-- Ligne 399 (substitution placeholder [move]) :
local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])

-- Ligne 411 (substitution placeholder [kind]) :
local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
```

**Explication factuelle** : `math.random` utilise le RNG standard de Lua, initialisé par `math.randomseed(os.time())` dans `main.lua:73`. Ce RNG n'est **pas** enregistré par le système de replay/quicksave du moteur. Le code commenté à la ligne 1155–1156 du même fichier le documente explicitement :
```
-- Fix audit 2026-07-27 : RNG deterministe (GAME.Rand) au lieu de math.random.
-- math.random n'est PAS enregistre par le systeme de replay/quicksave :
-- au rechargement, l'objet donne differait -> desynchronisation d'inventaire
```

Le correctif a été appliqué dans `BATTLE_SCRIPT.AnnexePolissage` (ligne 1155+) qui utilise désormais `GAME.Rand:Next(0, #finds) + 1`, mais **pas** dans `BATTLE_SCRIPT.DungeonInteract` (lignes 342, 399, 411) ni dans `COMMON.DungeonInteract` (ligne ~796).

**Conséquence** : Lors d'un replay ou d'un rechargement de sauvegarde, les dialogues de PNJ en donjon peuvent afficher des répliques différentes de celles de la session originale. Si un de ces dialogues est suivi d'un choix d'UI, la désynchronisation avec le replay peut provoquer un crash « Recorded action failed ».

**Conditions de reproduction** : Parler à un PNJ allié en donjon avec des placeholders dans les répliques, puis recharger une sauvegarde.

**Méthode de découverte** : Recherche textuelle de `math.random` dans les fichiers de contexte donjon (`event_battle.lua`, `common.lua`), comparaison avec le pattern corrigé (`GAME.Rand`).

---

#### Bug #5 — MAJEUR : Fuite de variable globale `result` dans `BATTLE_SCRIPT.ShopkeeperInteract`

**Fichier** : `Data/Script/halcyon/event_battle.lua`
**Lignes** : 24, 43

**Extrait du code concerné** :
```lua
function BATTLE_SCRIPT.ShopkeeperInteract(owner, ownerChar, context, args)
  -- ...
  if sell_price > 0 then
    -- ...
    UI:WaitForChoice()
    result = UI:ChoiceResult()          -- ligne 24 : PAS de 'local'

    if SV.adventure.Thief then
      COMMON.ThiefReturn()
    elseif result then
      -- ...
    end
  end

  if price > 0 then
    -- ...
    UI:WaitForChoice()
    result = UI:ChoiceResult()          -- ligne 43 : PAS de 'local'
    -- ...
  end
```

**Explication factuelle** : Les deux affectations `result = UI:ChoiceResult()` omettent le mot-clé `local`. En Lua, une variable sans `local` est **globale** : elle persiste dans `_G` entre les appels de fonction et entre les sessions.

**Conséquence** :
1. La valeur de `result` de la première interaction (vente) reste accessible comme globale et peut être lue par n'importe quel autre code Lua du mod qui référencerait `result` sans `local`.
2. Si `sell_price > 0` mais que le code n'atteint jamais la ligne 24 (ex. `SV.adventure.Thief` est vrai et `COMMON.ThiefReturn()` lève une erreur sous xpcall), la variable globale `result` conserve sa valeur d'un appel précédent, ce qui peut fausser le branchement `elseif result then` de la section d'achat.

**Conditions de reproduction** : Interagir avec un Kecleon en donjon après avoir volé, avec `sell_price > 0` et `price > 0`.

**Méthode de découverte** : Recherche textuelle d'affectations sans `local` dans les callbacks de combat.

---

### 3.3 Composante : `Data/Script/halcyon/common.lua` (suite)

---

#### Bug #6 — MAJEUR : Mutation globale de `MAX_TEAM_SLOTS` sans restauration garantie

**Fichier** : `Data/Script/halcyon/common.lua`
**Lignes** : 991, 1074

**Extraits du code concerné** :
```lua
-- Ligne 991 (EnterDungeonMissionCheck) :
RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 3

-- Ligne 1074 (ExitDungeonMissionCheck) :
RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4
```

**Explication factuelle** : `ExplorerTeam.MAX_TEAM_SLOTS` est un champ statique sur une classe .NET (`RogueEssence.Dungeon.ExplorerTeam`). La modification à la ligne 991 affecte **toutes les instances** de `ExplorerTeam` dans le processus, y compris celles d'autres zones ou d'autres sessions de jeu. La restauration à 4 (ligne 1074) n'est exécutée que si `ExitDungeonMissionCheck` est appelé avec `rescue == true` ET qu'une mission d'escort est trouvée.

Si le joueur entre en donjon avec un escort (MAX_TEAM_SLOTS = 3), puis meurt/quitte sans passer par le chemin de sortie normal (ex. via `GAME:EndDungeonRun` direct, ou via un script de zone qui court-circuite `ExitDungeonMissionCheck`), la valeur reste à 3 pour toute la session.

**Autres points de mutation** : `event_battle.lua:287` et `event_single.lua:146, 581` remettent à 4, mais uniquement dans des chemins d'exécution spécifiques (retrait d'escort, team assembly).

**Conditions de reproduction** : Entrer en donjon avec une mission d'escort, puis mourir en déclenchant un chemin de sortie alternatif qui ne passe pas par `ExitDungeonMissionCheck`.

**Méthode de découverte** : Recherche textuelle de `MAX_TEAM_SLOTS` dans l'ensemble du dépôt.

---

### 3.4 Composante : `Data/Script/halcyon/event_single.lua`

---

#### Bug #7 — MINEUR : Définition de fonction redondante `SINGLE_CHAR_SCRIPT.CheckOngoingMissions`

**Fichier** : `Data/Script/halcyon/event_single.lua`
**Lignes** : 1533 et 1554

**Extrait du code concerné** :
```lua
-- Première définition (ligne 1533) :
function SINGLE_CHAR_SCRIPT.CheckOngoingMissions(owner, ownerChar, context, args)
    -- ... boucle avec UI:WaitShowDialogue à l'intérieur
    -- ... demande au joueur pour CHAQUE mission trouvée
end

-- Deuxième définition (ligne 1554) — REMPLACE la première :
function SINGLE_CHAR_SCRIPT.CheckOngoingMissions(owner, ownerChar, context, args)
    -- ... vérifie toutes les missions d'abord (has_ongoing_mission)
    -- ... ne demande qu'une fois au joueur
    -- ... gère aussi le cas Rescue
end
```

**Explication factuelle** : La première définition est intégralement remplacée par la seconde (en Lua, une nouvelle affectation de fonction écrase la précédente). La seconde version est correcte : elle agrège d'abord, puis demande. La première version avait un défaut logique (demande dans la boucle = multiples dialogues).

**Impact** : Aucun bug runtime — la seconde définition est correcte. Mais la présence de la première (code mort) complique la maintenance et peut induire en erreur un lecteur qui ne lit que les premières lignes.

**Méthode de découverte** : Recherche de définitions de fonctions dupliquées.

---

### 3.5 Composante : `Data/Script/halcyon/common.lua` + `Data/Script/halcyon/main.lua`

---

#### Bug #8 — MINEUR : Paramètre mort dans `COMMON.EndRescue`

**Fichier** : `Data/Script/halcyon/common.lua`
**Lignes** : 1017–1029 et 1107

**Extrait du code concerné** :
```lua
-- Appel (ligne 1107) :
COMMON.EndRescue(zone, result, rescue, segmentID)
-- Note : le paramètre s'appelle 'zone' mais contient un zoneId (string)

-- Définition (ligne 1017) :
function COMMON.EndRescue(zone, result, rescue, segmentID)
  COMMON.EndDayCycle()
  local zoneId = 'master_zone'      -- HARDCODED, le paramètre 'zone' n'est jamais lu
  local structureId = -1
  local mapId = 21
  local entryId = 2
  GAME:EndDungeonRun(result, zoneId, structureId, mapId, entryId, true, true)
  SV.General.Rescue = result
  GAME:EnterZone(zoneId, structureId, mapId, entryId)
end
```

**Explication factuelle** : Le premier paramètre `zone` est reçu mais jamais utilisé. La destination est codée en dur (`'master_zone', -1, 21, 2`). Si l'intention était de renvoyer le joueur dans une zone dynamique (par exemple la zone d'origine), ce code ne le fait pas.

**Impact** : Comportement fonctionnel correct pour le cas d'usage actuel (toutes les rescues renvoient au même bureau de poste), mais le paramètre mort suggère une intention non réalisée ou un refactoring incomplet.

**Méthode de découverte** : Lecture du chemin d'exécution de la fonction rescue.

---

#### Bug #9 — MINEUR : Initialisation RNG non-reproductible au démarrage

**Fichier** : `Data/Script/halcyon/main.lua`
**Ligne** : 73

**Extrait du code concerné** :
```lua
math.randomseed(os.time())
```

**Explication factuelle** : `os.time()` retourne le nombre de secondes depuis l'epoch, ce qui rend le seed différent à chaque lancement. Cela affecte tous les appels à `math.random` qui ne sont pas re-initialisés avec `GAME:GetDailySeed()` (seul `COMMON.EndDayCycle()` à `common.lua:1133` le fait).

Entre le lancement du jeu et le premier `EndDayCycle()`, tous les appels `math.random` (ex. `GeneralFunctions.RandBool()` ligne 250, les `LookAround` / `ShakeHead` aléatoires) sont non-déterministes.

**Impact** : Limité car `math.random` dans ces contextes ne produit pas d'effet de gameplay persistant (animations, orientations de regard). Le vrai risque est documenté dans le bug #4 (dialogues de PNJ en donjon).

**Méthode de découverte** : Lecture séquentielle de `main.lua`.

---

## 4. Zones non couvertes ou non vérifiables

| Zone | Statut | Justification |
|---|---|---|
| RogueEssence (moteur C#) | **Non vérifiable** | Sources absentes du dépôt. Les commentaires Lua référencent des fichiers (LuaEngine.cs, ScriptUI.cs, PortraitSheet.cs, DSceneZone.cs, etc.) mais sans les sources, les comportements moteur décrits ne peuvent pas être vérifiés par lecture directe. |
| RogueElement (bibliothèque C#) | **Non vérifiable** | Sources absentes du dépôt. |
| PMDC.Dungeon (assembly C#) | **Non vérifiable** | Sources absentes. Les types importés via `luanet.import_type` (ex. `PMDC.Dungeon.Redirected`, `PMDC.Dungeon.DmgMult`, `PMDC.Dungeon.PreTypeEvent`) ne peuvent pas être audités. |
| RogueEssence serialization | **Non vérifiable** | Le format de sauvegarde (.rsqs, .rssv) et sa gestion de version ne peuvent pas être audités sans les sources du moteur. |
| Réseau / multijoueur | **Non vérifiable** | Aucun code réseau identifiable dans le dépôt. Si le moteur gère du multijoueur, son code est externe. |
| `RESERVE/scripts_ground/` et `RESERVE/scripts_zone/` | **Couverture échantillonnée** | 189 scripts ground + de nombreux scripts zone. Inspection structurelle complète, mais lecture approfondie limitée à 5–8 fichiers représentatifs. |
| Scripts AI (`Data/Script/halcyon/ai/`) | **Couverture partielle** | Seul `ground_talking.lua` a été lu en détail. |
| Fichiers de données (JSON) | **Non couverts** | `Data/Zone/*.json`, `Data/Item/*.json`, `Data/Monster/*.json` — fichiers de configuration, pas de logique exécutable auditable. |
| Scripts dans `Data/Script/halcyon/ground/` | **Couverture échantillonnée** | ~150 grounds. Vérification structurelle complète, lecture approfondie limitée aux grounds critiques (boss, cinématiques, transitions de zone). |

---

## 5. Incertitudes déclarées

1. Le comportement exact de `GAME.Rand` vs `math.random` dans le système de replay est documenté par les commentaires du code Lua (ligne 1155–1156 de `event_battle.lua`), mais n'a pas été vérifié dans les sources du moteur (absentes). L'affirmation selon laquelle `math.random` n'est pas enregistré par le replay repose sur cette documentation interne au code Lua.

2. L'affirmation selon laquelle le moteur enveloppe les callbacks Lua dans un `xpcall` (mentionné dans `main.lua:895` comme « LuaEngine.cs:895 ») repose sur le commentaire du code Lua. Le mécanisme exact de gestion d'erreur n'a pas été vérifié dans les sources C#.

3. Le comportement de `ExplorerTeam.MAX_TEAM_SLOTS` comme champ statique partagé entre instances est déduit de l'utilisation `RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS` (accès via la classe, pas une instance). La sémantique exacte (statique vs instance) n'a pas été vérifiée dans les sources C#.

4. Les scripts de la `RESERVE/` sont marqués comme réserve (non intégrés au jeu actif). Leur impact runtime dépend de si le moteur les charge ou non. Ceci n'est pas vérifiable sans les sources du moteur.

---

## Annexe A — Méthodologie de parcours

L'analyse a suivi l'ordre suivant :

1. **Exploration de la structure du dépôt** : `find` sur la racine pour identifier les types de fichiers présents (exclusion rapide : aucun .cs, .csproj, .sln).
2. **Identification du périmètre réel** : confirmation que le dépôt contient uniquement le mod Lua/contenu PMDC, pas le moteur.
3. **Lecture des fichiers d'initialisation** : `main.lua`, `scriptvars.lua`, `config.lua` — pour comprendre le point d'entrée, l'état persistant, et les dépendances.
4. **Lecture des fichiers cœur** : `common.lua` (fonctions partagées), `GeneralFunctions.lua` (utilitaires), `event_battle.lua` / `event_single.lua` / `event_misc.lua` (callbacks moteur).
5. **Analyse par motif de bug** :
   - Recherche textuelle de `math.random` dans les contextes donjon
   - Recherche d'affectations sans `local` (fuites globales)
   - Comparaison ligne-à-ligne des variantes de fonctions similaires (`DungeonInteract` vs `GroundInteract`)
   - Vérification de la complétude des gardes nil
   - Recherche de mutations d'état global statique
   - Vérification de la cohérence des paramètres de fonction
6. **Lecture des services** : vérification de la robustesse des services (sonde NRE, validateur ground).
7. **Échantillonnage des scripts de contenu** : zone scripts, ground scripts, scripts RESERVE.
