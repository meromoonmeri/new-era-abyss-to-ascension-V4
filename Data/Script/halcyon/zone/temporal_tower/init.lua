--[[ temporal_tower — donjon Sky segment 1 (d30p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 41 LABEL_D041_CLEAR ; m25a0901.ssb -> EnterDungeon(42)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local temporal_tower = {}

function temporal_tower.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'temporal_tower'
end

function temporal_tower.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function temporal_tower.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function temporal_tower.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return temporal_tower
