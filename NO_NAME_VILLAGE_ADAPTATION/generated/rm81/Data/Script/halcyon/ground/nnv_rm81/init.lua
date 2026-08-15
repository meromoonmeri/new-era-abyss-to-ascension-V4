-- Generated NNV→PMDO candidate; not a production route.
require 'origin.common'
require 'halcyon.LivingWorld'
require 'halcyon.TownLife'
require 'halcyon.TownPlace'
require 'halcyon.Seasons'
require 'halcyon.Weather'
require 'halcyon.TownNight'
local M = {}
function M.Init(map)
  LivingWorld.Ensure()
  TownNight.Ensure()
end
function M.Enter(map)
  LivingWorld.SyncStory()
  M.Context = LivingWorld.Context('no_name_village', 'nnv_rm81')
  M.Day = TownLife.Today()
  LivingWorld.ApplyOutdoor(true)
  Seasons.Setup()
  local preset = Weather.ForChapter((SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1)
  if preset ~= nil then Weather.Set(preset) end
end
function M.PlaceDialogue(inst)
  return TownPlace.Line(inst)
end
function M.Exit(map) end
function M.Update(map) end
function M.Exit_North_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm82', 'Entry_South')
end
function M.Exit_West_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm73', 'Entry_East')
end
function M.Exit_South_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm84', 'Entry_North')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
