-- Shared lifecycle and route adapter for authenticated PMD Red early dungeons.
-- Dungeon-specific zone scripts supply only IDs, completion tokens, and route
-- endpoints.  Mission exits and failed runs stay centralized here.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local RedEarlyDungeonRoute = {}

function RedEarlyDungeonRoute.Init(zone, dungeon_id)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags = SV.TemporaryFlags or {}
  SV.TemporaryFlags.LastDungeonEntered = dungeon_id
end

function RedEarlyDungeonRoute.EnterSegment(zone, rescuing, segment_id, map_id, rescue_allowed)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segment_id, map_id)
  end
  GAME:SetRescueAllowed(rescue_allowed == true)
end

function RedEarlyDungeonRoute.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function RedEarlyDungeonRoute.ExitSegment(zone, result, rescue, segment_id, config)
  assert(config ~= nil and config.pending ~= nil and config.ending_ground ~= nil
    and config.ending_map ~= nil,
    'Configuration de sortie PMD Red incomplète')
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segment_id) then
    return
  end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    SV.CanonicalDungeons.Pending = config.pending
    -- A dungeon clear must terminate the adventure before loading its Ground.
    -- Numeric Ground entries also support exact direct-ROM Grounds that have no
    -- invented marker entities; their adapter relocates the player during Init.
    GeneralFunctions.EndDungeonRun(
      result,
      zone.ID,
      -1,
      config.ending_map,
      config.ending_entry or 0,
      config.completion_display == true,
      config.completion_fanfare == true)
  else
    GeneralFunctions.EndDungeonRun(
      result,
      config.failure_zone or 'master_zone',
      config.failure_segment or -1,
      config.failure_map or 1,
      config.failure_entry or 0,
      config.failure_display ~= false,
      config.failure_fanfare ~= false)
  end
end

return RedEarlyDungeonRoute
