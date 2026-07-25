--[[
    init.lua
    Vast Steppe Mini-Boss Ground Map
    Stantler + Mudbray encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.vast_steppe_miniboss.vast_steppe_miniboss_ch_5'

local vast_steppe_miniboss = {}

function vast_steppe_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vast_steppe_miniboss")
end

function vast_steppe_miniboss.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_vast_steppe_miniboss")

  if SV.Chapter5.SteppeMiniBossSeen then
    vast_steppe_miniboss_ch_5.SecondPreBossScene()
  else
    vast_steppe_miniboss_ch_5.FirstPreBossScene()
  end
end

function vast_steppe_miniboss.Update(map, time)
end

function vast_steppe_miniboss.GameSave(map)
end

function vast_steppe_miniboss.GameLoad(map)
end

return vast_steppe_miniboss
