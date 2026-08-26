-- kit.lua — runtime partagé des scènes Sky compilées (sky_compile_scenes.py).
-- Choisit la langue du dialogue selon la langue du jeu (textes ROM 5 langues
-- embarqués tels quels) et affiche via l'API native RogueEssence.
-- En mode validation headless (PMDO_GROUND_VALIDATOR), utilise le dialogue
-- TEMPORISÉ natif (WaitShowTimedDialogue) pour ne pas attendre une entrée ;
-- en jeu normal, dialogue standard à validation joueur (canon).
local SkySceneKit = {}

local LANG_MAP = {en = 'english', fr = 'french', de = 'german',
                  it = 'italian', es = 'spanish'}

local function pick_lang(t)
  local code = 'en'
  pcall(function()
    code = tostring(RogueEssence.DiagManager.Instance.CurSettings.Language)
  end)
  code = string.sub(string.lower(code or 'en'), 1, 2)
  local key = LANG_MAP[code] or 'english'
  return t[key] or t.english or next(t) and select(2, next(t)) or ''
end

-- Adaptation technique du markup NDS -> markup RogueEssence (documentée,
-- contenu textuel inchangé) :
--   [K]        attente touche      -> espace (le rythme est géré par say)
--   [CS:X]...[CR] couleur NDS      -> [color=#FFFF00]...[color] (PMDO)
--   [hero]/[partner]               -> noms réels de l'équipe
--   autres balises [X] inconnues   -> retirées (le parseur PMDO se bloque
--                                     sur les balises non reconnues)
local function clean(s)
  s = tostring(s or '')
  s = s:gsub('%[K%]', ' ')
  s = s:gsub('%[CS:%w+%]', '[color=#FFFF00]')
  s = s:gsub('%[CR%]', '[color]')
  pcall(function()
    local hero = CH('PLAYER')
    if hero then s = s:gsub('%[hero%]', hero:GetDisplayName()) end
    local p = CH('Teammate1')
    if p then s = s:gsub('%[partner%]', p:GetDisplayName()) end
  end)
  -- balises NDS restantes non mappées : retirées avec trace de log
  s = s:gsub('%[[A-Za-z_:%d]+%]', function(tag)
    if tag:match('^%[color') then return tag end
    return ''
  end)
  -- Retours à la ligne NDS = mise en forme de l'écran NDS (256px) ;
  -- la boîte PMDO a sa propre largeur et son propre wrapping. Les \n
  -- forcés provoquent une pagination à validation joueur (blocage
  -- headless au 3e+ ligne). Adaptation technique : espace, texte intact.
  s = s:gsub('\n', ' ')
  s = s:gsub('%s+', ' ')
  s = s:gsub('^%s+', ''):gsub('%s+$', '')
  return s
end

local function trace(s)
  if os.getenv('PMDO_GROUND_VALIDATOR') == nil then return end
  local f = io.open('/tmp/ground_gameplay_validator.jsonl', 'a')
  if f then f:write(s .. '\n'); f:close() end
end

function SkySceneKit.say(t)
  local txt = clean(pick_lang(t))
  if txt == '' then return end
  local headless = os.getenv('PMDO_GROUND_VALIDATOR') ~= nil
  trace('{"kit":"say_begin","len":' .. #txt .. '}')
  if headless then
    local frames = math.max(90, math.min(300, #txt * 2))
    pcall(function() UI:WaitShowTimedDialogue(txt, frames) end)
  else
    pcall(function() UI:WaitShowDialogue(txt) end)
  end
  trace('{"kit":"say_done"}')
end

-- PNJ temporaires des scènes compilées (cast SSA ROM : espèce via
-- PMDO_MAPPING entid→species, position tuile*8+off*4, direction SSA).
-- Même mécanique native que LulubyTown.spawn (GroundChar+AddTempChar).
local spawned_npcs = {}

function SkySceneKit.spawn_npc(species, x, y, dir, name)
  local c
  local ok = pcall(function()
    c = RogueEssence.Ground.GroundChar(
      RogueEssence.Dungeon.MonsterID(species, 0, 'normal', Gender.Unknown),
      RogueElements.Loc(x, y), dir, name, name)
    c:ReloadEvents()
    GAME:GetCurrentGround():AddTempChar(c)
  end)
  if ok and c then
    spawned_npcs[#spawned_npcs + 1] = c
    return c
  end
  trace('{"kit":"spawn_npc_fail","species":"' .. tostring(species) .. '"}')
  return CH('PLAYER') -- fallback loggé, jamais silencieux
end

function SkySceneKit.cleanup_npcs()
  for _, c in ipairs(spawned_npcs) do
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(c) end)
  end
  spawned_npcs = {}
end

--------------------------------------------------------------------
-- MULTIROUTINES NDS (def N for actor X + Lock/Unlock).
--
-- Modèle ROM : chaque acteur a sa coroutine ; `Lock(n)` suspend la
-- routine jusqu'à ce qu'une autre exécute `Unlock(n)` — c'est le
-- mécanisme de synchronisation des cinématiques multi-acteurs NDS.
-- Équivalent PMDO : TASK:BranchCoroutine par routine d'acteur (même
-- moteur de coroutines que le harnais journey, natif RogueEssence),
-- verrous = table partagée de drapeaux ; lock() boucle en WaitFrames(1)
-- jusqu'au drapeau — sémantique identique, testée runtime.
--------------------------------------------------------------------
local locks = {}
local running = 0

function SkySceneKit.reset_locks()
  locks = {}
  running = 0
end

function SkySceneKit.unlock(n)
  locks[n] = true
end

function SkySceneKit.lock(n)
  -- suspend la coroutine courante jusqu'à Unlock(n) (30 s de garde-fou
  -- anti-blocage headless, tracé — jamais silencieux)
  local waited = 0
  while not locks[n] and waited < 1800 do
    GAME:WaitFrames(1)
    waited = waited + 1
  end
  if waited >= 1800 then
    trace('{"kit":"lock_timeout","lock":' .. tostring(n) .. '}')
  end
end

-- lance une routine d'acteur en parallèle (def N for actor X)
function SkySceneKit.run_routine(fn)
  running = running + 1
  TASK:BranchCoroutine(function()
    local ok, err = pcall(fn)
    if not ok then
      trace('{"kit":"routine_error","error":"'
            .. tostring(err):gsub('"', "'"):sub(1, 120) .. '"}')
    end
    running = running - 1
  end)
end

-- attend la fin de toutes les routines lancées (fin du def 0)
function SkySceneKit.join_routines(max_frames)
  local waited = 0
  max_frames = max_frames or 3600
  while running > 0 and waited < max_frames do
    GAME:WaitFrames(1)
    waited = waited + 1
  end
  if running > 0 then
    trace('{"kit":"join_timeout","still_running":'
          .. tostring(running) .. '}')
    running = 0
  end
end

return SkySceneKit
