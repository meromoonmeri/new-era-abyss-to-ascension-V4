--[[
    init.lua — Zone drenched_bluff (Drenched Bluff)
]]
require 'origin.common'

local drenched_bluff = {}

function drenched_bluff.Init(zone)
  PrintInfo("=>> Init_drenched_bluff")
end

function drenched_bluff.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_drenched_bluff seg=" .. tostring(segmentID))
end

function drenched_bluff.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_drenched_bluff result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function drenched_bluff.Rescued(zone, name, mail)
end

return drenched_bluff
