--[[
    init.lua — tt_sharpedo_bluff

    La falaise Sharpedo, a l'ouest du bourg.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_sharpedo_bluff = {}

function tt_sharpedo_bluff.Init(map) TreasureTownHub.Init(map) end
function tt_sharpedo_bluff.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_sharpedo_bluff.Update(map) end
function tt_sharpedo_bluff.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_sharpedo_bluff.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_sharpedo_bluff.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_sharpedo_bluff.TreasureTownEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("treasure_town", "Main_Entrance_Marker")
end

function tt_sharpedo_bluff.SignSharpedoBluffDay_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Falaise_Ambiance', "Normal")
end

return tt_sharpedo_bluff
