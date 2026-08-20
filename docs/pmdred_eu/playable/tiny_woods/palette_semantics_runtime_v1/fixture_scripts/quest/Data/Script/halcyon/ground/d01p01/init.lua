-- Production-overlay PMD Red EU Tiny Woods opening/retry/post-rescue relay.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Core=require 'halcyon.pmdred_tiny_woods_scenes'
local Campaign=require 'halcyon.pmdred_tiny_woods_command_campaign'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  if os.getenv('TINY_WOODS_COMMAND_MODE')=='palette_adapter_all' then Campaign.RunSemanticAdapterCertification();return end
  local group=Route.DispatchGround('d01p01');if group~='g1' and group~='g2' and group~='g3' then error('unsupported d01p01 group '..tostring(group)) end
  Core.Stage('d01p01_'..group);Campaign.RunCore('d01p01_'..group)
  if group=='g1' and os.getenv('TINY_WOODS_COMMAND_MODE')=='opening_naming' then Campaign.OpeningAutomationCheckpoint();return end
  if group=='g1' or group=='g2' then
    local seed=tonumber(os.getenv('TINY_WOODS_COMMAND_SEED') or '424242') or 424242;Route.BeginAttempt();RogueElements.MathUtils.ReSeedRand(seed)
    GAME:EnterDungeon('tiny_woods',0,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
  else
    Campaign.DeliverRewards();local state=Route.GetState();state.LastGround='d01p01';state.LastGroup='g3';state.PendingGround='b01p00a'
    GAME:EnterZone('master_zone',-1,141,0)
  end
end
function M.Exit(map) Core.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
