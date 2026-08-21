-- Exact-PMDO isolated route probe for Mt Steel 9F. Disabled unless opted in.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('MtSteelRouteValidator',BaseService)
local GameBaseType=luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType=luanet.import_type('RogueEssence.GameBase+LoadPhase')
local GameManagerType=luanet.import_type('RogueEssence.GameManager')
local DungeonSceneType=luanet.import_type('RogueEssence.Dungeon.DungeonScene')
local CoroutineManagerType=luanet.import_type('RogueEssence.CoroutineManager')
local GameActionType=luanet.import_type('RogueEssence.Dungeon.GameAction')
local ActionType=luanet.import_type('RogueEssence.Dungeon.GameAction+ActionType')
local Dir8Type=luanet.import_type('RogueElements.Dir8')
local MenuManagerType=luanet.import_type('RogueEssence.Menu.MenuManager')
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n',' | ')end
local function emit(s)local f=io.open('/tmp/pmdred_mt_steel_route.jsonl','a');if f then f:write(s..'\n');f:flush();f:close() end;PrintInfo('[MT_STEEL_ROUTE] '..s)end
local function phase(v)local raw=tostring(v);return raw:match('^([%a_]+)') or raw,raw end
function V:initialize()
 BaseService.initialize(self);self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='mt_steel_route_fixture'
 self.seed=424242;self.mode=os.getenv('MT_STEEL_ROUTE_MODE') or 'clear';self.started=false;self.groundPending=false;self.task=nil;self.nativeAction=nil;self.attacks=0;self.giveupSubmitted=false;self.finishing=false;self.seenEnding=false;self.seenReturn=false
end
function V:finish(verdict)
 if self.finishing then return end;self.finishing=true
 emit(string.format('{"event":"scenario_verdict","verdict":"%s","attacks":%d,"ending":%s,"return":%s}',verdict,self.attacks,self.seenEnding and 'true' or 'false',self.seenReturn and 'true' or 'false'))
 local before,beforeRaw=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'))
 local assigned,assignedRaw=phase(safe(function()GameBaseType.CurrentPhase=LoadPhaseType.Unload;return GameBaseType.CurrentPhase end,'WRITE_FAILED'))
 emit(string.format('{"event":"load_phase_unload_requested","before":"%s","before_raw":"%s","requested":"Unload","readback":"%s","readback_raw":"%s"}',quote(before),quote(beforeRaw),quote(assigned),quote(assignedRaw)))
end
function V:OnInit()
 if not self.enabled then return end;local f=io.open('/tmp/pmdred_mt_steel_route.jsonl','w');if f then f:close() end
 emit('{"event":"bootstrap","seed":424242}');RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()if not self.enabled or self.started then return end;self.started=true;GAME:EnterZone('master_zone',-1,@@LAUNCHER_GROUND_INDEX@@,0)end
function V:OnGroundMapEnter()
 if not self.enabled or self.finishing then return end
 local id=tostring(GAME:GetCurrentGround().AssetName or '')
 emit('{"event":"ground_enter_signal","id":"'..quote(id)..'"}')
 if id=='d03p02' then
  self.seenEnding=true
  emit(string.format('{"event":"ending_ground","pending":"%s"}',quote(SV.CanonicalDungeons and SV.CanonicalDungeons.Pending or 'nil')))
 end
 self.groundPending=true
