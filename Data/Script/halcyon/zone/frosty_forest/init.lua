--[[
    init.lua — Zone frosty_forest (Frosty Forest)
]]
require 'origin.common'

local frosty_forest = {}

function frosty_forest.Init(zone)
  PrintInfo("=>> Init_frosty_forest")
end

function frosty_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_frosty_forest seg=" .. tostring(segmentID))
end

function frosty_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_frosty_forest result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function frosty_forest.Rescued(zone, name, mail)
end

return frosty_forest
