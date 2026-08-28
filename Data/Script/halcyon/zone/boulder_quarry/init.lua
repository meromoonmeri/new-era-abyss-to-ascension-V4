--[[ boulder_quarry — donjon Sky segment 1 (d55p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 150 ; n06a1101.ssb -> EnterDungeon(151)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local boulder_quarry = {}

function boulder_quarry.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'boulder_quarry'
end

function boulder_quarry.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function boulder_quarry.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function boulder_quarry.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return boulder_quarry
