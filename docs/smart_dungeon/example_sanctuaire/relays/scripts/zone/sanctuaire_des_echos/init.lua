-- Generated Smart Dungeon complete journey router.
require 'origin.common'
require 'halcyon.GeneralFunctions'

local sanctuaire_des_echos = {}
local RELAY_AFTER_SEGMENT = {
  [0] = 'sanctuaire_des_echos_relais_01',
  [1] = 'sanctuaire_des_echos_relais_02',
}

function sanctuaire_des_echos.Init(zone)
  SV.smart_dungeon = SV.smart_dungeon or {}
  SV.smart_dungeon['sanctuaire_des_echos'] = SV.smart_dungeon['sanctuaire_des_echos'] or {seen=false, won=false, lost=false, completed=false}
end

function sanctuaire_des_echos.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
end

function sanctuaire_des_echos.ExitSegment(zone, result, rescue, segmentID, mapID)
  local relay = RELAY_AFTER_SEGMENT[segmentID]
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared and relay ~= nil then
    GAME:EnterGroundMap(relay, 'Main_Entrance_Marker')
    return
  end
  if segmentID == 2 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EnterGroundMap('sanctuaire_des_echos_arene_finale', 'Main_Entrance_Marker')
    return
  end
  if segmentID == 3 then
    if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
      SV.smart_dungeon['sanctuaire_des_echos'].won = true
    else
      SV.smart_dungeon['sanctuaire_des_echos'].lost = true
    end
    GAME:EnterGroundMap('sanctuaire_des_echos_arene_finale', 'Main_Entrance_Marker')
    return
  end
end

function sanctuaire_des_echos.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

return sanctuaire_des_echos
