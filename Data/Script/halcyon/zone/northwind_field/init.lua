-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Champ du Vent du Nord (northwind_field) — chapitre 19.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local northwind_field = {}

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

local RETURN_GROUND = 'metano_town'

function northwind_field.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'northwind_field'
end

function northwind_field.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function northwind_field.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function northwind_field.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    SV.CanonicalDungeons.Pending = 'northwind_field_seg0'
    GAME:EnterGroundMap('champ_vent_boreal', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    -- étage d'arène franchi : fin de run sur place, la scène a déjà été jouée
    SV.CanonicalDungeons['northwind_field'] = true
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return northwind_field
