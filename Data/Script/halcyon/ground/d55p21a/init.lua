--[[ d55p21a — aire de repos Sky (checkpoint boulder_quarry -> deep_boulder_quarry).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 150 ; n06a1101.ssb -> EnterDungeon(151)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d55p21a = {}

function d55p21a.Init(map) end

function d55p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d55p21a')
end

function d55p21a.Update(map) end
function d55p21a.GameSave(map) end
function d55p21a.GameLoad(map) GAME:FadeIn(20) end

function d55p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d55p21a
