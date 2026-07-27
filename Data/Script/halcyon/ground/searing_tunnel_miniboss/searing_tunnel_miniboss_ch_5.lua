--[[ 
    searing_tunnel_miniboss_ch_5.lua
    Tunnel Incandescent — Mini-Boss : Torkoal + Magmar
    Apparition : Torkoal émerge de la vapeur, Magmar tombe du plafond en flammes
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

searing_tunnel_miniboss_ch_5 = {}

function searing_tunnel_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 440, Direction.Up)
  GROUND:TeleportTo(partner, 272, 440, Direction.Up)
  -- CADRAGE : la camera doit demarrer SUR le duo (y~440).
  GAME:MoveCamera(256, 420, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  -- Team walks through the tunnel
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    -- La camera suit le duo pendant sa marche vers le nord (64px).
    GAME:MoveCamera(256, 356, 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_001']))
  -- "Cette chaleur devient étouffante... On doit approcher d'une poche de magma."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_002']))
  -- "Tu entends ça, [hero] ? On dirait... de la vapeur sous pression."

  GAME:WaitFrames(30)

  -- === STEAM BEGINS TO FILL THE CHAMBER ===
  SOUND:FadeOutBGM(40)
  SOUND:LoopSE("Light Earthquake")

  local steamEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  steamEmitter.FadeIn = 40
  steamEmitter.TotalTime = 120
  steamEmitter.Layer = DrawLayer.Back
  steamEmitter.Anim = RogueEssence.Content.BGAnimData("Steam", 2)
  GROUND:PlayVFX(steamEmitter, 256, 200)

  local continueSteam = true
  coro1 = TASK:BranchCoroutine(function()
    while continueSteam do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_003']))
    -- "De la vapeur ! Elle vient de partout !"
    continueSteam = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Light Earthquake", 30)
  GAME:WaitFrames(30)

  -- === LA VOIX DE L'ABYSSE PARLE EN PREMIER ===
  -- Ordre impose : Voix -> Flash -> Emergence thematique.
  BossFX.Voice('STM_006')
  GAME:WaitFrames(20)

  -- === PANORAMIQUE VERS LE HAUT — les boss surgissent vers y=208-232 ===
  GAME:MoveCamera(256, 280, 60, false)
  GAME:WaitFrames(10)

  -- === FLASH BLANC ===
  BossFX.Flash(256, 220)
  GAME:WaitFrames(10)

  -- === TORKOAL EMERGE DE LA LAVE (signature FEU) ===
  -- Vapeur sous pression, panache de lave, braises : pas un simple flash.
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.DownRight}
  })
  GROUND:Hide('Torkoal')
  BossFX.EmergeFire(torkoal, 220, 232)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Impact(8)

  -- Braises jaillissant de la carapace de Torkoal.
  -- "Ember" est une PARTICULE (Content/Particle) : elle doit passer par un
  -- SingleEmitter/AnimData. En BGAnimData l'effet ne s'affichait pas du tout.
  BossFX.Particle("Ember", 220, 232, 4)
  BossFX.Particle("Ember", 204, 238, 5)
  BossFX.Particle("Ember", 236, 238, 5)

  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Left, 4, 1, 1)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_004']))
  -- "Un Torkoal ! Il nous barre la route !"

  GAME:WaitFrames(20)

  -- === MAGMAR TOMBE DU PLAFOND EN FLAMMES (signature FEU) ===
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.DownLeft}
  })
  GROUND:Hide('Magmar')
  GROUND:TeleportTo(magmar, 292, 208 - 140, Direction.Down)
  GROUND:Unhide('Magmar')
  BossFX.Particle("Lava_Plume_Fire", 292, 208 - 120, 3)
  SOUND:PlayBattleSE('DUN_Fire_Spin')
  GROUND:MoveToPosition(magmar, 292, 208, false, 7)
  BossFX.Particle("Fire_Blast", 292, 212, 3)
  BossFX.Particle("Ember", 276, 214, 4)
  BossFX.Particle("Ember", 308, 214, 4)
  BossFX.Flash(292, 208)
  BossFX.Impact(10)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Right)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_007']))
  -- "Cette voix, encore !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_008']))
  -- "Ils gardent les fournaises depuis des siècles. Leur chaleur te consumera."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_009']))
  -- "À moins que tu ne prouves ta propre flamme..."

  GAME:WaitFrames(30)

  -- Torkoal releases smoke, Magmar crackles with fire
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(torkoal, "Idle", true)
    local smoke = RogueEssence.Content.FiniteOverlayEmitter()
    smoke.FadeIn = 10
    smoke.TotalTime = 50
    smoke.Layer = DrawLayer.Front
    smoke.Anim = RogueEssence.Content.BGAnimData("Fog", 0)
    GROUND:PlayVFX(smoke, torkoal.Position.X, torkoal.Position.Y - 16)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    BossFX.Particle("Ember", magmar.Position.X, magmar.Position.Y, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_010']))
  -- "On n'a pas fait tout ce chemin pour rien ! [hero], en avant !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.TunnelMiniBossSeen = true
  PrintInfo("[NREPROBE][transition] searing_tunnel_miniboss_ch_5.lua ContinueDungeon('searing_tunnel', 1)") GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:TeleportTo(hero, 240, 380, Direction.Up)
  GROUND:TeleportTo(partner, 272, 380, Direction.Up)
  -- CADRAGE : duo (y~380) et boss (y~208-232) dans le meme cadre.
  GAME:MoveCamera(256, 300, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_011']))
  -- "De retour. Cette fois, on est prêts !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] searing_tunnel_miniboss_ch_5.lua ContinueDungeon('searing_tunnel', 1)") GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
local function DefeatedBossBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  -- Pose des boss vaincus : "Faint" n'existe pas comme anim ground pour toutes
  -- les especes -> GetAnimIndex("Faint") levait une erreur et coupait la
  -- cinematique (ecran noir). "EventSleep" est une anim ground sure.
  GROUND:CharSetAnim(torkoal, "EventSleep", true)
  GROUND:CharSetAnim(magmar, "EventSleep", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 320, Direction.Up)
  GROUND:TeleportTo(partner, 272, 320, Direction.Up)
  -- CADRAGE : duo (y~320) et boss au sol (y~208-232) dans le meme cadre.
  GAME:MoveCamera(256, 270, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_012']))
  -- "On a survécu à la fournaise !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_013']))
  -- "Cette voix...[pause=15] Elle semble tout savoir de ce donjon."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_014']), "Normal")
  -- "C'est comme si elle nous testait. Continuons."

  GAME:WaitFrames(20)

  -- Torkoal and Magmar fade into steam
  local fadeSteam = RogueEssence.Content.FlashEmitter()
  fadeSteam.FadeInTime = 2
  fadeSteam.HoldTime = 2
  fadeSteam.FadeOutTime = 20
  fadeSteam.StartColor = Color(255, 200, 100, 0)
  fadeSteam.Layer = DrawLayer.Top
  fadeSteam.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeSteam, 256, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Torkoal')
  GROUND:Hide('Magmar')
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function searing_tunnel_miniboss_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DefeatedBoss cutscene start")
  SV.Chapter5.TunnelMiniBossCleared = true

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  -- Sortie garantie, quoi qu'il arrive.
  GAME:CutsceneMode(false)
  PrintInfo("[NREPROBE][transition] searing_tunnel_miniboss_ch_5.lua ContinueDungeon('searing_tunnel', 2)") GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Player died to the boss
-- Réécrite (audit IsGameOver) : l'ancienne version était un collage corrompu —
-- dialogues AVANT CutsceneMode/FadeIn (affichés hors cinématique), répliques de
-- VICTOIRE mélangées dans la défaite, héros/partenaire cachés en pleine scène.
-- Storyboard : fondu -> triomphe du boss -> la Voix -> le duo à terre -> retraite
-- du boss -> fondu noir -> retour à l'entrée.
function searing_tunnel_miniboss_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DiedToBoss cutscene start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  GROUND:CharSetAnim(torkoal, "Idle", true)
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })
  GROUND:CharSetAnim(magmar, "Idle", true)

  -- L'équipe est au sol, vaincue.
  GROUND:TeleportTo(hero, 240, 320, Direction.Up)
  GROUND:TeleportTo(partner, 208, 320, Direction.Up)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(256, 255, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte sur le vainqueur.
  GAME:MoveCamera(256, 215, 40, false)
  GAME:WaitFrames(10)

  -- Le boss triomphe.
  GROUND:CharSetEmote(torkoal, "happy", 1)
  GeneralFunctions.Hop(torkoal)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_018']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- La Voix de l'Abysse commente la défaite.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_015']))
  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_016']))
  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_019']))
  GAME:WaitFrames(30)

  -- La caméra redescend sur le duo ; le partenaire se redresse à peine.
  GAME:MoveCamera(256, 265, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
  UI:WaitShowDialogue("Trop... trop chaud...[pause=20] On ne passera pas cette fois...")
  GAME:WaitFrames(20)

  -- Le boss se retire, victorieux.
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_020']))
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
  PrintInfo("[BossSeq][searing_tunnel_miniboss_ch_5] DiedToBoss -> searing_tunnel_entrance")
  GAME:EnterGroundMap("searing_tunnel_entrance", "Main_Entrance_Marker")
end

return searing_tunnel_miniboss_ch_5
