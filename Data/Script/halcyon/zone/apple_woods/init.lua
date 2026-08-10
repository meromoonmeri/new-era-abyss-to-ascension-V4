--[[
    init.lua — Zone apple_woods (Apple Woods)
]]
require 'origin.common'

local apple_woods = {}

function apple_woods.Init(zone)
  PrintInfo("=>> Init_apple_woods")
end

function apple_woods.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_apple_woods seg=" .. tostring(segmentID))
end

function apple_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_apple_woods result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function apple_woods.Rescued(zone, name, mail)
end

return apple_woods
