-- Fixture-local authenticated EU Caterpie rescue scene.
require 'origin.common'
local Route=require 'halcyon.pmdred_tiny_woods_route'
local Scene=require 'halcyon.pmdred_tiny_woods_scenes'
local M={}
function M.Init(map) DEBUG.EnableDbgCoro() end
function M.Enter(map)
  local group=Route.DispatchGround('d01p02')
  if group~='g1' then error('d01p02 scene did not dispatch g1') end
  Scene.Stage('d01p02_g1');Scene.Run('d01p02_g1')
  Route.CompleteRescue()
  GAME:EnterGroundMap('d01p01','Main_Entrance_Marker')
end
function M.Exit(map) Scene.Cleanup() end
function M.Update(map) end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
