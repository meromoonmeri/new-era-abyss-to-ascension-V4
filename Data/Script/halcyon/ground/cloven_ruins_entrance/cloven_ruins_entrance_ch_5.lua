--[[
    cloven_ruins_entrance_ch_5.lua
    Chapitre 5 (Finale de l'Expédition) : Le Campement des Ruines Fendues
    Modèle : searing_tunnel_entrance / mount_windswept_entrance
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

cloven_ruins_entrance_ch_5 = {}

function cloven_ruins_entrance_ch_5.SetupGround()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- Placement esthétique du campement d'expédition devant la porte souterraine (670, 618)
  local npcs = CharacterEssentials.MakeCharactersFromList({
    {"Tropius",   660, 680, Direction.Down},
    {"Noctowl",   696, 688, Direction.DownLeft},
    {"Flygon",    632, 704, Direction.Right},
    {"Altaria",   712, 704, Direction.Left},
    {"Shinx",     640, 736, Direction.UpRight},
    {"Phanpy",    664, 736, Direction.Up},
    {"Vulpix",    696, 736, Direction.UpLeft},
    {"Mareep",    616, 760, Direction.Right},
    {"Zorua",     640, 760, Direction.UpRight},
    {"Growlithe", 680, 760, Direction.UpLeft},
    {"Zigzagoon", 712, 760, Direction.Left},
    {"Natu",      736, 736, Direction.Left} -- Plum en faction sur le flanc Est
  })

  cloven_ruins_entrance_ch_5.CAMP_NPCS = npcs
  for _, c in ipairs(npcs) do
    GAME:GetCurrentGround():AddTempChar(c)
  end
end

function cloven_ruins_entrance_ch_5.ArrivalCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  UI:ResetSpeaker()

  -- Étape 1 : Établir le lieu d'abord (Silence, résonance de la roche antique)
  GAME:MoveCamera(670, 690, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(40)
  SOUND:PlayBGM("In the Depths of the Pit.ogg", true)
  GAME:WaitFrames(30)

  cloven_ruins_entrance_ch_5.SetupGround()
  local penticus = cloven_ruins_entrance_ch_5.CAMP_NPCS[1]
  local phileas  = cloven_ruins_entrance_ch_5.CAMP_NPCS[2]
  local hyko     = cloven_ruins_entrance_ch_5.CAMP_NPCS[3]

  GROUND:TeleportTo(hero, 656, 720, Direction.Up)
  GROUND:TeleportTo(partner, 680, 720, Direction.Up)

  -- Étape 2 (Grammaire) : Concret -> Abstrait -> Décision
  -- 1. Constat sensoriel : la roche froide, la fin du vent
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue("Le vent est tombé d'un coup...[pause=15] L'air est si calme sous ces voûtes de pierre.")
  GAME:WaitFrames(10)

  -- 2. Réaction affective & poids de l'histoire (Penticus)
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Nous y sommes.[pause=15] Les Ruines Fendues... le dernier palier de notre grande expédition.")
  UI:WaitShowDialogue("Ces pierres ont résisté aux siècles pour abriter le Cœur régional le plus profond.")
  GAME:WaitFrames(15)

  -- Réactivité systématique en cascade : regards vers l'entrée
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(10)

  UI:SetSpeaker(phileas)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Le campement est établi.[pause=15] Reposez-vous bien ce soir, car la descente s'annonce longue.")
  GAME:WaitFrames(20)

  SV.Chapter5.ReachedClovenRuins = true
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

function cloven_ruins_entrance_ch_5.MorningCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  UI:ResetSpeaker()

  cloven_ruins_entrance_ch_5.SetupGround()
  local penticus = cloven_ruins_entrance_ch_5.CAMP_NPCS[1]
  local phileas  = cloven_ruins_entrance_ch_5.CAMP_NPCS[2]
  local hyko     = cloven_ruins_entrance_ch_5.CAMP_NPCS[3]

  GROUND:TeleportTo(hero, 656, 720, Direction.Up)
  GROUND:TeleportTo(partner, 680, 720, Direction.Up)

  GAME:MoveCamera(670, 700, 1, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM("Heartwarming.ogg", true)
  GAME:WaitFrames(30)

  -- Briefing matinal au seuil des Ruines
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Bonjour à tous ![pause=15] C'est le jour solennel de notre descente finale.")
  UI:WaitShowDialogue("Le mystère de ce lieu nous tend les bras.[pause=15] Explorez ensemble, veillez les uns sur les autres !")
  GAME:WaitFrames(10)

  -- Cri de ralliement d'expédition
  UI:SetSpeaker(penticus)
  GeneralFunctions.SetEmotion("Shouting")
  UI:WaitShowDialogue("Expédition de Metano...[pause=15] En avant !")
  GAME:WaitFrames(15)

  local cheer = {}
  for i, c in ipairs({partner, hero}) do
    cheer[#cheer+1] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(i * 3)
      GeneralFunctions.Hop(c, "Idle", 8, 20, 0, false)
    end)
  end
  TASK:JoinCoroutines(cheer)
  GAME:WaitFrames(20)

  SV.TemporaryFlags.MorningAddress = false
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

-- Dialogues interactifs des membres au camp
function cloven_ruins_entrance_ch_5.Tropius_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "Le Cœur régional des Ruines Fendues est le joyau de notre expédition.[pause=15] Soyez prudents.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance_ch_5.Noctowl_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "J'ai inspecté les cartes anciennes.[pause=15] Ces ruines descendent très profondément.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function cloven_ruins_entrance_ch_5.Flygon_Action(chara, activator)
  GeneralFunctions.StartConversation(chara, "Je reste ici pour coordonner le relais.[pause=15] Allez-y, je veille sur l'entrée.", "Normal")
  GeneralFunctions.EndConversation(chara)
end

return cloven_ruins_entrance_ch_5
