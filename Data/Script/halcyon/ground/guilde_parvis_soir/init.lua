--[[
    init.lua — guilde_parvis_soir

    Le parvis au crepuscule.

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

local guilde_parvis_soir = {}

function guilde_parvis_soir.Init(map) TreasureTownHub.Init(map) end
function guilde_parvis_soir.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function guilde_parvis_soir.Update(map) end
function guilde_parvis_soir.GameSave(map) TreasureTownHub.GameSave(map) end
function guilde_parvis_soir.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function guilde_parvis_soir.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guilde_parvis_soir.GuildEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_entrance", "Main_Entrance_Marker")
end

function guilde_parvis_soir.CrossRoadsEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_assembly", "Main_Entrance_Marker")
end

function guilde_parvis_soir.Koffing_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_parvis_soir.Zubat_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_parvis_soir.Diglett_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_parvis_soir.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return guilde_parvis_soir
