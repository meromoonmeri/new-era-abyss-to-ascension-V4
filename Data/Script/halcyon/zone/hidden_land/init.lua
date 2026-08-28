--[[ hidden_land — donjon Sky segment 1 (d28p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 38 LABEL_D038_CLEAR ; m24a0601.ssb -> EnterDungeon(39)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local hidden_land = {}

function hidden_land.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'hidden_land'
end

function hidden_land.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function hidden_land.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function hidden_land.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return hidden_land
