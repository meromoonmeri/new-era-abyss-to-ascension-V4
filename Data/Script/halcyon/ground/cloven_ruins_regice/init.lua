--[[
    init.lua — Chambre de Regice (Ruines Tordues, portage Aegis Cave)

    Ground de cinematique du gardien. Le combat lui-meme se joue dans le
    segment 1 de la zone cloven_ruins ; ce ground n'existe que pour
    la mise en scene, exactement comme cloven_ruins_miniboss.

    Dispatch : premiere venue -> eveil du gardien ; retour apres victoire
    ou defaite -> scene correspondante. Toute la logique vit dans
    halcyon.RuinesGardiens, commune aux trois scelles.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.RuinesGardiens'

local cloven_ruins_regice = {}

function cloven_ruins_regice.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins_regice")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_regice.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_cloven_ruins_regice")
  if SV.Ruines == nil then SV.Ruines = {} end

  if SV.Ruines.VaincuRegice then
    SV.Ruines.VaincuRegice = false
    SV.Ruines.ScelleRegiceBrise = true
    RuinesGardiens.Apres('Regice', true)
  elseif SV.Ruines.PerduRegice then
    SV.Ruines.PerduRegice = false
    RuinesGardiens.Apres('Regice', false)
  else
    RuinesGardiens.Affronter('Regice')
  end
end

function cloven_ruins_regice.Update(map, time) end
function cloven_ruins_regice.GameSave(map) end
function cloven_ruins_regice.GameLoad(map) end

return cloven_ruins_regice
