--[[ d73p24a — aire de repos Sky (checkpoint fourth_station_pass -> fifth_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 114 ; enter01.ssb -> 115).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p24a = {}

function d73p24a.Init(map) end

function d73p24a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p24a')
end

function d73p24a.Update(map) end
function d73p24a.GameSave(map) end
function d73p24a.GameLoad(map) GAME:FadeIn(20) end

function d73p24a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p24a
