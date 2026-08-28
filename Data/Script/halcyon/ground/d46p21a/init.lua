--[[ d46p21a — aire de repos Sky (checkpoint barren_valley -> deep_barren_valley).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 133 ; n08a0608.ssb -> EnterDungeon(134)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d46p21a = {}

function d46p21a.Init(map) end

function d46p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d46p21a')
end

function d46p21a.Update(map) end
function d46p21a.GameSave(map) end
function d46p21a.GameLoad(map) GAME:FadeIn(20) end

function d46p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d46p21a
