--[[
    init.lua
    Mount Windswept Guardian Ground Map
    Aerodactyl encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.mount_windswept_guardian.mount_windswept_guardian_ch_5'

-- [NREPROBE] sonde locale : état complet de la scène à un point donné.
local function nre_snap(tag)
  local ok, msg = pcall(function()
    local zone = tostring(_ZONE.CurrentZoneID)
    local seg = tostring(_ZONE.CurrentMapID.Segment)
    local save_n = _DATA.Save.ActiveTeam.Players.Count
    local leader = '<nil>'
    if _DATA.Save.ActiveTeam.Leader ~= nil then
      leader = _DATA.Save.ActiveTeam.Leader:GetDisplayName(true)
    end
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    return string.format('[NREPROBE][%s] zone=%s seg=%s Save.Team=%d leader=%s hero=%s partner=%s',
      tag, zone, seg, save_n, leader,
      hero ~= nil and 'OK' or 'NIL', partner ~= nil and 'OK' or 'NIL')
  end)
  PrintInfo(ok and msg or ('[NREPROBE]['..tag..'] snapshot FAILED: '..tostring(msg)))
end

local mount_windswept_guardian = {}

function mount_windswept_guardian.Init(map)
  nre_snap('mount_windswept_guardian.Init')
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windswept_guardian")

  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mount_windswept_guardian.Enter(map)
  nre_snap('mount_windswept_guardian.Enter')
	if SV.Chapter5.MountGuardianDefeated == nil then SV.Chapter5.MountGuardianDefeated = false end
	if SV.Chapter5.MountGuardianLost == nil then SV.Chapter5.MountGuardianLost = false end
	if SV.Chapter5.MountGuardianSeen == nil then SV.Chapter5.MountGuardianSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_mount_windswept_guardian")

  if SV.Chapter5.MountGuardianDefeated then
    SV.Chapter5.MountGuardianDefeated = false
    mount_windswept_guardian_ch_5.DefeatedBoss()
  elseif SV.Chapter5.MountGuardianLost then
    SV.Chapter5.MountGuardianLost = false
    mount_windswept_guardian_ch_5.DiedToBoss()
  elseif SV.Chapter5.MountGuardianSeen then
    mount_windswept_guardian_ch_5.SecondPreBossScene()
  else
    mount_windswept_guardian_ch_5.FirstPreBossScene()
  end
end

function mount_windswept_guardian.Update(map, time)
end

function mount_windswept_guardian.GameSave(map)
end

function mount_windswept_guardian.GameLoad(map)
end

return mount_windswept_guardian
