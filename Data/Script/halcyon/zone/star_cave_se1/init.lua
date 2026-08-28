--[[ star_cave_se1 — donjon Sky segment 1 (d42p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 123 ; n01a1601.ssb -> EnterDungeon(124 DEEP_STAR_CAVE)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local star_cave_se1 = {}

function star_cave_se1.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'star_cave_se1'
end

function star_cave_se1.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function star_cave_se1.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function star_cave_se1.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return star_cave_se1
