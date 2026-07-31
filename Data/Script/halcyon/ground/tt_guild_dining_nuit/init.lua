--[[
    init.lua — tt_guild_dining_nuit

    Le refectoire, la nuit. On y arrive par la variante horaire.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_dining_nuit = {}

function tt_guild_dining_nuit.Init(map) TreasureTownHub.Init(map) end
function tt_guild_dining_nuit.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_dining_nuit.Update(map) end
function tt_guild_dining_nuit.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_dining_nuit.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_dining_nuit.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_dining_nuit.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Diglett_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Dugtrio_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Sunflora_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Loudred_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Corphish_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Croagunk_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_dining_nuit.Chimecho_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_dining_nuit
