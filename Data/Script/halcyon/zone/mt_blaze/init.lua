--[[
    init.lua — Zone mt_blaze (Mt. Blaze)
]]
require 'origin.common'

local mt_blaze = {}

function mt_blaze.Init(zone)
  PrintInfo("=>> Init_mt_blaze")
end

function mt_blaze.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_mt_blaze seg=" .. tostring(segmentID))
end

function mt_blaze.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_mt_blaze result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function mt_blaze.Rescued(zone, name, mail)
end

return mt_blaze
