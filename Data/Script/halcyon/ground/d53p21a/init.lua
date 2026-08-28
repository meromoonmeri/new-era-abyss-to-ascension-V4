--[[ d53p21a — aire de repos Sky (checkpoint vast_ice_mountain -> vast_ice_mountain_peak).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 146 ; n09a1601.ssb -> EnterDungeon(147)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d53p21a = {}

function d53p21a.Init(map) end

function d53p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d53p21a')
end

function d53p21a.Update(map) end
function d53p21a.GameSave(map) end
function d53p21a.GameLoad(map) GAME:FadeIn(20) end

function d53p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d53p21a
