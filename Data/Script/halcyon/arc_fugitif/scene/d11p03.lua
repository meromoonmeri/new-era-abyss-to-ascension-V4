--[[ d11p03 — Autel du Mont Gelé : FEUNARD, le témoin (canon PMD Red gs203).
     Pas de combat : Feunard (Ninetales) reçoit le duo et livre le
     témoignage sur la légende. Apparition discrète dans la brume
     (EmergeMist), voix posée. Dialogues canoniques (clés SCENE_D11P03_*). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local d11p03 = {}

function d11p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Positions canoniques (markers d11p03) : héros (280,344), Feunard (224,328)
  pcall(function() GROUND:TeleportTo(hero, 280, 344, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 248, 344, Direction.Up) end) end
  GAME:MoveCamera(248, 280, 1, false)
  GAME:FadeIn(25)

  -- Le duo gravit l'autel
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 248, 260, false, 10, 45) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 280, 260, false, 10, 45) end
  GAME:WaitFrames(30)

  -- Pensées du héros (le lieu, la présence)
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_002"))

  -- FEUNARD se révèle dans la brume
  local ninetales = CharacterEssentials.MakeCharactersFromList({{'Ninetales', 224, 240, Direction.Down}})
  if ninetales then
    pcall(function() GROUND:Hide('Ninetales') end)
    BossFX.EmergeMist(ninetales, 224, 240)
  end

  -- FEUNARD livre le témoignage
  if ninetales then UI:SetSpeaker(ninetales) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_008"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_009"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_010"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_011"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_012"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_013"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_014"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_015"))

  -- Réaction du duo
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_016"))
  if ninetales then UI:SetSpeaker(ninetales) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_017"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_018"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_019"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_020"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D11P03_021"))

  GAME:CutsceneMode(false)
end

return d11p03
