--[[
    init.lua — guilde_sous_sol

    Le sous-sol de la guilde : l'echelle remonte a l'etage des tableaux,
-- le refectoire a l'ouest, les quartiers du maitre a l'est, le couloir
-- des chambres au fond.

    Carte reprise d'ExplorersOfSkyOrigins (voir CREDITS.md). Elle etait
    presente dans le depot depuis longtemps mais ORPHELINE : absente de
    master_zone, citee par aucun script, et depourvue de ses objets de
    sortie. Elle a ete remplacee par la version complete d'EOSO, puis
    cablee ici.

    Le cablage du hub est centralise dans halcyon.TreasureTownHub.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.TreasureTownHub'

local guilde_sous_sol = {}

function guilde_sous_sol.Init(map) TreasureTownHub.Init(map) end
function guilde_sous_sol.Enter(map) TreasureTownHub.Enter(map, "Wigglytuff's Guild.ogg") end
function guilde_sous_sol.Update(map) end
function guilde_sous_sol.GameSave(map) TreasureTownHub.GameSave(map) end
function guilde_sous_sol.GameLoad(map) TreasureTownHub.GameLoad(map, "Wigglytuff's Guild.ogg") end

function guilde_sous_sol.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guilde_sous_sol.GuildSecondFloor_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_jobboards", "Main_Entrance_Marker")
end

function guilde_sous_sol.GuildDiningRoom_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_dining", "Main_Entrance_Marker")
end

function guilde_sous_sol.GuildMasterRoom_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_master", "Main_Entrance_Marker")
end

function guilde_sous_sol.GuildHallwayEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Sortie("tt_guild_bedroom", "Main_Entrance_Marker")
end

function guilde_sous_sol.Chatot_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Croagunk_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Loudred_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Chimecho_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Dugtrio_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Corphish_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Bidoof_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Diglett_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Sunflora_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

function guilde_sous_sol.Wigglytuff_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  TreasureTownHub.Parle(chara, 'TTH_Guilde_Ambiance', "Normal")
end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function guilde_sous_sol.CutsceneWanderTrigger_Touch(obj, activator) end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function guilde_sous_sol.CutsceneWanderTrigger_1_Touch(obj, activator) end

--Declencheur sans destination cablee : il existe sur la carte d'origine
--mais ne mene nulle part dans New Era pour l'instant. Laisse inerte
--plutot que muet-plantant.
function guilde_sous_sol.CutsceneWanderTrigger_2_Touch(obj, activator) end

return guilde_sous_sol
