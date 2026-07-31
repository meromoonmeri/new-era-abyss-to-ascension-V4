--[[
    init.lua — guilde_parvis_nuit

    Le parvis la nuit, grille fermee dans le jeu source.

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

local guilde_parvis_nuit = {}

function guilde_parvis_nuit.Init(map) TreasureTownHub.Init(map) end
function guilde_parvis_nuit.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function guilde_parvis_nuit.Update(map) end
function guilde_parvis_nuit.GameSave(map) TreasureTownHub.GameSave(map) end
function guilde_parvis_nuit.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function guilde_parvis_nuit.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guilde_parvis_nuit.GuildEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_entrance", "Main_Entrance_Marker")
end

function guilde_parvis_nuit.CrossRoadsEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_assembly", "Main_Entrance_Marker")
end

return guilde_parvis_nuit
