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
function V:initialize() BaseService.initialize(self);self.enabled=(os.getenv('PMDO_GROUND_VALIDATOR')=='1');self.idx=0;self.entered=false;self.busy=false end
function V:begin()
 if not self.enabled or self.idx>0 then return end
 SV.RuntimeGroundAudit=SV.RuntimeGroundAudit or {};SV.RuntimeGroundAudit.Active=true
 local f=io.open('/tmp/ground_gameplay_validator.jsonl','w');if f then f:close() end
 self.idx=1;emit('{"event":"begin","count":'..#PILOT..'}');GAME:EnterZone(PILOT[self.idx].zone,-1,PILOT[self.idx].idx,0)
end
function V:OnGroundMapEnter()
 if not self.enabled or self.busy then return end
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
end
function V:UnSubscribe(med)end
SCRIPT:AddService('GroundGameplayValidator',V:new())
return V
