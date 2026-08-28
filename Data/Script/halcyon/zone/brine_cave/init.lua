--[[ brine_cave — donjon Sky segment 1 (d26p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 35 LABEL_D035_CLEAR ; m23a0402.ssb -> EnterDungeon(36)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local brine_cave = {}

function brine_cave.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'brine_cave'
end

function brine_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function brine_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function brine_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return brine_cave
