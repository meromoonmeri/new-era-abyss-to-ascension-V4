--[[
    init.lua — Zone quicksand_cave (Quicksand Cave)
]]
require 'origin.common'

local quicksand_cave = {}

function quicksand_cave.Init(zone)
  PrintInfo("=>> Init_quicksand_cave")
end

function quicksand_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_quicksand_cave seg=" .. tostring(segmentID))
end

function quicksand_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_quicksand_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function quicksand_cave.Rescued(zone, name, mail)
end

return quicksand_cave
