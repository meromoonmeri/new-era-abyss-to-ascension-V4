--[[ d41p21a — aire de repos Sky (checkpoint dark_crater -> deep_dark_crater).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 67 LABEL_D067_CLEAR ; s22p0901.ssb -> EnterDungeon(68)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d41p21a = {}

function d41p21a.Init(map) end

function d41p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d41p21a')
end

function d41p21a.Update(map) end
function d41p21a.GameSave(map) end
function d41p21a.GameLoad(map) GAME:FadeIn(20) end

function d41p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d41p21a
