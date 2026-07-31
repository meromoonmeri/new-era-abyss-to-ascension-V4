--[[
    init.lua — tt_guild_jobboards

    La salle des tableaux de missions. C'est ici que vivent JobBoard et
-- OutlawBoard : le job board du bourg, exige par la regle de parite
-- avec Metano.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_jobboards = {}

function tt_guild_jobboards.Init(map) TreasureTownHub.Init(map) end
function tt_guild_jobboards.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_jobboards.Update(map) end
function tt_guild_jobboards.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_jobboards.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_jobboards.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_guild_jobboards.ExitTopFloor_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_entrance", "Main_Entrance_Marker")
end

function tt_guild_jobboards.ExitBasement_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("guilde_sous_sol", "Main_Entrance_Marker")
end

function tt_guild_jobboards.CH2_Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Sunflora_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Ledyba_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Wurmple_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Swellow_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Pidgey_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.CH2_Seedot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.Sunflora_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.Spoink_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.OutlawBoard_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.JobBoard_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function tt_guild_jobboards.LeftSign_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

return tt_guild_jobboards
