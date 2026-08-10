--[[
    init.lua — Zone magma_cavern (Magma Cavern)
]]
require 'origin.common'

local magma_cavern = {}

function magma_cavern.Init(zone)
  PrintInfo("=>> Init_magma_cavern")
end

function magma_cavern.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_magma_cavern seg=" .. tostring(segmentID))
end

function magma_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_magma_cavern result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function magma_cavern.Rescued(zone, name, mail)
end

return magma_cavern
