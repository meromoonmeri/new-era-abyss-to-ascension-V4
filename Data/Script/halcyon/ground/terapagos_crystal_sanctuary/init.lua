require 'origin.common'
require 'halcyon.PartnerEssentials'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro();COMMON.RespawnAllies(true);PartnerEssentials.InitializePartnerSpawn() end
function M.Enter(map)
 local hero,partner=CH('PLAYER'),CH('Teammate1');GAME:CutsceneMode(true)
 GROUND:TeleportTo(hero,300,535,Direction.Up);if partner then GROUND:TeleportTo(partner,366,535,Direction.Up) end
 local mon=RogueEssence.Dungeon.MonsterID('terapagos',0,'normal',Gender.Genderless)
 local boss=RogueEssence.Ground.GroundChar(mon,RogueElements.Loc(333,310),Direction.Down,'Terapagos','Terapagos');boss:ReloadEvents();GAME:GetCurrentGround():AddTempChar(boss)
 GAME:MoveCamera(333,350,1,false);GAME:FadeIn(30);GAME:WaitFrames(30)
 local a=TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero,307,397,false,1) end)
 local b=TASK:BranchCoroutine(function() if partner then GROUND:MoveToPosition(partner,360,397,false,1) end end);TASK:JoinCoroutines({a,b})
 GROUND:CharTurnToCharAnimated(hero,boss,4);if partner then GROUND:CharTurnToCharAnimated(partner,boss,4) end
 GROUND:CharSetEmote(boss,'notice',1);GAME:WaitFrames(20)
 UI:SetSpeaker(boss);UI:WaitShowDialogue('Le cristal conserve chaque lumière… et chaque promesse.')
 COMMON.BossTransition();GAME:CutsceneMode(false);GAME:ContinueDungeon('waterfall_pond',5,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
end
function M.Exit(map) end function M.Update(map,time) end function M.GameSave(map) end function M.GameLoad(map) GAME:FadeIn(20) end
return M
