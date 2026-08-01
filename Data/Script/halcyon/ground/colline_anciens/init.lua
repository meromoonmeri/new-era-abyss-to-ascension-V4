--[[ Colline des Anciens — le Veilleur Xatu (Réseau des Anciens Chemins).
     Ground pmd-red importé 1:1 (精霊の丘 Hill of the Ancients) : géométrie intouchée,
     casting et dialogues 100 % New Era.
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
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
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

  -- Positions recalées sur la Colline des Anciens (240x160 px) :
  --   Héros : (140, 120, Direction.Up)
  --   Partenaire : (100, 120, Direction.Up)
  --   Xatu : (120, 60, Direction.Down) (L'éperon rocheux du sommet)
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
  say("Worried", "C'est ça qui me dérange depuis tout à l'heure.[pause=25] Un canyon devrait renvoyer chaque mot.")
  think("Worried", "(J'ai crié tout à l'heure, en tombant.[pause=25] Je ne me suis même pas entendu.)")
  GAME:WaitFrames(15)

  narrate("Sur l'éperon rocheux, en face,[pause=20] une silhouette immobile.[pause=25] Elle ne s'est pas posée : elle était là.")
  local xatu = CharacterEssentials.MakeCharactersFromList({{'Canyon_Xatu', 120, 60, Direction.Down}})
  GAME:WaitFrames(20)
  say("Surprised", "Depuis quand est-ce qu'il...[pause=25] Non. Il n'a pas bougé. C'est nous qui ne l'avions pas vu.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Le canyon ne mange pas vos voix.[pause=30] C'est moi.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Je les écoute depuis si longtemps que je les garde.[pause=25] Toutes.[pause=20] Y compris celles qu'on ne devrait pas entendre.")
  GAME:WaitFrames(20)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Toi.[pause=30] Approche.")
  GAME:WaitFrames(15)
  say("Normal", "Moi ?[pause=20] ...Non. Il te regarde, toi.")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu)
  UI:WaitShowDialogue("Tu en portes une.[pause=30] Une voix qui n'est pas la tienne,[pause=20] et que personne d'autre n'entend.")
  GAME:WaitFrames(20)

  pcall(function() VoiceVisions.Nausea(hero, 2) end)
  pcall(function() VoiceVisions.Recover(hero) end)
  GAME:WaitFrames(15)

  say("Shock", "Comment vous...[pause=25] Il ne l'a dit à PERSONNE.[pause=20] Même à moi, il ne l'a dit qu'à moitié.")
  GAME:WaitFrames(15)
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue("Il ne l'a pas dit.[pause=25] Elle, si.[pause=30] Elle parle fort, pour qui sait écouter le silence.")
  GAME:WaitFrames(20)

  think("Worried", "(Alors ce n'est pas dans ma tête.[pause=30] Quelqu'un d'autre l'entend.[pause=20] Je ne sais pas si je suis soulagé ou terrifié.)")
  GAME:WaitFrames(20)

  say("Worried", "Alors dites-nous ![pause=20] Qu'est-ce que c'est ?[pause=25] Qu'est-ce qu'elle veut ?")
  GAME:WaitFrames(15)
  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Non.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Je vois loin.[pause=25] Assez loin pour savoir que nommer une chose,[pause=20] c'est lui ouvrir la porte.")
  GAME:WaitFrames(20)
  say("Angry", "C'est tout ?![pause=20] Vous nous laissez avec ÇA ?")
  GAME:WaitFrames(15)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Je vous laisse avec mieux qu'une réponse.[pause=30] Une bonne question.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Vous demandez tous CE QUE c'est.[pause=30] Demandez plutôt DEPUIS QUAND elle lui parle.")
  GAME:WaitFrames(25)

  think("Shock", "(Depuis quand...[pause=30] ...Je ne me souviens pas d'un seul jour sans elle.)")
  GAME:WaitFrames(20)
  say("Sad", "Attends.[pause=25] Tu veux dire que même avant qu'on se rencontre—")
  GAME:WaitFrames(20)

  UI:SetSpeaker(xatu); GeneralFunctions.SetEmotion("Sad")
  UI:WaitShowDialogue("La voie est ouverte.[pause=25] Passez.[pause=30] Et quand vous reviendrez,[pause=20] rapportez-moi la réponse.")
  GAME:WaitFrames(20)

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(120, 60, 3, 5, 20)
  pcall(function() GROUND:Hide('Canyon_Xatu') end)
  GAME:WaitFrames(25)
  narrate("Il n'est pas parti.[pause=25] Il a simplement cessé d'être visible,[pause=20] comme le reste des voix d'ici.")
  GAME:WaitFrames(15)

  narrate("Deux piliers taillés dans la roche s'éveillent de part et d'autre du passage.")
  say("Normal", "Le Réseau ne traverse pas le canyon...[pause=20] il le franchit.")
  GAME:WaitFrames(12)
  think("Normal", "(Et le gardien de la porte savait qui allait venir.)")
  GAME:WaitFrames(15)
  say("Determined", "Une voie de plus.[pause=25] Et beaucoup plus de questions.")
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
