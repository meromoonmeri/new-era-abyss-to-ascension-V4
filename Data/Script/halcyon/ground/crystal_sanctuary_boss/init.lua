--[[
    init.lua — crystal_sanctuary_boss
    Ground de cinématique de l'arène de boss (pattern crooked_den).
    La bataille se joue dans le .rsmap (étage de donjon). Ce ground
    héberge la mise en scène pré/post-combat puis route vers le donjon.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'

local crystal_sanctuary_boss = {}

function crystal_sanctuary_boss.Init(map, time)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function crystal_sanctuary_boss.Enter(map, time)
  crystal_sanctuary_boss.PlotScripting()
end

function crystal_sanctuary_boss.Exit(map, time) end
function crystal_sanctuary_boss.Update(map, time) end

function crystal_sanctuary_boss.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  crystal_sanctuary_boss.PlotScripting()
end

function crystal_sanctuary_boss.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Routage de secours : on ne joue aucune scène bloquante ici pour
-- l'instant (les cinématiques pré/post-boss arrivent au prochain passage).
-- La carte s'ouvre simplement, sans jamais crasher.
function crystal_sanctuary_boss.PlotScripting()
  GAME:FadeIn(20)
end

function crystal_sanctuary_boss.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return crystal_sanctuary_boss
