--[[ d45p21a — aire de repos Sky (checkpoint fortune_ravine -> fortune_ravine_depths).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 130 ; n03a1301.ssb -> EnterDungeon(131)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d45p21a = {}

function d45p21a.Init(map) end

function d45p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d45p21a')
end

function d45p21a.Update(map) end
function d45p21a.GameSave(map) end
function d45p21a.GameLoad(map) GAME:FadeIn(20) end

function d45p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d45p21a
