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
-- D04P01 canonique n'est qu'une bande praticable (collision BMA 1:1) : tous
-- les slots des Dazzling sont posés DANS la bande, entre le héros et l'objet
-- Dungeon_Entrance (corrigé 2026-08-10 : l'ancienne mise en scène les
-- spawnait dans les murs — rows 10-20 solides). La scène ne lance pas le
-- donjon : le joueur conserve la main et franchit ensuite le trigger.
function gloomy_forest_entrance_ch_6.DazzlingEntranceBlockade()
  if SV.Chapter6.DazzlingEntranceSeen then return end
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner then AI:DisableCharacterAI(partner) end
    GROUND:TeleportTo(hero, 208, 248, Direction.Up)
    if partner then GROUND:TeleportTo(partner, 248, 248, Direction.Up) end
    local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
      {'Adagio',224,216,Direction.Down}, {'Aria',192,224,Direction.DownRight},
      {'Sonata',256,224,Direction.DownLeft}})
    GAME:MoveCamera(224,224,30,false);SOUND:PlayBGM('Team_Dazzling_Theme.ogg',true)
    GAME:FadeIn(20);GAME:WaitFrames(20)
    dialogue(aria,'GF6E_A13','Happy');dialogue(adagio,'GF6E_A14','Normal')
    dialogue(partner,'GF6E_A15','Angry');dialogue(sonata,'GF6E_A16','Happy')
    pcall(function()
      GROUND:MoveToPosition(aria,176,224,false,1)
      GROUND:MoveToPosition(sonata,272,224,false,1)
    end)
    dialogue(aria,'GF6E_A17','Happy');dialogue(adagio,'GF6E_A18','Normal')
    dialogue(partner,'GF6E_A19','Angry')
    GeneralFunctions.HeroDialogue(hero,STRINGS:Format(STRINGS.MapStrings['GF6E_A20']),'Determined')
    dialogue(partner,'GF6E_A21','Determined')
    -- Elles cessent enfin de barrer le passage et entrent les premières :
    -- marche vers la lisière (bord haut de la bande praticable) puis fondu.
    local a=TASK:BranchCoroutine(function() GROUND:MoveToPosition(adagio,224,200,false,2) end)
    local b=TASK:BranchCoroutine(function() GROUND:MoveToPosition(aria,192,200,false,2) end)
    local c=TASK:BranchCoroutine(function() GROUND:MoveToPosition(sonata,256,200,false,2) end)
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

-- D04P02 : la clairière. Les trois positions FINALES de la scène source sont
-- conservées et recastées : centre (272,192) = meneuse; droite (312,224);
-- gauche (240,224) — rendues ici par les marqueurs du ground (translations
-- de cadrage documentées dans le .rsground). Les Dazzling entrent depuis la
-- lisière praticable (corrigé 2026-08-10 : spawn hors des murs).
function gloomy_forest_entrance_ch_6.DazzlingClearingCutscene()
  local hero, partner = CH('PLAYER'), CH('Teammate1')
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  if partner then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 224, 208, Direction.Up)
  if partner then GROUND:TeleportTo(partner, 264, 208, Direction.Up) end
  -- Dans la source GBA, les trois Meanies avancent ensemble avant leur
  -- première réplique (sub_8087144). Team Dazzling reprend ces trois slots :
  -- elle n'apparaît donc pas déjà figée à sa position finale. Spawn à la
  -- lisière haute de la clairière (cellules praticables), puis avancée.
  local adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
    {'Adagio',240,120,Direction.Down},
    {'Aria',280,136,Direction.DownLeft},
    {'Sonata',208,136,Direction.DownRight},
  })
  GAME:MoveCamera(240,160,1,false)
  SOUND:PlayBGM('In the Depths of the Pit.ogg',true)
  GAME:FadeIn(30);GAME:WaitFrames(10)
  local enter1=TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(adagio,240,144,false,1)
    GROUND:CharAnimateTurnTo(adagio,Direction.Down,4)
  end)
  local enter2=TASK:BranchCoroutine(function()
    GAME:WaitFrames(12);GROUND:MoveToPosition(aria,280,176,false,1)
    GROUND:CharAnimateTurnTo(aria,Direction.Left,4)
  end)
  local enter3=TASK:BranchCoroutine(function()
    GAME:WaitFrames(12);GROUND:MoveToPosition(sonata,208,176,false,1)
    GROUND:CharAnimateTurnTo(sonata,Direction.Right,4)
  end)
  local cam=TASK:BranchCoroutine(function() GAME:MoveCamera(240,192,35,false) end)
  TASK:JoinCoroutines({enter1,enter2,enter3,cam});GAME:WaitFrames(10)
  SOUND:PlayBGM('Team_Dazzling_Theme.ogg',true)

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
  -- Canon D04P02 : le héros enregistre la tension par un pivot lent gauche
  -- puis droite (source : ROTATE_TO(10,SPINLEFT1,WEST) / WAIT(60) /
  -- ROTATE_TO(4,SPINRIGHT1,EAST)) avant la bascule sérieuse.
  GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  GAME:WaitFrames(30)
  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
  GAME:WaitFrames(15)
  if partner then GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end

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
