--[[ d73p23a — aire de repos Sky (checkpoint third_station_pass -> fourth_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 113 ; enter01.ssb -> 114).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p23a = {}

function d73p23a.Init(map) end

function d73p23a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p23a')
end

function d73p23a.Update(map) end
function d73p23a.GameSave(map) end
function d73p23a.GameLoad(map) GAME:FadeIn(20) end

function d73p23a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p23a
