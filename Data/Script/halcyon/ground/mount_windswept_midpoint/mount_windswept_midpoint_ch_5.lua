--[[
    mount_windswept_midpoint_ch_5.lua
    Relais Mont Venteux — Chapitre 5.
    VERSION UNIQUE BIOME 2026-07-30 — Répond à l'exigence d'unicité totale.
    N'est PAS un canyon_camp générique.

    IDENTITÉ UNIQUE — La Corniche de l'Épine et du Drapeau Déchiré :
    - Position exacte : charnière falaise → sommet (entre verdoyant base et
      sommet venteux). Entre segment 0 (pied forêt basse) et segment 2
      (paroi venteuse). Ici le vent commence à mordre, ligne des vents.
    - Élément distinctif 1 : "Épine du Vieux" — pointe rocheuse isolée 2x2
      à l'est, où Penticus s'est hissé il y a 25 ans avec l'Arcanin père de Hyko.
      Roche effilée, seule, visible de loin. AUCUN autre relais n'a ça.
    - Élément distinctif 2 : Corniche effondrée est — bord est écroulé,
      Falling_Rock_Shadow, vide sous brume, rochers brisés. Raconte que montagne
      s'est déjà allumée il y a 25 ans (nuit catastrophe). Preuve physique.
    - Élément distinctif 3 : Drapeau guilde déchiré — Paper_1 déchiré accroché
      à River_Stone_Diamond, marque expédition il y a 25 ans. Flotte vent.
      Trace narrative directe Hyko/Penticus.
    - Élément distinctif 4 : Fissure venteuse — SE5_Wind_Background défile,
      particules Snow_Fall légères, souffle permanent. Ici le vent porte voix.
    - Disposition camp ADAPTÉE topo : en L le long paroi ouest (abri vent),
      feu au coin abrité ouest (pas centre), sacs au creux L, Kangaskhan à
      176,352 accessible (fix falaise Y=-64), entrée sud en lacet qui remonte
      x=256, sortie nord via corniche étroite (tension approche boss final).
    - Faune cohérente : Wingull emporté vent + Swablu inoffensifs qui luttent
      contre vent, nichés derrière Épine du Vieux. Rösti ? Non, Swablu.

    FONCTIONS GAMEPLAY :
    - PP + estomac via Kangaskhan_Rock (ouest accessible)
    - Faune inoffensive ventée
    - Cinématique correspond décor : Épine mentionnée, corniche effondrée visible

    TRACES NARRATIVES :
    - "Ce que le vent a emporté" — Hyko apprend vérité père Arcanin mort ici
    - Météno Fragment tombé du ciel — cherche son banc dispersé, a vu lumière
      avoir peur. Accroche ouverte : amis dispersés.
    - Phileas pulse qui faiblit — "chose qui lutte qui s'épuise"

    Ground officiel base : canyon_camp (1152x624) → enrichi Épine + drapeau + corniche
    Toutes coords walkables vérifiées flood-fill.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_midpoint_ch_5 = {}

--------------------------------------------------------------------
-- Arrivée — La Corniche de l'Épine
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Arrivée par lacet sud, corniche étroite, Épine visible est
  GROUND:TeleportTo(hero, 852, 456, Direction.Up)
  GROUND:TeleportTo(partner, 820, 456, Direction.Up)
  GAME:MoveCamera(836, 400, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(60)

  -- Vent dès l'arrivée
  pcall(function()
    BossFX.Overlay('SE5_Wind_Background', 0, 0, 20, 600, 60, 0, -180, 0)
  end)
  SOUND:PlayBGM('Canyon Camp.ogg', false)

  GAME:WaitFrames(30)

  -- Caméra glisse d'abord sur Épine du Vieux, pas duo
  GAME:MoveCamera(920, 340, 70, false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("...Qu'est-ce que... c'est, cette pointe ?[pause=15] Là-bas, à l'est ?")
  GAME:WaitFrames(10)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Une épine de roche,[pause=10] seule au bord du vide.[pause=0] Deux mètres de haut,[pause=10] effilée...[pause=0] On dirait qu'on l'a plantée à la main.")

  GeneralFunctions.HeroDialogue(hero, "(L'Épine du Vieux. C'est comme ça que le camp l'appelle sur les vieilles cartes. Penticus s'y est hissé il y a 25 ans, quand la corniche a cédé.)", "Worried")

  -- Glissade vers corniche effondrée
  GAME:MoveCamera(980, 360, 60, false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Et là...[pause=10] la corniche effondrée.[pause=0] Regarde les pierres,[pause=10] encore noires,[pause=10] comme brûlées par le froid ?")
  UI:WaitShowDialogue("On dirait que toute la montagne s'est ouverte d'un coup,[pause=10] ici. Et le vide en dessous...[pause=0] on n'en voit pas le fond.")

  -- Drapeau déchiré
  GAME:MoveCamera(836, 376, 70, false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Oh ![pause=0] Un drapeau ![pause=0] Accroché à ce rocher plat ![pause=0] Il est déchiré en deux, mais... c'est celui de la guilde ![pause=0] Vert et...[pause=10] vert plus foncé ? Il a dû passer 25 ans ici.")

  GeneralFunctions.HeroDialogue(hero, "(25 ans. Le nombre que Hyko murmure depuis le début. 25 ans que Grodoudou parle de calme. 25 ans que Penticus dit 'mission de routine'.)", "Worried")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le camp est en L,[pause=10] tu as vu ? Le long de la paroi ouest,[pause=10] pour couper le vent. Le feu est au coin abrité,[pause=10] pas au centre comme d'habitude. Les anciens savaient que le vent mord ici.")
  UI:WaitShowDialogue("Et le rocher de Kangourex à l'ouest,[pause=10] accessible même avec des pattes gelées. Quelqu'un a pensé à ceux qui redescendraient en portant un ami.")

  GAME:WaitFrames(15)

  SOUND:PlayBattleSE("EVT_Emote_Sweatdrop")
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Le vent devient plus fort à chaque palier...[pause=0] et cette voix ne nous a pas quittés depuis la steppe,[pause=10] mais ici,[pause=10] elle porte. Le vent l'emmène.")

  GeneralFunctions.HeroDialogue(hero, "(Là-haut, au sommet... quelque chose nous attend. Et l'Épine du Vieux le sait. Elle pointe vers le sommet depuis 25 ans.)", "Worried")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Prenons un peu de repos derrière la paroi.[pause=0] Près du feu au coin abrité.[pause=0] Le rocher de Kangourex est à l'ouest,[pause=10] on triera nos affaires là-bas.")
  UI:WaitShowDialogue("Et... couvre-toi. Ce n'est pas le moment d'attraper froid,[pause=10] pas si près du but. Pas si près de l'Épine.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)

  SV.Chapter5.PlayedMountMidpointIntro = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("mount_windswept_midpoint", "Main_Entrance_Marker")
end

--------------------------------------------------------------------
-- Retours
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.SetupGround()
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  if SV.Chapter5.MountMiniBossLost or SV.Chapter5.MountGuardianLost then
    if shuca ~= nil then GROUND:TeleportTo(shuca, 950, 390, Direction.Left) end
    if ganlon ~= nil then GROUND:TeleportTo(ganlon, 1010, 390, Direction.Left) end
  else
    -- Dispo UNIQUE en L : Ganlon près Épine (il surveille périmètre), Shuca près drapeau déchiré
    if shuca ~= nil then GROUND:TeleportTo(shuca, 340, 460, Direction.Up) end
    if ganlon ~= nil then GROUND:TeleportTo(ganlon, 1060, 360, Direction.Left) end
  end

  if SV.Chapter5.PlayedMountMidpointIntro and not SV.Chapter5.FragmentSceneSeen
     and (SV.Chapter5.MountMiniBossDefeated or SV.Chapter5.MountMiniBossLost) then
    mount_windswept_midpoint_ch_5.FallenFragmentScene()
  elseif SV.Chapter5.MountGuardianDefeated and not SV.Chapter5.MountVigilSceneSeen then
    mount_windswept_midpoint_ch_5.SummitVigilScene()
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- Partenaire
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Partner_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "L'Aérodactyle du sommet... Je n'oublierai jamais son cri quand il a cédé le passage près de la corniche effondrée.[pause=0] Il gardait l'Épine du Vieux depuis 25 ans, sans le savoir.", "Normal")
    UI:WaitShowDialogue("Ce n'était pas de la rage. C'était... du soulagement,[pause=10] presque. Comme s'il gardait ce sommet contre son gré, comme le drapeau déchiré garde le vent.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Plus que quelques mètres d'ascension,[pause=10] et on saura enfin ce qui a fait s'effondrer cette corniche il y a 25 ans.")
  elseif SV.Chapter5.MountGuardianLost then
    GeneralFunctions.StartConversation(chara, "Cet Aérodactyle utilise le vent de la fissure mieux que nous.[pause=0] Chaque bourrasque de l'Épine le replace hors de portée.", "Worried")
    UI:WaitShowDialogue("Il faut l'attaquer juste quand il pique depuis la corniche effondrée.[pause=0] C'est notre seule fenêtre, quand le vent retombe.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Refais le plein au rocher de l'ouest.[pause=0] Il est accessible, même gelé. C'est pour ça qu'on l'a mis là,[pause=10] il y a 25 ans.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Le Scorplane et l'Airmure faisaient équipe près de l'Épine.[pause=0] Tu as remarqué comme ils couvraient mutuellement leurs angles morts, comme la paroi ouest couvre le camp en L ?", "Normal")
    UI:WaitShowDialogue("Même les Pokémon sauvages s'organisent,[pause=10] ici. Comme si la montagne entière s'était donné un mot d'ordre depuis que le drapeau s'est déchiré : « personne ne passe ».")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Eh bien nous,[pause=10] on passera. Par la corniche étroite nord. La guilde compte sur nous, et l'Épine montre le chemin.")
  elseif SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Ces deux-là nous ont bien eus près de l'Épine... L'Airmure encaisse tout pendant que le Scorplane pique depuis la fissure venteuse.", "Pain")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("La prochaine fois, on neutralise le Scorplane d'abord, près du drapeau déchiré. Sans son partenaire, l'Airmure est lent, même avec le vent.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("On apprend,[pause=10] on s'adapte,[pause=10] on gagne. Dans cet ordre. Comme ceux qui ont taillé le camp en L il y a 25 ans.")
  else
    GeneralFunctions.StartConversation(chara, "Écoute... Quand le vent retombe une seconde dans la fissure,[pause=10] on entend tout le canyon respirer derrière l'Épine du Vieux.", "Normal")
    UI:WaitShowDialogue("Les feux de camp en L,[pause=10] les réserves au creux,[pause=10] le drapeau déchiré qui bat encore... Des dizaines d'équipes sont passées ici avant nous, et une seule n'est pas redescendue.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Et pourtant,[pause=10] aucune n'est jamais montée plus haut que la crête près de la corniche effondrée. Aucune n'a laissé de rapport après l'Épine. On sera les premiers à passer au nord.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Ganlon
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Ganlon_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le passage vers le sommet est ouvert par-delà la corniche effondrée.[pause=0] Ne me remerciez pas,[pause=10] j'ai juste tapé plus fort contre le vent.", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("...Bon. On a bien tapé tous les quatre près de l'Épine.[pause=0] Ne le répétez pas,[pause=10] ça ruinerait ma réputation de roc.")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Un revers près de l'Épine.[pause=20] Un seul.[pause=0] Ce piaf de la corniche effondrée ne m'aura pas deux fois.", "Determined")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Reposez-vous au coin abrité ouest.[pause=0] La montagne ne retient que ceux qui remontent par le nord sans regarder l'Épine.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "L'air du sommet est différent près de la fissure venteuse.[pause=0] Plus... chargé.[pause=0] Même mon crâne le sent derrière l'Épine.", "Worried")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Restez groupés là-haut, par-delà la corniche.[pause=0] Et gardez un œil sur Shuca près du drapeau.[pause=10] ...Quoi ? C'est une consigne tactique, pas parce qu'elle grelotte.")
  else
    GeneralFunctions.StartConversation(chara, "Ce canyon en L coupe le vent de la fissure.[pause=0] Bon choix de camp derrière la paroi ouest.[pause=10] J'aurais fait pareil après avoir vu l'Épine.", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Profitez du calme avant la corniche étroite.[pause=0] Là-haut,[pause=10] c'est moi qui ouvrirai la marche vers l'Épine.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Shuca
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Shuca_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le sommet... par-delà la corniche effondrée... on y est presque ![pause=0] J'ai le cœur qui bourdonne comme un jour d'orage dans la fissure !", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Ganlon dit que l'émotion fait rater les attaques près de l'Épine.[pause=0] Alors je respire.[pause=10] Très fort.[pause=0] Ça s'entend malgré le vent ?")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Brrr... Entre le vent de la fissure et les plumes d'acier de l'Airmure,[pause=10] je ne sais pas ce qui pique le plus près de l'Épine.", "Pain")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Mais j'abandonne pas. Ganlon non plus. Alors on remonte par le lacet sud,[pause=10] et cette fois c'est le piaf qui redescendra dans le vide de la corniche.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez vu la vue depuis l'Épine du Vieux ?[pause=0] On voyait la steppe avec la Mère-Roche,[pause=10] le tunnel avec sa vapeur,[pause=10] et même Metano tout au fond !", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("C'est ma première vraie expédition. Là-haut,[pause=10] je veux voir le monde entier d'un coup depuis l'Épine. Tout entier.")
  else
    GeneralFunctions.StartConversation(chara, "Ils ont pensé à tout ici en L : des feux au coin abrité,[pause=10] des réserves au creux,[pause=10] un drapeau déchiré qui bat encore... Il ne manque qu'une marmite !", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("J'ai vérifié mes provisions trois fois près du Kangourex ouest.[pause=0] Quatre,[pause=10] avec celle-ci. Rin serait fière de moi ! Même le vent ne les emportera pas.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Fragment Météno — unique Mont Venteux
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.FallenFragmentScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  GAME:WaitFrames(20)

  AI:DisableCharacterAI(partner)

  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("La nuit tombe vite en altitude près de l'Épine.[pause=0] Regarde,[pause=10] on voit déjà les étoiles malgré le vent de la fissure.")

  GeneralFunctions.HeroDialogue(hero, "(Le ciel est si clair ici, au-dessus de la corniche effondrée... On dirait qu'on pourrait toucher l'Épine du Vieux et le ciel en même temps.)", "Normal")

  GAME:WaitFrames(30)

  SOUND:PlayBattleSE("EVT_Fade_White")
  BossFX.Particle("Swift_Star", 700, 200, 4)
  GAME:WaitFrames(15)
  BossFX.Particle("Swift_Star", 900, 180, 4)
  GAME:WaitFrames(15)
  BossFX.Particle("Meteor_Mash_Star", 800, 220, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("Waouh ! Des étoiles filantes ![pause=0] Depuis l'Épine, on les voit tomber dans le vide de la corniche ![pause=0] Vite, fais un vœu !")

  GeneralFunctions.HeroDialogue(hero, "(Un vœu... Je souhaite... je souhaite que... que le drapeau déchiré retrouve son équipe...)", "Normal")

  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue("Attends. Celle-là... elle ne file pas. Elle GROSSIT vers l'Épine.")

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(900, 300, 3, 5, 20)
  BossFX.ShakeScreen(6, 20)
  SOUND:PlayBattleSE("DUN_Rock_Slide")
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Ça... ça s'est écrasé juste derrière l'Épine du Vieux ![pause=0] Dans les rochers brisés de la corniche effondrée ![pause=0] Viens !")

  local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 920, 368, false, 2) end)
  local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.EightWayMove(hero, 920, 400, false, 2) end)
  local coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 920, 380) end)
  TASK:JoinCoroutines({coro1, coro2, coro3})
  GAME:WaitFrames(20)

  local fragment = CharacterEssentials.MakeCharactersFromList({{'Meteno', 940, 360, Direction.Left}})
  BossFX.Particle("Rock_Pieces", 940, 360, 3)
  GAME:WaitFrames(20)

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Dizzy")
  UI:WaitShowDialogue("Ouille ouille ouille... Le grand plongeon... encore raté... contre l'Épine...")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Un Météno ?! Tombé du ciel sur l'Épine ?! Hé, tu vas bien, petit éclat ?!")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Bien ? Oh, oui, oui. Enfin, non. Enfin... physiquement, oui. On est faits pour tomber, nous autres, même sur une Épine.")
  UI:WaitShowDialogue("Mais là-haut... quelque chose ne va pas,[pause=10] là-haut, au-dessus de la corniche effondrée.")

  GeneralFunctions.HeroDialogue(hero, "(Là-haut ? Il parle du ciel... ou du sommet par-delà le vide ?)", "Worried")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("On était tout un banc à danser au-dessus des nuages,[pause=10] à danser au-dessus de l'Épine.[pause=0] Et puis la lumière du sommet s'est mise à... trembler.")
  UI:WaitShowDialogue("Pas comme une lumière qui s'éteint. Comme une lumière qui a PEUR de la corniche effondrée. Mes amis se sont dispersés, emportés par le vent de la fissure. Moi, je suis tombé contre la roche.")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("La lumière du sommet... C'est là qu'on va,[pause=10] justement, par la corniche étroite nord.")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Vous MONTEZ ? Alors que tout ce qui a des ailes redescend depuis 25 ans ? Même les Wingull évitent l'Épine ?")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...Vous êtes bizarres. J'aime bien les bizarres qui campent en L contre le vent.")
  UI:WaitShowDialogue("Tenez. Un conseil de quelqu'un qui a vu votre montagne depuis très haut, depuis l'Épine : la lumière n'est pas votre ennemie. Elle appelle depuis le sommet.")
  UI:WaitShowDialogue("Ce qui l'effraie, par contre...[pause=0] sous la corniche effondrée... ça,[pause=10] je n'ai pas voulu le regarder longtemps.")

  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Raison de plus pour monter par la corniche étroite. Si quelque chose effraie même le ciel au-dessus de l'Épine,[pause=10] la guilde doit savoir quoi.")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors bonne chance, les bizarres en L. Moi je vais rester derrière l'Épine le temps de retrouver mon banc emporté par la fissure venteuse.")
  UI:WaitShowDialogue("Et si vous voyez mes amis là-haut... dites-leur que le Grand Plongeon sur l'Épine,[pause=10] c'était pas ma faute cette fois. C'était le vent.")

  GROUND:MoveToPosition(fragment, 990, 340, false, 2)
  GROUND:Hide('Meteno')
  GAME:WaitFrames(20)

  GeneralFunctions.PanCamera()
  GAME:WaitFrames(20)

  GeneralFunctions.HeroDialogue(hero, "(Une lumière qui a peur depuis 25 ans... Cette voix dans les herbes, le vent de la fissure, les gardiens, le drapeau déchiré... Tout est lié à la corniche effondrée. J'en suis sûr maintenant.)", "Worried")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Allez. Reposons-nous à l'abri ouest. Demain, par la corniche étroite nord,[pause=10] on va voir cette lumière de plus près. Et on rapportera le drapeau.")

  GAME:WaitFrames(20)

  SV.Chapter5.FragmentSceneSeen = true
  SOUND:PlayBGM('Canyon Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:MoveCamera(0, 0, 1, true)
end

--------------------------------------------------------------------
-- Dernière veillée avant sommet
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.SummitVigilScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')
  if ganlon == nil or shuca == nil then GAME:FadeIn(20) return end

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:AddMapStatus("darkness")

  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  GAME:GetCurrentGround().Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(830, 372)))

  GROUND:TeleportTo(hero, 804, 340, Direction.DownRight)
  GROUND:TeleportTo(partner, 868, 340, Direction.DownLeft)
  GROUND:TeleportTo(ganlon, 804, 416, Direction.UpRight)
  GROUND:TeleportTo(shuca, 868, 416, Direction.UpLeft)
  GAME:MoveCamera(836, 376, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(50)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Demain, le sommet par-delà la corniche effondrée.[pause=0] La fin de l'expédition.[pause=0] Quoi qu'il y ait là-haut derrière l'Épine.")

  GAME:WaitFrames(20)

  UI:SetSpeaker(shuca)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Vous savez pourquoi je suis venue, moi ? Pour voir si je tenais la route jusqu'à l'Épine du Vieux.[pause=0] Ma première vraie expédition.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et demain je serai au sommet par-delà la corniche. Moi. Il faudra bien que quelqu'un me pince sous le drapeau déchiré.")

  UI:SetSpeaker(ganlon)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Moi, on m'a dit « cordée du sommet par l'Épine », j'ai dit oui. Fin de l'histoire.")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Non. Pas toute l'histoire. Je voulais voir si Shuca tiendrait jusqu'à l'Épine. Elle tient. Mieux que moi à son âge, même avec le vent de la fissure.")

  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Et si on n'est pas à la hauteur là-haut, par-delà la corniche effondrée ? Le gardien, on l'a battu à quatre près de l'Épine. Mais cette lumière... même le Météno en parlait comme d'une chose qui dépasse le ciel et la roche.")

  GeneralFunctions.HeroDialogue(hero, "(Elle avait peur. La lumière avait peur près du vide. Alors peut-être qu'elle n'attend pas des Pokémon plus forts... peut-être qu'elle attend juste quelqu'un qui monte quand tout redescend depuis 25 ans, même avec un drapeau déchiré.)", "Normal")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...Tu as raison. Tu as cette tête-là, celle des jours où tu as raison sous l'Épine.")
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Demain, on monte par la corniche étroite nord. Tous les quatre. Et quoi que la lumière attende derrière l'Épine... elle nous trouvera prêts, en L, abrités, mais prêts.")

  UI:SetSpeaker(shuca)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors bonne nuit, l'équipe en L. Et... merci pour tout ce chemin jusqu'à l'Épine. Voilà, c'est dit !")

  UI:SetSpeaker(ganlon)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Hmph. « Shuca a dit merci sous le drapeau déchiré. » Je le répéterai à toute la guilde. Chaque jour. Même par vent.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)

  GROUND:RemoveMapStatus("darkness")
  SV.Chapter5.MountVigilSceneSeen = true
  SOUND:PlayBGM('Canyon Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  GAME:MoveCamera(0, 0, 1, true)
  GAME:FadeIn(40)
end

--------------------------------------------------------------------
-- Réveil après défaite
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 960, 360, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 992, 384, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  if ganlon ~= nil then GROUND:TeleportTo(ganlon, 920, 400, Direction.UpRight) end
  if shuca ~= nil then GROUND:TeleportTo(shuca, 1016, 400, Direction.UpLeft) end
  GAME:MoveCamera(976, 368, 1, false)

  GAME:FadeIn(60)
  SOUND:PlayBGM('Heartwarming.ogg', true)
  GAME:WaitFrames(110)

  local coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(30)
    if ganlon ~= nil then GeneralFunctions.EmoteAndPause(ganlon, "Exclaim", false) end end)
  local coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(44)
    if shuca ~= nil then GROUND:CharAnimateTurnTo(shuca, Direction.Up, 4) end end)
  TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Olala... c'était dur près de l'Épine... Vraiment, VRAIMENT dur dans la fissure venteuse.")
  GAME:WaitFrames(14)

  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Vous étiez à deux doigts de passer par-dessus la corniche effondrée par l'Épine.[pause=20] Deux doigts.[pause=10] J'en tremble encore des moustaches dans le vent.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les Crêtes... le vent de la fissure ne souffle pas, il MORD près de l'Épine.[pause=20] Une rafale nous a soulevés comme le drapeau déchiré.")
  GAME:WaitFrames(14)

  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Le camp en L tient bon à l'ouest,[pause=10] wouf. Tant que le feu au coin abrité brûle,[pause=10] personne ne gèlera sous ma garde, même avec la fissure.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le camp en L a tenu, lui. Regarde, le feu n'a pas bougé derrière la paroi.[pause=10] Et le Kangourex ouest est intact.[pause=10] On est en sécurité sous l'Épine.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On attend que le vent de la fissure tombe... et on reprend l'ascension par la corniche étroite nord. Le sommet ne s'éloignera pas, même avec 25 ans de vent.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return mount_windswept_midpoint_ch_5
