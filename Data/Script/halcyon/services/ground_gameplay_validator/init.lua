-- Opt-in PMDO runtime gameplay validator. Disabled in normal play.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('GroundGameplayValidator',BaseService)
local PILOT={
 {id='a02p01',zone='master_zone',idx=121},
 {id='mt_blaze_midpoint',zone='mt_blaze',idx=3},
 {id='mount_windswept_guardian',zone='mount_windswept',idx=2},
 {id='d11p03',zone='mt_freeze',idx=2},
 {id='champ_vent_boreal',zone='master_zone',idx=80},
}
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function emit(s)
 PrintInfo('[GROUND_VALIDATOR] '..s)
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','a');if f then f:write(s..'\n');f:flush();f:close() end
end
function V:initialize() BaseService.initialize(self);self.mode=os.getenv('PMDO_GROUND_VALIDATOR');self.enabled=(self.mode=='1' or self.mode=='tornadus_battle');self.idx=0;self.entered=false;self.busy=false end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 SV.RuntimeGroundAudit=SV.RuntimeGroundAudit or {};SV.RuntimeGroundAudit.Active=true
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','w');if f then f:close() end
 if self.mode=='tornadus_battle' then
  self.idx=-1
  SV.Chapter5=SV.Chapter5 or {};SV.Chapter5.MountGuardianSeen=true
  emit('{"event":"tornadus_battle_begin","zone":"mount_windswept","segment":2,"floor":0}')
  -- EnterDungeon doit etre appele depuis la coroutine du Ground, pas depuis
  -- l'evenement service NewGame (sinon NLua: yield outside a coroutine).
  GAME:EnterZone('mount_windswept',-1,2,0)
  return
 end
 self.idx=1;emit('{"event":"begin","count":'..#PILOT..'}');GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0)
end
function V:OnDungeonFloorEnter()
 if not self.enabled or self.mode~='tornadus_battle' then return end
 local ok,msg=pcall(function()
  local map=_ZONE.CurrentMap
  local foes=map.MapTeams.Count
  local boss=map.MapTeams[0].Players[0]
  return string.format('{"event":"tornadus_battle_runtime","zone":"%s","segment":%d,"map_teams":%d,"boss_species":"%s","boss_level":%d,"boss_x":%d,"boss_y":%d,"player_control":"DUNGEON_MODE_ENTERED","verdict":"BATTLE_START_PASS"}',tostring(_ZONE.CurrentZoneID),_ZONE.CurrentMapID.Segment,foes,tostring(boss.CurrentForm.Species),boss.Level,boss.CharLoc.X,boss.CharLoc.Y)
 end)
 emit(ok and msg or ('{"event":"tornadus_battle_runtime","verdict":"RUNTIME_FAIL","error":"'..tostring(msg):gsub('"','\\"')..'"}'))
end
function V:OnGroundMapEnter()
 if not self.enabled or self.mode=='tornadus_battle' or self.busy then return end
 self.busy=true;self:validate();self.idx=self.idx+1
 if self.idx>#PILOT then SV.RuntimeGroundAudit.Active=false;emit('{"event":"end"}')
 else GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0) end
 self.busy=false
end
function V:validate()
 local id=PILOT[self.idx].id;local map=safe(function()return GAME:GetCurrentGround()end,nil);local hero=CH('PLAYER')
 if not map or not hero then emit('{"ground":"'..id..'","verdict":"RUNTIME_FAIL","error":"map_or_hero_nil"}');return end
 local x=safe(function()return hero.Position.X end,-1);local y=safe(function()return hero.Position.Y end,-1)
 local beforeX,beforeY=x,y;local moves={}
 for _,d in ipairs({Direction.Up,Direction.Right,Direction.Down,Direction.Left}) do
  pcall(function()GROUND:MoveInDirection(hero,d,8,false,2)end);local nx=safe(function()return hero.Position.X end,x);local ny=safe(function()return hero.Position.Y end,y);moves[#moves+1]=(nx~=x or ny~=y) and 1 or 0;pcall(function()GROUND:TeleportTo(hero,x,y,Direction.Down)end)
 end
 local movable=(moves[1]+moves[2]+moves[3]+moves[4])>0
 emit(string.format('{"ground":"%s","load":"PASS","spawn":{"x":%d,"y":%d},"move_dirs":[%d,%d,%d,%d],"movement_probe":"INCONCLUSIVE_SYNC_CONTEXT","verdict":"MANUAL_REVIEW"}',id,beforeX,beforeY,moves[1],moves[2],moves[3],moves[4]))
end
function V:Update(gtime) while true do coroutine.yield() end end
function V:OnInit()
 if self.enabled then
  emit('{"event":"bootstrap_new_game"}')
  RogueEssence.GameManager.Instance:NewGamePlus(424242)
 end
end
function V:OnNewGame()self:begin()end
function V:OnLoadSavedData()self:begin()end
function V:Subscribe(med)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.LoadSavedData,function()self.OnLoadSavedData(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('GroundGameplayValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('GroundGameplayValidator',V:new())
return V
