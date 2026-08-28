--[[ d73p26a — aire de repos Sky (checkpoint sixth_station_pass -> seventh_station_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 116 ; enter01.ssb -> 117).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p26a = {}

function d73p26a.Init(map) end

function d73p26a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p26a')
end

function d73p26a.Update(map) end
function d73p26a.GameSave(map) end
function d73p26a.GameLoad(map) GAME:FadeIn(20) end

function d73p26a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p26a
