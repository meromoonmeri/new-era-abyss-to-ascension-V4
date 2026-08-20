-- Exact-PMDO validator for Tiny Woods palette semantics and integrated choreography.
require 'origin.common'
require 'origin.services.baseservice'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local V = Class('TinyWoodsCommandCompleteValidator', BaseService)
local GameBaseType = luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType = luanet.import_type('RogueEssence.GameBase+LoadPhase')
local MenuManagerType = luanet.import_type('RogueEssence.Menu.MenuManager')
local EVENT_PATH = '/tmp/tiny_woods_command_complete.jsonl'

local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\r','\\r'):gsub('\n','\\n'):gsub('\t','\\t')end
local function emit(s)
  PrintInfo('[TINY_WOODS_COMMAND_COMPLETE] '..s)
  local f=io.open(EVENT_PATH,'a');if f then f:write(s..'\n');f:flush();f:close() end
end
local function phase(v)local raw=tostring(v);return raw:match('^([%a_]+)') or raw,raw end
local function size(t)local n=0;for _ in pairs(t) do n=n+1 end;return n end
local function jsonScalar(v)if v==nil then return 'null' end;return tostring(v) end
local function equalRoute(actual,expected)
  if #actual~=#expected then return false end
  for i=1,#expected do if actual[i]~=expected[i] then return false end end
  return true
end

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='tiny_woods_command_complete'
  self.mode=os.getenv('TINY_WOODS_COMMAND_MODE') or 'post_route'
  self.seed=tonumber(os.getenv('TINY_WOODS_COMMAND_SEED') or '424242') or 424242
  self.started=false;self.finishing=false;self.pendingFinish=false
  self.dialogues=0;self.menus=0;self.namingHero=0;self.namingTeam=0
  self.namingHeroAfter=-1;self.commands={};self.arrays={};self.cues={};self.route={}
  self.sceneStarts={};self.sceneCompletes={};self.rewards={};self.progression=false;self.paletteTransitions=0
end

PMDRED_TINY_WOODS_COMMAND_TRACE=function(arrayId,index,address,op,argByte,argShort,arg1,arg2,handler)
  local v=TINY_WOODS_COMMAND_COMPLETE_VALIDATOR_INSTANCE
  if v==nil or not v.enabled then return end
  v.commands[address]=true;v.arrays[arrayId]=true
  emit(string.format('{"event":"command_trace","array":"%s","index":%d,"address":"%s","op":%d,"arg_byte":%d,"arg_short":%d,"arg1":%d,"arg2":%d,"handler":"%s"}',quote(arrayId),tonumber(index) or -1,quote(address),tonumber(op) or -1,tonumber(argByte) or 0,tonumber(argShort) or 0,tonumber(arg1) or 0,tonumber(arg2) or 0,quote(handler)))
end

PMDRED_TINY_WOODS_SCENE_TRACE=function(kind,scene,sequence,pointer,speaker,text,detail)
  local v=TINY_WOODS_COMMAND_COMPLETE_VALIDATOR_INSTANCE
  if v==nil or not v.enabled then return end
  if kind=='dialogue' then v.dialogues=v.dialogues+1 end
  if kind=='scene_start' then v.sceneStarts[scene]=(v.sceneStarts[scene] or 0)+1 end
  if kind=='scene_complete' then v.sceneCompletes[scene]=(v.sceneCompletes[scene] or 0)+1 end
  if kind=='naming_hero' then v.namingHero=v.namingHero+1;v.namingHeroAfter=v.dialogues end
  if kind=='naming_team' then v.namingTeam=v.namingTeam+1 end
  if kind=='audio_cue' then v.cues[tostring(detail)]=true end
  if kind=='reward' then v.rewards[tostring(detail)]=true end
  if kind=='palette_transition_complete' then v.paletteTransitions=v.paletteTransitions+1 end
  if kind=='opening_automation_checkpoint' or kind=='palette_semantic_automation_checkpoint' then v.pendingFinish=true end
  if kind=='progression' then v.progression=true;v.pendingFinish=true end
  emit(string.format('{"event":"scene_trace","kind":"%s","scene":"%s","sequence":%d,"pointer":"%s","speaker":"%s","text":"%s","detail":"%s","music":"%s"}',quote(kind),quote(scene),tonumber(sequence) or 0,quote(pointer or ''),quote(speaker or ''),quote(text or ''),quote(detail or ''),quote(SOUND:GetCurrentSong())))
end

