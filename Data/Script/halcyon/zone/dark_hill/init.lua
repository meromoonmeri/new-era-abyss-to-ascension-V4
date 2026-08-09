--[[
    init.lua — Dark Hill (dungeon 28, arc du futur main story).
    Zone PMDO native : LayeredSegment -> 15 floors procéduraux.
    Entrée : d19p11a (m18a0201). Sortie : retour d19p11a -> Sealed Ruin.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc._future_dungeons_common'

local dark_hill = {}

function dark_hill.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_dark_hill")
  SV.TemporaryFlags.LastDungeonEntered = 'dark_hill'
end

function dark_hill.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then COMMON.BeginDungeon(zone.ID, segmentID, mapID) end
end

function dark_hill.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function dark_hill.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end
  FutureDungeonCommon.ExitToGround(result, zone.ID, 'd19p11a')
end

return dark_hill
