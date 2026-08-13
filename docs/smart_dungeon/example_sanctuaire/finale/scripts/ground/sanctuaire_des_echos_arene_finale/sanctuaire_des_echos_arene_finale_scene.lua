-- Smart Dungeon boss scene; flow modeled after Vast Steppe Guardian.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sanctuaire_des_echos_arene_finale_scene = {}

local function state()
  SV.smart_dungeon = SV.smart_dungeon or {}
  SV.smart_dungeon['sanctuaire_des_echos'] = SV.smart_dungeon['sanctuaire_des_echos'] or {seen=false, won=false, lost=false, completed=false}
  return SV.smart_dungeon['sanctuaire_des_echos']
end

local function make_boss()
  local monster = RogueEssence.Dungeon.MonsterID('absol', 0, 'normal', Gender.Genderless)
  local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(176, 136), Direction.Down, '', 'Boss')
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  return chara
end

function sanctuaire_des_echos_arene_finale_scene.Introduction()
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local boss = make_boss()
  GROUND:Hide('Boss')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 88, Direction.Up)
  GAME:MoveCamera(176, 112, 1, false)
  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)
  GROUND:Unhide('Boss')
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  GAME:WaitFrames(20)
  UI:SetSpeaker(boss)
  UI:WaitShowDialogue('Vous avez atteint le cœur de ce lieu. Montrez-moi votre détermination !')
  COMMON.BossTransition()
  state().seen = true
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon('sanctuaire_des_echos', 3, 0, 0,
    RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function sanctuaire_des_echos_arene_finale_scene.Victory()
  pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local boss = make_boss()
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 88, Direction.Up)
  GAME:MoveCamera(176, 112, 1, false)
  GAME:FadeIn(40)
  UI:SetSpeaker(boss)
  UI:WaitShowDialogue('Votre force est réelle. Le passage peut désormais s'achever.')
  state().completed = true
  GAME:FadeOut(false, 40)
  -- Fallback project route. A narrative destination can override this candidate.
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
    'master_zone', -1, 1, 0, true, true)
end

function sanctuaire_des_echos_arene_finale_scene.Defeat()
  state().lost = false
  GAME:CutsceneMode(true)
  GAME:FadeIn(20)
  UI:ResetSpeaker()
  UI:WaitShowDialogue('La confrontation est perdue. Il faudra reprendre le parcours.')
  GAME:FadeOut(false, 40)
  GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Downed,
    'master_zone', -1, 1, 0, true, true)
end

return sanctuaire_des_echos_arene_finale_scene
