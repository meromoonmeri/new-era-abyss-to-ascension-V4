--[[ d12p21a — aire de repos Sky (checkpoint amp_plains -> far_amp_plains).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 17 LABEL_D017_CLEAR ; m12a0501.ssb -> EnterDungeon(18)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d12p21a = {}

function d12p21a.Init(map) end

function d12p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d12p21a')
end

function d12p21a.Update(map) end
function d12p21a.GameSave(map) end
function d12p21a.GameLoad(map) GAME:FadeIn(20) end

function d12p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d12p21a
