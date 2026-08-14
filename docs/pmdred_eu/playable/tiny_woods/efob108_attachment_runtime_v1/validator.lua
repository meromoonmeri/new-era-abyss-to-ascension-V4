-- Exact-runtime Caterpie efob108 attachment validator. Disabled unless opted in.
require 'origin.common'
require 'origin.services.baseservice'
local Route = require 'halcyon.pmdred_tiny_woods_route'
local Attachment = require 'halcyon.pmdred_efob108_attachment_fixture'
local V = Class('PmdRedEfob108AttachmentValidator', BaseService)
local GameBaseType = luanet.import_type('RogueEssence.GameBase')
local LoadPhaseType = luanet.import_type('RogueEssence.GameBase+LoadPhase')
local EVENT_PATH = '/tmp/pmdred_efob108_attachment.jsonl'

local function quote(value)
  return tostring(value):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\r','\\r'):gsub('\n',' | '):gsub('\t','\\t')
end
local function json_value(value)
  local kind=type(value)
  if kind=='boolean' then return value and 'true' or 'false' end
  if kind=='number' then return tostring(value) end
  if value==nil then return 'null' end
  return '"'..quote(value)..'"'
end
local function emit_record(event, fields)
  local keys={}
  for key,_ in pairs(fields or {}) do table.insert(keys,key) end
  table.sort(keys)
  local parts={'"event":'..json_value(event)}
  for _,key in ipairs(keys) do table.insert(parts,'"'..quote(key)..'":'..json_value(fields[key])) end
  local line='{'..table.concat(parts,',')..'}'
  PrintInfo('[PMDRED_EFOB108_ATTACHMENT] '..line)
  local stream=io.open(EVENT_PATH,'a')
  if stream then stream:write(line..'\n');stream:flush();stream:close() end
end
local function phase(value)
  local raw=tostring(value);local name=raw:match('^([%a_]+)');return name or raw,raw
end
local function safe(call, default)
  local ok,value=pcall(call);if ok then return value end;return default
end

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_GROUND_VALIDATOR')=='pmdred_efob108_attachment_fixture'
  self.seed=tonumber(os.getenv('PMDRED_EFOB108_SEED') or '424242') or 424242
  self.started=false;self.finishing=false;self.task=nil;self.visit=0
end

function V:finish(verdict)
  if self.finishing then return end
  self.finishing=true
  emit_record('fixture_verdict',{verdict=verdict,visits=self.visit})
  local before_value=safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED')
  local before,before_raw=phase(before_value)
  local assigned_value=safe(function()GameBaseType.CurrentPhase=LoadPhaseType.Unload;return GameBaseType.CurrentPhase end,'WRITE_FAILED')
  local assigned,assigned_raw=phase(assigned_value)
  emit_record('load_phase_unload_requested',{
    before=before,before_raw=before_raw,requested='Unload',readback=assigned,readback_raw=assigned_raw,
  })
end

function V:queue_ground(ground)
  if self.task~=nil then
    emit_record('fixture_fail',{error='validator ground task overlap',ground=ground})
    self:finish('FAIL')
    return
  end
  self.task=TASK:BranchCoroutine(function()
    GAME:WaitFrames(2)
    local ok,err=xpcall(function()
      self.visit=self.visit+1
      emit_record('ground_enter',{ground=ground,visit=self.visit})
      if ground=='d01p02' and self.visit==1 then
        local state=Route.GetState()
        if state.LastGroup~='g1' then error('d01p02 did not dispatch authenticated ending group g1') end
        local caterpie=GAME:GetCurrentGround():GetChar('CATERPIE')
        Attachment.Run(caterpie,function(kind,fields)emit_record(kind,fields)end)
        self:finish('PASS')
      else
        error('unexpected Ground visit '..tostring(ground)..' #'..tostring(self.visit))
      end
    end,debug.traceback)
    if not ok then
      emit_record('fixture_fail',{error=err})
      self:finish('FAIL')
    end
    self.task=nil
  end)
end

function V:OnInit()
  if not self.enabled then return end
  local stream=io.open(EVENT_PATH,'w');if stream then stream:close() end
  emit_record('bootstrap_new_game',{seed=self.seed,validator='pmdred_efob108_attachment_fixture'})
  RogueEssence.GameManager.Instance:NewGamePlus(self.seed)
end
function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true
  local state=Route.Reset()
  state.Status='cleared';state.Attempts=1;state.Defeats=0
  state.FloorsEntered={0,1,2};state.FloorsCleared={0,1,2}
  state.RescueComplete=false;state.PendingGround='d01p02';state.LastResult='Cleared'
  emit_record('route_staged',{status=state.Status,attempts=state.Attempts,floors_entered=#state.FloorsEntered,floors_cleared=#state.FloorsCleared})
  GAME:EnterZone('tiny_woods',-1,1,0)
end
function V:OnGroundMapEnter()
  if not self.enabled or self.finishing then return end
  self:queue_ground(GAME:GetCurrentGround().AssetName)
end
function V:OnDeinit()
  if not self.enabled then return end
  local name,raw=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'))
  emit_record('native_deinit',{load_phase=name,load_phase_raw=raw})
end
function V:OnGraphicsUnload()
  if not self.enabled then return end
  local name,raw=phase(safe(function()return GameBaseType.CurrentPhase end,'READ_FAILED'))
  emit_record('native_graphics_unload',{load_phase=name,load_phase_raw=raw})
  emit_record('end',{terminal=true,graceful=true,load_phase=name,load_phase_raw=raw})
end
function V:Subscribe(med)
  med:Subscribe('PmdRedEfob108AttachmentValidator',EngineServiceEvents.Init,function()self.OnInit(self)end)
  med:Subscribe('PmdRedEfob108AttachmentValidator',EngineServiceEvents.NewGame,function()self.OnNewGame(self)end)
  med:Subscribe('PmdRedEfob108AttachmentValidator',EngineServiceEvents.GroundMapEnter,function()self.OnGroundMapEnter(self)end)
  med:Subscribe('PmdRedEfob108AttachmentValidator',EngineServiceEvents.Deinit,function()self.OnDeinit(self)end)
  med:Subscribe('PmdRedEfob108AttachmentValidator',EngineServiceEvents.GraphicsUnload,function()self.OnGraphicsUnload(self)end)
end
function V:UnSubscribe(med) end
PMDRED_EFOB108_ATTACHMENT_VALIDATOR_INSTANCE=V:new()
PMDRED_EU_NATIVE_VALIDATOR_INSTANCE=PMDRED_EFOB108_ATTACHMENT_VALIDATOR_INSTANCE
SCRIPT:AddService('PmdRedEfob108AttachmentValidator',PMDRED_EFOB108_ATTACHMENT_VALIDATOR_INSTANCE)
return V
