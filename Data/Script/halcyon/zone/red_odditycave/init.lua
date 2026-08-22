require 'origin.common'
require 'halcyon.GeneralFunctions'
local red_odditycave = {}
function red_odditycave.Init(data)
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = 'red_odditycave'
end
function red_odditycave.EnterSegment(data, rescuing, segmentID, mapID)
  GAME:SetRescueAllowed(segmentID < 2)
  if rescuing ~= true then COMMON.BeginDungeon(data.ID, segmentID, mapID) end
end
function red_odditycave.Rescued(data, name, mail) COMMON.Rescued(data, name, mail) end
function red_odditycave.ExitSegment(data, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, data.ID, segmentID) then return end
  SV.adventure.Thief = false
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    if segmentID > 0 then GAME:EnterGroundMap('red_odditycave_mid', 'Main_Entrance_Marker')
    else GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true) end
    return
  end
  if segmentID == 0 then
    GAME:EnterGroundMap('red_odditycave_mid', 'Main_Entrance_Marker')
    return
  end
  if segmentID < 1 then
    GAME:ContinueDungeon('red_odditycave', segmentID + 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end
  if segmentID == 1 then
    GAME:EnterGroundMap('red_odditycave_boss', 'Main_Entrance_Marker')
    return
  end
  -- Any segment after the final exploration segment is the fixed boss map.
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end
return red_odditycave
