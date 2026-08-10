--[[
    init.lua — Zone temporal_tower (Temporal Tower)
]]
require 'origin.common'

local temporal_tower = {}

function temporal_tower.Init(zone)
  PrintInfo("=>> Init_temporal_tower")
end

function temporal_tower.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_temporal_tower seg=" .. tostring(segmentID))
end

function temporal_tower.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_temporal_tower result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function temporal_tower.Rescued(zone, name, mail)
end

return temporal_tower
