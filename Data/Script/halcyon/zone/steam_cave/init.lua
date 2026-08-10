--[[
    init.lua — Zone steam_cave (Steam Cave)
]]
require 'origin.common'

local steam_cave = {}

function steam_cave.Init(zone)
  PrintInfo("=>> Init_steam_cave")
end

function steam_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_steam_cave seg=" .. tostring(segmentID))
end

function steam_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_steam_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function steam_cave.Rescued(zone, name, mail)
end

return steam_cave
