--[[
    init.lua — guilde_sous_sol_nuit

    Le sous-sol la nuit.

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

local guilde_sous_sol_nuit = {}

function guilde_sous_sol_nuit.Init(map) TreasureTownHub.Init(map) end
function guilde_sous_sol_nuit.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function guilde_sous_sol_nuit.Update(map) end
function guilde_sous_sol_nuit.GameSave(map) TreasureTownHub.GameSave(map) end
function guilde_sous_sol_nuit.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function guilde_sous_sol_nuit.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guilde_sous_sol_nuit.GuildSecondFloor_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_jobboards", "Main_Entrance_Marker")
end

function guilde_sous_sol_nuit.GuildDiningRoom_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_dining", "Main_Entrance_Marker")
end

function guilde_sous_sol_nuit.GuildMasterRoom_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_master", "Main_Entrance_Marker")
end

function guilde_sous_sol_nuit.GuildHallwayEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_bedroom", "Main_Entrance_Marker")
end

function guilde_sous_sol_nuit.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return guilde_sous_sol_nuit
