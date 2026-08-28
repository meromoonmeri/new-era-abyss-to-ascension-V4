--[[ d35p21a — aire de repos Sky (checkpoint miracle_sea -> deep_miracle_sea).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 51 LABEL_D051_CLEAR ; -> EnterDungeon(52)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d35p21a = {}

function d35p21a.Init(map) end

function d35p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d35p21a')
end

function d35p21a.Update(map) end
function d35p21a.GameSave(map) end
function d35p21a.GameLoad(map) GAME:FadeIn(20) end

function d35p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d35p21a
