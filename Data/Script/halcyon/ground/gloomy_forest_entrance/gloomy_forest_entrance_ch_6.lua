--[[ Sinister Woods — adaptation New Era du diptyque canonique D04P01/D04P02.

Les positions ne sont pas recomposées : elles viennent des marqueurs extraits
par PMD-RED-PMDO-PORT. Le casting Rescue Team est remplacé par New Era.
]]--
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_entrance_ch_6 = {}

local function dialogue(chara, key, emotion)
  UI:SetSpeaker(chara)
  if emotion then GeneralFunctions.SetEmotion(emotion) end
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
end

function gloomy_forest_entrance_ch_6.SetupGround()
  for _, name in ipairs({'Adagio','Aria','Sonata'}) do
    pcall(function() GROUND:Hide(name) end)
  end
end

-- D04P01 : arrivée dans les bois. La scène source ne contient que deux
-- messages et des poses idle; on conserve cette sobriété.
function gloomy_forest_entrance_ch_6.ApproachCutscene()
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner then AI:DisableCharacterAI(partner) end
  -- Positions extraites D04P01 : entrée et partenaire du port actif.
  GROUND:TeleportTo(hero, 208, 192, Direction.Up)
  if partner then GROUND:TeleportTo(partner, 240, 192, Direction.Up) end
  GAME:MoveCamera(224, 176, 1, false)
  SOUND:PlayBGM('Mystifying Forest.ogg', true)
  GAME:FadeIn(30)
  dialogue(partner, 'GF6E_A01', 'Worried')
  dialogue(partner, 'GF6E_A02', 'Worried')
  SV.Chapter6.SinisterApproachSeen = true
  GAME:CutsceneMode(false)
  if partner then AI:EnableCharacterAI(partner) end
  GAME:MoveCamera(0, 0, 20, true)
end

-- D04P02 : les trois positions de Team Meanies sont conservées et recastées.
-- centre (272,192) = meneuse; droite (312,224); gauche (240,224).
function gloomy_forest_entrance_ch_6.DazzlingClearingCutscene()
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 256, 256, Direction.Up)
  if partner then GROUND:TeleportTo(partner, 296, 256, Direction.Up) end
  local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
    {'Adagio', 272, 192, Direction.Down},
    {'Aria', 312, 224, Direction.Left},
    {'Sonata', 240, 224, Direction.Right},
  })
  GAME:MoveCamera(272, 240, 1, false)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  GAME:FadeIn(30)

  -- Neuf boîtes comme la scène D04P02 source, distribuées au nouveau casting.
  dialogue(aria, 'GF6E_A04', 'Happy')
  dialogue(partner, 'GF6E_A05', 'Surprised')
  dialogue(adagio, 'GF6E_A06', 'Normal')
  dialogue(sonata, 'GF6E_A07', 'Angry')
  pcall(function() GROUND:CharTurnToCharAnimated(aria, sonata, 4) end)
  dialogue(aria, 'GF6E_A08', 'Happy')
  dialogue(sonata, 'GF6E_A09', 'Angry')
  pcall(function()
    GROUND:CharTurnToCharAnimated(adagio, aria, 4)
    GROUND:CharTurnToCharAnimated(aria, adagio, 4)
    GROUND:CharTurnToCharAnimated(sonata, adagio, 4)
  end)
  dialogue(adagio, 'GF6E_A10', 'Normal')
  dialogue(adagio, 'GF6E_A11', 'Normal')
  dialogue(aria, 'GF6E_A12', 'Happy')

  -- Les neuf poses finales de la CIF sont rendues par les orientations et
  -- réactions successives, sans déplacer les personnages hors de leurs slots.
  pcall(function()
    GROUND:CharTurnToCharAnimated(hero, adagio, 4)
    GROUND:CharTurnToCharAnimated(partner, adagio, 4)
    GROUND:CharSetEmote(aria, 'exclaim', 1)
    GROUND:CharSetEmote(sonata, 'angry', 1)
  end)
  SV.Chapter6.FinishedGloomyForestIntro = true
  GAME:FadeOut(false, 30)
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon('gloomy_forest', 4, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gloomy_forest_entrance_ch_6.Butterfree_Action(obj, activator)
  UI:SetSpeaker(obj)
  UI:WaitShowDialogue("Chenipent est quelque part dans Sinister Woods...[pause=20] Retrouvez-le, je vous en prie !")
end

return gloomy_forest_entrance_ch_6
