--[[
    cloven_ruins_midpoint_ch_7.lua

    RELAIS DES RUINES TORDUES — Chapitre 7 (enrichi)
    ================================================================
    Le relais mi-donjon est un moment de respiration avant le boss.
    Le duo (et Ganlon/Shuca) fait le point sur ce qu'ils ont vu.
    Les veines dorees dans les murs sont de plus en plus visibles
    et de plus en plus inquietantes.

    GRAMMAIRE : constat → interpretation → decision d'avancer.
    Chaque personnage a sa lecture propre de ce qu'il voit.

    DUREE CIBLE : ~100 dialogues, ~5 minutes de jeu.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.RelayScenes'

cloven_ruins_midpoint_ch_7 = {}

--------------------------------------------------------------------
-- ARRIVEE AU RELAIS — premiere fois (enrichie)
--------------------------------------------------------------------
function cloven_ruins_midpoint_ch_7.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 212, 456, Direction.Up)
  GROUND:TeleportTo(partner, 180, 456, Direction.Up)
  if ganlon ~= nil then GROUND:TeleportTo(ganlon, 244, 470, Direction.Up) end
  if shuca ~= nil then GROUND:TeleportTo(shuca, 148, 470, Direction.Up) end
  GAME:MoveCamera(196, 400, 1, false)

  GAME:FadeIn(40)
  SOUND:PlayBGM('In the Depths of the Pit.ogg', true)
  GAME:WaitFrames(30)

  -- Le partenaire observe l'esplanade
  pcall(function() GROUND:CharSetEmote(partner, "notice", 1) end)
  GAME:WaitFrames(10)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Attends...[pause=15] le sol est plat, ici.[pause=20] Taillé.[pause=15] Quelqu'un a NIVELÉ cette esplanade au milieu des ruines.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Et là, regarde ![pause=20] Un rocher de Kangourex.[pause=15] Intact.[pause=20] Pas une fissure, alors que tout le reste s'effondre autour.")

  GAME:WaitFrames(15)

  -- Le heros — pensee
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, "(Les bâtisseurs de ces ruines ont voulu que cet endroit survive.[pause=20] Pourquoi celui-ci et pas le reste ?)", "Worried")

  GAME:WaitFrames(15)

  -- Le partenaire — les veines
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Tu as vu les veines dorées dans la pierre, en descendant ?[pause=20] Elles convergent toutes vers le bas...[pause=15] vers ce que la guilde appelle le Cœur.")
  GAME:WaitFrames(15)

  -- Ganlon — le soldat evalue
  if ganlon ~= nil then
    GROUND:CharTurnToCharAnimated(ganlon, partner, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("J'ai compté trois types de pièges différents depuis l'entrée.[pause=25] Dalles à pression, fléchettes empoisonnées, et...[pause=20] des trucs que je n'ai jamais vus.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Des dalles qui s'effondrent APRÈS ton passage.[pause=25] Comme si les ruines ne voulaient pas qu'on revienne en arrière.")
    GAME:WaitFrames(15)
    pcall(function() GROUND:CharSetEmote(ganlon, "notice", 1) end)
    UI:WaitShowDialogue("Mais ici...[pause=20] rien.[pause=25] Pas un piège dans un rayon de vingt mètres.[pause=20] C'est voulu.")
    GAME:WaitFrames(15)
  end

  -- Shuca — le physique
  if shuca ~= nil then
    GROUND:CharTurnToCharAnimated(shuca, hero, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Vous le sentez ?[pause=20] L'air est...[pause=15] différent ici.[pause=20] Plus chaud.[pause=15] Comme si quelque chose respirait en dessous de nous.")
    GAME:WaitFrames(15)
    pcall(function() GROUND:CharSetEmote(shuca, "sweatdrop", 1) end)
    UI:WaitShowDialogue("Mes antennes vibrent.[pause=20] Pas de peur — d'excitation.[pause=25] Comme avant un orage, mais... sous la terre.")
    GAME:WaitFrames(15)
  end

  -- Le partenaire — decision
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Déposons ce qui nous encombre et sauvegardons.[pause=25] Passé cette esplanade, je crois que les ruines ne nous laisseront plus faire demi-tour aussi facilement.")
  GAME:WaitFrames(15)

  -- Le heros
  GeneralFunctions.HeroDialogue(hero, "(Le Cœur est juste en dessous.[pause=25] Je le sens aussi.[pause=20] Il bat — mais pas droit.[pause=25] Comme un cœur malade.)", "Worried")

  GAME:WaitFrames(20)

  -- Ganlon — le soldat se prepare
  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Si les ruines ne laissent pas revenir en arrière...[pause=25] alors on avance.[pause=20] C'est la seule direction qui reste.")
    GAME:WaitFrames(10)
  end

  -- Shuca — encouragement
  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Et si les ruines nous empêchent de revenir...[pause=25] c'est peut-être parce qu'elles VEULENT qu'on aille jusqu'au Cœur.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Peut-être qu'elles attendent quelqu'un depuis longtemps.")
    GAME:WaitFrames(15)
  end

  -- Fin de la scene
  GAME:WaitFrames(20)
  GeneralFunctions.PanCamera()
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  end
  GAME:CutsceneMode(false)
end

--------------------------------------------------------------------
-- ARRIVEE REPETEE — visites suivantes
--------------------------------------------------------------------
function cloven_ruins_midpoint_ch_7.RepeatArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le rocher de Kangourex est toujours là.[pause=20] Profitons-en avant de redescendre.")
  GAME:WaitFrames(10)

  if SV.Chapter7.DefeatedRuinsBoss then
    UI:WaitShowDialogue("Depuis que Regigigas s'est apaisé, l'esplanade est plus calme.[pause=25] Les veines brillent doucement — comme un cœur qui respire bien.")
  else
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Les veines pulsent plus fort qu'avant.[pause=20] Le Cœur s'emballe.[pause=25] Il faut se dépêcher.")
  end
end

--------------------------------------------------------------------
-- DIALOGUES DES PNJ AU RELAIS
--------------------------------------------------------------------

-- Partenaire au relais
function cloven_ruins_midpoint_ch_7.Partner_Action(chara, activator)
  if SV.Chapter7.DefeatedRuinsBoss then
    GeneralFunctions.StartConversation(chara,
      "Les veines dorées se sont éteintes quand Regigigas s'est apaisé.[pause=20] Le Cœur bat à nouveau normalement.", "Normal")
  else
    GeneralFunctions.StartConversation(chara,
      "Ces ruines cachent le premier Cœur d'Anima corrompu.[pause=20] La réponse est à l'intérieur.[pause=25] Tout au fond.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

-- Ganlon au relais
function cloven_ruins_midpoint_ch_7.Ganlon_Action(chara, activator)
  if chara == nil then return end
  if SV.Chapter7.DefeatedRuinsBoss then
    GeneralFunctions.StartConversation(chara,
      "Un colosse de pierre qui gardait un Cœur depuis des millénaires...[pause=20] J'ai frappé plus fort que d'habitude.[pause=25] Par respect.", "Normal")
  else
    GeneralFunctions.StartConversation(chara,
      "Les veines dorées pulsent de plus en plus vite.[pause=20] Comme un cœur qui s'emballe.[pause=25] Il faut se dépêcher.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

-- Shuca au relais
function cloven_ruins_midpoint_ch_7.Shuca_Action(chara, activator)
  if chara == nil then return end
  if SV.Chapter7.DefeatedRuinsBoss then
    GeneralFunctions.StartConversation(chara,
      "Les ruines sont silencieuses maintenant.[pause=20] Un bon silence, cette fois.[pause=25] Celui d'un cœur qui bat droit.", "Happy")
  else
    GeneralFunctions.StartConversation(chara,
      "Cette pression dans l'air...[pause=20] C'est le Cœur qui souffre.[pause=25] Je le sens dans mes antennes.[pause=15] Comme une migraine qui ne passe pas.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- SCENE DE DEFAITE — reveil au relais (enrichie)
--------------------------------------------------------------------
function cloven_ruins_midpoint_ch_7.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 172, 344, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 204, 344, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  if ganlon ~= nil then GROUND:TeleportTo(ganlon, 148, 360, Direction.Right) end
  if shuca ~= nil then GROUND:TeleportTo(shuca, 228, 360, Direction.Left) end
  GAME:MoveCamera(188, 336, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  -- Reveil en cascade
  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    if ganlon ~= nil then pcall(function() GROUND:CharSetEmote(ganlon, "notice", 1) end) end
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})
  GAME:WaitFrames(30)

  -- Le partenaire — douleur
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  UI:WaitShowDialogue("Ces ruines...[pause=20] même le sol semblait vouloir qu'on parte.")
  GAME:WaitFrames(14)

  -- Se tourne vers le heros
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les veines dorées dans la pierre...[pause=15] elles BRILLAIENT plus fort à mesure qu'on approchait.[pause=20] Comme un avertissement.")
  GAME:WaitFrames(14)

  -- Ganlon — le soldat analyse
  if ganlon ~= nil then
    GROUND:CharTurnToCharAnimated(ganlon, partner, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Les pièges sont plus denses en profondeur.[pause=25] J'en ai compté le double dans les derniers couloirs.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Mais il y a un schéma.[pause=20] Les pièges protègent le chemin VERS le bas.[pause=25] Pas les chemins de traverse.")
    GAME:WaitFrames(10)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Si on prend les couloirs secondaires, on évite le pire.")
    GAME:WaitFrames(15)
  end

  -- Shuca — le physique
  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Et vous avez senti ?[pause=25] Tout au fond...[pause=20] comme une présence.[pause=25] Quelque chose de GROS qui respire lentement.")
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(shuca, "shock", 1) end)
    UI:WaitShowDialogue("Je crois que le gardien du Cœur est juste derrière la dernière porte.")
    GAME:WaitFrames(15)
  end

  -- Le partenaire — determination
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:WaitShowDialogue("Le Cœur des ruines est tout près, je le sens.[pause=25] Reposons-nous — puis finissons ce qu'on a commencé.")
  GAME:WaitFrames(14)

  -- Le heros
  GeneralFunctions.HeroDialogue(hero, "(Cette fois, on sait à quoi s'attendre.[pause=25] Les pièges, le gardien...[pause=20] On y retourne préparés.)", "Determined")
  GAME:WaitFrames(20)

  -- Fin
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return cloven_ruins_midpoint_ch_7
