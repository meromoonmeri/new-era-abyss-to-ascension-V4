--[[ d73p21a — aire de repos Sky (checkpoint first_station_pass -> second_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 111 LABEL_SORANOITADAKI_1GOUME ; enter01.ssb -> 112).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p21a = {}

function d73p21a.Init(map) end

function d73p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p21a')
end

function d73p21a.Update(map) end
function d73p21a.GameSave(map) end
function d73p21a.GameLoad(map) GAME:FadeIn(20) end

function d73p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p21a
