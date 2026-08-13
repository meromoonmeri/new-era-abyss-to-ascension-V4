-- Exact-runtime Tiny Woods route/action validator.  Disabled unless explicitly opted in.
require 'origin.common'
require 'origin.services.baseservice'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local V = Class('TinyWoodsRouteValidator', BaseService)
local GameBaseType = luanet.import_type('RogueEssence.GameBase')
local GameManagerType = luanet.import_type('RogueEssence.GameManager')
local LoadPhaseType = luanet.import_type('RogueEssence.GameBase+LoadPhase')
local DungeonSceneType = luanet.import_type('RogueEssence.Dungeon.DungeonScene')
local CoroutineManagerType = luanet.import_type('RogueEssence.CoroutineManager')
local CoroutineType = luanet.import_type('RogueEssence.Coroutine')
local GameActionType = luanet.import_type('RogueEssence.Dungeon.GameAction')
local ActionType = luanet.import_type('RogueEssence.Dungeon.GameAction+ActionType')
local Dir8Type = luanet.import_type('RogueElements.Dir8')
local MenuManagerType = luanet.import_type('RogueEssence.Menu.MenuManager')
local EVENT_PATH = '/tmp/tiny_woods_route.jsonl'

local function safe(f, d) local ok,v=pcall(f);if ok then return v end;return d end
local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\r','\\r'):gsub('\n',' | '):gsub('\t','\\t')end
local function emit(s)
  PrintInfo('[TINY_WOODS_ROUTE] '..s)
  local f=io.open(EVENT_PATH,'a');if f then f:write(s..'\n');f:flush();f:close() end
end
local function phase(v)local raw=tostring(v);local name=raw:match('^([%a_]+)');return name or raw,raw end
local function fail(message) error('TINY_WOODS_ROUTE_FAIL: '..tostring(message), 2) end
local function expect(value, message) if not value then fail(message) end end
local function key(x,y,w)return y*w+x end
local CARDINALS = {
  {dx=1,dy=0,dir=Dir8Type.Right,name='Right'},
  {dx=-1,dy=0,dir=Dir8Type.Left,name='Left'},
  {dx=0,dy=1,dir=Dir8Type.Down,name='Down'},
  {dx=0,dy=-1,dir=Dir8Type.Up,name='Up'},
}

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='tiny_woods_route_fixture'
  self.mode=os.getenv('TINY_WOODS_ROUTE_MODE') or 'opening_entry'
  self.seed=tonumber(os.getenv('TINY_WOODS_ROUTE_SEED') or '424242') or 424242
  self.started=false;self.finishing=false;self.task=nil;self.pending=nil
  self.actionRequest=nil;self.floorDrive=nil;self.nativeAction=nil;self.updateBusy=false
  self.defeatModalPending=false
  self.groundVisits={};self.floorVisits=0;self.actions=0;self.replans=0
  self.occupancyReplans=0;self.hostileBlocks=0;self.allyBlocks=0
end

