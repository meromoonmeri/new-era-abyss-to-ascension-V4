--[[
    init.lua — gloomy_forest_boss
    Ground de cinématique de l'arène de boss (pattern crooked_den).
    La bataille se joue dans le .rsmap (étage de donjon). Ce ground
    héberge la mise en scène pré/post-combat puis route vers le donjon.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'

local gloomy_forest_boss = {}

function gloomy_forest_boss.Init(map, time)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function gloomy_forest_boss.Enter(map, time)
  gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.Exit(map, time) end
function gloomy_forest_boss.Update(map, time) end

function gloomy_forest_boss.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  gloomy_forest_boss.PlotScripting()
end

function gloomy_forest_boss.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Routage de secours : on ne joue aucune scène bloquante ici pour
-- l'instant (les cinématiques pré/post-boss arrivent au prochain passage).
-- La carte s'ouvre simplement, sans jamais crasher.
function gloomy_forest_boss.PlotScripting()
  GAME:FadeIn(20)
end

function gloomy_forest_boss.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return gloomy_forest_boss
