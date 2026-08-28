--[[ steam_cave — donjon Sky segment 1 (d10p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 14 LABEL_D014_CLEAR ; m10a0601/m10a0701.ssb -> EnterDungeon(15)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local steam_cave = {}

function steam_cave.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'steam_cave'
end

function steam_cave.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function steam_cave.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function steam_cave.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return steam_cave
