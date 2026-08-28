--[[ d51p21a — aire de repos Sky (checkpoint dark_ice_mountain -> dark_ice_mountain_peak).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 142 ; n09a0301.ssb -> EnterDungeon(143)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d51p21a = {}

function d51p21a.Init(map) end

function d51p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d51p21a')
end

function d51p21a.Update(map) end
function d51p21a.GameSave(map) end
function d51p21a.GameLoad(map) GAME:FadeIn(20) end

function d51p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d51p21a
