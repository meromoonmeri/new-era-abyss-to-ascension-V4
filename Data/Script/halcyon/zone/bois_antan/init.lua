--[[ Heures Mortes — Donjon-Ancrage (Livre II, ch20). Vague 3.
     Segment 3 = arene de revanche (celebi). LegendZones key: dead_hours_grove ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local bois_antan = {}

function bois_antan.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bois_antan")
  SV.TemporaryFlags.LastDungeonEntered = 'bois_antan'
end

function bois_antan.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function bois_antan.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function bois_antan.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_bois_antan result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 3 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('dead_hours')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['dead_hours'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return bois_antan
