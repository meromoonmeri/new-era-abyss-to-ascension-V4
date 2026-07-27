--[[ Cloche des Orages — Donjon-Ancrage (Livre II, ch16). Vague 3.
     Segment 5 = arene de revanche (raikou). LegendZones key: storm_bell_ridge ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local crete_voilee = {}

function crete_voilee.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crete_voilee")
  SV.TemporaryFlags.LastDungeonEntered = 'crete_voilee'
end

function crete_voilee.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function crete_voilee.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function crete_voilee.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_crete_voilee result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end
  if segmentID == 6 then
    -- Annexe de la Toupie (etage mystere) : sortie douce.
    GAME:WaitFrames(10)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
    return
  end

  if segmentID == 4 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('arene_hautes_plaines', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 5 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('storm_bell')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['storm_bell'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return crete_voilee
