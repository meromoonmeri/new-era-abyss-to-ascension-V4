--[[
    init.lua — Zone silent_chasm (Silent Chasm)
]]
require 'origin.common'

local silent_chasm = {}

function silent_chasm.Init(zone)
  PrintInfo("=>> Init_silent_chasm")
end

function silent_chasm.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_silent_chasm seg=" .. tostring(segmentID))
end

function silent_chasm.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_silent_chasm result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function silent_chasm.Rescued(zone, name, mail)
end

return silent_chasm
