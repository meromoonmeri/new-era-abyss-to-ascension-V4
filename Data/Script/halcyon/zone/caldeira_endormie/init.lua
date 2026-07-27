--[[ Trône de Magma — Donjon-Ancrage (Livre II, ch11). Vague 3.
     Segment 1 = arene de revanche (groudon). LegendZones key: molten_throne ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local caldeira_endormie = {}

function caldeira_endormie.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_caldeira_endormie")
  SV.TemporaryFlags.LastDungeonEntered = 'caldeira_endormie'
end

function caldeira_endormie.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function caldeira_endormie.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function caldeira_endormie.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_caldeira_endormie result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 1 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('molten_throne')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['molten_throne'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return caldeira_endormie
