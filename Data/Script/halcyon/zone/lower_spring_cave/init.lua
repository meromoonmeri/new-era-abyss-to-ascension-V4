--[[ lower_spring_cave — donjon Sky segment 1 (d57p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 162 ; n04a1701/n04a1901.ssb -> EnterDungeon(163)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local lower_spring_cave = {}

function lower_spring_cave.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'lower_spring_cave'
end

function lower_spring_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function lower_spring_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function lower_spring_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return lower_spring_cave
