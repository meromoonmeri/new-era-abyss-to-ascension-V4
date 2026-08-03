--[[
    cloven_ruins_boss_ch_7.lua
    Ruines Tordues — Boss : Regigigas
    Apparition : les veines dorees de l'arene s'animent, le colosse s'eveille
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_boss_ch_7 = {}

function cloven_ruins_boss_ch_7.FirstPreBossScene()

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

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Carte 600x648 px (TexSize 1) — décor régénéré 2026-08-04 (arène à
  -- dalles et plaques à glyphes). Géométrie MESURÉE sur la grille
  -- d'obstacles : 55,0 % bloquant, 2701 cases atteignables.
  --   couloir d'entrée au SUD : x 264-360, y >= 568
  --   arène large            : x 104-512, y 240-552
  --   niche du colosse au NORD : x 232-384, y 48-144
  -- (Les anciennes coordonnées visaient une carte 240x320 : 5 des 6
  -- positions du duo tombaient HORS SOL. Corrigé.)
  GROUND:TeleportTo(hero, 296, 616, Direction.Up)
  GROUND:TeleportTo(partner, 320, 616, Direction.Up)
  GAME:MoveCamera(308, 600, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 56, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 56, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_001']))
  -- "Le cœur des ruines... Il bat encore."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_002']))
  -- "Regarde ces veines dorées... Elles palpitent."

  GAME:WaitFrames(30)

  -- === VOIX DE L'ABYSSE ===
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(30)

  BossFX.Voice('CRB_003')
  -- "Le Titan déchu... Il attend depuis des millénaires."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, true, false, Direction.Up)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Up)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_004']))
  -- "Toi... Tu nous as suivis jusqu'ici ?"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_005']))
  -- "Je suis partout où la vie des Cœurs s'affaiblit."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_006']))
  -- "Et ici... le Cœur ne bat presque plus."

  GAME:WaitFrames(30)

  -- ================================================================
  -- ENIGME DES ZARBI (motif Aegis Cave : les Unown ecrivent le mot-cle
  -- au-dessus de la porte scellee, et la porte s'ouvre quand on le lit).
  -- Carte 240x320 px ; la porte est au nord, le duo arrive par le sud.
  -- ================================================================
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_028']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)

  -- Les cinq Zarbi sortent des murs, un par un, et s'alignent : R E G I S.
  local zx = {88, 116, 144, 172, 200}
  local zid = {'Zarbi_R', 'Zarbi_E', 'Zarbi_G', 'Zarbi_I', 'Zarbi_S'}
  local zarbis = {}
  for i = 1, 5 do
    zarbis[i] = CharacterEssentials.MakeCharactersFromList({
      {zid[i], zx[i], 152, Direction.Down}
    })
    GROUND:Hide(zid[i])
  end
  GAME:MoveCamera(308, 400, 40, false)
  for i = 1, 5 do
    SOUND:PlayBattleSE('EVT_Emote_Shock_2')
    BossFX.Flash(zx[i], 152, 2, 3, 12)
    GROUND:Unhide(zid[i])
    GAME:WaitFrames(10)
  end
  GAME:WaitFrames(15)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_029']))
  end
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_030']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_031']))
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_032']), "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Determined")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_033']))
  end
  GAME:WaitFrames(15)

  -- La porte cede : les cinq Zarbi s'embrasent puis se dispersent.
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  for i = 1, 5 do BossFX.Flash(zx[i], 152, 2, 4, 14) end
  BossFX.ShakeScreen(5, 24)
  GAME:WaitFrames(16)
  for i = 1, 5 do GROUND:Hide(zid[i]) end
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_034']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- ================================================================
  -- LES TROIS GARDIENS SCELLES — eveil un par un (motif Aegis Cave :
  -- Regirock, Regice puis Registeel, chacun avec sa signature).
  -- ================================================================
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_035']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)

  local regirock = CharacterEssentials.MakeCharactersFromList({
    {'Regirock', 246, 128, Direction.Down}
  })
  local regice = CharacterEssentials.MakeCharactersFromList({
    {'Regice', 304, 136, Direction.Down}
  })
  local registeel = CharacterEssentials.MakeCharactersFromList({
    {'Registeel', 376, 128, Direction.Down}
  })
  GROUND:Hide('Regirock')
  GROUND:Hide('Regice')
  GROUND:Hide('Registeel')
  GAME:MoveCamera(308, 300, 40, false)

  -- Regirock : la pierre s'ebroue.
  BossFX.Flash(96, 120, 3, 5, 18)
  GAME:WaitFrames(8)
  GROUND:Unhide('Regirock')
  BossFX.Particle("Rock_Pieces", 96, 128, 3)
  BossFX.Impact(8)
  GROUND:CharSetAnim(regirock, "Idle", true)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_036']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)

  -- Regice : le froid tombe d'un coup.
  BossFX.Flash(144, 112, 3, 5, 18)
  GAME:WaitFrames(8)
  GROUND:Unhide('Regice')
  BossFX.Impact(8)
  GROUND:CharSetAnim(regice, "Idle", true)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_037']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)

  -- Registeel : il ne s'eveille pas, il etait deja la.
  BossFX.Flash(192, 120, 3, 5, 18)
  GAME:WaitFrames(8)
  GROUND:Unhide('Registeel')
  BossFX.Impact(10)
  GROUND:CharSetAnim(registeel, "Idle", true)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_038']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)

  BossFX.Rumble({hero, partner}, 2)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    GeneralFunctions.SetEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_039']))
  end
  GAME:WaitFrames(12)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_040']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_041']), "Worried")
  GAME:WaitFrames(20)

  -- La camera recule : les trois gardiens ET ce qui dort derriere eux.
  GAME:MoveCamera(308, 430, 50, false)
  GAME:WaitFrames(15)

  -- === FLASH + EMERGENCE DE REGIGIGAS ===
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 6, 18)

  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 304, 80, Direction.Down}
  })
  GROUND:Hide('Regigigas')

  -- Signature ROCHE : eboulement, le colosse se reveille
  BossFX.RockFall(144, 128)
  BossFX.Rumble({hero, partner}, 3)

  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(20)
  GROUND:Unhide('Regigigas')
  GROUND:CharSetAnim(regigigas, "Idle", true)

  -- Les veines dorees de Regigigas pulsent
  BossFX.Overlay("White", regigigas.Position.X, regigigas.Position.Y, 5, 40, 10, DrawLayer.Front)

  BossFX.Impact(14)
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 6, 1, 1)
    GeneralFunctions.Recoil(partner, "Hurt", 14, 14, false, false)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 6, 1, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_007']))
  -- "REGIGIGAS ! Le Titan des Ruines !"

  GAME:WaitFrames(30)

  -- ================= LE TITAN PARLE =================
  -- Audit tools/audit_boss_cinematics.py : cloven_ruins_boss etait le SEUL
  -- boss d'histoire entierement MUET. 37 repliques dans la scene, aucune du
  -- boss. Le partenaire criait son nom et on enchainait sur le combat.
  --
  -- Registre choisi : UNE SENTINELLE QUI N'A PLUS D'ORDRES. Il ne hait pas
  -- (Zarude), il ne teste pas (la harde), il ne compte pas (les Sentinelles
  -- du Pic) : il EXECUTE une consigne dont il a oublie l'auteur. Diction
  -- hachee, presque militaire — un rapport, pas une conversation.
  --
  -- C'est le boss le plus proche du twist des Coeurs, donc celui qui doit
  -- en dire le MOINS. Ici il ne pose que le cadre ; la question qui derange
  -- est reservee a l'apres-boss.
  GAME:MoveCamera(308, 240, 40, false)
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_045']))
  -- "...Halte."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_046']))
  -- "Designation : sentinelle. Poste : cette salle. Duree : inconnue."
  GAME:WaitFrames(22)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_047']))
  -- "On m'a dit de tenir jusqu'a la releve. Personne n'est venu."
  GAME:WaitFrames(25)
  -- Il s'adresse au duo : cadre commun.
  GAME:MoveCamera(308, 430, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_048']))
  -- "Petits. Etes-vous la releve ?"
  GAME:WaitFrames(25)
  -- Il repond lui-meme. Personne n'a le temps de placer un mot : c'est ce
  -- qui montre qu'il ne dialogue pas vraiment.
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_049']))
  -- "Non. La releve n'arrive pas en armes."
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(regigigas, "angry", 1) end)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_050']))
  -- "Alors la consigne tient. Rien ne sort de cette salle."
  GAME:WaitFrames(25)
  pcall(function() GROUND:CharSetEmote(regigigas, "", 0) end)

  -- REGIGIGAS ENONCE LUI-MEME LA REGLE — pas un commentaire exterieur.
  -- Le Titan a parle juste avant (CRB_049/050) : ces deux repliques
  -- poursuivent SON discours. La Voix ne commente pas le boss.
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_008']))
  -- "Je protège ce qui reste du Cœur. Si tu me vaines, le Cœur est à toi."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_009']))
  -- "Si tu échoues... ce Cœur s'éteindra pour toujours."

  GAME:WaitFrames(30)

  -- Regigigas émet un grondement, le sol tremble
  BossFX.ShakeScreen(8, 30)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_010'], hero:GetDisplayName()))
  -- "Alors on ne peut pas perdre. [hero], à nous !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_boss_ch_7.SecondPreBossScene()

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
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 304, 80, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(regigigas, "Idle", true)

  GROUND:TeleportTo(hero, 296, 616, Direction.Up)
  GROUND:TeleportTo(partner, 320, 616, Direction.Up)
  GAME:MoveCamera(308, 600, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_011']))
  -- "Cette fois, on le terrasse !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
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
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 304, 80, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 296, 600, Direction.Up)
  GROUND:TeleportTo(partner, 320, 600, Direction.Up)
  GAME:MoveCamera(308, 584, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(40)
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  BossFX.ShakeScreen(6, 20)
  -- Pose du Titan vaincu : "Faint" n'est pas une anim ground garantie pour
  -- toutes les especes -> GetAnimIndex("Faint") pouvait lever une erreur et
  -- couper la cinematique (ecran noir). "EventSleep" est une anim ground sure.
  GROUND:CharSetAnim(regigigas, "EventSleep", true)

  GAME:WaitFrames(60)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_012']))
  -- "On a vaincu le Titan !"

  GAME:WaitFrames(20)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_013']))
  -- "La pierre palpite encore... mais moins fort. Comme si elle reprenait son souffle."

  GAME:WaitFrames(20)

  -- ================= LE TITAN N'EST PAS VAINCU : IL EST RELEVE ==========
  -- Renversement du sens du combat. Le duo croit avoir gagne ; il vient en
  -- realite de liberer un veilleur de sa consigne. Cascade d'animations
  -- (patron pmd-red) : le colosse se redresse a demi pour parler, puis
  -- retombe. Il ne se releve jamais completement.
  pcall(function()
    GROUND:CharSetAnim(regigigas, "Hurt", true)
    GAME:WaitFrames(25)
    GROUND:CharSetAnim(regigigas, "Idle", true)
  end)
  GAME:MoveCamera(308, 310, 40, false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_051']))
  -- "...Consigne. Rompue."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_052']))
  -- "Sentinelle. Relevee."
  GAME:WaitFrames(25)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_053']))
  -- "Je ne me souviens pas de qui a donne la consigne. Je me souviens
  --  d'avoir obei."
  GAME:WaitFrames(22)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_054']))
  -- "C'est tout ce qui reste de moi. L'obeissance."
  GAME:WaitFrames(25)

  -- La question qui derange. Camera serree : c'est LA phrase de la scene.
  GAME:MoveCamera(308, 250, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_055']))
  -- "Prenez-le. Mais repondez-moi une chose, petits."
  GAME:WaitFrames(25)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_056']))
  -- "Si nous devions le proteger... pourquoi m'a-t-on poste FACE a lui ?"
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_057']))
  -- "Un garde fait face a ce qu'il tient dehors. J'ai fait face a ce qui dort
  --  sous la pierre pendant mille ans."
  GAME:WaitFrames(35)

  -- Le duo encaisse. Le partenaire n'a pas de reponse : c'est voulu.
  GAME:MoveCamera(308, 470, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_059']))
  -- "Face a lui...[pause=25] Mais alors ce n'etait pas une salle du tresor."
  GAME:WaitFrames(25)

  GAME:MoveCamera(308, 310, 40, false)
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_058']))
  -- "Partez. Avant que je me souvienne du reste de la consigne."
  GAME:WaitFrames(30)

  -- Il retombe. Il ne disparait pas : il reste la, releve de sa faction.
  pcall(function()
    GROUND:CharSetAnim(regigigas, "EventSleep", true)
  end)
  BossFX.ShakeScreen(4, 20)
  GAME:WaitFrames(25)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_060']))
  -- "Le colosse se rassoit dans la poussiere,[pause=20] tourne vers ce qu'il
  --  gardait.[pause=25] Comme il l'a toujours ete."
  UI:SetCenter(false)
  GAME:WaitFrames(25)

  GAME:MoveCamera(308, 470, 40, false)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_014']), "Worried")
  -- "(Cette voix... elle nous a guidés jusqu'ici exprès.)"

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_015']))
  -- "On doit parler à Phileas. Il en sait plus qu'il ne le dit."

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function cloven_ruins_boss_ch_7.DefeatedBoss()
  PrintInfo("[BossSeq][cloven_ruins_boss_ch_7] DefeatedBoss cutscene start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  -- LE TITAN EST VAINCU — L'EXPEDITION DU CH5 EST TERMINEE.
  --(Restructuration validee : les Ruines Fendues sont le climax du ch5.
  --Regigigas est un GARDIEN QUI TESTE — bienveillant-eprouvant. Le duo
  --l'a releve de sa consigne millenaire. Révélation TARDIVE : le Cœur
  --corrompu n'est PAS revele ici — seule reste l'anomalie inquietante
  --(les veines, la pulsation sous la pierre) posee en foreshadowing.
  --Le fil Cœur/Genese/reve Necrozma vit apres le ch10.)
  --La cloture est HORS du pcall : meme si la mise en scene casse, la
  --progression et le retour a Metano ont TOUJOURS lieu.
  SV.Chapter5.FinishedExpedition = true
  SV.Chapter5.RuinsExpeditionDone = true
  SV.ChapterProgression.Chapter = 7
  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  local exit_ground = 6
  if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][cloven_ruins_boss_ch_7] DefeatedBoss -> master_zone (fin expedition ch5, Chapter=6)")
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    "master_zone", -1, exit_ground, 0, true, true)
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : collage corrompu — dialogues avant
-- CutsceneMode/FadeIn, répliques de VICTOIRE (CRB_023/024/026/025/027)
-- mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> le Titan domine -> la Voix -> le duo à terre ->
-- le Titan retourne à son sommeil -> fondu -> retour à l'entrée.
function cloven_ruins_boss_ch_7.DiedToBoss()
  PrintInfo("[BossSeq][cloven_ruins_boss] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 304, 80, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  -- Les trois gardiens sont la aussi : la defaite se joue devant la veille
  -- au complet, pas devant le seul Titan.
  local regirock = CharacterEssentials.MakeCharactersFromList({
    {'Regirock', 246, 128, Direction.Down}
  })
  local regice = CharacterEssentials.MakeCharactersFromList({
    {'Regice', 304, 136, Direction.Down}
  })
  local registeel = CharacterEssentials.MakeCharactersFromList({
    {'Registeel', 376, 128, Direction.Down}
  })
  GROUND:CharSetAnim(regirock, "Idle", true)
  GROUND:CharSetAnim(regice, "Idle", true)
  GROUND:CharSetAnim(registeel, "Idle", true)

  -- L'équipe est au sol, vaincue, au pied du Titan.
  GROUND:TeleportTo(hero, 296, 608, Direction.Up)
  GROUND:TeleportTo(partner, 320, 608, Direction.Up)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(308, 592, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte lentement le long du colosse.
  GAME:MoveCamera(308, 310, 60, false)
  GAME:WaitFrames(10)

  -- Le Titan se redresse, les veines dorées pulsent.
  BossFX.ShakeScreen(4, 20)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_019']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- LE TITAN PARLE LUI-MEME APRES LA DEFAIRE — meme patron que Magcargo
  -- au Creuset : le vainqueur commente SA victoire, pas un locuteur
  -- anonyme.
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_016']))
  -- "Le Titan ne pardonne pas..."
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_017']))
  -- "Mais ce Cœur t'attend. Reviens quand tu seras prêt."
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_020']))
  -- "Tu n'es pas le premier à défier le Titan. Ni le dernier à tomber."
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(308, 500, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Pain")
  UI:WaitShowDialogue("Il est... trop fort...[pause=20] On ne peut rien faire de plus aujourd'hui...")
  GAME:WaitFrames(20)

  -- Le Titan retourne à son sommeil millénaire.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_021']))
  UI:SetCenter(false)
  GAME:WaitFrames(10)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  --APRES UN KO CONTRE REGIGIGAS, l'expedition se refait au CAMP devant
  --l'entree (et non a la guilde) : le camp joue la cinematique de reveil
  --(KODefeatCutscene). Le flag PlayTempRuinsScene est lu par
  --cloven_ruins_entrance.PlotScripting des l'arrivee.
  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter == 5 then
    SV.Chapter5.PlayTempRuinsScene = true
    SV.Chapter5.RuinsLastExitReason = 'Died'
  end

  -- Les trois regagnent leurs niches : la veille reprend, la porte se referme.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_042']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  -- REGIGIGAS CLOT LA DEFAIRE — ses propres mots, pas une voix exterieure.
  UI:SetSpeaker(regigigas)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_043']))
  GAME:WaitFrames(12)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_044']))
  UI:SetCenter(false)
  GAME:WaitFrames(15)

  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][cloven_ruins_boss] DiedToBoss -> cloven_ruins_entrance")
  GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
end

return cloven_ruins_boss_ch_7
