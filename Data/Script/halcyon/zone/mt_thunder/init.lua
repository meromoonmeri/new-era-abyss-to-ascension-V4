-- Mt. Thunder canonical PMD Red route: 10F -> d06p02 -> Peak -> d06p03/Zapdos.
require 'origin.common'
require 'halcyon.GeneralFunctions'
local mt_thunder={}
function mt_thunder.Init(zone) DEBUG.EnableDbgCoro(); SV.TemporaryFlags.LastDungeonEntered='mt_thunder' end
function mt_thunder.EnterSegment(zone,rescuing,segmentID,mapID)
  if rescuing~=true then COMMON.BeginDungeon(zone.ID,segmentID,mapID) end
  GAME:SetRescueAllowed(segmentID<3)
end
function mt_thunder.Rescued(zone,name,mail) COMMON.Rescued(zone,name,mail) end
function mt_thunder.ExitSegment(zone,result,rescue,segmentID,mapID)
  if COMMON.ExitDungeonMissionCheck(result,rescue,zone.ID,segmentID) then return end
  SV.adventure.Thief=false; SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  if result~=RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true); return
  end
  if segmentID==0 then
    SV.CanonicalDungeons.Pending='mt_thunder_mid'; GAME:EnterGroundMap('d06p02','Main_Entrance_Marker')
  elseif segmentID==2 then
    SV.CanonicalDungeons.Pending='mt_thunder_zapdos'; GAME:EnterGroundMap('d06p03','Main_Entrance_Marker')
  elseif segmentID==3 then
    SV.CanonicalDungeons.MtThunderCleared=true
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
  else
    GeneralFunctions.EndDungeonRun(result,'master_zone',-1,1,0,true,true)
  end
end
return mt_thunder
