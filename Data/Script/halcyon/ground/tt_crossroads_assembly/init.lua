--[[
    init.lua — tt_crossroads_assembly

    Le carrefour. Toute la circulation du bourg passe par ici :
-- la place au sud-ouest, la guilde en haut de la falaise, la route du
-- sud vers la plage. DungeonEntrance reste inerte tant qu'aucun donjon
-- n'est rattache au bourg.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_crossroads_assembly = {}

function tt_crossroads_assembly.Init(map) TreasureTownHub.Init(map) end
function tt_crossroads_assembly.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_crossroads_assembly.Update(map) end
function tt_crossroads_assembly.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_crossroads_assembly.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_crossroads_assembly.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_crossroads_assembly.GuildOutsideEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("guilde_parvis", "Main_Entrance_Marker")
end

function tt_crossroads_assembly.TreasureTownEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("treasure_town", "Main_Entrance_Marker")
end

function tt_crossroads_assembly.CrossRoadsSouthEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_south", "Main_Entrance_Marker")
end

function tt_crossroads_assembly.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Carrefour_Ambiance', "Normal")
end

function tt_crossroads_assembly.Marill_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Carrefour_Ambiance', "Normal")
end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function tt_crossroads_assembly.DungeonEntrance_Touch(obj, activator) end

return tt_crossroads_assembly
