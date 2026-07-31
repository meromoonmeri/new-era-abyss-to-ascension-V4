--[[
    init.lua — tt_guild_master_nuit

    Les quartiers du maitre, la nuit.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_master_nuit = {}

function tt_guild_master_nuit.Init(map) TreasureTownHub.Init(map) end
function tt_guild_master_nuit.Enter(map) TreasureTownHub.Enter(map, 'Guildmaster Wigglytuff.ogg') end
function tt_guild_master_nuit.Update(map) end
function tt_guild_master_nuit.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_master_nuit.GameLoad(map) TreasureTownHub.GameLoad(map, 'Guildmaster Wigglytuff.ogg') end

function tt_guild_master_nuit.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_master_nuit.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_master_nuit.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_master_nuit
