--[[
    init.lua — Zone great_canyon (Great Canyon)
]]
require 'origin.common'

local great_canyon = {}

function great_canyon.Init(zone)
  PrintInfo("=>> Init_great_canyon")
end

function great_canyon.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_great_canyon seg=" .. tostring(segmentID))
end

function great_canyon.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_great_canyon result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function great_canyon.Rescued(zone, name, mail)
end

return great_canyon
