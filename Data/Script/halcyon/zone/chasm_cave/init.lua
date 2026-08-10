--[[
    init.lua — Zone chasm_cave (Chasm Cave)
]]
require 'origin.common'

local chasm_cave = {}

function chasm_cave.Init(zone)
  PrintInfo("=>> Init_chasm_cave")
end

function chasm_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_chasm_cave seg=" .. tostring(segmentID))
end

function chasm_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_chasm_cave result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function chasm_cave.Rescued(zone, name, mail)
end

return chasm_cave
