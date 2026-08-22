require 'origin.common'
require 'halcyon.GeneralFunctions'
local destiny_tower = {}
function destiny_tower.Init(data)
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = 'destiny_tower'
end
function destiny_tower.EnterSegment(data, rescuing, segmentID, mapID)
  GAME:SetRescueAllowed(segmentID < 10)
  if rescuing ~= true then COMMON.BeginDungeon(data.ID, segmentID, mapID) end
end
function destiny_tower.Rescued(data, name, mail) COMMON.Rescued(data, name, mail) end
function destiny_tower.ExitSegment(data, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, data.ID, segmentID) then return end
  SV.adventure.Thief = false
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if segmentID > 0 then GAME:EnterGroundMap('destiny_tower_mid', 'Main_Entrance_Marker')
    else GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true) end
    return
  end
  if segmentID == 0 then
    GAME:EnterGroundMap('destiny_tower_mid', 'Main_Entrance_Marker')
    return
  end
  if segmentID < 9 then
    GAME:ContinueDungeon('destiny_tower', segmentID + 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 9 then
    GAME:EnterGroundMap('destiny_tower_boss', 'Main_Entrance_Marker')
    return
  end
  -- Any segment after the final exploration segment is the fixed boss map.
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end
return destiny_tower
