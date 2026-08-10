--[[
    init.lua — Zone mt_steel (Mt. Steel)
]]
require 'origin.common'

local mt_steel = {}

function mt_steel.Init(zone)
  PrintInfo("=>> Init_mt_steel")
end

function mt_steel.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_mt_steel seg=" .. tostring(segmentID))
end

function mt_steel.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_mt_steel result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function mt_steel.Rescued(zone, name, mail)
end

return mt_steel
