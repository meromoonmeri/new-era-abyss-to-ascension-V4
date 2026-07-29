--[[
    guild_third_floor_lobby_ch_9.lua
    Chapter 9 — Marais de l'Oubli : adresse du matin

    ARC NARRATIF
    ------------------------------------------------------------------
    Après Diancie et le Fragment de Cristal, l'équipe sait que les
    Cœurs peuvent être sauvés. Mais un troisième Cœur faiblit — celui
    du Marais de l'Oubli, au sud. Les rapports parlent d'une brume
    épaisse, de Pokémon qui errent sans but, et surtout... du Cercle
    du Suaire, aperçu rôdant autour du marais.

    Penticus est inquiet : pour la première fois, la menace n'est plus
    seulement naturelle. Quelqu'un SABOTE les Cœurs. Et l'équipe va
    devoir affronter cette réalité.

    FORESHADOWING : le Cercle du Suaire est nommé pour la première fois
    en adresse du matin. Le joueur a déjà croisé des indices (brume,
    silhouettes) dans les chapitres précédents.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_third_floor_lobby_ch_9 = {}

function guild_third_floor_lobby_ch_9.ForgottenMarshAddress()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig,
        breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

  GAME:WaitFrames(20)

  -- PENTICUS — le ton a changé. Ce n'est plus une mission, c'est une alerte.
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Cette fois, ce n'est pas un rapport qui m'inquiète.[pause=25] C'est un silence.")
  GAME:WaitFrames(15)
  UI:WaitShowDialogue("Le village de Roseaux, au sud du marais, n'a plus donné signe de vie depuis cinq jours.")
  GAME:WaitFrames(20)

  -- Réactions des apprentis
  pcall(function() GROUND:CharSetEmote(audino, "shock", 1) end)
  GAME:WaitFrames(8)

  UI:WaitShowDialogue("Et ce n'est pas tout.[pause=25] Nos éclaireurs ont vu quelque chose dans la brume.")
  GAME:WaitFrames(15)
  GROUND:CharTurnToChar(tropius, noctowl)
  UI:WaitShowDialogue("Phileas ?")
  GAME:WaitFrames(20)

  -- PHILEAS — la menace prend forme
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Trois silhouettes.[pause=25] Toujours les mêmes.[pause=20] Toujours dans la brume.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Les textes anciens les appellent le Cercle du Suaire.[pause=30] Des Pokémon qui... éteignent les choses.")
  GAME:WaitFrames(20)

  -- ZIGZAGOON — la peur
  pcall(function() GROUND:CharSetEmote(zigzagoon, "shock", 1) end)
  UI:SetSpeaker(zigzagoon)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Ils...[pause=15] ils éteignent les Cœurs ?[pause=25] C'est EUX qui font ça ?")
  GAME:WaitFrames(20)

  -- PHILEAS — prudent, il ne conclut pas
  UI:SetSpeaker(noctowl)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Je ne sais pas encore.[pause=25] Mais le Cœur du Marais faiblit, et eux sont là.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("La coïncidence me paraît difficile à ignorer.")
  GAME:WaitFrames(25)

  -- PENTICUS — la mission, plus grave que les précédentes
  UI:SetSpeaker(tropius)
  UI:SetSpeakerEmotion("Determined")
  GROUND:CharTurnToChar(tropius, hero)
  GAME:WaitFrames(8)
  UI:WaitShowDialogue("Cette mission est différente des autres.[pause=25] Vous ne partez pas seulement sauver un Cœur.")
  GAME:WaitFrames(10)
  UI:WaitShowDialogue("Vous allez peut-être rencontrer ceux qui les détruisent.")
  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Soyez prudents.[pause=20] Et si vous les croisez...[pause=25] ne les affrontez pas seuls.")
  GAME:WaitFrames(25)

  -- LE PARTENAIRE — courage malgré la peur
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Le Cercle du Suaire...[pause=20] J'aime pas ce nom.")
  GAME:WaitFrames(10)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Mais le Marais a un Cœur qui se noie.[pause=25] On n'a pas le choix.")
  GAME:WaitFrames(20)

  -- LE HEROS — détermination silencieuse
  GeneralFunctions.HeroDialogue(hero, "(Le Cercle du Suaire...[pause=25] Ceux qui éteignent.[pause=20] Je veux comprendre pourquoi.)", "Determined")
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

  SV.Chapter9.MarshAddressGiven = true
  SV.TemporaryFlags.MorningAddress = false
  GeneralFunctions.PanCamera()
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

-- Phileas — dialogue post-adresse
function guild_third_floor_lobby_ch_9.Noctowl_Action(chara, activator)
  if SV.Chapter9.MarshAddressGiven and not SV.Chapter9.EnteredMarsh then
    GeneralFunctions.StartConversation(chara,
      "Le Marais de l'Oubli est au sud.[pause=25] Un lieu que les Pokémon évitent instinctivement.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Et maintenant, le Cercle du Suaire y rôde.[pause=25] Trouvez le Cœur avant qu'ils ne l'éteignent.")
    SV.Chapter9.MissionAccepted = true
    GeneralFunctions.EndConversation(chara)
  elseif SV.Chapter9.DefeatedMegaBlastoise then
    GeneralFunctions.StartConversation(chara,
      "Laggron...[pause=25] Un gardien millénaire, seul dans la vase.[pause=30] Il a tenu bon malgré tout.")
    UI:SetSpeakerEmotion("Sad")
    UI:WaitShowDialogue("Mais le Cercle du Suaire était bien là.[pause=25] Ce n'était pas une coïncidence.")
    GeneralFunctions.EndConversation(chara)
  else
    GeneralFunctions.StartConversation(chara,
      "Le Marais cache des choses que la lumière ne touche plus.[pause=25] Avancez avec prudence.")
    GeneralFunctions.EndConversation(chara)
  end
end

return guild_third_floor_lobby_ch_9
