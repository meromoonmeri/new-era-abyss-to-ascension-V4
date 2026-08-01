--[[
    init.lua
    Mount Windswept Guardian Ground Map
    Tornadus, gardien du sommet — Chapitre 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
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

  -- Rejouabilite : l'expedition est bouclee, le sommet est vide.
  -- Attention : cette arene fait 1128x1344 px, le duo doit rester dans la carte.
  if ReplayEnding.IsReplay('mount_windswept', 5) then
    SV.Chapter5.MountGuardianDefeated = false
    SV.Chapter5.MountGuardianLost = false
    ReplayEnding.EmptyArena({
      -- Positions verifiees cellule par cellule contre obstacles[] :
      -- hero/partner en y=1200 (zone libre, y<=1228), les equipiers
      -- derives par EmptyArena (min-32 / max+32, +16 en Y) tombent en
      -- (464,1216)/(592,1216), tous libres, et la marche de 40 px vers
      -- le nord reste dans la plateforme (ex-208x176 : tout etait dans
      -- les murs apres l'agrandissement de la carte).
      hero = {560, 1200}, partner = {496, 1200},
      camera = {560, 1200}, look = {560, 1160},
      walk = 40, title = true, music = 'Mt. Travail.ogg',
      lines = {
        { spk='partner', emo='Normal', key='MWG_R01', wait=10 },
        { spk='hero',    emo='Normal', key='MWG_R02', wait=10 },
        { spk='partner', emo='Normal', key='MWG_R03' },
        { spk='narrator',              key='MWG_R04' },
      },
    })
    return
  end

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
