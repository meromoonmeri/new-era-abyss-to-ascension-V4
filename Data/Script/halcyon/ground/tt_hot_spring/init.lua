--[[
    init.lua — tt_hot_spring

    La source chaude. Lieu de repos, sans sortie propre : on y accede
-- depuis le carrefour une fois la liaison ecrite.

    ACCES NON CABLE, meme raison que le cafe : la source chaude n'a pas de
    porte d'entree dans le decor source. Elle se rejoint depuis le
    carrefour dans EoS, par un chemin qui n'existe pas sur nos cartes
    importees.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_hot_spring = {}

function tt_hot_spring.Init(map) TreasureTownHub.Init(map) end
function tt_hot_spring.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_hot_spring.Update(map) end
function tt_hot_spring.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_hot_spring.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_hot_spring.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return tt_hot_spring
