--[[
    init.lua — Zone mt_freeze (Mt. Freeze)
]]
require 'origin.common'

local mt_freeze = {}

function mt_freeze.Init(zone)
  PrintInfo("=>> Init_mt_freeze")
end

function mt_freeze.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_mt_freeze seg=" .. tostring(segmentID))
end

function mt_freeze.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_mt_freeze result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function mt_freeze.Rescued(zone, name, mail)
end

return mt_freeze
