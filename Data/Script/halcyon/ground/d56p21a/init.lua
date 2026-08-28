--[[ d56p21a — aire de repos Sky (checkpoint limestone_cavern -> deep_limestone_cavern).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 155 ; n06a3201.ssb -> EnterDungeon(156)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d56p21a = {}

function d56p21a.Init(map) end

function d56p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d56p21a')
end

function d56p21a.Update(map) end
function d56p21a.GameSave(map) end
function d56p21a.GameLoad(map) GAME:FadeIn(20) end

function d56p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d56p21a
