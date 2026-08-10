--[[
    init.lua — Zone crystal_cave (Crystal Cave)
]]
require 'origin.common'

local crystal_cave = {}

function crystal_cave.Init(zone)
  PrintInfo("=>> Init_crystal_cave")
end

function crystal_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_crystal_cave seg=" .. tostring(segmentID))
end

function crystal_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_crystal_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function crystal_cave.Rescued(zone, name, mail)
end

return crystal_cave
