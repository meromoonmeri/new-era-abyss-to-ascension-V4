--[[
    init.lua — tt_guild_gate

    La grille de la guilde vue de face. PLAN DE CINEMATIQUE, pas une
-- carte jouable : c'est pourquoi elle n'a aucune collision. Aucune
-- sortie, aucune interaction.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_guild_gate = {}

function tt_guild_gate.Init(map) TreasureTownHub.Init(map) end
function tt_guild_gate.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_guild_gate.Update(map) end
function tt_guild_gate.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_guild_gate.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_guild_gate.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return tt_guild_gate
