--[[
    init.lua — Zone sealed_ruin (Sealed Ruin)
]]
require 'origin.common'

local sealed_ruin = {}

function sealed_ruin.Init(zone)
  PrintInfo("=>> Init_sealed_ruin")
end

function sealed_ruin.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_sealed_ruin seg=" .. tostring(segmentID))
end

function sealed_ruin.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_sealed_ruin result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function sealed_ruin.Rescued(zone, name, mail)
end

return sealed_ruin
