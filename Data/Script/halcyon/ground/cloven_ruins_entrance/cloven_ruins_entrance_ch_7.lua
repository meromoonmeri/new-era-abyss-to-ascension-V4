--[[
    cloven_ruins_entrance_ch_7.lua

    ARRIVEE AUX RUINES TORDUES — Chapitre 7
    ================================================================
    L'expedition de la guilde touche a sa fin. Le duo (et Ganlon/Shuca
    si presents) arrive devant les ruines ou se cache le premier Cœur
    d'Anima corrompu. La mission : comprendre pourquoi les Cœurs
    faiblissent. La Voix a parle au sommet du Mont — elle guidait vers
    ici.

    GRAMMAIRE APPLIQUEE
    ------------------------------------------------------------------
    1. Le lieu avant les personnages (son, decor, silence).
    2. Constat sensoriel -> reaction affective -> decision d'avancer.
    3. Camera : panoramique du decor, puis retour sur le duo.
    4. Depart en coroutine jointe (marche + fondu + musique).

    PERSONNAGES
    ------------------------------------------------------------------
    hero, partner (obligatoires)
    ganlon (Teammate2), shuca (Teammate3) — presents si expedtion ch5
    terminee avec eux (ce qui est le cas en ch7 normal)

    REGLES
    ------------------------------------------------------------------
    * La Voix ne parle PAS ici (usage restreint, directive boss/Voix).
    * Jamais « Necrozma », « Eternatus », « l'Abime » nommes.
    * Francais idiomatique, texte via Strings/TextData.
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

cloven_ruins_entrance_ch_7 = {}

function cloven_ruins_entrance_ch_7.ArrivalCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- LE LIEU AVANT LES PERSONNAGES.
  -- Silence, puis le vent dans les pierres. Le son monte AVANT l'image.
  GAME:FadeOut(false, 1)
  GAME:MoveCamera(256, 180, 1, false)  -- cadrage sur les ruines
  SOUND:PlayBGM('Desert Ruins.ogg', true)
  GAME:WaitFrames(40)

  -- LE DUO ARRIVE PAR LE SUD.
  GROUND:TeleportTo(hero, 256, 400, Direction.Up)
  GROUND:TeleportTo(partner, 240, 416, Direction.Up)
  if ganlon ~= nil then GROUND:TeleportTo(ganlon, 272, 416, Direction.Up) end
  if shuca ~= nil then GROUND:TeleportTo(shuca, 224, 432, Direction.Up) end

  -- Remontee en file vers les ruines
  local c1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 256, 280, false, 1)
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveToPosition(partner, 240, 296, false, 1)
  end)
  local c3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if ganlon ~= nil then GROUND:MoveToPosition(ganlon, 272, 310, false, 1) end
  end)
  local c4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    if shuca ~= nil then GROUND:MoveToPosition(shuca, 224, 320, false, 1) end
  end)
  local c5 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    GAME:MoveCamera(256, 240, 60, false)
    GAME:FadeIn(40)
  end)
  TASK:JoinCoroutines({c1, c2, c3, c4, c5})
  GAME:WaitFrames(30)

  -- CONSTAT SENSORIEL — le partenaire observe les ruines
  pcall(function() GROUND:CharSetEmote(partner, "notice", 1) end)
  GAME:WaitFrames(8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Les Ruines Tordues...[pause=15] On les voit de loin depuis le camp de base.")
  GAME:WaitFrames(10)
  -- Se tourne vers le héros
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:WaitShowDialogue("De près,[pause=10] c'est encore plus impressionnant.[pause=15] Ces pierres ont des milliers d'années.")

  GAME:WaitFrames(15)

  -- GANLON — le soldat évalue
  if ganlon ~= nil then
    GROUND:CharTurnToCharAnimated(ganlon, partner, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Des marques de griffes sur les piliers.[pause=10] Profondes.[pause=15] Quelque chose de gros vit là-dedans.")
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(ganlon, "notice", 1) end)
    UI:WaitShowDialogue("Et ces veines dorées dans la roche...[pause=10] Elles pulsent.[pause=15] Comme un cœur qui bat.")
    GAME:WaitFrames(15)
  end

  -- SHUCA — l'émotion
  if shuca ~= nil then
    GROUND:CharTurnToCharAnimated(shuca, hero, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Vous le sentez ?[pause=15] Cette pression dans l'air...[pause=10] Comme avant un orage.[pause=15] Mais il n'y a pas de nuages.")
    GAME:WaitFrames(15)
  end

  -- LE HEROS — reaction intérieure
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, "(La Voix au sommet du Mont...[pause=15] Elle parlait de ruines ancestrales.[pause=10] C'est ici que tout a commencé.)", "Worried")

  GAME:WaitFrames(20)

  -- LE PARTENAIRE — décision
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("La guilde nous a envoyés pour comprendre pourquoi les Cœurs d'Anima faiblissent.[pause=15] La réponse est là-dedans.")
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "glowing", 1) end)
  UI:WaitShowDialogue("On est montés au sommet du Mont pour ça.[pause=10] On a traversé le Tunnel pour ça.[pause=15] Alors on entre.")

  GAME:WaitFrames(20)

  -- GANLON — le soldat se prepare
  if ganlon ~= nil then
    GROUND:CharTurnToCharAnimated(ganlon, partner, 4)
    GAME:WaitFrames(4)
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("J'ouvre la marche.[pause=15] Shuca,[pause=5] tu couvres nos arrières.")
    GAME:WaitFrames(10)
  end

  if shuca ~= nil then
    GROUND:CharTurnToCharAnimated(shuca, ganlon, 4)
    GAME:WaitFrames(4)
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Compris.[pause=15] Et...[pause=10] faites attention aux pièges.[pause=10] Ces ruines sont piégées depuis bien plus longtemps que nous.")
    GAME:WaitFrames(15)
  end

  -- DEPART — coroutine jointe (marche + fondu + musique)
  GAME:WaitFrames(10)
  local d1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:MoveInDirection(hero, Direction.Up, 80, false, 2)
  end)
  local d2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:MoveInDirection(partner, Direction.Up, 80, false, 2)
  end)
  local d3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if ganlon ~= nil then
      GROUND:CharAnimateTurnTo(ganlon, Direction.Up, 4)
      GROUND:MoveInDirection(ganlon, Direction.Up, 80, false, 2)
    end
  end)
  local d4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    if shuca ~= nil then
      GROUND:CharAnimateTurnTo(shuca, Direction.Up, 4)
      GROUND:MoveInDirection(shuca, Direction.Up, 80, false, 2)
    end
  end)
  local d5 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(40)
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
  end)
  TASK:JoinCoroutines({d1, d2, d3, d4, d5})
  GAME:WaitFrames(60)

  -- Sortie de la cinematique — le joueur reprend la main
  GAME:CutsceneMode(false)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  end
  GAME:FadeIn(40)
  SOUND:PlayBGM('Desert Ruins.ogg', true)
  GAME:MoveCamera(0, 0, 1, true)
