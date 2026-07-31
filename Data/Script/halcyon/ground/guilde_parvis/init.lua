--[[
    init.lua — guilde_parvis

    Le parvis de la guilde Grodoudou, au sommet de la falaise. La grille
-- au nord mene a l'interieur, la rampe au sud redescend au carrefour.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Elle etait
    presente dans le depot depuis longtemps mais ORPHELINE : absente de
    master_zone, citee par aucun script, et depourvue de ses objets de
    sortie. Elle a ete remplacee par la version complete d'EOSO, puis
    cablee ici.

    Le cablage du hub est centralise dans halcyon.TreasureTownHub.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local guilde_parvis = {}

function guilde_parvis.Init(map) TreasureTownHub.Init(map) end
function guilde_parvis.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function guilde_parvis.Update(map) end
function guilde_parvis.GameSave(map) TreasureTownHub.GameSave(map) end
function guilde_parvis.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function guilde_parvis.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guilde_parvis.GuildEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_entrance", "Main_Entrance_Marker")
end

function guilde_parvis.CrossRoadsEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_assembly", "Main_Entrance_Marker")
end

function guilde_parvis.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return guilde_parvis
