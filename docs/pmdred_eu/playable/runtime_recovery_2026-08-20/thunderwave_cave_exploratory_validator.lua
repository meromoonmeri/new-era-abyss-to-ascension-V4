-- Ignored native Tiny Woods procedural-runtime probe. Disabled outside its exact opt-in mode.
require 'origin.common'
require 'origin.services.baseservice'
local V=Class('TinyWoodsNativeValidator',BaseService)
local GameBaseType=luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType=luanet.import_type('RogueEssence.GameBase+LoadPhase')
local function safe(f,d)local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n',' | ')end
local function emit(s)
 PrintInfo('[TINY_WOODS_NATIVE] '..s)
 local f=io.open('/tmp/tiny_woods_native.jsonl','a');if f then f:write(s..'\n');f:flush();f:close() end
end
local function phase(v)local raw=tostring(v);local name=raw:match('^([%a_]+)');return name or raw,raw end
local function key(x,y,w)return y*w+x end
function V:initialize()
 BaseService.initialize(self)
 self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='early_dungeon_native_fixture'
 self.floor=tonumber(os.getenv('EARLY_DUNGEON_FLOOR') or '0') or 0
 self.seed=tonumber(os.getenv('EARLY_DUNGEON_SEED') or '424242') or 424242
 self.ground_pending=false;self.started=false;self.finishing=false;self.task=nil
end
function V:finish()
 if self.finishing then return end
 self.finishing=true
 local before_value=safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED')
 local before,before_raw=phase(before_value)
 local assigned_value=safe(function()GameBaseType.CurrentPhase=LoadPhaseType.Unload;return GameBaseType.CurrentPhase end,'WRITE_FAILED')
 local assigned,assigned_raw=phase(assigned_value)
 emit('{"event":"load_phase_unload_requested","before":"'..quote(before)..'","before_raw":"'..quote(before_raw)..'","requested":"Unload","readback":"'..quote(assigned)..'","readback_raw":"'..quote(assigned_raw)..'"}')
