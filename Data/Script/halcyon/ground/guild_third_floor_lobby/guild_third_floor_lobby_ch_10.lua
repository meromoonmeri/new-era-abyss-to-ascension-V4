--[[
    guild_third_floor_lobby_ch_10.lua
    Chapter 10 — Pic Céleste : adresse du matin

    ARC NARRATIF
    ------------------------------------------------------------------
    Le chapitre final de l'Arc 1. Trois Cœurs ont été sauvés ou protégés.
    Mais le dernier — celui du Pic Céleste, au sommet du monde connu —
    montre des signes d'une perturbation sans précédent. Et l'Escouade
    Fulgur, la guilde rivale, est déjà partie pour l'atteindre.

    Penticus révèle que le Pic Céleste n'abrite pas un Cœur ordinaire :
    c'est le Cœur le plus ancien, celui que les textes appellent le
    « Premier Souffle ». Si celui-ci est corrompu, tous les autres
    suivront.

    FORESHADOWING : la vision de Necrozma que le héros a eue au ch7
    trouve son écho ici — « ce qui est enfermé doit le rester ». Le Pic
    Céleste est le lieu où cette phrase prendra tout son sens.

    L'ENJEU DE RIVALITE : l'Escouade Fulgur est partie sans prévenir.
    Course contre la montre — qui atteindra le sommet en premier ?
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_10 = {}

function guild_third_floor_lobby_ch_10.CelestialPeakAddress()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
        breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

  GAME:WaitFrames(20)

  -- PENTICUS — l'urgence
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Je vais aller droit au but.[pause=25] L'Escouade Fulgur est partie cette nuit.")
  GAME:WaitFrames(15)

  -- Réaction de la salle
  pcall(function() GROUND:CharSetEmote(growlithe, "exclaim", 1) end)
  GAME:WaitFrames(8)

  UI:WaitShowDialogue("Sans prévenir.[pause=20] Sans demander d'autorisation.[pause=25] Direction : le Pic Céleste.")
  GAME:WaitFrames(20)

  -- ZIGZAGOON
  UI:SetSpeaker(zigzagoon)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Le Pic Céleste ?![pause=20] Mais...[pause=15] c'est le point le plus haut de toute la région !")
  GAME:WaitFrames(15)

  -- PENTICUS — le vrai enjeu
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Exactement.[pause=25] Et c'est là-haut que se trouve le Cœur le plus ancien.")
  GAME:WaitFrames(15)
  GROUND:CharTurnToChar(tropius, noctowl)
  UI:WaitShowDialogue("Phileas va vous expliquer pourquoi c'est si grave.")
  GAME:WaitFrames(20)

  -- PHILEAS — la révélation
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Les textes anciens appellent ce Cœur le « Premier Souffle ».")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("C'est le premier Cœur d'Anima qui ait jamais existé.[pause=30] Celui dont tous les autres découlent.")
  GAME:WaitFrames(20)

  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Si le Premier Souffle est corrompu...[pause=25] tous les autres Cœurs suivront.[pause=30] Un par un.")
  GAME:WaitFrames(25)

  -- AUDINO — l'inquiétude
  pcall(function() GROUND:CharSetEmote(audino, "sweatdrop", 1) end)
  UI:SetSpeaker(audino)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais alors...[pause=20] tout ce qu'on a fait aux Ruines, au Sanctuaire, au Marais...")
  GAME:WaitFrames(15)

  -- PHILEAS — confirme
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Tout cela ne servira à rien si le Premier Souffle tombe.[pause=30] C'est la clé de voûte.")
  GAME:WaitFrames(25)

  -- PENTICUS — la course commence
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Determined")
  GROUND:CharTurnToChar(tropius, hero)
  GAME:WaitFrames(8)
  UI:WaitShowDialogue("L'Escouade Fulgur a une nuit d'avance.[pause=25] Mais ils ne savent pas ce qu'ils cherchent.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Vous, si.")
  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Montez au Pic Céleste.[pause=20] Atteignez le sommet.[pause=25] Et protégez le Premier Souffle.")
  GAME:WaitFrames(25)

  -- LE PARTENAIRE — l'enjeu personnel
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("L'Escouade Fulgur court depuis hier soir ?[pause=20] Parfait.")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "glowing", 1) end)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Ils vont être étonnés de nous voir arriver aussi vite.")
  GAME:WaitFrames(20)

  -- LE HEROS — la vision du ch7 résonne
  GeneralFunctions.HeroDialogue(hero, "(Le Premier Souffle...[pause=25] La voix dans mon rêve disait : « Ce qui est enfermé doit le rester. »[pause=30] C'est lié. J'en suis sûr.)", "Worried")
  GAME:WaitFrames(30)

  -- DEPART DES APPRENTIS
  GAME:WaitFrames(20)
  local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
  local coro2 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
  local coro3 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
  local coro4 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
  local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveFast(snubbull) end)
  local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(audino) end)
  local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveFast(breloom) end)
  local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(girafarig) end)
  local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
  local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
  local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
      GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
      GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
      GAME:GetCurrentGround():RemoveTempChar(tropius) end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro12})

  SV.Chapter10.PeakAddressGiven = true
  SV.TemporaryFlags.MorningAddress = false
  GeneralFunctions.PanCamera()
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

-- Phileas — dialogue post-adresse
function guild_third_floor_lobby_ch_10.Noctowl_Action(chara, activator)
  if SV.Chapter10.PeakAddressGiven and not SV.Chapter10.EnteredPeak then
    GeneralFunctions.StartConversation(chara,
      "Le Pic Céleste est visible depuis n'importe où en ville.[pause=25] Le sentier principal part du nord.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("L'Escouade Fulgur a pris le sentier direct.[pause=25] Mais il existe une autre voie — les contreforts.[pause=30] Plus dure, mais moins surveillée.")
    SV.Chapter10.MissionAccepted = true
    GeneralFunctions.EndConversation(chara)
  elseif SV.Chapter10.DefeatedLugia then
    GeneralFunctions.StartConversation(chara,
      "Lugia...[pause=30] Le Gardien des Cieux.[pause=25] Il a jugé que vous étiez dignes.")
    UI:SetSpeakerEmotion("Sad")
    UI:WaitShowDialogue("Mais ce que vous avez vu là-haut...[pause=25] la vision...[pause=30] Ce n'est que le commencement.")
    GeneralFunctions.EndConversation(chara)
  else
    GeneralFunctions.StartConversation(chara,
      "Le Premier Souffle bat encore.[pause=25] Mais pour combien de temps ?")
    GeneralFunctions.EndConversation(chara)
  end
end

return guild_third_floor_lobby_ch_10
