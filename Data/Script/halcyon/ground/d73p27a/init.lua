--[[ d73p27a — aire de repos Sky (checkpoint seventh_station_pass -> eighth_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 117 ; enter01.ssb -> 118).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p27a = {}

function d73p27a.Init(map) end

function d73p27a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p27a')
end

function d73p27a.Update(map) end
function d73p27a.GameSave(map) end
function d73p27a.GameLoad(map) GAME:FadeIn(20) end

function d73p27a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p27a
