-- Fixture-local authenticated EU Tiny Woods entry scenes.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Scene=require 'halcyon.pmdred_tiny_woods_scenes'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p01')
  if group~='g1' and group~='g2' and group~='g3' then error('unsupported d01p01 scene group '..tostring(group)) end
  Scene.Stage('d01p01_'..group)
  Scene.Run('d01p01_'..group)
  if group=='g1' or group=='g2' then
    local seed=tonumber(os.getenv('TINY_WOODS_SCENE_SEED') or '424242') or 424242
    Route.BeginAttempt();RogueElements.MathUtils.ReSeedRand(seed)
    GAME:EnterDungeon('tiny_woods',0,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true)
  end
end
function M.Exit(map) Scene.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
