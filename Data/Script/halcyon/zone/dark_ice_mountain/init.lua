--[[ dark_ice_mountain — donjon Sky segment 1 (d51p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 142 ; n09a0301.ssb -> EnterDungeon(143)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local dark_ice_mountain = {}

function dark_ice_mountain.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'dark_ice_mountain'
end

function dark_ice_mountain.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function dark_ice_mountain.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function dark_ice_mountain.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return dark_ice_mountain
