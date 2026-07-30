--[[
    crystal_sanctuary_miniboss_ch_8.lua
    Sanctuaire de Cristal — Mini-Boss : Strassie + Momartik
    (héraut et spectre du seuil, avant la chambre de Diancie)
    Simple : flash blanc + dialogues (directive utilisateur).
    Salle 456x456 px, ring de 2 tuiles de murs : plancher de (48,48) à (408,408).
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

crystal_sanctuary_miniboss_ch_8 = {}

local HERO_SPAWN = {220, 348}
local PARTNER_SPAWN = {252, 348}
local T2_SPAWN = {188, 364}
local T3_SPAWN = {284, 364}
local CAM_TEAM = {236, 310}
local CAM_FOYER = {248, 220}
local BOSS_1 = {196, 150}
local BOSS_2 = {300, 138}

local function PlaceTeam(hero, partner)
  GROUND:TeleportTo(hero, HERO_SPAWN[1], HERO_SPAWN[2], Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, PARTNER_SPAWN[1], PARTNER_SPAWN[2], Direction.Up) end
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, T2_SPAWN[1], T2_SPAWN[2], Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, T3_SPAWN[1], T3_SPAWN[2], Direction.Up) end
end

function crystal_sanctuary_miniboss_ch_8.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  -- NOIR AVANT LA MISE EN PLACE (patron searing_tunnel_miniboss : teleports
  -- et camera sous le fondu, plus de flash de la carte a l'arrivee).
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_TEAM[1], CAM_TEAM[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Crystal Cave.ogg', false)

  -- L'équipe s'avance vers le nord de la salle.
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    if partner ~= nil then GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1) end
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_001']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CSM_002']), "Normal")
  GAME:WaitFrames(20)

  -- Ordre imposé : Voix -> Flash -> Apparition.
  BossFX.Voice('CSM_003')
  GAME:WaitFrames(20)

  -- Strassie apparaît sous un flash blanc.
  local carbink = CharacterEssentials.MakeCharactersFromList({
    {'Carbink', BOSS_1[1], BOSS_1[2], Direction.DownRight}
  })
  GROUND:Hide('Carbink')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Flash(BOSS_1[1], BOSS_1[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Carbink')
  BossFX.Impact(7)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_004']))
  GAME:WaitFrames(20)

  -- Momartik apparaît sous un flash blanc.
  local froslass = CharacterEssentials.MakeCharactersFromList({
    {'Froslass', BOSS_2[1], BOSS_2[2], Direction.DownLeft}
  })
  GROUND:Hide('Froslass')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(10)
  BossFX.Flash(BOSS_2[1], BOSS_2[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Froslass')
  BossFX.Impact(7)

  GAME:WaitFrames(20)
  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_005']))
  GAME:WaitFrames(20)

  -- Le héraut et le spectre prennent la parole.
  UI:SetSpeaker(carbink)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_006']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(froslass)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_007']))
  GAME:WaitFrames(20)

  GAME:MoveCamera(CAM_TEAM[1], CAM_TEAM[2] - 40, 40, false)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_008']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter8.CrystalMiniBossSeen = true
  -- Segment 3 : l'arène de combat proprement dite.
  PrintInfo("[BossSeq][crystal_miniboss] ContinueDungeon('crystal_sanctuary', 3)")
  GAME:ContinueDungeon("crystal_sanctuary", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function crystal_sanctuary_miniboss_ch_8.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local carbink = CharacterEssentials.MakeCharactersFromList({
    {'Carbink', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local froslass = CharacterEssentials.MakeCharactersFromList({
    {'Froslass', BOSS_2[1], BOSS_2[2], Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(carbink, "Idle", true)
  GROUND:CharSetAnim(froslass, "Idle", true)
  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_009']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][crystal_miniboss] ContinueDungeon('crystal_sanctuary', 3)")
  GAME:ContinueDungeon("crystal_sanctuary", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

local function DefeatedBossBody()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local carbink = CharacterEssentials.MakeCharactersFromList({
    {'Carbink', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local froslass = CharacterEssentials.MakeCharactersFromList({
    {'Froslass', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(carbink, "Idle", true)
  GROUND:CharSetAnim(froslass, "Idle", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Crystal Cave.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(carbink)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_010']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(froslass)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_011']))
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_012']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CSM_013']), "Normal")
  GAME:WaitFrames(20)

  -- Le héraut et le spectre se dissolvent dans un flash blanc.
  BossFX.Flash(248, 150, 2, 2, 20)
  GAME:WaitFrames(16)
  pcall(function() GROUND:Hide('Carbink') end)
  pcall(function() GROUND:Hide('Froslass') end)
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function crystal_sanctuary_miniboss_ch_8.DefeatedBoss()
  PrintInfo("[BossSeq][crystal_sanctuary_miniboss_ch_8] DefeatedBoss start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  GAME:CutsceneMode(false)
  -- Segment 4 : les 3F au-dessus du mini-boss, vers la chambre de Diancie.
  PrintInfo("[BossSeq][crystal_sanctuary_miniboss_ch_8] -> ContinueDungeon(seg 4)")
  GAME:ContinueDungeon("crystal_sanctuary", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function crystal_sanctuary_miniboss_ch_8.DiedToBoss()
  PrintInfo("[BossSeq][crystal_sanctuary_miniboss_ch_8] DiedToBoss start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local carbink = CharacterEssentials.MakeCharactersFromList({
    {'Carbink', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  GROUND:CharSetAnim(carbink, "Idle", true)
  local froslass = CharacterEssentials.MakeCharactersFromList({
    {'Froslass', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(froslass, "Idle", true)

  PlaceTeam(hero, partner)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  UI:SetSpeaker(froslass)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CSM_014']))
  GAME:WaitFrames(20)
  BossFX.Voice('CSM_015')
  GAME:WaitFrames(20)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  GROUND:CharEndAnim(hero)
  if partner ~= nil then GROUND:CharEndAnim(partner) end
  GAME:CutsceneMode(false)

  -- Checkpoint : réveil au relais (WipedCutscene du relay).
  SV.Chapter8.SanctuaryMidState = 'DeathArrival'
  PrintInfo("[BossSeq][crystal_sanctuary_miniboss_ch_8] DiedToBoss -> crystal_sanctuary_relay")
  GAME:EnterGroundMap("crystal_sanctuary_relay", "Main_Entrance_Marker")
end

return crystal_sanctuary_miniboss_ch_8
