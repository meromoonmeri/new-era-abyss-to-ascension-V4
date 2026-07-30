--[[ 
    mount_windswept_guardian_ch_5.lua
    Mont Venteux — Gardien : Aerodactyl
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
    -- La camera se cale ENTRE l'equipe (y=272) et le gardien (y=192).
    GAME:MoveCamera(224, 232, 40, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro2b, coro2c, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_001']))
  -- "Le sommet...[pause=15] On y est presque."

  GAME:WaitFrames(30)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

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

  -- === WHITE FLASH + LIGHTNING STRIKE ===
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
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(4, 8, 20))

  GAME:WaitFrames(10)

  -- === AERODACTYL DESCENDS FROM THE FLASH ===
  SOUND:PlayBattleSE('_UNK_EVT_003')

  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:Hide('Aerodactyl')

  -- LOT 8.3 — l'orage comme presence, le pacte du duo avant l'ultime gardien.
  GAME:MoveCamera(224, 250, 40, false)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_030']))
  -- "Cet orage n'est pas un phenomene. Il nous attendait."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_031']), "Determined")
  -- "Quoi qu'il se pose ici, on ne court pas. D'accord ?"
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
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
  GAME:MoveCamera(224, 232, 40, false)

  -- === APPARITION SOUS FLASH BLANC (LOT 2) ===
  SOUND:PlayBGM('Rising Fear.ogg', true)
  BossFX.Flash(224, 192, 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Aerodactyl')
  BossFX.Impact(9)
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

  -- Impact — ground shakes, dust everywhere
  local impactDust = RogueEssence.Content.FiniteOverlayEmitter()
  impactDust.FadeIn = 5
  impactDust.TotalTime = 50
  impactDust.Movement = RogueElements.Loc(-40, 0)
  impactDust.Layer = DrawLayer.Front
  impactDust.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
  GROUND:PlayVFX(impactDust, aerodactyl.Position.X - 24, aerodactyl.Position.Y + 16)

  local impactDust2 = RogueEssence.Content.FiniteOverlayEmitter()
  impactDust2.FadeIn = 5
  impactDust2.TotalTime = 50
  impactDust2.Movement = RogueElements.Loc(40, 0)
  impactDust2.Layer = DrawLayer.Front
  impactDust2.Anim = RogueEssence.Content.BGAnimData("Sandstorm", 1)
  GROUND:PlayVFX(impactDust2, aerodactyl.Position.X + 24, aerodactyl.Position.Y + 16)

  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(3, 5, 30))

  GAME:WaitFrames(15)
  SOUND:PlayBattleSE('EVT_Battle_Flash')

  -- Push the team back with the shockwave
  GAME:WaitFrames(20)
  local coro_push1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(partner, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
    BossFX.Impact(12)
  -- Signature ROCHE : l'impact fait s'ebouler la paroi, des blocs
  -- degringolent autour de l'arene.
  BossFX.RockFall(224, 200)
  BossFX.Particle("Rock_Pieces", 196, 208, 3)
  BossFX.Particle("Rock_Pieces", 252, 208, 3)
  end)
  local coro_push2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 8, 1, 1)
    GROUND:AnimateInDirection(hero, "Hurt", Direction.Down, Direction.Down, 8, 1, 2)
  end)
  TASK:JoinCoroutines({coro_push1, coro_push2})

  GAME:WaitFrames(30)
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_004']))
  -- "Un...[pause=10] UN AERODACTYL !"

  GAME:WaitFrames(30)
  -- Aerodactyl spreads its wings and roars
  GROUND:CharSetAnim(aerodactyl, "Charge", true)
  local wingWind = RogueEssence.Content.FiniteOverlayEmitter()
  wingWind.FadeIn = 10
  wingWind.TotalTime = 40
  wingWind.RepeatX = true
  wingWind.Movement = RogueElements.Loc(-180, 0)
  wingWind.Layer = DrawLayer.Front
  wingWind.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
  GROUND:PlayVFX(wingWind, aerodactyl.Position.X, aerodactyl.Position.Y)

  local wingWind2 = RogueEssence.Content.FiniteOverlayEmitter()
  wingWind2.FadeIn = 10
  wingWind2.TotalTime = 40
  wingWind2.RepeatX = true
  wingWind2.Movement = RogueElements.Loc(180, 0)
  wingWind2.Layer = DrawLayer.Front
  wingWind2.Anim = RogueEssence.Content.BGAnimData("Ominous_Wind", 1)
  GROUND:PlayVFX(wingWind2, aerodactyl.Position.X, aerodactyl.Position.Y)

  SOUND:PlayBattleSE('EVT_Battle_Transition')
  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)

  -- ================= LE GARDIEN DU CIEL PARLE =================
  -- C'est le boss de CLOTURE du chapitre 5, et il etait muet. Or il est le
  -- seul personnage du chapitre qui voit le monde d'en haut : c'est lui, et
  -- personne d'autre, qui peut donner au duo la premiere image d'ensemble
  -- du probleme. Il ne parle ni d'epreuve ni de garde — il decrit ce qu'il
  -- a VU. « Rien de naturel n'a d'angles » plante l'arc des Coeurs sans
  -- rien nommer : le joueur comprendra bien plus tard, le heros jamais ici.
  GAME:MoveCamera(224, 206, 40, false)
  UI:SetSpeaker(aerodactyl)
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
  GAME:MoveCamera(224, 198, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_041']))
  -- "Et il y a une forme sous votre monde, petits. Elle a des angles."
  GAME:WaitFrames(25)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_042']))
  -- "Rien de naturel n'a d'angles."
  GAME:WaitFrames(30)
  GAME:MoveCamera(224, 232, 40, false)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_043']))
  -- "Je porte ca sur le dos depuis longtemps. Montrez-moi que vous pouvez aussi."
  GAME:WaitFrames(22)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_010'], hero:GetDisplayName()))
  -- "Alors on va lui montrer que notre voyage ne fait que commencer ! [hero], à nous deux !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.MountGuardianSeen = true
  PrintInfo("[NREPROBE][transition] mount_windswept_guardian_ch_5.lua ContinueDungeon('mount_windswept', 3)") GAME:ContinueDungeon("mount_windswept", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function mount_windswept_guardian_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

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
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(aerodactyl, "Charge", true)

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
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  -- Aerodactyl collapses dramatically
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 20))
  -- LOT 2.3 — pas de PoseGroundAction/"Faint" : le gardien reste visible
  -- pendant les dialogues, puis disparait au flash blanc.
  GROUND:CharSetAnim(aerodactyl, "Idle", true)

  GAME:WaitFrames(60)

  -- The storm clears
  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_012']))
  -- "On...[pause=10] On l'a vaincu !"

  GAME:WaitFrames(30)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_013']))
  -- "Regarde ! L'orage se dissipe..."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_014']))
  -- "Cette voix...[pause=15] Elle a dit quelque chose à propos de ruines ancestrales."

  GAME:WaitFrames(20)
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
  UI:SetSpeaker(aerodactyl)
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

  GAME:MoveCamera(224, 248, 40, false)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_036']))
  -- "On est montes ici pour l'expedition. Je l'avais oublie."
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['MWG_037']), "Normal")
  -- "Moi aussi. Quelque part en route, c'est devenu autre chose."
  GAME:WaitFrames(20)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MWG_016']))
  -- "Alors allons-y ! La fin de l'expédition nous attend !"

  GAME:WaitFrames(30)
  SOUND:FadeOutBGM(60)

  -- Aerodactyl disappears in a whirlwind
  local whirlwind = RogueEssence.Content.FlashEmitter()
  whirlwind.FadeInTime = 2
  whirlwind.HoldTime = 2
  whirlwind.FadeOutTime = 20
  whirlwind.StartColor = Color(255, 255, 255, 0)
  whirlwind.Layer = DrawLayer.Top
  whirlwind.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(whirlwind, aerodactyl.Position.X, aerodactyl.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Aerodactyl')
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

  local aerodactyl = CharacterEssentials.MakeCharactersFromList({
    {'Aerodactyl', 224, 192, Direction.Down}
  })
  GROUND:CharSetAnim(aerodactyl, "Idle", true)

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
  GROUND:CharSetAnim(aerodactyl, "Charge", true)
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
