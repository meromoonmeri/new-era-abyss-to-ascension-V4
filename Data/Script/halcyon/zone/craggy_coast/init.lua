--[[
    init.lua — Zone craggy_coast (Craggy Coast)
]]
require 'origin.common'

local craggy_coast = {}

function craggy_coast.Init(zone)
  PrintInfo("=>> Init_craggy_coast")
end

function craggy_coast.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_craggy_coast seg=" .. tostring(segmentID))
end

function craggy_coast.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_craggy_coast result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function craggy_coast.Rescued(zone, name, mail)
end

return craggy_coast
