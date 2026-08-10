--[[
    init.lua — Zone foggy_forest (Foggy Forest)
]]
require 'origin.common'

local foggy_forest = {}

function foggy_forest.Init(zone)
  PrintInfo("=>> Init_foggy_forest")
end

function foggy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_foggy_forest seg=" .. tostring(segmentID))
end

function foggy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_foggy_forest result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function foggy_forest.Rescued(zone, name, mail)
end

return foggy_forest
