-- Mt. Freeze canonique : 15F -> D11P02 -> Peak 5F -> D11P03/Ninetales.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local mt_freeze = {}

-- Index du ground par NOM dans la zone courante (mt_freeze.json GroundMaps).
local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("mt_freeze")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[mt_freeze] ground introuvable : " .. tostring(name))
    return 1
  end
  return idx
end

function mt_freeze.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='mt_freeze' end
function mt_freeze.EnterSegment(zone,rescuing,segmentID,mapID)
  if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
  GAME:SetRescueAllowed(true)
end
function mt_freeze.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function mt_freeze.ExitSegment(zone,result,rescue,segmentID,mapID)
  if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
  SV.adventure.Thief=false; SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- KO / abandon au-dela du point median (segment 1+) : reveil au relais.
    if segmentID >= 1 then
      SV.MtFreeze = SV.MtFreeze or {}
      SV.MtFreeze.DiedPastCheckpoint = true
      GeneralFunctions.EndDungeonRun(result,'mt_freeze',-1,GROUND_IDX('mt_freeze_midpoint'),0,true,true)
    else
      GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
    end
    return
  end
  if segmentID==0 then
    SV.CanonicalDungeons.Pending='mt_freeze_mid'; GAME:EnterGroundMap('mt_freeze_midpoint','Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.Pending='mt_freeze_summit'; GAME:EnterGroundMap('d11p03','Main_Entrance_Marker')
  end
end
return mt_freeze
