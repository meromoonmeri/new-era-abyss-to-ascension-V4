--[[
    init.lua — Cloven Ruins Boss Ground Map
    Chapter 7 — Arene Regigigas
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.cloven_ruins_boss.cloven_ruins_boss_ch_7'

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
local cloven_ruins_boss = {}
function cloven_ruins_boss.Init(map) COMMON.RespawnAllies(); PartnerEssentials.InitializePartnerSpawn() end
function cloven_ruins_boss.Enter(map)
  nre_snap('cloven_ruins_boss.Enter')
  if SV.Chapter7.DefeatedRuinsBoss then
    SV.Chapter7.DefeatedRuinsBoss = false
    cloven_ruins_boss_ch_7.DefeatedBoss()
  elseif SV.Chapter7.DiedToRuinsBoss then
    SV.Chapter7.DiedToRuinsBoss = false
    cloven_ruins_boss_ch_7.DiedToBoss()
  else
    cloven_ruins_boss_ch_7.FirstPreBossScene()
  end
end
function cloven_ruins_boss.Update(map) end
function cloven_ruins_boss.GameSave(map) PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1')) end
function cloven_ruins_boss.GameLoad(map) PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1')) end
return cloven_ruins_boss
