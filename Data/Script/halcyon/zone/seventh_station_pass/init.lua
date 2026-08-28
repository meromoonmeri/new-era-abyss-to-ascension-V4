--[[ seventh_station_pass — donjon Sky segment 1 (d73p27a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 117 ; enter01.ssb -> 118).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local seventh_station_pass = {}

function seventh_station_pass.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'seventh_station_pass'
end

function seventh_station_pass.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function seventh_station_pass.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function seventh_station_pass.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return seventh_station_pass
