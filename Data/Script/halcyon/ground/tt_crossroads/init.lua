--[[
    init.lua — tt_crossroads

    Variante du carrefour sans PNJ, conservee pour les cinematiques.
-- Aucune sortie : on n'y arrive que par script.

    Variante du carrefour SANS PNJ. tt_crossroads_assembly est la version
    peuplee, c'est elle qui sert au jeu normal. Celle-ci est conservee
    pour une cinematique qui aurait besoin d'un carrefour vide.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_crossroads = {}

function tt_crossroads.Init(map) TreasureTownHub.Init(map) end
function tt_crossroads.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_crossroads.Update(map) end
function tt_crossroads.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_crossroads.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_crossroads.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return tt_crossroads
