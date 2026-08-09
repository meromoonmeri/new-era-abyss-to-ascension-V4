--[[ a03p02 — Forêt de neige (canon PMD Red gs169).
     Le duo traverse la neige poudreuse. Court, contemplatif. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a03p02 = {}

function a03p02.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée par le Main_Entrance_Marker (116,212) sur 264x336
  pcall(function() GROUND:TeleportTo(hero, 116, 212, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 84, 212, Direction.Up) end) end
  GAME:MoveCamera(100, 160, 1, false)
  GAME:FadeIn(25)

  -- Marche dans la neige poudreuse
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 84, 148, false, 12, 35) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 116, 148, false, 12, 35) end
  GAME:WaitFrames(25)

  -- Le partenaire s'émerveille
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P02_001"))
    pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P02_002"))
  end

  -- Sortie nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 116, 80, false, 14, 30) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 84, 80, false, 14, 30) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a03p02
