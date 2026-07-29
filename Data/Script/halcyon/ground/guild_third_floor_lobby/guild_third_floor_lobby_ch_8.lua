--[[
    guild_third_floor_lobby_ch_8.lua
    Chapter 8 — Sanctuaire de Cristal : adresse du matin + brief Phileas

    ARC NARRATIF
    ------------------------------------------------------------------
    Le chapitre 7 s'est terminé sur la Genese racontee par Phileas et
    le premier reve de Necrozma. L'equipe sait maintenant que les Cœurs
    d'Anima existent, qu'ils sont anciens, et que quelque chose les
    corrompt. Penticus annonce qu'un deuxieme Cœur montre des signes
    de faiblesse — celui du Sanctuaire de Cristal, au nord-est.

    Phileas ajoute un detail crucial : le Sanctuaire n'est pas un lieu
    ordinaire. C'est une reserve d'Anima cristallisee — de la memoire
    du monde, figee dans la pierre. Si ce Cœur s'eteint, ce ne sont
    pas seulement les Pokemon de la region qui souffriront : c'est le
    souvenir meme de ce qui etait avant qui disparaîtra.

    TWIST SEME : Phileas mentionne que les textes parlent d'une
    « gardienne » du Sanctuaire — un Pokemon qui veille sur les cristaux
    depuis des siecles. Personne ne sait lequel. (Foreshadowing Diancie.)

    GRAMMAIRE
    ------------------------------------------------------------------
    Memes conventions que guild_third_floor_lobby_ch_7.lua :
    - Penticus (Tropius) ouvre, passe a Phileas (Noctowl)
    - Les apprentis reagissent (emotes, murmures)
    - Le heros et le partenaire sont adresses directement
    - Depart en coroutines jointes
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_8 = {}

function guild_third_floor_lobby_ch_8.CrystalSanctuaryAddress()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
        breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

  GAME:WaitFrames(20)

  -- PENTICUS — les nouvelles sont mauvaises
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mes amis...[pause=20] ce que nous avons appris aux Ruines Tordues est grave.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Le Cœur de notre région faiblit.[pause=25] Mais il n'est pas le seul.")
  GAME:WaitFrames(20)

  -- Regard vers Phileas
  GROUND:CharTurnToChar(tropius, noctowl)
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Phileas a reçu un rapport ce matin.[pause=20] Un autre Cœur montre les mêmes signes.")
  GAME:WaitFrames(25)

  -- PHILEAS — le savant prend le relais
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le Sanctuaire de Cristal.[pause=25] Au nord-est, derrière la cascade de quartz.")
  GAME:WaitFrames(15)

  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Ce lieu est unique.[pause=25] Ce n'est pas seulement un Cœur d'Anima.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("C'est une réserve d'Anima cristallisée.[pause=30] De la mémoire du monde,[pause=15] figée dans la pierre depuis des millénaires.")
  GAME:WaitFrames(20)

  -- Les apprentis réagissent
  pcall(function() GROUND:CharSetEmote(audino, "notice", 1) end)
  GAME:WaitFrames(8)

  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("Si ce Cœur s'éteint,[pause=20] ce ne sont pas seulement les Pokémon de la région qui souffriront.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("C'est le souvenir même de ce qui était avant[pause=15] qui disparaîtra.")
  GAME:WaitFrames(30)

  -- ZIGZAGOON — la question naive
  pcall(function() GROUND:CharSetEmote(zigzagoon, "question", 1) end)
  UI:SetSpeaker(zigzagoon)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Mais...[pause=15] qui a fait ça ?[pause=20] Qui peut corrompre un Cœur ?")
  GAME:WaitFrames(20)

  -- PHILEAS — la réponse qui sème le twist
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Je ne sais pas encore.[pause=25] Mais les textes anciens parlent d'une gardienne.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Un Pokémon qui veille sur les cristaux depuis des siècles.[pause=30] Personne ne sait lequel.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Si cette gardienne est encore en vie,[pause=20] elle sait peut-être ce qui se passe.")
  GAME:WaitFrames(25)

  -- PENTICUS — la mission
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Determined")
  GROUND:CharTurnToChar(tropius, hero)
  GAME:WaitFrames(8)
  UI:WaitShowDialogue("Je n'ai pas besoin de vous demander si vous êtes prêts.[pause=25] Je le vois dans vos yeux.")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le Sanctuaire de Cristal vous attend.[pause=20] Trouvez la gardienne.[pause=25] Et protégez ce Cœur.")
  GAME:WaitFrames(20)

  -- LE PARTENAIRE — détermination
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(partner, "glowing", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On y va.[pause=20] La mémoire du monde, ça se protège.")
  GAME:WaitFrames(20)

  -- LE HEROS — pensée intérieure
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, "(Une gardienne qui veille depuis des siècles...[pause=25] Qui peut bien rester seul aussi longtemps ?)", "Worried")
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

  SV.Chapter8.CrystalAddressGiven = true
  SV.TemporaryFlags.MorningAddress = false
  GeneralFunctions.PanCamera()
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

-- Phileas — dialogue post-adresse, pre-depart
function guild_third_floor_lobby_ch_8.Noctowl_Action(chara, activator)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if SV.Chapter8.CrystalAddressGiven and not SV.Chapter8.EnteredSanctuary then
    GeneralFunctions.StartConversation(chara,
      "Le Sanctuaire de Cristal se trouve derrière la cascade de quartz, au nord-est.[pause=25] Les anciens disaient que l'entrée ne se montre qu'à ceux qui cherchent sans vouloir prendre.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("La gardienne...[pause=20] si elle existe encore,[pause=15] elle ne vous accueillera pas facilement.[pause=25] Soyez patients.")
    SV.Chapter8.MissionAccepted = true
    GeneralFunctions.EndConversation(chara)
  elseif SV.Chapter8.DefeatedDiancie then
    GeneralFunctions.StartConversation(chara,
      "Diancie...[pause=25] Alors c'était elle, la gardienne.[pause=30] Un Pokémon fabuleux, né d'un cristal de Métamorph.")
    UI:SetSpeakerEmotion("Sad")
    UI:WaitShowDialogue("Elle protégeait la mémoire du monde depuis si longtemps qu'elle en avait oublié pourquoi.[pause=30] Merci de lui avoir rappelé.")
    GeneralFunctions.EndConversation(chara)
  else
    GeneralFunctions.StartConversation(chara,
      "Les cristaux du Sanctuaire contiennent des souvenirs que personne d'autre ne porte.[pause=25] Protégez-les.")
    GeneralFunctions.EndConversation(chara)
  end
end

return guild_third_floor_lobby_ch_8
