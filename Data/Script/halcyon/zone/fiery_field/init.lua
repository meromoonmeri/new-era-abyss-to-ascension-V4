-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Plaine Ardent (fiery_field) — chapitre 18.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local fiery_field = {}

local LAST_SEGMENT = 1

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
  PrintInfo('[fiery_field] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'metano_town'

function fiery_field.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'fiery_field'
end

function fiery_field.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function fiery_field.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function fiery_field.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- cinématique du gardien puis retour dans le donjon pour le combat : cinématique et combat au même endroit, aucune arène séparée
    SV.CanonicalDungeons.Pending = 'fiery_field_seg0'
    -- champ_braises ne porte aucun marqueur : la scène téléporte
    -- elle-même le joueur, on entre donc par index.
    GAME:EnterGroundMap(ZONE_GROUND_IDX(zone, 'champ_braises'), 0)
  elseif segmentID == 1 then
    -- étage d'arène franchi : fin de run sur place, la scène a déjà été jouée
    SV.CanonicalDungeons['fiery_field'] = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return fiery_field
