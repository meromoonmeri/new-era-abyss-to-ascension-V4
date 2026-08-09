--[[ d10p03 — Grotte Givrée : ARTIKODIN (canon PMD Red gs200).
     Le duo entre dans la clairière gelée. Artikodin (Articuno) surgit dans
     la brume glaciale (EmergeMist), accuse le duo du réchauffement, puis
     Absol intervient pour attester de leur innocence. Apparition
     progressive, dialogues canoniques (clés SCENE_D10P03_*). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local d10p03 = {}

function d10p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Positions canoniques (markers d10p03) : héros (232,232), boss (264,176)
  pcall(function() GROUND:TeleportTo(hero, 232, 232, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 200, 232, Direction.Up) end) end
  GAME:MoveCamera(264, 216, 1, false)
  GAME:FadeIn(25)

  -- Le duo avance vers le centre
  if partner then GeneralFunctions.MoveCharAndCamera(partner, 200, 200, false, 12, 35) end
  if hero then GeneralFunctions.MoveCharAndCamera(hero, 232, 200, false, 12, 35) end
  GAME:WaitFrames(30)

  -- ARTIKODIN surgit de la brume
  local articuno = CharacterEssentials.MakeCharactersFromList({{'Articuno', 264, 176, Direction.Down}})
  if articuno then
    pcall(function() GROUND:Hide('Articuno') end)
    BossFX.EmergeMist(articuno, 264, 176)
    BossFX.Flash(264, 176, 3, 6, 30)
  end

  -- ARTIKODIN accuse
  if articuno then UI:SetSpeaker(articuno) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_001"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_005"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_006"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_007"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_008"))
  if partner then pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_009"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_010"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_011"))

  -- ABSOL intervient
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_012"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_013"))
  if articuno then UI:SetSpeaker(articuno) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_014"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_015"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_016"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_017"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_018"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_019"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_020"))

  -- ARTIKODIN laisse passer, avec une mission
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_021"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_022"))
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_023"))
  if articuno then UI:SetSpeaker(articuno) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_024"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_025"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_026"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_027"))
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_028"))

  -- Soupir de soulagement
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_029"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D10P03_030"))

  GAME:CutsceneMode(false)
end

return d10p03
