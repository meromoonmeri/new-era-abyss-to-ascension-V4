--[[
    init.lua — Zone sinister_woods (Sinister Woods)
]]
require 'origin.common'

local sinister_woods = {}

function sinister_woods.Init(zone)
  PrintInfo("=>> Init_sinister_woods")
end

function sinister_woods.EnterSegment(zone, rescuing, segmentID, mapID)
  PrintInfo("=>> EnterSegment_sinister_woods seg=" .. tostring(segmentID))
end

function sinister_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_sinister_woods result=" .. tostring(result) .. " seg=" .. tostring(segmentID))
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
  else
    GAME:EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
  end
end

function sinister_woods.Rescued(zone, name, mail)
end

return sinister_woods
