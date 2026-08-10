--[[
    init.lua — Zone northern_desert (Northern Desert)
]]
require 'origin.common'

local northern_desert = {}

function northern_desert.Init(zone)
  PrintInfo("=>> Init_northern_desert")
end

function northern_desert.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_northern_desert seg=" .. tostring(segmentID))
end

function northern_desert.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_northern_desert result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function northern_desert.Rescued(zone, name, mail)
end

return northern_desert
