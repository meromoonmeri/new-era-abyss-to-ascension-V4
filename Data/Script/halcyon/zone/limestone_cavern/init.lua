--[[ limestone_cavern — donjon Sky segment 1 (d56p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 155 ; n06a3201.ssb -> EnterDungeon(156)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local limestone_cavern = {}

function limestone_cavern.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'limestone_cavern'
end

function limestone_cavern.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function limestone_cavern.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function limestone_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return limestone_cavern
