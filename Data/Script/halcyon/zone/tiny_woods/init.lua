--[[
    init.lua — Zone tiny_woods (Tiny Woods)
]]
require 'origin.common'

local tiny_woods = {}

function tiny_woods.Init(zone)
  PrintInfo("=>> Init_tiny_woods")
end

function tiny_woods.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_tiny_woods seg=" .. tostring(segmentID))
end

function tiny_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_tiny_woods result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function tiny_woods.Rescued(zone, name, mail)
end

return tiny_woods
