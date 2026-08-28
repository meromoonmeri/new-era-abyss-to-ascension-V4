--[[ d79p21a — aire de repos Sky (checkpoint crevice_cave -> lower_crevice_cave).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 47 LABEL_D047_CLEAR ; scripts -> EnterDungeon(48)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d79p21a = {}

function d79p21a.Init(map) end

function d79p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d79p21a')
end

function d79p21a.Update(map) end
function d79p21a.GameSave(map) end
function d79p21a.GameLoad(map) GAME:FadeIn(20) end

function d79p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d79p21a
