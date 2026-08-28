--[[ d73p22a — aire de repos Sky (checkpoint second_station_pass -> third_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 112 ; enter01.ssb -> 113).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p22a = {}

function d73p22a.Init(map) end

function d73p22a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p22a')
end

function d73p22a.Update(map) end
function d73p22a.GameSave(map) end
function d73p22a.GameLoad(map) GAME:FadeIn(20) end

function d73p22a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p22a
