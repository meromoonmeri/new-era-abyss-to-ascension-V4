--[[ a03p01 — Route de neige (canon PMD Red gs168).
     Le duo traverse le froid. Partenaire parle, héros observe. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a03p01 = {}

function a03p01.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée par le Main_Entrance_Marker (460,156) sur 960x288
  pcall(function() GROUND:TeleportTo(hero, 460, 156, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 428, 156, Direction.Up) end) end
  GAME:MoveCamera(444, 140, 1, false)
  GAME:FadeIn(25)

  -- Le duo avance dans le froid (canon : la marche vers le nord)
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 428, 92, false, 12, 40) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 460, 92, false, 12, 40) end
  GAME:WaitFrames(30)

  -- Le partenaire sent le froid
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_001"))
    pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_002"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_003"))
  end

  -- Un mouvement dans la neige : le héros sursaute (pensée)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_004"))
  if hero then
    pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
    UI:SetSpeaker(hero)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_005"))
  end
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_006"))

  -- Le partenaire reprend la marche
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_007"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_008"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_009"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_010"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_011"))
  end
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_012"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_013"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A03P01_014"))
  end

  -- Avancer vers la sortie nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 460, 40, false, 14, 30) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 428, 40, false, 14, 30) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a03p01
