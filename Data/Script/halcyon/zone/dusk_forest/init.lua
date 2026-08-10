--[[
    init.lua — Zone dusk_forest (Dusk Forest)
]]
require 'origin.common'

local dusk_forest = {}

function dusk_forest.Init(zone)
  PrintInfo("=>> Init_dusk_forest")
end

function dusk_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_dusk_forest seg=" .. tostring(segmentID))
end

function dusk_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_dusk_forest result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function dusk_forest.Rescued(zone, name, mail)
end

return dusk_forest
