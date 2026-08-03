--[[
    init.lua — Chambre de Registeel (Ruines Tordues, portage Aegis Cave)

    Ground de cinematique du gardien. Le combat lui-meme se joue dans le
    segment 5 de la zone cloven_ruins ; ce ground n'existe que pour
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

local cloven_ruins_registeel = {}

function cloven_ruins_registeel.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_cloven_ruins_registeel")
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cloven_ruins_registeel.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_cloven_ruins_registeel")
  if SV.Ruines == nil then SV.Ruines = {} end

  if SV.Ruines.VaincuRegisteel then
    SV.Ruines.VaincuRegisteel = false
    SV.Ruines.ScelleRegisteelBrise = true
    RuinesGardiens.Apres('Registeel', true)
  elseif SV.Ruines.PerduRegisteel then
    SV.Ruines.PerduRegisteel = false
    RuinesGardiens.Apres('Registeel', false)
  else
    RuinesGardiens.Affronter('Registeel')
  end
end

function cloven_ruins_registeel.Update(map, time) end
function cloven_ruins_registeel.GameSave(map) end
function cloven_ruins_registeel.GameLoad(map) end

return cloven_ruins_registeel
