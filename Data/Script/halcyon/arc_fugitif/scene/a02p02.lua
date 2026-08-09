--[[ a02p02 — Incendie (canon PMD Red gs165).
     Le duo traverse une terre qui fume encore. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a02p02 = {}

function a02p02.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée (Main_Entrance_Marker) sur 264x192
  pcall(function() GROUND:TeleportTo(hero, 132, 160, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 100, 160, Direction.Up) end) end
  GAME:MoveCamera(116, 140, 1, false)
  GAME:FadeIn(25)

  -- Le duo avance, la terre fume
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 100, 96, false, 12, 35) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 132, 96, false, 12, 35) end
  GAME:WaitFrames(25)

  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_001"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_002"))
  end
  if hero then
    UI:SetSpeaker(hero)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_003"))
  end
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P02_004"))
  end

  -- Sortie nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 132, 40, false, 14, 30) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 100, 40, false, 14, 30) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a02p02
