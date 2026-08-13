-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local cour_ancienne = {}
function cour_ancienne.Init(map) DEBUG.EnableDbgCoro() end
function cour_ancienne.Enter(map) GAME:FadeIn(20) end
function cour_ancienne.Update(map) end
function cour_ancienne.North_Exit_Touch(obj, activator)
  GAME:FadeOut(false, 30)
  GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker')
end
return cour_ancienne
