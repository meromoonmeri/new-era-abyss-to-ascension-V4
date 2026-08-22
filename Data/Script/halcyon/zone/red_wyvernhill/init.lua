require 'origin.common'
require 'halcyon.GeneralFunctions'
local red_wyvernhill = {}
function red_wyvernhill.Init(data)
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = 'red_wyvernhill'
end
function red_wyvernhill.EnterSegment(data, rescuing, segmentID, mapID)
  GAME:SetRescueAllowed(segmentID < 3)
  if rescuing ~= true then COMMON.BeginDungeon(data.ID, segmentID, mapID) end
end
function red_wyvernhill.Rescued(data, name, mail) COMMON.Rescued(data, name, mail) end
function red_wyvernhill.ExitSegment(data, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, data.ID, segmentID) then return end
  SV.adventure.Thief = false
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if segmentID > 0 then GAME:EnterGroundMap('red_wyvernhill_mid', 'Main_Entrance_Marker')
    else GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true) end
    return
  end
  if segmentID == 0 then
    GAME:EnterGroundMap('red_wyvernhill_mid', 'Main_Entrance_Marker')
    return
  end
  if segmentID < 2 then
    GAME:ContinueDungeon('red_wyvernhill', segmentID + 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 2 then
    GAME:EnterGroundMap('red_wyvernhill_boss', 'Main_Entrance_Marker')
    return
  end
  -- Any segment after the final exploration segment is the fixed boss map.
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end
return red_wyvernhill
