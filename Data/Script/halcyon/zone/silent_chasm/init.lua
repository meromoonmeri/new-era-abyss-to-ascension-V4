-- [dungeon_builder] script de zone canonique généré — ne pas éditer à la main.
--[[ Gouffre Muet (silent_chasm) — chapitre 8.
     Zone reconstruite par tools/dungeon_builder : 1 segment(s).
     Règle verrouillée : Ground de cinématique = Ground du combat = Ground final
     canonique. Aucune arène séparée, aucune téléportation vers un décor inventé.
     Regénérer avec : python3 tools/dungeon_builder.py wire-scenes --apply ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local silent_chasm = {}

local LAST_SEGMENT = 0

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

local RETURN_GROUND = 'gouffre_muet_bord'

function silent_chasm.Init(zone)
  DEBUG.EnableDbgCoro()
  SV.TemporaryFlags.LastDungeonEntered = 'silent_chasm'
end

function silent_chasm.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
  GAME:SetRescueAllowed(segmentID < LAST_SEGMENT)
end

function silent_chasm.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function silent_chasm.ExitSegment(zone, result, rescue, segmentID, mapID)
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
    -- Ground final canonique : cinématique, combat et fin au même endroit
    SV.CanonicalDungeons.Pending = 'silent_chasm_seg0'
    GAME:EnterGroundMap('d05p02', 'Main_Entrance_Marker')
  else
    GeneralFunctions.EndDungeonRun(result, 'master_zone', -1, GROUND_IDX(RETURN_GROUND), 0, true, true)
  end
end

return silent_chasm
