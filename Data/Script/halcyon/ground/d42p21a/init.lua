--[[ d42p21a — aire de repos Sky (checkpoint star_cave_se1 -> deep_star_cave_dungeon).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 123 ; n01a1601.ssb -> EnterDungeon(124 DEEP_STAR_CAVE)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d42p21a = {}

function d42p21a.Init(map) end

function d42p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d42p21a')
end

function d42p21a.Update(map) end
function d42p21a.GameSave(map) end
function d42p21a.GameLoad(map) GAME:FadeIn(20) end

function d42p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d42p21a
