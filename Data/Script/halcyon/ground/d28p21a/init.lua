--[[ d28p21a — aire de repos Sky (checkpoint hidden_land -> hidden_highland).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 38 LABEL_D038_CLEAR ; m24a0601.ssb -> EnterDungeon(39)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d28p21a = {}

function d28p21a.Init(map) end

function d28p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d28p21a')
end

function d28p21a.Update(map) end
function d28p21a.GameSave(map) end
function d28p21a.GameLoad(map) GAME:FadeIn(20) end

function d28p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d28p21a
