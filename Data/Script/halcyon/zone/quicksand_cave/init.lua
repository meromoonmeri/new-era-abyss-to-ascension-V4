--[[ quicksand_cave — donjon Sky segment 1 (d15p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 21 LABEL_D021_CLEAR ; m14a0501.ssb -> EnterDungeon(22)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local quicksand_cave = {}

function quicksand_cave.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'quicksand_cave'
end

function quicksand_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function quicksand_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function quicksand_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return quicksand_cave
