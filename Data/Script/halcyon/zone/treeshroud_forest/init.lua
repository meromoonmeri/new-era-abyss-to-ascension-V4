--[[
    init.lua — Zone treeshroud_forest (Treeshroud Forest)
]]
require 'origin.common'

local treeshroud_forest = {}

function treeshroud_forest.Init(zone)
  PrintInfo("=>> Init_treeshroud_forest")
end

function treeshroud_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_treeshroud_forest seg=" .. tostring(segmentID))
end

function treeshroud_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_treeshroud_forest result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function treeshroud_forest.Rescued(zone, name, mail)
end

return treeshroud_forest
