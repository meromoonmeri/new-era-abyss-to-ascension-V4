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

return SkySceneKit
