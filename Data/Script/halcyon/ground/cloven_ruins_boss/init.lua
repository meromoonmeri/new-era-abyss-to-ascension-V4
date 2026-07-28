--[[
    init.lua — Cloven Ruins Boss Ground Map
    Chapter 7 — Arene Regigigas
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ReplayEnding'
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
  -- Rejouabilite : les golems sont partis, le Titan aussi. La revanche
  -- volontaire passe par le segment 3 achete chez Grodoudou ('colossus_quarry'),
  -- et zone/cloven_ruins/init.lua l'intercepte AVANT d'arriver ici.
  if ReplayEnding.IsReplay('cloven_ruins', 7) then
    SV.Chapter7.DefeatedRuinsBoss = false
    SV.Chapter7.DiedToRuinsBoss = false
    ReplayEnding.EmptyArena({
      hero = {152, 240}, partner = {120, 240},
      camera = {136, 208}, look = {136, 168},
      walk = 48, title = true, music = 'In the Depths of the Pit.ogg',
      lines = {
        { spk='partner', emo='Normal', key='CRB_R01', wait=10 },
        { spk='hero',    emo='Normal', key='CRB_R02', wait=10 },
        { spk='partner', emo='Sad',    key='CRB_R03' },
        { spk='narrator',              key='CRB_R04' },
      },
    })
    return
  end

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
