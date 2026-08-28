--[[ d48p21a — aire de repos Sky (checkpoint temporal_tower_se5 -> temporal_spire_se5).
     Statue Kangourex = sauvegarde native ; la suite du donjon est reprise
     via SkyRestAreas (main_EnterDungeon ROM : GETOUT case 137 ; n08a1808.ssb -> EnterDungeon(138)).
     Généré par dev/tools/wire_sky_rest_areas.py. ]]
require 'origin.common'
require 'halcyon.SkyRestAreas'

local d48p21a = {}

function d48p21a.Init(map) end

function d48p21a.Enter(map)
  SkyRestAreas.OnRestAreaEnter('d48p21a')
end

function d48p21a.Update(map) end
function d48p21a.GameSave(map) end
function d48p21a.GameLoad(map) GAME:FadeIn(20) end

function d48p21a.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

return d48p21a
