--[[
    init.lua — Zone thunderwave_cave (Thunderwave Cave)
]]
require 'origin.common'

local thunderwave_cave = {}

function thunderwave_cave.Init(zone)
  PrintInfo("=>> Init_thunderwave_cave")
end

function thunderwave_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_thunderwave_cave seg=" .. tostring(segmentID))
end

function thunderwave_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_thunderwave_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function thunderwave_cave.Rescued(zone, name, mail)
end

return thunderwave_cave
