--[[
    init.lua — Zone amp_plains (Amp Plains)
]]
require 'origin.common'

local amp_plains = {}

function amp_plains.Init(zone)
  PrintInfo("=>> Init_amp_plains")
end

function amp_plains.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_amp_plains seg=" .. tostring(segmentID))
end

function amp_plains.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_amp_plains result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function amp_plains.Rescued(zone, name, mail)
end

return amp_plains
