-- Frosty Forest canonique : 9F -> D10P02 -> Grotto 5F -> D10P03/Articuno.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local frosty_forest = {}

-- Index du ground par NOM dans la zone courante (frosty_forest.json GroundMaps).
local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("frosty_forest")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[frosty_forest] ground introuvable : " .. tostring(name))
    return 1 -- repli metano_town
  end
  return idx
end

function frosty_forest.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='frosty_forest' end
function frosty_forest.EnterSegment(zone,rescuing,segmentID,mapID)
  if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
  GAME:SetRescueAllowed(segmentID<2)
end
function frosty_forest.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function frosty_forest.ExitSegment(zone,result,rescue,segmentID,mapID)
  if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
  SV.adventure.Thief=false; SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- KO / abandon au-dela du point median (segment 1+) : reveil au relais.
    if segmentID >= 1 then
      SV.FrostyForest = SV.FrostyForest or {}
      SV.FrostyForest.DiedPastCheckpoint = true
      GeneralFunctions.EndDungeonRun(result,'frosty_forest',-1,GROUND_IDX('frosty_forest_midpoint'),0,true,true)
    else
      GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
    end
    return
  end
  if segmentID==0 then
    SV.CanonicalDungeons.Pending='frosty_forest_mid'; GAME:EnterGroundMap('frosty_forest_midpoint','Main_Entrance_Marker')
  elseif segmentID==1 then
    SV.CanonicalDungeons.Pending='frosty_forest_summit'; GAME:EnterGroundMap('d10p03','Main_Entrance_Marker')
  else
    SV.CanonicalDungeons.FrostyForestCleared=true
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
  end
end
return frosty_forest
