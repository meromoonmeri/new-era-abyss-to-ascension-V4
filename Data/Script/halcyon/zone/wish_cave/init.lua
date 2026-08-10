--[[
    init.lua — Zone wish_cave (Wish Cave)
]]
require 'origin.common'

local wish_cave = {}

function wish_cave.Init(zone)
  PrintInfo("=>> Init_wish_cave")
end

function wish_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_wish_cave seg=" .. tostring(segmentID))
end

function wish_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_wish_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function wish_cave.Rescued(zone, name, mail)
end

return wish_cave
