--[[ d13p03 — Sommet de la Tour Céleste : RAYQUAZA (canon PMD Red gs209).
     L'arbitre du ciel descend des nuages (DescendSky), juge le duo,
     puis le combat s'engage. Même mise en scène que le climax ch10
     (tour_ciel_sommet) : apparition progressive, pushback, flash.
     Dialogues canoniques (clés SCENE_D13P03_*). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local d13p03 = {}

function d13p03.Cutscene()
  DEBUG.EnableDbgCoro()
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Positions canoniques (markers arc_tour_ciel_sommet) : héros (296,296), boss (272,272)
  pcall(function() GROUND:TeleportTo(hero, 296, 296, Direction.Up) end)
  if partner then pcall(function() GROUND:TeleportTo(partner, 256, 296, Direction.Up) end) end
  GAME:MoveCamera(272, 280, 1, false)
  GAME:FadeIn(25)

  -- Pensée du héros
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_001"))

  -- RAYQUAZA descend des nuages
  local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 272, Direction.Down}})
  if rayquaza then
    pcall(function() GROUND:Hide('Rayquaza') end)
    BossFX.DescendSky(rayquaza, 272, 272, 160)
    BossFX.PushBack({hero, partner}, Direction.Down)
    BossFX.Flash(272, 272, 4, 6, 30)
    pcall(function() SOUND:PlaySE('DUN_Thundurus_Spawn') end)
  end

  -- RAYQUAZA juge
  if rayquaza then UI:SetSpeaker(rayquaza) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_002"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_003"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_004"))
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_005"))
  if hero then pcall(function() GROUND:CharSetEmote(hero, "determined", 1) end) end
  UI:SetSpeaker(hero)
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_006"))
  if partner then UI:SetSpeaker(partner) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_007"))
  if rayquaza then UI:SetSpeaker(rayquaza) end
  UI:WaitShowDialogue(STRINGS:FormatKey("SCENE_D13P03_008"))

  GAME:CutsceneMode(false)
end

return d13p03
