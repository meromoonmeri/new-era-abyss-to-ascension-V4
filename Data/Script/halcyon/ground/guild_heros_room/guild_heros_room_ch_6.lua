--[[
    guild_heros_room_ch_6.lua
    Chapter 6 hero room scenes: Title Card
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_6 = {}


function guild_heros_room_ch_6.ShowTitleCard()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(CH('Teammate1'))
  UI:ResetSpeaker()
  SOUND:StopBGM()
  GAME:WaitFrames(60)
  local coro1 = TASK:BranchCoroutine(function()
    UI:WaitShowTitle("Chapitre 6\n\nLa Forêt Lugubre\n", 20)
    GAME:WaitFrames(180)
    UI:WaitHideTitle(20)
  end)
  --FOND DEDIE AU CHAPITRE 6.
  --Il affichait « Chapter_4 » : le ch6 empruntait l'image du Bosquet
  --Apricorn, alors que la regle impose une image propre a chaque chapitre
  --(« pas de reutilisation d'un meme visuel generique d'un chapitre a
  --l'autre »). Chapter_6 est un rendu de la clairiere de la Foret Lugubre,
  --produit par tools/make_chapter_bg.py depuis les tuiles reelles du jeu
  --et assombri a la meme luminance que les fonds Chapter_1 a 4.
  local coro2 = TASK:BranchCoroutine(function()
    UI:WaitShowBG("Chapter_6", 180, 20)
    GAME:WaitFrames(180)
    UI:WaitHideBG(20)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(120)
  SV.Chapter6.ShowedTitleCard = true
  guild_heros_room_helper.Morning(true)
end


return guild_heros_room_ch_6

function guild_heros_room_ch_6.PostGloomyBedtalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  guild_heros_room_helper.Bedtime(false)
  UI:ResetSpeaker()
  GAME:FadeIn(40)

  SOUND:PlayBGM('Goodnight.ogg', true)
  GAME:WaitFrames(40)

  -- Étape 1 : Constat sensoriel (le silence après la Forêt Lugubre)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue("Quelle journée...[pause=15] Le silence de la Forêt Lugubre résonne encore dans ma tête.")
  UI:WaitShowDialogue("Zarude ne cherchait pas à faire de mal.[pause=15] Il voulait seulement protéger les siens...")
  GAME:WaitFrames(15)

  -- Étape 2 : Réaction affective & réflexion sur le duel Dazzling
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue("Et le duel contre la Team Dazzling ![pause=15] Adagio a enfin cessé de nous appeler 'les petits'.")
  UI:WaitShowDialogue("Mais ce que Penticus a dit sur cette équipe aux yeux d'or qui pose des questions sur les Cœurs...")
  GAME:WaitFrames(15)

  -- Échange de regards dans la pénombre
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue("Tu ressens toujours cette étrange sensation ?[pause=15] Cette impression que ton passé est lié à tout ça ?")
  GAME:WaitFrames(15)

  GeneralFunctions.HeroDialogue(hero, "(...Oui.[pause=15] Plus nous approchons des Cœurs régionaux,[pause=10] plus je sens que quelque chose de grand sommeille.)", "Worried")
  GeneralFunctions.HeroDialogue(hero, "(Mais quoi qu'il arrive,[pause=10] je ne suis pas seul.[pause=15] Nous ferons face ensemble.)", "Determined")
  GAME:WaitFrames(15)
  GeneralFunctions.DoAnimation(hero, "Nod")
  GAME:WaitFrames(15)

  -- Étape 3 : Décision d'agir
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue("C'est ça ![pause=15] Demain,[pause=10] nous serons prêts à relever n'importe quel défi.")
  UI:WaitShowDialogue("Bonne nuit,[pause=10] " .. hero:GetDisplayName() .. ".")
  GAME:WaitFrames(30)

  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:WaitFrames(30)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GAME:WaitFrames(120)

  SOUND:FadeOutBGM(90)
  GAME:FadeOut(false, 90)

  SV.Chapter6.FinishedBedtimeCutscene = true
  SV.TemporaryFlags.MorningAddress = true
  SV.TemporaryFlags.MorningWakeup = true
  GeneralFunctions.EndOfDay()
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end

