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

-- Barrage d'entrée : la Team Dazzling occupe physiquement le passage.
-- Les slots sont tous praticables sur D04P01 et laissent le chemin libre
-- uniquement après leur départ. Cette scène ne lance pas le donjon : le
-- joueur conserve la main et franchit ensuite le trigger normalement.
function gloomy_forest_entrance_ch_6.DazzlingEntranceBlockade()
  if SV.Chapter6.DazzlingEntranceSeen then return end
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner then AI:DisableCharacterAI(partner) end
    GROUND:TeleportTo(hero, 208, 192, Direction.Up)
    if partner then GROUND:TeleportTo(partner, 240, 192, Direction.Up) end
    local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
      {'Adagio',224,136,Direction.Down}, {'Aria',192,160,Direction.DownRight},
      {'Sonata',256,160,Direction.DownLeft}})
    GAME:MoveCamera(224,160,30,false);SOUND:PlayBGM('Team_Dazzling_Theme.ogg',true)
    GAME:FadeIn(20);GAME:WaitFrames(20)
    dialogue(aria,'GF6E_A13','Happy');dialogue(adagio,'GF6E_A14','Normal')
    dialogue(partner,'GF6E_A15','Angry');dialogue(sonata,'GF6E_A16','Happy')
    pcall(function()
      GROUND:MoveToPosition(aria,176,136,false,1)
      GROUND:MoveToPosition(sonata,272,136,false,1)
    end)
    dialogue(aria,'GF6E_A17','Happy');dialogue(adagio,'GF6E_A18','Normal')
    dialogue(partner,'GF6E_A19','Angry')
    GeneralFunctions.HeroDialogue(hero,STRINGS:Format(STRINGS.MapStrings['GF6E_A20']),'Determined')
    dialogue(partner,'GF6E_A21','Determined')
    -- Elles cessent enfin de barrer le passage et entrent les premières.
    local a=TASK:BranchCoroutine(function() GROUND:MoveToPosition(adagio,224,96,false,2) end)
    local b=TASK:BranchCoroutine(function() GROUND:MoveToPosition(aria,192,104,false,2) end)
    local c=TASK:BranchCoroutine(function() GROUND:MoveToPosition(sonata,256,104,false,2) end)
    TASK:JoinCoroutines({a,b,c});GAME:FadeOut(false,20)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(adagio) end)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(aria) end)
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(sonata) end)
    SV.Chapter6.DazzlingEntranceSeen=true
    SV.Chapter6.DazzlingPresenceStage=1
    GAME:MoveCamera(0,0,1,true);GAME:FadeIn(20)
  end)
  pcall(function()
    if partner then AI:EnableCharacterAI(partner);AI:SetCharacterAI(partner,'origin.ai.ground_partner',hero,partner.Position) end
    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Gloomy Dazzling entrance] '..tostring(err)) end
end

-- D04P02 : les trois positions de la scène source sont conservées et recastées.
-- centre (272,192) = meneuse; droite (312,224); gauche (240,224).
function gloomy_forest_entrance_ch_6.DazzlingClearingCutscene()
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 224, 208, Direction.Up)
  if partner then GROUND:TeleportTo(partner, 264, 208, Direction.Up) end
  local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
    {'Adagio', 240, 144, Direction.Down},
    {'Aria', 280, 176, Direction.Left},
    {'Sonata', 208, 176, Direction.Right},
  })
  GAME:MoveCamera(240, 192, 1, false)
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

  -- Dans Deep Shadow, la rivalité cesse d'être une plaisanterie. La Team
  -- Dazzling a entendu Chenipent avant nous et ne peut plus feindre l'insouciance.
  UI:SetSpeaker(sonata);GeneralFunctions.SetEmotion('Worried')
  UI:WaitShowDialogue("Attendez...[pause=18] Ce bruit ne venait pas d'un Pokémon qui nous suivait.[pause=15] Il venait de devant.")
  UI:SetSpeaker(adagio);GeneralFunctions.SetEmotion('Determined')
  UI:WaitShowDialogue("Chenipent est tout près.[pause=15] Notre concours s'arrête ici. Si quelque chose le retient, nous ouvrons le passage ensemble.")
  UI:SetSpeaker(aria);GeneralFunctions.SetEmotion('Worried')
  UI:WaitShowDialogue("Je déteste quand la forêt devient assez sérieuse pour donner raison à Adagio...")
  GeneralFunctions.HeroDialogue(hero,"(Elles ont peur, elles aussi.[pause=15] Mais aucune ne recule.)",'Worried')
  SV.Chapter6.DazzlingPresenceStage = 4
  SV.Chapter6.DazzlingPreRescueSeen = true

  -- Les neuf poses finales de la CIF sont rendues par les orientations et
  -- réactions successives, sans déplacer les personnages hors de leurs slots.
  pcall(function()
    GROUND:CharTurnToCharAnimated(hero, adagio, 4)
    GROUND:CharTurnToCharAnimated(partner, adagio, 4)
    GROUND:CharSetEmote(aria, 'exclaim', 1)
    GROUND:CharSetEmote(sonata, 'angry', 1)
  end)
  SV.Chapter6.FinishedGloomyForestIntro = true
  SV.Chapter6.DazzlingPresenceStage = 4
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
