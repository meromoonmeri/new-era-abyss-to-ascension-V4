-- Opt-in PMDO route validator for staged PMD Red story batches.
require 'origin.common'
require 'origin.services.baseservice'

local V=Class('RedStoryRouteValidator',BaseService)
local OUT=os.getenv('PMDO_RED_STORY_ROUTE_OUT') or '/tmp/red_story_route.jsonl'
local CONFIG={
  tiny_woods={floors=3,entrance='foret_tendre_oree',final='d01p02'},
  thunderwave_cave={floors=5,entrance='grotte_statique_seuil',final='d02p02'},
}
local function esc(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n',' | '):gsub('\r','')end
local function emit(v)
  PrintInfo('[RED_STORY_ROUTE] '..v)
  local f=io.open(OUT,'a');if f then f:write(v..'\n');f:flush();f:close() end
end
local function safe(fn,fallback)local ok,v=pcall(fn);if ok then return v end;return fallback end

function V:initialize()
  BaseService.initialize(self)
  self.zone=os.getenv('PMDO_RED_STORY_ROUTE_VALIDATOR') or ''
  self.config=CONFIG[self.zone]
  self.enabled=self.config~=nil
  self.started=false;self.final_done=false;self.returning=false;self.last_map=nil
end
function V:OnInit()
  if not self.enabled then return end
  local f=io.open(OUT,'w');if f then f:close() end
  RogueEssence.GameManager.Instance:NewGamePlus(20260823)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true
  SV.TakenBoard={};_DATA.Save.Rescue=nil
  while _DATA.Save.ActiveTeam.Players.Count>2 do
    _DATA.Save.ActiveTeam.Players:RemoveAt(_DATA.Save.ActiveTeam.Players.Count-1)
  end
  SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  SV.CanonicalDungeons[self.zone]=false
  emit('{"event":"begin","zone":"'..self.zone..'","expected_floors":'..self.config.floors..'}')
  GAME:EnterZone(self.zone,-1,0,0)
end
function V:inspect_map()
  local map=_ZONE.CurrentMap;local stairs=0;local stair_ids={}
  for x=0,map.Width-1 do for y=0,map.Height-1 do
    local id=tostring(map.Tiles[x][y].Effect.ID or '')
    if id=='stairs_go_down' or id=='stairs_go_up' then stairs=stairs+1;stair_ids[#stair_ids+1]=id end
  end end
  local teams=map.MapTeams.Count;local mobs=0
  for ii=0,teams-1 do mobs=mobs+map.MapTeams[ii].Players.Count end
  emit('{"event":"map","zone":"'..self.zone..'","segment":'.._ZONE.CurrentMapID.Segment
    ..',"floor":'.._ZONE.CurrentMapID.ID..',"width":'..map.Width..',"height":'..map.Height
    ..',"mobs":'..mobs..',"stairs":'..stairs..',"map_seed":"'..esc(map.Rand.FirstSeed)
    ..'","adventure_seed":"'..esc(_DATA.Save.Rand.FirstSeed)..'"}')
  if stairs<1 then error('procedural floor has no stairs') end
end
function V:OnDungeonMapInit()
  if not self.enabled or tostring(_ZONE.CurrentZoneID)~=self.zone then return end
  local key=tostring(_ZONE.CurrentMapID.Segment)..':'..tostring(_ZONE.CurrentMapID.ID)
  if self.last_map==key then return end
  self.last_map=key
  local ok,err=xpcall(function()self:inspect_map()end,debug.traceback)
  if not ok then emit('{"event":"fatal","phase":"map","error":"'..esc(err)..'"}') end
end
function V:OnDungeonFloorEnter()
  if not self.enabled or tostring(_ZONE.CurrentZoneID)~=self.zone then return end
  local floor=_ZONE.CurrentMapID.ID
  local ok,err=xpcall(function()
    if floor+1<self.config.floors then
      emit('{"event":"next_floor","from":'..floor..',"to":'..(floor+1)..'}')
      GAME:EnterZone(self.zone,0,floor+1,0)
    else
      emit('{"event":"segment_clear","floor":'..floor..'}')
      local manager=RogueEssence.GameManager.Instance
      local field=manager:GetType():GetField('SceneOutcome')
      manager:SetFade(true,false)
      field:SetValue(manager,_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared,true))
    end
  end,debug.traceback)
  if not ok then emit('{"event":"fatal","phase":"advance","error":"'..esc(err)..'"}') end
end
function V:OnGroundMapEnter()
  if not self.enabled then return end
  local id=safe(function()return GAME:GetCurrentGround().AssetName end,'')
  emit('{"event":"ground","zone":"'..esc(_ZONE.CurrentZoneID)..'","id":"'..esc(id)..'"}')
  if id==self.config.entrance and not self.returning then
    self.task=TASK:BranchCoroutine(function()
      local ok,err=xpcall(function()
        emit('{"event":"ground_transition","id":"'..id..'","target":"'..self.zone..'"}')
        TASK:WaitTask(GAME:_EnterDungeon(self.zone,0,0,0,
          RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false))
      end,debug.traceback)
      if not ok then emit('{"event":"fatal","phase":"entrance","error":"'..esc(err)..'"}') end
    end)
    return
  end
  if id==self.config.final and not self.final_done then
    self.final_done=true;self.returning=true
    local complete=(SV.CanonicalDungeons and SV.CanonicalDungeons[self.zone])==true
    emit('{"event":"canonical_end","id":"'..id..'","scene_complete":'..tostring(complete)..'}')
    local commit=GAME:_EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared,
      self.zone,-1,0,0,false,false)
    commit:MoveNext()
    GAME:EnterZone(self.zone,-1,0,0)
    return
  end
  if id==self.config.entrance and self.returning then
    emit('{"event":"end","zone":"'..self.zone..'","canonical_complete":true}')
    RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
  end
end
function V:Subscribe(med)
  med:Subscribe('RedStoryRouteValidator',EngineServiceEvents.Init,function()self:OnInit()end)
  med:Subscribe('RedStoryRouteValidator',EngineServiceEvents.NewGame,function()self:OnNewGame()end)
  med:Subscribe('RedStoryRouteValidator',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)
  med:Subscribe('RedStoryRouteValidator',EngineServiceEvents.DungeonFloorEnter,function()self:OnDungeonFloorEnter()end)
  med:Subscribe('RedStoryRouteValidator',EngineServiceEvents.GroundMapEnter,function()self:OnGroundMapEnter()end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('RedStoryRouteValidator',V:new())
return V
