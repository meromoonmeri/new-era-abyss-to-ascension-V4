-- Exact-PMDO validator for authenticated French Tiny Woods scene execution.
require 'origin.common'
require 'origin.services.baseservice'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local V = Class('TinyWoodsSceneValidator', BaseService)
local GameBaseType = luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType = luanet.import_type('RogueEssence.GameBase+LoadPhase')
local MenuManagerType = luanet.import_type('RogueEssence.Menu.MenuManager')
local EVENT_PATH = '/tmp/tiny_woods_scenes.jsonl'

local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\r','\\r'):gsub('\n','\\n'):gsub('\t','\\t')end
local function emit(s)
  PrintInfo('[TINY_WOODS_SCENES] '..s)
  local f=io.open(EVENT_PATH,'a');if f then f:write(s..'\n');f:flush();f:close() end
end
local function phase(v)local raw=tostring(v);return raw:match('^([%a_]+)') or raw,raw end

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='tiny_woods_scene_fixture'
  self.mode=os.getenv('TINY_WOODS_SCENE_MODE') or 'opening_scene'
  self.seed=tonumber(os.getenv('TINY_WOODS_SCENE_SEED') or '424242') or 424242
  self.started=false;self.finishing=false;self.dialogues=0;self.menus=0
  self.sceneStarts={};self.sceneCompletes={};self.choreography=0;self.pendingFinish=false
end

PMDRED_TINY_WOODS_SCENE_TRACE=function(kind,scene,sequence,pointer,speaker,text,detail)
  local instance=TINY_WOODS_SCENE_VALIDATOR_INSTANCE
  if instance==nil or not instance.enabled then return end
  if kind=='dialogue' then instance.dialogues=instance.dialogues+1 end
  if kind=='scene_start' then instance.sceneStarts[scene]=(instance.sceneStarts[scene] or 0)+1 end
  if kind=='scene_complete' then
    instance.sceneCompletes[scene]=(instance.sceneCompletes[scene] or 0)+1
    if instance.mode=='ending_rescue_scene' and scene=='d01p01_g3' then instance.pendingFinish=true end
  end
  if kind=='choreography' then instance.choreography=instance.choreography+1 end
  emit(string.format('{"event":"scene_trace","kind":"%s","scene":"%s","sequence":%d,"pointer":"%s","speaker":"%s","text":"%s","detail":"%s","music":"%s"}',quote(kind),quote(scene),tonumber(sequence) or 0,quote(pointer or ''),quote(speaker or ''),quote(text or ''),quote(detail or ''),quote(SOUND:GetCurrentSong())))
end

function V:finish()
  if self.finishing then return end
  local expected=self.mode=='opening_scene' and 38 or (self.mode=='defeat_scene' and 11 or 25)
  local state=Route.GetState()
  local passed=self.dialogues==expected and self.menus==expected and self.choreography>0
  if self.mode=='opening_scene' then passed=passed and state.Attempts==1
  elseif self.mode=='defeat_scene' then passed=passed and state.Attempts==2 and state.Defeats==1
  else passed=passed and state.RescueComplete and self.sceneCompletes.d01p02_g1==1 and self.sceneCompletes.d01p01_g3==1 end
  emit(string.format('{"event":"scene_verdict","mode":"%s","verdict":"%s","dialogues":%d,"menus_closed":%d,"expected_dialogues":%d,"choreography":%d,"attempts":%d,"defeats":%d,"rescue_complete":%s}',quote(self.mode),passed and 'PASS' or 'FAIL',self.dialogues,self.menus,expected,self.choreography,state.Attempts or 0,state.Defeats or 0,state.RescueComplete and 'true' or 'false'))
  self.finishing=true
  local before,beforeRaw=phase(GameBaseType.CurrentPhase)
  GameBaseType.CurrentPhase=LoadPhaseType.Unload
  local after,afterRaw=phase(GameBaseType.CurrentPhase)
  emit('{"event":"load_phase_unload_requested","before":"'..quote(before)..'","before_raw":"'..quote(beforeRaw)..'","requested":"Unload","readback":"'..quote(after)..'","readback_raw":"'..quote(afterRaw)..'"}')
end

function V:OnInit()
  if not self.enabled then return end
  local f=io.open(EVENT_PATH,'w');if f then f:close() end
  if self.mode~='opening_scene' and self.mode~='defeat_scene' and self.mode~='ending_rescue_scene' then error('unsupported Tiny Woods scene mode') end
  emit(string.format('{"event":"bootstrap_new_game","mode":"%s","seed":%d}',quote(self.mode),self.seed))
  RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true;local s=Route.Reset()
  if self.mode=='defeat_scene' then
    s.Status='failed';s.Attempts=1;s.Defeats=1;s.PendingGround='d01p01'
    GAME:EnterZone('master_zone',-1,@@LAUNCHER_GROUND_INDEX@@,0)
  elseif self.mode=='ending_rescue_scene' then
    s.Status='cleared';s.Attempts=1;s.FloorsEntered={0,1,2};s.FloorsCleared={0,1,2};s.PendingGround='d01p02'
    GAME:EnterZone('tiny_woods',-1,1,0)
  else
    GAME:EnterZone('master_zone',-1,@@LAUNCHER_GROUND_INDEX@@,0)
  end
end
function V:OnUpdate()
  if not self.enabled or self.finishing then return end
  if MenuManagerType.Instance.MenuCount>0 then
    self.menus=self.menus+1
    emit(string.format('{"event":"dialogue_menu_closed","number":%d,"menu_count":%d}',self.menus,MenuManagerType.Instance.MenuCount))
    MenuManagerType.Instance:ClearMenus()
    return
  end
  if self.pendingFinish then self.pendingFinish=false;self:finish() end
end
function V:OnDungeonFloorEnter()
  if not self.enabled or self.finishing then return end
  if self.mode=='ending_rescue_scene' then error('ending scene unexpectedly entered dungeon') end
  emit(string.format('{"event":"scene_destination","mode":"%s","zone":"%s","floor":%d}',quote(self.mode),quote(_ZONE.CurrentZoneID),_ZONE.CurrentMapID.ID))
  self:finish()
end
function V:OnDeinit()
  if not self.enabled then return end
  local n,r=phase(GameBaseType.CurrentPhase)
  emit('{"event":"native_deinit","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:OnGraphicsUnload()
  if not self.enabled then return end
  local n,r=phase(GameBaseType.CurrentPhase)
  emit('{"event":"native_graphics_unload","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
  emit('{"event":"end","terminal":true,"graceful":true,"load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:Subscribe(med)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
  med:Subscribe('TinyWoodsSceneValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med) end
TINY_WOODS_SCENE_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=TINY_WOODS_SCENE_VALIDATOR_INSTANCE
SCRIPT:AddService('TinyWoodsSceneValidator',TINY_WOODS_SCENE_VALIDATOR_INSTANCE)
return V
