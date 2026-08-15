-- Exact-PMDO validator for the recovered Tiny Woods 304-command semantic supplement v3.
require 'origin.common'
require 'origin.services.baseservice'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local V = Class('TinyWoodsCommandSemanticV3Validator', BaseService)
local GameBaseType = luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType = luanet.import_type('RogueEssence.GameBase+LoadPhase')
local EVENT_PATH = '/tmp/tiny_woods_command_semantic_v3.jsonl'
local EXPECTED = {@@SEMANTIC_EXPECTED_ROWS@@}

local function quote(v)return tostring(v):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\r','\\r'):gsub('\n','\\n'):gsub('\t','\\t')end
local function emit(s)
  PrintInfo('[TINY_WOODS_COMMAND_SEMANTIC_V3] '..s)
  local f=io.open(EVENT_PATH,'a');if f then f:write(s..'\n');f:flush();f:close() end
end
local function phase(v)local raw=tostring(v);return raw:match('^([%a_]+)') or raw,raw end
local function size(t)local n=0;for _ in pairs(t) do n=n+1 end;return n end
local function same(a,b)return tostring(a)==tostring(b)end

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='tiny_woods_command_semantic_v3'
  self.mode=os.getenv('TINY_WOODS_COMMAND_MODE') or 'semantic_selected_v3'
  self.seed=tonumber(os.getenv('TINY_WOODS_COMMAND_SEED') or '424242') or 424242
  self.started=false;self.finishing=false;self.pendingFinish=false;self.fault=false
  self.commands={};self.arrays={};self.route={};self.semanticStarts=0;self.semanticCompletes=0
  self.waits=0;self.waitFrames=0;self.pendingOrdinal=nil
end

-- The palette/command-complete validator is required immediately before this
-- service.  Preserve its callback exactly for all legacy validator modes.
local PREVIOUS_COMMAND_TRACE=PMDRED_TINY_WOODS_COMMAND_TRACE
PMDRED_TINY_WOODS_COMMAND_TRACE=function(arrayId,index,address,op,argByte,argShort,arg1,arg2,handler)
  local v=TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE
  if v==nil or not v.enabled then
    if PREVIOUS_COMMAND_TRACE then return PREVIOUS_COMMAND_TRACE(arrayId,index,address,op,argByte,argShort,arg1,arg2,handler) end
    return
  end
  v.commands[address]=true;v.arrays[arrayId]=true
  emit(string.format('{"event":"command_trace","array":"%s","index":%d,"address":"%s","op":%d,"arg_byte":%d,"arg_short":%d,"arg1":%d,"arg2":%d,"handler":"%s"}',quote(arrayId),tonumber(index) or -1,quote(address),tonumber(op) or -1,tonumber(argByte) or 0,tonumber(argShort) or 0,tonumber(arg1) or 0,tonumber(arg2) or 0,quote(handler)))
end

PMDRED_TINY_WOODS_COMMAND_SEMANTIC_TRACE=function(kind,ordinal,address,arrayId,index,op,argByte,argShort,arg1,arg2,handler,category,api,routeClass,sourceFrames,beforeTick,afterTick,elapsedFrames)
  local v=TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE
  if v==nil or not v.enabled then return true end
  local e=EXPECTED[(tonumber(ordinal) or -1)+1]
  local eligible=e~=nil and (v.mode=='semantic_all_v3' or e.route_class=='selected_route')
  local matches=eligible and same(e.address,address) and same(e.array_id,arrayId) and e.source_index==tonumber(index)
    and e.op==tonumber(op) and e.arg_byte==tonumber(argByte) and e.arg_short==tonumber(argShort)
    and e.arg1==tonumber(arg1) and e.arg2==tonumber(arg2) and same(e.handler,handler)
    and same(e.category,category) and same(e.api,api) and same(e.route_class,routeClass)
    and e.source_frames==tonumber(sourceFrames)
  if kind=='semantic_start' then
    if v.pendingOrdinal~=nil or not matches then
      v.fault=true
      emit(string.format('{"event":"command_semantic_error","kind":"start","ordinal":%d,"address":"%s","expected_address":"%s","reason":"ordinal metadata mismatch"}',tonumber(ordinal) or -1,quote(address),quote(e and e.address or 'missing')))
      return false
    end
    v.pendingOrdinal=tonumber(ordinal);v.semanticStarts=v.semanticStarts+1
  elseif kind=='semantic_complete' then
    local elapsed=tonumber(elapsedFrames) or -1
    local tickOrder=(tonumber(afterTick) or -1)>=(tonumber(beforeTick) or 0)
    local expectedElapsed=e and e.source_frames or -1
    if v.pendingOrdinal~=tonumber(ordinal) or not matches or not tickOrder or elapsed~=expectedElapsed then
      v.fault=true
      emit(string.format('{"event":"command_semantic_error","kind":"complete","ordinal":%d,"address":"%s","expected_elapsed":%d,"actual_elapsed":%d,"reason":"completion metadata mismatch"}',tonumber(ordinal) or -1,quote(address),expectedElapsed,elapsed))
      return false
    end
    v.pendingOrdinal=nil;v.semanticCompletes=v.semanticCompletes+1
    if e.op==0xDB then v.waits=v.waits+1;v.waitFrames=v.waitFrames+e.source_frames end
  else
    v.fault=true;emit('{"event":"command_semantic_error","reason":"unknown trace kind"}');return false
  end
  emit(string.format('{"event":"command_semantic_trace","kind":"%s","ordinal":%d,"address":"%s","array":"%s","index":%d,"op":%d,"arg_byte":%d,"arg_short":%d,"arg1":%d,"arg2":%d,"handler":"%s","category":"%s","api":"%s","route_class":"%s","source_frames":%d,"before_tick":%d,"after_tick":%d,"elapsed_frames":%d}',quote(kind),tonumber(ordinal) or -1,quote(address),quote(arrayId),tonumber(index) or -1,tonumber(op) or -1,tonumber(argByte) or 0,tonumber(argShort) or 0,tonumber(arg1) or 0,tonumber(arg2) or 0,quote(handler),quote(category),quote(api),quote(routeClass),tonumber(sourceFrames) or 0,tonumber(beforeTick) or 0,tonumber(afterTick) or 0,tonumber(elapsedFrames) or 0))
  return true