end
function V:handleGround()
 local map=GAME:GetCurrentGround();local id=tostring(map.AssetName or '')
 emit('{"event":"ground_entered","id":"'..quote(id)..'"}')
 if id=='d03p01' and not self.seenEnding then
  RogueElements.MathUtils.ReSeedRand(self.seed);GAME:EnterDungeon('mt_steel',0,8,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
 elseif id=='d03p02' then
  self.seenEnding=true
  emit(string.format('{"event":"ending_ground","pending":"%s"}',quote(SV.CanonicalDungeons and SV.CanonicalDungeons.Pending or 'nil')))
 elseif self.seenEnding then
  self.seenReturn=true
  local cleared=SV.CanonicalDungeons and SV.CanonicalDungeons.D03Cleared==true
  emit(string.format('{"event":"return_ground","id":"%s","cleared":%s,"pending":"%s"}',quote(id),cleared and 'true' or 'false',quote(SV.CanonicalDungeons and SV.CanonicalDungeons.Pending or 'nil')))
  self:finish(cleared and 'PASS' or 'FAIL')
 elseif self.mode=='failure' then
  local cleared=SV.CanonicalDungeons and SV.CanonicalDungeons.D03Cleared==true
  emit(string.format('{"event":"failure_return","id":"%s","cleared":%s,"ending_seen":%s}',quote(id),cleared and 'true' or 'false',self.seenEnding and 'true' or 'false'))
  self:finish((not cleared and not self.seenEnding) and 'PASS' or 'FAIL')
 else self:finish('FAIL') end
end
function V:OnDungeonFloorEnter()
 if not self.enabled then return end
 local map=_ZONE.CurrentMap;local foe=map.MapTeams.Count>0 and map.MapTeams[0].Players.Count>0 and map.MapTeams[0].Players[0] or nil
 -- Keep the test focused on the boss-clear route rather than the synthetic
 -- NewGamePlus party's level-one survivability. Damage and defeat still pass
 -- through native ProcessPlayerInput and combat events.
 for i=0,_DUNGEON.ActiveTeam.Players.Count-1 do local actor=_DUNGEON.ActiveTeam.Players[i];actor.Level=100;actor:FullRestore() end
 emit('{"event":"fixture_party_scale","level":100,"purpose":"native_boss_route"}')
 emit(string.format('{"event":"boss_floor","width":%d,"height":%d,"music":"%s","foe":"%s","foe_x":%d,"foe_y":%d}',map.Width,map.Height,quote(map.Music),quote(foe and foe.CurrentForm.Species or 'nil'),foe and foe.CharLoc.X or -1,foe and foe.CharLoc.Y or -1))
end
function V:OnUpdate()
 if not self.enabled or self.finishing then return end
 if MenuManagerType.Instance.MenuCount>0 then MenuManagerType.Instance:ClearMenus();return end
 if self.groundPending and self.task==nil then
  self.groundPending=false;self.task=TASK:BranchCoroutine(function()GAME:WaitFrames(2);local ok,err=xpcall(function()self:handleGround()end,debug.traceback);if not ok then emit('{"event":"scenario_fail","error":"'..quote(err)..'"}');self:finish('FAIL')end;self.task=nil end);return
 end
 if GameManagerType.Instance.CurrentScene~=DungeonSceneType.Instance then return end
 if self.nativeAction~=nil then
  if self.nativeAction:MoveNext() then return end
  self.nativeAction=nil
 end
 if not DungeonSceneType.Instance:IsPlayerLeaderTurn() or not DungeonSceneType.Instance:AnimationsOver() then return end
 local map=_ZONE.CurrentMap
 if self.mode=='failure' then
  if self.giveupSubmitted then return end
  self.giveupSubmitted=true
  local giveup=GameActionType(ActionType.GiveUp,Dir8Type.None,1)
  emit('{"event":"failure_action","type":"GiveUp","result":"Failed"}')
  self.nativeAction=CoroutineManagerType.Instance:StartCoroutine(DungeonSceneType.Instance:ProcessPlayerInput(giveup))
  return
 end
 local alive=false
 for ti=0,map.MapTeams.Count-1 do for pi=0,map.MapTeams[ti].Players.Count-1 do local mob=map.MapTeams[ti].Players[pi];if mob.BaseForm.Species=='skarmory' and not mob.Dead then alive=true end end end
 if not alive then
  if not self.defeatObserved then self.defeatObserved=true;emit('{"event":"skarmory_defeated","method":"native_basic_attacks"}') end
  return
 end
 if self.attacks>=64 then self:finish('FAIL');return end
 self.attacks=self.attacks+1
 local action=GameActionType(ActionType.Attack,Dir8Type.Up)
 emit(string.format('{"event":"player_attack","number":%d,"direction":"Up"}',self.attacks))
 self.nativeAction=CoroutineManagerType.Instance:StartCoroutine(DungeonSceneType.Instance:ProcessPlayerInput(action))
end
function V:OnDeinit()if self.enabled then local n,r=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'));emit('{"event":"native_deinit","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')end end
function V:OnGraphicsUnload()if self.enabled then local n,r=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'));emit('{"event":"native_graphics_unload","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}');emit('{"event":"end","terminal":true,"graceful":true,"load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')end end
function V:Subscribe(m)
 m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.Init,function()self.OnInit(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end);m:Subscribe('MtSteelRouteValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(m)end
MT_STEEL_ROUTE_VALIDATOR_INSTANCE=V:new();SCRIPT:AddService('MtSteelRouteValidator',MT_STEEL_ROUTE_VALIDATOR_INSTANCE);return V
