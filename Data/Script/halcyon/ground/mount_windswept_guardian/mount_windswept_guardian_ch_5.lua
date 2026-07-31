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
  GROUND:TeleportTo(hero, 560, 1216, Direction.Up)
  GROUND:TeleportTo(partner, 496, 1224, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 624, 1224, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 560, 1248, Direction.Up) end
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
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

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

  -- THE VOICE — before anything appears
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_005']))
  -- "Le Prédateur Ancestral du Ciel..."

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

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_006']))
  -- "Toi...[pause=10] Tu savais qu'il était là !"

  GAME:WaitFrames(30)

  --TORNADUS PARLE LUI-MEME. Le brief l'exige : « par defaut, Tornadus
  --porte lui-meme l'integralite de la scene [...] la Voix ne doit
  --intervenir que si elle est indispensable ». Ces trois repliques
  --enoncent SES conditions d'acces au sommet : elles lui appartiennent,
  --pas a une instance exterieure. On les lui rend.
  --Il n'est pas encore visible : le SetSpeaker nomme sans portrait
  --(forme desincarnee), donc la voix precede le corps — exactement le
  --patron d'entree recherche.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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

  -- (560,1064) : 4 cases au nord du heros, sur la plateforme, dans le
  -- meme ecran que toute l'equipe. Verifie libre et connexe.
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 560, 1064, Direction.Down}
  })
  GROUND:Hide('Tornadus')

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
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
  BossFX.Flash(560, 1064, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Tornadus')
  BossFX.Impact(9)
  GROUND:CharSetAnim(tornadus, "Charge", true)

  GAME:WaitFrames(15)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

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

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountGuardianSeen = true
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
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
    {'Tornadus', 560, 1064, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(tornadus, "Charge", true)

  GROUND:TeleportTo(hero, 560, 1160, Direction.Up)
  GROUND:TeleportTo(partner, 496, 1168, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 624, 1168, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 560, 1192, Direction.Up) end
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
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
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
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 560, 1064, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Charge", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 560, 1160, Direction.Up)
  GROUND:TeleportTo(partner, 496, 1168, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 624, 1168, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 560, 1192, Direction.Up) end
  GAME:MoveCamera(560, 1120, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  -- Tornadus ploie, les vents retombent
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 20))
  -- LOT 2.3 — pas de PoseGroundAction/"Faint" : le gardien reste visible
  -- pendant les dialogues, puis disparait au flash blanc.
  GROUND:CharSetAnim(tornadus, "Idle", true)

  GAME:WaitFrames(60)

  -- The storm clears
  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_012']))
  -- "On...[pause=10] On l'a vaincu !"

  GAME:WaitFrames(30)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_013']))
  -- "Regarde ! L'orage se dissipe..."

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_014']))
  -- "Cette voix...[pause=15] Elle a dit quelque chose à propos de ruines ancestrales."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_015']), "Determined")
  -- "C'est là qu'on va. Vers les Ruines du Cloven."

  -- LOT 8.3 — bilan de l'expedition : ce qui a change en chemin.
  GAME:WaitFrames(15)
  GAME:MoveCamera(560, 1108, 40, false)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_035']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)
  -- ================= IL POSE SON FARDEAU =================
  -- Cloture de l'expedition : il ne felicite pas, il TRANSMET. Le detail
  -- « dormez, mangez » le rend humain apres la revelation. Sa derniere
  -- phrase retourne l'evidence — un mur peut enfermer autant qu'il protege.
  -- C'est la graine que Diancie fera germer au chapitre 8.
  GAME:MoveCamera(560, 1104, 40, false)
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_044']))
  -- "Alors c'est a vous, maintenant. J'en suis heureux. C'etait lourd."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_045']))
  -- "Descendez. Dormez. Mangez. Personne ne resout une forme le ventre vide."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_046']))
  -- "Et quand vous trouverez les angles — ne supposez pas qu'ils ont ete
  --  batis pour vous garder DEHORS."
  GAME:WaitFrames(28)

  GAME:MoveCamera(560, 1136, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_036']))
  -- "On est montes ici pour l'expedition. Je l'avais oublie."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_037']), "Normal")
  -- "Moi aussi. Quelque part en route, c'est devenu autre chose."
  GAME:WaitFrames(20)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_016']))
  -- "Alors allons-y ! La fin de l'expédition nous attend !"

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)

  -- Tornadus se dissout dans une bourrasque
  local whirlwind = RogueEssence.Content.FlashEmitter()
  whirlwind.FadeInTime = 2
  whirlwind.HoldTime = 2
  whirlwind.FadeOutTime = 20
  whirlwind.StartColor = Color(255, 255, 255, 0)
  whirlwind.Layer = DrawLayer.Top
  whirlwind.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(whirlwind, tornadus.Position.X, tornadus.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Tornadus')
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function mount_windswept_guardian_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DefeatedBoss cutscene start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  GAME:CutsceneMode(false)

  --Le sommet est vaincu : l'expedition du chapitre 5 est terminee.
  --On renvoyait vers "cloven_ruins", carte qui n'existe pas (la zone est
  --Released=false, 0 segment) -> ecran noir apres la victoire finale.
  --On cloture proprement : bascule chapitre 6, fin de journee a la guilde.
  --Cette cloture est HORS du pcall : meme si la mise en scene casse, la
  --progression de chapitre et le retour a la guilde ont TOUJOURS lieu.
  SV.Chapter5.FinishedExpedition = true
  SV.ChapterProgression.Chapter = 6
  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  local exit_ground = 6
  if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end
  PrintInfo("[BossSeq][mount_windswept_guardian_ch_5] DefeatedBoss -> master_zone (fin expedition ch5, Chapter=6)")
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    "master_zone", -1, exit_ground, 0, true, true)
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
    {'Tornadus', 560, 1064, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 560, 1160, Direction.Up)
  GROUND:TeleportTo(partner, 496, 1168, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 624, 1168, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 560, 1192, Direction.Up) end
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

  -- La Voix de l'Abysse commente la défaite.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_017']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_018']))
  GAME:WaitFrames(20)
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
