--[[ d57p21a — aire de repos Sky (checkpoint lower_spring_cave -> spring_cave_depths).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 162 ; n04a1701/n04a1901.ssb -> EnterDungeon(163)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d57p21a = {}

function d57p21a.Init(map) end

function d57p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d57p21a')
end

function d57p21a.Update(map) end
function d57p21a.GameSave(map) end
function d57p21a.GameLoad(map) GAME:FadeIn(20) end

function d57p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d57p21a
