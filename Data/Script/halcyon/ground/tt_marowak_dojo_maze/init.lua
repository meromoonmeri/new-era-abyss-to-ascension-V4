--[[
    init.lua — tt_marowak_dojo_maze

    Le labyrinthe du dojo. On n'en sort que par la sortie de donjon.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Le cablage
    du hub est centralise dans halcyon.TreasureTownHub : ce fichier ne
    fait que declarer ses sorties.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local tt_marowak_dojo_maze = {}

function tt_marowak_dojo_maze.Init(map) TreasureTownHub.Init(map) end
function tt_marowak_dojo_maze.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function tt_marowak_dojo_maze.Update(map) end
function tt_marowak_dojo_maze.GameSave(map) TreasureTownHub.GameSave(map) end
function tt_marowak_dojo_maze.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function tt_marowak_dojo_maze.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return tt_marowak_dojo_maze
