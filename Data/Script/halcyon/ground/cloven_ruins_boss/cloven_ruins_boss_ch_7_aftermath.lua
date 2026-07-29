--[[
    cloven_ruins_boss_ch_7_aftermath.lua

    APRES LA DEFAITE DE REGIGIGAS — Purification du Coeur d'Anima
    ================================================================
    Le boss est vaincu. Les veines dorees de l'arene changent de
    couleur : le rouge corrompu cede place a un bleu profond et
    stable. Le Coeur bat a nouveau normalement.

    Cette scene est le point culminant du chapitre 7 : la premiere
    purification. Le joueur comprend que les Cœurs PEUVENT etre
    sauves. Mais Regigigas revele quelque chose d'inattendu : la
    corruption n'est pas naturelle. Quelqu'un l'a PROVOQUEE.

    GRAMMAIRE
    ------------------------------------------------------------------
    1. Le corps parle avant la bouche : Regigigas s'apaise (animation,
       veines qui changent), PUIS les personnages reagissent.
    2. Le son precede l'image : un grondement sourd, puis la lumiere
       bleue, puis les mots.
    3. Chaque personnage a sa reaction propre : le partenaire (emotion),
       Ganlon (soldat, constat), Shuca (sensible, physique), le heros
       (pensee interieure qui relie les indices).

    DUREE CIBLE : ~200 dialogues, ~8-10 minutes de jeu.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_aftermath = {}

function cloven_ruins_aftermath.PurificationScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- ================================================================
  -- PHASE 1 : LE COLOSSE S'APAISE
  -- Le corps parle avant la bouche. Regigigas s'immobilise, les
  -- veines dorees changent de couleur. Pas un mot pendant 6 secondes.
  -- ================================================================
  GAME:WaitFrames(40)

  -- Regigigas baisse les bras, s'agenouille lentement
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 224, 168, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)
  GAME:WaitFrames(30)

  -- Les veines dorees changent : du rouge corrompu au bleu pur
  -- (overlay progressif, pas de flash brutal)
  pcall(function()
    local purify = RogueEssence.Content.FiniteOverlayEmitter()
    purify.FadeIn = 120
    purify.TotalTime = 300
    purify.Layer = DrawLayer.Front
    purify.Anim = RogueEssence.Content.BGAnimData("Light_Ball_Blue", 0)
    GROUND:PlayVFX(purify, 224, 200)
  end)

  -- Son : un bourdonnement grave qui monte, puis se stabilise
  pcall(function() SOUND:PlayBattleSE('DUN_Power_Gem') end)
  GAME:WaitFrames(60)

  -- Le sol tremble une derniere fois, puis plus rien
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 3, 20)) end)
  GAME:WaitFrames(40)

  -- Silence. Les veines sont bleues maintenant. Le Coeur bat droit.
  GAME:WaitFrames(60)

  -- ================================================================
  -- PHASE 2 : REACTIONS DE L'EQUIPE
  -- ================================================================

  -- Le partenaire est le premier a parler — emerveille
  pcall(function() GROUND:CharSetEmote(partner, "notice", 1) end)
  GAME:WaitFrames(10)
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("Les veines...[pause=20] Elles sont bleues maintenant.[pause=25] Tu les vois ?")

  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Elles pulsent doucement.[pause=20] Comme un cœur qui respire.[pause=25] Pas comme avant — avant, ça s'emballait.")

  GAME:WaitFrames(20)

  -- Ganlon — le soldat constate
  if ganlon ~= nil then
    GROUND:CharTurnToCharAnimated(ganlon, regigigas, 4)
    GAME:WaitFrames(8)
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Il ne bouge plus.[pause=20] Il ne nous attaque plus.[pause=25] On dirait... qu'il se repose.")
    GAME:WaitFrames(10)
    UI:WaitShowDialogue("Il gardait ce Cœur depuis des millénaires.[pause=25] Il a le droit de souffler un peu.")
    GAME:WaitFrames(15)
  end

  -- Shuca — le physique, l'emotion
  if shuca ~= nil then
    GROUND:CharTurnToCharAnimated(shuca, partner, 4)
    GAME:WaitFrames(6)
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("L'air est différent.[pause=20] Vous le sentez ?[pause=25] Avant, c'était lourd.[pause=15] Maintenant...[pause=20] c'est léger.")
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(shuca, "happy", 2) end)
    UI:WaitShowDialogue("Comme après un orage, quand le ciel se dégage.")
    GAME:WaitFrames(15)
  end

  -- Le heros — pensee interieure qui relie les indices
  GROUND:CharTurnToCharAnimated(hero, regigigas, 4)
  GAME:WaitFrames(8)
  GeneralFunctions.HeroDialogue(hero, "(Le Cœur bat normalement maintenant.[pause=25] Mais ce qui l'a corrompu...[pause=20] ce n'était pas naturel.)", "Worried")

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, "(Les veines ne se corrompent pas toutes seules.[pause=25] Quelqu'un a fait ça.[pause=20] Quelqu'un a TOUCHÉ ce Cœur.)", "Determined")

  GAME:WaitFrames(25)

  -- ================================================================
  -- PHASE 3 : REGIGIGAS PARLE
  -- Le colosse millénaire s'adresse à l'équipe pour la premiere fois.
  -- Voix grave, lente, fatiguée. Il ne remercie pas — il transmet.
  -- ================================================================

  -- Un grondement sourd — Regigigas ouvre les yeux
  pcall(function() SOUND:PlayBattleSE('EVT_Emote_Shock_2') end)
  GAME:WaitFrames(20)

  -- Camera sur Regigigas
  GAME:MoveCamera(224, 180, 40, false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(regigigas)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...")
  GAME:WaitFrames(40)
  UI:WaitShowDialogue("Vous avez...[pause=30] arrêté la douleur.")
  GAME:WaitFrames(20)

  -- L'équipe se tourne vers Regigigas
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  GAME:WaitFrames(10)

  UI:WaitShowDialogue("Je gardais ce Cœur depuis avant que vos ancêtres ne construisent leurs premières pierres.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Des milliers d'années.[pause=30] Sans dormir.[pause=20] Sans oublier.")
  GAME:WaitFrames(25)

  -- Le partenaire, ému
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Des milliers d'années...[pause=25] Seul ?")
  GAME:WaitFrames(15)

  -- Regigigas
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue("Pas seul.[pause=30] Le Cœur battait.[pause=20] C'était une compagnie suffisante.")
  GAME:WaitFrames(20)

  -- La revelation : la corruption n'est pas naturelle
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais un jour...[pause=25] quelque chose est venu.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Pas un Pokémon.[pause=25] Pas un humain.[pause=20] Une OMBRE.")
  GAME:WaitFrames(20)

  -- Reactions de l'equipe
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ganlon ~= nil then pcall(function() GROUND:CharSetEmote(ganlon, "notice", 1) end) end
  GAME:WaitFrames(12)

  UI:WaitShowDialogue("Elle s'est glissée dans les veines.[pause=25] Comme du poison dans le sang.[pause=20] Je n'ai pas pu l'arrêter.")
  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("J'ai lutté.[pause=30] Pendant des mois.[pause=20] Mais la corruption était plus rapide que ma volonté.")
  GAME:WaitFrames(25)

  -- Le heros — la question cruciale
  GROUND:CharTurnToCharAnimated(hero, regigigas, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, "(L'ombre...[pause=25] D'où venait-elle ?[pause=20] Est-ce qu'elle est allée vers d'autres Cœurs ?)", "Determined")

  GAME:WaitFrames(20)

  -- Regigigas — la reponse qui ouvre l'arc 2
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue("Elle venait d'en bas.[pause=30] De très loin en bas.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Et oui...[pause=25] elle n'a pas commencé ici.[pause=20] Elle a commencé partout à la fois.")
  GAME:WaitFrames(25)

  -- Shuca — la peur
  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Partout à la fois...[pause=25] Ça veut dire que les autres Cœurs...")
    GAME:WaitFrames(15)
  end

  -- Regigigas confirme
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue("Sont tous attaqués.[pause=30] En ce moment même.")
  GAME:WaitFrames(30)

  -- ================================================================
  -- PHASE 4 : LE DEPART DE REGIGIGAS
  -- Le colosse se retire — pas une disparition, un adieu.
  -- Il confie la garde du Cœur à l'équipe.
  -- ================================================================

  UI:WaitShowDialogue("Je suis fatigué.[pause=30] Plus fatigué que vous ne pouvez l'imaginer.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Je vais dormir.[pause=25] Pour la première fois depuis des millénaires.")
  GAME:WaitFrames(20)

  -- Le partenaire
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais...[pause=15] si tu dors, qui garde le Cœur ?")
  GAME:WaitFrames(15)

  -- Regigigas regarde l'equipe
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue("Vous.")
  GAME:WaitFrames(40)
  UI:WaitShowDialogue("Vous l'avez purifié.[pause=25] C'est votre responsabilité maintenant.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Pas de garder ce Cœur.[pause=30] De trouver ceux qui font ça aux autres.")
  GAME:WaitFrames(25)

  -- Ganlon — le soldat accepte
  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Compris.[pause=20] On s'en occupe.")
    GAME:WaitFrames(10)
  end

  -- Regigigas — dernier mot
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue("Une dernière chose.")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("L'ombre...[pause=25] elle avait une voix.[pause=20] Elle parlait de « Celui qui dort ».")
  GAME:WaitFrames(20)
  UI:WaitShowDialogue("Je ne sais pas ce que ça veut dire.[pause=30] Mais ça m'a fait peur.[pause=20] Et peu de choses me font peur.")
  GAME:WaitFrames(30)

  -- Regigigas s'endort — fondu lent, pas de flash
  GAME:WaitFrames(20)
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)

  -- Le colosse disparait — pas de PoseGroundAction("Faint") !
  pcall(function() GROUND:Hide('Regigigas') end)
  GAME:WaitFrames(30)

  -- ================================================================
  -- PHASE 5 : RETOUR AU RELAIS — l'equipe remonte
  -- ================================================================

  GAME:MoveCamera(224, 240, 40, false)
  GAME:FadeIn(40)
  SOUND:PlayBGM('Mt. Travail.ogg', true)
  GAME:WaitFrames(30)

  -- Le partenaire — le poids de la mission
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("« Celui qui dort. »[pause=25] Encore un mystère.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Mais au moins, on a une direction maintenant.[pause=25] Les autres Cœurs sont attaqués.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On va les protéger.[pause=20] Tous.")
  GAME:WaitFrames(20)

  -- Le heros — pensee finale
  GeneralFunctions.HeroDialogue(hero, "(Une ombre venue d'en bas.[pause=25] Des Cœurs attaqués partout à la fois.[pause=20] Et une voix qui parle de « Celui qui dort ».)", "Worried")
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, "(Ce n'est pas un accident.[pause=25] C'est un plan.[pause=20] Et on est au milieu.)", "Determined")

  GAME:WaitFrames(30)

  -- Ganlon — pragmatique
  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("On racontera tout à Penticus en rentrant.[pause=25] Il faut qu'il sache.")
    GAME:WaitFrames(10)
  end

  -- Shuca — le detail qui humanise
  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Et on pourra dire qu'on a VU Regigigas.[pause=25] En vrai.[pause=20] Personne ne va nous croire.")
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(shuca, "happy", 2) end)
    UI:WaitShowDialogue("Ganlon va passer trois jours à le raconter à tout le monde.")
    GAME:WaitFrames(10)
  end

  -- Ganlon — pique
  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Deux jours maximum.[pause=25] Trois si Penticus pose des questions.")
    GAME:WaitFrames(15)
  end

  -- Sortie — marche vers le nord en coroutine jointe
  GAME:WaitFrames(20)
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
    GAME:WaitFrames(50)
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
  end)
  TASK:JoinCoroutines({d1, d2, d3, d4, d5})
  GAME:WaitFrames(60)

  -- Flag de fin
  SV.Chapter7.DefeatedRuinsBoss = true
  SV.Chapter7.SawAnimaCoreCorruption = true
  SV.Chapter7.ClovenRuinsComplete = true

  GAME:CutsceneMode(false)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  end
  GAME:FadeIn(40)
  GAME:MoveCamera(0, 0, 1, true)
end

return cloven_ruins_aftermath
