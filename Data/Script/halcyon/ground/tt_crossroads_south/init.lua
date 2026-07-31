--[[
    init.lua — tt_crossroads_south

    Le carrefour sud, entre le croisement principal et la plage.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_crossroads_south = {}

function tt_crossroads_south.Init(map) TreasureTownHub.Init(map) end
function tt_crossroads_south.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_crossroads_south.Update(map) end
function tt_crossroads_south.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_crossroads_south.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_crossroads_south.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_crossroads_south.CrossRoadsAssemblyEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_assembly", "Main_Entrance_Marker")
end

function tt_crossroads_south.BeachEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_beach", "Main_Entrance_Marker")
end

return tt_crossroads_south
