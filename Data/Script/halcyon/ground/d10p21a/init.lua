--[[ d10p21a — aire de repos Sky (checkpoint steam_cave -> upper_steam_cave).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 14 LABEL_D014_CLEAR ; m10a0601/m10a0701.ssb -> EnterDungeon(15)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d10p21a = {}

function d10p21a.Init(map) end

function d10p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d10p21a')
end

function d10p21a.Update(map) end
function d10p21a.GameSave(map) end
function d10p21a.GameLoad(map) GAME:FadeIn(20) end

function d10p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d10p21a
