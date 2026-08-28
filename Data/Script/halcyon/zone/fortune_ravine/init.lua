--[[ fortune_ravine — donjon Sky segment 1 (d45p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 130 ; n03a1301.ssb -> EnterDungeon(131)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local fortune_ravine = {}

function fortune_ravine.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'fortune_ravine'
end

function fortune_ravine.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function fortune_ravine.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function fortune_ravine.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return fortune_ravine
