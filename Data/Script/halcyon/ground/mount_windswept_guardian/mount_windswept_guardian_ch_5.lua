--[[ 
    mount_windswept_guardian_ch_5.lua
    Mont Venteux — Gardien du sommet : Tornadus
    Apparition : Descend des nuages d'orage dans un cri perçant, fait trembler la montagne
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.Weather'

mount_windswept_guardian_ch_5 = {}

function mount_windswept_guardian_ch_5.FirstPreBossScene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- POSITIONS RECALEES SUR LA NOUVELLE ARENE (1128x1344 px).
  -- L'ancienne carte faisait 448x504 px : les coordonnees d'origine
  -- (240,328) tombaient dans une POCHE ISOLEE du nouveau decor, hors de
  -- la plateforme de combat. Verifie cellule par cellule contre
  -- obstacles[] : chacune de ces positions est libre ET connexe a la
  -- grande plateforme (zone de 8792 cellules).
  --   depart  y=1216..1248  (sud de la plateforme, sous le cadre camera)
  --   arrivee y=1160..1192  (apres la marche de 56 px vers le nord)
  --   boss    y=1064        (4 cases au-dessus du heros, comme au Creuset)
  -- L'ecart equipe/boss vaut 128 px : tout le monde tient dans l'ecran
  -- de 320x240, exigence explicite du brief d'arene.
  GROUND:TeleportTo(hero, 568, 951, Direction.Up)
  GROUND:TeleportTo(partner, 536, 959, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 600, 959, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 544, 959, Direction.Up) end
  GAME:MoveCamera(560, 1212, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  -- Dramatic silence — wind howling
  SOUND:PlayBGM('Mt. Travail.ogg', false)

  -- TORNADUS EST CREE DES LE DEBUT (CACHE), POUR PARLER AVEC SON PORTRAIT
  -- AVANT MEME D'APPARAITRE. Meme patron que le Creuset (magcargo cree
  -- puis Hide en tete de scene, searing_crucible_ch_5.lua:68-72) : le
  -- locuteur a besoin du GroundChar pour afficher son portrait. Sans
  -- cette creation precoce, les repliques de Tornadus passaient par le
  -- locuteur anonyme uE040 SANS portrait — la « Voix » qui commente a
  -- la place du boss, exactement ce que l'utilisateur demande de
  -- supprimer.
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 568, 440, Direction.Down}
  })
  GROUND:Hide('Tornadus')

  GAME:WaitFrames(40)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 56, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 56, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 56, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 56, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    -- La camera se cale ENTRE l'equipe arrivee (y=1160) et le point ou
    -- Tornadus se posera (y=1064).
    GAME:MoveCamera(560, 1120, 40, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_001']))
  -- "Le sommet...[pause=15] On y est presque."

  GAME:WaitFrames(30)
  -- LE DUO REGARDE LE CIEL. Le sommet, les nuages et la menace sont au
  -- nord (haut de l'ecran) ; ils se tournaient vers Down (sud, bas de
  -- l'ecran), a l'oppose du point d'interet. Correction d'orientation :
  -- « Regarde le ciel » (MWG_002) doit etre accompagne d'un regard vers
  -- le haut.
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_002']))
  -- "Regarde le ciel...[pause=15] Ces nuages ne sont pas normaux."

  GAME:WaitFrames(30)

  GAME:WaitFrames(30)

  -- === STORM GATHERS — VOICE SPEAKS FIRST ===
  SOUND:FadeOutBGM(80)

  -- SOBRIETE (brief, point 4) : l'ancienne version empilait un overlay
  -- Cloudy_Sky plein ecran, deux Sandstorm, deux Ominous_Wind, un
  -- RockFall et deux gerbes de Rock_Pieces. On garde UN changement
  -- meteo simple : le vent se leve, et c'est tout. Le MapStatus
  -- blowing_wind existe dans Data/MapStatus et n'a aucun effet de jeu
  -- (purement visuel), c'est exactement ce qu'on veut ici.
  -- pcall : AddMapStatus echoue en silence si le statut manque.
  pcall(function() GROUND:AddMapStatus('blowing_wind') end)

  GAME:WaitFrames(60)

  -- TORNADUS S'ANNONCE — il parle avant d'apparaitre, sans son portrait
  -- car il est encore cache dans la brume.
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", 0)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_005']))
  -- "Le Souffle qui garde la cime..."

  GAME:WaitFrames(20)
  -- RESPIRATION DU GROUPE : les quatre cherchent d'ou vient la voix, mais
  -- pas au meme instant ni du meme cote. Les decalages (0/6/11/17 frames)
  -- evitent le mouvement d'automate ou tout le monde pivote ensemble.
  local coro_voice1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 3, 4, true, true, false, Direction.UpLeft)
  end)
  local coro_voice2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.UpRight)
  end)
  local coro_voice3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(11)
    if t2 ~= nil then
      GeneralFunctions.LookAround(t2, 2, 5, false, false, false, Direction.UpRight)
    end
  end)
  local coro_voice4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(17)
    if t3 ~= nil then
      -- t3 est en retrait : il se contente de lever la tete, plus lentement.
      GROUND:CharAnimateTurnTo(t3, Direction.UpLeft, 6)
      GAME:WaitFrames(8)
      GROUND:CharAnimateTurnTo(t3, Direction.Up, 6)
    end
  end)
  TASK:JoinCoroutines({coro_voice1, coro_voice2, coro_voice3, coro_voice4})

  --Apres avoir cherche d'ou vient la voix, le duo se fixe vers le haut :
  --la source est dans le ciel, au nord. Sans cela, le LookAround les
  --laissait orientes au hasard quand Tornadus prend la parole.
  pcall(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_006']))
  -- "Toi...[pause=10] Tu savais qu'il était là !"

  GAME:WaitFrames(30)

  -- TORNADUS PARLE (AVANT D'APPARAITRE). Le brief l'exige : « par defaut,
  -- Tornadus porte lui-meme l'integralite de la scene [...] la Voix ne
  -- doit intervenir que si elle est indispensable ». Ces repliques sont
  -- LES SIENNES : conditions d'acces au sommet, adresse directe au duo.
  -- Il n'est pas encore visible : on lui donne la parole sans portrait
  -- car il est encore cache dans la brume.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", 0)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_007']))
  -- "L'ultime gardien de la montagne..."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_008']))
  -- "Si tu triomphes ici..."

  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_009']))
  -- "Échoue... et ton voyage s'arrête ici."

  GAME:WaitFrames(30)

  -- === WHITE FLASH + LIGHTNING STRIKE ===
  -- LE FLASH SUFFIT (brief, point 4 : « un flash, ou un changement
  -- meteo simple, suffit a transmettre l'idee »). On conserve donc le
  -- FlashEmitter, qui EST le dispositif sobre recommande, et on retire
  -- la secousse d'ecran qui l'accompagnait.
  local center_flash = GAME:GetCameraCenter()
  local megaFlash = RogueEssence.Content.FlashEmitter()
  megaFlash.FadeInTime = 2
  megaFlash.HoldTime = 4
  megaFlash.FadeOutTime = 15
  megaFlash.StartColor = Color(255, 255, 255, 0)
  megaFlash.Layer = DrawLayer.Top
  megaFlash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(megaFlash, center_flash.X, center_flash.Y)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  GAME:WaitFrames(10)

  -- === TORNADUS DESCEND DES NUAGES ===
  SOUND:PlayBattleSE('_UNK_EVT_003')

  -- (568, 440) : 4 cases au nord du heros, sur la plateforme, dans le
  -- meme ecran que toute l'equipe. Verifie libre et connexe.
  -- Tornadus a deja ete cree (et cache) en tete de scene pour pouvoir
  -- parler avec son portrait avant d'apparaitre ; il est toujours cache
  -- ici, on ne le recree pas.

  -- LOT 8.3 — l'orage comme presence, le pacte du duo avant l'ultime gardien.
  GAME:MoveCamera(560, 1140, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_030']))
  -- "Cet orage n'est pas un phenomene. Il nous attendait."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_031']), "Determined")
  -- "Quoi qu'il se pose ici, on ne court pas. D'accord ?"
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_032']))
  -- "D'accord. Meme si mes pattes demandent a etre convaincues."
  GAME:WaitFrames(20)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, tornadus.CurrentForm.Species, tornadus.CurrentForm.Form, tornadus.CurrentForm.Skin, tornadus.CurrentForm.Gender)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_033']))
  -- "Celui-ci se souvient d'un ciel sans grimpeurs."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_034']), "Normal")
  -- "Alors il a eu tout le temps de s'habituer a la deception."
  GAME:WaitFrames(20)
  GAME:MoveCamera(560, 1120, 40, false)

  -- === APPARITION SOUS FLASH BLANC (LOT 2) ===
  -- Dispositif volontairement SOBRE : un flash, un impact, et c'est la
  -- REACTION DES PERSONNAGES qui porte la scene — pas un empilement
  -- d'overlays. Les deux Sandstorm, le RockFall et les Rock_Pieces de la
  -- version precedente ont ete retires (brief, point 4).
  SOUND:PlayBGM('Rising Fear.ogg', true)

  -- === LE CIEL REPOND A SA VENUE (climat progressif) ===
  -- L'anneau de nuages TOURNE en permanence (couche 'Nuages' du ground,
  -- 1103 tuiles a 8 frames) : il n'est jamais interrompu. Ce qui change,
  -- c'est la LUMIERE au-dessus de lui, posee par MapStatus.
  --
  -- Pourquoi des MapStatus et pas un echange de planches : il n'existe
  -- AUCUNE API GROUND: pour basculer la visibilite d'une couche de
  -- tuiles (verifie : 38 methodes GROUND: employees dans le mod, aucune
  -- ne touche aux Layers). Une version a trois planches de nuages,
  -- claire / orage / eclair, a donc ete ecrite puis ABANDONNEE : rien
  -- n'aurait pu les commuter en jeu. Les MapStatus, eux, sont poses et
  -- retires a chaud (Weather.lua, prouve).
  --
  -- Trois paliers, du plus leger au plus lourd, pour que l'orage MONTE
  -- au lieu de tomber d'un bloc.
  pcall(function() GROUND:AddMapStatus('blowing_wind') end)   -- 1. le vent se leve
  GAME:WaitFrames(30)
  pcall(function() GROUND:AddMapStatus('gloom') end)          -- 2. le ciel s'assombrit
  GAME:WaitFrames(25)
  pcall(function() GROUND:AddMapStatus('blowing_wind_fast') end)
  pcall(function() GROUND:RemoveMapStatus('blowing_wind') end)
  GAME:WaitFrames(20)

  -- Deux eclairs d'avertissement DERRIERE le pic, avant qu'il ne
  -- paraisse. Weather.Thunder separe la lumiere du son : le flash part,
  -- puis le tonnerre arrive quelques frames plus tard.
  --Les eclairs sont protegés : Weather.Thunder protege deja son propre
  --corps (Weather.lua:146), mais GAME:WaitFrames et PlayBattleSE restent
  --nus a l'interieur. Une erreur ici interromprait la scene AVANT le
  --Weather.Clear final, et les quatre MapStatus suivraient le joueur
  --dans le donjon.
  pcall(function() Weather.Thunder(14) end)
  GAME:WaitFrames(46)
  pcall(function() Weather.Thunder(10) end)
  GAME:WaitFrames(28)

  BossFX.Flash(568, 440, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Tornadus')
  BossFX.Impact(9)
  GROUND:CharSetAnim(tornadus, "Charge", true)

  -- L'orage eclate franchement : la pluie rejoint le vent et la nuee.
  pcall(function() GROUND:AddMapStatus('heavy_rain') end)

  GAME:WaitFrames(15)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  -- Trois eclairs derriere lui, espaces IRREGULIEREMENT : un orage
  -- cadence au metronome sonne mecanique (Weather.lua:166).
  pcall(function() Weather.StormLoop(3, 70) end)

  -- LE SOUFFLE TOUCHE TOUT LE MONDE — EN CASCADE.
  -- C'est le defaut signale : « pas tous les pokemon presents reagissent,
  -- ils sont trop immobiles, se retournent pas quand Tornadus est la ».
  -- Les quatre encaissent desormais, chacun a son rythme et selon son
  -- caractere. Le decalage 0/6/13/21 frames donne la respiration du
  -- groupe exigee par les regles de mise en scene ; personne ne reagit
  -- « a la meme vitesse ni de la meme facon ».
  GAME:WaitFrames(20)
  local coro_push1 = TASK:BranchCoroutine(function()
    -- Le partenaire est le plus expose : il recule et encaisse.
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(partner, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
    BossFX.Impact(12)
  end)
  local coro_push2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(hero, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
  end)
  local coro_push3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(13)
    if t2 ~= nil then
      -- t2 est de cote : il est deporte, pas plaque au sol.
      GROUND:AnimateInDirection(t2, "None", t2.Direction, Direction.Down, 6, 1, 1)
      GAME:WaitFrames(4)
      GROUND:CharSetEmote(t2, "shock", 1)
      GROUND:CharAnimateTurnTo(t2, Direction.Up, 4)
    end
  end)
  local coro_push4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(21)
    if t3 ~= nil then
      -- t3 ferme la marche : il recule d'un pas, se fige, puis leve
      -- les yeux. Reaction plus tardive et plus discrete : c'est lui
      -- qui a vu la scene de plus loin.
      GROUND:AnimateInDirection(t3, "None", t3.Direction, Direction.Down, 6, 1, 1)
      GAME:WaitFrames(10)
      GROUND:CharSetEmote(t3, "sweatdrop", 1)
      GROUND:CharAnimateTurnTo(t3, Direction.Up, 6)
    end
  end)
  TASK:JoinCoroutines({coro_push1, coro_push2, coro_push3, coro_push4})

  GAME:WaitFrames(30)
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_004']))
  -- "C'est...[pause=15] Tornadus.[pause=20] L'esprit des vents."

  GAME:WaitFrames(30)
  -- Tornadus se redresse. Les deux overlays Ominous_Wind qui balayaient
  -- l'ecran de part et d'autre sont retires : le MapStatus blowing_wind
  -- pose plus haut porte deja le vent en continu, et le brief demande
  -- explicitement de ne pas surcharger. Reste l'animation du personnage
  -- lui-meme, qui suffit a dire la menace.
  GROUND:CharSetAnim(tornadus, "Charge", true)

  SOUND:PlayBattleSE('EVT_Battle_Transition')
  GAME:WaitFrames(20)

  -- TOUS SE TOURNENT VERS LUI, en decale. Auparavant seuls le heros et
  -- le partenaire pivotaient : t2 et t3 restaient plantes de dos face a
  -- un legendaire. CharTurnToChar vise l'entite plutot qu'une direction
  -- fixe : l'orientation reste juste meme si une position change.
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharTurnToChar(partner, tornadus)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:CharTurnToChar(hero, tornadus)
  end)
  local coro2d = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t2 ~= nil then GROUND:CharTurnToChar(t2, tornadus) end
  end)
  local coro2e = TASK:BranchCoroutine(function()
    GAME:WaitFrames(19)
    if t3 ~= nil then GROUND:CharTurnToChar(t3, tornadus) end
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2d, coro2e})

  GAME:WaitFrames(10)

  -- ================= LE GARDIEN DU CIEL PARLE =================
  -- C'est le boss de CLOTURE du chapitre 5, et il etait muet. Or il est le
  -- seul personnage du chapitre qui voit le monde d'en haut : c'est lui, et
  -- personne d'autre, qui peut donner au duo la premiere image d'ensemble
  -- du probleme. Il ne parle ni d'epreuve ni de garde — il decrit ce qu'il
  -- a VU. « Rien de naturel n'a d'angles » plante l'arc des Coeurs sans
  -- rien nommer : le joueur comprendra bien plus tard, le heros jamais ici.
  GAME:MoveCamera(560, 1104, 40, false)
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_038']))
  -- "Je vous ai vus depuis la crete. Deux points, qui grimpaient mal."
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_039']))
  -- "J'observe cette terre d'en haut depuis avant qu'elle ait des routes."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_040']))
  -- "De la-haut, on cesse de voir des lieux. On voit des formes."
  GAME:WaitFrames(20)
  -- La revelation : plan serre, puis un temps long. C'est LA phrase.
  GAME:MoveCamera(560, 1092, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_041']))
  -- "Et il y a une forme sous votre monde, petits. Elle a des angles."
  GAME:WaitFrames(25)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_042']))
  -- "Rien de naturel n'a d'angles."
  GAME:WaitFrames(30)
  GAME:MoveCamera(560, 1120, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_043']))
  -- "Je porte ca sur le dos depuis longtemps. Montrez-moi que vous pouvez aussi."
  GAME:WaitFrames(22)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_010'], hero:GetDisplayName()))
  -- "Alors on va lui montrer que notre voyage ne fait que commencer ! [hero], à nous deux !"

  --Le climat est RENDU a la carte avant de basculer sur le combat :
  --un MapStatus non retire suit le joueur dans le donjon.
  --ClearAll balaie les 19 MapStatus connus, pas seulement ceux que
  --Weather.active a memorises : les quatre poses ici l'ont ete par
  --GROUND:AddMapStatus direct, donc Weather.Clear() seul les ignorait.
  Weather.ClearAll()

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountGuardianSeen = true
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_guardian_ch_5.SecondPreBossScene()

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 568, 440, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(tornadus, "Charge", true)

  GROUND:TeleportTo(hero, 568, 919, Direction.Up)
  GROUND:TeleportTo(partner, 536, 927, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 600, 927, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 568, 951, Direction.Up) end
  GAME:MoveCamera(560, 1120, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Rising Fear.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_011'], hero:GetDisplayName()))
  -- "Cette fois, on le terrasse. Promis, [hero]."

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
-- Enjeu maximal ici : c'est la CLOTURE de l'expedition du chapitre 5.
local function DefeatedBossBody()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  -- POST-COMBAT : LA VICTOIRE SUR TORNADUS (plan en 7 actes).
  -- Tornadus est un GARDIEN qui se revele : il ne testait pas par
  -- malveillance, il cherchait a comprendre les perturbations. Un
  -- vrai echange s'engage, la Guilde arrive, on repart vers les
  -- Ruines Fendues. Foreshadowing Ch6 (Zarude) / Ch7 (Groudon).

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- ============================================================
  -- ACTE 1 : LE CALME APRES LA TEMPETE — Tornadus parle
  -- ============================================================
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 568, 440, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Idle", true)

  GROUND:TeleportTo(hero, 568, 919, Direction.Up)
  GROUND:TeleportTo(partner, 536, 927, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 600, 927, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 568, 951, Direction.Up) end
  GAME:MoveCamera(560, 1120, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)
  GAME:WaitFrames(40)

  -- Le vent retombe, la camera se stabilise.
  GAME:MoveCamera(560, 1104, 60, false)
  GAME:WaitFrames(60)

  -- Tornadus fait face au duo.
  GROUND:CharAnimateTurnTo(tornadus, Direction.Down, 4)
  UI:SetSpeaker(tornadus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A01']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A02']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A03']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A04']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A05']))
  GAME:WaitFrames(20)

  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A06']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A07']))
  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A08']))
  GAME:WaitFrames(25)

  -- ============================================================
  -- ACTE 2 : L'ARRIVEE DE LA GUILDE
  -- ============================================================
  -- La Guilde, qui avait attendu en contrebas, a grimpe pendant le
  -- combat. Elle arrive par le sud (positions libres y 1220-1236).
  local tropius, noctowl, girafarig, breloom, audino, snubbull, growlithe, zigzagoon =
    CharacterEssentials.MakeCharactersFromList({
      {'Tropius',    424, 832, Direction.Up},
      {'Noctowl',    512, 880, Direction.Up},
      {'Girafarig',  552, 880, Direction.Up},
      {'Breloom',    592, 880, Direction.Up},
      {'Audino',     640, 872, Direction.Up},
      {'Snubbull',   680, 864, Direction.Up},
      {'Growlithe',  448, 864, Direction.Up},
      {'Zigzagoon',  720, 816, Direction.Up},
    })

  -- Arrivee en groupe, camera qui suit le mouvement.
  local arr = {}
  local group = {tropius, noctowl, girafarig, breloom, audino, snubbull, growlithe, zigzagoon}
  for i, c in ipairs(group) do
    if c ~= nil then
      arr[#arr+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(i * 5)
        pcall(function()
          GROUND:MoveToPosition(c, c.Position.X, 1140, false, 0.9)
          GROUND:CharAnimateTurnTo(c, Direction.Up, 4)
        end)
      end)
    end
  end
  TASK:JoinCoroutines(arr)
  GAME:WaitFrames(20)

  -- Tous decouvrent Tornadus : silence, camera elargie.
  GAME:MoveCamera(560, 1180, 80, false)
  GAME:WaitFrames(80)

  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Stunned")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A09']))
  end
  GAME:WaitFrames(20)
  if noctowl ~= nil then
    GROUND:CharSetEmote(noctowl, "shock", 1)
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A10']))
  end

  -- ============================================================
  -- ACTE 3 : LES EXCUSES DE LA GUILDE
  -- ============================================================
  GAME:WaitFrames(30)
  if noctowl ~= nil then
    local walk1 = TASK:BranchCoroutine(function()
      pcall(function() GROUND:MoveToPosition(noctowl, 536, 935, false, 0.8) end)
    end)
    TASK:JoinCoroutines({walk1})
    GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A11']))
    GAME:WaitFrames(15)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A12']))
    GAME:WaitFrames(15)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A13']))
  end

  GAME:WaitFrames(30)
  GROUND:CharAnimateTurnTo(tornadus, Direction.Down, 4)
  UI:SetSpeaker(tornadus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A14']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A15']))
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A16']))
  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A17']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A18']))

  -- ============================================================
  -- ACTE 4 : TOUR DE PAROLE (variation de portrait par personnage)
  -- ============================================================
  GAME:WaitFrames(20)

  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A19']))
  end
  if noctowl ~= nil then
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A20']))
  end
  if girafarig ~= nil then
    UI:SetSpeaker(girafarig)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A21']))
  end
  if breloom ~= nil then
    UI:SetSpeaker(breloom)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A22']))
  end
  if audino ~= nil then
    UI:SetSpeaker(audino)
    GeneralFunctions.SetEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A23']))
  end
  if snubbull ~= nil then
    UI:SetSpeaker(snubbull)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A24']))
  end
  if t2 ~= nil then
    UI:SetSpeaker(t2)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A25']))
  end
  if t3 ~= nil then
    UI:SetSpeaker(t3)
    GeneralFunctions.SetEmotion("Joyous")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A26']))
  end
  if growlithe ~= nil then
    UI:SetSpeaker(growlithe)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A27']))
  end

  GAME:WaitFrames(15)
  if zigzagoon ~= nil then
    GROUND:CharSetEmote(zigzagoon, "happy", 1)
    UI:SetSpeaker(zigzagoon)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A28']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A29']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A30']))
    -- Almotz ecrit frenetiquement (pas d'anim "Write" : Idle + emote).
    GROUND:CharSetAnim(zigzagoon, "Idle", true)
    GROUND:CharSetEmote(zigzagoon, "notice", 1)
  end

  -- ============================================================
  -- ACTE 5 : LE DEPART DE TORNADUS
  -- ============================================================
  GAME:WaitFrames(30)
  GAME:MoveCamera(560, 1104, 60, false)
  GROUND:CharTurnToCharAnimated(tornadus, hero, 4)

  UI:SetSpeaker(tornadus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A31']))
  GAME:WaitFrames(15)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A32']))
  GAME:WaitFrames(20)

  if tropius ~= nil then
    GROUND:CharTurnToCharAnimated(tornadus, tropius, 4)
  end
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A33']))

  GAME:WaitFrames(15)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A34']))

  -- Flash blanc, envol, disparition.
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:FadeOut(false, 30)
  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  GAME:WaitFrames(30)
  GAME:FadeIn(20)
  GROUND:Hide('Tornadus')
  GAME:WaitFrames(30)

  -- ============================================================
  -- ACTE 6 : LA SCENE COMIQUE
  -- ============================================================
  GAME:MoveCamera(560, 1180, 40, false)
  GAME:WaitFrames(40)

  if noctowl ~= nil then
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Stunned")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A35']))
  end
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A36']))
  end
  GAME:WaitFrames(20)
  if snubbull ~= nil then
    UI:SetSpeaker(snubbull)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A37']))
  end
  if growlithe ~= nil then
    GROUND:CharSetEmote(growlithe, "question", 1)
    UI:SetSpeaker(growlithe)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A38']))
  end
  if t3 ~= nil then
    UI:SetSpeaker(t3)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A39']))
  end
  if zigzagoon ~= nil then
    UI:SetSpeaker(zigzagoon)
    GeneralFunctions.SetEmotion("Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A40']))
  end

  GAME:WaitFrames(20)
  if noctowl ~= nil then
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A41']))
  end

  GAME:WaitFrames(20)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A42']))
  UI:SetCenter(false)
  UI:ResetSpeaker()

  -- ============================================================
  -- ACTE 7 : REPRENDRE LA ROUTE
  -- ============================================================
  GAME:WaitFrames(20)
  if tropius ~= nil then
    UI:SetSpeaker(tropius)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A43']))
  end
  if girafarig ~= nil then
    GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4)
    UI:SetSpeaker(girafarig)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A44']))
  end
  if noctowl ~= nil then
    UI:SetSpeaker(noctowl)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A45']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_A46']))
  end

  -- Mise en formation et depart collectif vers le nord.
  GAME:WaitFrames(15)
  local depart = {}
  depart[1] = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(hero, Direction.Up, 120, false, 1)
  end)
  depart[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(4)
    GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1)
  end)
  for i, c in ipairs(group) do
    if c ~= nil then
      depart[#depart+1] = TASK:BranchCoroutine(function()
        GAME:WaitFrames(8 + i * 3)
        pcall(function()
          GROUND:MoveInDirection(c, Direction.Up, 110, false, 1)
          GAME:GetCurrentGround():RemoveTempChar(c)
        end)
      end)
    end
  end
  local coro_cam_final = TASK:BranchCoroutine(function()
    GAME:MoveCamera(560, 1000, 140, false)
  end)
  depart[#depart+1] = coro_cam_final
  TASK:JoinCoroutines(depart)
  GAME:WaitFrames(40)
  GAME:WaitFrames(60)

  SOUND:FadeOutBGM(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  -- Nettoyage : retirer les PNJ de la guilde restants.
  for _, c in ipairs(group) do
    if c ~= nil then
      pcall(function() GAME:GetCurrentGround():RemoveTempChar(c) end)
    end
  end
  SV.Chapter5.MountGuardianDefeated = true
end

function mount_windswept_guardian_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DefeatedBoss cutscene start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  --LE MODE CINEMATIQUE RESTE ACTIF PENDANT LA BASCULE (patron du Creuset,
  --searing_crucible_ch_5.lua:DefeatedBoss) : le couper ici laissait au
  --moteur des frames de gameplay sur la carte sortante pendant
  --l'armement du changement — fenetre ou un input du joueur (menu,
  --deplacement) pouvait se chevaucher avec l'ecran de resultats et
  --figer la partie. C'est le freeze signale apres la victoire sur
  --Tornadus. La carte d'arrivee relache le mode : le refectoire via
  --guild_dining_room.Dinnertime (init.lua:102), le 2e etage via son
  --PlotScripting.

  --LE SOMMET EST VAINCU — MAIS L'EXPEDITION N'EST PAS TERMINEE.
  --(Restructuration validee : option 2 — les Ruines Fendues sont le
  --climax du ch5.) La scene post-combat (7 actes) a ete jouee dans
  --DefeatedBossBody : Tornadus a revele les perturbations de la
  --region et indique que les reponses se trouvent plus loin. La suite
  --logique est le CAMPEMENT DEVANT LES RUINES FENDUES
  --(cloven_ruins_entrance), pas un retour a Metano. Le briefing, la
  --nuit et le reve s'y jouent (cloven_ruins_entrance_ch_5.lua), puis
  --le donjon final. FinishedExpedition ne sera pose qu'apres les
  --Ruines (et la cloture de l'expedition -> ch6).
  --Cette bascule est HORS du pcall : meme si la mise en scene casse,
  --l'expedition doit TOUJOURS pouvoir continuer vers les Ruines.
  SV.Chapter5.RuinsCampPending = true
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DefeatedBoss -> cloven_ruins_entrance (campement des Ruines Fendues)")
  GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : l'ancienne version était un collage corrompu —
-- dialogues AVANT CutsceneMode/FadeIn (affichés hors cinématique), répliques de
-- VICTOIRE mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> triomphe du boss -> la Voix -> le duo à terre -> retraite
-- du boss -> fondu noir -> retour à l'entrée.
function mount_windswept_guardian_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 568, 440, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 568, 919, Direction.Up)
  GROUND:TeleportTo(partner, 536, 927, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 600, 927, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 568, 951, Direction.Up) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(560, 1120, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(560, 1100, 40, false)
  GAME:WaitFrames(10)

  -- Le boss triomphe.
  GROUND:CharSetAnim(tornadus, "Charge", true)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_021']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- TORNADUS PARLE LUI-MEME APRES LA DEFAIRE — comme Magcargo au Creuset
  -- (searing_crucible_ch_5.lua:1000+ : apres la defaite, c'est le boss
  -- qui s'adresse au duo). Pas de locuteur anonyme : le vainqueur
  -- commente SA victoire.
  UI:SetSpeaker(tornadus)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_017']))
  GAME:WaitFrames(30)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_018']))
  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_019']))
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(560, 1140, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Il est... trop rapide...[pause=20] Le ciel entier est son territoire...")
  GAME:WaitFrames(20)

  -- Le boss se retire, victorieux.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_023']))
  UI:SetCenter(false)
  GAME:WaitFrames(10)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DiedToBoss -> mount_windswept_entrance")
  GAME:EnterGroundMap("mount_windswept_entrance", "Main_Entrance_Marker")
end

return mount_windswept_guardian_ch_5
