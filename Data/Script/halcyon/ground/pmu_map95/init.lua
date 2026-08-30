--[[
    init.lua — import automatique PMU « map95 » (pipeline pmu_maps v1.1.0).
    Environnement seul : le fondu d'entrée est libéré à Enter() (exigence
    moteur — sinon EnterGroundMap fige la scène). Aucun routing de scénario,
    aucun PNJ, aucune interaction : la sémantique PMU vit dans
    output/pmu/map95/semantics.json et les markers de la carte, en attente
    d'un jalon « structures/Gameplay » dédié.
]]--
require 'origin.common'

local pmu_map95 = {}

function pmu_map95.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_pmu_map95 <<=')
end

function pmu_map95.Enter(map)
  GAME:FadeIn(20)
end

function pmu_map95.Update(map, time)
end

function pmu_map95.GameSave(map)
end

function pmu_map95.GameLoad(map)
  GAME:FadeIn(20)
end

return pmu_map95
