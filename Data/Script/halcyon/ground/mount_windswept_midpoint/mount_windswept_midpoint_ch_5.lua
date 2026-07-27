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
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')

  if SV.Chapter5.MountMiniBossLost or SV.Chapter5.MountGuardianLost then
    -- Apres une defaite : regroupes pres du rocher de Kangourex.
    if almotz ~= nil then GROUND:TeleportTo(almotz, 950, 390, Direction.Left) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 1010, 390, Direction.Left) end
  else
    -- Repos ordinaire : Almotz pres d'un feu de camp, Hyko en poste au bord est.
    if almotz ~= nil then GROUND:TeleportTo(almotz, 340, 460, Direction.Up) end
    if hyko ~= nil then GROUND:TeleportTo(hyko, 1060, 360, Direction.Left) end
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
function mount_windswept_midpoint_ch_5.Hyko_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le passage vers le sommet est ouvert,[pause=10] wouf ![pause=0] Je l'ai consigné en triple exemplaire.", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Un pour le Maître de Guilde,[pause=10] un pour les archives,[pause=10] un pour...[pause=0] bon,[pause=10] le troisième est pour moi.[pause=0] Souvenir personnel.")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Ne perdons pas espoir,[pause=10] wouf ![pause=0] Un revers n'est pas une déroute !", "Determined")
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue("...C'est ce que dit le manuel,[pause=10] en tout cas.[pause=0] Page quarante-deux.[pause=0] Je l'ai relu trois fois cette nuit pour y croire.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Le manuel a toujours raison.[pause=0] Préparons-nous correctement,[pause=10] et le manuel gagnera.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Wouf...[pause=0] Vous sentez cette odeur ?[pause=0] L'air du sommet est différent.[pause=0] Plus...[pause=10] chargé.", "Worried")
    UI:WaitShowDialogue("Mon flair ne se trompe jamais.[pause=0] Enfin,[pause=10] rarement.[pause=0] Une fois,[pause=10] j'ai confondu un Chartor avec un rocher chaud,[pause=10] mais c'était un cas limite.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Ce que je veux dire,[pause=10] c'est :[pause=10] restez groupés là-haut.[pause=0] Quoi qu'il y ait au sommet,[pause=10] on l'affrontera ensemble.")
  else
    GeneralFunctions.StartConversation(chara, "Poste d'observation établi,[pause=10] wouf ![pause=0] De là,[pause=10] je vois toute la sortie est du canyon.", "Normal")
    UI:WaitShowDialogue("Ces barrières et ces tentes sont solides.[pause=0] Du travail de guilde,[pause=10] du vrai.[pause=0] On reconnaît les nœuds réglementaires.")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Un jour,[pause=10] c'est moi qui formerai les recrues aux nœuds réglementaires.[pause=0] C'est mon deuxième rêve.[pause=0] Le premier étant d'avoir ma propre patrouille,[pause=10] évidemment.")
  end
  GeneralFunctions.EndConversation(chara)
end

