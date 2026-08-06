--[[
  tour_celeste_entree/init.lua
  Tour Céleste — Entrée (D13P01) — PMD Red authentique 1:1 — VUE PANORAMIQUE
  Source: PMD-5 sky_tower.rsground 36x27 SkyTower_Base + PMDRed D13P01 (8 dlg, BGM_SWITCH, CAMERA_INIT_PAN)
  Preserve integrite: Ground 36x27, Sheet SkyTower_Base, Markers Main_Entrance+Cutscene — NE PAS MODIFIER LE .rsground
  Choregraphie: CAMERA_INIT_PAN (vue Tour) -> BGM_SWITCH Sky Tower -> Flash -> Dialogues
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local entree = {}

function entree.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
end

function entree.Enter(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner then AI:DisableCharacterAI(partner) end
  -- Placement PMD-5 : Main_Entrance_Marker au sud, équipe regarde nord vers la Tour
  GAME:MoveCamera(144, 200, 1, false) -- bas de la Tour (vue pied)
  GAME:CutsceneMode(true)
  GAME:WaitFrames(40)
  UI:ResetSpeaker()
  -- Titre PMD Red
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(30)
  UI:WaitHideTitle(20)
  -- BGM_SWITCH MUS_SKY_TOWER (D13P01 first action)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)
  -- CAMERA_INIT_PAN : dévoile la Tour du pied au sommet — 90 frames lent (grandeur)
  -- PMD Red : CAMERA_INIT_PAN + CAMERA_PAN direction Up, speed lent = tension
  local camPan = TASK:BranchCoroutine(function() GAME:MoveCamera(144, 40, 90, false) end)
  GAME:WaitFrames(10)
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCE_001']), "Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCE_002']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCE_003']))
    GeneralFunctions.EndConversation(partner)
  end
  TASK:JoinCoroutines({camPan})
  GAME:WaitFrames(20)
  -- Dialogue héros (pensée) — vue confirmée
  if hero then GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['TCE_004']), "Worried") end
  GAME:WaitFrames(15)
  -- Flash + BGM_SWITCH second (D13P01 mid)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  do local c=GAME:GetCameraCenter(); pcall(function() GAME:FadeOut(false, 8) end); GAME:WaitFrames(8); pcall(function() GAME:FadeIn(8) end) end
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCE_005']), "Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCE_006']))
    GeneralFunctions.EndConversation(partner)
  end
  GAME:WaitFrames(15)
  -- Second pan : retour sur équipe
  GAME:MoveCamera(144, 108, 60, false)
  GAME:WaitFrames(60)
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCE_007']), "Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCE_008']))
    GeneralFunctions.EndConversation(partner)
  end
  GAME:CutsceneMode(false)
  if partner then AI:EnableCharacterAI(partner) end
end

function entree.Update(map) end
function entree.GameSave(map) end
function entree.GameLoad(map) GAME:FadeIn(20) end

return entree
