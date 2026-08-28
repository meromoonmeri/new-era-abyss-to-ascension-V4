--[[ spacial_rift — donjon Sky segment 1 (d39p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 64 LABEL_D064_CLEAR ; s21p0901.ssb -> EnterDungeon(65)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local spacial_rift = {}

function spacial_rift.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'spacial_rift'
end

function spacial_rift.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function spacial_rift.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function spacial_rift.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return spacial_rift