end

PMDRED_TINY_WOODS_COMMAND_SEMANTIC_CHECKPOINT=function()
  local v=TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE
  if v~=nil and v.enabled then v.pendingFinish=true end
end

function V:finish()
  if self.finishing then return end
  local expectedCommands=self.mode=='semantic_all_v3' and 304 or 251
  local expectedWaits=self.mode=='semantic_all_v3' and 108 or 92
  local expectedFrames=self.mode=='semantic_all_v3' and 3001 or 2690
  local passed=not self.fault and self.pendingOrdinal==nil and size(self.commands)==975 and size(self.arrays)==27
    and #self.route==1 and self.route[1]=='d01p01' and self.semanticStarts==expectedCommands
    and self.semanticCompletes==expectedCommands and self.waits==expectedWaits and self.waitFrames==expectedFrames
  emit(string.format('{"event":"command_semantic_verdict","mode":"%s","verdict":"%s","commands":%d,"arrays":%d,"semantic_starts":%d,"semantic_completes":%d,"waits":%d,"wait_frames":%d,"fault":%s,"route":"%s"}',quote(self.mode),passed and 'PASS' or 'FAIL',size(self.commands),size(self.arrays),self.semanticStarts,self.semanticCompletes,self.waits,self.waitFrames,self.fault and 'true' or 'false',quote(table.concat(self.route,'>'))))
  self.finishing=true
  local before,beforeRaw=phase(GameBaseType.CurrentPhase);GameBaseType.CurrentPhase=LoadPhaseType.Unload
  local after,afterRaw=phase(GameBaseType.CurrentPhase)
  emit('{"event":"load_phase_unload_requested","before":"'..quote(before)..'","before_raw":"'..quote(beforeRaw)..'","requested":"Unload","readback":"'..quote(after)..'","readback_raw":"'..quote(afterRaw)..'"}')
end

function V:OnInit()
  if not self.enabled then return end
  local f=io.open(EVENT_PATH,'w');if f then f:close() end
  if self.mode~='semantic_selected_v3' and self.mode~='semantic_all_v3' then error('unsupported command-semantic-v3 mode') end
  emit(string.format('{"event":"bootstrap_new_game","mode":"%s","seed":%d}',quote(self.mode),self.seed))
  RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true;Route.Reset();GAME:EnterZone('master_zone',-1,@@LAUNCHER_GROUND_INDEX@@,0)
end
function V:OnUpdate()
  if not self.enabled or self.finishing then return end
  if self.pendingFinish then self.pendingFinish=false;self:finish() end
end
function V:OnGroundMapEnter()
  if not self.enabled or self.finishing then return end
  local name=GAME:GetCurrentGround().AssetName;table.insert(self.route,name)
  emit(string.format('{"event":"ground_enter","ordinal":%d,"ground":"%s"}',#self.route,quote(name)))
end
function V:OnDungeonFloorEnter()if self.enabled and not self.finishing then self.fault=true;emit('{"event":"unexpected_dungeon_floor"}') end end
function V:OnDeinit()if self.enabled then local n,r=phase(GameBaseType.CurrentPhase);emit('{"event":"native_deinit","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}') end end
function V:OnGraphicsUnload()
  if not self.enabled then return end
  local n,r=phase(GameBaseType.CurrentPhase);emit('{"event":"native_graphics_unload","load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
  emit('{"event":"end","terminal":true,"graceful":true,"load_phase":"'..quote(n)..'","load_phase_raw":"'..quote(r)..'"}')
end
function V:Subscribe(med)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.Update,function()self.OnUpdate(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.DungeonFloorEnter,function()self.OnDungeonFloorEnter(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
  med:Subscribe('TinyWoodsCommandSemanticV3Validator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med) end
TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE
SCRIPT:AddService('TinyWoodsCommandSemanticV3Validator',TINY_WOODS_COMMAND_SEMANTIC_V3_VALIDATOR_INSTANCE)
return V