end
function V:probe()
 local map=_ZONE.CurrentMap
 local adventure_seed=tostring(_DATA.Save.Rand.FirstSeed)
 local map_seed=tostring(map.Rand.FirstSeed)
 local w=map.Width;local h=map.Height
 local leader=_DUNGEON.ActiveTeam.Leader
 local sx=leader.CharLoc.X;local sy=leader.CharLoc.Y
 local terrain={};local effects={};local walkable=0
 local stairs={};local traps={}
 for y=0,h-1 do
  for x=0,w-1 do
   local loc=RogueElements.Loc(x,y)
   local tile=map:GetTile(loc)
   local tid=tostring(tile.ID or '')
   terrain[tid]=(terrain[tid] or 0)+1
   if not map:TileBlocked(loc) then walkable=walkable+1 end
   local eid=tostring(tile.Effect.ID or '')
   if eid~='' then
    effects[eid]=(effects[eid] or 0)+1
    local rec={x=x,y=y,id=eid}
    if eid=='stairs_go_up' then stairs[#stairs+1]=rec else traps[#traps+1]=rec end
   end
  end
 end
 local qx={sx};local qy={sy};local head=1
 local dist={};dist[key(sx,sy,w)]=0;local reachable=0
 while head<=#qx do
  local x=qx[head];local y=qy[head];head=head+1;reachable=reachable+1
  local d=dist[key(x,y,w)]
  local nx={x+1,x-1,x,x};local ny={y,y,y+1,y-1}
  for i=1,4 do
   local xx=nx[i];local yy=ny[i]
   if xx>=0 and xx<w and yy>=0 and yy<h then
    local k=key(xx,yy,w)
    if dist[k]==nil and not map:TileBlocked(RogueElements.Loc(xx,yy)) then
     dist[k]=d+1;qx[#qx+1]=xx;qy[#qy+1]=yy
    end
   end
  end
 end
 local stair_parts={};local all_stairs=true;local shortest=-1
 for _,s in ipairs(stairs) do
  local d=dist[key(s.x,s.y,w)]
  if d==nil then all_stairs=false else if shortest<0 or d<shortest then shortest=d end end
  stair_parts[#stair_parts+1]=string.format('{"id":"%s","x":%d,"y":%d,"reachable":%s,"distance":%d}',quote(s.id),s.x,s.y,d~=nil and 'true' or 'false',d or -1)
 end
 local entry_parts={}
 for i=0,map.EntryPoints.Count-1 do
  local p=map.EntryPoints[i]
  entry_parts[#entry_parts+1]=string.format('{"x":%d,"y":%d}',p.Loc.X,p.Loc.Y)
 end
 local item_parts={};local reachable_items=true
 for i=0,map.Items.Count-1 do
  local item=map.Items[i];local d=dist[key(item.TileLoc.X,item.TileLoc.Y,w)]
  if d==nil then reachable_items=false end
  item_parts[#item_parts+1]=string.format('{"id":"%s","money":%s,"amount":%d,"x":%d,"y":%d,"reachable":%s}',quote(item.Value),item.IsMoney and 'true' or 'false',item.Amount,item.TileLoc.X,item.TileLoc.Y,d~=nil and 'true' or 'false')
 end
 local mob_parts={};local mob_count=0;local reachable_mobs=true
 for ti=0,map.MapTeams.Count-1 do
  local team=map.MapTeams[ti]
  for pi=0,team.Players.Count-1 do
   local mob=team.Players[pi];mob_count=mob_count+1
   local d=dist[key(mob.CharLoc.X,mob.CharLoc.Y,w)]
   if d==nil then reachable_mobs=false end
   mob_parts[#mob_parts+1]=string.format('{"species":"%s","level":%d,"x":%d,"y":%d,"reachable":%s}',quote(mob.CurrentForm.Species),mob.Level,mob.CharLoc.X,mob.CharLoc.Y,d~=nil and 'true' or 'false')
  end
 end
 local terrain_parts={};for id,n in pairs(terrain) do terrain_parts[#terrain_parts+1]=string.format('"%s":%d',quote(id),n) end;table.sort(terrain_parts)
 local effect_parts={};for id,n in pairs(effects) do effect_parts[#effect_parts+1]=string.format('"%s":%d',quote(id),n) end;table.sort(effect_parts)
 local verdict=(reachable==walkable and #stairs==1 and all_stairs and reachable_items and reachable_mobs and mob_count>0) and 'PASS' or 'FAIL'
 emit(string.format('{"event":"floor_probe","bootstrap_seed":%d,"adventure_seed":%s,"map_seed":%s,"requested_floor":%d,"zone":"%s","segment":%d,"map":%d,"width":%d,"height":%d,"music":"%s","start":{"x":%d,"y":%d},"entries":[%s],"terrain":{%s},"effects":{%s},"walkable":%d,"reachable":%d,"all_walkable_reachable":%s,"stairs":[%s],"shortest_stair_route":%d,"items":[%s],"mobs":[%s],"mob_count":%d,"traps":%d,"verdict":"%s"}',self.seed,adventure_seed,map_seed,self.floor,tostring(_ZONE.CurrentZoneID),_ZONE.CurrentMapID.Segment,_ZONE.CurrentMapID.ID,w,h,quote(map.Music),sx,sy,table.concat(entry_parts,','),table.concat(terrain_parts,','),table.concat(effect_parts,','),walkable,reachable,reachable==walkable and 'true' or 'false',table.concat(stair_parts,','),shortest,table.concat(item_parts,','),table.concat(mob_parts,','),mob_count,#traps,verdict))
end
function V:OnInit()
 if not self.enabled then return end
 local f=io.open('/tmp/tiny_woods_native.jsonl','w');if f then f:close() end
 emit(string.format('{"event":"bootstrap_new_game","seed":%d,"requested_floor":%d}',self.seed,self.floor))
 RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
 if not self.enabled or self.started then return end
 self.started=true
 GAME:EnterZone('master_zone',-1,309,0)
end
function V:OnGroundMapEnter()
 if not self.enabled or self.finishing then return end
 self.ground_pending=true
 emit('{"event":"launcher_ground_entered","scheduler":"MAP_UPDATE_BRANCH"}')
end
function V:OnMapUpdate()
 if not self.enabled or not self.ground_pending or self.task~=nil then return end
 self.ground_pending=false
 emit('{"event":"launcher_map_update"}')
 self.task=TASK:BranchCoroutine(function()
  emit('{"event":"launcher_coroutine_started"}')
  local ok,err=xpcall(function()
   RogueElements.MathUtils.ReSeedRand(self.seed)
   GAME:EnterDungeon('thunderwave_cave',0,self.floor,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
  end,debug.traceback)
  if not ok then emit('{"event":"launcher_fail","error":"'..quote(err)..'"}');self:finish() end
  self.task=nil
 end)
end
function V:OnDungeonFloorEnter()
 if not self.enabled then return end
 local ok,err=xpcall(function()self:probe()end,debug.traceback)
 if not ok then emit('{"event":"floor_probe_fail","error":"'..quote(err)..'"}') end
 self:finish()
end
function V:OnDeinit()
 if not self.enabled then return end
 local n,r=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'))
 emit('{"event":"native_deinit","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:OnGraphicsUnload()
 if not self.enabled then return end
 local n,r=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'))
 emit('{"event":"native_graphics_unload","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
 emit('{"event":"end","terminal":true,"graceful":true,"load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:Subscribe(med)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
 med:Subscribe('TinyWoodsNativeValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med)end
TINY_WOODS_NATIVE_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=TINY_WOODS_NATIVE_VALIDATOR_INSTANCE
SCRIPT:AddService('TinyWoodsNativeValidator',TINY_WOODS_NATIVE_VALIDATOR_INSTANCE)
return V