function V:finish(verdict)
  if self.finishing then return end
  self.finishing=true
  local s=Route.GetState()
  emit(string.format('{"event":"scenario_verdict","mode":"%s","verdict":"%s","attempts":%d,"defeats":%d,"floors_entered":%d,"floors_cleared":%d,"rescue_complete":%s,"actions":%d,"replans":%d,"occupancy_replans":%d,"hostile_blocks":%d,"ally_blocks":%d}',quote(self.mode),quote(verdict),s.Attempts or 0,s.Defeats or 0,#(s.FloorsEntered or {}),#(s.FloorsCleared or {}),s.RescueComplete and 'true' or 'false',self.actions,self.replans,self.occupancyReplans,self.hostileBlocks,self.allyBlocks))
  local before_value=safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED')
  local before,before_raw=phase(before_value)
  local assigned_value=safe(function()GameBaseType.CurrentPhase=LoadPhaseType.Unload;return GameBaseType.CurrentPhase end,'WRITE_FAILED')
  local assigned,assigned_raw=phase(assigned_value)
  emit('{"event":"load_phase_unload_requested","before":"'..quote(before)..'","before_raw":"'..quote(before_raw)..'","requested":"Unload","readback":"'..quote(assigned)..'","readback_raw":"'..quote(assigned_raw)..'"}')
end

function V:request_action(action, kind, direction, floor)
  expect(self.actionRequest==nil,'validator action request is occupied')
  self.actionRequest={action=action,kind=kind,direction=direction,floor=floor}
end

function V:submit(request)
  self.actions=self.actions+1
  emit(string.format('{"event":"player_action","number":%d,"kind":"%s","direction":"%s","floor":%d,"native_type":"%s","native_direction":"%s","native_argument0":"%s"}',self.actions,quote(request.kind),quote(request.direction or 'None'),request.floor or -1,quote(request.action.Type),quote(request.action.Dir),quote(safe(function()return request.action[0]end,'READ_FAILED'))))
  -- Schedule ProcessPlayerInput as an engine-managed branch.  It enters the
  -- same coroutine pipeline as a real input without nesting a scene transition
  -- inside the validator's Lua branch.
  expect(self.nativeAction==nil,'native player-action coroutine is occupied')
  emit(string.format('{"event":"native_action_queue","number":%d,"current_scene":"%s","dungeon_scene":%s,"player_turn":%s,"leader_turn":%s,"animations_over":%s,"current_character":"%s","scene_outcome":"%s"}',self.actions,quote(GameManagerType.Instance.CurrentScene),GameManagerType.Instance.CurrentScene==DungeonSceneType.Instance and 'true' or 'false',tostring(safe(function()return DungeonSceneType.Instance:IsPlayerTurn()end,false)),tostring(safe(function()return DungeonSceneType.Instance:IsPlayerLeaderTurn()end,false)),tostring(safe(function()return DungeonSceneType.Instance:AnimationsOver()end,false)),quote(safe(function()return DungeonSceneType.Instance.CurrentCharacter end,'READ_FAILED')),quote(GameManagerType.Instance.SceneOutcome)))
  self.nativeAction=CoroutineManagerType.Instance:StartCoroutine(DungeonSceneType.Instance:ProcessPlayerInput(request.action))
  if request.kind=='GiveUp' then self.defeatModalPending=true end
end

function V:find_stair(map)
  for y=0,map.Height-1 do
    for x=0,map.Width-1 do
      if tostring(map:GetTile(RogueElements.Loc(x,y)).Effect.ID or '')=='stairs_go_up' then
        return RogueElements.Loc(x,y)
      end
    end
  end
  return nil
end

function V:first_step(map, start, goal, traveler, avoidOccupants)
  local w=map.Width;local h=map.Height
  local qx={start.X};local qy={start.Y};local head=1
  local seen={[key(start.X,start.Y,w)]=true};local first={}
  while head<=#qx do
    local x=qx[head];local y=qy[head];head=head+1
    for _,step in ipairs(CARDINALS) do
      local nx=x+step.dx;local ny=y+step.dy;local k=key(nx,ny,w)
      local loc=RogueElements.Loc(nx,ny)
      local occupied=false
      if nx>=0 and nx<w and ny>=0 and ny<h and avoidOccupants then
        occupied=map:GetCharAtLoc(loc,traveler)~=nil
      end
      if nx>=0 and nx<w and ny>=0 and ny<h and not seen[k]
          and not map:TileBlocked(loc) and not occupied then
        seen[k]=true
        first[k]=first[key(x,y,w)] or step
        if nx==goal.X and ny==goal.Y then return first[k] end
        qx[#qx+1]=nx;qy[#qy+1]=ny
      end
    end
  end
  return nil
end

function V:start_floor_drive(floor)
  local map=_ZONE.CurrentMap
  local target=self:find_stair(map)
  expect(target~=nil,'generated floor has no stairs_go_up')
  self.floorDrive={floor=floor,map=map,mapID=_ZONE.CurrentMapID.ID,target=target,iterations=0,stairSubmitted=false}
  emit(string.format('{"event":"action_path_started","floor":%d,"start_x":%d,"start_y":%d,"stair_x":%d,"stair_y":%d}',floor,_DUNGEON.ActiveTeam.Leader.CharLoc.X,_DUNGEON.ActiveTeam.Leader.CharLoc.Y,target.X,target.Y))
end

function V:drive_floor_step()
  local drive=self.floorDrive
  if drive==nil then return end
  if _ZONE.CurrentMap~=drive.map or _ZONE.CurrentMapID.ID~=drive.mapID then self.floorDrive=nil;return end
  if drive.stairSubmitted then return end
  drive.iterations=drive.iterations+1
  expect(drive.iterations<=2000,'player action bound exceeded before stair transition')
  local map=_ZONE.CurrentMap;local leader=_DUNGEON.ActiveTeam.Leader
  if leader.CharLoc.X==drive.target.X and leader.CharLoc.Y==drive.target.Y then
    -- AskLeaderEvent now hands control to the canonical TileUnderfootMenu.
    -- OnUpdate selects that menu's trigger action through MenuManager.EndAction.
    drive.awaitingStairMenu=true
    return
  end
  local step=self:first_step(map,leader.CharLoc,drive.target,leader,true)
  local occupancyFallback=false
  if step==nil then
    -- A one-tile passage is occupied.  Recompute the same terrain route only
    -- to reach/swap an allied body block or genuinely attack a blocking foe.
    occupancyFallback=true
    step=self:first_step(map,leader.CharLoc,drive.target,leader,false)
  end
  expect(step~=nil,'no terrain route from leader to stair')
  self.replans=self.replans+1
  local nextLoc=RogueElements.Loc(leader.CharLoc.X+step.dx,leader.CharLoc.Y+step.dy)
  local occupant=map:GetCharAtLoc(nextLoc,leader)
  local action=nil;local kind='Move';local relation='none';local species=''
  if occupant~=nil then
    species=safe(function()return occupant.CurrentForm.Species end,'unknown')
    if occupant.MemberTeam==leader.MemberTeam then
      -- PMDO's native ProcessWalk swaps allied characters in a one-tile
      -- passage; this is the normal player escape from a party-body block.
      relation='ally';self.allyBlocks=self.allyBlocks+1
      kind='Move';action=GameActionType(ActionType.Move,step.dir,1)
    else
      relation='hostile';self.hostileBlocks=self.hostileBlocks+1
      kind='Attack';action=GameActionType(ActionType.Attack,step.dir)
    end
  else
    -- Argument 1 is PMDO's normal single-tile walk command (0 is held-run).
    action=GameActionType(ActionType.Move,step.dir,1)
  end
  if occupancyFallback then
    self.occupancyReplans=self.occupancyReplans+1
    emit(string.format('{"event":"occupancy_replan","floor":%d,"number":%d,"next_x":%d,"next_y":%d,"next_occupied":%s,"relation":"%s","species":"%s","selected_action":"%s"}',drive.floor,self.occupancyReplans,nextLoc.X,nextLoc.Y,occupant~=nil and 'true' or 'false',quote(relation),quote(species),quote(kind)))
  end
  self:request_action(action,kind,step.name,drive.floor)
end

function V:validate_launcher(group)
  local hero=GAME:GetCurrentGround():GetChar('PLAYER')
  expect(hero~=nil,'d01p01 PLAYER is missing')
  expect(hero.Position.X==200 and hero.Position.Y==196,'d01p01 hero placement differs')
  expect(hero.Direction==Direction.Down,'d01p01 hero direction differs: actual='..tostring(hero.Direction)..' expected='..tostring(Direction.Down))
  emit(string.format('{"event":"ground_route","ground":"d01p01","group":"%s","visit":%d,"hero_x":%d,"hero_y":%d,"direction":"%s"}',quote(group),self.groundVisits.d01p01,hero.Position.X,hero.Position.Y,quote(hero.Direction)))
end

function V:validate_ending(group, cleanup)
  local map=GAME:GetCurrentGround();local hero=map:GetChar('PLAYER')
  expect(map.Width==45 and map.Height==42,'d01p02 dimensions differ from EU Ground')
  local solid=0
  for x=0,map.Width-1 do for y=0,map.Height-1 do if map:GetObstacle(x,y)~=0 then solid=solid+1 end end end
  expect(solid==1503,'d01p02 collision-cell count differs')
  expect(hero~=nil and hero.Position.X==164 and hero.Position.Y==276,'d01p02 hero placement differs')
  expect(hero.Direction==Direction.Down,'d01p02 hero direction differs: actual='..tostring(hero.Direction)..' expected='..tostring(Direction.Down))
  local partner=map:GetTempChar('PARTNER');local caterpie=map:GetTempChar('CATERPIE')
  if cleanup then
    expect(partner==nil and caterpie==nil,'temporary ending actors leaked after relay cleanup')
    expect(SOUND:GetCurrentSong()=='','ending music leaked after relay cleanup')
  else
    expect(group=='g1','first d01p02 visit did not dispatch g1')
    expect(partner~=nil and partner.Position.X==196 and partner.Position.Y==276,'partner placement differs')
    expect(caterpie~=nil and caterpie.Position.X==180 and caterpie.Position.Y==148,'Caterpie placement differs')
    expect(caterpie.Data.BaseForm.Species=='caterpie','Caterpie identity differs')
    expect(partner.Direction==Direction.Down and caterpie.Direction==Direction.Down,'ending actor direction differs: partner='..tostring(partner.Direction)..' caterpie='..tostring(caterpie.Direction)..' expected='..tostring(Direction.Down))
    expect(SOUND:GetCurrentSong()=='In the Depths of the Pit.ogg','ending BGM differs')
  end
  emit(string.format('{"event":"ending_ground_probe","visit":%d,"group":"%s","cleanup":%s,"width":%d,"height":%d,"solid_cells":%d,"hero_x":%d,"hero_y":%d,"partner":%s,"caterpie":%s,"music":"%s","verdict":"PASS"}',self.groundVisits.d01p02,quote(group),cleanup and 'true' or 'false',map.Width,map.Height,solid,hero.Position.X,hero.Position.Y,partner~=nil and 'true' or 'false',caterpie~=nil and 'true' or 'false',quote(SOUND:GetCurrentSong())))
end

function V:enter_dungeon()
  local attempt=Route.BeginAttempt()
  RogueElements.MathUtils.ReSeedRand(self.seed)
  emit(string.format('{"event":"attempt_started","attempt":%d,"seed":%d}',attempt,self.seed))
  GAME:EnterDungeon('tiny_woods',0,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
end

function V:handle_ground(id)
  local s=Route.GetState();local group=s.LastGroup or ''
  self.groundVisits[id]=(self.groundVisits[id] or 0)+1
  if id=='d01p01' then
    self:validate_launcher(group)
    if self.groundVisits[id]==1 then
      expect(group=='g1','opening did not dispatch d01p01:g1')
      self:enter_dungeon()
    elseif self.mode=='defeat_retry' and self.groundVisits[id]==2 then
      expect(group=='g2','failed attempt did not dispatch d01p01:g2')
      expect(s.Attempts==1 and s.Defeats==1 and s.Status=='failed','failed route state differs')
      self:enter_dungeon()
    elseif self.mode=='clear_rescue_cleanup' and self.groundVisits[id]==2 then
      expect(group=='g3' and s.RescueComplete,'rescue did not dispatch d01p01:g3')
      emit('{"event":"post_rescue_relay","ground":"d01p01","group":"g3"}')
      GAME:EnterGroundMap('d01p02','Main_Entrance_Marker')
    else
      fail('unexpected d01p01 visit')
    end
  elseif id=='d01p02' then
    if self.mode~='clear_rescue_cleanup' then fail('unexpected ending Ground for scenario') end
    if self.groundVisits[id]==1 then
      self:validate_ending(group,false)
      expect(s.Status=='cleared' and #s.FloorsCleared==3,'clear state/floor chronology differs')
      Route.CompleteRescue()
      emit('{"event":"rescue_completed","destination":"d01p01:g3"}')
      GAME:EnterGroundMap('d01p01','Main_Entrance_Marker')
    elseif self.groundVisits[id]==2 then
      expect(group=='','post-rescue d01p02 unexpectedly replayed g1')
      self:validate_ending(group,true)
      self:finish('PASS')
    else
      fail('unexpected d01p02 visit')
    end
  else
    fail('unexpected Ground '..tostring(id))
  end
end

function V:handle_floor(floor)
  self.floorVisits=self.floorVisits+1
  Route.RecordFloorEntered(floor)
  local s=Route.GetState()
  emit(string.format('{"event":"dungeon_floor_entered","floor":%d,"visit":%d,"attempt":%d,"mode":"%s"}',floor,self.floorVisits,s.Attempts,quote(self.mode)))
  if self.mode=='opening_entry' then
    expect(s.Attempts==1 and floor==0,'opening did not enter Tiny Woods 1F')
    self:finish('PASS')
  elseif self.mode=='defeat_retry' then
    if s.Attempts==1 then
      expect(floor==0,'defeat scenario did not begin on 1F')
      local action=GameActionType(ActionType.GiveUp,Dir8Type.None,1)
      emit('{"event":"failed_result_action","result":"Failed","argument":1}')
      self:request_action(action,'GiveUp','None',floor)
    elseif s.Attempts==2 then
      expect(floor==0 and s.Defeats==1,'retry did not return to Tiny Woods 1F')
      self:finish('PASS')
    else
      fail('unexpected defeat/retry attempt')
    end
  elseif self.mode=='clear_rescue_cleanup' then
    expect(floor>=0 and floor<=2,'clear traversal entered non-canonical floor')
    self:start_floor_drive(floor)
  else
    fail('unknown route scenario '..tostring(self.mode))
  end
end

function V:queue(kind, value)
  self.pending={kind=kind,value=value}
  if self.task~=nil then return end
  local function launch()
    local job=self.pending;if job==nil or self.finishing then return end
    self.pending=nil
    self.task=TASK:BranchCoroutine(function()
      GAME:WaitFrames(2)
      local ok,err=xpcall(function()
        if job.kind=='ground' then self:handle_ground(job.value) else self:handle_floor(job.value) end
      end,debug.traceback)
      if not ok then emit('{"event":"scenario_fail","error":"'..quote(err)..'"}');self:finish('FAIL') end
      self.task=nil
      if self.pending~=nil and not self.finishing then launch() end
    end)
  end
  launch()
end

function V:OnUpdate()
  if not self.enabled or self.finishing or self.updateBusy then return end
  -- Failed EndSegment first opens PMDO's modal message log.  A player closes
  -- this with Menu/Cancel; the headless harness invokes the menu's native
  -- close endpoint after proving that the modal was actually reached.
  if self.defeatModalPending and MenuManagerType.Instance.MenuCount>0 then
    emit(string.format('{"event":"defeat_message_log","menu_count":%d,"action":"native_close"}',MenuManagerType.Instance.MenuCount))
    MenuManagerType.Instance:ClearMenus()
    self.defeatModalPending=false
    return
  end
  -- Landing on PMDO stairs natively schedules AskLeaderEvent's
  -- TileUnderfootMenu.  Select its trigger exactly as TileUnderfootMenu does:
  -- install ProcessPlayerInput(Tile, None, 0) as MenuManager.EndAction, then
  -- close the menu so the engine executes that action in its own menu branch.
  local drive=self.floorDrive
  if drive~=nil and drive.awaitingStairMenu and MenuManagerType.Instance.MenuCount>0 then
    local action=GameActionType(ActionType.Tile,Dir8Type.None,0)
    self.actions=self.actions+1
    emit(string.format('{"event":"stair_prompt_menu","floor":%d,"menu_count":%d,"selection":"trigger"}',drive.floor,MenuManagerType.Instance.MenuCount))
    emit(string.format('{"event":"player_action","number":%d,"kind":"Tile","direction":"None","floor":%d,"native_type":"%s","native_direction":"%s","native_argument0":"%s"}',self.actions,drive.floor,quote(action.Type),quote(action.Dir),quote(safe(function()return action[0]end,'READ_FAILED'))))
    emit(string.format('{"event":"native_action_queue","number":%d,"scheduler":"MenuManager.EndAction","current_scene":"%s","dungeon_scene":%s,"player_turn":%s,"leader_turn":%s,"animations_over":%s,"current_character":"%s","scene_outcome":"%s"}',self.actions,quote(GameManagerType.Instance.CurrentScene),GameManagerType.Instance.CurrentScene==DungeonSceneType.Instance and 'true' or 'false',tostring(safe(function()return DungeonSceneType.Instance:IsPlayerTurn()end,false)),tostring(safe(function()return DungeonSceneType.Instance:IsPlayerLeaderTurn()end,false)),tostring(safe(function()return DungeonSceneType.Instance:AnimationsOver()end,false)),quote(safe(function()return DungeonSceneType.Instance.CurrentCharacter end,'READ_FAILED')),quote(GameManagerType.Instance.SceneOutcome)))
    drive.stairSubmitted=true;drive.awaitingStairMenu=false
    Route.RecordFloorCleared(drive.floor)
    emit(string.format('{"event":"stair_action_submitted","floor":%d,"x":%d,"y":%d}',drive.floor,drive.target.X,drive.target.Y))
    MenuManagerType.Instance.EndAction=DungeonSceneType.Instance:ProcessPlayerInput(action)
    MenuManagerType.Instance:ClearMenus()
    return
  end
  if GameManagerType.Instance.CurrentScene~=DungeonSceneType.Instance then return end
  if GameManagerType.Instance.SceneOutcome~=nil then return end
  if self.nativeAction~=nil then
    if not self.nativeAction:FinishedYield() then return end
    emit(string.format('{"event":"native_action_consumed","number":%d,"scene_outcome":"%s"}',self.actions,quote(GameManagerType.Instance.SceneOutcome)))
    self.nativeAction=nil
  end
  if self.actionRequest==nil and self.floorDrive==nil then return end
  -- ProcessPlayerInput is only valid at the same leader-turn boundary used by
  -- DungeonScene's real input loop.  Detached scheduling must never inject a
  -- second player action while AI turns or action animations are in progress.
  if not DungeonSceneType.Instance:IsPlayerLeaderTurn()
      or not DungeonSceneType.Instance:AnimationsOver() then return end
  self.updateBusy=true
  local ok,err=xpcall(function()
    if self.actionRequest==nil then self:drive_floor_step() end
    if self.actionRequest~=nil then
      local request=self.actionRequest;self.actionRequest=nil;self:submit(request)
    end
  end,debug.traceback)
  self.updateBusy=false
  if not ok then
    emit('{"event":"scenario_fail","error":"'..quote(err)..'"}')
    self:finish('FAIL')
  end
end

function V:OnInit()
  if not self.enabled then return end
  local f=io.open(EVENT_PATH,'w');if f then f:close() end
  expect(self.mode=='opening_entry' or self.mode=='defeat_retry' or self.mode=='clear_rescue_cleanup','unsupported route mode')
  emit(string.format('{"event":"bootstrap_new_game","mode":"%s","seed":%d}',quote(self.mode),self.seed))
  RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true;Route.Reset()
  GAME:EnterZone('master_zone',-1,@@LAUNCHER_GROUND_INDEX@@,0)
end
function V:OnGroundMapEnter()
  if not self.enabled or self.finishing then return end
  self:queue('ground',GAME:GetCurrentGround().AssetName)
end
function V:OnDungeonFloorEnter()
  if not self.enabled or self.finishing then return end
  self:queue('floor',_ZONE.CurrentMapID.ID)
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
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
  med:Subscribe('TinyWoodsRouteValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med) end
TINY_WOODS_ROUTE_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=TINY_WOODS_ROUTE_VALIDATOR_INSTANCE
SCRIPT:AddService('TinyWoodsRouteValidator',TINY_WOODS_ROUTE_VALIDATOR_INSTANCE)
return V
