--[[
    init.lua — Zone waterfall_cave (Waterfall Cave)
]]
require 'origin.common'

local waterfall_cave = {}

function waterfall_cave.Init(zone)
  PrintInfo("=>> Init_waterfall_cave")
end

function waterfall_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_waterfall_cave seg=" .. tostring(segmentID))
end

function waterfall_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_waterfall_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function waterfall_cave.Rescued(zone, name, mail)
end

return waterfall_cave
