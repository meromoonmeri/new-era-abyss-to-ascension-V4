--[[
    init.lua — Zone sky_tower (Sky Tower)
]]
require 'origin.common'

local sky_tower = {}

function sky_tower.Init(zone)
  PrintInfo("=>> Init_sky_tower")
end

function sky_tower.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_sky_tower seg=" .. tostring(segmentID))
end

function sky_tower.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_sky_tower result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function sky_tower.Rescued(zone, name, mail)
end

return sky_tower
