--[[ d39p21a — aire de repos Sky (checkpoint spacial_rift -> deep_spacial_rift).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 64 LABEL_D064_CLEAR ; s21p0901.ssb -> EnterDungeon(65)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d39p21a = {}

function d39p21a.Init(map) end

function d39p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d39p21a')
end

function d39p21a.Update(map) end
function d39p21a.GameSave(map) end
function d39p21a.GameLoad(map) GAME:FadeIn(20) end

function d39p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d39p21a
