-- Canonical Sinister Woods (Chapter 6): compact, re-generated PMD Red route.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}

function gloomy_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  -- Rescue Team allows rescues in the exploration, never in the fixed boss room.
  GAME:SetRescueAllowed(segmentID < 2)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function gloomy_forest.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

local function return_to_town(result)
  GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}

  if segmentID == 0 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      SV.CanonicalDungeons.SinisterWoodsCheckpoint = true
      GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')
    else
      return_to_town(result)
    end
    return
  end

  if segmentID == 1 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      GAME:EnterGroundMap('sinister_woods_boss', 'Main_Entrance_Marker')
    elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then
      GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')
    else
      SV.CanonicalDungeons.SinisterWoodsBossFailed = true
      GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')
    end
    return
  end

  -- Segment 2 is the fixed 13F Team Meanies battle.
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    SV.CanonicalDungeons.SinisterWoodsCleared = true
    SV.CanonicalDungeons.SinisterWoodsBossFailed = false
    return_to_town(result)
  elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then
    GAME:EnterGroundMap('sinister_woods_entrance', 'Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.SinisterWoodsBossFailed = true
    GAME:EnterGroundMap('sinister_woods_mid', 'Main_Entrance_Marker')
  end
end

return gloomy_forest
