--[[ Île des Longues Cendres — Donjon-Ancrage (Livre II, ch14). Vague 3.
     Segment 5 = arene de revanche (moltres). LegendZones key: long_ash_isle ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local ile_lave_flottante = {}

function ile_lave_flottante.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_ile_lave_flottante")
  SV.TemporaryFlags.LastDungeonEntered = 'ile_lave_flottante'
end

function ile_lave_flottante.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function ile_lave_flottante.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function ile_lave_flottante.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_ile_lave_flottante result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 5 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('long_ash')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['long_ash'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return ile_lave_flottante
