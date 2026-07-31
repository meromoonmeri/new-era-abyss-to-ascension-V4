--[[
    init.lua — tt_beach_dusk

    La plage au crepuscule. Carte de cinematique (les marqueurs C1S1/C1S2
-- sont des positions de camera du chapitre 1 d'EoS). Pas de sortie
-- libre : une scene la charge et la quitte.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_beach_dusk = {}

function tt_beach_dusk.Init(map) TreasureTownHub.Init(map) end
function tt_beach_dusk.Enter(map) TreasureTownHub.Enter(map, 'Treasure Town.ogg') end
function tt_beach_dusk.Update(map) end
function tt_beach_dusk.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_beach_dusk.GameLoad(map) TreasureTownHub.GameLoad(map, 'Treasure Town.ogg') end

function tt_beach_dusk.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function tt_beach_dusk.Koffing_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Plage_Ambiance', "Normal")
end

function tt_beach_dusk.Zubat_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Plage_Ambiance', "Normal")
end

function tt_beach_dusk.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Plage_Ambiance', "Normal")
end

function tt_beach_dusk.Grovyle_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Plage_Ambiance', "Normal")
end

return tt_beach_dusk