function V:finish()
  if self.finishing then return end
  local state=Route.GetState()
  local commandCount=size(self.commands);local arrayCount=size(self.arrays);local cueCount=size(self.cues)
  local expectedRoute=(self.mode=='opening_naming' or self.mode=='palette_adapter_all') and {'d01p01'} or {'d01p02','d01p01','b01p00a','s02_fre'}
  local passed=commandCount==975 and arrayCount==27 and equalRoute(self.route,expectedRoute)
  if self.mode=='palette_adapter_all' then
    passed=passed and self.dialogues==0 and self.menus==0 and self.paletteTransitions==15
  elseif self.mode=='opening_naming' then
    passed=passed and self.dialogues==38 and self.menus==38 and self.namingHero==1 and self.namingHeroAfter==23
      and self.sceneCompletes.d01p01_g1==1 and state.Attempts==0
  else
    local progress=SV.PmdRedTinyWoodsProgress or {}
    local scenario=SV.Scenario or {}
    passed=passed and self.dialogues==56 and self.menus==56 and self.namingTeam==1 and cueCount==8
      and self.sceneCompletes.d01p02_g1==1 and self.sceneCompletes.d01p01_g3==1
      and self.sceneCompletes.b01p00a_g16==1 and self.sceneCompletes.s02_fre_g2==1
      and state.RescueComplete and state.RewardsDelivered==true
      and self.rewards.berry_oran and self.rewards.berry_pecha and self.rewards.berry_rawst
      and _DATA.Save:GetDungeonUnlock('tiny_woods')==RogueEssence.Data.GameProgress.UnlockState.Completed
      and scenario.Main==3 and scenario.MainLevel==0
      and progress.EventDivision=='EVENT_DIVIDE' and progress.Scenario==3 and progress.Level==0
      and self.progression
  end
  emit(string.format('{"event":"command_complete_verdict","mode":"%s","verdict":"%s","commands":%d,"arrays":%d,"palette_transitions":%d,"dialogues":%d,"menus_closed":%d,"hero_naming":%d,"hero_naming_after_dialogues":%d,"team_naming":%d,"cues":%d,"route":"%s","tiny_woods_unlock":"%s","scenario_main":%s,"scenario_level":%s,"event_division":"%s"}',quote(self.mode),passed and 'PASS' or 'FAIL',commandCount,arrayCount,self.paletteTransitions,self.dialogues,self.menus,self.namingHero,self.namingHeroAfter,self.namingTeam,cueCount,quote(table.concat(self.route,'>')),quote(_DATA.Save:GetDungeonUnlock('tiny_woods')),jsonScalar((SV.Scenario or {}).Main),jsonScalar((SV.Scenario or {}).MainLevel),quote((SV.PmdRedTinyWoodsProgress or {}).EventDivision)))
  self.finishing=true
  local before,beforeRaw=phase(GameBaseType.CurrentPhase)
  GameBaseType.CurrentPhase=LoadPhaseType.Unload
  local after,afterRaw=phase(GameBaseType.CurrentPhase)
  emit('{"event":"load_phase_unload_requested","before":"'..quote(before)..'","before_raw":"'..quote(beforeRaw)..'","requested":"Unload","readback":"'..quote(after)..'","readback_raw":"'..quote(afterRaw)..'"}')
end

function V:OnInit()
  if not self.enabled then return end
  local f=io.open(EVENT_PATH,'w');if f then f:close() end
  if self.mode~='opening_naming' and self.mode~='post_route' and self.mode~='palette_adapter_all' then error('unsupported palette-semantic mode') end
  emit(string.format('{"event":"bootstrap_new_game","mode":"%s","seed":%d}',quote(self.mode),self.seed))
  RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true;local s=Route.Reset()
  if self.mode=='post_route' then
    s.Status='cleared';s.Attempts=1;s.FloorsEntered={0,1,2};s.FloorsCleared={0,1,2};s.PendingGround='d01p02'
    GAME:EnterZone('tiny_woods',-1,1,0)
  else
    GAME:EnterZone('master_zone',-1,308,0)
  end
end
function V:OnUpdate()
  if not self.enabled or self.finishing then return end
  if MenuManagerType.Instance.MenuCount>0 then
    self.menus=self.menus+1
    emit(string.format('{"event":"dialogue_menu_closed","number":%d,"menu_count":%d}',self.menus,MenuManagerType.Instance.MenuCount))
    MenuManagerType.Instance:ClearMenus();return
  end
  if self.pendingFinish then self.pendingFinish=false;self:finish() end
end
function V:OnGroundMapEnter()
  if not self.enabled or self.finishing then return end
  local name=GAME:GetCurrentGround().AssetName;table.insert(self.route,name)
  emit(string.format('{"event":"ground_enter","ordinal":%d,"ground":"%s"}',#self.route,quote(name)))
end
function V:OnDungeonFloorEnter()
  if not self.enabled or self.finishing then return end
  emit('{"event":"unexpected_dungeon_floor","zone":"'..quote(_ZONE.CurrentZoneID)..'"}')
end
function V:OnDeinit()
  if not self.enabled then return end
  local n,r=phase(GameBaseType.CurrentPhase);emit('{"event":"native_deinit","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:OnGraphicsUnload()
  if not self.enabled then return end
  local n,r=phase(GameBaseType.CurrentPhase);emit('{"event":"native_graphics_unload","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
  emit('{"event":"end","terminal":true,"graceful":true,"load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:Subscribe(med)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
  med:Subscribe('TinyWoodsCommandCompleteValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med) end
TINY_WOODS_COMMAND_COMPLETE_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=TINY_WOODS_COMMAND_COMPLETE_VALIDATOR_INSTANCE
SCRIPT:AddService('TinyWoodsCommandCompleteValidator',TINY_WOODS_COMMAND_COMPLETE_VALIDATOR_INSTANCE)
return V
