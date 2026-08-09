--[[ a02p04 — Volcan : le soulagement (canon PMD Red gs167).
     Plus de poursuivants. Le duo rit, puis prend la mesure de la route
     qui reste : le Mont Ardent, puis le froid, puis la neige. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a02p04 = {}

function a02p04.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée (Main_Entrance_Marker) sur 264x384
  pcall(function() GROUND:TeleportTo(hero, 132, 336, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 100, 336, Direction.Up) end) end
  GAME:MoveCamera(116, 280, 1, false)
  GAME:FadeIn(25)

  -- Le duo souffle, se regarde, rit
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_001"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_002"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_003"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_004"))
  end
  GAME:WaitFrames(20)

  -- La mesure de la solitude
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_008"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_009"))
  end
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_010"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_011"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_012"))
  end
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_013"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_014"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_015"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_016"))

  -- La décision
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_017"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_018"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_019"))
  end
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_020"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_021"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_022"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_023"))
  end
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_024"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_025"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_026"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P04_027"))
  end

  -- En route vers le nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 132, 180, false, 12, 40) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 100, 180, false, 12, 40) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a02p04
