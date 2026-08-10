--[[
    init.lua — Zone mt_bristle (Mt. Bristle)
]]
require 'origin.common'

local mt_bristle = {}

function mt_bristle.Init(zone)
  PrintInfo("=>> Init_mt_bristle")
end

function mt_bristle.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_mt_bristle seg=" .. tostring(segmentID))
end

function mt_bristle.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_mt_bristle result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function mt_bristle.Rescued(zone, name, mail)
end

return mt_bristle
