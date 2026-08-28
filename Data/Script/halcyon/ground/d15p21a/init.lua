--[[ d15p21a — aire de repos Sky (checkpoint quicksand_cave -> quicksand_pit).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 21 LABEL_D021_CLEAR ; m14a0501.ssb -> EnterDungeon(22)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d15p21a = {}

function d15p21a.Init(map) end

function d15p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d15p21a')
end

function d15p21a.Update(map) end
function d15p21a.GameSave(map) end
function d15p21a.GameLoad(map) GAME:FadeIn(20) end

function d15p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d15p21a
