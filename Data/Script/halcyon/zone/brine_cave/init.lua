--[[
    init.lua — Zone brine_cave (Brine Cave)
]]
require 'origin.common'

local brine_cave = {}

function brine_cave.Init(zone)
  PrintInfo("=>> Init_brine_cave")
end

function brine_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_brine_cave seg=" .. tostring(segmentID))
end

function brine_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_brine_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function brine_cave.Rescued(zone, name, mail)
end

return brine_cave
