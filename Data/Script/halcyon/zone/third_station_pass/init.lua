--[[ third_station_pass — donjon Sky segment 1 (d73p23a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 113 ; enter01.ssb -> 114).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local third_station_pass = {}

function third_station_pass.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'third_station_pass'
end

function third_station_pass.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function third_station_pass.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function third_station_pass.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return third_station_pass
