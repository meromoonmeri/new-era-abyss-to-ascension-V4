-- Mt. Blaze canonique PMD Red : 12F -> D09P02 -> Peak 3F -> D09P03/Moltres.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_blaze = {}

-- Index du ground par NOM dans la zone courante (mt_blaze.json GroundMaps).
local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mt_blaze")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[mt_blaze] ground introuvable : " .. tostring(name))
    return 1
  end
  return idx
end


function mt_blaze.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_blaze'
end

function mt_blaze.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
  GAME:SetRescueAllowed(segmentID < 2)
end

function mt_blaze.Rescued(zone, name, mail) COMMON.Rescued(zone, name, mail) end

function mt_blaze.ExitSegment(zone, result, rescue, segmentID, mapID)
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  if exited then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- KO / abandon au-dela du point median (segment 1+) : reveil au relais.
    if segmentID >= 1 then
      SV.MtBlaze = SV.MtBlaze or {}
      SV.MtBlaze.DiedPastCheckpoint = true
      GeneralFunctions.EndDungeonRun(result, 'mt_blaze', -1, GROUND_IDX('mt_blaze_midpoint'), 0, true, true)
    else
      GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
    end
    return
  end
  if segmentID == 0 then
    SV.CanonicalDungeons.Pending = 'mt_blaze_mid'
    GAME:EnterGroundMap('mt_blaze_midpoint', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    SV.CanonicalDungeons.Pending = 'mt_blaze_summit'
    GAME:EnterGroundMap('d09p03', 'Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.MtBlazeCleared = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, 1, 0, true, true)
  end
end

return mt_blaze