end

-- Action du partenaire au camp
function cloven_ruins_entrance_ch_7.Partner_Action(chara, activator)
  if SV.Chapter7.ClovenRuinsComplete then
    GeneralFunctions.StartConversation(chara,
      "Les veines dorées se sont éteintes quand Regigigas s'est apaisé.[pause=15] Le Cœur bat à nouveau normalement.", "Normal")
  else
    GeneralFunctions.StartConversation(chara,
      "Ces ruines cachent le premier Cœur d'Anima corrompu.[pause=15] La réponse est à l'intérieur.", "Determined")
  end
  GeneralFunctions.EndConversation(chara)
end

-- Action de Ganlon
function cloven_ruins_entrance_ch_7.Ganlon_Action(chara, activator)
  if chara == nil then return end
  if SV.Chapter7.ClovenRuinsComplete then
    GeneralFunctions.StartConversation(chara,
      "Un colosse de pierre qui gardait un Cœur depuis des millénaires...[pause=15] J'ai frappé plus fort que d'habitude. Par respect.", "Normal")
  else
    GeneralFunctions.StartConversation(chara,
      "Les veines dorées pulsent de plus en plus vite.[pause=15] Comme un cœur qui s'emballe.[pause=10] Il faut se dépêcher.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

-- Action de Shuca
function cloven_ruins_entrance_ch_7.Shuca_Action(chara, activator)
  if chara == nil then return end
  if SV.Chapter7.ClovenRuinsComplete then
    GeneralFunctions.StartConversation(chara,
      "Les ruines sont silencieuses maintenant.[pause=15] Un bon silence, cette fois.[pause=10] Celui d'un cœur qui bat droit.", "Happy")
  else
    GeneralFunctions.StartConversation(chara,
      "Cette pression dans l'air...[pause=15] C'est le Cœur qui souffre.[pause=10] Je le sens dans mes antennes.", "Worried")
  end
  GeneralFunctions.EndConversation(chara)
end

return cloven_ruins_entrance_ch_7
