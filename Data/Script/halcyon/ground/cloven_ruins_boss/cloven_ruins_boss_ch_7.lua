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
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Carte 240x320 px : entrée par le sud, cellules walkables vérifiées.
  GROUND:TeleportTo(hero, 152, 240, Direction.Up)
  GROUND:TeleportTo(partner, 120, 240, Direction.Up)
  GAME:MoveCamera(136, 176, 1, false)

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
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_001']))
  -- "Le cœur des ruines... Il bat encore."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
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
  UI:SetSpeakerEmotion("Surprised")
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

  -- === FLASH + EMERGENCE DE REGIGIGAS ===
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 6, 18)

  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 144, 128, Direction.Down}
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
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_007']))
  -- "REGIGIGAS ! Le Titan des Ruines !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_008']))
  -- "Il protège ce qui reste du Cœur. Si tu le vaines, le Cœur est à toi."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_009']))
  -- "Si tu échoues... ce Cœur s'éteindra pour toujours."

  GAME:WaitFrames(30)

  -- Regigigas émet un grondement, le sol tremble
  BossFX.ShakeScreen(8, 30)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_010']))
  -- "Alors on ne peut pas perdre. [hero], à nous !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_boss_ch_7.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 144, 128, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(regigigas, "Idle", true)

  GROUND:TeleportTo(hero, 152, 240, Direction.Up)
  GROUND:TeleportTo(partner, 120, 240, Direction.Up)
  GAME:MoveCamera(136, 176, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_011']))
  -- "Cette fois, on le terrasse !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_boss_ch_7.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local regigigas = CharacterEssentials.MakeCharactersFromList({
    {'Regigigas', 144, 128, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 152, 224, Direction.Up)
  GROUND:TeleportTo(partner, 120, 224, Direction.Up)
  GAME:MoveCamera(136, 176, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In the Depths of the Pit.ogg', false)

  GAME:WaitFrames(40)
  SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
  BossFX.ShakeScreen(6, 20)
  GROUND:CharSetAction(regigigas, RogueEssence.Ground.PoseGroundAction(
    regigigas.Position, regigigas.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  GAME:WaitFrames(60)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_012']))
  -- "On a vaincu le Titan !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_013']))
  -- "Le Cœur... il bat plus fort maintenant."

  GAME:WaitFrames(20)
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

  SV.Chapter7.SawAnimaCoreCorruption = true
  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
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
    {'Regigigas', 144, 128, Direction.Down}
  })
  GROUND:CharSetAnim(regigigas, "Idle", true)

  -- L'équipe est au sol, vaincue, au pied du Titan.
  GROUND:TeleportTo(hero, 160, 230, Direction.Up)
  GROUND:TeleportTo(partner, 128, 230, Direction.Up)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  GROUND:CharSetAnim(partner, "EventSleep", true)
  GAME:MoveCamera(144, 210, 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- La caméra monte lentement le long du colosse.
  GAME:MoveCamera(144, 150, 60, false)
  GAME:WaitFrames(10)

  -- Le Titan se redresse, les veines dorées pulsent.
  BossFX.ShakeScreen(4, 20)
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_019']))
  UI:SetCenter(false)
  GAME:WaitFrames(20)

  -- La Voix de l'Abysse commente la défaite.
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
  GAME:MoveCamera(144, 220, 40, false)
  GROUND:CharEndAnim(partner)
  GeneralFunctions.DoAnimation(partner, 'Wake')
  GAME:WaitFrames(12)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Pain")
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

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GROUND:CharEndAnim(hero)
  GROUND:CharEndAnim(partner)
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][cloven_ruins_boss] DiedToBoss -> cloven_ruins_entrance")
  GAME:EnterGroundMap("cloven_ruins_entrance", "Main_Entrance_Marker")
end

return cloven_ruins_boss_ch_7
