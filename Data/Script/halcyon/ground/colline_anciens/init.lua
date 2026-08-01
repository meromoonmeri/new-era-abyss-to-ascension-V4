--[[ Colline des Anciens — le Veilleur Xatu (Réseau des Anciens Chemins).
     Ground pmd-red importé 1:1 (精霊の丘 Hill of the Ancients).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.VoiceVisions'
require 'halcyon.BossFX'

local colline_anciens = {}

local function sortie()
  GAME:FadeOut(false, 40)
  -- Transition vers la grande réunion à Metano Town (Chapitre 7)
  SV.Chapter7.VisitedXatu = true
  GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
end

function colline_anciens.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_colline_anciens")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

local function Scene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- Positions recalées sur la Colline des Anciens (240x160 px)
  GROUND:TeleportTo(hero, 140, 120, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 100, 120, Direction.Up) end
  GAME:MoveCamera(120, 90, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  local function say(emo, txt)
    if partner == nil then return end
    UI:SetSpeaker(partner); GeneralFunctions.SetEmotion(emo)
    UI:WaitShowDialogue(txt); GAME:WaitFrames(10)
  end
  local function narrate(txt)
    UI:ResetSpeaker(false); UI:SetCenter(true)
    UI:WaitShowDialogue(txt); UI:SetCenter(false); GAME:WaitFrames(10)
  end
  local function think(emo, txt)
    GeneralFunctions.HeroDialogue(hero, txt, emo); GAME:WaitFrames(10)
  end

  say("Normal", "Quelle vue...[pause=20] On voit tout le canyon d'ici.")
  narrate("Le vent s'engouffre entre les parois sans produire le moindre écho.")
  say("Worried", "C'est ça qui me dérange depuis tout à l'heure.[pause=25] Un canyon de cette taille devrait renvoyer chaque mot.")
  think("Worried", "(J'ai crié tout à l'heure, en grimpant...[pause=25] Je ne me suis même pas entendu.)")
  GAME:WaitFrames(15)

  narrate("Sur l'éperon rocheux, en face,[pause=20] une silhouette de Xatu est immobile.[pause=25] Elle fixe le soleil couchant.")
  local xatu = CharacterEssentials.MakeCharactersFromList({{'Canyon_Xatu', 120, 60, Direction.Down}})
  GAME:WaitFrames(20)
  say("Surprised", "Depuis quand est-ce qu'il...[pause=25] Non, il n'a pas bougé d'un pouce. On ne l'avait pas vu.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Le canyon ne mange pas vos voix.[pause=30] C'est moi.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Je les écoute depuis si longtemps que je les garde toutes.[pause=20] Y compris celles qu'on ne devrait pas entendre.")
  GAME:WaitFrames(20)

  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Vous cherchez des réponses aux tremblements qui secouent ce monde,[pause=10] n'est-ce pas ?")
  GAME:WaitFrames(15)
  say("Normal", "Oui ! La Team Alakazam nous a dit que vos visions du passé et de l'avenir pourraient nous aider !")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("L'avenir...[pause=15] le présent...[pause=15] tout s'entremêle.[br]Le flux de l'équilibre est perturbé.[pause=20] Laissez-moi regarder...")
  GAME:WaitFrames(20)

  -- ENTREE EN TRANSE DE XATU (Effets sonores, secousses et clignotements d'écran)
  SOUND:PlayBattleSE("EVT_Title_Intro")
  pcall(function() GROUND:CharSetAnim(xatu, "Attack", true) end)
  BossFX.ShakeScreen(3, 40)
  GAME:FadeOut(true, 10)
  GAME:WaitFrames(20)
  GAME:FadeIn(10)
  GAME:WaitFrames(25)

  -- LES VISIONS DE XATU (Flashs de couleurs et bruits magiques)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(true, 5)
  pcall(function() GROUND:AddMapStatus("dream") end)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("...Je vois...[pause=10] une faille béante...[pause=15] sous la terre...")
  GAME:WaitFrames(15)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  UI:WaitShowDialogue("...La lave...[pause=10] elle monte...[pause=15] un géant de magma s'éveille dans sa caldeira...")
  GAME:WaitFrames(15)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(true, 5)
  GAME:FadeIn(5)
  GAME:WaitFrames(30)

  UI:WaitShowDialogue("...C'est...[pause=15] Groudon ![pause=20] Le Titan de la Terre !")
  UI:WaitShowDialogue("Il gronde au cœur du volcan...[pause=15] mais ce n'est pas sa propre volonté qui le pousse.[br]Une force invisible... une force obscure l'agite.")
  GAME:WaitFrames(30)

  -- FIN DE LA TRANSE
  SOUND:PlayBattleSE("EVT_Water_Splash")
  pcall(function() GROUND:RemoveMapStatus("dream") end)
  pcall(function() GROUND:CharSetAnim(xatu, "Idle", true) end)
  GAME:WaitFrames(40)

  say("Shock", "Groudon ?! Le Pokémon légendaire de la terre ?!")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Oui...[pause=15] Il est au cœur des perturbations sismiques actuelles.[pause=20] Les veines d'énergie convergent toutes vers son trône de magma.")
  UI:WaitShowDialogue("La voie est ouverte.[pause=25] Allez, petits.[pause=30] Et quand vous aurez affronté le feu, rapportez-moi la réponse.")
  GAME:WaitFrames(25)

  -- Xatu disparaît sous un flash
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(120, 60, 3, 5, 20)
  pcall(function() GROUND:Hide('Canyon_Xatu') end)
  GAME:WaitFrames(25)
  narrate("Il n'est pas parti.[pause=25] Il a simplement cessé d'être visible, comme le reste des voix d'ici.")
  GAME:WaitFrames(15)

  narrate("Deux piliers taillés dans la roche s'éveillent de part et d'autre du passage.")
  say("Normal", "Le Réseau ne traverse pas le canyon...[pause=20] il le franchit.")
  GAME:WaitFrames(12)
  think("Normal", "(Groudon...[pause=15] Et cette force qui l'agite...[pause=10] Qu'est-ce que cela signifie ?)")
  GAME:WaitFrames(15)
  say("Determined", "Une voie de plus.[pause=25] Et beaucoup plus de questions.[pause=15] Retournons vite à Metano Town faire notre rapport !")
  GAME:WaitFrames(20)
end

function colline_anciens.Enter(map)
  DEBUG.EnableDbgCoro()
  local ok, err = pcall(Scene)
  if not ok then PrintInfo('[colline_anciens] scene ecourtee : '..tostring(err)) end
  pcall(function()
    UI:ResetSpeaker()
    local partner = CH('Teammate1')
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  sortie()
end

function colline_anciens.Update(map, time) end
function colline_anciens.GameSave(map) end
function colline_anciens.GameLoad(map) end

return colline_anciens
