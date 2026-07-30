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
require 'halcyon.ground.crystal_sanctuary_miniboss.crystal_sanctuary_miniboss_ch_8'

local crystal_sanctuary_miniboss = {}

function crystal_sanctuary_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_crystal_sanctuary_miniboss")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function crystal_sanctuary_miniboss.Enter(map)
  if SV.Chapter8.CrystalMiniBossSeen == nil then SV.Chapter8.CrystalMiniBossSeen = false end
  if SV.Chapter8.CrystalMiniBossDefeated == nil then SV.Chapter8.CrystalMiniBossDefeated = false end
  if SV.Chapter8.CrystalMiniBossLost == nil then SV.Chapter8.CrystalMiniBossLost = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_crystal_sanctuary_miniboss")

  if SV.Chapter8.CrystalMiniBossDefeated then
    SV.Chapter8.CrystalMiniBossDefeated = false
    crystal_sanctuary_miniboss_ch_8.DefeatedBoss()
  elseif SV.Chapter8.CrystalMiniBossLost then
    SV.Chapter8.CrystalMiniBossLost = false
    crystal_sanctuary_miniboss_ch_8.DiedToBoss()
  elseif SV.Chapter8.CrystalMiniBossSeen then
    crystal_sanctuary_miniboss_ch_8.SecondPreBossScene()
  else
    crystal_sanctuary_miniboss_ch_8.FirstPreBossScene()
  end
end

function crystal_sanctuary_miniboss.Update(map, time)
end

function crystal_sanctuary_miniboss.GameSave(map)
end

function crystal_sanctuary_miniboss.GameLoad(map)
end

return crystal_sanctuary_miniboss
