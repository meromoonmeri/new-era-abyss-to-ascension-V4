-- Generated Smart Dungeon segment/relay router.
-- Requires promotion of the generated Ground candidates and their scripts.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sanctuaire_des_echos = {}
local RELAY_AFTER_SEGMENT = {
  [0] = 'sanctuaire_des_echos_relais_01',
  [1] = 'sanctuaire_des_echos_relais_02',
}

function sanctuaire_des_echos.Init(zone) end

function sanctuaire_des_echos.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
end

function sanctuaire_des_echos.ExitSegment(zone, result, rescue, segmentID, mapID)
  local relay = RELAY_AFTER_SEGMENT[segmentID]
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared and relay ~= nil then
    GAME:EnterGroundMap(relay, 'Main_Entrance_Marker')
    return
  end
  -- Final completion/failure policy remains an explicit integration hook;
  -- no narrative destination is invented by the designer.
end

function sanctuaire_des_echos.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

return sanctuaire_des_echos
