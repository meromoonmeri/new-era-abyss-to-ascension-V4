-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Bois Sinistre (gloomy_forest) — chapitre 6.
     Zone reconstruite par tools/dungeon_builder : 3 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}

local LAST_SEGMENT = 2

local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then return 1 end
  return idx
end

local function ZONE_GROUND_IDX(zone, name)
  for ii = 0, zone.GroundMaps.Count - 1 do
    if zone.GroundMaps[ii] == name then return ii end
  end
  PrintInfo('[gloomy_forest] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'metano_town'

function gloomy_forest.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function gloomy_forest.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  if COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID) then return end
  SV.adventure.Thief = false
  SV.CanonicalDungeons = SV.CanonicalDungeons or {}

  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
    return
  end

  if segmentID == 0 then
    -- relais interne du donjon (station de mi-parcours) puis retour au segment suivant
    SV.CanonicalDungeons.Pending = 'gloomy_forest_seg0'
    GAME:EnterGroundMap('gloomy_forest_midpoint', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    -- cinématique du gardien puis retour dans le donjon pour le combat : cinématique et combat au même endroit, aucune arène séparée
    SV.CanonicalDungeons.Pending = 'gloomy_forest_seg1'
    GAME:EnterGroundMap('sinister_woods_clearing', 'Main_Entrance_Marker')
  elseif segmentID == 2 then
    -- étage d'arène franchi : fin de run sur place, la scène a déjà été jouée
    SV.CanonicalDungeons['gloomy_forest'] = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return gloomy_forest
