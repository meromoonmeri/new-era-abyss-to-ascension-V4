--[[ fourth_station_pass — donjon Sky segment 1 (d73p24a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 114 ; enter01.ssb -> 115).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local fourth_station_pass = {}

function fourth_station_pass.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'fourth_station_pass'
end

function fourth_station_pass.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function fourth_station_pass.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function fourth_station_pass.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return fourth_station_pass
