--[[ a02p01 — Fissure : l'ouverture de la fuite (canon PMD Red gs164).
     La ville est derrière, les accusations aussi. Le duo décide de fuir. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a02p01 = {}

function a02p01.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée (Main_Entrance_Marker) sur 480x360
  pcall(function() GROUND:TeleportTo(hero, 240, 320, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 208, 320, Direction.Up) end) end
  GAME:MoveCamera(224, 280, 1, false)
  GAME:FadeIn(25)

  -- Un regard en arrière (la ville / les poursuivants)
  if partner then GROUND:CharTurnToCharAnimated(partner, hero, 4) end
  GAME:WaitFrames(25)
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_001"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_002"))
  end
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P01_004"))

  -- En avant, vers le nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 240, 180, false, 12, 40) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 208, 180, false, 12, 40) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a02p01
