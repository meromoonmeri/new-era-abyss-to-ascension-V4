--[[
    init.lua — tt_beach

    La plage. Beach_Cave_Entrance mene a la Grotte de la Plage dans le
-- jeu source ; le donjon n'existe pas encore ici, la sortie reste
-- inerte plutot que de renvoyer vers une zone absente.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_beach = {}

function tt_beach.Init(map) TreasureTownHub.Init(map) end
function tt_beach.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_beach.Update(map) end
function tt_beach.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_beach.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_beach.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_beach.Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_crossroads_south", "Main_Entrance_Marker")
end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function tt_beach.Beach_Cave_Entrance_Touch(obj, activator) end

return tt_beach
