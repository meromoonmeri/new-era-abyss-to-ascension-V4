--[[ dark_crater — donjon Sky segment 1 (d41p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 67 LABEL_D067_CLEAR ; s22p0901.ssb -> EnterDungeon(68)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local dark_crater = {}

function dark_crater.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'dark_crater'
end

function dark_crater.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function dark_crater.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function dark_crater.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return dark_crater
