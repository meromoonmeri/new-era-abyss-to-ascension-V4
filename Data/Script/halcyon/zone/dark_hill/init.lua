--[[
    init.lua — Zone dark_hill (Dark Hill)
]]
require 'origin.common'

local dark_hill = {}

function dark_hill.Init(zone)
  PrintInfo("=>> Init_dark_hill")
end

function dark_hill.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_dark_hill seg=" .. tostring(segmentID))
end

function dark_hill.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_dark_hill result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function dark_hill.Rescued(zone, name, mail)
end

return dark_hill
