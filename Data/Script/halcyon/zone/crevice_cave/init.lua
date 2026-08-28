--[[ crevice_cave — donjon Sky segment 1 (d79p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 47 LABEL_D047_CLEAR ; scripts -> EnterDungeon(48)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local crevice_cave = {}

function crevice_cave.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'crevice_cave'
end

function crevice_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function crevice_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function crevice_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return crevice_cave
