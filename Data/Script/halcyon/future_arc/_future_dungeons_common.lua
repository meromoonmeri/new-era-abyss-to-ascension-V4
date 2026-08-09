--[[
    _future_dungeons_common.lua — Helpers communs des 6 donjons du futur.

    Fournit GROUND_IDX (index d'un ground dans master_zone) et le hook de
    sortie de donjon qui renvoie le trio sur le ground d'entrée pour jouer la
    scène de sortie (AfterDungeon) puis poursuivre le parcours.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

FutureDungeonCommon = {}

function FutureDungeonCommon.GroundIdx(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if ok then return idx end
  return -1
end

-- Sortie de donjon : renvoie vers le ground d'entrée puis appelle AfterDungeon.
function FutureDungeonCommon.ExitToGround(result, zoneId, groundName)
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1,
    FutureDungeonCommon.GroundIdx(groundName), 0, false, false)
end

return FutureDungeonCommon
