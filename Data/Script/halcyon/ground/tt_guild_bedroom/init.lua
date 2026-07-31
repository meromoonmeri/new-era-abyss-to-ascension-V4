--[[
    init.lua — tt_guild_bedroom

    La chambre des apprentis. L'objet Bed declenche le coucher dans le
-- jeu source ; ici il reste inerte tant que le cycle de nuit du bourg
-- n'est pas ecrit.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_bedroom = {}

function tt_guild_bedroom.Init(map) TreasureTownHub.Init(map) end
function tt_guild_bedroom.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_bedroom.Update(map) end
function tt_guild_bedroom.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_bedroom.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_bedroom.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_bedroom.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_jobboards", "Main_Entrance_Marker")
end

function tt_guild_bedroom.Loudred_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_bedroom.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_bedroom.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_bedroom.Sign_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function tt_guild_bedroom.Bed_Touch(obj, activator) end

return tt_guild_bedroom
