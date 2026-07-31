--[[
    init.lua — tt_guild_bedroom_nuit

    La chambre, la nuit.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_bedroom_nuit = {}

function tt_guild_bedroom_nuit.Init(map) TreasureTownHub.Init(map) end
function tt_guild_bedroom_nuit.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_bedroom_nuit.Update(map) end
function tt_guild_bedroom_nuit.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_bedroom_nuit.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_bedroom_nuit.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_bedroom_nuit.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_bedroom_nuit.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_bedroom_nuit.Spoink_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_bedroom_nuit
