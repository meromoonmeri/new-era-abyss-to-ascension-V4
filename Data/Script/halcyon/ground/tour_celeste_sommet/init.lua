--[[
  tour_celeste_sommet/init.lua
  Tour Céleste — Sommet (D13P03) — Boss Rayquaza — PMD Red authentique 1:1
  Source: PMD-5/Data/Ground/sky_tower_end.rsground (69x75) + PMDRed D13P03 (19 dialogues, Flash, Shake, BGM)
  Preserve integrite: 69x75, Sheet SkyTowerEnd_Base, 3 Spawners TEAMMATE_1/2/3, Markers Main_Entrance/Boss_Marker/Cutscene_Marker
  Boss: Rayquaza (boss_celestial rayquaza) — VFX PMDRed : FLASH_TO/FROM, SHAKE, EVT_Roar
  Choregraphie: CAMERA_INIT_PAN, FLASH_TO 8 WHITE, SHAKE, BGM_SWITCH Rayquaza, BGM_FADEOUT 120
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

local sommet = {}

local function RayquazaVFX_SkyTowerEnd()
  -- VFX fidèle D13P03 : double flash blanc + shake + roar (PMD Red macro CALL_SCRIPT(SHOCK_FUNC))
  local center = GAME:GetCameraCenter()
  BossFX.Flash(center.X, center.Y, 3, 5, 15) -- FLASH_TO 8
  GAME:WaitFrames(8)
  BossFX.Flash(center.X, center.Y, 3, 5, 8)
  GAME:WaitFrames(8)
  SOUND:PlayBattleSE("EVT_Roar")
  BossFX.ShakeScreen(4, 20) -- SHAKE
  GAME:WaitFrames(20)
  BossFX.Flash(center.X, center.Y, 3, 5, 30) -- FLASH_TO 30
  GAME:WaitFrames(30)
  pcall(function() GAME:FadeIn(16) end) -- FLASH_FROM 16
end

function sommet.Init(map)
  pcall(function() GAME:FadeOut(false, 1) end)
  -- Pré-crée Rayquaza caché pour son portrait (même patron que Absol)
  -- Le GroundChar est créé à Boss_Marker, caché, pour permettre UI:SetSpeaker(rayquaza)
  local ok, ray = pcall(function()
    local m = GAME:GetCurrentGround():FindMarker("Boss_Marker")
    if m then
      local c = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', m.X, m.Y, Direction.Down}})
      GROUND:Hide('Rayquaza')
      return c
    end
  end)
end

-- POST-VICTOIRE — Ultralaser détruit la météorite (A04P03, PMD Red)
-- VFX: charge Hyper Beam, Flash 45, beam SingleEmitter, explosion, Shake
function sommet.PlayPostVictory(hero, partner, rayquaza, bx, by)
  -- Rayquaza déjà présent au Boss_Marker, équipe au sud
  GAME:CutsceneMode(true)
  GAME:MoveCamera(276, 300, 1, false)
  pcall(function() SOUND:PlayBGM("Rayquaza's Domain.ogg", true) end)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)
  -- Dialogue : Rayquaza accepte
  if rayquaza then
    UI:SetSpeaker(rayquaza)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_016']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_017']))
  end
  -- La météorite apparaît au nord (ciel) — VFX Flash + BGM World Calamity (A04P03)
  pcall(function() SOUND:PlayBGM("MUS_WORLD_CALAMITY.ogg", true) end)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  GAME:MoveCamera(276, 150, 60, false) -- pan vers le ciel
  GAME:WaitFrames(60)
  -- Flash 45 (A04P03)
  do local c=GAME:GetCameraCenter(); BossFX.Flash(c.X,c.Y,3,5,45); GAME:WaitFrames(45) end
  -- Rayquaza charge l'Ultralaser (anim Shoot + charge VFX)
  if rayquaza then GROUND:CharSetAnim(rayquaza, "Shoot", false) end
  GAME:WaitFrames(20)
  local emitterCharge = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Charge_Beam", 3))
  emitterCharge.LocHeight=16
  GROUND:PlayVFX(emitterCharge, bx, by)
  SOUND:PlayBattleSE("DUN_Hyper_Beam")
  GAME:WaitFrames(40)
  -- Flash 8 x2 avant tir (D13P03 + A04P03)
  do local c=GAME:GetCameraCenter(); BossFX.Flash(c.X,c.Y,3,5,15); GAME:WaitFrames(8); pcall(function() GAME:FadeIn(8) end); BossFX.Flash(c.X,c.Y,3,5,15); GAME:WaitFrames(8); pcall(function() GAME:FadeIn(8) end) end
  -- TIR : Hyper Beam du nord au sud vers la météorite (VFX beam)
  local emitterBeam = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Hyper_Beam", 3))
  emitterBeam.LocHeight=24
  -- Beam de Rayquaza (bx,by) vers ciel (bx, 40)
  GROUND:PlayVFX(emitterBeam, bx, by)
  SOUND:PlayBattleSE("DUN_Hyper_Beam")
  BossFX.ShakeScreen(6, 30)
  GAME:WaitFrames(30)
  -- Explosion météorite (Flash 45 + explosion VFX)
  local emitterExpl = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Explosion", 3))
  emitterExpl.LocHeight=32
  GROUND:PlayVFX(emitterExpl, bx, 40)
  SOUND:PlayBattleSE("DUN_Explosion")
  BossFX.Flash(bx, 40, 3, 5, 45)
  BossFX.ShakeScreen(8, 40)
  GAME:WaitFrames(45)
  pcall(function() GAME:FadeIn(16) end)
  GAME:WaitFrames(20)
  -- Dialogue après destruction
  if rayquaza then
    UI:SetSpeaker(rayquaza)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_018']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_019']))
  end
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCS_020']), "Happy")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_021']))
    GeneralFunctions.EndConversation(partner)
  end
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  -- Retour à la ville
  GAME:FadeOut(false, 60)
  GAME:CutsceneMode(false)
  SV.TemporaryFlags.TourCelestePostVictory = nil
  pcall(function() SV.TourCeleste.DefeatedRayquaza = true end)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
