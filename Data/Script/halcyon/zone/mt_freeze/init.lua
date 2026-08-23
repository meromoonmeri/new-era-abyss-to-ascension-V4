-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Mont Gelé (mt_freeze) — chapitre 11.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_freeze = {}

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
  PrintInfo('[mt_freeze] Ground absent de la zone : ' .. tostring(name))
  return 0
end

local RETURN_GROUND = 'mont_gele_pied'

function mt_freeze.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_freeze'
end

function mt_freeze.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function mt_freeze.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_freeze.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    SV.CanonicalDungeons.Pending = 'mt_freeze_seg0'
    GAME:EnterGroundMap('mt_freeze_midpoint', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    -- scène canonique de transition vers mt_freeze_peak
    SV.CanonicalDungeons.Pending = 'mt_freeze_seg1'
    GAME:EnterGroundMap('d11p02', 'Main_Entrance_Marker')
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return mt_freeze
