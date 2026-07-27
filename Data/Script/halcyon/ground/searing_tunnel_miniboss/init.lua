--[[
    init.lua
    Searing Tunnel Mini-Boss Ground Map
    Torkoal + Magmar encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.searing_tunnel_miniboss.searing_tunnel_miniboss_ch_5'

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

local searing_tunnel_miniboss = {}

function searing_tunnel_miniboss.Init(map)
  nre_snap('searing_tunnel_miniboss.Init')
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_searing_tunnel_miniboss")
end

function searing_tunnel_miniboss.Enter(map)
  nre_snap('searing_tunnel_miniboss.Enter')
	if SV.Chapter5.TunnelMiniBossSeen == nil then SV.Chapter5.TunnelMiniBossSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_searing_tunnel_miniboss")

  if SV.Chapter5.TunnelMiniBossSeen then
    searing_tunnel_miniboss_ch_5.SecondPreBossScene()
  else
    searing_tunnel_miniboss_ch_5.FirstPreBossScene()
  end
end

function searing_tunnel_miniboss.Update(map, time)
end

function searing_tunnel_miniboss.GameSave(map)
end

function searing_tunnel_miniboss.GameLoad(map)
end

return searing_tunnel_miniboss