end

function sommet.Enter(map)
  -- Si victoire déjà posée (retour Zone ExitSegment), joue post-victoire directement
  if SV.TemporaryFlags and SV.TemporaryFlags.TourCelestePostVictory then
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    local bossM = GAME:GetCurrentGround():FindMarker("Boss_Marker")
    local bx, by = 276, 200
    if bossM then bx, by = bossM.X, bossM.Y end
    local rayquaza = nil
    pcall(function() rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', bx, by, Direction.Down}}) end)
    if rayquaza then pcall(function() GROUND:Unhide('Rayquaza') end) end
    if hero then GROUND:TeleportTo(hero, 276, 520, Direction.Up) end
    if partner then GROUND:TeleportTo(partner, 244, 520, Direction.Up) end
    GAME:MoveCamera(276, 400, 1, false)
    sommet.PlayPostVictory(hero, partner, rayquaza, bx, by)
    return
  end
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if partner then AI:DisableCharacterAI(partner) end
  -- Placement précis PMD-5 : Boss_Marker au nord (69x75, centre 276,300), équipe au sud
  local bossM = GAME:GetCurrentGround():FindMarker("Boss_Marker")
  local bx, by = 276, 200
  if bossM then bx, by = bossM.X, bossM.Y end
  -- Spawn Rayquaza (caché)
  local rayquaza = nil
  pcall(function()
    rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', bx, by, Direction.Down}})
    GROUND:Hide('Rayquaza')
  end)
  -- Téléporte équipe au sud (y ~ 500)
  if hero then GROUND:TeleportTo(hero, 276, 520, Direction.Up) end
  if partner then GROUND:TeleportTo(partner, 244, 520, Direction.Up) end
  if t2 then GROUND:TeleportTo(t2, 308, 536, Direction.Up) end
  if t3 then GROUND:TeleportTo(t3, 276, 552, Direction.Up) end
  GAME:MoveCamera(276, 400, 1, false)
  GAME:CutsceneMode(true)
  GAME:WaitFrames(40)
  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(40)
  UI:WaitHideTitle(20)
  -- BGM_SWITCH MUS_RAYQUAZAS_DOMAIN (D13P03 first action)
  pcall(function() SOUND:PlayBGM("Rayquaza's Domain.ogg", true) end)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end) -- fallback
  GAME:FadeIn(40)
  GAME:WaitFrames(20)
  -- Marche vers le nord (60px) — CAMERA_INIT_PAN + équipe avance
  local coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(partner, Direction.Up, 60, false, 1) end)
  local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8); GROUND:MoveInDirection(hero, Direction.Up, 60, false, 1) end)
  local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(276, 300, 90, false) end)
  TASK:JoinCoroutines({coro1, coro2, coro3})
  GAME:WaitFrames(20)
  -- Dialogue 1-2 (PMDRed D13P03_001)
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCS_001']), "Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_002']))
    GeneralFunctions.EndConversation(partner)
  end
  -- Double flash blanc (PMD Red FLASH_TO 8 / FLASH_FROM 8 x2)
  do
    local c = GAME:GetCameraCenter()
    BossFX.Flash(c.X, c.Y, 3, 5, 15)
    GAME:WaitFrames(8)
    pcall(function() GAME:FadeIn(8) end)
    GAME:WaitFrames(8)
    BossFX.Flash(c.X, c.Y, 3, 5, 15)
    GAME:WaitFrames(8)
    pcall(function() GAME:FadeIn(8) end)
  end
  GAME:WaitFrames(10)
  if rayquaza then UI:SetSpeaker(rayquaza); UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_003'])) end
  -- SHAKE + FLASH 30 (D13P03 mid)
  SOUND:PlayBattleSE("EVT_Roar")
  BossFX.ShakeScreen(4, 20)
  GAME:WaitFrames(20)
  do local c=GAME:GetCameraCenter(); BossFX.Flash(c.X,c.Y,3,5,30); GAME:WaitFrames(30); pcall(function() GAME:FadeIn(16) end) end
  if rayquaza then
    UI:SetSpeaker(rayquaza)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_004']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_005']))
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_006']))
  end
  -- Révélation Rayquaza
  pcall(function() GROUND:Unhide('Rayquaza') end)
  if rayquaza then
    GROUND:CharSetAnim(rayquaza, "Idle", true)
    BossFX.Flash(bx, by, 3, 5, 15)
    SOUND:PlayBattleSE("EVT_Roar")
  end
  local rc1 = TASK:BranchCoroutine(function() if partner then GeneralFunctions.EmoteAndPause(partner, "Shock", true) end end)
  local rc2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8); if hero then GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end end)
  TASK:JoinCoroutines({rc1, rc2})
  GAME:WaitFrames(20)
  if partner then
    GeneralFunctions.StartConversation(partner, STRINGS:Format(STRINGS.MapStrings['TCS_007']), "Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_008']))
    GeneralFunctions.EndConversation(partner)
  end
  -- Flash 8 / 4 / 16 sequence (D13P03 fin)
  do local c=GAME:GetCameraCenter(); BossFX.Flash(c.X,c.Y,3,5,15); GAME:WaitFrames(8); pcall(function() GAME:FadeIn(8) end) end
  GAME:WaitFrames(10)
  -- Rayquaza parle (6 dialogues)
  if rayquaza then
    UI:SetSpeaker(rayquaza)
    for i=9,14 do
      local k=string.format("TCS_%03d", i)
      pcall(function() UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[k])) end)
      GAME:WaitFrames(10)
    end
  end
  -- BGM_FADEOUT 120 (tension avant combat)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(30)
  if rayquaza then
    UI:SetSpeaker(rayquaza)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['TCS_015']))
  end
  SOUND:PlayBattleSE("EVT_Roar")
  GAME:WaitFrames(20)
  -- Re-BGM Rayquaza
  pcall(function() SOUND:PlayBGM("Rayquaza's Domain.ogg", true) end)
  pcall(function() SOUND:PlayBGM("Sky Tower.ogg", true) end)
  pcall(function() GAME:FadeIn(16) end)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- Transition boss
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  if partner then AI:EnableCharacterAI(partner) end
  -- Lance le donjon/boss : le Zone tour_celeste gère le combat via son arène
  -- Ici on est déjà sur la ground d'arène, on déclenche le combat direct
  -- Le Zone tour_celeste Segment final (boss) sera appelé via ContinueDungeon
  -- Pour ground seul, on simule l'entrée donjon :
  pcall(function() GAME:ContinueDungeon("tour_celeste", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false) end)
end

function sommet.Update(map) end
function sommet.GameSave(map) end
function sommet.GameLoad(map) GAME:FadeIn(20) end

return sommet
