--[[ barren_valley — donjon Sky segment 1 (d46p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 133 ; n08a0608.ssb -> EnterDungeon(134)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local barren_valley = {}

function barren_valley.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'barren_valley'
end

function barren_valley.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function barren_valley.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function barren_valley.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return barren_valley
