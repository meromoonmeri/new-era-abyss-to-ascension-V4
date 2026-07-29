--[[
    mount_windswept_midpoint_ch_5.lua
    Relais Mont Venteux — Chapitre 5.
    Contenu : arrivee initiale, etats de retour, dialogues a variantes pour le
    partenaire / Hyko / Almotz, cinematique contemplative du Fragment tombe du
    ciel (adaptation New Era du motif "Minior: The Fallen Star" — prefigure le
    phenomene lumineux du sommet SANS nommer Necrozma ni l'Abime).
    Ground officiel : canyon_camp (1152x624). Marker central (836,384).
    Toutes les coordonnees utilisees ici sont verifiees walkables.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_midpoint_ch_5 = {}

--------------------------------------------------------------------
-- Arrivee initiale
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.FirstArrival()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Ground officiel canyon_camp (1152x624 px) : arrivée près du marker central (836,384).
  GROUND:TeleportTo(hero, 852, 416, Direction.Up)
  GROUND:TeleportTo(partner, 820, 416, Direction.Up)
  GAME:MoveCamera(836, 376, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Canyon Camp.ogg', false)

  GAME:WaitFrames(30)

  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 48, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 48, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("On a passé la première moitié de la montagne.[pause=0] Ce canyon nous protège du vent,[pause=10] pour l'instant.")
  UI:WaitShowDialogue("Un camp entier,[pause=10] taillé dans la roche...[pause=0] Les équipes qui ont balisé cette route ne plaisantaient pas.")

  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Le vent devient plus fort à chaque palier...[pause=0] et cette voix ne nous a pas quittés depuis la steppe.")
  UI:WaitShowDialogue("Là-haut,[pause=10] au sommet...[pause=0] j'ai l'impression que quelque chose nous attend.[pause=0] Je ne sais pas si c'est bon ou mauvais signe.")

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, "(Le sommet est encore loin.[pause=0] Une pause ne fera pas de mal.)", "Normal")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Prenons un peu de repos près des feux.[pause=0] On repart quand on est prêts.")
  UI:WaitShowDialogue("Et...[pause=10] couvre-toi.[pause=0] Ce n'est pas le moment d'attraper froid,[pause=10] pas si près du but.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)

  SV.Chapter5.PlayedMountMidpointIntro = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("mount_windswept_midpoint", "Main_Entrance_Marker")
end

--------------------------------------------------------------------
-- Mise en place des retours
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.SetupGround()
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  if SV.Chapter5.MountMiniBossLost or SV.Chapter5.MountGuardianLost then
    -- Apres une defaite : regroupes pres du rocher de Kangourex.
    if shuca ~= nil then GROUND:TeleportTo(shuca, 950, 390, Direction.Left) end
    if ganlon ~= nil then GROUND:TeleportTo(ganlon, 1010, 390, Direction.Left) end
  else
    -- Repos ordinaire : Shuca pres d'un feu de camp, Ganlon en poste au bord est.
    if shuca ~= nil then GROUND:TeleportTo(shuca, 340, 460, Direction.Up) end
    if ganlon ~= nil then GROUND:TeleportTo(ganlon, 1060, 360, Direction.Left) end
  end

  -- Cinematique contemplative du Fragment (une seule fois, apres le mini-boss).
  if SV.Chapter5.PlayedMountMidpointIntro and not SV.Chapter5.FragmentSceneSeen
     and (SV.Chapter5.MountMiniBossDefeated or SV.Chapter5.MountMiniBossLost) then
    mount_windswept_midpoint_ch_5.FallenFragmentScene()
  elseif SV.Chapter5.MountGuardianDefeated and not SV.Chapter5.MountVigilSceneSeen then
    -- Derniere veillee avant le sommet.
    mount_windswept_midpoint_ch_5.SummitVigilScene()
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- Partenaire : variantes selon la progression
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Partner_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "L'Aérodactyle du sommet...[pause=0] Je n'oublierai jamais son cri quand il a cédé le passage.", "Normal")
    UI:WaitShowDialogue("Ce n'était pas de la rage.[pause=0] C'était...[pause=10] du soulagement,[pause=10] presque.[pause=0] Comme s'il gardait ce sommet contre son gré.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Plus que quelques mètres d'ascension,[pause=10] et on saura enfin ce qui rend toute la région si nerveuse.")
  elseif SV.Chapter5.MountGuardianLost then
    GeneralFunctions.StartConversation(chara, "Cet Aérodactyle utilise le vent mieux que nous.[pause=0] Chaque bourrasque le replace hors de portée.", "Worried")
    UI:WaitShowDialogue("Il faut l'attaquer juste quand il pique.[pause=0] C'est notre seule fenêtre.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Refais le plein au rocher.[pause=0] On va lui montrer que la guilde ne recule pas devant un fossile grognon.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Le Scorplane et l'Airmure faisaient équipe.[pause=0] Tu as remarqué comme ils couvraient mutuellement leurs angles morts ?", "Normal")
    UI:WaitShowDialogue("Même les Pokémon sauvages s'organisent,[pause=10] ici.[pause=0] Comme si la montagne entière s'était donné un mot d'ordre :[pause=10] «[pause=5] personne ne passe[pause=5] ».")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Eh bien nous,[pause=10] on passera.[pause=0] La guilde compte sur nous.")
  elseif SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Ces deux-là nous ont bien eus...[pause=0] L'Airmure encaisse tout pendant que le Scorplane pique en traître.", "Pain")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("La prochaine fois,[pause=10] on neutralise le Scorplane d'abord.[pause=0] Sans son partenaire,[pause=10] l'Airmure est lent.")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("On apprend,[pause=10] on s'adapte,[pause=10] on gagne.[pause=0] Dans cet ordre.")
  else
    GeneralFunctions.StartConversation(chara, "Écoute...[pause=0] Quand le vent retombe une seconde,[pause=10] on entend tout le canyon respirer.", "Normal")
    UI:WaitShowDialogue("Les feux de camp,[pause=10] les tentes,[pause=10] les barrières...[pause=0] Des dizaines d'équipes sont passées ici avant nous.")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Et pourtant,[pause=10] aucune n'est jamais montée plus haut que la crête.[pause=0] Aucune n'a laissé de rapport.[pause=0] On sera les premiers.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Hyko (Growlithe)
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Ganlon_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le passage vers le sommet est ouvert.[pause=0] Ne me remerciez pas,[pause=10] j'ai juste tapé plus fort.", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("...Bon.[pause=20] On a bien tapé tous les quatre.[pause=0] Ne le répétez pas,[pause=10] ça ruinerait ma réputation.")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Un revers.[pause=20] Un seul.[pause=0] Ce piaf ne m'aura pas deux fois.", "Determined")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Reposez-vous au lieu de me regarder.[pause=0] La montagne ne retient que ceux qui remontent.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "L'air du sommet est différent.[pause=0] Plus...[pause=10] chargé.[pause=0] Même mon crâne le sent.", "Worried")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Restez groupés là-haut.[pause=0] Et gardez un œil sur Shuca.[pause=10] ...Quoi ?[pause=0] C'est une consigne tactique.")
  else
    GeneralFunctions.StartConversation(chara, "Ce canyon coupe le vent.[pause=0] Bon choix de camp.[pause=10] J'aurais fait pareil.", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Profitez du calme.[pause=0] Là-haut,[pause=10] c'est moi qui ouvrirai la marche.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Almotz (Zigzaton)
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Shuca_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le sommet...[pause=0] on y est presque ![pause=0] J'ai le cœur qui bourdonne comme un jour d'orage.", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Ganlon dit que l'émotion fait rater les attaques.[pause=0] Alors je respire.[pause=10] Très fort.[pause=0] Ça s'entend ?")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Brrr...[pause=0] Entre le vent et les plumes d'acier,[pause=10] je ne sais pas ce qui pique le plus.", "Pain")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Mais j'abandonne pas.[pause=0] Ganlon non plus.[pause=0] Alors on remonte,[pause=10] et cette fois c'est le piaf qui redescendra.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez vu la vue,[pause=10] depuis la crête ?[pause=0] On voyait la steppe,[pause=10] le tunnel,[pause=10] et même Metano tout au fond !", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("C'est ma première vraie expédition.[pause=0] Là-haut,[pause=10] je veux voir le monde entier d'un coup.[pause=0] Tout entier.")
  else
    GeneralFunctions.StartConversation(chara, "Ils ont pensé à tout ici :[pause=10] des feux,[pause=10] des réserves,[pause=10] des tentes...[pause=0] Il ne manque qu'une marmite !", "Normal")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("J'ai vérifié mes provisions trois fois.[pause=0] Quatre,[pause=10] avec celle-ci.[pause=0] Rin serait fière de moi !")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- CINEMATIQUE CONTEMPLATIVE — Le Fragment tombe du ciel
-- Adaptation New Era du motif "Minior : The Fallen Star" : une pluie
-- d'etoiles filantes, puis un eclat qui tombe pres du camp. Un Meteno
-- (Minior) desoriente, un voeu murmure, et un presage du phenomene
-- lumineux du sommet. Necrozma et l'Abime ne sont jamais nommes.
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.FallenFragmentScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  GAME:FadeIn(30)
  GAME:WaitFrames(20)

  AI:DisableCharacterAI(partner)

  -- Nuit qui tombe : la scene se joue au crepuscule.
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("La nuit tombe vite,[pause=10] en altitude.[pause=0] Regarde,[pause=10] on voit déjà les étoiles.")

  GeneralFunctions.HeroDialogue(hero, "(Le ciel est si clair,[pause=10] ici...[pause=0] On dirait qu'on pourrait le toucher.)", "Normal")

  GAME:WaitFrames(30)

  -- Pluie d'etoiles filantes
  SOUND:PlayBattleSE("EVT_Fade_White")
  BossFX.Particle("Swift_Star", 700, 200, 4)
  GAME:WaitFrames(15)
  BossFX.Particle("Swift_Star", 900, 180, 4)
  GAME:WaitFrames(15)
  BossFX.Particle("Meteor_Mash_Star", 800, 220, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue("Waouh ![pause=0] Des étoiles filantes ![pause=0] Vite,[pause=10] fais un vœu !")

  GeneralFunctions.HeroDialogue(hero, "(Un vœu...[pause=0] Je souhaite...[pause=10] je souhaite que...)", "Normal")

  GAME:WaitFrames(20)

  -- L'une d'elles... ne file pas. Elle tombe.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Stunned")
  UI:WaitShowDialogue("Attends.[pause=0] Celle-là...[pause=10] elle ne file pas.[pause=0] Elle GROSSIT.")

  SOUND:PlayBattleSE("EVT_Battle_Flash")
  BossFX.Flash(900, 300, 3, 5, 20)
  BossFX.ShakeScreen(6, 20)
  SOUND:PlayBattleSE("DUN_Rock_Slide")
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Ça...[pause=10] ça s'est écrasé juste derrière les rochers ![pause=0] Viens !")

  -- Deplacement vers le point d'impact (est du camp)
  local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 900, 368, false, 2) end)
  local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.EightWayMove(hero, 900, 400, false, 2) end)
  local coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 900, 380) end)
  TASK:JoinCoroutines({coro1, coro2, coro3})
  GAME:WaitFrames(20)

  -- Le Fragment : un Meteno en forme meteore, sonne
  local fragment = CharacterEssentials.MakeCharactersFromList({{'Meteno', 940, 360, Direction.Left}})
  BossFX.Particle("Rock_Pieces", 940, 360, 3)
  GAME:WaitFrames(20)

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Dizzy")
  UI:WaitShowDialogue("Ouille ouille ouille...[pause=0] Le grand plongeon...[pause=10] encore raté...")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Un Météno ?![pause=0] Tombé...[pause=10] du ciel ?![pause=0] Hé,[pause=10] tu vas bien ?!")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Bien ?[pause=0] Oh,[pause=10] oui,[pause=10] oui.[pause=0] Enfin,[pause=10] non.[pause=0] Enfin...[pause=10] physiquement,[pause=10] oui.[pause=0] On est faits pour tomber,[pause=10] nous autres.")
  UI:WaitShowDialogue("Mais là-haut...[pause=0] quelque chose ne va pas,[pause=10] là-haut.")

  GeneralFunctions.HeroDialogue(hero, "(Là-haut ?[pause=0] Il parle du ciel...[pause=10] ou du sommet ?)", "Worried")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue("On était tout un banc,[pause=10] à danser au-dessus des nuages.[pause=0] Et puis la lumière du sommet s'est mise à...[pause=10] trembler.")
  UI:WaitShowDialogue("Pas comme une lumière qui s'éteint.[pause=0] Comme une lumière qui a PEUR.[pause=0] Mes amis se sont dispersés.[pause=10] Moi,[pause=10] je suis tombé.")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("La lumière du sommet...[pause=0] C'est là qu'on va,[pause=10] justement.")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue("Vous MONTEZ ?[pause=0] Alors que tout ce qui a des ailes redescend ?")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...Vous êtes bizarres.[pause=0] J'aime bien les bizarres.")
  UI:WaitShowDialogue("Tenez.[pause=0] Un conseil de quelqu'un qui a vu votre montagne depuis très,[pause=10] très haut :[pause=0] la lumière n'est pas votre ennemie.[pause=0] Elle appelle.")
  UI:WaitShowDialogue("Ce qui l'effraie,[pause=10] par contre...[pause=0] ça,[pause=10] je n'ai pas voulu le regarder longtemps.")

  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Raison de plus pour monter.[pause=0] Si quelque chose effraie même le ciel,[pause=10] la guilde doit savoir quoi.")

  UI:SetSpeaker(fragment)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors bonne chance,[pause=10] les bizarres.[pause=0] Moi je vais rester par ici le temps de retrouver mon banc.")
  UI:WaitShowDialogue("Et si vous voyez mes amis là-haut...[pause=0] dites-leur que le Grand Plongeon,[pause=10] c'était pas ma faute cette fois.")

  -- Le Fragment roule derriere les rochers
  GROUND:MoveToPosition(fragment, 990, 340, false, 2)
  GROUND:Hide('Meteno')
  GAME:WaitFrames(20)

  -- Conclusion contemplative
  GeneralFunctions.PanCamera()
  GAME:WaitFrames(20)

  GeneralFunctions.HeroDialogue(hero, "(Une lumière qui a peur...[pause=0] Cette voix dans les herbes,[pause=10] le vent,[pause=10] les gardiens...[pause=0] Tout est lié.[pause=10] J'en suis sûr maintenant.)", "Worried")

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Allez.[pause=0] Reposons-nous.[pause=0] Demain,[pause=10] on va voir cette lumière de plus près.")
  GAME:WaitFrames(20)

  SV.Chapter5.FragmentSceneSeen = true
  SOUND:PlayBGM('Canyon Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  --La camera revient au joueur (forme attestee : searing_tunnel:1480).
  GAME:MoveCamera(0, 0, 1, true)
end

--------------------------------------------------------------------
-- CINEMATIQUE DRAMATIQUE — La derniere veillee (lot D)
-- Jouee une fois apres la victoire sur le gardien du sommet : la veille
-- de l'ascension finale. Chacun dit pourquoi il est venu. Le partenaire
-- doute, le heros repond. Le lendemain, c'est le sommet — et la lumiere.
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
  --Index capture a l'ajout : le feu sera retire en fin de scene, lui et
  --rien d'autre (decor en dur en tete de calque, patron event_single:724).
  local fireIdx = GAME:GetCurrentGround().Decorations[0].Anims.Count
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
  UI:WaitShowDialogue("Demain,[pause=10] le sommet.[pause=0] La fin de l'expédition.[pause=0] Quoi qu'il y ait là-haut.")

  GAME:WaitFrames(20)

  UI:SetSpeaker(shuca)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Vous savez pourquoi je suis venue,[pause=10] moi ?[pause=0] Pour voir si je tenais la route.[pause=0] Ma première vraie expédition.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Et demain je serai au sommet.[pause=0] Moi.[pause=0] Il faudra bien que quelqu'un me pince.")

  UI:SetSpeaker(ganlon)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Moi,[pause=10] on m'a dit «[pause=5] cordée du sommet[pause=5] »,[pause=10] j'ai dit oui.[pause=0] Fin de l'histoire.")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Non.[pause=0] Pas toute l'histoire.[pause=0] Je voulais voir si Shuca tiendrait.[pause=0] Elle tient.[pause=0] Mieux que moi à son âge.")

  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Et si on n'est pas à la hauteur,[pause=10] là-haut ?[pause=0] Le gardien,[pause=10] on l'a battu à quatre.[pause=0] Mais cette lumière...[pause=0] même le Météno en parlait comme d'une chose qui dépasse le ciel.")

  GeneralFunctions.HeroDialogue(hero, "(Elle avait peur.[pause=0] La lumière avait peur.[pause=0] Alors peut-être qu'elle n'attend pas des Pokémon plus forts...[pause=10] peut-être qu'elle attend juste quelqu'un qui monte quand tout redescend.)", "Normal")

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("...Tu as raison.[pause=0] Tu as cette tête-là,[pause=10] celle des jours où tu as raison.")
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("Demain,[pause=10] on monte.[pause=0] Tous les quatre.[pause=0] Et quoi que la lumière attende...[pause=10] elle nous trouvera prêts.")

  UI:SetSpeaker(shuca)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors bonne nuit,[pause=10] l'équipe.[pause=0] Et...[pause=10] merci pour tout ce chemin.[pause=0] Voilà,[pause=10] c'est dit !")

  UI:SetSpeaker(ganlon)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Hmph.[pause=20] «[pause=5] Shuca a dit merci.[pause=5] »[pause=0] Je le répéterai à toute la guilde.[pause=0] Chaque jour.")

  GAME:WaitFrames(40)
  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)

  GROUND:RemoveMapStatus("darkness")
  --Le feu de la veillee s'eteint avec la nuit : retire SOUS le fondu, lui
  --seul, pour ne pas en faire un residu permanent au centre du relais.
  pcall(function()
    local anims = GAME:GetCurrentGround().Decorations[0].Anims
    if fireIdx < anims.Count then anims:RemoveAt(fireIdx) end
  end)
  SV.Chapter5.MountVigilSceneSeen = true
  SOUND:PlayBGM('Canyon Camp.ogg', true)
  GAME:CutsceneMode(false)
  AI:EnableCharacterAI(partner)
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  --La camera revient au joueur (forme attestee : searing_tunnel:1480).
  GAME:MoveCamera(0, 0, 1, true)
  GAME:FadeIn(40)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local ganlon = CH('Teammate2')
  local shuca = CH('Teammate3')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  -- Fix audit 2026-07-27 : l'ancienne position du partenaire (992,368)
  -- chevauchait le collider du rocher Kangourex (984,352,24x24). Le duo se
  -- réveille désormais sous la statue, sur des cases libres vérifiées.
  GROUND:TeleportTo(hero, 960, 360, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 992, 384, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  -- Ganlon et Shuca ont porté le duo jusqu'au camp : ils veillent en contrebas.
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
  UI:WaitShowDialogue("Olala...[pause=20] c'était dur.[pause=10] C'était vraiment, VRAIMENT dur.")
  GAME:WaitFrames(14)

  if shuca ~= nil then
    UI:SetSpeaker(shuca)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("Vous étiez à deux doigts de passer par-dessus la corniche.[pause=20] Deux doigts.[pause=10] J'en tremble encore de la laine.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les Crêtes...[pause=10] le vent là-haut ne souffle pas, il MORD.[pause=20] Une rafale nous a soulevés comme des feuilles.")
  GAME:WaitFrames(14)

  if ganlon ~= nil then
    UI:SetSpeaker(ganlon)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Le camp de base tient bon.[pause=0] Et il tiendra.[pause=0] Tant que les feux brûlent,[pause=10] personne ne gèlera pendant ma garde.")
    GAME:WaitFrames(10)
  end

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le camp de base a tenu, lui.[pause=20] Regarde, les tentes n'ont pas bougé.[pause=10] On est en sécurité ici.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On attend que le vent tombe...[pause=20] et on reprend l'ascension.[pause=10] Le sommet ne s'éloignera pas.")
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
