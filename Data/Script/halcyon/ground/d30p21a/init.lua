--[[ d30p21a — aire de repos Sky (checkpoint temporal_tower -> temporal_spire).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 41 LABEL_D041_CLEAR ; m25a0901.ssb -> EnterDungeon(42)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d30p21a = {}

function d30p21a.Init(map) end

function d30p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d30p21a')
end

function d30p21a.Update(map) end
function d30p21a.GameSave(map) end
function d30p21a.GameLoad(map) GAME:FadeIn(20) end

function d30p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d30p21a
