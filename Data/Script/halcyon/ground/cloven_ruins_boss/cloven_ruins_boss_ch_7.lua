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
  GAME:MoveCamera(144, 168, 40, false)
  for i = 1, 5 do
    SOUND:PlayBattleSE('EVT_Emote_Shock_2')
    BossFX.Flash(zx[i], 152, 2, 3, 12)
    GROUND:Unhide(zid[i])
    GAME:WaitFrames(10)
  end
  GAME:WaitFrames(15)

  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
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
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_031']))
  end
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_032']), "Normal")
  GAME:WaitFrames(12)
  if partner ~= nil then
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Determined")
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
    {'Regirock', 96, 120, Direction.Down}
  })
  local regice = CharacterEssentials.MakeCharactersFromList({
    {'Regice', 144, 112, Direction.Down}
  })
  local registeel = CharacterEssentials.MakeCharactersFromList({
    {'Registeel', 192, 120, Direction.Down}
  })
  GROUND:Hide('Regirock')
  GROUND:Hide('Regice')
  GROUND:Hide('Registeel')
  GAME:MoveCamera(144, 148, 40, false)

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
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_039']))
  end
  GAME:WaitFrames(12)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_040']))
  GAME:WaitFrames(12)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRB_041']), "Worried")
  GAME:WaitFrames(20)

  -- La camera recule : les trois gardiens ET ce qui dort derriere eux.
  GAME:MoveCamera(144, 176, 50, false)
  GAME:WaitFrames(15)

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

-- Corps de la cinematique, appele sous pcall par DefeatedBoss() : toute erreur
-- Lua ici ne doit JAMAIS laisser le joueur sur un ecran noir definitif.
local function DefeatedBossBody()
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
  -- Pose du Titan vaincu : "Faint" n'est pas une anim ground garantie pour
  -- toutes les especes -> GetAnimIndex("Faint") pouvait lever une erreur et
  -- couper la cinematique (ecran noir). "EventSleep" est une anim ground sure.
  GROUND:CharSetAnim(regigigas, "EventSleep", true)

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
end

function cloven_ruins_boss_ch_7.DefeatedBoss()
  PrintInfo("[BossSeq][cloven_ruins_boss_ch_7] DefeatedBoss cutscene start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  -- Flag de progression + sortie garantis, quoi qu'il arrive.
  SV.Chapter7.SawAnimaCoreCorruption = true
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][cloven_ruins_boss_ch_7] DefeatedBoss -> guild_third_floor_lobby")
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

  -- Les trois gardiens sont la aussi : la defaite se joue devant la veille
  -- au complet, pas devant le seul Titan.
  local regirock = CharacterEssentials.MakeCharactersFromList({
    {'Regirock', 96, 120, Direction.Down}
  })
  local regice = CharacterEssentials.MakeCharactersFromList({
    {'Regice', 144, 112, Direction.Down}
  })
  local registeel = CharacterEssentials.MakeCharactersFromList({
    {'Registeel', 192, 120, Direction.Down}
  })
  GROUND:CharSetAnim(regirock, "Idle", true)
  GROUND:CharSetAnim(regice, "Idle", true)
  GROUND:CharSetAnim(registeel, "Idle", true)

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

  -- Les trois regagnent leurs niches : la veille reprend, la porte se referme.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRB_042']))
  UI:SetCenter(false)
  GAME:WaitFrames(12)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
