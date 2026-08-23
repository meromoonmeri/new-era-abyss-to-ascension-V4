-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Mont Grondant (mt_thunder) — chapitre 9.
     Zone reconstruite par tools/dungeon_builder : 2 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local mt_thunder = {}

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

local RETURN_GROUND = 'mont_grondant_pied'

function mt_thunder.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'mt_thunder'
end

function mt_thunder.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function mt_thunder.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function mt_thunder.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    SV.CanonicalDungeons.Pending = 'mt_thunder_seg0'
    GAME:EnterGroundMap('mt_thunder_midpoint', 'Main_Entrance_Marker')
  elseif segmentID == 1 then
    -- scène canonique de transition vers mt_thunder_peak
    SV.CanonicalDungeons.Pending = 'mt_thunder_seg1'
    GAME:EnterGroundMap('d06p02', 'Main_Entrance_Marker')
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return mt_thunder
