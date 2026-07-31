--[[
    init.lua — tt_guild_entrance

    Le sas d'entree de la guilde, entre le parvis et l'etage.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_entrance = {}

function tt_guild_entrance.Init(map) TreasureTownHub.Init(map) end
function tt_guild_entrance.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_entrance.Update(map) end
function tt_guild_entrance.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_entrance.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_entrance.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_entrance.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("guilde_parvis", "Main_Entrance_Marker")
end

function tt_guild_entrance.SecondFloor_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_jobboards", "Main_Entrance_Marker")
end

function tt_guild_entrance.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_entrance.LeftSign_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_entrance.RightSign_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_entrance
