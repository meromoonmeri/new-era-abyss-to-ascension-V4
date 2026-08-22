require 'origin.common'
require 'halcyon.GeneralFunctions'
local red_tinywoods = {}
function red_tinywoods.Init(data)
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = 'red_tinywoods'
end
function red_tinywoods.EnterSegment(data, rescuing, segmentID, mapID)
  GAME:SetRescueAllowed(segmentID < 2)
  if rescuing ~= true then COMMON.BeginDungeon(data.ID, segmentID, mapID) end
end
function red_tinywoods.Rescued(data, name, mail) COMMON.Rescued(data, name, mail) end
function red_tinywoods.ExitSegment(data, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, data.ID, segmentID) then return end
  SV.adventure.Thief = false
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if segmentID > 0 then GAME:EnterGroundMap('red_tinywoods_mid', 'Main_Entrance_Marker')
    else GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true) end
    return
  end
  if segmentID == 0 then
    GAME:EnterGroundMap('red_tinywoods_mid', 'Main_Entrance_Marker')
    return
  end
  if segmentID < 1 then
    GAME:ContinueDungeon('red_tinywoods', segmentID + 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 1 then
    GAME:EnterGroundMap('red_tinywoods_boss', 'Main_Entrance_Marker')
    return
  end
  -- Any segment after the final exploration segment is the fixed boss map.
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end
return red_tinywoods
