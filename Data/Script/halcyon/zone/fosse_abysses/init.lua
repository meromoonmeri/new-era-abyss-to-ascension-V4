--[[ Chœur Englouti — Donjon-Ancrage (Livre II, ch19). Vague 3.
     Segment 1 = arene de revanche (lugia). LegendZones key: sunken_choir_deep ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local fosse_abysses = {}

function fosse_abysses.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_fosse_abysses")
  SV.TemporaryFlags.LastDungeonEntered = 'fosse_abysses'
end

function fosse_abysses.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function fosse_abysses.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function fosse_abysses.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_fosse_abysses result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 1 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('sunken_choir')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['sunken_choir'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return fosse_abysses
