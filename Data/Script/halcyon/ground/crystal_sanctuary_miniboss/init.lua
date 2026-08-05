--[[
    init.lua
    Crystal Sanctuary — salle cinématique du mini-boss (Chapitre 8)
    Héraut et spectre : Strassie + Momartik.
    Patron : searing_tunnel_miniboss (dispatch Seen/Defeated/Lost),
    simplifié : flash blanc + dialogues (directive utilisateur).
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.waterfall_pond_miniboss.waterfall_pond_miniboss_ch_8'

local waterfall_pond_miniboss = {}

function waterfall_pond_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_waterfall_pond_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function waterfall_pond_miniboss.Enter(map)
  if SV.Chapter8.CrystalMiniBossSeen == nil then SV.Chapter8.CrystalMiniBossSeen = false end
  if SV.Chapter8.CrystalMiniBossDefeated == nil then SV.Chapter8.CrystalMiniBossDefeated = false end
  if SV.Chapter8.CrystalMiniBossLost == nil then SV.Chapter8.CrystalMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_waterfall_pond_miniboss")

  if SV.Chapter8.CrystalMiniBossDefeated then
    SV.Chapter8.CrystalMiniBossDefeated = false
    waterfall_pond_miniboss_ch_8.DefeatedBoss()
  elseif SV.Chapter8.CrystalMiniBossLost then
    SV.Chapter8.CrystalMiniBossLost = false
    waterfall_pond_miniboss_ch_8.DiedToBoss()
  elseif SV.Chapter8.CrystalMiniBossSeen then
    waterfall_pond_miniboss_ch_8.SecondPreBossScene()
  else
    waterfall_pond_miniboss_ch_8.FirstPreBossScene()
  end
end

function waterfall_pond_miniboss.Update(map, time)
end

function waterfall_pond_miniboss.GameSave(map)
end

function waterfall_pond_miniboss.GameLoad(map)
end

return waterfall_pond_miniboss
