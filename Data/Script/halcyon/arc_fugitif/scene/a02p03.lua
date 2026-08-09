--[[ a02p03 — Grotte Lapis : la poursuite (canon PMD Red gs166).
     La foule de Metano est lancée à leurs trousses. Cris en arrière-plan
     (ResetSpeaker), le duo halète, puis fonce vers le Mont Ardent. ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local a02p03 = {}

function a02p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Entrée (Main_Entrance_Marker) sur 360x288
  pcall(function() GROUND:TeleportTo(hero, 180, 240, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 148, 240, Direction.Up) end) end
  GAME:MoveCamera(164, 200, 1, false)
  GAME:FadeIn(25)

  -- Essoufflés
  if partner then
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_001"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_002"))
  end

  -- LA FOULE derrière eux (voix sans portrait)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_007"))

  -- Le duo regarde le Mont Ardent
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_008"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_009"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_010"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_011"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_012"))
  end

  -- La foule se rapproche — plus le choix
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_013"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_014"))
  if partner then
    UI:SetSpeaker(partner)
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_015"))
    UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_A02P03_016"))
  end

  -- Ils foncent vers le nord
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 180, 100, true, 16, 30) end
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 148, 100, true, 16, 30) end
  GAME:WaitFrames(20)
  GAME:CutsceneMode(false)
end

return a02p03
