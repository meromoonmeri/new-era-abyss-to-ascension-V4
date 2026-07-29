--[[ 
    mount_windswept_guardian_ch_5.lua
    Mont Venteux — Gardien : Tornadus
    Apparition : Descend des nuages d'orage dans un cri perçant, fait trembler la montagne
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

mount_windswept_guardian_ch_5 = {}

function mount_windswept_guardian_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  -- LOT 1 — l'equipe atterrit a ~64px sous le gardien (y=272) apres sa marche
  -- de 56px : on la fait donc apparaitre 56px plus bas (y=328).
  GROUND:TeleportTo(hero, 240, 328, Direction.Up)
  GROUND:TeleportTo(partner, 208, 328, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 344, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 344, Direction.Up) end
  GAME:MoveCamera(224, 324, 1, false)

  GAME:CutsceneMode(true)
  --REFONTE CINÉ 2026-07-30 : stabilisation avant FadeIn.
  --Les personnages sont teleportes, la camera placee. On attend 20f
  --supplementaires pour que le moteur finisse le rendu avant d'ouvrir.
  GAME:WaitFrames(80)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(60)

  -- Dramatic silence — wind howling
  SOUND:PlayBGM('Mt. Travail.ogg', false)

  GAME:WaitFrames(40)
  --REFONTE CINÉ 2026-07-30 : marche vers le sommet avec le vent qui pousse.
  --L'equipe avance lentement (vitesse 1 = fatigue de l'altitude).
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 56, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:MoveInDirection(hero, Direction.Up, 56, false, 1)
  end)
  local coro2b = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if t2 ~= nil then GROUND:MoveInDirection(t2, Direction.Up, 56, false, 1) end
  end)
  local coro2c = TASK:BranchCoroutine(function()
    GAME:WaitFrames(18)
    if t3 ~= nil then GROUND:MoveInDirection(t3, Direction.Up, 56, false, 1) end
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(224, 232, 40, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  --REFONTE CINÉ 2026-07-30 : partner parle, l'equipe se tourne vers lui.
  pcall(function()
    GROUND:CharTurnToCharAnimated(hero, partner, 4)
    if t2 ~= nil then GROUND:CharTurnToCharAnimated(t2, partner, 4) end
    if t3 ~= nil then GROUND:CharTurnToCharAnimated(t3, partner, 4) end
  end)
  GAME:WaitFrames(8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_001']))
  -- "Le sommet...[pause=15] On y est presque."

  GAME:WaitFrames(30)
  --REFONTE CINÉ 2026-07-30 : partner regarde le ciel, les autres suivent.
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  pcall(function()
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
    GROUND:CharSetEmote(partner, "notice", 1)
  end)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_002']))
  -- "Regarde le ciel...[pause=15] Ces nuages ne sont pas normaux."

  GAME:WaitFrames(30)

  GAME:WaitFrames(30)

  -- === STORM GATHERS — VOICE SPEAKS FIRST ===
  SOUND:FadeOutBGM(80)

  -- Dark clouds swirling overhead
  local darkCloud = RogueEssence.Content.FiniteOverlayEmitter()
  darkCloud.FadeIn = 60
  darkCloud.TotalTime = 140
  darkCloud.Layer = DrawLayer.Top
  darkCloud.Anim = RogueEssence.Content.BGAnimData("Cloudy_Sky", 0)
  GROUND:PlayVFX(darkCloud, 224, 100)

  GAME:WaitFrames(60)

  -- THE VOICE — before anything appears
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_005']))
  -- "Le Prédateur Ancestral du Ciel..."

  GAME:WaitFrames(20)
  local coro_voice1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 3, 4, true, true, false, Direction.UpLeft)
  end)
  local coro_voice2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.UpRight)
  end)
  TASK:JoinCoroutines({coro_voice1, coro_voice2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_006']))
  -- "Toi...[pause=10] Tu savais qu'il était là !"

  GAME:WaitFrames(30)

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

  -- ================================================================
  -- ENTRÉE LÉGENDAIRE DE BORÉAS (Tornadus) — 2026-07-30
  -- ================================================================
  -- 5 phases progressives : brise → vent → tempête → apparition → révélation
  -- Aucun flash avant la phase 4. La montagne elle-même annonce le gardien.

  -- PHASE 1 : LA BRISE CHANGE (subtil, 40f)
  -- Le vent qui soufflait depuis le début de la scène change de nature.
  SOUND:PlayBGM('Rising Fear.ogg', true)
  pcall(function() GROUND:AddMapStatus("blowing_wind") end)
  -- Overlay de vent subtil — alpha faible, vitesse lente
  pcall(function()
    local breeze = RogueEssence.Content.FiniteOverlayEmitter()
    breeze.FadeIn = 20
    breeze.TotalTime = 200
    breeze.RepeatX = true
    breeze.Movement = RogueElements.Loc(-60, 0)
    breeze.Layer = DrawLayer.Front
    breeze.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(breeze, 224, 200)
  end)
  GAME:WaitFrames(20)

  -- Le partenaire remarque le changement
  pcall(function() GROUND:CharSetEmote(partner, "notice", 1) end)
  GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
  GAME:WaitFrames(15)

  -- PHASE 2 : LE VENT MONTE (modéré, 50f)
  -- Les nuages s'accumulent, la caméra tremble légèrement
  pcall(function() GROUND:AddMapStatus("clouds_overhead") end)
  GAME:WaitFrames(10)
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 3, 40))
  -- Rafales plus fortes — deux couches croisées
  pcall(function()
    local gust1 = RogueEssence.Content.FiniteOverlayEmitter()
    gust1.FadeIn = 10
    gust1.TotalTime = 120
    gust1.RepeatX = true
    gust1.Movement = RogueElements.Loc(-120, 0)
    gust1.Layer = DrawLayer.Front
    gust1.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(gust1, 224, 180)
  end)
  pcall(function()
    local gust2 = RogueEssence.Content.FiniteOverlayEmitter()
    gust2.FadeIn = 15
    gust2.TotalTime = 100
    gust2.RepeatX = true
    gust2.Movement = RogueElements.Loc(100, 0)
    gust2.Layer = DrawLayer.Back
    gust2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(gust2, 224, 220)
  end)
  -- Plumes emportées par le vent
  pcall(function()
    local feathers = RogueEssence.Content.FiniteOverlayEmitter()
    feathers.FadeIn = 10
    feathers.TotalTime = 80
    feathers.RepeatX = true
    feathers.Movement = RogueElements.Loc(-80, 20)
    feathers.Layer = DrawLayer.Front
    feathers.Anim = RogueEssence.Content.BGAnimData("Feather", 1)
    GROUND:PlayVFX(feathers, 280, 160)
  end)
  GAME:WaitFrames(20)

  -- Le héros et le partenaire lèvent les yeux
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
  end)
  GAME:WaitFrames(15)

  -- PHASE 3 : LA TEMPÊTE (fort, 40f)
  -- Poussière, secousses, vent argenté spectral
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 30))
  pcall(function()
    local dust = RogueEssence.Content.FiniteOverlayEmitter()
    dust.FadeIn = 5
    dust.TotalTime = 60
    dust.RepeatX = true
    dust.Movement = RogueElements.Loc(-160, 0)
    dust.Layer = DrawLayer.Front
    dust.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
    GROUND:PlayVFX(dust, 224, 240)
  end)
  -- Vent argenté — dimension légendaire
  pcall(function()
    local silver = RogueEssence.Content.FiniteOverlayEmitter()
    silver.FadeIn = 10
    silver.TotalTime = 80
    silver.RepeatX = true
    silver.Movement = RogueElements.Loc(-140, -20)
    silver.Layer = DrawLayer.Back
    silver.Anim = RogueEssence.Content.BGAnimData("Silver_Wind", 1)
    GROUND:PlayVFX(silver, 224, 160)
  end)
  SOUND:PlayBattleSE('EVT_Tower_Quake')
  GAME:WaitFrames(20)

  -- L'équipe recule instinctivement
  pcall(function()
    GROUND:CharSetEmote(partner, "shock", 1)
    GROUND:CharSetEmote(hero, "exclaim", 1)
  end)
  GAME:WaitFrames(15)

  -- PHASE 4 : L'APPARITION (flash + Tornadus)
  -- Le ciel se déchire. Flash blanc aveuglant.
  local center_flash = GAME:GetCameraCenter()
  local megaFlash = RogueEssence.Content.FlashEmitter()
  megaFlash.FadeInTime = 2
  megaFlash.HoldTime = 6
  megaFlash.FadeOutTime = 25
  megaFlash.StartColor = Color(255, 255, 255, 0)
  megaFlash.Layer = DrawLayer.Top
  megaFlash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(megaFlash, center_flash.X, center_flash.Y)
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  GAME:WaitFrames(4)

  -- Tourbillon au point d'apparition
  SOUND:PlayBattleSE('_UNK_EVT_003')
  pcall(function()
    local whirl = RogueEssence.Content.FiniteOverlayEmitter()
    whirl.FadeIn = 2
    whirl.TotalTime = 40
    whirl.RepeatX = true
    whirl.Movement = RogueElements.Loc(-200, 0)
    whirl.Layer = DrawLayer.Front
    whirl.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(whirl, 224, 192)
    local whirl2 = RogueEssence.Content.FiniteOverlayEmitter()
    whirl2.FadeIn = 2
    whirl2.TotalTime = 40
    whirl2.RepeatX = true
    whirl2.Movement = RogueElements.Loc(200, 0)
    whirl2.Layer = DrawLayer.Front
    whirl2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(whirl2, 224, 192)
  end)
  GAME:WaitFrames(6)

  -- BORÉAS SE RÉVÈLE
  GROUND:Unhide('Tornadus')
  GROUND:CharSetAnim(tornadus, "Charge", true)
  GAME:WaitFrames(4)

  -- PHASE 5 : L'IMPACT (onde de choc + réactions héroïques)
  -- Tornadus touche le sol — impact massif
  -- Son : séisme + collapse (deux SE superposés pour un impact lourd)
  SOUND:PlayBattleSE('EVT_Tower_Quake')
  GAME:WaitFrames(4)
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  -- Caméra : double secousse (impact initial + réplique)
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(5, 8, 20))
  GAME:WaitFrames(12)
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 15))
  BossFX.Impact(12)

  -- Poussière explosive depuis Tornadus (deux couches, directions opposées)
  pcall(function()
    local impactDust = RogueEssence.Content.FiniteOverlayEmitter()
    impactDust.FadeIn = 3
    impactDust.TotalTime = 50
    impactDust.Movement = RogueElements.Loc(-60, 0)
    impactDust.Layer = DrawLayer.Front
    impactDust.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
    GROUND:PlayVFX(impactDust, tornadus.Position.X - 24, tornadus.Position.Y + 16)
    local impactDust2 = RogueEssence.Content.FiniteOverlayEmitter()
    impactDust2.FadeIn = 3
    impactDust2.TotalTime = 50
    impactDust2.Movement = RogueElements.Loc(60, 0)
    impactDust2.Layer = DrawLayer.Front
    impactDust2.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
    GROUND:PlayVFX(impactDust2, tornadus.Position.X + 24, tornadus.Position.Y + 16)
  end)
  -- Pluie de plumes à l'impact
  pcall(function()
    local feathers2 = RogueEssence.Content.FiniteOverlayEmitter()
    feathers2.FadeIn = 2
    feathers2.TotalTime = 60
    feathers2.RepeatX = true
    feathers2.Movement = RogueElements.Loc(-40, 40)
    feathers2.Layer = DrawLayer.Front
    feathers2.Anim = RogueEssence.Content.BGAnimData("Feather", 1)
    GROUND:PlayVFX(feathers2, tornadus.Position.X, tornadus.Position.Y - 20)
  end)

  GAME:WaitFrames(8)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  -- RÉACTIONS DES HÉROS — séquence synchronisée avec l'impact
  -- Chaque personnage réagit selon sa personnalité :
  --   partner : sursaute, recule, emote shock
  --   hero : recule d'un pas, emote exclaim, se reprend
  --   t2 (Ganlon) : recule, posture défensive
  --   t3 (Shuca) : sursaute, emote sweating, tremble

  GAME:WaitFrames(6)
  -- Partner : sursaute et recule (le plus proche de Tornadus)
  local coro_push1 = TASK:BranchCoroutine(function()
    SOUND:PlayBattleSE('EVT_Emote_Shock_2')
    pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
    pcall(function() GROUND:CharSetAnim(partner, "Hurt", true) end)
    GROUND:AnimateInDirection(partner, "Walk", partner.Direction, Direction.Down, 8, 1, 1)
    GAME:WaitFrames(10)
    GROUND:AnimateInDirection(partner, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
    GAME:WaitFrames(8)
    pcall(function() GROUND:CharSetAnim(partner, "Idle", true) end)
    -- Se relève, regarde Tornadus
    GAME:WaitFrames(6)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  end)

  -- Hero : recule d'un pas, emote exclaim, se reprend
  local coro_push2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(4)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
    pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
    GROUND:AnimateInDirection(hero, "Walk", hero.Direction, Direction.Down, 6, 1, 1)
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 8, 1, 1)
    GAME:WaitFrames(6)
    -- Se reprend — posture déterminée
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    pcall(function() GROUND:CharSetEmote(hero, "determined", 1) end)
  end)

  -- t2 (Ganlon) : recule, posture défensive
  local coro_push3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    if t2 ~= nil then
      pcall(function() GROUND:CharSetEmote(t2, "shock", 1) end)
      pcall(function() GROUND:CharSetAnim(t2, "Hurt", true) end)
      GROUND:AnimateInDirection(t2, "Walk", t2.Direction, Direction.Down, 6, 1, 1)
      GAME:WaitFrames(10)
      pcall(function() GROUND:CharSetAnim(t2, "Idle", true) end)
      GAME:WaitFrames(4)
      GROUND:CharAnimateTurnTo(t2, Direction.Up, 4)
      pcall(function() GROUND:CharSetEmote(t2, "angry", 1) end)
    end
  end)

  -- t3 (Shuca) : sursaute, tremble, emote sweating
  local coro_push4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if t3 ~= nil then
      SOUND:PlayBattleSE('EVT_Emote_Startled')
      pcall(function() GROUND:CharSetEmote(t3, "shock", 1) end)
      GROUND:AnimateInDirection(t3, "Hop", t3.Direction, Direction.Down, 4, 1, 1)
      GAME:WaitFrames(8)
      GROUND:AnimateInDirection(t3, "Hurt", Direction.Down, Direction.Down, 6, 1, 1)
      GAME:WaitFrames(6)
      pcall(function() GROUND:CharSetAnim(t3, "Idle", true) end)
      GAME:WaitFrames(4)
      GROUND:CharAnimateTurnTo(t3, Direction.Up, 4)
      pcall(function() GROUND:CharSetEmote(t3, "sweating", 1) end)
    end
  end)

  TASK:JoinCoroutines({coro_push1, coro_push2, coro_push3, coro_push4})

  -- Seconde secousse de caméra (réplique du séisme)
  GAME:WaitFrames(10)
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 3, 15))
  GAME:WaitFrames(20)

  -- RÉVÉLATION : l'équipe lève les yeux vers Boréas
  -- Tous regardent Tornadus — le silence après le choc
  pcall(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
  end)
  -- Silence pesant — le vent souffle, personne n'ose parler
  GAME:WaitFrames(30)

  -- Le partenaire parle le premier, voix tremblante
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_004']))
  -- "C'est...[pause=10] le maître des vents !"

  GAME:WaitFrames(30)

  -- PHASE 6 : L'AURA PERSISTANTE
  -- Boréas flotte, entouré de vents permanents
  GROUND:CharSetAnim(tornadus, "Charge", true)
  pcall(function()
    local aura1 = RogueEssence.Content.FiniteOverlayEmitter()
    aura1.FadeIn = 10
    aura1.TotalTime = 80
    aura1.RepeatX = true
    aura1.Movement = RogueElements.Loc(-180, 0)
    aura1.Layer = DrawLayer.Front
    aura1.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(aura1, tornadus.Position.X, tornadus.Position.Y)
    local aura2 = RogueEssence.Content.FiniteOverlayEmitter()
    aura2.FadeIn = 10
    aura2.TotalTime = 80
    aura2.RepeatX = true
    aura2.Movement = RogueElements.Loc(180, 0)
    aura2.Layer = DrawLayer.Front
    aura2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(aura2, tornadus.Position.X, tornadus.Position.Y)
  end)

  SOUND:PlayBattleSE('EVT_Battle_Transition')
  GAME:WaitFrames(20)

  -- ================================================================
  -- DIALOGUE PRÉ-COMBAT — Boréas et les héros (2-4 minutes)
  -- ================================================================
  -- Les héros ne connaissent pas Tornadus. Ils sont jeunes, inexpérimentés.
  -- Tornadus les interroge : intrusion ou espoir ? Le vent monte avec ses émotions.

  -- PHASE A — OBSERVATION (Tornadus regarde, les héros ont peur)
  GAME:MoveCamera(224, 206, 40, false)
  GAME:WaitFrames(40)

  -- Tornadus observe en silence
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
  end)
  GAME:WaitFrames(30)

  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_050']))
  -- "..."
  GAME:WaitFrames(30)

  -- Le partenaire, terrifié
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_051']))
  -- "Il... il nous regarde."
  GAME:WaitFrames(20)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_052']), "Worried")
  -- "(Je n'ai jamais rien vu de pareil...)"
  GAME:WaitFrames(30)

  -- PHASE B — QUESTIONNEMENT
  GAME:MoveCamera(224, 216, 30, false)
  GAME:WaitFrames(15)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_053']))
  -- "Pourquoi êtes-vous venus jusqu'ici ?"
  GAME:WaitFrames(25)

  -- Le partenaire hésite
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GROUND:CharTurnToCharAnimated(partner, tornadus, 4)
  GAME:WaitFrames(8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_054']))
  -- "On... on fait partie de la guilde. On est en expédition."
  GAME:WaitFrames(20)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_055']))
  -- "La guilde. Encore des grimpeurs. Toujours les mêmes."
  GAME:WaitFrames(20)

  -- Le vent réagit à l'émotion de Tornadus
  pcall(function()
    local windReact = RogueEssence.Content.FiniteOverlayEmitter()
    windReact.FadeIn = 10
    windReact.TotalTime = 40
    windReact.RepeatX = true
    windReact.Movement = RogueElements.Loc(-100, 0)
    windReact.Layer = DrawLayer.Front
    windReact.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(windReact, 224, 200)
  end)
  GAME:WaitFrames(15)

  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_056']))
  -- "Savez-vous seulement où vous mettez les pieds ?"
  GAME:WaitFrames(30)

  -- PHASE C — MALENTENDU
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_057']))
  -- "On ne veut de mal à personne !"
  GAME:WaitFrames(25)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Sad")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_058']))
  -- "Comprendre ? Vous montez, vous prenez, vous repartez."
  GAME:WaitFrames(25)

  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_059']), "Worried")
  -- "(Il est en colère... Mais pourquoi ?)"
  GAME:WaitFrames(20)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_060']))
  -- "Ce sommet n'est pas un trophée."
  GAME:WaitFrames(20)

  -- Le vent monte avec la colère
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
  pcall(function()
    local angerWind = RogueEssence.Content.FiniteOverlayEmitter()
    angerWind.FadeIn = 5
    angerWind.TotalTime = 60
    angerWind.RepeatX = true
    angerWind.Movement = RogueElements.Loc(-140, 0)
    angerWind.Layer = DrawLayer.Front
    angerWind.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(angerWind, 224, 180)
  end)
  GAME:WaitFrames(20)

  -- PHASE D — ESCALADE
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_061']))
  -- "Depuis combien de temps croyez-vous que je souffle ici ?"
  GAME:WaitFrames(25)

  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_062']))
  -- "Je... je ne sais pas..."
  GAME:WaitFrames(20)

  GAME:MoveCamera(224, 198, 30, false)
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_063']))
  -- "Depuis avant vos routes. Avant vos guildes. Avant vos noms."
  GAME:WaitFrames(30)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Angry")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_064']))
  -- "Et vous arrivez. Sans demander. Sans écouter."
  GAME:WaitFrames(20)

  -- Rafale — l'équipe recule
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 20))
  pcall(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
    GAME:WaitFrames(4)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
  end)
  GAME:WaitFrames(20)

  -- PHASE E — LES HÉROS EXPLIQUENT
  pcall(function() GROUND:CharSetEmote(partner, "determined", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_065']))
  -- "On écoute ! C'est pour ça qu'on est montés !"
  GAME:WaitFrames(25)

  GAME:WaitFrames(30)
  GAME:MoveCamera(224, 206, 30, false)
  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_066']))
  -- "...Vous cherchez les angles."
  GAME:WaitFrames(25)

  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_067']))
  -- "Les... les quoi ?"
  GAME:WaitFrames(20)

  -- La révélation — plan serré
  GAME:MoveCamera(224, 194, 30, false)
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_068']))
  -- "Rien de naturel n'a d'angles. Et pourtant ils sont là. Sous votre monde."
  GAME:WaitFrames(40)

  -- PHASE F — TRANSITION VERS LE COMBAT
  GAME:MoveCamera(224, 216, 30, false)
  GAME:WaitFrames(20)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_069']))
  -- "Je ne sais pas si vous êtes une menace... ou un espoir."
  GAME:WaitFrames(30)

  UI:SetSpeaker(tornadus)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_070']))
  -- "Alors je vais le découvrir."
  GAME:WaitFrames(15)

  -- EXPLOSION DE VENT — transition combat
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(5, 8, 20))
  pcall(function()
    local cw1 = RogueEssence.Content.FiniteOverlayEmitter()
    cw1.FadeIn = 2; cw1.TotalTime = 40; cw1.RepeatX = true
    cw1.Movement = RogueElements.Loc(-200, 0); cw1.Layer = DrawLayer.Front
    cw1.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(cw1, 224, 200)
    local cw2 = RogueEssence.Content.FiniteOverlayEmitter()
    cw2.FadeIn = 2; cw2.TotalTime = 40; cw2.RepeatX = true
    cw2.Movement = RogueElements.Loc(200, 0); cw2.Layer = DrawLayer.Front
    cw2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
    GROUND:PlayVFX(cw2, 224, 200)
  end)

  -- L'équipe se prépare
  pcall(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
    GROUND:CharSetEmote(partner, "determined", 1)
    GROUND:CharSetEmote(hero, "determined", 1)
  end)
  GAME:WaitFrames(20)

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountGuardianSeen = true
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_guardian_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 224, 192, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(tornadus, "Charge", true)

  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GAME:MoveCamera(224, 232, 1, false)

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
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_011']))
  -- "Cette fois, on le terrasse. Promis, [hero]."

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
-- Enjeu maximal ici : c'est la CLOTURE de l'expedition du chapitre 5.
local function DefeatedBossBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tornadus = CharacterEssentials.MakeCharactersFromList({
    {'Tornadus', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Charge", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GAME:MoveCamera(224, 232, 1, false)

  GAME:CutsceneMode(true)
  --REFONTE CINÉ 2026-07-30 : stabilisation avant FadeIn.
  pcall(function()
    GROUND:CharSetAnim(hero, "Idle", true)
    GROUND:CharSetAnim(partner, "Idle", true)
    if t2 ~= nil then GROUND:CharSetAnim(t2, "Idle", true) end
    if t3 ~= nil then GROUND:CharSetAnim(t3, "Idle", true) end
  end)
  GAME:WaitFrames(60)
  GAME:FadeIn(60)

  GAME:WaitFrames(40)

  -- Tornadus collapses dramatically
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 20))
  GROUND:CharSetAnim(tornadus, "Idle", true)

  --REFONTE CINÉ 2026-07-30 : l'equipe entoure le gardien vaincu.
  --Chacun regarde Tornadus avec un melange de respect et de soulagement.
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
    if t2 ~= nil then GROUND:CharAnimateTurnTo(t2, Direction.Up, 4) end
    if t3 ~= nil then GROUND:CharAnimateTurnTo(t3, Direction.Up, 4) end
  end)

  GAME:WaitFrames(60)

  -- The storm clears
  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  --REFONTE CINÉ 2026-07-30 : le partenaire se redresse, incredul.
  --L'equipe entiere reagit en cascade — pas seulement partner.
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(8)
  pcall(function()
    if t2 ~= nil then GROUND:CharSetEmote(t2, "notice", 1) end
  end)
  GAME:WaitFrames(6)
  pcall(function()
    if t3 ~= nil then GROUND:CharSetEmote(t3, "happy", 1) end
  end)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_012']))
  -- "On...[pause=10] On l'a vaincu !"

  GAME:WaitFrames(30)
  -- Le partenaire regarde le ciel qui se dégage
  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  GAME:WaitFrames(8)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_013']))
  -- "Regarde ! L'orage se dissipe..."

  GAME:WaitFrames(20)
  -- Se tourne vers le héros, pensif
  GROUND:CharTurnToCharAnimated(partner, hero, 4)
  GAME:WaitFrames(6)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_014']))
  -- "Cette voix...[pause=15] Elle a dit quelque chose à propos de ruines ancestrales."

  GAME:WaitFrames(20)
  -- Le héros répond, déterminé
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_015']), "Determined")
  -- "C'est là qu'on va. Vers les Ruines du Cloven."

  -- LOT 8.3 — bilan de l'expedition : ce qui a change en chemin.
  GAME:WaitFrames(15)
  GAME:MoveCamera(224, 218, 40, false)
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
  GAME:MoveCamera(224, 206, 40, false)
  -- L'équipe lève les yeux vers Tornadus
  pcall(function()
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  GAME:WaitFrames(8)
  UI:SetSpeaker(tornadus)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_044']))
  -- "Alors c'est a vous, maintenant. J'en suis heureux. C'etait lourd."
  GAME:WaitFrames(18)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_045']))
  -- "Descendez. Dormez. Mangez. Personne ne resout une forme le ventre vide."
  -- Le partenaire réagit, mi-amusé mi-touché
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_046']))
  -- "Et quand vous trouverez les angles — ne supposez pas qu'ils ont ete
  --  batis pour vous garder DEHORS."
  GAME:WaitFrames(28)

  GAME:MoveCamera(224, 248, 40, false)
  --REFONTE CINÉ 2026-07-30 : l'equipe se regarde, partage le moment.
  pcall(function()
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    if t2 ~= nil then GROUND:CharTurnToCharAnimated(t2, t3, 4) end
    if t3 ~= nil then GROUND:CharTurnToCharAnimated(t3, partner, 4) end
  end)
  GAME:WaitFrames(8)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_036']))
  -- "On est montes ici pour l'expedition. Je l'avais oublie."
  GAME:WaitFrames(15)
  GROUND:CharTurnToCharAnimated(hero, partner, 4)
  GAME:WaitFrames(6)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_037']), "Normal")
  -- "Moi aussi. Quelque part en route, c'est devenu autre chose."
  GAME:WaitFrames(20)

  --REFONTE CINÉ 2026-07-30 : reactions de t2/t3 au moment de verite.
  pcall(function()
    if t2 ~= nil then GROUND:CharSetEmote(t2, "notice", 1) end
    if t3 ~= nil then GROUND:CharSetEmote(t3, "happy", 1) end
  end)
  GAME:WaitFrames(10)

  -- Le partenaire se redresse, galvanisé
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "glowing", 1) end)
  GAME:WaitFrames(6)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_016']))
  -- "Alors allons-y ! La fin de l'expédition nous attend !"

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)

  -- Tornadus disappears in a whirlwind
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
    {'Tornadus', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(tornadus, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 240, 272, Direction.Up)
  GROUND:TeleportTo(partner, 208, 272, Direction.Up)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, 176, 288, Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, 272, 288, Direction.Up) end
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(224, 232, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(224, 205, 40, false)
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
  GAME:MoveCamera(224, 250, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
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
