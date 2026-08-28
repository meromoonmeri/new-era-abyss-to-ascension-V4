--[[ amp_plains — donjon Sky segment 1 (d12p21a = aire de repos canonique).
     Câblage ROM : unionall GETOUT (GETOUT case 17 LABEL_D017_CLEAR ; m12a0501.ssb -> EnterDungeon(18)).
     Généré par dev/tools/wire_sky_rest_areas.py — délègue tout au module
     générique SkyRestAreas (aucun hardcode par-donjon ici). ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local amp_plains = {}

function amp_plains.Init(zone)
  SV.TemporaryFlags.LastDungeonEntered = 'amp_plains'
end

function amp_plains.EnterSegment(zone, rescuing, segmentID, mapID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function amp_plains.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function amp_plains.ExitSegment(zone, result, rescue, segmentID, mapID)
  SkyRestAreas.HandleDungeonExit(zone, result, rescue, segmentID, mapID)
end

return amp_plains
