--[[ d73p29a — aire de repos Sky (checkpoint ninth_station_pass -> sky_peak_summit_pass).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 119 ; enter01.ssb -> 120).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d73p29a = {}

function d73p29a.Init(map) end

function d73p29a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d73p29a')
end

function d73p29a.Update(map) end
function d73p29a.GameSave(map) end
function d73p29a.GameLoad(map) GAME:FadeIn(20) end

function d73p29a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d73p29a
