--[[ temporal_tower_se5 — donjon Sky segment 1 (d48p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 137 ; n08a1808.ssb -> EnterDungeon(138)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local temporal_tower_se5 = {}

function temporal_tower_se5.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'temporal_tower_se5'
end

function temporal_tower_se5.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function temporal_tower_se5.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function temporal_tower_se5.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return temporal_tower_se5
