--[[ d38p12a — aire de repos Sky (entrée de spacial_rift).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : ENTRANCE_SORANOSAKEME_RESUME ; s21p0701.ssb -> EnterDungeon(64)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d38p12a = {}

function d38p12a.Init(map) end

function d38p12a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d38p12a')
end

function d38p12a.Update(map) end
function d38p12a.GameSave(map) end
function d38p12a.GameLoad(map) GAME:FadeIn(20) end

function d38p12a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d38p12a
