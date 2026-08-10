--[[
    init.lua — Zone mt_thunder (Mt. Thunder)
]]
require 'origin.common'

local mt_thunder = {}

function mt_thunder.Init(zone)
  PrintInfo("=>> Init_mt_thunder")
end

function mt_thunder.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_mt_thunder seg=" .. tostring(segmentID))
end

function mt_thunder.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_mt_thunder result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function mt_thunder.Rescued(zone, name, mail)
end

return mt_thunder
