--[[ d26p21a — aire de repos Sky (checkpoint brine_cave -> lower_brine_cave).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 35 LABEL_D035_CLEAR ; m23a0402.ssb -> EnterDungeon(36)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d26p21a = {}

function d26p21a.Init(map) end

function d26p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d26p21a')
end

function d26p21a.Update(map) end
function d26p21a.GameSave(map) end
function d26p21a.GameLoad(map) GAME:FadeIn(20) end

function d26p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d26p21a
