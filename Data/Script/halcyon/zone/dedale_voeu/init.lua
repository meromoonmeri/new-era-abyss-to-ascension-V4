--[[ Vœux Tus — Donjon-Ancrage (Livre II, ch31). Vague 3.
     Segment 1 = arene de revanche (jirachi). LegendZones key: unsaid_wishes_maze ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.LegendZones'

local dedale_voeu = {}

function dedale_voeu.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dedale_voeu")
  SV.TemporaryFlags.LastDungeonEntered = 'dedale_voeu'
end

function dedale_voeu.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function dedale_voeu.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function dedale_voeu.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> ExitSegment_dedale_voeu result "..tostring(result).." segment "..tostring(segmentID))

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end

  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- Cinematique du gardien avant l'arene (vague 7).
    GAME:EnterGroundMap('sanctuaire_voeu', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 1 then
    -- Arene de l'Ancrage : victoire = gardien stabilise (revanche/recrutement via Grodoudou).
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      LegendZones.SetDefeated('unsaid_wishes')
      if SV.Anchors == nil then SV.Anchors = { Stabilized = {} } end
      if SV.Anchors.Stabilized == nil then SV.Anchors.Stabilized = {} end
      SV.Anchors.Stabilized['unsaid_wishes'] = true
    end
    GAME:WaitFrames(20)
    GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
    return
  end

  -- Donjon secondaire : dans tous les cas on rentre a Metano Town (carte 1).
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return dedale_voeu
