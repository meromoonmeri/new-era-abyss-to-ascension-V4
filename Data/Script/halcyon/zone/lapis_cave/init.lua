--[[
    init.lua — Zone lapis_cave (Lapis Cave)
]]
require 'origin.common'

local lapis_cave = {}

function lapis_cave.Init(zone)
  PrintInfo("=>> Init_lapis_cave")
end

function lapis_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_lapis_cave seg=" .. tostring(segmentID))
end

function lapis_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_lapis_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function lapis_cave.Rescued(zone, name, mail)
end

return lapis_cave