--------------------------------------------------------------------
-- Almotz (Zigzaton)
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.Almotz_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  if chara == nil then return end

  if SV.Chapter5.MountGuardianDefeated then
    GeneralFunctions.StartConversation(chara, "Le sommet...[pause=0] on y est presque ![pause=0] J'ai le ventre qui fait des nœuds,[pause=10] et pas de faim pour une fois.", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Quand tout ça sera fini,[pause=10] il faudra que quelqu'un m'explique ce qu'on est vraiment venus chercher ici.[pause=0] Parce que j'ai suivi,[pause=10] hein,[pause=10] mais j'ai pas tout compris.")
  elseif SV.Chapter5.MountGuardianLost or SV.Chapter5.MountMiniBossLost then
    GeneralFunctions.StartConversation(chara, "Brrr...[pause=0] Entre le vent et les plumes d'acier,[pause=10] je ne sais pas ce qui pique le plus.", "Pain")
    UI:SetSpeakerEmotion("Determined")
    UI:WaitShowDialogue("Mais j'abandonne pas.[pause=0] Chez nous,[pause=10] on dit :[pause=10] «[pause=5] Le champ ne se laboure pas tout seul.[pause=5] »[pause=0] Bon,[pause=10] ça n'a rien à voir,[pause=10] mais ça me motive.")
  elseif SV.Chapter5.MountMiniBossDefeated then
    GeneralFunctions.StartConversation(chara, "Vous avez vu la vue,[pause=10] depuis la crête ?[pause=0] On voyait la steppe,[pause=10] le tunnel,[pause=10] et même Metano tout au fond !", "Happy")
    UI:WaitShowDialogue("Ma maison est quelque part là-dedans.[pause=0] Toute petite,[pause=10] d'ici.[pause=0] Toute ma famille dans un point minuscule.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("C'est drôle...[pause=0] plus on monte,[pause=10] plus j'ai l'impression de comprendre pourquoi je suis parti.[pause=0] Pour que le point minuscule reste tranquille.")
  else
    GeneralFunctions.StartConversation(chara, "Ils ont pensé à tout ici :[pause=10] des feux,[pause=10] des réserves,[pause=10] des tentes...[pause=0] Il ne manque qu'une marmite !", "Normal")
    UI:WaitShowDialogue("J'ai vérifié dans les pots,[pause=10] là-bas.[pause=0] Vides.[pause=0] TOUS vides.[pause=0] Quel gâchis de pots.")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Heureusement,[pause=10] j'ai gardé trois Baies de secours.[pause=0] Enfin...[pause=10] deux.[pause=0] Enfin...[pause=10] vous en voulez une ?[pause=0] Dépêchez-vous avant que je change d'avis.")
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
  local hyko = CH('Teammate2')
  local almotz = CH('Teammate3')
  if hyko == nil or almotz == nil then GAME:FadeIn(20) return end

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:AddMapStatus("darkness")

  local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)
  GAME:GetCurrentGround().Decorations[0].Anims:Add(
    RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(830, 372)))

  GROUND:TeleportTo(hero, 804, 340, Direction.DownRight)
  GROUND:TeleportTo(partner, 868, 340, Direction.DownLeft)
  GROUND:TeleportTo(hyko, 804, 416, Direction.UpRight)
  GROUND:TeleportTo(almotz, 868, 416, Direction.UpLeft)
  GAME:MoveCamera(836, 376, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(50)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Demain,[pause=10] le sommet.[pause=0] La fin de l'expédition.[pause=0] Quoi qu'il y ait là-haut.")

  GAME:WaitFrames(20)

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Vous savez pourquoi je suis venu,[pause=10] moi ?[pause=0] Pas pour la gloire.[pause=0] Pas pour la lumière.[pause=0] Pour la prime de mission.")
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("...C'est ce que je raconte,[pause=10] en tout cas.[pause=0] La vérité,[pause=10] c'est que je voulais savoir si le petit gars de la ferme pouvait faire ça.[pause=0] Et il peut.[pause=0] On dirait bien qu'il peut.")

  UI:SetSpeaker(hyko)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Moi,[pause=10] je suis venu parce que le Maître de Guilde l'a demandé,[pause=10] wouf.[pause=0] Un garde suit son chef.[pause=0] C'est la procédure.")
  GAME:WaitFrames(15)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("...Non.[pause=0] Ce n'est pas toute la vérité non plus.[pause=0] Je suis venu parce que le Maître de Guilde a PEUR.[pause=0] Je le vois.[pause=0] Depuis le départ.")
  UI:WaitShowDialogue("Et un garde ne laisse pas son chef porter sa peur tout seul.[pause=0] Ça,[pause=10] ce n'est écrit dans aucun manuel.[pause=0] Mais ça devrait,[pause=10] wouf.")

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

  UI:SetSpeaker(almotz)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Alors bonne nuit,[pause=10] l'équipe.[pause=0] Et...[pause=10] merci.[pause=0] Pour tout ce chemin.[pause=0] Voilà.[pause=0] C'est dit.[pause=0] Le premier qui en reparle demain aura affaire à moi.")

  UI:SetSpeaker(hyko)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowDialogue("Consigné dans le rapport,[pause=10] wouf.[pause=0] «[pause=5] Vingt-deux heures :[pause=10] Almotz a dit merci.[pause=5] »[pause=0] C'est officiel maintenant.[pause=0] Impossible d'y échapper.")

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
  GAME:FadeIn(40)
end



--------------------------------------------------------------------
-- Réveil après une défaite au-delà du checkpoint (vague 8).
-- Le duo revient à lui près du Terminal, ranimé par ses réserves.
--------------------------------------------------------------------
function mount_windswept_midpoint_ch_5.WipedCutscene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, 960, 360, Direction.Left)
  if partner ~= nil then GROUND:TeleportTo(partner, 992, 368, Direction.Right) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(976, 352, 1, false)

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
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(30)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Olala...[pause=20] c'était dur.[pause=10] C'était vraiment, VRAIMENT dur.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue("Les Crêtes...[pause=10] le vent là-haut ne souffle pas, il MORD.[pause=20] Une rafale nous a soulevés comme des feuilles.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue("Le camp de base a tenu, lui.[pause=20] Regarde, les tentes n'ont pas bougé.[pause=10] On est en sécurité ici.")
  GAME:WaitFrames(14)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue("On attend que le vent tombe...[pause=20] et on reprend l'ascension.[pause=10] Le sommet ne s'éloignera pas.")
  GAME:WaitFrames(14)
  GAME:WaitFrames(20)
  if partner ~= nil then AI:EnableCharacterAI(partner) end
  GAME:CutsceneMode(false)
  GAME:FadeIn(1)
end

return mount_windswept_midpoint_ch_5
