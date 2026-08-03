--[[
    init.lua — Chambre de Regirock (Ruines Tordues, portage Aegis Cave)

    Ground de cinematique du gardien. Le combat lui-meme se joue dans le
    segment 3 de la zone cloven_ruins ; ce ground n'existe que pour
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

local cloven_ruins_regirock = {}

function cloven_ruins_regirock.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins_regirock")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_regirock.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_cloven_ruins_regirock")
  if SV.Ruines == nil then SV.Ruines = {} end

  if SV.Ruines.VaincuRegirock then
    SV.Ruines.VaincuRegirock = false
    SV.Ruines.ScelleRegirockBrise = true
    RuinesGardiens.Apres('Regirock', true)
  elseif SV.Ruines.PerduRegirock then
    SV.Ruines.PerduRegirock = false
    RuinesGardiens.Apres('Regirock', false)
  else
    RuinesGardiens.Affronter('Regirock')
  end
end

function cloven_ruins_regirock.Update(map, time) end
function cloven_ruins_regirock.GameSave(map) end
function cloven_ruins_regirock.GameLoad(map) end

return cloven_ruins_regirock
