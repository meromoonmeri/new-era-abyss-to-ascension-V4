--[[
    init.lua — Zone beach_cave (Beach Cave)
]]
require 'origin.common'

local beach_cave = {}

function beach_cave.Init(zone)
  PrintInfo("=>> Init_beach_cave")
end

function beach_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_beach_cave seg=" .. tostring(segmentID))
end

function beach_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_beach_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function beach_cave.Rescued(zone, name, mail)
end

return beach_cave
