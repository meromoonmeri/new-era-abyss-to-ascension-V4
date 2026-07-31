--[[
    init.lua — tt_spinda_cafe

    Le Cafe Qulbutoke. Distinct du cafe de Metano, qui est une creation
-- propre a New Era.

    ACCES NON CABLE. La carte ne porte aucun objet de sortie, et la place
    ne comporte aucune porte vers le cafe dans le materiel source : dans
    EoS on y entre par une transition scriptee. Il faudra poser un
    GroundObject de type Touch sur la place, devant la devanture, quand
    la scene d'ouverture du bourg sera ecrite. En l'etat, la carte est
    chargeable mais on n'y accede que par script.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_spinda_cafe = {}

function tt_spinda_cafe.Init(map) TreasureTownHub.Init(map) end
function tt_spinda_cafe.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_spinda_cafe.Update(map) end
function tt_spinda_cafe.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_spinda_cafe.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_spinda_cafe.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return tt_spinda_cafe
