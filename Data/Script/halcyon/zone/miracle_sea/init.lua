--[[ miracle_sea — donjon Sky segment 1 (d35p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 51 LABEL_D051_CLEAR ; -> EnterDungeon(52)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local miracle_sea = {}

function miracle_sea.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'miracle_sea'
end

function miracle_sea.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function miracle_sea.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function miracle_sea.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return miracle_sea
