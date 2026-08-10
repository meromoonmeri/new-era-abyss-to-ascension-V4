--[[
    init.lua — Zone hidden_land (Hidden Land)
]]
require 'origin.common'

local hidden_land = {}

function hidden_land.Init(zone)
  PrintInfo("=>> Init_hidden_land")
end

function hidden_land.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_hidden_land seg=" .. tostring(segmentID))
end

function hidden_land.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_hidden_land result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function hidden_land.Rescued(zone, name, mail)
end

return hidden_land
