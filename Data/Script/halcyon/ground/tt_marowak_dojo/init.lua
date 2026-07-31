--[[
    init.lua — tt_marowak_dojo

    Le dojo Ossatueur. Terrain d'entrainement du bourg.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_marowak_dojo = {}

function tt_marowak_dojo.Init(map) TreasureTownHub.Init(map) end
function tt_marowak_dojo.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_marowak_dojo.Update(map) end
function tt_marowak_dojo.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_marowak_dojo.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_marowak_dojo.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_marowak_dojo.MarowakDojoExit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("treasure_town", "Main_Entrance_Marker")
end

function tt_marowak_dojo.MarowakDojoDungeonEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_marowak_dojo_maze", "Main_Entrance_Marker")
end

function tt_marowak_dojo.Marowak_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Dojo_Ambiance', "Normal")
end

return tt_marowak_dojo
