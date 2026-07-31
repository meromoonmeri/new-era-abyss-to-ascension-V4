--[[
    init.lua — tt_guild_master

    Les quartiers du maitre de guilde.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_master = {}

function tt_guild_master.Init(map) TreasureTownHub.Init(map) end
function tt_guild_master.Enter(map) TreasureTownHub.Enter(map, 'Guildmaster Wigglytuff.ogg') end
function tt_guild_master.Update(map) end
function tt_guild_master.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_master.GameLoad(map) TreasureTownHub.GameLoad(map, 'Guildmaster Wigglytuff.ogg') end

function tt_guild_master.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_master.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_jobboards", "Main_Entrance_Marker")
end

function tt_guild_master.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_master.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_master
