--[[
    init.lua
    Cloven Ruins — salle cinématique du mini-boss (Chapitre 7)
    Gardiens antiques : Kaorine + Golemastoc.
    Patron : searing_tunnel_miniboss (dispatch Seen/Defeated/Lost),
    simplifié : flash blanc + dialogues (directive utilisateur).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.cloven_ruins_miniboss.cloven_ruins_miniboss_ch_7'

local cloven_ruins_miniboss = {}

function cloven_ruins_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_miniboss.Enter(map)
  if SV.Chapter7.RuinsMiniBossSeen == nil then SV.Chapter7.RuinsMiniBossSeen = false end
  if SV.Chapter7.RuinsMiniBossDefeated == nil then SV.Chapter7.RuinsMiniBossDefeated = false end
  if SV.Chapter7.RuinsMiniBossLost == nil then SV.Chapter7.RuinsMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_cloven_ruins_miniboss")

  if SV.Chapter7.RuinsMiniBossDefeated then
    SV.Chapter7.RuinsMiniBossDefeated = false
    cloven_ruins_miniboss_ch_7.DefeatedBoss()
  elseif SV.Chapter7.RuinsMiniBossLost then
    SV.Chapter7.RuinsMiniBossLost = false
    cloven_ruins_miniboss_ch_7.DiedToBoss()
  elseif SV.Chapter7.RuinsMiniBossSeen then
    cloven_ruins_miniboss_ch_7.SecondPreBossScene()
  else
    cloven_ruins_miniboss_ch_7.FirstPreBossScene()
  end
end

function cloven_ruins_miniboss.Update(map, time)
end

function cloven_ruins_miniboss.GameSave(map)
end

function cloven_ruins_miniboss.GameLoad(map)
end

return cloven_ruins_miniboss
